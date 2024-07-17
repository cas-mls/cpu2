----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/29/2023 05:57:00 PM
-- Design Name: 
-- Module Name: Decode - Behavioral
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
--  Process (Clocked) : io_proc
--  Description: This handles the address, data and statuses for IO.
--  Wire Assignments
--      IO_ADDR     - Address of the IO peripheral.
--      IOW_DATA    - Data to be written to the peripheral.
--      IOW_ENA     - Flag indicating the transfer of data from CPU to peripheral.
--      IOR_ENA     - Flag indicating the data needs to be transferred from peripheral to CPU.
--      Note:   Interrupt driven peripheral should use the Interrupts Processing (No special purpose IO interrupts).
--      Note:   Reading the IO (IOR_DATA) is not performed in this process. it is used by other processes.
--  Used Clocked Wires:
--      ffopcode        - oRWIO / Read Write IO
--      ffflag          - 0 = Read (RIO) / 1 = Write (WIO)
--      ffmemop         - Reg/Reg, Immediate, Absolute, and Index
--      fsm_inst_cycle_p
--          Process States:
--              RESET_STATE_S   - Reset the CPU.
--              DECODE_S        - Instruction Decode and identify operands.
--              EXECUTE_S       - Execute the instruction.
--              CLEANUP_S       - Clean up data after execute.
--  Used Combinational Wires:
--      opcode          oRWIO / Read Write IO
--      flag            0 = Read (RIO) / 1 = Write (WIO)
--      memop           Reg/Reg, Immediate, Absolute, and Index
---------------------------------------------------------------------------

entity Interrupt_Entity is
    port (
        SYS_CLK : in std_logic;
        INSTRUCTION : in std_logic_vector(31 downto 0);
        cpuRegs : in reg_type;
        fsm_inst_cycle_p : in CYCLETYPE_FSM;
        MEM_ARG : in std_logic_vector(31 downto 0);
        INTERRUPT : in std_logic_vector (31 downto 0);
        timerAlarm : in std_logic;
        timerInt : in unsigned (4 downto 0);

        fsm_interrupt_cycle_p : out INTERRUPT_FSM;
        interruptRun : out std_logic := '0';
        interruptNum : out integer range 0 to interruptNums := 0;
        interruptMask : out std_logic_vector(interruptNums downto 0) := X"00000000";
        interruptSpNum : out integer range 0 to interruptNums;
        interruptSpAddrValue : out integer range 0 to 2 ** 12 - 1
    );

end Interrupt_Entity;

architecture Behavioral of Interrupt_Entity is

    -- interrupts
    signal fsm_interrupt_cycle_p_local : INTERRUPT_FSM;
    signal fsm_interrupt_cycle_n : INTERRUPT_FSM := INTRWAIT_S;
    signal interBitNum : integer range 0 to interruptNums := 0;
    signal interruptMaskLocal : std_logic_vector(interruptNums downto 0) := X"00000000";
    signal interruptSpNumLocal : integer range 0 to interruptNums;

    -- Decode information    
    signal opcode : OPCODETYPE := "00000";
    signal ffopcode : OPCODETYPE := "00000";
    signal memop : MEMTYPE;
    signal ffmemop : MEMTYPE;
    signal ffiregop1 : integer range 0 to regOpMax;
    signal ireg1value : std_logic_vector(31 downto 0) := X"00000000";
    signal ireg2value : std_logic_vector(31 downto 0) := X"00000000";
    signal ffimmop : IMMTYPE;

    attribute keep : string;
    attribute MARK_DEBUG : string;

    -- attribute keep of timerAlarm : signal is "TRUE";
    -- attribute keep of timerRun : signal is "TRUE";
    -- attribute keep of timerInt : signal is "TRUE";

    -- attribute keep of waitRun : signal is "TRUE";
    -- attribute keep of waitAlarm : signal is "TRUE";
    -- attribute keep of waitCancel : signal is "TRUE";

