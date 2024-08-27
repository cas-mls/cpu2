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
-- ### Wait / Timer

-- #### Instructions

--  * oWAIT - Wait, Timer or Cancel.

-- This processes the wait instruction which pauses execution and sleep which continues the execution, but when the alarm happens it will call a interrupt.  The wait and sleep timers count the clock.

-- #### Wire Assignments (outputs)

-- | Signal     | Description                                                  |
-- | ---------- | ------------------------------------------------------------ |
-- | waitAlarm  | The alarm happens when the wait timer is completed.          |
-- | waitRun    | This is active when it is in a wait state.                   |
-- | waitCancel | This cancels the wait state.                                 |
-- | timerAlarm | This alarm happens when the timer is completed.              |
-- | timerInt   | The interrupt number is to be processed when the timer alarm goes off. |

-- Note:  Interrupt driven peripheral should use the Interrupts Processing (No special purpose IO interrupts).
-- Note:  Reading the IO (IOR_DATA) is not performed in this process. it is used by other processes.

-- #### Used Wires (Inputs)

-- | Signal           | Description                                                  |
-- | ---------------- | ------------------------------------------------------------ |
-- | INSTRUCTION      | Instruction operation                                        |
-- | fsm_inst_cycle_p | Process States:                                              |
-- |                  | RESET_STATE_S           - Reset the CPU.                     |
-- |                  | DECODE_S                    - Instruction Decode and identify operands. |
-- |                  | EXECUTE_S               - Execute the instruction.  To process interrupts, store registers/data. |
-- | cpuRegs          | The fast CPU registers.                                      |

-- #### Internal Wires:

-- | Signal                   | Description                                              |
-- | ------------------------ | -------------------------------------------------------- |
-- | flag/ffflag              | Multiple use flag (e.g., negative logic)                 |
-- | opcode/ffopcode          | Instruction operation                                    |
-- | memop/ffmemop            | Memory access operation.                                 |
-- | regop1/iregop1/ffiregop1 | Instruction identified first register.                   |
-- | ireg1value               | Value of the Register pointed to by instruction.         |
-- | regop2/iregop2/ffiregop2 | Instruction identified second register.                  |
-- | ireg2value               | Value of the Register pointed to by instruction.         |
-- | immop/ffimmop            | Immediate value from the instruction.                    |
-- | waitReg                  | This is the wait register.                               |
-- | waitTime                 | This is the wait timer.                                  |
-- | waitCount                | This is the counter for the timer.                       |
-- | waitResolution           | This is the resolution of the wait timer.                |
-- | waitResCounter           | This counter will count the number of resolution values. |
-- | waitRunLocal             | This is the local value of the wait run.                 |
-- | waitCancelLocal          | This is the local value of the cancel.                   |
-- | timerRun                 | This is active when the timer is running.                |
-- | timerReg                 | This is the timer register number.                       |
-- | timerTime                | This is the wait timer.                                  |
-- | timerCount               | This is the counter for the timer.                       |
-- | timerResolution          | This is the resolution of the wait timer.                |
-- | timerResCounter          | This counter will count the number of resolution values. |
---------------------------------------------------------------------------

entity WaitTimer is
    port (
        SYS_CLK : in std_logic;
        INSTRUCTION : in std_logic_vector(31 downto 0);
        cpuRegs : in reg_type;
        fsm_inst_cycle_p : in CYCLETYPE_FSM;

        waitAlarm : out std_logic;
        waitRun : out std_logic;
        waitCancel : out std_logic;
        timerAlarm : out std_logic;
        timerInt : out unsigned (4 downto 0)
    );

end WaitTimer;

architecture Behavioral of WaitTimer is

    -- Wait & Timer
    signal waitReg : integer range 0 to 15 := 0;
    signal waitTime : unsigned (31 downto 0) := (others => '0');
    signal waitCount : unsigned (31 downto 0) := (others => '0');
    signal waitResolution : unsigned (15 downto 0) := (others => '0');
    signal waitResCounter : unsigned (15 downto 0) := (others => '0');
    signal waitRunLocal : std_logic := '0';
    signal waitCancelLocal : std_logic := '0';
    -- signal waitAlarm : std_logic := '0';

    -- signal timerAlarm : std_logic := '0';
    signal timerRun : std_logic := '0';
    signal timerReg : integer range 0 to 15 := 0;
    signal timerTime : unsigned (31 downto 0) := (others => '0');
    signal timerCount : unsigned (31 downto 0) := (others => '0');
    signal timerResolution : unsigned (15 downto 0) := (others => '0');
    signal timerResCounter : unsigned (15 downto 0) := (others => '0');

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

    -- attribute keep : string;
    -- attribute MARK_DEBUG : string;

    -- attribute keep of timerAlarm : signal is "TRUE";
    -- attribute keep of timerRun : signal is "TRUE";
    -- attribute keep of timerInt : signal is "TRUE";

    -- attribute keep of waitRun : signal is "TRUE";
    -- attribute keep of waitAlarm : signal is "TRUE";
    -- attribute keep of waitCancel : signal is "TRUE";

