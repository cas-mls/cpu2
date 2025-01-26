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

entity SimCPU is
    --  Port ( );
end SimCPU;

architecture Behavioral of SimCPU is

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
                BWhenReg => 16,
                BWhenValue => (others => '0'));
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
    end component;

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

    constant PERIOD        : TIME    := 10 ns;
    constant CLK_FREQ      : NATURAL := 50e6;
    constant BAUD_RATE     : NATURAL := 115200;
    constant TRANS_COUNT   : NATURAL := 2 ** 8;
    constant CLK_PERIOD    : TIME    := 1 ns * INTEGER(real(1e9)/real(CLK_FREQ));
    constant UART_PERIOD_I : NATURAL := INTEGER(real(1e9)/real(BAUD_RATE));
    constant UART_PERIOD   : TIME    := 1 ns * UART_PERIOD_I;

    signal RUN : BOOLEAN := true;
    -- signal RUN : boolean := false;

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

    -- Program Loading
    signal LD_CLK   : STD_LOGIC                     := '1';
    signal LD_ENA   : STD_LOGIC                     := '1';
    signal LD_WEA   : STD_LOGIC_VECTOR(0 downto 0)  := "0";
    signal LD_ADDRA : STD_LOGIC_VECTOR(11 downto 0) := X"000";
    signal LD_DINA  : STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
    signal LD_DOUTA : STD_LOGIC_VECTOR(31 downto 0) := X"00000000";

    -- Program Running
    -- signal RUN_CLK      : STD_LOGIC                     := '1';
    signal RUN_ENA   : STD_LOGIC                     := '1';
    signal RUN_WEA   : STD_LOGIC_VECTOR(0 downto 0)  := "0";
    signal RUN_ADDRA : STD_LOGIC_VECTOR(11 downto 0) := X"000";
    signal RUN_DINA  : STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
    signal RUN_DOUTA : STD_LOGIC_VECTOR(31 downto 0) := X"00000000";

    -- signal data1 : std_ulogic_vector(31 downto 0) := X"00000000";

    -- UART Device 
    signal UART_RXD      : STD_LOGIC;
    signal UART_TXD      : STD_LOGIC;
    signal TxByte        : STD_LOGIC_VECTOR (7 downto 0);
    signal TxAvail       : STD_LOGIC;
    signal TxStatus      : STD_LOGIC_VECTOR (31 downto 0);
    signal UartInterrupt : STD_LOGIC;
    signal RdByte        : STD_LOGIC_VECTOR (7 downto 0);
    signal RdStatus      : STD_LOGIC_VECTOR (31 downto 0);
    signal r_xtr         : STD_LOGIC_VECTOR(7 downto 0);

    -- Debug Items
    -- Debug Items
    signal DebugIn      : DEBUGINTYPE := 
        (DebugMode => '0',
        BreakPoints => (others => (others => '0')), 
        Break => '0', 
        Step => '0', 
        Continue => '0',
        BWhenReg => 16,
        BWhenValue => (others => '0'));
    signal DebugOut     : DEBUGOUTTYPE;

    procedure InitRamFromFile
    (RamFileName    : in  STRING;
    signal LD_CLK   : out STD_LOGIC;
    signal ENABLE   : out STD_LOGIC;
    signal W_ENABLE : out STD_LOGIC;
    signal ADDR     : out STD_LOGIC_VECTOR(11 downto 0);
    signal DOUT     : out STD_LOGIC_VECTOR(31 downto 0)
    )
    is
    file RamFile         : text is in RamFileName;
    variable RamFileLine : line;
    variable outLine     : line;
    variable good        : BOOLEAN;
    variable data1       : bit_vector(31 downto 0)                   := X"00000000";
    variable l_addr      : NATURAL range 0 to (2 ** ADDR'length - 1) := 0;
begin

    if not RUN then
        LD_CLK <= '0';
        wait for HALF_PERIOD;
        ENABLE   <= '1';
        W_ENABLE <= '1';

        -- for I in ADDR'range loop
        -- for I in 0 to 4095 loop
        while not endfile(RamFile)loop
            report "l_addr: " & INTEGER'image(l_addr);
            write(outLine, "l_addr: " & INTEGER'image(l_addr));
            writeline(output, outLine);
            ADDR <= STD_LOGIC_VECTOR(to_signed(l_addr, ADDR'length));
            readline(RamFile, RamFileLine);
            read(RamFileLine, data1, good);
            DOUT   <= to_stdlogicvector(data1);
            LD_CLK <= '1';
            wait for HALF_PERIOD;
            LD_CLK <= '0';
            wait for HALF_PERIOD;
            l_addr := l_addr + 1;
        end loop;
    end if;
end procedure;

procedure UART_DRIVER (
    constant UART_PER : TIME;
    signal UART_DIN   : in  STD_LOGIC_VECTOR(7 downto 0);
    signal UART_TXD   : out STD_LOGIC
) is
    variable rnd_delay : NATURAL;
begin
    -- start bit
    UART_TXD <= '0';
    wait for UART_PER;
    -- data bits
    for i in 0 to (UART_DIN'LENGTH - 1) loop
        UART_TXD <= UART_DIN(i);
        wait for UART_PER;
    end loop;
    -- stop bit
    UART_TXD <= '1';
    wait for UART_PER;
end procedure;

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
    MEM_ENA       => RUN_ENA,
    MEM_WEA       => RUN_WEA,
    MEM_ADDRA     => RUN_ADDRA,
    MEM_DINA      => RUN_DINA,
    MEM_DOUTA     => RUN_DOUTA,
    MEM_ENB       => MEM_ENB,
    MEM_WEB       => MEM_WEB,
    MEM_ADDRB     => MEM_ADDRB,
    MEM_DINB      => MEM_DINB,
    MEM_DOUTB     => MEM_DOUTB,
    DEBUGIN       => DebugIn,
    DEBUGOUT      => DebugOut
);

uartCUT : UartDevice
port map(
    CLK       => CLK,
    RST       => interrupt(0),
    UART_RXD  => UART_RXD,
    UART_TXD  => UART_TXD,
    TxByte    => TxByte,
    TxAvail   => TxAvail,
    TxStatus  => TxStatus,
    Interrupt => UartInterrupt,
    RdByte    => RdByte,
    RdStatus  => RdStatus
);

memory : cpumemory
port map(
    clka  => MEM_CLK,
    ena   => MEM_ENA,
    wea   => MEM_WEA,
    addra => MEM_ADDRA,
    dina  => MEM_DINA,
    douta => MEM_DOUTA,
    clkb  => MEM_CLK,
    enb   => MEM_ENB,
    web   => MEM_WEB,
    addrb => MEM_ADDRB,
    dinb  => MEM_DINB,
    doutb => MEM_DOUTB
);

-- Link the LOAD Program and RUN program memory signals.
MEM_CLK <= clk when RUN else
           LD_CLK;
MEM_ENA <= RUN_ENA when RUN else
           LD_ENA;
MEM_WEA <= RUN_WEA when RUN else
           LD_WEA;
MEM_ADDRA <= RUN_ADDRA when RUN else
             LD_ADDRA;
MEM_DINA <= RUN_DINA when RUN else
            LD_DINA;
RUN_DOUTA <= MEM_DOUTA when RUN else
             "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
LD_DOUTA <= MEM_DOUTA when not RUN else
            "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";

clk <= '0' after HALF_PERIOD when clk = '1' and RUN else
       '1' after HALF_PERIOD;

test_proc_read : process
begin
    UART_RXD <= '1';

    wait until interrupt(0) = '0';
    wait for PERIOD * 5;
    r_xtr <= X"55";
    UART_DRIVER(UART_PERIOD, r_xtr, UART_RXD);
    wait for 2 * UART_PERIOD;
    -- Send Serial Data to UART.
    r_xtr <= X"aa";
    UART_DRIVER(UART_PERIOD, r_xtr, UART_RXD);
    wait for 2 * UART_PERIOD;
    -- Send Serial Data to UART.
    r_xtr <= X"00";
    UART_DRIVER(UART_PERIOD, r_xtr, UART_RXD);
    wait for 2 * UART_PERIOD;

end process; -- test_proc_read

interrupt(12) <= UARTInterrupt;

test : process
begin

    if not RUN then
        InitRamFromFile
        ("cpumemory.mif",
        LD_CLK,
        LD_ENA,
        LD_WEA(0),
        LD_ADDRA,
        LD_DINA);
        RUN <= TRUE;
    else

        interrupt(0) <= '1';
        for j in 1 to 10 loop
            wait until rising_edge (clk);
        end loop;
        interrupt(0) <= '0';

        while true loop
            wait until rising_edge (clk);

            -- UART Device Interface
            if ioaddr = X"0c"
                and IOWena = '1'
                and IOStatusReq = '1'
            then
                IOStatus <= TxStatus;
            elsif ioaddr = X"0c"
                and IOWena = '1'
                and IOStatusReq = '0'
            then
                TxByte  <= IOWdata(7 downto 0);
                TxAvail <= '1';
            elsif ioaddr = X"0c"
                and IORena = '1'
                and IOStatusReq = '1'
            then
                IOStatus <= RdStatus;
            elsif ioaddr = X"0c"
                and IORena = '1'
                and IOStatusReq = '0'
            then
                IORdata <= X"000000" & RdByte;
            else
                TxAvail <= '0';
                -- IOStatus <= X"00000000";
            end if;

        end loop;
    end if;

end process;

end Behavioral;