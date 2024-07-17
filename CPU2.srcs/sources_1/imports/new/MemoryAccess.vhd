----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/29/2023 05:57:00 PM
-- Design Name: 
-- Module Name: Memory - Behavioral
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
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

use xil_defaultlib.Utilities.all;

---------------------------------------------------------------------------
--  Process (Clocked) : memoryAccess_proc
--  Description:    This handles the memory access for the operand, stack, and etc. memory.  
--                  This used the Port B memory access.
--  Wire Assignments
--      ffopcode        - Instruction operation
--      ffmemop         - Reg/Reg, Immediate, Absolute, and Index
--      ffiregop1       -
--      ffiregop2       -
--      ffimmop         -
--      ireg1value      - The current value read from the first instruction register.
--      ireg2value      - The current value read from the second instruction register.
--      MEM_ADDRB       - The address to Read or Write memory.
--      MEM_DINB        - The data 
--      MEM_ENB         - 
--      MEM_WEB         - 
--      Note:   Actually setting MEM_DOUTB (writting memory) is not part of this process.
--              But setting the address to write memory is being set.
--              This does not used 3-state addresses, could make use of it in the future.
--  Used Clocked Wires:
--      interruptSP
--      ProgCounter
--      interruptNum
--      fsm_inst_cycle_p
--          Process States:
--              RESET_STATE_S   - Reset the CPU.
--              ADDRESS_S       - Setting the address from the program counter.  This sets the clears the memory enable.
--              DECODE_S        - Instruction Decode and identify operands.  Sets up the Memory addresses and write data.
--              MEMFETCH1_S     - Waits to read (MEM_DOUTB) because of the memory legacy and latches. This use to pop interrupt PC and mask.
--              MEMFETCH2_S     - Waits to read (MEM_DOUTB) because of the memory legacy and latches.
--              EXECUTE_S       - Execute the instruction.  To process interrupts, store registers/data.
--              CLEANUP_S       - Clean up data after execute.
--      fsm_interrupt_cycle_p
--          Process States:
--              SAVEENA_S       -
--              DISABLEINT_S    - 
--              JMPADDR_S       -
--              JMPFETCH2_S     -
--  Used Combinational Wires:
--      opcode          Instruction operation
--      memop           Reg/Reg, Immediate, Absolute, and Index
--      flag            - 
--      iregop1         - 
--      iregop2         - 
--      immop           - 
---------------------------------------------------------------------------

entity MemoryAccess is
    port (
        SYS_CLK : in std_logic;
        INSTRUCTION : in std_logic_vector(31 downto 0);
        cpuRegs : in reg_type;

        fsm_inst_cycle_p : in CYCLETYPE_FSM;
        fsm_interrupt_cycle_p : in INTERRUPT_FSM;
        interruptSPNum : in integer range 0 to 31;
        IOR_DATA : in std_logic_vector(31 downto 0);
        IO_STATUS : in std_logic_vector(7 downto 0);
        interruptSpAddrValue : in integer range 0 to 2 ** 12 - 1;
        interruptRun : in std_logic;
        interruptNum : in integer range 0 to interruptNums := 0;
        ProgramCounter : in unsigned(11 downto 0);
        interruptMask : in std_logic_vector(interruptNums downto 0);

        MEM_ENB : out std_logic := '1';
        MEM_WEB : out std_logic_vector(0 downto 0) := "0";
        MEM_ADDRB : out std_logic_vector(11 downto 0);
        MEM_DINB : out std_logic_vector(31 downto 0)
    );
end MemoryAccess;

architecture Behavioral of MemoryAccess is

    -- Decode information    
    signal opcode : OPCODETYPE := "00000";
    signal ffopcode : OPCODETYPE := "00000";
    signal flag : std_logic := '0';
    signal ffflag : std_logic := '0';
    signal memop : MEMTYPE;
    signal ffmemop : MEMTYPE;
    signal regop1 : REGTYPE;
    signal iregop1 : integer range 0 to regOpMax;
    signal ffiregop1 : integer range 0 to regOpMax;
    signal ireg1value : std_logic_vector(31 downto 0) := X"00000000";
    signal regop2 : REGTYPE;
    signal iregop2 : integer range 0 to regOpMax;
    signal ffiregop2 : integer range 0 to regOpMax;
    signal ireg2value : std_logic_vector(31 downto 0) := X"00000000";
    signal immop : IMMTYPE;
    signal ffimmop : IMMTYPE;

