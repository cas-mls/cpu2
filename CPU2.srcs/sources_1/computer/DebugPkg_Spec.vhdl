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
use xil_defaultlib.Utilities.all;


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;

package DebugPkg is

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
        Stopped => '0',
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


end Package DebugPkg;
