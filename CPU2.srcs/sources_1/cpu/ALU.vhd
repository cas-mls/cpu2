----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/03/2023 09:47:49 PM
-- Design Name: 
-- Module Name: Registers - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
library xil_defaultlib;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_1164.all;
-- use ieee.std_logic_unsigned.all;

use xil_defaultlib.Utilities.all;

---------------------------------------------------------------------------
-- ### Arithmetic Logic Unit (ALU)

-- This handles the updating and operating on the register and is also known as the Arithmetic Logic Unit (ALU).

-- #### Instructions

--  * oLD - Move Register contents, load memory to register
--  * oRTN - Return from JSR (Return from Subroutine)
--  * oRTI - Return from InterruptoRTN
--  * oADD - Add registers, immediate, or memory 
--  * oSUB - Subtract registers, immediate, or memory 
--  * oAND - And or Nand registers, immediate, or memory
--  * oOR - Or or Nor registers, immediate, or memory
--  * oXOR - Xor or Xnor registers, immediate, or memory
--  * oSHL - Shift left registers, immediate, or memory
--  * oSHR - Shift right registers, immediate, or memory
--  * oJSR - Jump and store PC (Jump to Subroutine)
--  * oRWIO - Load and write to IO.
--  * oPUSHPOP - Push or Pop from memory

-- #### Wire Assignments (outputs)
-- | Signal            | Description                                                  |
-- | ----------------- | ------------------------------------------------------------ |
-- | cpuRegs         | The fast CPU registers.

-- #### Used Wires (Inputs)
-- | Signal            | Description                                                  |
-- | ----------------- | ------------------------------------------------------------ |
-- |INSTRUCTION     | Instruction operation
-- |MEM_ARG         | The current memory argument from decode.
-- |fsm_inst_cycle_p | Process States:
-- | |       RESET_STATE_S           - Reset the CPU.
-- | |       EXECUTE_S               - Execute the instruction.  To process interrupts, store registers/data.
-- |  |      CLEANUP_S               - Clean up data after execute.
-- |fsm_interrupt_cycle_p | Process States:
-- |  |      SAVEENA_S (State 2)     - Saves the Interrupt Enable Mask.
-- |  |      JMPADDR_S (State 4)     - Get the Interrupt Handler from address vector.
-- |interruptSPNum
-- |IOR_DATA           | Data from the peripheral device.
-- |IO_STATUS          | The IO status from the peripheral device.
-- |ireg1value         | Value of the Register pointed to by instruction.
-- |ffiregop2          | Instruction identified second register.
-- |ireg2value         | Value of the Register pointed to by instruction.
-- |interruptSpAddrValue    

-- #### Internal Wires:
-- | Signal            | Description                                                  |
-- | ----------------- | ------------------------------------------------------------ |
-- | ffopcode          | Instruction operation
-- | ffflag            | Multiple use flag (e.g., negative logic)
-- | ffmemop           | Memory access operation.
-- | ffiregop1         | Instruction identified first register.
-- | ffiregop2         | Instruction identified second register.
-- | ffimmop           | Immediate value from the instruction.
---------------------------------------------------------------------------

entity ALU is
    port (
        SYS_CLK : in std_logic;
        INSTRUCTION : in std_logic_vector(31 downto 0);
        MEM_ARG : in std_logic_vector(31 downto 0);
        fsm_inst_cycle_p : in CYCLETYPE_FSM;
        fsm_interrupt_cycle_p : in INTERRUPT_FSM;
        interruptSPNum : in integer range 0 to 31;
        IOR_DATA : in std_logic_vector(31 downto 0);
        IO_STATUS : in std_logic_vector(31 downto 0);
        ireg1value : in std_logic_vector(31 downto 0);
        ireg2value : in std_logic_vector(31 downto 0);
        interruptSpAddrValue : in integer range 0 to 2 ** 12 - 1;
        statusWord : out STATUS_WORD_TYPE := (others => '0');
        cpuRegs : out REG_TYPE
    );

