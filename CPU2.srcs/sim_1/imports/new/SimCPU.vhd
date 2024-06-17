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
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std_unsigned.ALL;
use std.textio.all;

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
            SYS_CLK     : IN STD_LOGIC;
            IO_ADDR     : out STD_LOGIC_VECTOR (7 downto 0);
            IOR_DATA    : in STD_LOGIC_VECTOR (31 downto 0);
            IOW_DATA    : out STD_LOGIC_VECTOR (31 downto 0);
            IOR_ENA     : out STD_LOGIC;
            IOW_ENA     : out std_logic;
            IO_STATUS   : in STD_LOGIC_VECTOR (7 downto 0);
            interrupt   : in STD_LOGIC_VECTOR (31 downto 0);
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


    constant HALF_PERIOD: time := 5 ns;

    signal RUN : boolean := true;
    -- signal RUN : boolean := false;

    signal clk : std_logic ;
    signal ioAddr  : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal IORdata    : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal IOWdata   : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal IORena: STD_LOGIC := '0';
    signal IOWena: std_logic := '0';
    signal IOStatus: STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal interrupt : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

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

    -- Program Loading
    signal LD_CLK      : STD_LOGIC                     := '1';
    signal LD_ENA      : STD_LOGIC                     := '1';
    signal LD_WEA      : STD_LOGIC_VECTOR(0 DOWNTO 0)  := "0";
    signal LD_ADDRA    : STD_LOGIC_VECTOR(11 DOWNTO 0) := X"000";
    signal LD_DINA     : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
    signal LD_DOUTA    : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";

    -- Program Running
    -- signal RUN_CLK      : STD_LOGIC                     := '1';
    signal RUN_ENA      : STD_LOGIC                     := '1';
    signal RUN_WEA      : STD_LOGIC_VECTOR(0 DOWNTO 0)  := "0";
    signal RUN_ADDRA    : STD_LOGIC_VECTOR(11 DOWNTO 0) := X"000";
    signal RUN_DINA     : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
    signal RUN_DOUTA    : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";

    -- signal data1 : std_ulogic_vector(31 downto 0) := X"00000000";

    procedure InitRamFromFile
        (   RamFileName     : in string;
            signal LD_CLK   : out STD_LOGIC;
            signal ENABLE   : out STD_LOGIC;
            signal W_ENABLE : out STD_LOGIC;
            signal ADDR     : out STD_LOGIC_VECTOR(11 DOWNTO 0);
            signal DOUT     : out STD_LOGIC_VECTOR(31 DOWNTO 0)
            )
    is
        file RamFile            : text is in RamFileName;
        variable RamFileLine    : line;
        variable outLine        : line;
        variable good           : boolean;
        variable data1 : bit_vector(31 downto 0) := X"00000000";
        variable l_addr         : natural range 0 to (2**ADDR'length - 1) := 0;
    begin

        if not RUN then
            LD_CLK <= '0';
            wait for HALF_PERIOD;
            ENABLE <= '1';
            W_ENABLE <= '1';

            -- for I in ADDR'range loop
            -- for I in 0 to 4095 loop
            while not endfile(RamFile)loop
                report "l_addr: " & integer'image(l_addr);
                write(outLine, "l_addr: " & integer'image(l_addr));
                writeline(output, outLine);
                ADDR <= std_logic_vector(to_signed(l_addr, ADDR'length));
                readline(RamFile, RamFileLine);
                read(RamFileLine, data1, good);
                DOUT  <= to_stdlogicvector(data1);
                LD_CLK <= '1';
                wait for HALF_PERIOD;
                LD_CLK <= '0';
                wait for HALF_PERIOD;
                l_addr := l_addr + 1;
            end loop;
        end if;
    end procedure;



begin

    cpuCUT : CPU
    port map
    (
        SYS_CLK     => clk,
        IO_ADDR     => ioAddr,
        IOR_DATA    => IORdata,
        IOW_DATA    => IOWdata,
        IOR_ENA     => IORena,
        IOW_ENA     => IOWena,
        IO_STATUS   => IOStatus,
        interrupt   => interrupt,
        MEM_ENA     => RUN_ENA  ,
        MEM_WEA     => RUN_WEA  ,
        MEM_ADDRA   => RUN_ADDRA,
        MEM_DINA    => RUN_DINA ,
        MEM_DOUTA   => RUN_DOUTA,
        MEM_ENB     => MEM_ENB  ,
        MEM_WEB     => MEM_WEB  ,
        MEM_ADDRB   => MEM_ADDRB,
        MEM_DINB    => MEM_DINB ,
        MEM_DOUTB   => MEM_DOUTB
    );

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

    -- Link the LOAD Program and RUN program memory signals.
    MEM_CLK     <= clk          when RUN    else LD_CLK;
    MEM_ENA     <= RUN_ENA      when RUN    else LD_ENA;
    MEM_WEA     <= RUN_WEA      when RUN    else LD_WEA;
    MEM_ADDRA   <= RUN_ADDRA    when RUN    else LD_ADDRA;
    MEM_DINA    <= RUN_DINA     when RUN    else LD_DINA;
    RUN_DOUTA   <= MEM_DOUTA    when RUN    else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
    LD_DOUTA    <= MEM_DOUTA    when not RUN else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";

    clk <= '0' after HALF_PERIOD when clk = '1' and RUN else '1' after HALF_PERIOD;

    test : process
    begin

        if not RUN then
            InitRamFromFile
                (   "cpumemory.mif",
                    LD_CLK,
                    LD_ENA,
                    LD_WEA(0),
                    LD_ADDRA,
                    LD_DINA);
            RUN <= TRUE;
        else

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
        end if;

    end process;

end Behavioral;
