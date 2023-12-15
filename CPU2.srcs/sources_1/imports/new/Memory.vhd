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
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Memory is
    Port ( 
        clk : IN STD_LOGIC;
        ena : IN STD_LOGIC := '1';
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0) := "0";
        addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
        douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
end Memory;

architecture Behavioral of Memory is

--    component CPUMemory 
--        PORT (
--    clka : IN STD_LOGIC;
--    ena : IN STD_LOGIC;
--    addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
--    douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
--        );
--    end component;            
    
COMPONENT cpumemory
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) 
  );
END COMPONENT;


begin

instmemory : cpumemory
  PORT MAP (
    clka => clk,
    ena => ena,
    wea => wea,
    addra => addra,
    dina => dina,
    douta => douta
  );



    Reg_Proc: process (clk)
    begin
        if rising_edge (clk) then
        end if;
            
    end process;

--    Reg_Proc: process (clk)
--    begin
--    -- Read COE file Test.
--    if falling_edge (clk) then
--        if rst = '1' then
--            addrtmp <= X"000";
--        else
--            addrtmp <=  addrtmp + 1;
--        end if;
--        wea <= "0000";
--        addra <= STD_LOGIC_VECTOR(unsigned(addrtmp));
--    end if;
--    if rising_edge (clk) then
--        led <= douta(3 downto 0);
--    end if;
--    end process;


end Behavioral;
