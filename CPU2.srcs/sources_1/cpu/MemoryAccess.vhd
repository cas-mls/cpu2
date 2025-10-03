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
-- ### Memory Access

-- This handles the memory access for the operand, stack, and etc. memory.  This used the Port B memory access.

-- #### Instructions

--  * oSTR - Store memory to register
--  * oRWIO - Read and store memory.

-- #### Wire Assignments (outputs)

-- | Signal            | Description                                                  |
-- | ----------------- | ------------------------------------------------------------ |
-- | MEM_ENB           | The Instruction Memory enabled. |
-- | MEM_WEB           | The Instruction Memory Read/Write. |
-- | MEM_ADDRB         | The Instruction address to Read or Write memory. |
-- | MEM_DINB          | The Instruction input data. |

-- Note:   Actually setting MEM_DOUTB (writting memory) is not part of this process.
--             But setting the address to write memory is being set.
--             This does not used 3-state addresses, could make use of it in the future.


-- #### Used Wires (Inputs)

-- | Signal            | Description                                                  |
-- | ----------------- | ------------------------------------------------------------ |
-- | INSTRUCTION       | Instruction operation|
-- | cpuRegs           | The fast CPU registers.|
-- | fsm_inst_cycle_p| Process States: |
-- | | RESET_STATE_S - Reset the CPU. |
-- | | ADDRESS_S - Setting the address from the program counter.  This sets clears the memory enable. |
-- | | DECODE_S - Instruction Decode and identify operands.  Sets up the Memory addresses and writes data. |
-- | | MEMFETCH1_S - Waits to read (MEM_DOUTB) because of the memory legacy and latches. This is  use to pop interrupt PC and mask. |
-- | | MEMFETCH2_S - Waits to read (MEM_DOUTB) because of the memory legacy and latches |
-- | | EXECUTE_S - Execute the instruction. To process interrupts, and store registers/data. |
-- | | CLEANUP_S - Clean up data after execute state. |
-- | fsm_interrupt_cycle_p|Process States:|
-- | |SAVEENA_S (State 2)     - Saves the Interrupt Enable Mask.|
-- | |DISABLEINT_S (State 3)  - Disable all Interrupts.|
-- | |JMPADDR_S (State 4)     - Get the Interrupt Handler from address vector.|
-- | |JMPFETCH2_S (State 6)   - Memory Read Latency|
-- | interruptRun           | Flag indicating that the interrupt is running.|
-- | interruptNum           | Interrupt number being processed (1-31)|
-- | interruptMask          | The Interrupt enable mask (1 is enabled).|
-- | interruptSpAddrValue   | The value of the stack pointer at the starting of the interrupt.|
-- | ProgramCounter         | Program counter (address) of the current executed statement.|

-- #### Internal Wires:

-- | Signal            | Description                                                  |
-- | ----------------- | ------------------------------------------------------------ |
-- |  flag/ffflag             | Multiple use flag (e.g., negative logic)|
-- |  opcode/ffopcode         | Instruction operation|
-- |  memop/ffmemop           | Memory access operation.|
-- |  regop1/iregop1/ffiregop1| Instruction identified first register.|
-- |  ireg1value              | Value of the Register pointed to by instruction.|
-- |  regop2/iregop2/ffiregop2| Instruction identified second register.|
-- |  ireg2value              | Value of the Register pointed to by instruction.|
-- |  immop/ffimmop           | Immediate value from the instruction.|
---------------------------------------------------------------------------

