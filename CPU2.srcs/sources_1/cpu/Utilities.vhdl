----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/04/2023 12:23:45 PM
-- Design Name: 
-- Module Name: Utilities - Package
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

use IEEE.STD_LOGIC_1164.ALL;


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;

package Utilities is

    -- Constants
    constant regOpSizeBits : integer := 4;
    constant regOpMax  : integer := 2**regOpSizeBits-1;

    type CYCLETYPE_FSM is (
        RESET_STATE_S,  -- State 0
        DUMMY1_S,       -- State 1
        DUMMY3_S,       -- State 2
        INSTFETCH_S,    -- State 3
        DECODE_S,       -- State 4
        DUMMY4_S,       -- State 5
        MEMFETCH_S,     -- State 6
        EXECUTE_S,      -- State 7
        DUMMY2_S,       -- State 8
        WAITS_S,        -- State 9
        DEBUGSTABLEIZE_S,-- State 10
        DEBUGWAIT_S     -- State 11
        );
    

    type INTERRUPT_FSM is (
        INTRWAIT_S,     -- State 0
        DUMMY_S,        -- State 1
        SAVEENA_S,      -- State 2
        DISABLEINT_S,   -- State 3
        JMPADDR_S,      -- State 4
        DUMMYINT1_S,    -- State 5
        JMPFETCH_S,    -- State 6
        JUMP_S,         -- State 7
        JUMP2_S,        -- State 8
        DONE_S          -- State 9
    );

    -- Program Counter
    subtype PCTYPE is unsigned(11 downto 0);

    -- Instruction Decode Types
    subtype INSTRUCTIONTYPE is STD_LOGIC_VECTOR (31 downto 0);
    subtype OPCODETYPE is STD_LOGIC_VECTOR (4 downto 0);
    subtype MEMTYPE is  STD_LOGIC_VECTOR (1 downto 0);
    subtype REGTYPE is  STD_LOGIC_VECTOR (regOpSizeBits-1 downto 0);
    subtype IMMTYPE is  STD_LOGIC_VECTOR (15 downto 0);

    -- Register Information
    type REG_TYPE_REC is record
        Value       : std_logic_vector(31 downto 0);
        OpCode      : OPCODETYPE;   -- Instruction OpCode
        MemOp       : MEMTYPE;     -- Memory OpCode
        Flag        : STD_LOGIC;    -- Instruction Flag
        Countdown   : integer range 0 to 7;      -- Countdown Timer.
    end record;

    constant REG_DEFAULTS : REG_TYPE_REC := (
        Value => (others => '0'),
        OpCode => (others => '0'),
        MemOp => (others => '0'),
        Flag => '0',
        Countdown => 0
    );


    

    type REG_TYPE is array (regOpMax downto 0) of REG_TYPE_REC;

    -- type REG_TYPE1 is array (regOpMax downto 0) of std_logic_vector(31 downto 0);


    -- Opcodes
    constant oNOP   : OPCODETYPE  := "00000"; -- x00
    constant oLD    : OPCODETYPE  := "00010"; -- x02
    constant oSTR   : OPCODETYPE  := "00100"; -- x04
    constant oJmp   : OPCODETYPE  := "00110"; -- x06
    constant oJsr   : OPCODETYPE  := "01000"; -- x08
    constant oRtn   : OPCODETYPE  := "01010"; -- x0A
    constant oBE    : OPCODETYPE  := "01100"; -- x0C
    constant oBLT   : OPCODETYPE  := "01110"; -- x0E
    constant oBGT   : OPCODETYPE  := "10000"; -- x10
    constant oPUSHPOP 
                    : OPCODETYPE  := "10010"; -- x12
    constant oWAIT  : OPCODETYPE  := "10100"; -- x14
    constant oRWIO  : OPCODETYPE  := "10110"; -- x16

    constant oIOST  : OPCODETYPE  := "11000"; -- x18
    constant oRTI   : OPCODETYPE  := "11010"; -- x1A

    constant oSWIENA: OPCODETYPE  := "11100"; -- x1C
    constant SWIFLAG: STD_LOGIC   := '0';
    constant ENAFLAG: STD_LOGIC   := '1';

    constant oSWDM  : OPCODETYPE  := "11110"; -- x1E
    constant SWDFLAG: STD_LOGIC   := '0';
    constant SWMFLAG: STD_LOGIC   := '1';

    constant oAdd   : OPCODETYPE  := "00001"; -- x01
    constant oSub   : OPCODETYPE  := "00011"; -- x03
    constant oMul   : OPCODETYPE  := "00101"; -- x05
    constant oDiv   : OPCODETYPE  := "00111"; -- x07
    constant oAnd   : OPCODETYPE  := "01001"; -- x09
    constant oOr    : OPCODETYPE  := "01011"; -- x0B
    constant oXor   : OPCODETYPE  := "01101"; -- x0D
    constant oShLR  : OPCODETYPE  := "01111"; -- x0F

    constant REGREG : MEMTYPE := "00";
    constant IMMEDIATE : MEMTYPE := "01";
    constant ABSOLUTE : MEMTYPE := "10";
    constant INDEX : MEMTYPE := "11";
    
    -- IO Status Word Bit Positions:
    constant OIBusy : integer := 0;
    constant OIError : integer := 1;

    -- Interrupt Constants
    constant interruptNums : integer := 31;
    constant ResetIntPos : integer := 0;
    constant NOINTERRUPT : STD_LOGIC_VECTOR (interruptNums downto 0) := X"00000000";
    
    ---------------------------------------------------------------------------
    -- Debug Information

    subtype DEBUG_REG_TYPE is STD_LOGIC_VECTOR (31 downto 0);
    type DEBUG_REG_ARR_TYPE is array (regOpMax downto 0) of DEBUG_REG_TYPE;

    -- Register compare types
    type REG_COMPARE is (
        REG_NOTHING,        -- Value 0
        REG_EQUAL,          -- Value 1
        REG_LESS,           -- Value 2
        REG_GREATER,        -- Value 3
        REG_CHANGE,         -- Value 4
        REG_NOT_EQUAL,      -- Value 5
        REG_GREATER_EQUAL,  -- Value 6
        REG_LESS_EQUAL     -- Value 7
        );

    constant NumBreakPoint : integer := 4;
    type BREAKPOINTS_TYPE is array (NumBreakPoint-1 downto 0) of PCTYPE;
    
    constant RegisterNumberOffset : integer := 16;

    type INPUT_VALUE_TYPE is record
        Number : integer range 0 to 15;
        Value : STD_LOGIC_VECTOR(31 downto 0);
        Valid : STD_LOGIC;
    end record;

    type DEBUGOUTTYPE is record
        Stopped     : STD_LOGIC;
        CycleCount  : unsigned(63 downto 0);
        ProgCounter : PCTYPE;
        Regs        : DEBUG_REG_ARR_TYPE;
        Instruction : INSTRUCTIONTYPE;
        Interrupt   : STD_LOGIC_VECTOR(interruptNums downto 0);
        interruptMask
                    : STD_LOGIC_VECTOR(31 downto 0);
        Status      : STD_LOGIC_VECTOR(31 downto 0);
        StatusMask  : STD_LOGIC_VECTOR(31 downto 0);
        MEMORY_ARG  : STD_LOGIC_VECTOR(31 downto 0);
        Reset       : STD_LOGIC;
    end record;

    constant DEBUGOUT_DEFAULTS : DEBUGOUTTYPE := (
        Stopped => '1',
        CycleCount => (others => '0'),
        ProgCounter => (others => '0'),
        Regs => (others => (others => '0')),
        Instruction => (others => '0'),
        Interrupt => (others => '0'),
        interruptMask => (others => '0'),
        Status => (others => '0'),
        StatusMask => (others => '0'),
        MEMORY_ARG => (others => '0'),
        Reset => '0'
    );

    type DEBUGINTYPE is record
        DebugMode   : STD_LOGIC;
        BreakPoints : BREAKPOINTS_TYPE;
        Break       : STD_LOGIC;
        Step        : STD_LOGIC;
        Continue    : STD_LOGIC;
        BWhenReg    : integer;
        BWhenValue  : STD_LOGIC_VECTOR(31 downto 0);
        BWhenOp     : REG_COMPARE;
        Reset       : STD_LOGIC;
        UpdateValue : INPUT_VALUE_TYPE;
        UpdateReg   : INPUT_VALUE_TYPE;
    end record;

    signal DEBUGIN_DEFAULTS : DEBUGINTYPE := (
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

    subtype TGA_TYPE is STD_LOGIC_VECTOR(6 downto 0);

    constant TGA_STATUS     : TGA_TYPE := std_logic_vector(to_unsigned(     0 , TGA_TYPE'length));
    constant TGA_STEP       : TGA_TYPE := std_logic_vector(to_unsigned(     1 , TGA_TYPE'length));
    constant TGA_CONTINUE   : TGA_TYPE := std_logic_vector(to_unsigned(     2 , TGA_TYPE'length));
    constant TGA_BREAK      : TGA_TYPE := std_logic_vector(to_unsigned(     3 , TGA_TYPE'length));
    constant TGA_BREAKAT    : TGA_TYPE := std_logic_vector(to_unsigned(     4 , TGA_TYPE'length));
    constant TGA_BREAKWHEN  : TGA_TYPE := std_logic_vector(to_unsigned(     5 , TGA_TYPE'length));
    constant TGA_RESET      : TGA_TYPE := std_logic_vector(to_unsigned(     6 , TGA_TYPE'length));
    constant TGA_REGISTERS  : TGA_TYPE := std_logic_vector(to_unsigned(     8 , TGA_TYPE'length));
    constant TGA_MEMORY     : TGA_TYPE := std_logic_vector(to_unsigned(    16 , TGA_TYPE'length));

    type DEBUG_DATA is (        -- WB_COMMANDS (ADDRESS WRITE)
        DBG_STATE,              -- VALUE 0
        DBG_PROG_COUNTER,       -- VALUE 1
        DBG_INSTRUCTION,        -- VALUE 2
        DBG_CYCLES,             -- VALUE 3
        DBG_INTERRUPT,          -- VALUE 4
        DGB_INTERRUPT_MASK,     -- VALUE 5
        DBG_STATUS,             -- VALUE 6
        DBG_STATUS_MASK,        -- VALUE 7
        DBG_MEMORY_ARG          -- VALUE 8
    );


    -- Status Word
    -- | Bit   | Description                    |
    -- | ----- | ------------------------------ |
    -- | 0     | Illegal Operation              |
    -- | 1     | Illegal Address                |
    -- | 2     | Integer Overflow/Underflow     |
    -- | 3     | Integer Divide by Zero         |
    -- |       |                                |
    -- |       |                                |
    -- | 16    | IO Change to not Busy          |
    -- | 17    | IO Error                       |
    -- | 24-31 | IO Address Creating Interrupts |
    subtype STATUS_WORD_TYPE is STD_LOGIC_VECTOR(31 downto 0);
    -- Status BIT location
    constant IllegalOp      : integer := 0;
    constant IllegalAddr    : integer := 1;
    constant OverUnderflow  : integer := 2;
    constant DivideByZero   : integer := 3;
    constant IONotBusy      : integer := 16;
    constant IOError        : integer := 17;

    -- Memory Records
    constant MEM_ID_NONE : STD_LOGIC_VECTOR(1 downto 0) := "00";
    constant MEM_ID_PC : STD_LOGIC_VECTOR(1 downto 0) := "01";
    constant MEM_ID_ARG : STD_LOGIC_VECTOR(1 downto 0) := "10";
    constant MEM_ID_STACK : STD_LOGIC_VECTOR(1 downto 0) := "11";

    type AXI4_MEMORY_WRITE_OUT_TYPE_REC is record
        s_axi_awid      : STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_awaddr    : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
        s_axi_awvalid   : STD_LOGIC;
        s_axi_wdata     : STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axi_wstrb     : STD_LOGIC_VECTOR(3 DOWNTO 0);
        s_axi_wvalid    : STD_LOGIC;
        s_axi_bready    : STD_LOGIC;
    end record;

    constant AXI4_MEMORY_WRITE_OUT_DEFAULTS : AXI4_MEMORY_WRITE_OUT_TYPE_REC := (
        s_axi_awid => (others => '0'),
        s_axi_awaddr => (others => '0'),
        s_axi_awvalid => '0',
        s_axi_wdata => (others => '0'),
        s_axi_wstrb => (others => '1'),
        s_axi_wvalid => '0',
        s_axi_bready => '0'
    );
    
    type AXI4_MEMORY_READ_OUT_TYPE_REC is record
        s_axi_arid      : STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_araddr    : STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axi_arvalid   : STD_LOGIC;
        s_axi_rready    : STD_LOGIC;
    end record;

    constant AXI4_MEMORY_READ_OUT_DEFAULTS : AXI4_MEMORY_READ_OUT_TYPE_REC := (
        s_axi_arid => (others => '0'),
        s_axi_araddr => (others => '0'),
        s_axi_arvalid => '0',
        s_axi_rready => '0'
    );

    type AXI4_MEMORY_WRITE_IN_TYPE_REC is record
        s_axi_awready   : STD_LOGIC;
        s_axi_wready    : STD_LOGIC;
        s_axi_bid       : STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_bresp     : STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_bvalid    : STD_LOGIC;
    end record;

    constant AXI4_MEMORY_WRITE_IN_DEFAULTS : AXI4_MEMORY_WRITE_IN_TYPE_REC := (
        s_axi_awready => '0',
        s_axi_wready => '0',
        s_axi_bid => (others => '0'),
        s_axi_bresp => (others => '0'),
        s_axi_bvalid => '0'
    );

    type AXI4_MEMORY_READ_IN_TYPE_REC is record
        s_axi_arready   : STD_LOGIC;
        s_axi_rid       : STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_rdata     : STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axi_rresp     : STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_rvalid    : STD_LOGIC;
    end record;

    constant AXI4_MEMORY_READ_IN_DEFAULTS : AXI4_MEMORY_READ_IN_TYPE_REC := (
        s_axi_arready => '0',
        s_axi_rid => (others => '0'),
        s_axi_rdata => (others => '0'),
        s_axi_rresp => (others => '0'),
        s_axi_rvalid => '0'
    );

    Function SetReadAddress (
            addr : std_logic_vector(11 downto 0); 
            id : std_logic_vector(1 downto 0)) 
        return AXI4_MEMORY_READ_OUT_TYPE_REC;

    Function ClearReadAddress (
        readOut : AXI4_MEMORY_READ_OUT_TYPE_REC; 
        readIn : AXI4_MEMORY_READ_IN_TYPE_REC ) 
    return AXI4_MEMORY_READ_OUT_TYPE_REC;

    Function ClearReadData (
        readOut : AXI4_MEMORY_READ_OUT_TYPE_REC; 
        readIn : AXI4_MEMORY_READ_IN_TYPE_REC ) 
    return AXI4_MEMORY_READ_OUT_TYPE_REC;

    Function GetReadData (
        readIn : AXI4_MEMORY_READ_IN_TYPE_REC; 
            id : std_logic_vector(1 downto 0))
    return std_logic_vector;

    Function IsReadDataValid (
        readIn : AXI4_MEMORY_READ_IN_TYPE_REC; 
        id : std_logic_vector(1 downto 0) )
    return boolean;

    Function SetWrite (
            addr : std_logic_vector(11 downto 0); 
            id : std_logic_vector(1 downto 0); 
            data : std_logic_vector(31 downto 0)) 
        return AXI4_MEMORY_WRITE_OUT_TYPE_REC;

        
    Function ClearWriteFlags (
        writeOut : AXI4_MEMORY_WRITE_OUT_TYPE_REC; 
        writeIn : AXI4_MEMORY_WRITE_IN_TYPE_REC ) 
    return AXI4_MEMORY_WRITE_OUT_TYPE_REC;

end Package;


    
-- end Package Body Utilities;