begin

    opcode <= INSTRUCTION(31 downto 27);
    flag <= INSTRUCTION(26);
    memop <= INSTRUCTION(25 downto 24);
    regop1 <= INSTRUCTION(23 downto 20);
    regop2 <= INSTRUCTION(19 downto 16);
    immop <= INSTRUCTION(15 downto 0);
    iregop1 <= to_integer(unsigned(regop1));
    iregop2 <= to_integer(unsigned(regop2));

    memoryAccess_proc : process (SYS_CLK)
    begin
        if rising_edge (SYS_CLK) then
            case fsm_inst_cycle_p is
                when RESET_STATE_S =>
                    MEM_ENB <= '0';
                    MEM_WEB <= "0";
                    MEM_ADDRB <= X"000";
                    MEM_DINB <= X"00000000";
                when ADDRESS_S =>
                    if interruptRun = '0'
                        then
                        MEM_ENB <= '0';
                        MEM_WEB <= "0";
                    end if;
                when DECODE_S =>

                    -- Maintain Flip-Flop (Memory) protions of the instruction.
                    -- This removes the timing violations and make the processor faster.
                    -- Might remove the combinatorial logic which should not be used after this cycle.
                    ffopcode <= opcode;
                    ffmemop <= memop;
                    ffflag <= flag;
                    ffiregop1 <= iregop1;
                    ffiregop2 <= iregop2;
                    ffimmop <= immop;
                    -- Save the values of the Register Data.  Again this ifor timing operations.
                    ireg1value <= cpuRegs(iregop1);
                    ireg2value <= cpuRegs(iregop2);

                    case memop is
                        when REGREG =>
                            case opcode is
                                when oJSR =>
                                    MEM_ENB <= '1';
                                    MEM_WEB <= "1";
                                    MEM_ADDRB <= cpuRegs(iregop1)(11 downto 0);
                                    MEM_DINB <= X"00000" & std_logic_vector(unsigned(ProgramCounter + 1));
                                when oRTN =>
                                    MEM_ENB <= '1';
                                    MEM_WEB <= "0";
                                    MEM_ADDRB <= std_logic_vector(to_unsigned(
                                                 to_integer(unsigned(cpuRegs(iregop1))) + 1, 12));
                                when oPUSHPOP =>
                                    if flag = '0' then -- Push
                                        MEM_ENB <= '1';
                                        MEM_WEB <= "1";
                                        MEM_ADDRB <= cpuRegs(iregop1)(11 downto 0);
                                        MEM_DINB <= cpuRegs(iregop2);
                                    else -- Pop
                                        MEM_ENB <= '1';
                                        MEM_WEB <= "0";
                                        MEM_ADDRB <= std_logic_vector(to_unsigned(
                                                     to_integer(unsigned(cpuRegs(iregop1))) + 1, 12));
                                    end if;
                                when oRTI =>
                                    MEM_ENB <= '1';
                                    MEM_ADDRB <= std_logic_vector(to_unsigned(
                                                 to_integer(unsigned(cpuRegs(interruptSpNum))) + 1, 12));
                                when others =>
                            end case;
                        when IMMEDIATE =>
                            case opcode is
                                when oJSR =>
                                    MEM_ENB <= '1';
                                    MEM_WEB <= "1";
                                    MEM_ADDRB <= cpuRegs(iregop1)(11 downto 0);
                                    MEM_DINB <= X"00000" & std_logic_vector(unsigned(ProgramCounter + 1));
                                when oPUSHPOP =>
                                    if flag = '0' then
                                        MEM_ENB <= '1';
                                        MEM_WEB <= "1";
                                        MEM_ADDRB <= cpuRegs(iregop1)(11 downto 0);
                                        MEM_DINB <= X"0000" & immop;
                                    end if;
                                when others =>
                            end case;
                        when ABSOLUTE =>
                            case opcode is
                                when oLD | oADD | oSUB | oAND | oOr | oXor | oShl | oShr | oJMP | oBE | oBLT | oBGT | oSWI | oIENA =>
                                    MEM_ENB <= '1';
                                    MEM_WEB <= "0";
                                    MEM_ADDRB <= immop(11 downto 0);
                                when others =>
                            end case;

                        when INDEX =>
                            case opcode is
                                when oLD | oADD | oSUB | oAND | oOr | oXor | oShl | oShr | oJMP =>
                                    MEM_ENB <= '1';
                                    MEM_WEB <= "0";
                                    MEM_ADDRB <= std_logic_vector(to_unsigned(to_integer(unsigned(immop(11 downto 0))) +
                                                 to_integer(unsigned(cpuRegs(iregop2))), 12));
                                when others =>
                            end case;
                        when others =>
                    end case;

                when MEMFETCH2_S => -- XXX This only works on SIM hardware.  Comment out next line to work on SIM.
                    --   when MEMFETCH1_S  => -- XXX This only works on Real Hardware Comment out for SIM
                    case ffmemop is
                        when REGREG =>
                            case ffopcode is
                                when oRTI =>
                                    MEM_ENB <= '1';
                                    MEM_WEB <= "0";
                                    MEM_ADDRB <= std_logic_vector(to_unsigned(interruptSpAddrValue + 2, 12));
                                when others =>
                            end case;
                        when others =>
                    end case;

                when EXECUTE_S =>
                    case ffmemop is
                        when ABSOLUTE =>
                            case ffopcode is
                                when oSTR =>
                                    MEM_ENB <= '1';
                                    MEM_WEB <= "1";
                                    MEM_ADDRB <= immop(11 downto 0);
                                    MEM_DINB <= ireg1value;
                                when oRWIO =>
                                    if ffflag = '0' then
                                        MEM_ENB <= '1';
                                        MEM_WEB <= "1";
                                        MEM_ADDRB <= immop(11 downto 0);
                                        MEM_DINB <= IOR_DATA;
                                    end if;
                                when others =>
                            end case;
                        when INDEX =>
                            case ffopcode is
                                when oSTR =>
                                    MEM_ENB <= '1';
                                    MEM_WEB <= "1";
                                    MEM_ADDRB <= std_logic_vector(to_unsigned(to_integer(unsigned(ffimmop(11 downto 0))) +
                                                 to_integer(unsigned(cpuRegs(ffiregop2))), 12));
                                    MEM_DINB <= ireg1value;
                                when oRWIO =>
                                    if ffflag = '0' then
                                        MEM_ENB <= '1';
                                        MEM_WEB <= "1";
                                        MEM_ADDRB <= std_logic_vector(to_unsigned(to_integer(unsigned(ffimmop(11 downto 0))) +
                                                     to_integer(unsigned(cpuRegs(ffiregop2))), 12));
                                        MEM_DINB <= IOR_DATA;
                                    end if;
                                when others =>
                            end case;
                        when others =>
                    end case;
                when others =>
            end case;

            case fsm_interrupt_cycle_p is
                when SAVEENA_S =>
                    MEM_ENB <= '1';
                    MEM_WEB <= "1";
                    MEM_ADDRB <= std_logic_vector(to_unsigned(interruptSpAddrValue, 12));
                    MEM_DINB <= interruptMask;
                when DISABLEINT_S =>
                    MEM_ENB <= '1';
                    MEM_WEB <= "1";
                    MEM_ADDRB <= std_logic_vector(to_unsigned(interruptSpAddrValue - 1, 12));
                    MEM_DINB <= X"00000" & std_logic_vector(unsigned(ProgramCounter));
                when JMPADDR_S =>
                    MEM_ENB <= '1';
                    MEM_WEB <= "0";
                    MEM_ADDRB <= "0000000" & std_logic_vector(to_unsigned(interruptNum, 5));
                when JMPFETCH2_S =>
                    MEM_ENB <= '1';
                when others =>
            end case;
        end if;
    end process memoryAccess_proc;

end Behavioral;