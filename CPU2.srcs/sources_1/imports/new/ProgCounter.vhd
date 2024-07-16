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
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

use xil_defaultlib.Utilities.ALL;

---------------------------------------------------------------------------
--  Process (Clocked) : procCounter_proc
--  Description:    This handles the program counter (PC) and memory access for obtaining the instruction.  
--                  This used the Port A memory access.
--  Wire Assignments
--      MEM_ADDRA       - The address to Read or Write memory.
--      MEM_ENA         - Enable at Address and disable during the Decode for branches.
--      MEM_WEA         - Always 0 (Read Only)
--      Note:   Actually setting MEM_DOUTA (writting memory) is not part of this process.
--              During the Decode state the MEM_DOUTA is seperated into opcode, flag, memop, regop1, regop2, and immop combinational wires.
--              The iregop1 and iregop2 are integers of rht regop1 and reop2 also are combinational wires.
--  Used Clocked Wires:
--      ffopcode        - Instruction operation
--      ffmemop         - Reg/Reg, Immediate, Absolute, and Index
--      ffiregop2
--      ffimmop
--      interruptSP
--      fsm_inst_cycle_p
--          Process States:
--              RESET_STATE_S   - Reset the CPU.
--              ADDRESS_S       - Setting the address from the program counter.  This sets the clears the memory enable.
--              DECODE_S        - Instruction Decode and identify operands.  Sets up the Memory addresses and write data.
--              EXECUTE_S       - Execute the instruction.  To process interrupts, store registers/data.
--      fsm_interrupt_cycle_p
--          Process States:
--              JUMP_S          -
--  Used Combinational Wires:
--      opcode          Instruction operation
---------------------------------------------------------------------------

entity ProgCounter is
    Port ( 
        SYS_CLK               : IN STD_LOGIC;
        INSTRUCTION           : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        cpuRegs               : IN reg_type;

        fsm_inst_cycle_p      : IN CYCLETYPE_FSM;
        fsm_interrupt_cycle_p : IN INTERRUPT_FSM;
        MEM_ARG               : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    
        MEM_ENA               : OUT STD_LOGIC := '1';
        MEM_WEA               : OUT STD_LOGIC_VECTOR(0 DOWNTO 0) := "0";
        MEM_ADDRA             : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
        ProgramCounter        : OUT unsigned(11 downto 0)
    );
end ProgCounter;

architecture Behavioral of ProgCounter is

    -- Decode information    
    signal opcode : OPCODETYPE := "00000";
    signal ffopcode : OPCODETYPE := "00000";
    signal ffflag : STD_LOGIC :='0';
    signal ffmemop : MEMTYPE;
    signal ffiregop1 : integer range 0 to regOpMax;
    signal ireg1value : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
    signal ffiregop2 : integer range 0 to regOpMax;
    signal ireg2value : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
    signal ffimmop: IMMTYPE;

    signal ProgCounterLocal : unsigned(11 downto 0);

    attribute keep : string;
    attribute MARK_DEBUG : string;
    attribute keep of ProgCounterLocal : signal is "TRUE";
    attribute MARK_DEBUG of ProgCounterLocal : signal is "TRUE";


