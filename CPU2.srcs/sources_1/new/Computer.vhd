----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/26/2023 05:47:29 PM
-- Design Name: 
-- Module Name: Computer - Behavioral
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

entity Computer is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           led : out STD_LOGIC_VECTOR (3 downto 0)
--           rgb : out STD_LOGIC_VECTOR (5 downto 0)
           );
end Computer;

architecture Behavioral of Computer is

component CPU
    Port ( 
        clk : IN STD_LOGIC;
        ioAddr : out STD_LOGIC_VECTOR (7 downto 0);
        IORdata : in STD_LOGIC_VECTOR (31 downto 0);
        IOWdata : out STD_LOGIC_VECTOR (31 downto 0);
        IORena: out STD_LOGIC;
        IOWena: out std_logic;
        IOStatus: in STD_LOGIC_VECTOR (7 downto 0);
        Interrupt : in STD_LOGIC_VECTOR (31 downto 0)
        );
end component;

    signal ioAddr : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal IORdata : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal IOWdata : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal interrupt : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal IOWena : STD_LOGIC := '0';
    signal IORena : STD_LOGIC := '0';
    signal IOStatus : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    
    signal echoIO : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');


begin

    cpu1 : CPU
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

    interrupt(0) <= rst;

    Comp : process (clk)
    begin
    
    if rising_edge  (clk) then
        if rst = '1' then
            IORdata <= (others => '0');
            interrupt(31 downto 1) <= (others => '0');
            IOStatus <= (others => '0');
        end if;
        if IORena = '1' then
        end if;
        if IOWena = '1' then
            if ioAddr = X"03" then
                led <= IOWdata(3 downto 0);
            elsif ioaddr = X"01" and IORena = '1' then
                IORdata <= echoIO;
                IOStatus <= X"00";
            elsif ioaddr = X"01" and IOWena = '1' then
                echoIO <= IOWdata;
                IOStatus <= X"00";
            elsif ioaddr = X"02" and IOWena = '1' then
                IOStatus <= X"10";
            else
                IOStatus <= X"00";
            end if;
        end if;
    end if;
    
    end process;


end Behavioral;
