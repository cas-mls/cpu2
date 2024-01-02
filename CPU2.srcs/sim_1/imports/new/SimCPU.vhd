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

library STD;
use STD.textio.all;                     -- basic I/O
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
            clk : IN STD_LOGIC;
            ioAddr  : out STD_LOGIC_VECTOR (7 downto 0);
            IORdata    : in STD_LOGIC_VECTOR (31 downto 0);
            IOWdata   : out STD_LOGIC_VECTOR (31 downto 0);
            IORena: out STD_LOGIC;
            IOWena: out std_logic;
            IOStatus: in STD_LOGIC_VECTOR (7 downto 0);
            interrupt : in STD_LOGIC_VECTOR (31 downto 0)
            );
    end component;            

    constant HALF_PERIOD: time := 5 ns;
    signal clk : std_logic ;
    signal rst : std_logic ;
    signal ioAddr  : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal IORdata    : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal IOWdata   : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal IORena: STD_LOGIC := '0';
    signal IOWena: std_logic := '0';
    signal IOStatus: STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal interrupt : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

    signal echoIO : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');


begin

    cpuCUT : CPU
    port map
    (
        clk => clk,
        ioAddr => ioAddr,
        IORdata => IORdata,
        IOWdata => IOWdata,
        IORena => IORena,
        IOWena => IOWena,
        IOStatus => IOStatus,
        interrupt => interrupt
    );


    clk <= '0' after HALF_PERIOD when clk = '1' else '1' after HALF_PERIOD;

    test : process

        variable my_line : line;  -- type 'line' comes from textio

    begin
    
        interrupt(0) <= '1';
        for j in 1 to 4 loop
            wait until rising_edge (clk);
        end loop;
        interrupt(0) <= '0';

        for j in 1 to 10000 loop
            wait until rising_edge (clk);
            if ioaddr = X"01" and IORena = '1' then
                IORdata <= echoIO;
                IOStatus <= X"00";
            elsif ioaddr = X"01" and IOWena = '1' then
                echoIO <= IOWdata;
                IOStatus <= X"00";
            elsif ioaddr = X"02" and IOWena = '1' then
                IOStatus <= X"10";
            elsif ioaddr = X"05" and IOWena = '1' then
                interrupt(2) <= IOWdata(0);
            else
                IOStatus <= X"00";
            end if;
         end loop;

         
         
    

    end process;

end Behavioral;
