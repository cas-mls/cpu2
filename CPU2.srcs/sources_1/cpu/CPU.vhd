-- vhdl-linter-disable type-resolved not-declared
----------------------------------------------------------------------------------
-- Company:
-- Engineer: Craig Shannon
--
-- Create Date: 11/29/2023 05:57:00 PM
-- Design Name:
-- Module Name: CPU - Behavioral
-- Project Name: Craig's CPU
-- Target Devices: Arty S7
-- Tool Versions: Viviado
-- Description:
--
-- Dependencies: Block Memory Generator
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

library UNISIM;
use UNISIM.VComponents.all;

-------------------------------------------------------------------------------
-- ### CPU

-- The operation cycles are in the following order: ADDRESS, INSTFETCH1, INSTFETCH2, DECODE, MEMFETCH1, MEMFETCH2, EXECUTE, and CLEANUP.  Some instructions do not use all of the cycles.  Example: the MEMFETCH1only is used during Read / Write IO operations, other operations completely skipped this cycle.  Another exception MEMFETCH1 and MEMFETCH2 cycles are skipped when the operation is not a Memory read (Access / Memory operations 2 and 3).

-- During each cycle, the Access (Memory) value is selected (Case statement) and then the Opcode is selected (Case).  This is opposite to the normal method of CPU operation (Opcode first, Memory second).

-- #### Wire Assignments (outputs)

-- | Signal    | Description                                                  |
-- | --------- | ------------------------------------------------------------ |
-- | IO_ADDR   | Address of the IO peripheral.                                |
-- | IOW_DATA  | Data to be written to the peripheral.                        |
-- | IOW_ENA   | Flag indicating the transfer of data from CPU to peripheral. |
-- | IOR_ENA   | Flag indicating the data needs to be transferred from peripheral to CPU. |
-- | MEM_ENA   | Enable at Address and disable during the Decode for branches. |
-- | MEM_WEA   | Always 0 (Read Only)                                         |
-- | MEM_ADDRA | The address to Read or Write memory.                         |
-- | MEM_ENB   | The Instruction Memory enabled.                              |
-- | MEM_WEB   | The Instruction Memory Read/Write.                           |
-- | MEM_ADDRB | The Instruction address to Read or Write memory.             |
-- | MEM_DINB  | The Instruction input data.                                  |

-- #### Used Wires (inputs):

-- | Signal    | Description                               |
-- | --------- | ----------------------------------------- |
-- | IOR_DATA  | Data from the peripheral device.          |
-- | IO_STATUS | The IO status from the peripheral device. |
-- | INTERRUPT | The Interrupt vector                      |
-- | MEM_DINB  | Instruction operation.                    |
-- | MEM_DINB  | The Instruction input data.               |

-- #### Internal Wires:

-- | Signal                              | Description                                                  |
-- | ----------------------------------- | ------------------------------------------------------------ |
-- | Program Counter                     | Program counter (address) of the current executed statement. |
-- | fsm_inst_cycle_p / fsm_inst_cycle_n | Instruction finite state model (See below)                   |
-- | flag/ffflag                         | Multiple use flag (e.g., negative logic)                     |
-- | opcode/ffopcode                     | Instruction operation                                        |
-- | memop/ffmemop                       | Memory access operation.                                     |
-- | regop1/iregop1/ffiregop1            | Instruction identified first register.                       |
-- | ireg1value                          | Value of the Register pointed to by instruction.             |
-- | regop2/iregop2/ffiregop2            | Instruction identified second register.                      |
-- | ireg2value                          | Value of the Register pointed to by instruction.             |
-- | immop/ffimmop                       | Immediate value from the instruction.                        |
-- | cpuRegs                             | The fast CPU registers.                                      |
-- | fsm_interrupt_cycle_p               | Interrupt finite state model                                 |
-- | interruptRun                        | Flag indicating that the interrupt is running.               |
-- | interruptNum                        | Interrupt number being processed (1-31)                      |
-- | interruptMask                       | The Interrupt enable mask (1 is enabled).                    |
-- | interruptSpNum                      | The stack pointer register.                                  |
-- | interruptSpAddrValue                | The value of the stack pointer at the starting of the interrupt. |
-- | waitRun                             | This is active when it is in a wait state.                   |
-- | waitAlarm                           | The alarm happens when the wait timer is completed.          |
-- | waitCancel                          | This cancels the wait state.                                 |
-- | timerAlarm                          | This alarm happens when the timer is completed.              |
-- | timerInt                            | The interrupt number is to be processed when the timer alarm goes off. |

-- #### Instruction State Diagram