begin

    opcode <= INSTRUCTION(31 downto 27);
    memop <= INSTRUCTION(25 downto 24);

    interBitNum <=
                  0 when INTERRUPT = RESET else
                  1 when INTERRUPT = X"00000002" else
                  2 when INTERRUPT = X"00000004" else
                  3 when INTERRUPT = X"00000008" else
                  4 when INTERRUPT = X"00000010" else
                  5 when INTERRUPT = X"00000020" else
                  6 when INTERRUPT = X"00000040" else
                  7 when INTERRUPT = X"00000080" else
                  8 when INTERRUPT = X"00000100" else
                  9 when INTERRUPT = X"00000200" else
                  10 when INTERRUPT = X"00000400" else
                  11 when INTERRUPT = X"00000800" else
                  12 when INTERRUPT = X"00001000" else
                  13 when INTERRUPT = X"00002000" else
                  14 when INTERRUPT = X"00004000" else
                  15 when INTERRUPT = X"00008000" else
                  16 when INTERRUPT = X"00000001" else
                  17 when INTERRUPT = X"00000002" else
                  18 when INTERRUPT = X"00040000" else
                  19 when INTERRUPT = X"00080000" else
                  20 when INTERRUPT = X"00100000" else
                  21 when INTERRUPT = X"00200000" else
                  22 when INTERRUPT = X"00400000" else
                  23 when INTERRUPT = X"00800000" else
                  24 when INTERRUPT = X"01000000" else
                  25 when INTERRUPT = X"02000000" else
                  26 when INTERRUPT = X"04000000" else
                  27 when INTERRUPT = X"08000000" else
                  28 when INTERRUPT = X"10000000" else
                  29 when INTERRUPT = X"20000000" else
                  30 when INTERRUPT = X"40000000" else
                  31 when INTERRUPT = X"80000000" else
                  31;

    -- Output Values
    fsm_interrupt_cycle_p <= fsm_interrupt_cycle_p_local;
    interruptMask <= interruptMaskLocal;
    interruptSpNum <= interruptSpNumLocal;

    interrupt_fsm_Proc : process (SYS_CLK)

        variable interruptVar : integer range 0 to interruptNums;

    begin
        if rising_edge (SYS_CLK) then
            if INTERRUPT = RESET then
                interruptSpAddrValue <= 0;
                fsm_interrupt_cycle_p_local <= JMPADDR_S;
            elsif fsm_inst_cycle_p = DECODE_S
                then
                if opcode = oRTI
                    and memop = REGREG
                    then
                    interruptSpAddrValue <= to_integer(unsigned(cpuRegs(interruptSpNumLocal)));
                end if;
                -- Maintain Flip-Flop (Memory) protions of the instruction.
                -- This removes the timing violations and make the processor faster.
                -- Might remove the combinatorial logic which should not be used after this cycle.
                ffopcode <= INSTRUCTION(31 downto 27);
                ffmemop <= INSTRUCTION(25 downto 24);
                ffiregop1 <= to_integer(unsigned(INSTRUCTION(23 downto 20)));
                ffimmop <= INSTRUCTION(15 downto 0);
                ireg1value <= cpuRegs(to_integer(unsigned(INSTRUCTION(23 downto 20))));
                ireg2value <= cpuRegs(to_integer(unsigned(INSTRUCTION(19 downto 16))));

            elsif fsm_interrupt_cycle_n = INTRWAIT_S then
                if fsm_inst_cycle_p = EXECUTE_S then
                    if ffopcode = oSWI then
                        case ffmemop is
                            when REGREG =>
                                interruptVar := to_integer(unsigned(ireg1value));
                            when IMMEDIATE =>
                                interruptVar := to_integer(unsigned(ffimmop(4 downto 0)));
                            when ABSOLUTE | INDEX =>
                                interruptVar := to_integer(unsigned(MEM_ARG(4 downto 0)));
                            when others =>
                                fsm_interrupt_cycle_p_local <= INTRWAIT_S; -- This should not happen.
                        end case;
                        if interruptMaskLocal(interruptVar) = '1'
                            then
                            interruptNum <= interruptVar;
                            fsm_interrupt_cycle_p_local <= SAVEENA_S;
                            interruptSpAddrValue <= to_integer(unsigned(cpuRegs(interruptSpNumLocal)));
                            interruptRun <= '1';
                        else
                            fsm_interrupt_cycle_p_local <= INTRWAIT_S;
                        end if;

                    elsif ffopcode = oIENA then
                        case ffmemop is
                            when REGREG =>
                                interruptSpNumLocal <= ffiregop1;
                                interruptMaskLocal <= ireg2value;
                            when IMMEDIATE =>
                                interruptSpNumLocal <= ffiregop1;
                                interruptMaskLocal <= X"0000" & ffimmop;
                            when ABSOLUTE | INDEX =>
                                interruptSpNumLocal <= ffiregop1;
                                interruptMaskLocal <= MEM_ARG;
                            when others =>
                                fsm_interrupt_cycle_p_local <= INTRWAIT_S;
                        end case;
                    end if;

                    if unsigned(INTERRUPT and interruptMaskLocal) /= 0
                        then
                        interruptNum <= interBitNum;
                        fsm_interrupt_cycle_p_local <= SAVEENA_S;
                        interruptSpAddrValue <= to_integer(unsigned(cpuRegs(interruptSpNumLocal)));
                        interruptRun <= '1';
                    end if;

                elsif (fsm_inst_cycle_p = EXECUTE_S
                    or fsm_inst_cycle_p = WAITS_S)
                    and (timerAlarm = '1'
                    and interruptMaskLocal(to_integer(unsigned(timerInt))) = '1')
                    then
                    interruptNum <= to_integer(unsigned(timerInt));
                    fsm_interrupt_cycle_p_local <= SAVEENA_S;
                    interruptSpAddrValue <= to_integer(unsigned(cpuRegs(interruptSpNumLocal)));
                    interruptRun <= '1';
                elsif fsm_inst_cycle_p = CLEANUP_S
                    and ffopcode = oRTI
                    then
                    interruptMaskLocal <= MEM_ARG;
                end if;
            else
                -- Clear the interrupt, so changing the mask does not inadvertently case an interrupt.
                case fsm_interrupt_cycle_n is
                    when SAVEENA_S
                        | JMPADDR_S
                        | JMPFETCH1_S
                        | JMPFETCH2_S
                        | JUMP_S =>
                        interruptRun <= '1';
                    when DISABLEINT_S =>
                        interruptRun <= '1';
                        interruptMaskLocal <= (others => '0');
                    when DONE_S =>
                        interruptNum <= 0;
                        interruptRun <= '0';
                    when others =>
                end case;

                fsm_interrupt_cycle_p_local <= fsm_interrupt_cycle_n;
            end if;
        end if;
    end process;

    intrrupt_Proc : process (
        fsm_interrupt_cycle_p_local,
        fsm_inst_cycle_p,
        INTERRUPT
        )
    begin
        case fsm_interrupt_cycle_p_local is
            when INTRWAIT_S =>
                if INTERRUPT /= NOINTERRUPT then
                    fsm_interrupt_cycle_n <= CYCLEWAIT_S;
                else
                    fsm_interrupt_cycle_n <= INTRWAIT_S;
                end if;
            when CYCLEWAIT_S =>
                if fsm_inst_cycle_p = EXECUTE_S then
                    fsm_interrupt_cycle_n <= SAVEENA_S;
                else
                    fsm_interrupt_cycle_n <= CYCLEWAIT_S;
                end if;
            when SAVEENA_S =>
                fsm_interrupt_cycle_n <= DISABLEINT_S;
            when DISABLEINT_S =>
                fsm_interrupt_cycle_n <= JMPADDR_S;
            when JMPADDR_S =>
                fsm_interrupt_cycle_n <= JMPFETCH1_S;
            when JMPFETCH1_S =>
                fsm_interrupt_cycle_n <= JMPFETCH2_S;
            when JMPFETCH2_S =>
                fsm_interrupt_cycle_n <= JUMP_S;
            when JUMP_S =>
                fsm_interrupt_cycle_n <= DONE_S;
            when DONE_S =>
                fsm_interrupt_cycle_n <= INTRWAIT_S;
            when others =>
                fsm_interrupt_cycle_n <= INTRWAIT_S;
        end case;
    end process intrrupt_Proc;

end Behavioral;