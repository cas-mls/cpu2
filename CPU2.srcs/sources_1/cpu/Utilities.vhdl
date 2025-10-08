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
        RegOpNum    : integer range 0 to 3; -- Register Number
        Countdown   : integer range 0 to 7;      -- Countdown Timer.
    end record;

    constant REG_DEFAULTS : REG_TYPE_REC := (
        Value => (others => '0'),
        OpCode => (others => '0'),
        MemOp => (others => '0'),
        Flag => '0',
        RegOpNum => 0,
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


    
-- end Package Body Utilities;