-- | Cycle      | Description                                                  |
-- | ---------- | ------------------------------------------------------------ |
-- | ADDRESS    | Sets the instruction address.<br />Start interrupt processing |
-- | INSTFETCH1 | Wait for instruction data.                                   |
-- | INSTFETCH2 | Wait for instruction data.                                   |
-- | DECODE     | Instruction Data is available and the Instruction is separated into different fields.<br/>The main purpose is to get the values required to perform the operations.  For Memory operations 0 (Register/Register), the register values are obtained.  For Memory Operation 1 the Registers and the Immediate values.  For Memory Operation 2, the Immediate value is used as the Memory address.  For Memory Operation 3, the Register and the Immediate values are added and used as the Memory address. |
-- | MEMFETCH1  | Wait for Access (Memory) types 2 and 3.<br />The Return from Interrupt (RTI) operation reads the stack for the Interrupt Mask. |
-- | MEMFETCH2  | Wait for Read for Access (Memory) types 2 and 3.             |
-- | EXECUTE    | Perform the operations.                                      |
-- | CLEANUP    | Perform additional items after Execute.  Read and Write operations are the only operations that use this cycle state to reset the enable flag. |




-- ```mermaid
-- stateDiagram
--     [*] --> ADDRESS_S : Reset
--     ADDRESS_S --> INSTFETCH1_S
--     INSTFETCH1_S --> INSTFETCH2_S
--     INSTFETCH2_S --> DECODE_S
--     DECODE_S --> MEMFETCH1_S : addr modes 2 & 3
--     MEMFETCH1_S --> MEMFETCH2_S
--     MEMFETCH2_S --> EXECUTE_S
--     DECODE_S --> EXECUTE_S : addr modes 0 & 1
--     EXECUTE_S --> ADDRESS_S : jumps & branches
--     EXECUTE_S --> CLEANUP_S : rio & wio
--     EXECUTE_S --> DECODE_S : addr modes 2 & 3
--     EXECUTE_S --> INSTFETCH2_S : addr modes 0 & 1
--     CLEANUP_S --> ADDRESS_S

-- ```
-------------------------------------------------------------------------------

entity CPU is
    port (
        SYS_CLK : in std_logic;
        IO_ADDR : out std_logic_vector (7 downto 0);
        IOR_DATA : in std_logic_vector (31 downto 0);
        IOW_DATA : out std_logic_vector (31 downto 0);
        IOR_ENA : out std_logic;
        IOW_ENA : out std_logic;
        IO_STATUS : in std_logic_vector (31 downto 0);
        IO_STATUS_REQ : out std_logic;
        INTERRUPT : in std_logic_vector (31 downto 0);
        -- AXI Memory Interface
        AXI4_MEMORY_READ_OUT : out AXI4_MEMORY_READ_OUT_TYPE_REC;
        AXI4_MEMORY_READ_IN : in AXI4_MEMORY_READ_IN_TYPE_REC;
        AXI4_MEMORY_WRITE_OUT : out AXI4_MEMORY_WRITE_OUT_TYPE_REC;
        AXI4_MEMORY_WRITE_IN : in AXI4_MEMORY_WRITE_IN_TYPE_REC;
        
        -- DEBUG
        DEBUGIN     : in DEBUGINTYPE := DEBUGIN_DEFAULTS;
        DEBUGOUT    : out DEBUGOUTTYPE
    );

end CPU;

