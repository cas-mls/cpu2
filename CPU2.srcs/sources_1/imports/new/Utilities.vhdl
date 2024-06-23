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

    type INST_CYCLE_TYPE is (
        RESET_STATE,
        ADDRESS_STATE, 
        INSTFETCH1_STATE, 
        INSTFETCH2_STATE, 
        DECODE_STATE, 
        MEMFETCH1_STATE, 
        MEMFETCH2_STATE, 
        EXECUTE_STATE, 
        CLEANUP_STATE,
        INTERRUPT_STATE,
        -- SAVEENA, 
        -- DISABLEINT, 
        -- JMPADDR, 
        -- JMPFETCH1, 
        -- JMPFETCH2, 
        -- JUMP,
        WAITS
        );
    
    type INTERRUPT_CYCLE is (
        INTERRUPT_RESET,
        NO_INTERRUPT,
        SAVEENA_I, 
        DISABLEINT_I, 
        JMPADDR_I, 
        JMPFETCH1_I, 
        JMPFETCH2_I, 
        JUMP_I
    );

    subtype OPCODETYPE is STD_LOGIC_VECTOR (4 downto 0);
    subtype MEMTYPE is  STD_LOGIC_VECTOR (1 downto 0);
    subtype REGTYPE is  STD_LOGIC_VECTOR (3 downto 0);
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
    constant oEMPTY1: OPCODETYPE  := "11000"; -- x18
    constant oRTI   : OPCODETYPE  := "11010"; -- x1A
    constant oSWI   : OPCODETYPE  := "11100"; -- x1C
    constant oIENA  : OPCODETYPE  := "11110"; -- x1E

    constant oAdd   : OPCODETYPE  := "00001"; -- x01
    constant oSub   : OPCODETYPE  := "00011"; -- x03
    constant oAnd   : OPCODETYPE  := "00101"; -- x05
    constant oOr    : OPCODETYPE  := "00111"; -- x07
    constant oEMPTY2: OPCODETYPE  := "01001"; -- x09
    constant oXor   : OPCODETYPE  := "01011"; -- x0B
    constant oShL   : OPCODETYPE  := "01101"; -- x0D
    constant oShR   : OPCODETYPE  := "01111"; -- x0F

    constant REGREG : MEMTYPE := "00";
    constant IMMEDIATE : MEMTYPE := "01";
    constant ABSOLUTE : MEMTYPE := "10";
    constant INDEX : MEMTYPE := "11";
    
    -- IO Status Word Bit Positions:
    constant OIBusy : integer := 0;
    constant OIError : integer := 1;

    type reg_type is array (15 downto 0) of std_logic_vector(31 downto 0);
    

    constant RESET : STD_LOGIC_VECTOR (31 downto 0) := X"00000001";
    
    type METRICSTYPE is record
        CycleCount : unsigned(63 downto 0);
    end record;

end Package;
