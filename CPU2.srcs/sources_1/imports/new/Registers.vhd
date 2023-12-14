----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/03/2023 09:47:49 PM
-- Design Name: 
-- Module Name: Registers - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Registers is
    Port ( clk : in STD_LOGIC;
           ena : in STD_LOGIC := '1';
           regnum : in STD_LOGIC_VECTOR(3 downto 0);
           we : in std_logic ;
           regin : in STD_LOGIC_VECTOR (31 downto 0);
           regout : out STD_LOGIC_VECTOR (31 downto 0));
end Registers;

architecture Behavioral of Registers is

 type reg_type is array (15 downto 0) of std_logic_vector(31 downto 0);
 signal regist : reg_type := (others => (others => '0'));
-- signal w : std_logic := '0';
 
begin

    reg : process(clk)
    begin
    if ena = '1' then
        if rising_edge(clk) then
            if we = '1' then
                regist(to_integer(unsigned(regnum))) <= regin;
            else
                regout <= regist(to_integer(unsigned(regnum)));
            end if;
        end if;
    end if;
        
    end process;

end Behavioral;