architecture Behavioral of CPU is

    component ALU is
        port (
            SYS_CLK              : in std_logic;
            INSTRUCTION          : in std_logic_vector(31 downto 0);
            MEM_ARG              : in std_logic_vector(31 downto 0);
            STACK_ARG            : in  STD_LOGIC_VECTOR(31 downto 0);
            fsm_inst_cycle_p     : in CYCLETYPE_FSM;
            fsm_interrupt_cycle_p: in INTERRUPT_FSM;
            interruptSpNum       : in integer range 0 to 31;
            IOR_DATA             : in std_logic_vector(31 downto 0);
            IO_STATUS            : in std_logic_vector(31 downto 0);
            interruptSpAddrValue : in integer range 0 to 2 ** 12 - 1;
            statusWord           : out STATUS_WORD_TYPE;
            cpuRegs              : out REG_TYPE;
            AluRegisterLocked    : out std_logic;

            DEBUGIN              : in DEBUGINTYPE := DEBUGIN_DEFAULTS
            );

    end component;

    component MemoryAccess is
        port (
            SYS_CLK    : in std_logic;
            INSTRUCTION: in std_logic_vector(31 downto 0);
            cpuRegs    : in REG_TYPE;

            fsm_inst_cycle_p     : in CYCLETYPE_FSM;
            fsm_interrupt_cycle_p: in INTERRUPT_FSM;
            interruptSPNum       : in integer range 0 to 31;
            IOR_DATA             : in std_logic_vector(31 downto 0);
            interruptSpAddrValue : in integer range 0 to 2 ** 12 - 1;
            interruptRun         : in std_logic;
            interruptNum         : in integer range 0 to interruptNums := 0;
            ProgramCounter       : in PCTYPE;
            interruptMask        : in std_logic_vector(interruptNums downto 0);
            AluRegisterLocked    : in std_logic;

                -- AXI Memory Interface
            ARG_MEMORY_READ_OUT : OUT AXI4_MEMORY_READ_OUT_TYPE_REC;
            ARG_MEMORY_READ_IN  : in AXI4_MEMORY_READ_IN_TYPE_REC;
            ARG_MEMORY_WRITE_OUT: OUT AXI4_MEMORY_WRITE_OUT_TYPE_REC;
            ARG_MEMORY_WRITE_IN : in AXI4_MEMORY_WRITE_IN_TYPE_REC;

            NEXT_CYCLE : out CYCLETYPE_FSM := RESET_STATE_S
        );
    end component;

    component ProgCounter is
        port (
            SYS_CLK    : in std_logic;
            INSTRUCTION: in std_logic_vector(31 downto 0);
            cpuRegs    : in REG_TYPE;

            fsm_inst_cycle_p     : in CYCLETYPE_FSM;
            fsm_inst_cycle_n      : IN CYCLETYPE_FSM;
            fsm_interrupt_cycle_p: in INTERRUPT_FSM;
            MEM_ARG              : in std_logic_vector(31 downto 0);
            STACK_ARG             : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

            -- AXI Memory Interface
            PC_Memory_OUT: OUT AXI4_MEMORY_READ_OUT_TYPE_REC;
            PC_Memory_IN : IN AXI4_MEMORY_READ_IN_TYPE_REC;

            ARG_MEMORY_READ_OUT : in AXI4_MEMORY_READ_OUT_TYPE_REC;
            ARG_MEMORY_READ_IN  : in AXI4_MEMORY_READ_IN_TYPE_REC;

            ProgramCounter    : out PCTYPE;
            JumpDisablePipline: out std_logic := '0';
            AluRegisterLocked : in std_logic;
            DEBUGIN           : in DEBUGINTYPE := DEBUGIN_DEFAULTS

        );
    end component ProgCounter;

    component IoProcess is
        port (
            SYS_CLK         : in std_logic;
            INSTRUCTION     : in std_logic_vector(31 downto 0);
            cpuRegs         : in REG_TYPE;
            MEM_ARG         : in std_logic_vector(31 downto 0);
            fsm_inst_cycle_p: in CYCLETYPE_FSM;

            IOW_ENA      : out std_logic;
            IOR_ENA      : out std_logic;
            IO_ADDR      : out std_logic_vector (7 downto 0);
            IOW_DATA     : out std_logic_vector (31 downto 0);
            IO_STATUS_REQ: out std_logic

        );
    end component IoProcess;

    component WaitTimer is
        port (
            SYS_CLK         : in std_logic;
            INSTRUCTION     : in std_logic_vector(31 downto 0);
            cpuRegs         : in REG_TYPE;
            fsm_inst_cycle_p: in CYCLETYPE_FSM;

            waitAlarm : out std_logic;
            waitRun   : out std_logic;
            waitCancel: out std_logic;
            timerAlarm: out std_logic;
            timerInt  : out unsigned (4 downto 0)

        );
    end component WaitTimer;

    component Interrupt_Entity is
        port (
            SYS_CLK         : in std_logic;
            INSTRUCTION     : in std_logic_vector(31 downto 0);
            cpuRegs         : in REG_TYPE;
            fsm_inst_cycle_p: in CYCLETYPE_FSM;
            MEM_ARG         : in std_logic_vector(31 downto 0);
            STACK_ARG       : in  STD_LOGIC_VECTOR(31 downto 0);
            INTERRUPT       : in std_logic_vector (31 downto 0);
            timerAlarm      : in std_logic;
            timerInt        : in unsigned (4 downto 0);
            statusWord      : in STATUS_WORD_TYPE;

            fsm_interrupt_cycle_p: out INTERRUPT_FSM;
            interruptRun         : out std_logic := '0';
            interruptNum         : out integer range 0 to interruptNums := 0;
            interruptMask        : out std_logic_vector(interruptNums downto 0) := X"00000000";
            interruptSpNum       : out integer range 0 to interruptNums;
            interruptSpAddrValue : out integer range 0 to 2 ** 12 - 1;
            interruptReset       : out STD_LOGIC := '0';
            statusMask           : out std_logic_vector(31 downto 0) := X"00000000";

            AXI4_MEMORY_READ_OUT : in AXI4_MEMORY_READ_OUT_TYPE_REC := AXI4_MEMORY_READ_OUT_DEFAULTS;
            AXI4_MEMORY_READ_IN  : in AXI4_MEMORY_READ_IN_TYPE_REC;
            AXI4_MEMORY_WRITE_OUT: in AXI4_MEMORY_WRITE_OUT_TYPE_REC := AXI4_MEMORY_WRITE_OUT_DEFAULTS;
            AXI4_MEMORY_WRITE_IN : in AXI4_MEMORY_WRITE_IN_TYPE_REC;

            DEBUGIN            : in DEBUGINTYPE := DEBUGIN_DEFAULTS
            );
    end component Interrupt_Entity;

    component cpu_debug is
        port(
            SYS_CLK            : in STD_LOGIC;
            INSTRUCTION        : in STD_LOGIC_VECTOR(31 downto 0);
            fsm_inst_cycle_p   : in CYCLETYPE_FSM;
            programCounter     : in PCTYPE;
            cpuRegs            : in REG_TYPE;
            MEM_ARG            : in STD_LOGIC_VECTOR(31 downto 0);
            interruptNum       : in integer range 0 to interruptNums;
            interruptMask      : in STD_LOGIC_VECTOR(interruptNums downto 0);
            statusWord         : in STATUS_WORD_TYPE := (others => '0');
            statusMask         : in STD_LOGIC_VECTOR(31 downto 0);
            debugDisablePipline: out STD_LOGIC;
            DebugStart         : out STD_LOGIC;
            DEBUGIN            : in DEBUGINTYPE := DEBUGIN_DEFAULTS;
            DEBUGOUT           : out DEBUGOUTTYPE
        );
    end component;

    signal ProgramCounter : PCTYPE          := X"000";
    signal fsm_inst_cycle_p : CYCLETYPE_FSM := RESET_STATE_S;
    signal fsm_inst_cycle_n : CYCLETYPE_FSM := RESET_STATE_S;
    signal JumpDisablePipline : std_logic   := '0';
    signal AluRegisterLocked : std_logic    := '0';

    -- Memory Interface
    signal MEM_INST              : std_logic_vector(31 downto 0) := X"00000000";
    signal axi4PcMemoryReadOut   : AXI4_MEMORY_READ_OUT_TYPE_REC;
    signal axi4PcMemoryReadIn    : AXI4_MEMORY_READ_IN_TYPE_REC;
    signal axi4DataMemoryReadOut : AXI4_MEMORY_READ_OUT_TYPE_REC;
    signal axi4DataMemoryReadIn  : AXI4_MEMORY_READ_IN_TYPE_REC;
    signal axi4DataMemoryWriteOut: AXI4_MEMORY_WRITE_OUT_TYPE_REC;
    signal MEM_ARG             : std_logic_vector(31 downto 0) := X"00000000";
    signal STACK_ARG           : std_logic_vector(31 downto 0) := X"00000000";
    signal MEM_NEXT_CYCLE        : CYCLETYPE_FSM := RESET_STATE_S;

    -- Decode information
    signal opcode   : OPCODETYPE := "00000";
    signal ffopcode : OPCODETYPE := "00000";
    signal flag     : std_logic := '0';
    signal ffflag   : std_logic := '0';
    signal memop    : MEMTYPE;
    signal ffmemop  : MEMTYPE;
    signal regop1   : REGTYPE;
    signal iregop1  : integer range 0 to regOpMax;
    signal ffiregop1: integer range 0 to regOpMax;
    signal regop2   : REGTYPE;
    signal iregop2  : integer range 0 to regOpMax;
    signal ffiregop2: integer range 0 to regOpMax;
    signal immop    : IMMTYPE;
    signal ffimmop  : IMMTYPE;

    -- Register information
    signal cpuRegs : REG_TYPE := (others => REG_DEFAULTS);

    -- interrupts
    signal fsm_interrupt_cycle_p: INTERRUPT_FSM := INTRWAIT_S;
    signal interruptRun         : std_logic := '0';
    signal interruptNum         : integer range 0 to interruptNums := 0;
    signal interruptMask        : std_logic_vector(interruptNums downto 0) := X"00000000";
    signal interruptSpNum       : integer range 0 to interruptNums;
    signal interruptSpAddrValue : integer range 0 to 2 ** 12 - 1;
    signal interruptReset       : STD_LOGIC                 := '0';
    signal statusMask           : std_logic_vector(31 downto 0) := X"00000000";

    signal waitRun      : std_logic := '0';
    signal waitAlarm    : std_logic := '0';
    signal waitCancel   : std_logic := '0';

    signal timerAlarm : std_logic           := '0';
    signal timerInt : unsigned (4 downto 0) := "00000";

    -- Status Word
    signal statusWord  : STATUS_WORD_TYPE;

    -- DEBUG
    signal DebugDisablePipline : STD_LOGIC := '0';
    signal DebugStart : STD_LOGIC          := '0';

    -- Help with ILA debugging by flattening the Wires.
    -- attribute keep : string;
    -- attribute MARK_DEBUG : string;
    -- attribute keep of cpuRegs : signal is "TRUE";
    -- attribute MARK_DEBUG of cpuRegs : signal is "TRUE";
    -- attribute keep of fsm_inst_cycle_p : signal is "TRUE";
    -- attribute MARK_DEBUG of fsm_inst_cycle_p : signal is "TRUE";
    -- attribute keep of ProgramCounter : signal is "TRUE";
    -- attribute MARK_DEBUG of ProgramCounter : signal is "TRUE";

    -- CPU Debugging ILA
    -- attribute keep of DebugDisablePipline : signal is "TRUE";
    -- attribute MARK_DEBUG of DebugDisablePipline : signal is "TRUE";
    -- attribute keep of DebugStart : signal is "TRUE";
    -- attribute MARK_DEBUG of DebugStart : signal is "TRUE";