begin

    opcode <= INSTRUCTION(31 downto 27);
    flag <= INSTRUCTION(26);
    memop <= INSTRUCTION(25 downto 24);
    regop1 <= INSTRUCTION(23 downto 20);
    regop2 <= INSTRUCTION(19 downto 16);
    immop <= INSTRUCTION(15 downto 0);
    iregop1 <= to_integer(unsigned(regop1));
    iregop2 <= to_integer(unsigned(regop2));

    -- Output Values
    waitRun <= waitRunLocal;
    waitCancel <= waitCancelLocal;

    wait_p : process (SYS_CLK)
    begin
        if rising_edge (SYS_CLK) then
            if fsm_inst_cycle_p = RESET_STATE_S
                or waitCancelLocal = '1' then
                waitResCounter <= (others => '0');
                waitCount <= (others => '0');
                waitReg <= 0;
                timerResCounter <= (others => '0');
                timerCount <= (others => '0');
                timerReg <= 0;
                timerAlarm <= '0';
                timerRun <= '0';

            elsif fsm_inst_cycle_p = DECODE_S
                then
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

            elsif fsm_inst_cycle_p = EXECUTE_S
                then
                if ffopcode = oWAIT
                    then
                    if ffmemop = REGREG
                        then
                        -- Wait/Timer Cancel
                        if ffflag = '1' then
                            -- Interrupt processing can cancel the wait.
                            if ffiregop1 = waitReg then
                                waitReg <= 0;
                                waitCancelLocal <= '1';
                                waitRunLocal <= '0';
                            elsif ffiregop1 = timerReg then
                                timerReg <= 0;
                                timerAlarm <= '0';
                                timerRun <= '0';
                            end if;
                        end if;
                    elsif ffmemop = IMMEDIATE
                        then
                        if ffflag = '0' then
                            if ffiregop2 = 0 then
                                if waitRunLocal = '0' then
                                    waitReg <= ffiregop1;
                                    waitTime <= unsigned(cpuRegs(ffiregop1));
                                    waitResolution <= unsigned(ffimmop);
                                    waitResCounter <= (others => '0');
                                    waitCount <= (others => '0');
                                    waitAlarm <= '0';
                                    waitRunLocal <= '1';
                                end if;
                            else
                                timerreg <= ffiregop1;
                                timerTime <= unsigned(cpuRegs(ffiregop1));
                                timerInt <= unsigned(cpuRegs(ffiregop2)(4 downto 0));
                                timerResolution <= unsigned(ffimmop);
                                timerAlarm <= '0';
                                timerRun <= '1';
                                timerResCounter <= (others => '0');
                                timerCount <= (others => '0');
                            end if;
                        end if;
                    end if;
                end if;
            end if;

            -- Process the wait loop.
            if waitRunLocal = '1'
                then
                if waitTime /= 0 then -- Infinite wait when Wait Time = 0
                    waitResCounter <= waitResCounter + 1;
                    if waitResCounter >= waitResolution - 1 then
                        waitCount <= waitCount + 1;
                        waitResCounter <= (others => '0');
                        if waitCount >= waitTime - 1 then
                            waitCount <= (others => '0');
                            waitAlarm <= '1';
                            waitRunLocal <= '0';
                        end if;
                    end if;
                end if;
            else
                waitAlarm <= '0';
            end if;

            -- Process the timer loop
            if timerRun = '1'
                then
                if timerTime /= 0 then -- Infinite timer when Wait Time = 0
                    timerResCounter <= timerResCounter + 1;
                    if timerResCounter >= timerResolution - 1 then
                        timerCount <= timerCount + 1;
                        timerResCounter <= (others => '0');
                        if timerCount >= timerTime then
                            timerCount <= (others => '0');
                            timerAlarm <= '1';
                            timerRun <= '0';
                        end if;
                    end if;
                end if;
            else
                timerAlarm <= '0';
            end if;
        end if;
    end process wait_p;

end Behavioral;