begin

    opcode <= INSTRUCTION(31 downto 27);
  
    procCounter_proc : process (SYS_CLK)
    begin
        if rising_edge  (SYS_CLK) then
            case fsm_inst_cycle_p is
                when RESET_STATE_S=>
                    MEM_ENA <= '1';
                    MEM_WEA <= "0";
                    MEM_ADDRA <= X"000";
                    ProgCounterLocal <= X"000";

                when ADDRESS_S    =>
                    MEM_ENA <= '1';
                    MEM_ADDRA <= STD_LOGIC_VECTOR(unsigned(ProgCounterLocal));
                when DECODE_S     =>

                    -- Maintain Flip-Flop (Memory) protions of the instruction.
                    -- This removes the timing violations and make the processor faster.
                    -- Might remove the combinatorial logic which should not be used after this cycle.
                    ffopcode    <= INSTRUCTION(31 downto 27);
                    ffflag      <= INSTRUCTION(26);
                    ffmemop     <= INSTRUCTION(25 downto 24);
                    ffiregop1   <= to_integer(unsigned(INSTRUCTION(23 downto 20)));
                    ffiregop2   <= to_integer(unsigned(INSTRUCTION(19 downto 16)));
                    ffimmop     <= INSTRUCTION(15 downto 0);
                    -- Save the values of the Register Data.  Again this ifor timing operations.
                    ireg1value <= cpuRegs(to_integer(unsigned(INSTRUCTION(23 downto 20))));
                    ireg2value <= cpuRegs(to_integer(unsigned(INSTRUCTION(19 downto 16))));

                    if      opcode /= oJMP 
                        and opcode /= oBE 
                        and opcode /= oBLT 
                        and opcode /= oBGT 
                        and opcode /= oJSR 
                        and opcode /= oRTN 
                        and opcode /= oRTI 
                        and opcode /= oSWI
                    then -- ignore all Jump operations.
                        MEM_ENA <= '1';
                        MEM_ADDRA <= STD_LOGIC_VECTOR(unsigned(ProgCounterLocal+1));
                    else
                        MEM_ENA <= '0';
                    end if;

                when EXECUTE_S    =>
                    case ffmemop is
                        when REGREG     =>
                            case ffopcode is
                                when oJMP | oJSR =>
                                    ProgCounterLocal <= unsigned(ireg2value(11 downto 0)); 
                                when oRTN | oRTI =>
                                    ProgCounterLocal <= unsigned(MEM_ARG(11 downto 0));
                                when others =>
                                    ProgCounterLocal <= ProgCounterLocal + 1;
                            end case;
                        when IMMEDIATE  =>
                            case ffopcode is
                                when oJMP | oJSR =>
                                    ProgCounterLocal <= unsigned(ffimmop(11 downto 0));
                                when oRTN | oRTI =>
                                    ProgCounterLocal <= unsigned(MEM_ARG(11 downto 0));
                                when oBE =>
                                    if  ffiregop2 /= 0 
                                        and  ((ffflag = '0' and ireg1value = ireg2value)
                                        or (ffflag = '1' and ireg1value /= ireg2value)) then
                                            ProgCounterLocal <= unsigned(ffimmop(11 downto 0));
                                    elsif ffiregop2 = 0 
                                        and  ((ffflag = '0' and signed(ireg1value) = 0)
                                        or (ffflag = '1' and signed(ireg1value) /= 0)) then
                                            ProgCounterLocal <= unsigned(ffimmop(11 downto 0));
                                    else
                                        ProgCounterLocal <= ProgCounterLocal + 1;
                                    end if;
                                when oBLT =>
                                    if ffiregop2 /= 0 
                                        and ((ffflag = '0' and ireg1value < ireg2value) 
                                            or (ffflag = '1' and ireg1value >= ireg2value)) 
                                            then
                                            ProgCounterLocal <= unsigned(ffimmop(11 downto 0));
                                    elsif ffiregop2 = 0 
                                        and ((ffflag = '0' and signed(ireg1value) < 0) 
                                            or (ffflag = '1' and signed(ireg1value) >= 0))
                                            then
                                            ProgCounterLocal <= unsigned(ffimmop(11 downto 0));
                                    else
                                        ProgCounterLocal <= ProgCounterLocal + 1;
                                    end if;
                                when oBGT =>
                                    if ffiregop2 /= 0 
                                        and  ((ffflag = '0' and ireg1value > ireg2value) 
                                        or (ffflag = '1' and ireg1value <= ireg2value)) then
                                            ProgCounterLocal <= unsigned(ffimmop(11 downto 0));
                                    elsif ffiregop2 = 0 
                                        and  ((ffflag = '0' and signed(ireg1value) > 0) 
                                        or (ffflag = '1' and signed(ireg1value) <= 0)) then
                                            ProgCounterLocal <= unsigned(ffimmop(11 downto 0));
                                    else
                                        ProgCounterLocal <= ProgCounterLocal + 1;
                                    end if;
                                when others =>
                                    ProgCounterLocal <= ProgCounterLocal + 1;
                            end case;
                        when ABSOLUTE | INDEX =>
                        case ffopcode is
                            when oJMP | oJSR =>
                                ProgCounterLocal <= unsigned(MEM_ARG(11 downto 0));
                            when oRTN | oRTI =>
                                ProgCounterLocal <= unsigned(MEM_ARG(11 downto 0));
                            when oBE =>
                                if  ffiregop2 /= 0 
                                    and  ((ffflag = '0' and ireg1value = ireg2value)
                                    or (ffflag = '1' and ireg1value /= ireg2value)) then
                                        ProgCounterLocal <= unsigned(MEM_ARG(11 downto 0));
                                elsif ffiregop2 = 0 
                                    and  ((ffflag = '0' and signed(ireg1value) = 0)
                                    or (ffflag = '1' and signed(ireg1value) /= 0)) then
                                        ProgCounterLocal <= unsigned(MEM_ARG(11 downto 0));
                                else
                                    ProgCounterLocal <= ProgCounterLocal + 1;
                                end if;
                            when oBLT =>
                                if ffiregop2 /= 0 
                                    and ((ffflag = '0' and ireg1value < ireg2value) 
                                        or (ffflag = '1' and ireg1value >= ireg2value)) 
                                        then
                                            ProgCounterLocal <= unsigned(MEM_ARG(11 downto 0));
                                elsif ffiregop2 = 0 
                                    and ((ffflag = '0' and signed(ireg1value) < 0) 
                                        or (ffflag = '1' and signed(ireg1value) >= 0))
                                then
                                    ProgCounterLocal <= unsigned(MEM_ARG(11 downto 0));
                                else
                                    ProgCounterLocal <= ProgCounterLocal + 1;
                                end if;
                            when oBGT =>
                                if ffiregop2 /= 0 
                                    and  ((ffflag = '0' and ireg1value > ireg2value) 
                                    or (ffflag = '1' and ireg1value <= ireg2value)) then
                                        ProgCounterLocal <= unsigned(MEM_ARG(11 downto 0));
                                elsif ffiregop2 = 0 
                                    and  ((ffflag = '0' and signed(ireg1value) > 0) 
                                    or (ffflag = '1' and signed(ireg1value) <= 0)) then
                                        ProgCounterLocal <= unsigned(MEM_ARG(11 downto 0));
                                else
                                    ProgCounterLocal <= ProgCounterLocal + 1;
                                end if;
                            when others =>
                                ProgCounterLocal <= ProgCounterLocal + 1;
                        end case;
                    when others     =>
                    end case;
                when others =>
            end case;

            case fsm_interrupt_cycle_p is
                when JUMP_S       =>
                    ProgCounterLocal <= unsigned(MEM_ARG(11 downto 0));
                when others =>
            end case;

            ProgramCounter <= ProgCounterLocal;

        end if;
    end process procCounter_proc;
end Behavioral;