begin

    -- MEM_INST <= MEM_DOUTA;
    MEM_INST <= axi4PcMemoryReadIn.s_axi_rdata 
        when (axi4PcMemoryReadIn.s_axi_rvalid = '1') 
            and (axi4PcMemoryReadIn.s_axi_rid = "01")
            and (fsm_inst_cycle_p = DECODE_S)
        else (others => '0');
    -- 
    MEM_ARG <= AXI4_MEMORY_READ_IN.s_axi_rdata 
        when (AXI4_MEMORY_READ_IN.s_axi_rvalid = '1') 
            and (AXI4_MEMORY_READ_IN.s_axi_rid = "10")
            and (fsm_inst_cycle_p = EXECUTE_S
                or fsm_inst_cycle_p = WAITS_S)
        else (others => '0');

    STACK_ARG <= AXI4_MEMORY_READ_IN.s_axi_rdata 
        when (AXI4_MEMORY_READ_IN.s_axi_rvalid = '1') 
            and (AXI4_MEMORY_READ_IN.s_axi_rid = "11")
            and (fsm_inst_cycle_p = EXECUTE_S 
                or fsm_inst_cycle_p = MEMFETCH_S)
        else (others => '0');

    
    opcode  <= MEM_INST(31 downto 27);
    flag    <= MEM_INST(26);
    memop   <= MEM_INST(25 downto 24);
    regop1  <= MEM_INST(23 downto 20);
    regop2  <= MEM_INST(19 downto 16);
    immop   <= MEM_INST(15 downto 0);
    iregop1 <= to_integer(unsigned(regop1));
    iregop2 <= to_integer(unsigned(regop2));


    AXI4_MEMORY_READ_OUT <= axi4PcMemoryReadOut
            when axi4PcMemoryReadOut.s_axi_arid = "01"
            else axi4DataMemoryReadOut
                when axi4DataMemoryReadOut.s_axi_arid = "10"
                    or axi4DataMemoryReadOut.s_axi_arid = "11"
            else AXI4_MEMORY_READ_OUT_DEFAULTS;

    axi4DataMemoryReadIn <= AXI4_MEMORY_READ_IN 
        when AXI4_MEMORY_READ_IN.s_axi_rid = "10"
            or AXI4_MEMORY_READ_IN.s_axi_rid = "11"
        else AXI4_MEMORY_READ_IN_DEFAULTS;

     axi4PcMemoryReadIn <= AXI4_MEMORY_READ_IN 
        when AXI4_MEMORY_READ_IN.s_axi_rid = "01"
        else AXI4_MEMORY_READ_IN_DEFAULTS;

    AXI4_MEMORY_WRITE_OUT <= axi4DataMemoryWriteOut;

    alu_entity : alu
    port map(
           SYS_CLK               => SYS_CLK,
           INSTRUCTION           => MEM_INST,
           MEM_ARG               => MEM_ARG,
           STACK_ARG             => STACK_ARG,
           fsm_inst_cycle_p      => fsm_inst_cycle_p,
           fsm_interrupt_cycle_p => fsm_interrupt_cycle_p,
           interruptSpNum        => interruptSpNum,
           IOR_DATA              => IOR_DATA,
           IO_STATUS             => IO_STATUS,
           interruptSpAddrValue  => interruptSpAddrValue,
           statusWord            => statusWord,
           cpuRegs               => cpuRegs,
           AluRegisterLocked     => AluRegisterLocked,
           DebugIn               => DEBUGIN
    );

    memoryAccess_enity : MemoryAccess
    port map(
        SYS_CLK     => SYS_CLK,
        INSTRUCTION => MEM_INST,
        cpuRegs     => cpuRegs,

        fsm_inst_cycle_p      => fsm_inst_cycle_p,
        fsm_interrupt_cycle_p => fsm_interrupt_cycle_p,
        interruptSPNum        => interruptSPNum,
        IOR_DATA              => IOR_DATA,
        interruptSpAddrValue  => interruptSpAddrValue,
        interruptRun          => interruptRun,
        interruptNum          => interruptNum,
        ProgramCounter        => ProgramCounter,
        interruptMask         => interruptMask,
        AluRegisterLocked     => AluRegisterLocked,

        ARG_MEMORY_READ_OUT  => axi4DataMemoryReadOut,
        ARG_MEMORY_READ_IN   => axi4DataMemoryReadIn,
        ARG_MEMORY_WRITE_OUT => axi4DataMemoryWriteOut,
        ARG_MEMORY_WRITE_IN  => AXI4_MEMORY_WRITE_IN,
        NEXT_CYCLE          => MEM_NEXT_CYCLE
    );

    progCounter_enty : ProgCounter
    port map(
        SYS_CLK => SYS_CLK,
        INSTRUCTION => MEM_INST,
        cpuRegs => cpuRegs,

        fsm_inst_cycle_p => fsm_inst_cycle_p,
        fsm_inst_cycle_n => fsm_inst_cycle_n,
        fsm_interrupt_cycle_p => fsm_interrupt_cycle_p,
        MEM_ARG => MEM_ARG,
        STACK_ARG             => STACK_ARG,

        -- AXI Memory Interface
        PC_Memory_OUT => axi4PcMemoryReadOut,
        PC_Memory_IN => axi4PcMemoryReadIn,

        ARG_MEMORY_READ_OUT  => axi4DataMemoryReadOut,
        ARG_MEMORY_READ_IN   => axi4DataMemoryReadIn,


        ProgramCounter => ProgramCounter,
        JumpDisablePipline => JumpDisablePipline,
        AluRegisterLocked => AluRegisterLocked,
        DebugIn => DEBUGIN
    );

    IoProcess_enty : IoProcess
    port map(
        SYS_CLK => SYS_CLK,
        INSTRUCTION => MEM_INST,
        cpuRegs => cpuRegs,
        MEM_ARG => MEM_ARG,

        fsm_inst_cycle_p => fsm_inst_cycle_p,

        IOW_ENA => IOW_ENA,
        IOR_ENA => IOR_ENA,
        IO_ADDR => IO_ADDR,
        IOW_DATA => IOW_DATA,
        IO_STATUS_REQ => IO_STATUS_REQ
    );

    WaitTimer_enty : WaitTimer
    port map(
        SYS_CLK => SYS_CLK,
        INSTRUCTION => MEM_INST,
        cpuRegs => cpuRegs,

        fsm_inst_cycle_p => fsm_inst_cycle_p,

        waitAlarm => waitAlarm,
        waitRun => waitRun,
        waitCancel => waitCancel,
        timerAlarm => timerAlarm,
        timerInt => timerInt
    );

    Interrupt_enty : Interrupt_Entity
    port map(
        SYS_CLK => SYS_CLK,
        INSTRUCTION => MEM_INST,
        cpuRegs => cpuRegs,
        fsm_inst_cycle_p => fsm_inst_cycle_p,
        MEM_ARG => MEM_ARG,
        STACK_ARG => STACK_ARG,
        INTERRUPT => INTERRUPT,
        timerAlarm => timerAlarm,
        timerInt => timerInt,
        statusWord => statusWord,

        fsm_interrupt_cycle_p => fsm_interrupt_cycle_p,
        interruptRun => interruptRun,
        interruptNum => interruptNum,
        interruptMask => interruptMask,
        interruptSpNum => interruptSpNum,
        interruptSpAddrValue => interruptSpAddrValue,
        interruptReset => interruptReset,
        statusMask => statusMask,
        AXI4_MEMORY_READ_OUT => AXI4_MEMORY_READ_OUT,
        AXI4_MEMORY_READ_IN  => AXI4_MEMORY_READ_IN,
        AXI4_MEMORY_WRITE_OUT=> AXI4_MEMORY_WRITE_OUT,
        AXI4_MEMORY_WRITE_IN => AXI4_MEMORY_WRITE_IN,
        DebugIn => DEBUGIN
    );

    cpu_debug_enty : cpu_debug
    port map(
        SYS_CLK => SYS_CLK,
        INSTRUCTION => MEM_INST,
        fsm_inst_cycle_p => fsm_inst_cycle_p,
        programCounter => ProgramCounter,
        cpuRegs => cpuRegs,
        MEM_ARG => MEM_ARG,
        interruptNum => interruptNum,
        interruptMask => interruptMask,
        statusWord => statusWord,
        statusMask => statusMask,
        debugDisablePipline => DebugDisablePipline,
        DebugStart => DebugStart,
        DEBUGIN => DEBUGIN,
        DEBUGOUT => DEBUGOUT
    );

    instruction_fsm_Proc : process (SYS_CLK)
    begin
        if rising_edge (SYS_CLK) then
            if INTERRUPT(ResetIntPos) = '1' 
                or interruptReset = '1' 
                or DEBUGOUT.Reset = '1' 
            then
                fsm_inst_cycle_p <= RESET_STATE_S;
            else
                if interruptRun = '1' then
                    fsm_inst_cycle_p <= WAITS_S;
                else
                    fsm_inst_cycle_p <= fsm_inst_cycle_n;
                end if;
            end if;
        end if;
    end process;

    instruction_Proc : process (
        fsm_inst_cycle_p,
        opcode,
        ffopcode,
        ffflag,
        flag,
        memop,
        waitAlarm,
        waitCancel,
        interruptRun,
        DEBUGOUT.Stopped,
        DebugStart,
        fsm_interrupt_cycle_p,
        AluRegisterLocked,
        axi4PcMemoryReadIn.s_axi_rvalid,
        axi4PcMemoryReadIn.s_axi_rid,
        axi4PcMemoryReadOut.s_axi_rready,
        axi4PcMemoryReadOut.s_axi_arid,
        axi4DataMemoryReadIn.s_axi_rvalid,
        axi4DataMemoryReadIn.s_axi_rid,
        axi4DataMemoryReadOut.s_axi_rready,
        axi4DataMemoryReadOut.s_axi_arid,
        MEM_NEXT_CYCLE

        )
    begin

        case fsm_inst_cycle_p is
                -- CPU RESET
            when RESET_STATE_S =>
                fsm_inst_cycle_n <= WAITS_S;

                ----------------------------------------------------------------
                -- This is the Cycle to wait for the Fetch Instruction Memory
            when INSTFETCH_S =>
                if IsReadDataValid(axi4PcMemoryReadIn, axi4PcMemoryReadOut, MEM_ID_PC) then
                    fsm_inst_cycle_n <= DECODE_S;
                else
                    fsm_inst_cycle_n <= INSTFETCH_S;
                end if;

                ----------------------------------------------------------------
                -- Decoding is completed in the combinatorial logic and should only be used in this cycle.
                --       (opcode, memop, flag, iregop1, iregop2, and immop)
                -- Set up memory address for ABSOLUTE and INDEX
            when DECODE_S =>
                case memop is
                    when REGREG =>
                        case opcode is
                            when oJSR =>
                                if DebugStart = '1' then
                                    fsm_inst_cycle_n <= DEBUGSTABLEIZE_S;
                                else
                                    fsm_inst_cycle_n <= EXECUTE_S;
                                end if;
                            when oRTN | oRTI =>
                                fsm_inst_cycle_n <= MEMFETCH_S;
                            when oRWIO | oIOST =>
                                fsm_inst_cycle_n <= EXECUTE_S;
                            when oPUSHPOP =>
                                if flag = '0' then
                                    if DebugStart = '1' then
                                        fsm_inst_cycle_n <= DEBUGSTABLEIZE_S;
                                    else
                                        fsm_inst_cycle_n <= EXECUTE_S;
                                    end if;
                                else
                                    fsm_inst_cycle_n <= MEMFETCH_S;
                                end if;
                            when others =>
                                if DebugStart = '1' then
                                    fsm_inst_cycle_n <= DEBUGSTABLEIZE_S;
                                else
                                    fsm_inst_cycle_n <= EXECUTE_S;
                                end if;
                        end case;
                    when IMMEDIATE =>
                        case opcode is
                            when oJSR =>
                                if DebugStart = '1' then
                                    fsm_inst_cycle_n <= DEBUGSTABLEIZE_S;
                                else
                                    fsm_inst_cycle_n <= EXECUTE_S;
                                end if;
                            when oRWIO | oIOST=>
                                fsm_inst_cycle_n <= EXECUTE_S;
                            when oPUSHPOP =>
                                if flag = '0' then
                                    if DebugStart = '1' then
                                        fsm_inst_cycle_n <= DEBUGSTABLEIZE_S;
                                    else
                                        fsm_inst_cycle_n <= EXECUTE_S;
                                    end if;
                                else
                                    fsm_inst_cycle_n <= INSTFETCH_S; -- Should not happen
                                end if;
                            when others =>
                                if DebugStart = '1' then
                                    fsm_inst_cycle_n <= DEBUGSTABLEIZE_S;
                                else
                                    fsm_inst_cycle_n <= EXECUTE_S;
                                end if;
                        end case;
                    when ABSOLUTE =>
                        case opcode is
                            when oLD | oADD | oSUB | oMul | oDiv | oAND | oOr | oXor | oShlr | oJMP | oBE | oBLT | oBGT | oSWIENA | oRWIO =>
                                fsm_inst_cycle_n <= MEMFETCH_S;
                            when others =>
                                if DebugStart = '1' then
                                    fsm_inst_cycle_n <= DEBUGSTABLEIZE_S;
                                else
                                    fsm_inst_cycle_n <= EXECUTE_S;
                                end if;
                        end case;
                    when INDEX =>
                        case opcode is
                            when oLD | oADD | oSUB | oMul | oDiv | oAND | oOr | oXor | oShlr | oJMP | oRWIO =>
                                fsm_inst_cycle_n <= MEMFETCH_S;
                            when others =>
                                if DebugStart = '1' then
                                    fsm_inst_cycle_n <= DEBUGSTABLEIZE_S;
                                else
                                    fsm_inst_cycle_n <= EXECUTE_S;
                                end if;
                        end case;
                    when others =>
                        if DebugStart = '1' then
                            fsm_inst_cycle_n <= DEBUGSTABLEIZE_S;
                        else
                            fsm_inst_cycle_n <= EXECUTE_S;
                        end if;
                end case;
            ----------------------------------------------------------------
            -- Cycle to wait for memory to be read.
            -- ABSOLUTE and INDEX operations.
            when MEMFETCH_S =>
                if DebugStart = '1' then
                    fsm_inst_cycle_n <= DEBUGSTABLEIZE_S;
                else
                    fsm_inst_cycle_n <= MEM_NEXT_CYCLE;
                end if;



                ----------------------------------------------------------------
                -- Execute intruction
            when EXECUTE_S =>

                if AluRegisterLocked = '1' then
                    fsm_inst_cycle_n <= EXECUTE_S;
                else

                    if ffopcode = oWAIT then
                        if ffflag = '0' -- Wait, Not Cancel
                        then
                            if ffiregop2 = 0 -- Wait, Not Timer
                            then -- Specific requirement for only WAIT
                                fsm_inst_cycle_n <= WAITS_S;
                            else
                                fsm_inst_cycle_n <= INSTFETCH_S;
                            end if;
                        else
                            fsm_inst_cycle_n <= INSTFETCH_S;
                        end if;

                    elsif opcode = oRTI and waitRun = '1' then
                        fsm_inst_cycle_n <= WAITS_S;

                    else -- All other operations.
                        fsm_inst_cycle_n <= INSTFETCH_S;
                    end if;
                end if;

            when WAITS_S =>
                if waitAlarm = '1'
                    or waitCancel = '1'
                    or fsm_interrupt_cycle_p = DONE_S
                then
                    fsm_inst_cycle_n <= DECODE_S;
                else
                    fsm_inst_cycle_n <= WAITS_S;
                end if;

            ----------------------------------------------------------------
            -- This is set when the DEBUG.Stopped is set and the next cycle
            -- would be the Execute cycle.
            when DEBUGSTABLEIZE_S =>
                if DebugStart = '1' then -- This shouldn't happen.  But, it does ignore debug.
                    fsm_inst_cycle_n <= DEBUGWAIT_S;
                else
                    fsm_inst_cycle_n <= EXECUTE_S;
                end if;

            when DEBUGWAIT_S =>
            if DEBUGOUT.Stopped = '0' then
                fsm_inst_cycle_n <= EXECUTE_S;
            else
                fsm_inst_cycle_n <= DEBUGWAIT_S;
            end if;

            when others =>
                fsm_inst_cycle_n <= INSTFETCH_S;
        end case;
    end process;

    decode_Proc : process (SYS_CLK)
    begin
        if rising_edge (SYS_CLK) then
            if fsm_inst_cycle_p = DECODE_S
                then
                -- Maintain Flip-Flop (Memory) portions of the instruction.
                -- This removes the timing violations and make the processor faster.
                -- Might remove the combinatorial logic which should not be used after this cycle.
                ffopcode <= opcode;
                ffmemop <= memop;
                ffflag <= flag;
                ffiregop1 <= iregop1;
                ffiregop2 <= iregop2;
                ffimmop <= immop;
            end if;
        end if;

    end process decode_Proc;

end Behavioral;