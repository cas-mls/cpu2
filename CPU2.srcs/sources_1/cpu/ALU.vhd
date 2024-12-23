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
    begin
        if rising_edge (SYS_CLK) then
            case fsm_inst_cycle_p is
                when RESET_STATE_S =>
                    cpuRegs <= (others => (others => '0'));
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
                            case ffmemop is
                                when REGREG =>
                                    cpuRegs(ffiregop1) <= std_logic_vector(to_unsigned(
                                                          to_integer(unsigned(ireg1value)) + 1, 32));
                                when others =>
                            end case;

                        when oRTI =>
                            case ffmemop is
                                when REGREG =>
                                    cpuRegs(interruptSpNum) <= std_logic_vector(to_unsigned(
                                                               interruptSpAddrValue + 2, 32));
                                when others =>
                            end case;

                        when oADD =>
                            case ffmemop is
                                when REGREG =>
                                    if ffflag = '0' then
                                        cpuRegs(ffiregop1) <=
                                                         std_logic_vector(to_signed(
                                                         to_integer(signed(ireg1value)) +
                                                         to_integer(signed(ireg2value)), 32));
                                    else
                                        cpuRegs(ffiregop1) <=
                                                         std_logic_vector(to_unsigned(
                                                         to_integer(unsigned(ireg1value)) +
                                                         to_integer(unsigned(ireg2value)), 32));
                                    end if;
                                when IMMEDIATE =>
                                    if ffflag = '0' then
                                        if ffiregop2 = 0 then
                                            cpuRegs(ffiregop1) <=
                                                                std_logic_vector(to_signed(to_integer(signed(ireg1value)) +
                                                                to_integer(signed(ffimmop))
                                                                , 32));
                                        else
                                            cpuRegs(ffiregop1) <=
                                                                std_logic_vector(to_unsigned(
                                                                to_integer(unsigned(ireg1value)) +
                                                                to_integer(unsigned(ireg2value)) +
                                                                to_integer(unsigned(ffimmop))
                                                                , 32));
                                        end if;
                                    else
                                        if ffiregop2 = 0 then
                                            cpuRegs(ffiregop1) <=
                                                                std_logic_vector(to_unsigned(to_integer(unsigned(ireg1value)) +
                                                                to_integer(unsigned(ffimmop))
                                                                , 32));
                                        else
                                            cpuRegs(ffiregop1) <=
                                                                std_logic_vector(to_unsigned(
                                                                to_integer(unsigned(ireg1value)) +
                                                                to_integer(unsigned(ireg2value)) +
                                                                to_integer(unsigned(ffimmop))
                                                                , 32));
                                        end if;
                                    end if;
                                when ABSOLUTE | INDEX =>
                                    if ffflag = '0' then
                                        cpuRegs(ffiregop1) <=
                                                         std_logic_vector(to_signed(
                                                         to_integer(signed(ireg1value)) +
                                                         to_integer(signed(MEM_ARG)), 32));
                                    else
                                        cpuRegs(ffiregop1) <=
                                                         std_logic_vector(to_unsigned(
                                                         to_integer(unsigned(ireg1value)) +
                                                         to_integer(unsigned(MEM_ARG)), 32));
                                    end if;
                                when others =>
                            end case;

                        when oSUB =>
                            case ffmemop is
                                when REGREG =>
                                    if ffflag = '0' then
                                        cpuRegs(ffiregop1) <=
                                                         std_logic_vector(to_signed(
                                                         to_integer(signed(ireg1value)) -
                                                         to_integer(signed(ireg2value)), 32));
                                    else
                                        cpuRegs(ffiregop1) <=
                                                         std_logic_vector(to_unsigned(
                                                         to_integer(unsigned(ireg1value)) -
                                                         to_integer(unsigned(ireg2value)), 32));
                                    end if;
                                when IMMEDIATE =>
                                    if ffflag = '0' then
                                        if ffiregop2 = 0 then
                                            cpuRegs(ffiregop1) <=
                                                                std_logic_vector(to_signed(
                                                                to_integer(signed(ireg1value)) -
                                                                to_integer(signed(ffimmop))
                                                                , 32));
                                        else
                                            cpuRegs(ffiregop1) <=
                                                                std_logic_vector(to_signed(
                                                                to_integer(signed(ireg1value)) -
                                                                to_integer(signed(ireg2value)) -
                                                                to_integer(signed(ffimmop))
                                                                , 32));
                                        end if;
                                    else
                                        if ffiregop2 = 0 then
                                            cpuRegs(ffiregop1) <=
                                                                std_logic_vector(to_unsigned(
                                                                to_integer(unsigned(ireg1value)) -
                                                                to_integer(unsigned(ffimmop))
                                                                , 32));
                                        else
                                            cpuRegs(ffiregop1) <=
                                                                std_logic_vector(to_unsigned(
                                                                to_integer(unsigned(ireg1value)) -
                                                                to_integer(unsigned(ireg2value)) -
                                                                to_integer(unsigned(ffimmop))
                                                                , 32));
                                        end if;
                                    end if;
                                when ABSOLUTE | INDEX =>
                                    if ffflag = '0' then
                                        cpuRegs(ffiregop1) <=
                                                         std_logic_vector(to_signed(
                                                         to_integer(signed(ireg1value)) -
                                                         to_integer(signed(MEM_ARG)), 32));
                                    else
                                        cpuRegs(ffiregop1) <=
                                                         std_logic_vector(to_unsigned(
                                                         to_integer(unsigned(ireg1value)) -
                                                         to_integer(unsigned(MEM_ARG)), 32));
                                    end if;
                                when others =>
                            end case;

                        when oAND =>
                            case ffmemop is
                                when REGREG =>
                                    if ffflag = '0' then
                                        cpuRegs(ffiregop1) <= ireg1value and ireg2value;
                                    else
                                        cpuRegs(ffiregop1) <= (ireg1value nand ireg2value);
                                    end if;
                                when IMMEDIATE =>
                                    if ffflag = '0' and ffiregop2 = 0 then
                                        cpuRegs(ffiregop1) <= ireg1value and (X"1111" & ffimmop);
                                    elsif ffflag = '1' and ffiregop2 = 0 then
                                        cpuRegs(ffiregop1) <= ireg1value nand (X"1111" & ffimmop);
                                    elsif ffflag = '0' and ffiregop2 = 0 then
                                        cpuRegs(ffiregop1) <= ireg1value and ireg2value and (X"1111" & ffimmop);
                                    else
                                        cpuRegs(ffiregop1) <= ireg1value nand (ireg2value nand (X"1111" & ffimmop));
                                    end if;
                                when ABSOLUTE | INDEX =>
                                    if ffflag = '0' then
                                        cpuRegs(ffiregop1) <= ireg1value and MEM_ARG;
                                    else
                                        cpuRegs(ffiregop1) <= ireg1value nand MEM_ARG;
                                    end if;
                                when others =>
                            end case;

                        when oOR =>
                            case ffmemop is
                                when REGREG =>
                                    if ffflag = '0' then
                                        cpuRegs(ffiregop1) <= ireg1value or ireg2value;
                                    else
                                        cpuRegs(ffiregop1) <= (ireg1value nor ireg2value);
                                    end if;
                                when IMMEDIATE =>
                                    if ffflag = '0' and ffiregop2 = 0 then
                                        cpuRegs(ffiregop1) <= ireg1value or (X"0000" & ffimmop);
                                    elsif ffflag = '1' and ffiregop2 = 0 then
                                        cpuRegs(ffiregop1) <= ireg1value nor (X"0000" & ffimmop);
                                    elsif ffflag = '0' and ffiregop2 = 0 then
                                        cpuRegs(ffiregop1) <= ireg1value or ireg2value or (X"1111" & ffimmop);
                                    else
                                        cpuRegs(ffiregop1) <= ireg1value nor (ireg2value nor (X"1111" & ffimmop));
                                    end if;
                                when ABSOLUTE | INDEX =>
                                    if ffflag = '0' then
                                        cpuRegs(ffiregop1) <= ireg1value or MEM_ARG;
                                    else
                                        cpuRegs(ffiregop1) <= ireg1value nor MEM_ARG;
                                    end if;
                                when others =>
                            end case;

                        when oXOR =>
                            case ffmemop is
                                when REGREG =>
                                    if ffflag = '0' then
                                        cpuRegs(ffiregop1) <= ireg1value xor ireg2value;
                                    else
                                        cpuRegs(ffiregop1) <= (ireg1value xnor ireg2value);
                                    end if;
                                when IMMEDIATE =>
                                    if ffflag = '0' and ffiregop2 = 0 then
                                        cpuRegs(ffiregop1) <= ireg1value xor (X"0000" & ffimmop);
                                    elsif ffflag = '1' and ffiregop2 = 0 then
                                        cpuRegs(ffiregop1) <= ireg1value xnor (X"0000" & ffimmop);
                                    elsif ffflag = '0' and ffiregop2 = 0 then
                                        cpuRegs(ffiregop1) <= ireg1value xor ireg2value xor (X"1111" & ffimmop);
                                    else
                                        cpuRegs(ffiregop1) <= ireg1value xnor (ireg2value xnor (X"1111" & ffimmop));
                                    end if;
                                when ABSOLUTE | INDEX =>
                                    if ffflag = '0' then
                                        cpuRegs(ffiregop1) <= ireg1value xor MEM_ARG;
                                    else
                                        cpuRegs(ffiregop1) <= ireg1value xnor MEM_ARG;
                                    end if;
                                when others =>
                            end case;

                        when oSHLR =>
                            case ffmemop is
                                when REGREG =>
                                    if ffflag = '0' then
                                        cpuRegs(ffiregop1) <= std_logic_vector(unsigned(ireg1value)
                                                        sll to_integer(unsigned(ireg2value(4 downto 0))));
                                    else
                                        cpuRegs(ffiregop1) <= std_logic_vector(unsigned(ireg1value)
                                                        srl to_integer(unsigned(ireg2value(4 downto 0))));
                                    end if;
                                when IMMEDIATE =>
                                    if ffflag = '0' then
                                        cpuRegs(ffiregop1) <= std_logic_vector(unsigned(ireg1value)
                                                        sll to_integer(unsigned(ffimmop(4 downto 0))));
                                    else
                                        cpuRegs(ffiregop1) <= std_logic_vector(unsigned(ireg1value)
                                                        srl to_integer(unsigned(ffimmop(4 downto 0))));
                                    end if;
                                when ABSOLUTE | INDEX =>
                                    if ffflag = '0' then
                                        cpuRegs(ffiregop1) <= std_logic_vector(unsigned(ireg1value)
                                                            sll to_integer(unsigned(MEM_ARG(4 downto 0))));
                                    else
                                        cpuRegs(ffiregop1) <= std_logic_vector(unsigned(ireg1value)
                                                            srl to_integer(unsigned(MEM_ARG(4 downto 0))));
                                      end if;
                                when others =>
                            end case;

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