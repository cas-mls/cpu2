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
-- ### Interrupts
-- This handles the interrupt put the Mask and program counter
--              on the stack and calls the interrupt handler.
--             The maintains it own finite state machine (FSM).
-- #### Wire Assignments (outputs)
-- | Signal            | Description                                                  |
-- | ----------------- | ------------------------------------------------------------ |
-- |fsm_interrupt_cycle_p |
-- |  |  INTRWAIT_S (State 0)    - Wait for Interrupt
-- |  |  CYCLEWAIT_S (State 1)   - Wait for Instruction Cycle to complete.
-- |  |  SAVEENA_S (State 2)     - Saves the Interrupt Enable Mask.
-- |  |  DISABLEINT_S (State 3)  - Disable all Interrupts.
-- |  |  JMPADDR_S (State 4)     - Get the Interrupt Handler from address vector.
-- |  |  JMPFETCH1_S (State 5)   - Memory Read Latency 
-- |  |  JMPFETCH2_S (State 6)   - Memory Read Latency 
-- |  |  JUMP_S (State 7)        - Start the Instruction Cycle with Interrupt Handler.
-- |  |  DONE_S (State 8)        - Complete the Interrupt processing.
-- |interruptRun            | Flag indicating that the interrupt is running.
-- |interruptNum            | Interrupt number being processed (1-31)
-- |interruptMask           | The Interrupt enable mask (1 is enabled).
-- |interruptSpNum          | The stack pointer register.
-- |interruptSpAddrValue    | The value of the stack pointer at the starting of the interrupt.

-- Note:   Limitations 1) The interrupt is read when instruction in execute state.

-- #### Used Wires (Inputs)
-- | Signal            | Description                                                  |
-- | ----------------- | ------------------------------------------------------------ |
-- | INSTRUCTION         | Current Fetched Instruction
-- | cpuRegs             | CPU Registers
-- | fsm_inst_cycle_p | Process States:
-- |  |       RESET_STATE_S   - Reset the CPU.
-- |  |       DECODE_S        - Instruction Decode and identify operands.
-- |  |       EXECUTE_S       - Execute the instruction.
-- |  |       CLEANUP_S       - Clean up data after execute.
-- | MEM_ARG             | The current memory argument from decode.
-- | INTERRUPT           | The Interrupt vector
-- | timerAlarm          | Completion of the timer alarm.
-- | timerInt            | The interrupt number (1-31)
-- #### Internal Wires:
-- | Signal            | Description                                                  |
-- | ----------------- | ------------------------------------------------------------ |
-- | opcode/ffopcode         | Instruction operation
-- | ffflag                  | Multiple use flag (e.g., negative logic)
-- | memop/ffmemop           | Memory access operation.
-- | ffiregop1               | Instruction identified first register.
-- | ireg1value              | Value of the Register pointed to by instruction.
-- | ireg2value              | Value of the Register pointed to by instruction.
-- | ffimmop                 | Immediate value from the instruction.
-- | fsm_interrupt_cycle_p_local
-- |                         | Local value of the current state (set and used).
-- | fsm_interrupt_cycle_n   | Next interrupt state.
-- | interBitNum             | Interrupt bit number (interrupt number)
-- | interruptMaskLocal      | Local value of the Mask (set and used).
-- | interruptSpNumLocal     | Local value of the interrupt stack register number (set and used).

-- #### Interrupt State Diagram

-- | Cycle      | Description                                                  |
-- | ---------- | ------------------------------------------------------------ |
-- |            | Interrupt Processing                                         |
-- | SAVEENA    | IntEna → dinB  <br />reg(InterSP) → reg(InterSP) – 1         |
-- | DISABLEINT | ’0’ → IntEna(interNum) <br />reg(InterSP) → addrB <br />PC → dinB |
-- | JMPADDR    | reg(InterSP) → reg(InterSP) – 1 <br />InterNum → addrB       |
-- | JMPFETCH1  | Wait                                                         |
-- | JMPFETCH2  | Wait                                                         |
-- | JUMP       | DoutB → PC                                                   |

-- ```mermaid
-- stateDiagram

--     [*] --> INTRWAIT_S 
--     INTRWAIT_S --> INTRWAIT_S
--     INTRWAIT_S --> CYCLEWAIT_S : interrupt, SWI
--     CYCLEWAIT_S --> CYCLEWAIT_S : Wait for Execute State
--     CYCLEWAIT_S --> SAVEENA_S : Execute State
--     SAVEENA_S --> DISABLEINT_S
--     DISABLEINT_S --> JMPADDR_S
--     JMPADDR_S --> JMPFETCH1_S
--     JMPFETCH1_S --> JMPFETCH2_S
--     JMPFETCH2_S --> JUMP_S
--     JUMP_S --> [*]
    
-- ```
---------------------------------------------------------------------------


