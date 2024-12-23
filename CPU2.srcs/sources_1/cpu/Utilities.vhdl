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
--library UNISIM;
--use UNISIM.VComponents.all;

package Utilities is

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
        WAITS_S         -- State 9
        );
    

    type INTERRUPT_FSM is (
        INTRWAIT_S,     -- State 0
        CYCLEWAIT_S,    -- State 1
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

    -- Register Information
    constant regOpSizeBits : integer := 4;
    constant regOpMax  : integer := 2**regOpSizeBits-1;
    type REG_TYPE is array (regOpMax downto 0) of std_logic_vector(31 downto 0);

    -- Instruction Decode Types
    subtype INSTRUCTIONTYPE is STD_LOGIC_VECTOR (31 downto 0);
    subtype OPCODETYPE is STD_LOGIC_VECTOR (4 downto 0);
    subtype MEMTYPE is  STD_LOGIC_VECTOR (1 downto 0);
    subtype REGTYPE is  STD_LOGIC_VECTOR (regOpSizeBits-1 downto 0);
    subtype IMMTYPE is  STD_LOGIC_VECTOR (15 downto 0);

    -- Opcodes
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
    constant oSWI   : OPCODETYPE  := "11100"; -- x1C
    constant oIENA  : OPCODETYPE  := "11110"; -- x1E

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
    
    type DEBUGOUTTYPE is record
        Stopped     : STD_LOGIC;
        CycleCount  : unsigned(63 downto 0);
        ProgCounter : PCTYPE;
        Regs        : REG_TYPE;
        Instruction : INSTRUCTIONTYPE;
    end record;

    constant NumBreakPoint : integer := 4;
    type BREAKPOINTS_TYPE is array (NumBreakPoint-1 downto 0) of PCTYPE;

    type DEBUGINTYPE is record
        DebugMode   : STD_LOGIC;
        BreakPoints : BREAKPOINTS_TYPE;
        Break       : STD_LOGIC;
        Step        : STD_LOGIC;
        Continue    : STD_LOGIC;
        BWhenReg    : integer;
        BWhenValue  : STD_LOGIC_VECTOR(31 downto 0);
    end record;

    subtype TGA_TYPE is STD_LOGIC_VECTOR(6 downto 0);

    constant TGA_STATUS     : TGA_TYPE := std_logic_vector(to_unsigned(     0 , TGA_TYPE'length));
    constant TGA_STEP       : TGA_TYPE := std_logic_vector(to_unsigned(     1 , TGA_TYPE'length));
    constant TGA_CONTINUE   : TGA_TYPE := std_logic_vector(to_unsigned(     2 , TGA_TYPE'length));
    constant TGA_BREAK      : TGA_TYPE := std_logic_vector(to_unsigned(     3 , TGA_TYPE'length));
    constant TGA_BREAKAT    : TGA_TYPE := std_logic_vector(to_unsigned(     4 , TGA_TYPE'length));
    constant TGA_BREAKWHEN  : TGA_TYPE := std_logic_vector(to_unsigned(     5 , TGA_TYPE'length));
    constant TGA_REGISTERS  : TGA_TYPE := std_logic_vector(to_unsigned(     8 , TGA_TYPE'length));
    constant TGA_MEMORY     : TGA_TYPE := std_logic_vector(to_unsigned(    16 , TGA_TYPE'length));

    type DEBUG_DATA is (        -- WB_COMMANDS (ADDRESS WRITE)
        DBG_STATE,              -- VALUE 0
        DBG_PROG_COUNTER,       -- VALUE 1
        DBG_INSTRUCTION,        -- VALUE 2
        DBG_CYCLES              -- VALUE 3
    );


end Package;