entity MemoryAccess is
    port (
        SYS_CLK : in std_logic;
        INSTRUCTION : in std_logic_vector(31 downto 0);
        cpuRegs : in REG_TYPE;

        fsm_inst_cycle_p : in CYCLETYPE_FSM;
        fsm_interrupt_cycle_p : in INTERRUPT_FSM;
        interruptSPNum : in integer range 0 to 31;
        IOR_DATA : in std_logic_vector(31 downto 0);
        interruptSpAddrValue : in integer range 0 to 2 ** 12 - 1;
        interruptRun : in std_logic;
        interruptNum : in integer range 0 to interruptNums := 0;
        ProgramCounter : in PCTYPE;
        interruptMask : in std_logic_vector(interruptNums downto 0);
        AluRegisterLocked         : in std_logic;

         -- AXI Memory Interface
        ARG_MEMORY_READ_OUT : OUT AXI4_MEMORY_READ_OUT_TYPE_REC := AXI4_MEMORY_READ_OUT_DEFAULTS;
        ARG_MEMORY_READ_IN  : in AXI4_MEMORY_READ_IN_TYPE_REC;
        ARG_MEMORY_WRITE_OUT: OUT AXI4_MEMORY_WRITE_OUT_TYPE_REC := AXI4_MEMORY_WRITE_OUT_DEFAULTS;
        ARG_MEMORY_WRITE_IN : in AXI4_MEMORY_WRITE_IN_TYPE_REC;

        NEXT_CYCLE : out CYCLETYPE_FSM := RESET_STATE_S

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

    signal tempWait : integer := 0;

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

            ARG_MEMORY_READ_OUT <= 
                ClearReadAddress(
                    ARG_MEMORY_READ_OUT, 
                    ARG_MEMORY_READ_IN);

            ARG_MEMORY_READ_OUT <= 
                ClearReadData(
                    ARG_MEMORY_READ_OUT, 
                    ARG_MEMORY_READ_IN);

            ARG_MEMORY_WRITE_OUT <= 
                ClearWriteFlags(
                    ARG_MEMORY_WRITE_OUT, 
                    ARG_MEMORY_WRITE_IN);


            -- Check for any additional processing after the execute state.
            -- This will run concurrent with the next instruction fetch.
            FOR reg IN cpuRegs'RANGE LOOP
                IF cpuRegs(reg).OpCode = oRWIO
                    and cpuRegs(reg).Flag = '0' -- IO Read
                THEN
                    if cpuRegs(reg).MemOp = ABSOLUTE then
                        ARG_MEMORY_WRITE_OUT <= SetWrite (
                            ffimmop(11 downto 0),
                            MEM_ID_ARG,
                            IOR_DATA
                        );
                    elsif cpuRegs(reg).MemOp = INDEX 
                        and cpuRegs(reg).RegOpNum = 2 then
                        ARG_MEMORY_WRITE_OUT <= SetWrite (
                            std_logic_vector(to_unsigned(to_integer(unsigned(ffimmop(11 downto 0))) +
                                to_integer(unsigned(cpuRegs(reg).Value)), 12)),
                            MEM_ID_ARG,
                            IOR_DATA
                        );
                    end if;
                END IF;
            END LOOP;


            case fsm_inst_cycle_p is
                when RESET_STATE_S =>
                    ARG_MEMORY_READ_OUT <= AXI4_MEMORY_READ_OUT_DEFAULTS;
                    ARG_MEMORY_WRITE_OUT <= AXI4_MEMORY_WRITE_OUT_DEFAULTS;
                    ARG_MEMORY_WRITE_OUT.s_axi_bready <= '0';
                    NEXT_CYCLE <= EXECUTE_S;

                when INSTFETCH_S =>

                when DECODE_S =>

                    if AluRegisterLocked = '0' then

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
                        ireg1value <= cpuRegs(iregop1).Value;
                        ireg2value <= cpuRegs(iregop2).Value;

                        case memop is
                            when REGREG =>
                                case opcode is
                                    when oJSR =>
                                        ARG_MEMORY_WRITE_OUT <= SetWrite (
                                            cpuRegs(iregop2).Value(11 downto 0),
                                            MEM_ID_STACK,
                                            X"00000" & std_logic_vector(unsigned(ProgramCounter + 1))
                                        );

                                    when oRTN =>
                                        ARG_MEMORY_READ_OUT <= SetReadAddress(
                                            ARG_MEMORY_READ_OUT,
                                            std_logic_vector(to_unsigned(to_integer(unsigned(cpuRegs(iregop2).Value)) + 1, 12)), 
                                            MEM_ID_STACK);

                                    when oPUSHPOP =>
                                        if flag = '0' then -- Push
                                            ARG_MEMORY_WRITE_OUT <= SetWrite (
                                                cpuRegs(iregop2).Value(11 downto 0),
                                                MEM_ID_STACK,
                                                cpuRegs(iregop1).Value
                                            );

                                        else -- Pop
                                            ARG_MEMORY_READ_OUT <= SetReadAddress(
                                                ARG_MEMORY_READ_OUT,
                                                std_logic_vector(to_unsigned(to_integer(unsigned(cpuRegs(iregop2).Value)) + 1, 12)), 
                                                MEM_ID_STACK);

                                        end if;
                                    when oRTI =>
                                        ARG_MEMORY_READ_OUT <= SetReadAddress(
                                            ARG_MEMORY_READ_OUT,
                                            std_logic_vector(to_unsigned(to_integer(unsigned(cpuRegs(interruptSpNum).Value)) + 1, 12)), 
                                            MEM_ID_STACK);

                                    when others =>
                                end case;
                            when IMMEDIATE =>
                                case opcode is
                                    when oJSR =>
                                        ARG_MEMORY_WRITE_OUT <= SetWrite (
                                            cpuRegs(iregop2).Value(11 downto 0),
                                            MEM_ID_STACK,
                                            X"00000" & std_logic_vector(unsigned(ProgramCounter + 1))
                                        ); 

                                    when oPUSHPOP =>
                                        if flag = '0' then
                                            ARG_MEMORY_WRITE_OUT <= SetWrite (
                                                cpuRegs(iregop2).Value(11 downto 0),
                                                MEM_ID_STACK,
                                                X"0000" & immop
                                            );  

                                        end if;
                                    when others =>
                                end case;
                            when ABSOLUTE =>
                                case opcode is
                                    when oLD | oADD | oSUB | oMul | oDiv | oAND | oOr | oXor | oShlr | oJMP | oBE | oBLT | oBGT | oSWIENA | oRWIO =>
                                        ARG_MEMORY_READ_OUT <= SetReadAddress(
                                            ARG_MEMORY_READ_OUT,
                                            immop(11 downto 0), 
                                            MEM_ID_ARG);

                                    when others =>
                                end case;

                            when INDEX =>
                                case opcode is
                                    when oLD | oADD | oSUB | oMul | oDiv | oAND | oOr | oXor | oShlr | oJMP | oRWIO =>
                                        ARG_MEMORY_READ_OUT <= SetReadAddress(
                                            ARG_MEMORY_READ_OUT,
                                            std_logic_vector(to_unsigned(to_integer(unsigned(immop(11 downto 0))) +
                                                    to_integer(unsigned(cpuRegs(iregop2).Value)), 12)), 
                                            MEM_ID_ARG);

                                    when others =>
                                end case;
                            when others =>
                        end case;
                    end if;
                    NEXT_CYCLE <= MEMFETCH_S;
                    tempWait <= 0;

                when MEMFETCH_S  =>
                    if ARG_MEMORY_READ_IN.s_axi_rvalid = '1' 
                        and (ARG_MEMORY_READ_IN.s_axi_rid = "10"
                            or ARG_MEMORY_READ_IN.s_axi_rid = "11") then
                            NEXT_CYCLE <= EXECUTE_S;
                    else
                        NEXT_CYCLE <= MEMFETCH_S;
                    end if;

                    case ffmemop is
                        when REGREG =>
                            case ffopcode is
                                when oRTI =>
                                    if tempWait = 1 then
                                        tempWait <= 2;
                                        ARG_MEMORY_READ_OUT <= 
                                            SetReadAddress(
                                                ARG_MEMORY_READ_OUT, 
                                                std_logic_vector(to_unsigned(interruptSpAddrValue + 2, 12)), 
                                                MEM_ID_STACK);
                                    elsif tempWait = 0 then
                                        tempWait <= 1;
                                    end if;
                                when others =>
                            end case;
                        when others =>
                    end case;


                when EXECUTE_S =>
                    if AluRegisterLocked = '0' 
                    then
                        case ffmemop is
                            when ABSOLUTE =>
                                case ffopcode is
                                    when oSTR =>
                                        ARG_MEMORY_WRITE_OUT <= SetWrite (
                                            ffimmop(11 downto 0),
                                            MEM_ID_ARG,
                                            ireg1value
                                        );

                                    when oRWIO =>
                                        if ffflag = '0' then
                                            ARG_MEMORY_READ_OUT <= 
                                                SetReadAddress(
                                                    ARG_MEMORY_READ_OUT,
                                                    ffimmop(11 downto 0), 
                                                    MEM_ID_STACK);

                                        end if;
                                    when others =>
                                end case;
                            when INDEX =>
                                case ffopcode is
                                    when oSTR =>
                                        ARG_MEMORY_WRITE_OUT <= SetWrite (
                                            std_logic_vector(to_unsigned(to_integer(unsigned(ffimmop(11 downto 0))) +
                                                        to_integer(unsigned(cpuRegs(ffiregop2).Value)), 12)),
                                            MEM_ID_ARG,
                                            ireg1value
                                        );

                                    when oRWIO =>
                                        if ffflag = '0' then
                                            ARG_MEMORY_READ_OUT <= 
                                                SetReadAddress(
                                                    ARG_MEMORY_READ_OUT,
                                                    std_logic_vector(to_unsigned(to_integer(unsigned(ffimmop(11 downto 0))) +
                                                        to_integer(unsigned(cpuRegs(ffiregop2).Value)), 12)), 
                                                    MEM_ID_STACK);

                                        end if;
                                    when others =>
                                end case;
                            when others =>
                        end case;
                    end if;
                    ARG_MEMORY_READ_OUT <= AXI4_MEMORY_READ_OUT_DEFAULTS;
                when others =>
            end case;



            case fsm_interrupt_cycle_p is
                when SAVEENA_S =>
                    if OkTowrite(ARG_MEMORY_WRITE_IN, ARG_MEMORY_WRITE_OUT) then
                        ARG_MEMORY_WRITE_OUT <= SetWrite (
                            std_logic_vector(to_unsigned(interruptSpAddrValue, 12)),
                            MEM_ID_ARG,
                            interruptMask
                        );
                    end if;

                when DISABLEINT_S =>
                    if OkTowrite(ARG_MEMORY_WRITE_IN, ARG_MEMORY_WRITE_OUT) then
                        ARG_MEMORY_WRITE_OUT <= SetWrite (
                            std_logic_vector(to_unsigned(interruptSpAddrValue - 1, 12)),
                            MEM_ID_ARG,
                            X"00000" & std_logic_vector(unsigned(ProgramCounter))
                        );
                    end if;

                when JMPADDR_S =>
                    ARG_MEMORY_READ_OUT <= 
                        SetReadAddress(
                            ARG_MEMORY_READ_OUT, 
                            "0000000" & std_logic_vector(to_unsigned(interruptNum, 5)), 
                            MEM_ID_ARG);

                when JMPFETCH_S =>
                    null;
                when others =>
                    null;
            end case;
        end if;
    end process memoryAccess_proc;

end Behavioral;