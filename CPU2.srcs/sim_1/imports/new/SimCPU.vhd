----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/30/2023 11:08:27 PM
-- Design Name: 
-- Module Name: SimCPU - Behavioral
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

entity SimCPU is
--  Port ( );
end SimCPU;

architecture Behavioral of SimCPU is

    component CPU 
        port (  
            rst : IN std_logic ;
            clk : IN STD_LOGIC
            );
    end component;            

    constant HALF_PERIOD: time := 5 ns;
    signal clk : std_logic ;
--    signal led : STD_LOGIC_VECTOR(3 DOWNTO 0);
    signal rst : std_logic ;

begin

    memory : CPU
    port map
    (
        rst => rst,
        clk => clk
    );


    clk <= '0' after HALF_PERIOD when clk = '1' else '1' after HALF_PERIOD;

    test : process
    begin
    
        rst <= '1';
        for j in 1 to 2 loop
            wait until rising_edge (clk);
        end loop;
        
        for j in 1 to 2 loop
            wait until rising_edge (clk);
        end loop;
        
        rst <= '0';
  
        for j in 1 to 200 loop
            wait until rising_edge (clk);
         end loop;

         
         
    

    end process;

end Behavioral;