entity Interrupt_Entity is
    port (
        SYS_CLK : in std_logic;
        INSTRUCTION : in std_logic_vector(31 downto 0);
        cpuRegs : in REG_TYPE;
        fsm_inst_cycle_p : in CYCLETYPE_FSM;
        MEM_ARG : in std_logic_vector(31 downto 0);
        INTERRUPT : in std_logic_vector (31 downto 0);
        timerAlarm : in std_logic;
        timerInt : in unsigned (4 downto 0);
        statusWord : in STATUS_WORD_TYPE;

        fsm_interrupt_cycle_p : out INTERRUPT_FSM;
        interruptRun : out std_logic := '0';
        interruptNum : out integer range 0 to interruptNums := 0;
        interruptMask : out std_logic_vector(interruptNums downto 0) := X"00000000";
        interruptSpNum : out integer range 0 to interruptNums;
        interruptSpAddrValue : out integer range 0 to 2 ** 12 - 1;
        interruptReset : out STD_LOGIC := '0'
    );

end Interrupt_Entity;

architecture Behavioral of Interrupt_Entity is

    -- interrupts
    signal fsm_interrupt_cycle_p_local : INTERRUPT_FSM;
    signal fsm_interrupt_cycle_n : INTERRUPT_FSM := INTRWAIT_S;
    signal interruptMaskLocal : std_logic_vector(interruptNums downto 0) := X"00000000";
    signal interruptSpNumLocal : integer range 0 to regOpMax;

    -- Software Status Mask
    signal softwareStatusMask : std_logic_vector(31 downto 0) := X"00000000";

    -- Decode information    
    signal opcode : OPCODETYPE := "00000";
    signal ffopcode : OPCODETYPE := "00000";
    signal ffflag  : STD_LOGIC := '0';
    signal memop : MEMTYPE;
    signal ffmemop : MEMTYPE;
    signal ffiregop1 : integer range 0 to regOpMax;
    signal ireg1value : std_logic_vector(31 downto 0) := X"00000000";
    signal ireg2value : std_logic_vector(31 downto 0) := X"00000000";
    signal ffimmop : IMMTYPE;

    -- attribute keep : string;
    -- attribute MARK_DEBUG : string;

    -- attribute keep of        fsm_interrupt_cycle_p : signal is "TRUE";
    -- attribute MARK_DEBUG of  fsm_interrupt_cycle_p : signal is "TRUE";
    -- attribute keep of        fsm_interrupt_cycle_n : signal is "TRUE";
    -- attribute MARK_DEBUG of  fsm_interrupt_cycle_n : signal is "TRUE";
    -- attribute keep of        INTERRUPT : signal is "TRUE";
    -- attribute MARK_DEBUG of  INTERRUPT : signal is "TRUE";

    -- attribute keep of        timerAlarm : signal is "TRUE";
    -- attribute MARK_DEBUG of  timerAlarm : signal is "TRUE";
    -- attribute keep of        timerInt : signal is "TRUE";
    -- attribute MARK_DEBUG of  timerInt : signal is "TRUE";

    -- attribute keep of        interruptRun : signal is "TRUE";
    -- attribute MARK_DEBUG of  interruptRun : signal is "TRUE";
    -- attribute keep of        interruptMaskLocal : signal is "TRUE";
    -- attribute MARK_DEBUG of  interruptMaskLocal : signal is "TRUE";
    -- attribute keep of        interruptSpNumLocal : signal is "TRUE";
    -- attribute MARK_DEBUG of  interruptSpNumLocal : signal is "TRUE";
    -- attribute keep of        interruptSpAddrValue : signal is "TRUE";
    -- attribute MARK_DEBUG of  interruptSpAddrValue : signal is "TRUE";
    
    -- Function to determine the interrupt bit number
    function get_interBitNum(INTERRUPT : std_logic_vector) return integer is
        variable bitNum : integer := 0;
    begin
        for i in 0 to INTERRUPT'length-1 loop
            if INTERRUPT(i) = '1' then
                bitNum := i;
                exit;
            end if;
        end loop;
        return bitNum;
    end function;

begin

    opcode <= INSTRUCTION(31 downto 27);
    memop <= INSTRUCTION(25 downto 24);

    -- Output Values
    fsm_interrupt_cycle_p <= fsm_interrupt_cycle_p_local;
    interruptMask <= interruptMaskLocal;
    interruptSpNum <= interruptSpNumLocal;

    interrupt_fsm_Proc : process (SYS_CLK)

    begin
        if rising_edge (SYS_CLK) then
            if fsm_inst_cycle_p = RESET_STATE_S then
                fsm_interrupt_cycle_p_local <= JMPADDR_S;
            else
                fsm_interrupt_cycle_p_local <= fsm_interrupt_cycle_n;
            end if;
        end if;
    end process;

    intrrupt_Proc : process (
        fsm_interrupt_cycle_p_local,
        fsm_inst_cycle_p,
        interruptRun
        )
    begin
        case fsm_interrupt_cycle_p_local is
            when INTRWAIT_S =>
                if interruptRun = '1'
                then
                    fsm_interrupt_cycle_n <= SAVEENA_S;
                else
                    fsm_interrupt_cycle_n <= INTRWAIT_S;
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

