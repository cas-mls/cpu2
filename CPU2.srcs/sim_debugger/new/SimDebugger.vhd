-- vhdl-linter-disable type-resolved component
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
use STD.textio.all; -- basic I/O
library IEEE;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std_unsigned.all;
use std.textio.all;
library xil_defaultlib;
use xil_defaultlib.Utilities.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SimDebugger is
    --  Port ( );
end SimDebugger;

architecture Behavioral of SimDebugger is

    component CPU
        port (
            SYS_CLK       : in  STD_LOGIC;
            IO_ADDR       : out STD_LOGIC_VECTOR (7 downto 0);
            IOR_DATA      : in  STD_LOGIC_VECTOR (31 downto 0);
            IOW_DATA      : out STD_LOGIC_VECTOR (31 downto 0);
            IOR_ENA       : out STD_LOGIC;
            IOW_ENA       : out STD_LOGIC;
            IO_STATUS     : in  STD_LOGIC_VECTOR (31 downto 0);
            IO_STATUS_REQ : out STD_LOGIC;
            interrupt     : in  STD_LOGIC_VECTOR (31 downto 0);
            MEM_ENA       : out STD_LOGIC                     := '1';
            MEM_WEA       : out STD_LOGIC_VECTOR(0 downto 0)  := "0";
            MEM_ADDRA     : out STD_LOGIC_VECTOR(11 downto 0) := X"000";
            MEM_DINA      : out STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
            MEM_DOUTA     : in  STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
            MEM_ENB       : out STD_LOGIC                     := '1';
            MEM_WEB       : out STD_LOGIC_VECTOR(0 downto 0)  := "0";
            MEM_ADDRB     : out STD_LOGIC_VECTOR(11 downto 0) := X"000";
            MEM_DINB      : out STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
            MEM_DOUTB     : in  STD_LOGIC_VECTOR(31 downto 0) := X"00000000";

            DEBUGIN     : in DEBUGINTYPE := (
                DebugMode => '0',
                BreakPoints => (others => (others => '0')),
                Break => '0', 
                Step => '0', 
                Continue => '0',
                BWhenReg => 0,
                BWhenValue => (others => '0'),
                BWhenOp => REG_NOTHING);
            DEBUGOUT    : out DEBUGOUTTYPE
        );
    end component;

    component cpumemory
        port (
            clka  : in  STD_LOGIC;
            ena   : in  STD_LOGIC;
            wea   : in  STD_LOGIC_VECTOR(0 downto 0);
            addra : in  STD_LOGIC_VECTOR(11 downto 0);
            dina  : in  STD_LOGIC_VECTOR(31 downto 0);
            douta : out STD_LOGIC_VECTOR(31 downto 0);
            clkb  : in  STD_LOGIC;
            enb   : in  STD_LOGIC;
            web   : in  STD_LOGIC_VECTOR(0 downto 0);
            addrb : in  STD_LOGIC_VECTOR(11 downto 0);
            dinb  : in  STD_LOGIC_VECTOR(31 downto 0);
            doutb : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component; -- vhdl-linter-disable-line component

    component UartDevice is
        port (
            CLK       : in  STD_LOGIC;
            RST       : in  STD_LOGIC;
            UART_RXD  : in  STD_LOGIC;
            UART_TXD  : out STD_LOGIC;
            TxByte    : in  STD_LOGIC_VECTOR (7 downto 0);
            TxAvail   : in  STD_LOGIC;
            TxStatus  : out STD_LOGIC_VECTOR (31 downto 0);
            Interrupt : out STD_LOGIC;
            RdByte    : out STD_LOGIC_VECTOR (7 downto 0);
            RdStatus  : out STD_LOGIC_VECTOR (31 downto 0)
        );
    end component;

    constant HALF_PERIOD : TIME := 5 ns;

    signal clk         : STD_LOGIC;
    signal ioAddr      : STD_LOGIC_VECTOR (7 downto 0)  := (others => '0');
    signal IORdata     : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal IOWdata     : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal IORena      : STD_LOGIC                      := '0';
    signal IOWena      : STD_LOGIC                      := '0';
    signal IOStatus    : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal IOStatusReq : STD_LOGIC                      := '0';
    signal interrupt   : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

    signal echoIO : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

    -- Memory Information
    signal MEM_CLK   : STD_LOGIC                     := '1';
    signal MEM_ENA   : STD_LOGIC                     := '1';
    signal MEM_WEA   : STD_LOGIC_VECTOR(0 downto 0)  := "0";
    signal MEM_ADDRA : STD_LOGIC_VECTOR(11 downto 0) := X"000";
    signal MEM_DINA  : STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
    signal MEM_DOUTA : STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
    signal MEM_ENB   : STD_LOGIC                     := '1';
    signal MEM_WEB   : STD_LOGIC_VECTOR(0 downto 0)  := "0";
    signal MEM_ADDRB : STD_LOGIC_VECTOR(11 downto 0) := X"000";
    signal MEM_DINB  : STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
    signal MEM_DOUTB : STD_LOGIC_VECTOR(31 downto 0) := X"00000000";


    -- Debug Items
    -- Debug Items
    signal DebugIn      : DEBUGINTYPE := 
        (DebugMode => '0',
        BreakPoints => (others => (others => '0')), 
        Break => '0', 
        Step => '0', 
        Continue => '0',
        BWhenReg => 0,
        BWhenValue => (others => '0'),
        BWhenOp => REG_NOTHING);
    signal DebugOut     : DEBUGOUTTYPE;

begin

cpuCUT : CPU
port map(
    SYS_CLK       => clk,
    IO_ADDR       => ioAddr,
    IOR_DATA      => IORdata,
    IOW_DATA      => IOWdata,
    IOR_ENA       => IORena,
    IOW_ENA       => IOWena,
    IO_STATUS     => IOStatus,
    IO_STATUS_REQ => IOStatusReq,
    interrupt     => interrupt,
    MEM_ENA       => MEM_ENA,
    MEM_WEA       => MEM_WEA,
    MEM_ADDRA     => MEM_ADDRA,
    MEM_DINA      => MEM_DINA,
    MEM_DOUTA     => MEM_DOUTA,
    MEM_ENB       => MEM_ENB,
    MEM_WEB       => MEM_WEB,
    MEM_ADDRB     => MEM_ADDRB,
    MEM_DINB      => MEM_DINB,
    MEM_DOUTB     => MEM_DOUTB,
    DEBUGIN       => DebugIn,
    DEBUGOUT      => DebugOut
);

memory : cpumemory
port map(
    clka  => clk,
    ena   => MEM_ENA,
    wea   => MEM_WEA,
    addra => MEM_ADDRA,
    dina  => MEM_DINA,
    douta => MEM_DOUTA,
    clkb  => clk,
    enb   => MEM_ENB,
    web   => MEM_WEB,
    addrb => MEM_ADDRB,
    dinb  => MEM_DINB,
    doutb => MEM_DOUTB
);

clk <= '0' after HALF_PERIOD when clk = '1' else
       '1' after HALF_PERIOD;

test : process
begin

    interrupt(0) <= '1';
    for j in 1 to 10 loop
        wait until rising_edge (clk);
    end loop;
    interrupt(0) <= '0';

    while true loop
        wait until rising_edge (clk);

    end loop;

end process;

debug : process
begin
    wait for 0.5us;
    DebugIn.DebugMode <= '1';

    -- Test for Breakpoints
    DebugIn.BreakPoints(0) <= x"081";
    wait until DebugOut.Stopped = '1';
    wait until rising_edge (clk);
    -- --Continue
    -- wait for 0.1us;
    -- DebugIn.Continue <= '1';
    -- wait until rising_edge (clk);
    -- DebugIn.Continue <= '0';

    -- -- Test for Register Break - Change
    -- wait for 0.5us;
    -- wait until rising_edge (clk);
    -- DebugIn.BWhenReg <=14;
    -- DebugIn.BWhenOp <= REG_CHANGE; -- This will happen every time the register changes
    -- wait until DebugOut.Stopped = '1';
    -- DebugIn.BWhenOp <= REG_NOTHING; -- This will stop the register break
    -- wait until rising_edge (clk);
    -- --Continue
    -- wait for 0.1us;
    -- DebugIn.Continue <= '1';
    -- wait until rising_edge (clk);
    -- DebugIn.Continue <= '0';

    -- -- Test for Register Break - EUQAL
    -- wait for 0.5us;
    -- wait until rising_edge (clk);
    -- DebugIn.BWhenReg <=14;
    -- DebugIn.BWhenValue <= x"00000022";
    -- DebugIn.BWhenOp <= REG_EQUAL; -- This will happen every time the register changes
    -- wait until DebugOut.Stopped = '1';
    -- DebugIn.BWhenOp <= REG_NOTHING; -- This will stop the register break
    -- wait until rising_edge (clk);
    -- --Continue
    -- wait for 0.1us;
    -- DebugIn.Continue <= '1';
    -- wait until rising_edge (clk);
    -- DebugIn.Continue <= '0';
    
    -- -- Test for Break Command
    -- wait for 0.5us;
    -- wait until rising_edge (clk);
    -- DebugIn.Break <= '1';
    -- wait until rising_edge (clk);
    -- DebugIn.Break <= '0';
 
    -- Test for Step Command
    wait for 0.15us;
    wait until rising_edge (clk);
    DebugIn.Step <= '1';
    wait until rising_edge (clk);
    DebugIn.Step <= '0';

    -- Test for Step Command
    wait for 0.15us;
    wait until rising_edge (clk);
    DebugIn.Step <= '1';
    wait until rising_edge (clk);
    DebugIn.Step <= '0';

    -- Test for Continue
    wait for 0.5us;
    wait until rising_edge (clk);
    DebugIn.Continue <= '1';
    wait until rising_edge (clk);
    DebugIn.Continue <= '0';

end process;

end Behavioral;