end ALU;

architecture Behavioral of ALU is

    -- Decode information    
    signal ffopcode : OPCODETYPE := "00000";
    signal ffflag : std_logic := '0';
    signal ffmemop : MEMTYPE;
    signal ffiregop1 : integer;
    signal ffiregop2 : integer;
    signal ffimmop : IMMTYPE;

begin

    alu_proc : process (SYS_CLK)
        variable a_reg_s        : signed(31 downto 0);
        variable b_reg_s        : signed(31 downto 0);
        variable results_reg_s  : signed(31 downto 0);
        variable results_mult_s : signed(63 downto 0);
        variable a_reg_u        : unsigned(32 downto 0);
        variable b_reg_u        : unsigned(32 downto 0);
        variable results_reg_u  : unsigned(32 downto 0);
        variable results_mult_u : unsigned(63 downto 0);
        variable results_ov     : integer;
    begin
        if rising_edge (SYS_CLK) then
            case fsm_inst_cycle_p is
                when RESET_STATE_S =>
                    cpuRegs <= (others => (others => '0'));
                    statusWord <= (others => '0');
                when DECODE_S =>

                    -- Maintain Flip-Flop (Memory) protions of the instruction.
                    -- This removes the timing violations and make the processor faster.
                    -- Might remove the combinatorial logic which should not be used after this cycle.
                    ffopcode <= INSTRUCTION(31 downto 27);
                    ffflag <= INSTRUCTION(26);
                    ffmemop <= INSTRUCTION(25 downto 24);
                    ffiregop1 <= to_integer(unsigned(INSTRUCTION(23 downto 20)));
                    ffiregop2 <= to_integer(unsigned(INSTRUCTION(19 downto 16)));
                    ffimmop <= INSTRUCTION(15 downto 0);
                    -- Save the values of the Register Data.  Again this ifor timing operations.

                when EXECUTE_S =>
                    case ffmemop is
                        when REGREG =>
                            a_reg_u := resize(unsigned(ireg1value),33);
                            b_reg_u := resize(unsigned(ireg2value),33);

                        when IMMEDIATE =>
                            if ffiregop2 = 0 then
                                a_reg_u := resize(unsigned(ireg1value),33);
                                b_reg_u := resize(unsigned(ffimmop),33);
                            else
                                a_reg_u := resize(unsigned(ireg2value),33);
                                b_reg_u := resize(unsigned(ffimmop),33);
                            end if;

                        when ABSOLUTE | INDEX =>
                            a_reg_u := resize(unsigned(ireg1value),33);
                            b_reg_u := resize(unsigned(MEM_ARG),33);

                        when others =>

                    end case;

                    case ffopcode is
                        when oLD =>
                            case ffmemop is
                                when REGREG =>
                                    cpuRegs(ffiregop1) <= ireg2value;
                                when IMMEDIATE =>
                                    if ffflag = '1' then
                                        cpuRegs(ffiregop1)(31 downto 16) <= ffimmop;
                                    else
                                        cpuRegs(ffiregop1)(15 downto 0) <= ffimmop;
                                    end if;
                                when ABSOLUTE | INDEX =>
                                    cpuRegs(ffiregop1) <= MEM_ARG;
                                when others =>
                            end case;

                        when oRTN =>
                            if ffmemop = REGREG then
                                cpuRegs(ffiregop1) <= std_logic_vector(to_unsigned(
                                                        to_integer(unsigned(ireg1value)) + 1, 32));
                            end if;

                        when oRTI =>
                            if ffmemop = REGREG then
                                cpuRegs(interruptSpNum) <= std_logic_vector(to_unsigned(
                                                               interruptSpAddrValue + 2, 32));
                            end if;

                        when oADD | oSUB | oMul | oDiv =>
                            if ffflag = '0' then
                                case ffmemop is
                                    when REGREG =>
                                        a_reg_s := signed(ireg1value);
                                        b_reg_s := signed(ireg2value);
                                    when IMMEDIATE =>
                                            if ffiregop2 = 0 then
                                                a_reg_s := signed(ireg1value);
                                                b_reg_s := resize(signed(ffimmop),32);
                                            else
                                                a_reg_s := signed(ireg2value);
                                                b_reg_s := resize(signed(ffimmop),32);
                                            end if;
                                    when ABSOLUTE | INDEX =>
                                        if ffflag = '0' then
                                            a_reg_s := signed(ireg1value);
                                            b_reg_s := signed(MEM_ARG);
                                        end if;
                                    when others =>
                                end case;
                            end if;

                            if ffopcode = oAdd then
                                if ffflag = '0' then
                                    results_reg_s := a_reg_s + b_reg_s;
                                    cpuRegs(ffiregop1) <= std_logic_vector(results_reg_s);
                                    statusWord(OverUnderflow) <=  (a_reg_s(31) xnor b_reg_s(31)) and (a_reg_s(31) xor results_reg_s(31));
                                else
                                    results_reg_u := a_reg_u + b_reg_u;
                                    cpuRegs(ffiregop1) <= std_logic_vector(resize(results_reg_u,32));
                                    statusWord(OverUnderflow) <= results_reg_u(32);
                                end if;
                            elsif ffopcode = oSub then
                                if ffflag = '0' then
                                    results_reg_s := a_reg_s - b_reg_s;
                                    cpuRegs(ffiregop1) <= std_logic_vector(results_reg_s);
                                    statusWord(OverUnderflow) <= 
                                            '1' when a_reg_s < 0 and  b_reg_s > 0 and results_reg_s < a_reg_s
                                                else '0';
                                else
                                    results_reg_u := a_reg_u - b_reg_u;
                                    cpuRegs(ffiregop1) <= std_logic_vector(resize(results_reg_u,32));
                                    statusWord(OverUnderflow) <=  
                                            '1' when b_reg_u > a_reg_u
                                                else '0';
                                end if;
                            elsif ffopcode = oMul then
                                -- if ffflag = '0' then
                                --     results_mult_s := a_reg_s * b_reg_s;
                                --     results_ov := to_integer(results_mult_s(63 downto 32));
                                --     cpuRegs(ffiregop1) <= std_logic_vector(resize(results_mult_s,32));
                                --     statusWord(OverUnderflow) <= 
                                --             '0' when results_mult_s(63 downto 0) = 0 
                                --                     or results_mult_s(63 downto 0) = -1 
                                --                 else '1';
                                -- else
                                --     results_mult_u := a_reg_u(31 downto 0) * b_reg_u(31 downto 0);
                                --     cpuRegs(ffiregop1) <= std_logic_vector(resize(results_mult_u,32));
                                --     results_ov := to_integer(results_mult_s(63 downto 32));
                                --     statusWord(OverUnderflow) <= 
                                --             '0' when results_mult_u(63 downto 32) = 0
                                --                 else '1';
                                -- end if;

                            elsif ffopcode = oDiv then
                                -- if ffflag = '0' then
                                --     if b_reg_s = 0 then
                                --         statusWord(DivideByZero) <= '1';
                                --     else
                                --         results_reg_s := a_reg_s / b_reg_s;
                                --         cpuRegs(ffiregop1) <= std_logic_vector(resize(results_reg_s,32));
                                --         statusWord(DivideByZero) <= '0';
                                --     end if;
                                -- else
                                --     if b_reg_u = 0 then
                                --         statusWord(DivideByZero) <= '1';
                                --     else
                                --         results_reg_u := a_reg_u / b_reg_u;
                                --         cpuRegs(ffiregop1) <= std_logic_vector(resize(results_reg_u,32));
                                --         statusWord(DivideByZero) <= '0';
                                --     end if;
                                -- end if;
                            end if;

                        when oAND =>
                            if ffflag = '0' then
                                cpuRegs(ffiregop1) <= std_logic_vector(resize(a_reg_u and b_reg_u,32));
                            else
                                cpuRegs(ffiregop1) <= std_logic_vector(resize(a_reg_u nand b_reg_u,32));
                            end if;

                        when oOR =>
                            if ffflag = '0' then
                                cpuRegs(ffiregop1) <= std_logic_vector(resize(a_reg_u or b_reg_u,32));
                            else
                                cpuRegs(ffiregop1) <= std_logic_vector(resize(a_reg_u nor b_reg_u,32));
                            end if;

                        when oXOR =>
                            if ffflag = '0' then
                                cpuRegs(ffiregop1) <= std_logic_vector(resize(a_reg_u xor b_reg_u,32));
                            else
                                cpuRegs(ffiregop1) <= std_logic_vector(resize(a_reg_u xnor b_reg_u,32));
                            end if;

                        when oSHLR =>
                            if ffflag = '0' then
                                cpuRegs(ffiregop1) <= std_logic_vector(resize(a_reg_u sll to_integer(b_reg_u),32));
                            else
                                cpuRegs(ffiregop1) <= std_logic_vector(resize(a_reg_u srl to_integer(b_reg_u),32));
                            end if;

                        when oJSR =>
                            case ffmemop is
                                when REGREG =>
                                    cpuRegs(ffiregop1) <= std_logic_vector(to_unsigned(
                                                          to_integer(unsigned(ireg1value)) - 1, 32));
                                when IMMEDIATE =>
                                    cpuRegs(ffiregop1) <= std_logic_vector(to_unsigned(
                                                          to_integer(unsigned(ireg1value)) - 1, 32));
                                when others =>
                            end case;

                        when oRWIO =>
                            case ffmemop is
                                when REGREG =>
                                    if ffflag = '0' then
                                        cpuRegs(ffiregop1) <= IOR_DATA;
                                    end if;
                                when IMMEDIATE =>
                                    if ffflag = '0' then
                                        cpuRegs(ffiregop1) <= IOR_DATA;
                                    end if;
                                when others =>
                            end case;

                        when  oIOST =>
                            if ffmemop = REGREG then
                                cpuRegs(ffiregop1) <= IO_STATUS;
                            elsif ffmemop = IMMEDIATE then
                                cpuRegs(ffiregop1) <= IO_STATUS;
                            end if;

                        when oPUSHPOP =>
                            case ffmemop is
                                when REGREG =>
                                    if ffflag = '0' then -- Push
                                        cpuRegs(ffiregop1) <= std_logic_vector(to_unsigned(
                                                              to_integer(unsigned(ireg1value)) - 1, 32));
                                    else -- Pop
                                        cpuRegs(ffiregop1) <= std_logic_vector(to_unsigned(
                                                              to_integer(unsigned(ireg1value)) + 1, 32));
                                        cpuRegs(ffiregop2) <= MEM_ARG;
                                    end if;
                                when IMMEDIATE =>
                                    if ffflag = '0' then
                                        cpuRegs(ffiregop1) <= std_logic_vector(to_unsigned(
                                                              to_integer(unsigned(ireg1value)) - 1, 32));
                                    end if;
                                when others =>
                            end case;
                        
                        when  oSWDM =>
                            if  ffflag = SWDFLAG 
                                and ffmemop = REGREG
                            then
                                cpuRegs(ffiregop1) <= statusWord;
                                statusWord <= (others => '0');
                            end if;
    
                        when others =>
                    end case;

                when others =>
            end case;

            case fsm_interrupt_cycle_p is
                when JUMP_S =>
                    cpuRegs(interruptSpNum) <= std_logic_vector(to_unsigned(interruptSpAddrValue - 2, 32));
                when others =>
            end case;
        end if;
    end process alu_proc;

end Behavioral;