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
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Computer is
    port (
        rst : in std_logic;
        SYS_CLK : in std_logic;
        led : out std_logic_vector (3 downto 0)
        --           rgb : out STD_LOGIC_VECTOR (5 downto 0)
    );
end Computer;

architecture Behavioral of Computer is

    component CPU
        port (
            SYS_CLK : in std_logic;
            IO_ADDR : out std_logic_vector (7 downto 0);
            IOR_DATA : in std_logic_vector (31 downto 0);
            IOW_DATA : out std_logic_vector (31 downto 0);
            IOR_ENA : out std_logic;
            IOW_ENA : out std_logic;
            IO_STATUS : in std_logic_vector (7 downto 0);
            INTERRUPT : in std_logic_vector (31 downto 0);
            MEM_ENA : out std_logic := '1';
            MEM_WEA : out std_logic_vector(0 downto 0) := "0";
            MEM_ADDRA : out std_logic_vector(11 downto 0) := X"000";
            MEM_DINA : out std_logic_vector(31 downto 0) := X"00000000";
            MEM_DOUTA : in std_logic_vector(31 downto 0) := X"00000000";
            MEM_ENB : out std_logic := '1';
            MEM_WEB : out std_logic_vector(0 downto 0) := "0";
            MEM_ADDRB : out std_logic_vector(11 downto 0) := X"000";
            MEM_DINB : out std_logic_vector(31 downto 0) := X"00000000";
            MEM_DOUTB : in std_logic_vector(31 downto 0) := X"00000000"
        );
    end component;

    component cpumemory
        port (
            clka : in std_logic;
            ena : in std_logic;
            wea : in std_logic_vector(0 downto 0);
            addra : in std_logic_vector(11 downto 0);
            dina : in std_logic_vector(31 downto 0);
            douta : out std_logic_vector(31 downto 0);
            clkb : in std_logic;
            enb : in std_logic;
            web : in std_logic_vector(0 downto 0);
            addrb : in std_logic_vector(11 downto 0);
            dinb : in std_logic_vector(31 downto 0);
            doutb : out std_logic_vector(31 downto 0)
        );
    end component;

    signal ioAddr : std_logic_vector (7 downto 0) := (others => '0');
    signal IORdata : std_logic_vector (31 downto 0) := (others => '0');
    signal IOWdata : std_logic_vector (31 downto 0) := (others => '0');
    signal interrupt : std_logic_vector (31 downto 0) := (others => '0');
    signal IOWena : std_logic := '0';
    signal IORena : std_logic := '0';
    signal IOStatus : std_logic_vector (7 downto 0) := (others => '0');

    signal echoIO : std_logic_vector (31 downto 0) := (others => '0');

    -- Memory Information
    signal MEM_CLK : std_logic := '1';
    signal MEM_ENA : std_logic := '1';
    signal MEM_WEA : std_logic_vector(0 downto 0) := "0";
    signal MEM_ADDRA : std_logic_vector(11 downto 0) := X"000";
    signal MEM_DINA : std_logic_vector(31 downto 0) := X"00000000";
    signal MEM_DOUTA : std_logic_vector(31 downto 0) := X"00000000";
    signal MEM_ENB : std_logic := '1';
    signal MEM_WEB : std_logic_vector(0 downto 0) := "0";
    signal MEM_ADDRB : std_logic_vector(11 downto 0) := X"000";
    signal MEM_DINB : std_logic_vector(31 downto 0) := X"00000000";
    signal MEM_DOUTB : std_logic_vector(31 downto 0) := X"00000000";

    -- attribute keep : string;
    -- attribute keep of ioAddr : signal is "TRUE";
    -- attribute keep of IORdata : signal is "TRUE";
    -- attribute keep of IOWdata : signal is "TRUE";
    -- attribute keep of echoIO : signal is "TRUE";

begin

    memory : cpumemory
    port map(
        clka => MEM_CLK,
        ena => MEM_ENA,
        wea => MEM_WEA,
        addra => MEM_ADDRA,
        dina => MEM_DINA,
        douta => MEM_DOUTA,
        clkb => MEM_CLK,
        enb => MEM_ENB,
        web => MEM_WEB,
        addrb => MEM_ADDRB,
        dinb => MEM_DINB,
        doutb => MEM_DOUTB
    );

    cpu1 : CPU
    port map
    (
        SYS_CLK => SYS_CLK,
        IO_ADDR => ioAddr,
        IOR_DATA => IORdata,
        IOW_DATA => IOWdata,
        IOR_ENA => IORena,
        IOW_ENA => IOWena,
        IO_STATUS => IOStatus,
        INTERRUPT => interrupt,
        -- MEM_ENA     => RUN_ENA  ,
        -- MEM_WEA     => RUN_WEA  ,
        -- MEM_ADDRA   => RUN_ADDRA,
        -- MEM_DINA    => RUN_DINA ,
        -- MEM_DOUTA   => RUN_DOUTA,
        MEM_ENA => MEM_ENA,
        MEM_WEA => MEM_WEA,
        MEM_ADDRA => MEM_ADDRA,
        MEM_DINA => MEM_DINA,
        MEM_DOUTA => MEM_DOUTA,
        MEM_ENB => MEM_ENB,
        MEM_WEB => MEM_WEB,
        MEM_ADDRB => MEM_ADDRB,
        MEM_DINB => MEM_DINB,
        MEM_DOUTB => MEM_DOUTB
    );

    interrupt(0) <= rst;
    MEM_CLK <= SYS_CLK;

    Comp : process (SYS_CLK)
    begin

        if rising_edge (SYS_CLK) then
            if rst = '1' then
                IORdata <= (others => '0');
                interrupt(31 downto 1) <= (others => '0');
                IOStatus <= (others => '0');
            else
                if ioAddr = X"03" and IOWena = '1'then
                    led <= IOWdata(3 downto 0);
                elsif ioaddr = X"01" and IORena = '1' then
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
            end if;
        end if;

    end process;

end Behavioral;