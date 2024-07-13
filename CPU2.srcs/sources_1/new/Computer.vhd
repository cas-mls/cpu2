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
           SYS_CLK : in STD_LOGIC;
           led : out STD_LOGIC_VECTOR (3 downto 0)
--           rgb : out STD_LOGIC_VECTOR (5 downto 0)
           );
end Computer;

architecture Behavioral of Computer is

    component CPU
    Port ( 
        SYS_CLK     : IN STD_LOGIC;
        IO_ADDR     : out STD_LOGIC_VECTOR (7 downto 0);
        IOR_DATA    : in STD_LOGIC_VECTOR (31 downto 0);
        IOW_DATA    : out STD_LOGIC_VECTOR (31 downto 0);
        IOR_ENA     : out STD_LOGIC;
        IOW_ENA     : out STD_LOGIC;
        IO_STATUS   : in STD_LOGIC_VECTOR (7 downto 0);
        INTERRUPT   : in STD_LOGIC_VECTOR (31 downto 0);
        MEM_ENA     : out STD_LOGIC := '1';
        MEM_WEA     : out STD_LOGIC_VECTOR(0 DOWNTO 0) := "0";
        MEM_ADDRA   : out STD_LOGIC_VECTOR(11 DOWNTO 0) := X"000";
        MEM_DINA    : out STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
        MEM_DOUTA   : in STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
        MEM_ENB     : out STD_LOGIC := '1';
        MEM_WEB     : out STD_LOGIC_VECTOR(0 DOWNTO 0) := "0";
        MEM_ADDRB   : out STD_LOGIC_VECTOR(11 DOWNTO 0) := X"000";
        MEM_DINB    : out STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
        MEM_DOUTB   : in STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000"
        );
    end component;

    COMPONENT cpumemory
    PORT (
        clka : IN STD_LOGIC;
        ena : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        clkb : IN STD_LOGIC;
        enb : IN STD_LOGIC;
        web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addrb : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        dinb : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
    END COMPONENT;


    signal ioAddr : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal IORdata : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal IOWdata : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal interrupt : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal IOWena : STD_LOGIC := '0';
    signal IORena : STD_LOGIC := '0';
    signal IOStatus : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    
    signal echoIO : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

    -- Memory Information
    signal MEM_CLK      : STD_LOGIC                     := '1';
    signal MEM_ENA      : STD_LOGIC                     := '1';
    signal MEM_WEA      : STD_LOGIC_VECTOR(0 DOWNTO 0)  := "0";
    signal MEM_ADDRA    : STD_LOGIC_VECTOR(11 DOWNTO 0) := X"000";
    signal MEM_DINA     : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
    signal MEM_DOUTA    : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
    signal MEM_ENB      : STD_LOGIC                     := '1';
    signal MEM_WEB      : STD_LOGIC_VECTOR(0 DOWNTO 0)  := "0";
    signal MEM_ADDRB    : STD_LOGIC_VECTOR(11 DOWNTO 0) := X"000";
    signal MEM_DINB     : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
    signal MEM_DOUTB    : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";

    -- attribute keep : string;
    -- attribute keep of ioAddr : signal is "TRUE";
    -- attribute keep of IORdata : signal is "TRUE";
    -- attribute keep of IOWdata : signal is "TRUE";
    -- attribute keep of echoIO : signal is "TRUE";


begin

    memory : cpumemory
    PORT MAP (
        clka    => MEM_CLK,
        ena     => MEM_ENA,
        wea     => MEM_WEA,
        addra   => MEM_ADDRA,
        dina    => MEM_DINA,
        douta   => MEM_DOUTA,
        clkb    => MEM_CLK,
        enb     => MEM_ENB,
        web     => MEM_WEB,
        addrb   => MEM_ADDRB,
        dinb    => MEM_DINB,
        doutb   => MEM_DOUTB
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
        MEM_ENA     => MEM_ENA  ,
        MEM_WEA     => MEM_WEA  ,
        MEM_ADDRA   => MEM_ADDRA,
        MEM_DINA    => MEM_DINA ,
        MEM_DOUTA   => MEM_DOUTA,
        MEM_ENB     => MEM_ENB  ,
        MEM_WEB     => MEM_WEB  ,
        MEM_ADDRB   => MEM_ADDRB,
        MEM_DINB    => MEM_DINB ,
        MEM_DOUTB   => MEM_DOUTB    
        );

    interrupt(0) <= rst;
    MEM_CLK <= SYS_CLK;

    Comp : process (SYS_CLK)
    begin
    
    if rising_edge  (SYS_CLK) then
        if rst = '1' then
            IORdata <= (others => '0');
            interrupt(31 downto 1) <= (others => '0');
            IOStatus <= (others => '0');
        else
            if ioAddr = X"03"  and IOWena = '1'then
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
