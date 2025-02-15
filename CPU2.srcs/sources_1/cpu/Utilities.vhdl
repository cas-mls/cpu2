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
        ADDRESS_S,      -- State 1
        INSTFETCH1_S,   -- State 2
        INSTFETCH2_S,   -- State 3
        DECODE_S,       -- State 4
        MEMFETCH1_S,    -- State 5
        MEMFETCH2_S,    -- State 6
        EXECUTE_S,      -- State 7
        CLEANUP_S,      -- State 8
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
        JMPFETCH1_S,    -- State 5
        JMPFETCH2_S,    -- State 6
        JUMP_S,         -- State 7
        DONE_S          -- State 8
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
        Flag        : STD_LOGIC;    -- Instruction Flag
        Countdown   : integer;      -- Countdown Timer.
    end record;

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
    constant RESET : STD_LOGIC_VECTOR (interruptNums downto 0) := X"00000001";
    constant NOINTERRUPT : STD_LOGIC_VECTOR (interruptNums downto 0) := X"00000000";
    
    ---------------------------------------------------------------------------
    -- Debug Information

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
    
    type DEBUGOUTTYPE is record
        Stopped     : STD_LOGIC;
        CycleCount  : unsigned(63 downto 0);
        ProgCounter : PCTYPE;
        Regs        : REG_TYPE;
        Instruction : INSTRUCTIONTYPE;
        Interrupt   : STD_LOGIC_VECTOR(interruptNums downto 0);
        interruptMask
                    : STD_LOGIC_VECTOR(31 downto 0);
        Status      : STD_LOGIC_VECTOR(31 downto 0);
        StatusMask  : STD_LOGIC_VECTOR(31 downto 0);
        MEMORY_ARG  : STD_LOGIC_VECTOR(31 downto 0);
        Reset       : STD_LOGIC;
    end record;

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
    end record;

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


end Package;
