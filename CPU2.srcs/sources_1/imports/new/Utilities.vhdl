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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

package Utilities is

    type CYCLETYPE is (PREFETCH, DATAIN, FETCH, WAITS, DECODES, MEMRWAIT, MEMR, EXECUTE, MEMW);
    
    subtype OPCODETYPE is STD_LOGIC_VECTOR (4 downto 0);
    subtype MEMTYPE is  STD_LOGIC_VECTOR (1 downto 0);
    subtype REGTYPE is  STD_LOGIC_VECTOR (3 downto 0);
    subtype IMMTYPE is  STD_LOGIC_VECTOR (15 downto 0);

    -- Opcodes
    constant oLD   : OPCODETYPE  := "00010"; -- x02
    constant oSTR  : OPCODETYPE  := "00100"; -- x04
    constant oJmp  : OPCODETYPE  := "00110"; -- x06
    constant oJsr  : OPCODETYPE  := "01000"; -- x08
    constant oRtn  : OPCODETYPE  := "01010"; -- x0A
    constant oBE   : OPCODETYPE  := "01100"; -- x0C
    constant oBLT  : OPCODETYPE  := "01110"; -- x0E
    constant oBGT  : OPCODETYPE  := "10000"; -- x10

    constant oAdd  : OPCODETYPE  := "00001"; -- x01
    constant oSub  : OPCODETYPE  := "00011"; -- x03
    constant oAnd  : OPCODETYPE  := "00101"; -- x05
    constant oOr   : OPCODETYPE  := "00111"; -- x07
    constant oNot  : OPCODETYPE  := "01001"; -- x09
    constant oXor  : OPCODETYPE  := "01011"; -- x0B
    constant oInc  : OPCODETYPE  := "01101"; -- x0D
    constant oDec  : OPCODETYPE  := "01111"; -- x0F
    constant oShL  : OPCODETYPE  := "10001"; -- x11
    constant oShR  : OPCODETYPE  := "10011"; -- x13

    constant REGREG : MEMTYPE := "00";
    constant IMMEDIATE : MEMTYPE := "01";
    constant ABSOLUTE : MEMTYPE := "10";
    constant INDEX : MEMTYPE := "11";

    type reg_type is array (15 downto 0) of std_logic_vector(31 downto 0);

end Package;