process (SYS_CLK)

    variable interruptVar : integer range 0 to interruptNums;
    variable maskedInterrupt : std_logic_vector(interruptNums downto 0);

begin
    if rising_edge(SYS_CLK) then
        case fsm_inst_cycle_p is 
            when RESET_STATE_S =>
                interruptSpAddrValue <= 0;
                interruptReset <= '0';
                interruptRun <= '0';
            when DECODE_S =>

                if  opcode = oRTI
                    and memop = REGREG
                then
                    interruptSpAddrValue <= to_integer(unsigned(cpuRegs(interruptSpNumLocal)));
                end if;

                -- Maintain Flip-Flop (Memory) protions of the instruction.
                -- This removes the timing violations and make the processor faster.
                -- Might remove the combinatorial logic which should not be used after this cycle.
                ffopcode <= INSTRUCTION(31 downto 27);
                ffflag <= INSTRUCTION(26);
                ffmemop <= INSTRUCTION(25 downto 24);
                ffiregop1 <= to_integer(unsigned(INSTRUCTION(23 downto 20)));
                ffimmop <= INSTRUCTION(15 downto 0);
                ireg1value <= cpuRegs(to_integer(unsigned(INSTRUCTION(23 downto 20))));
                ireg2value <= cpuRegs(to_integer(unsigned(INSTRUCTION(19 downto 16))));

            when EXECUTE_S | WAITS_S =>
                if ffopcode = oSWDM then
                    if ffflag = SWMFLAG then -- Status Mask
                        case ffmemop is
                            when REGREG =>
                                softwareStatusMask <= ireg2value;
                            when IMMEDIATE =>
                                softwareStatusMask <= X"0000" & ffimmop;
                            when ABSOLUTE | INDEX =>
                                softwareStatusMask <= MEM_ARG;
                            when others =>
                        end case;
                    else -- Obtain status word

                    end if;
                elsif ffopcode = oSWIENA then
                    if ffflag = ENAFLAG then -- Enable Mask
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
                            end case;
                    end if;

                end if;

                -- Check for Software Interrupt
                if ffopcode = oSWIENA then
                    if ffflag = SWIFLAG then -- Enable Mask
                        case ffmemop is
                            when REGREG =>
                                interruptVar := to_integer(unsigned(ireg1value));
                            when IMMEDIATE =>
                                interruptVar := to_integer(unsigned(ffimmop(4 downto 0)));
                            when ABSOLUTE | INDEX =>
                                interruptVar := to_integer(unsigned(MEM_ARG(4 downto 0)));
                            when others =>
                        end case;
                        if interruptVar = 0 
                        then
                            interruptReset <= '1';
                        elsif interruptMaskLocal(interruptVar) = '1'
                        then
                            interruptNum <= interruptVar;
                            interruptSpAddrValue <= to_integer(unsigned(cpuRegs(interruptSpNumLocal)));
                            interruptRun <= '1';
                        end if;
                    end if;
                end if;

            when CLEANUP_S =>
                if ffopcode = oRTI
                then
                    interruptMaskLocal <= MEM_ARG;
                end if;
            when others =>
        end case;

        -- Check for Timer Interrupt
        if (timerAlarm = '1'
            and interruptMaskLocal(to_integer(unsigned(timerInt))) = '1')
        then
            interruptNum <= to_integer(unsigned(timerInt));
            interruptSpAddrValue <= to_integer(unsigned(cpuRegs(interruptSpNumLocal)));
            interruptRun <= '1';
        end if;

        -- Check for Hardware Interrupt
        maskedInterrupt := INTERRUPT and interruptMaskLocal;
        if unsigned(maskedInterrupt) /= 0
        then
            interruptNum <= get_interBitNum(maskedInterrupt);
            interruptSpAddrValue <= to_integer(unsigned(cpuRegs(interruptSpNumLocal)));
            interruptRun <= '1';
        end if;
        
        -- Check for Status Interrupt
        if unsigned(statusWord and softwareStatusMask) /= 0 
            and interruptMaskLocal(1) = '1'
        then
            interruptNum <= 1;
            interruptSpAddrValue <= to_integer(unsigned(cpuRegs(interruptSpNumLocal)));
            interruptRun <= '1';
        end if;

        case fsm_interrupt_cycle_n is
            when INTRWAIT_S =>
            when SAVEENA_S =>
            when JMPADDR_S =>
            when JMPFETCH1_S =>
            when JMPFETCH2_S =>
            when JUMP_S =>
            when DISABLEINT_S =>    
                interruptMaskLocal <= (others => '0');
            when DONE_S =>
                interruptNum <= 0;
                interruptRun <= '0';
            when others =>
                interruptRun <= '0';
        end case;
    end if;
end process;

end Behavioral;