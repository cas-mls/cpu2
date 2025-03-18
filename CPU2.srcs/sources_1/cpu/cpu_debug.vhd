----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/14/2025 02:19:31 PM
-- Design Name: 
-- Module Name: cpu_debug - Behavioral
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
use xil_defaultlib.Utilities.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cpu_debug is
    Port ( 
        SYS_CLK : in STD_LOGIC;
        INSTRUCTION : in std_logic_vector(31 downto 0);
        fsm_inst_cycle_p : in CYCLETYPE_FSM;
        programCounter : in PCTYPE;
        cpuRegs : in REG_TYPE;
        MEM_ARG : in std_logic_vector(31 downto 0);
        interruptNum : in integer range 0 to interruptNums;
        interruptMask : in std_logic_vector(interruptNums downto 0);
        statusWord : in STATUS_WORD_TYPE := (others => '0');
        statusMask : in std_logic_vector(31 downto 0);
        DebugDisablePipline : out STD_LOGIC;
        DebugStart : out STD_LOGIC;
        DebugIn     : in DEBUGINTYPE := (
            DebugMode => '0',
            BreakPoints => (others => (others => '0')),
            Break => '0',
            Step => '0',
            Continue => '0',
            BWhenReg => 0,
            BWhenValue => (others => '0'),
            BWhenOp => REG_NOTHING,
            Reset => '0',
            UpdateValue => (
                Number => 0,
                Value => (others => '0'),
                Valid => '0'
            ),
            UpdateReg => (
                Number => 0,
                Value => (others => '0'),
                Valid => '0'
            )            
        );
        DebugOut    : out DEBUGOUTTYPE
    );
end cpu_debug;

architecture Behavioral of cpu_debug is

    signal StepWait : STD_LOGIC;
    signal ProgCounterLast : PCTYPE;
    signal RegsLast : REG_TYPE := (others => (
        value => (others => '0'),
        opcode => oNOP,
        flag => '0',
        countdown => 0));

    function debug_reg_compare(
        RegLast : std_logic_vector;
        Reg : std_logic_vector;
        RegDebug : std_logic_vector;
        Op : REG_COMPARE) return boolean is
    begin
        if (Op = REG_NOTHING) then
            return false;
        elsif Reg /= RegLast then
            case Op is
                when REG_EQUAL =>
                    return Reg = RegDebug;
                when REG_LESS =>
                    return Reg < RegDebug;
                when REG_GREATER =>
                    return Reg > RegDebug;
                when REG_CHANGE =>
                    return true;
                when REG_NOT_EQUAL =>
                    return Reg /= RegDebug;
                when REG_GREATER_EQUAL =>
                    return Reg >= RegDebug;
                when REG_LESS_EQUAL =>
                    return Reg <= RegDebug;
                when others =>
                    return false;
            end case;
        end if;
        return false;
    end function;

    
begin

    
    debug_proc : process(SYS_CLK)

    begin
        if rising_edge (SYS_CLK) then
            if fsm_inst_cycle_p = RESET_STATE_S then
                DEBUGOUT <= ( 
                    stopped => '0',
                    cycleCount => (others => '0'),
                    progCounter => (others => '0'),
                    Regs => (others => (others => '0')),
                    Instruction => (others =>'0'),
                    Interrupt => (others => '0'),
                    InterruptMask => (others => '0'),
                    Status => (others => '0'),
                    StatusMask => (others => '0'),
                    MEMORY_ARG => (others => '0'),
                    Reset => '0'
                    );
                StepWait <= '0';
                DebugDisablePipline <= '0';
                DebugStart <= '0';
                ProgCounterLast <= X"000";
                RegsLast <= (others => (
                    value => (others => '0'),
                    opcode => oNOP,
                    flag => '0',
                    countdown => 0));
            elsif fsm_inst_cycle_p = DECODE_S then
                -- Maintain Flip-Flop (Memory) portions of the instruction.
                -- The INSTRUCTION might change because of the pipeline.
                DEBUGOUT.Instruction <= INSTRUCTION;

            elsif DEBUGIN.DebugMode = '1' then
                if fsm_inst_cycle_p = DEBUGSTABLEIZE_S
                then
                    DEBUGOUT.Stopped <= '1';
                    DebugStart <= '0';

                elsif fsm_inst_cycle_p = DEBUGWAIT_S
                then
                    if DEBUGIN.Continue = '1'
                    then
                        DEBUGOUT.Stopped <= '0';
                        StepWait <= '0';
                        DebugDisablePipline <= '1';
                    elsif DEBUGIN.Step = '1'
                    then
                        DEBUGOUT.Stopped <= '0';
                        StepWait <= '1';
                        DebugDisablePipline <= '1';
                    elsif DEBUGIN.UpdateValue.Valid = '1' 
                        and DEBUG_DATA'VAL(DEBUGIN.UpdateValue.Number) = DBG_INTERRUPT
                    then
                        StepWait <= '1';
                        -- DebugStart <= '1';
                        DebugDisablePipline <= '1';
                    end if;
                    else
                    if  (ProgCounterLast /= ProgramCounter
                        and (ProgramCounter = DEBUGIN.BreakPoints(0)
                            or ProgramCounter = DEBUGIN.BreakPoints(1)
                            or ProgramCounter = DEBUGIN.BreakPoints(2)
                            or ProgramCounter = DEBUGIN.BreakPoints(3)))
                        or debug_reg_compare(
                                RegsLast(DEBUGIN.BWhenReg).Value,
                                cpuRegs(DEBUGIN.BWhenReg).Value,
                                DEBUGIN.BWhenValue, DEBUGIN.BWhenOp)
                        or stepWait = '1'
                        or DEBUGIN.Break = '1'
                    then
                        StepWait <= '0';
                        DebugStart <= '1';
                    end if;

                    if fsm_inst_cycle_p = EXECUTE_S
                    then
                        DebugDisablePipline <= '0';
                    end if;
                end if;
                DEBUGOUT.Reset <= DEBUGIN.Reset;

                -- Continue to update the debug information.
                -- Good generic information for the simulator and ILA.
                if DEBUGOUT.Stopped = '0'
                then
                    DEBUGOUT.CycleCount <= DEBUGOUT.CycleCount + 1;
                end if;
                DEBUGOUT.ProgCounter <= ProgramCounter;
                for i in 0 to regOpMax loop
                    DEBUGOUT.Regs(i) <= cpuRegs(i).Value;
                end loop;
                -- DEBUGOUT.Regs <= cpuRegs;
                DEBUGOUT.Status <= statusWord;
                DEBUGOUT.StatusMask <= statusMask;
                DEBUGOUT.Interrupt <= std_logic_vector(to_unsigned(interruptNum,32));
                DEBUGOUT.interruptMask  <= interruptMask;
                if DEBUGOUT.Instruction(25 downto 24) = ABSOLUTE 
                    or DEBUGOUT.Instruction(25 downto 24) = INDEX
                then
                    DEBUGOUT.MEMORY_ARG <= MEM_ARG;
                else
                    DEBUGOUT.MEMORY_ARG <= (others => '0');
                end if;

                -- Capture last values to find when the current values changes.
                ProgCounterLast <= ProgramCounter;
                RegsLast <= cpuRegs;

            end if;
        end if;
    end process debug_proc;



end Behavioral;
