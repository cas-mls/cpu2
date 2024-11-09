----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/01/2024 02:43:24 PM
-- Design Name: 
-- Module Name: simComputer - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity simComputer is
--  Port ( );
end simComputer;

architecture Behavioral of simComputer is

    component Computer is
        port (
            RST         : in  STD_LOGIC;
            SYS_CLK     : in  STD_LOGIC;
            led         : out STD_LOGIC_VECTOR (3 downto 0);
            dmode       : in STD_LOGIC;
            dcont       : in STD_LOGIC;
            dstep       : in STD_LOGIC;
            dbreak      : in STD_LOGIC;
            
            uart_txd_out : out STD_LOGIC;
            uart_rxd_in  : in  STD_LOGIC
            --           rgb : out STD_LOGIC_VECTOR (5 downto 0)
        );
    end component;

    signal CLK         : STD_LOGIC;
    signal RST         : STD_LOGIC;
    signal UART_RXD    : STD_LOGIC;
    signal UART_TXD    : STD_LOGIC;
    
    constant PERIOD     : TIME := 10 ns;
    constant CLK_FREQ   : NATURAL := 50e6;
    constant BAUD_RATE  : NATURAL := 115200;
    constant TRANS_COUNT : NATURAL := 2 ** 8;
    constant CLK_PERIOD  : TIME := 1 ns * INTEGER(real(1e9)/real(CLK_FREQ));
    constant UART_PERIOD_I : NATURAL := INTEGER(real(1e9)/real(BAUD_RATE));
    constant UART_PERIOD : TIME := 1 ns * UART_PERIOD_I;

    signal led         : STD_LOGIC_VECTOR (3 downto 0);
    signal dmode       : STD_LOGIC;
    signal dcont       : STD_LOGIC;
    signal dstep       : STD_LOGIC;
    signal dbreak      : STD_LOGIC;

    signal CMD : STD_LOGIC_VECTOR(7 downto 0);
    signal ADDRESS : STD_LOGIC_VECTOR(15 downto 0);
    signal CMD_RESP : STD_LOGIC_VECTOR(7 downto 0);
    signal DATA_OUT : STD_LOGIC_VECTOR(31 downto 0);
    signal DATA_IN  : STD_LOGIC_VECTOR(31 downto 0);


    procedure UART_DRIVER (
        constant UART_PER : TIME;
        signal UART_DIN : in STD_LOGIC_VECTOR(7 downto 0);
        signal UART_RXD : out STD_LOGIC
    ) is
        variable rnd_delay : NATURAL;
    begin
        -- start bit
        UART_RXD <= '0';
        wait for UART_PER;
        -- data bits
        for i in 0 to (UART_DIN'LENGTH - 1) loop
            UART_RXD <= UART_DIN(i);
            wait for UART_PER;
        end loop;
        -- stop bit
        UART_RXD <= '1';
        wait for UART_PER;
    end procedure;

    procedure UART_MONITOR (
        constant UART_PER       : time;
        variable UART_DOUT      : out std_logic_vector(7 downto 0);
        signal   UART_TXD       : in  std_logic
    ) is 
        variable tmp : STD_LOGIC_VECTOR(7 downto 0);
    begin
        if (UART_TXD = '1') then
            wait until UART_TXD = '0';
        end if;
        -- start bit
        wait for UART_PER;
        -- data bits
        wait for UART_PER/2; -- move to middle data bit 
        for i in 0 to (UART_DOUT'LENGTH-2) loop
            -- UART_DOUT(i) <= UART_TXD;
            tmp(i) := UART_TXD;
            wait for UART_PER;
        end loop;
        -- last data bit
        -- UART_DOUT(UART_DOUT'LENGTH-1) <= UART_TXD;
        tmp(UART_DOUT'LENGTH-1) := UART_TXD;
        wait for UART_PER/2;
        -- stop bit
        -- move to middle of stop bit
        wait for UART_PER/2;
        if (UART_TXD = '0') then
            report "======== INVALID STOP BIT IN UART_MONITOR! ========" severity failure;
        end if;
        UART_DOUT := tmp;
        -- in middle of stop bit move to resync (wait for start bit)
    end procedure;

    procedure WB_READ(
        constant UART_PER   : time;
        signal UART_RXD     : out STD_LOGIC;
        signal UART_TXD     : in  STD_LOGIC;
        signal CMD          : in  STD_LOGIC_VECTOR(7 downto 0);
        signal ADDRESS      : in  STD_LOGIC_VECTOR(15 downto 0);
        signal DATA         : out STD_LOGIC_VECTOR(31 downto 0);
        signal CMD_RESP      : out STD_LOGIC_VECTOR(7 downto 0)
    ) is
        variable tmp : STD_LOGIC_VECTOR(31 downto 0);
        variable tmp2 : STD_LOGIC_VECTOR(7 downto 0);
    begin
        UART_DRIVER(UART_PERIOD, CMD, UART_RXD); -- Command
        UART_DRIVER(UART_PERIOD, ADDRESS(7 downto 0), UART_RXD); -- Low Address
        UART_DRIVER(UART_PERIOD, ADDRESS(15 downto 8), UART_RXD); -- High Address
        UART_MONITOR(UART_PERIOD, tmp2, UART_TXD); -- Command Response
        UART_MONITOR(UART_PERIOD, tmp(7 downto 0), UART_TXD); -- Data 0
        UART_MONITOR(UART_PERIOD, tmp(15 downto 8), UART_TXD); -- Data 1
        UART_MONITOR(UART_PERIOD, tmp(23 downto 16), UART_TXD); -- Data 2
        UART_MONITOR(UART_PERIOD, tmp(31 downto 24), UART_TXD); -- Data 3
        DATA <= tmp;
        CMD_RESP <= tmp2;
    end procedure;

    procedure WB_WRITE(
        constant UART_PER   : time;
        signal UART_RXD     : out STD_LOGIC;
        signal UART_TXD     : in  STD_LOGIC;
        signal CMD          : in  STD_LOGIC_VECTOR(7 downto 0);
        signal ADDRESS      : in  STD_LOGIC_VECTOR(15 downto 0);
        signal DATA         : in STD_LOGIC_VECTOR(31 downto 0);
        signal CMD_RESP      : out STD_LOGIC_VECTOR(7 downto 0)
    ) is
        variable tmp2 : STD_LOGIC_VECTOR(7 downto 0);
    begin
        UART_DRIVER(UART_PERIOD, CMD, UART_RXD); -- Command
        UART_DRIVER(UART_PERIOD, ADDRESS(7 downto 0), UART_RXD); -- Low Address
        UART_DRIVER(UART_PERIOD, ADDRESS(15 downto 8), UART_RXD); -- High Address
        UART_DRIVER(UART_PERIOD, DATA(7 downto 0), UART_RXD); -- Data 0
        UART_DRIVER(UART_PERIOD, DATA(15 downto 8), UART_RXD); -- Data 1
        UART_DRIVER(UART_PERIOD, DATA(23 downto 16), UART_RXD); -- Data 2
        UART_DRIVER(UART_PERIOD, DATA(31 downto 24), UART_RXD); -- Data 3
        UART_MONITOR(UART_PERIOD, tmp2, UART_TXD); -- Command Response
        CMD_RESP <= tmp2;
    end procedure;


begin

    computer_UUT : Computer
    port map(
        SYS_CLK         => CLK,
        RST             => RST,
        led             => led,
        dmode           => dmode,
        dcont           => dcont,
        dstep           => dstep,
        dbreak          => dbreak,
        uart_txd_out    => UART_TXD,
        uart_rxd_in     => UART_RXD
    );

    CLK <= '0' after PERIOD / 2 when clk = '1'
           else
           '1' after PERIOD / 2;

    Reset_Proc : process
    begin
        RST <= '1';
        wait on CLK; -- look for first clock
        wait until rising_edge (CLK);

        RST <= '0' after PERIOD * 5; -- release reset

        wait; -- wait forever
    end process;


    test_proc_read : process
    begin

        UART_RXD <= '1';
        dmode <= '0';
        dcont <= '0';
        dstep <= '0';
        dbreak <= '0';
        DATA_OUT <= (others => '0');
        DATA_IN <= (others => '0');
        wait until RST = '0';

        wait for PERIOD * 5;
        dmode <= '1';
        wait for PERIOD * 5;
        wait until rising_edge(clk);
        dbreak <= '1';
        wait until rising_edge(clk);
        dbreak <= '0';

        wait for PERIOD * 5;
        CMD <= X"01"; -- Command Write
        ADDRESS <= X"0001"; -- Break
        DATA_IN <= (others => '0');
        WB_WRITE(UART_PERIOD, UART_RXD, UART_TXD, CMD , ADDRESS, DATA_IN, CMD_RESP);

        CMD <= X"00"; -- Command Read (Status)
        ADDRESS <= X"0000"; -- Debug Mode (1 = Stop, 0 = Run)
        WB_READ(UART_PERIOD, UART_RXD, UART_TXD, CMD , ADDRESS, DATA_OUT, CMD_RESP);
        ADDRESS <= X"0001"; -- Program Counter
        WB_READ(UART_PERIOD, UART_RXD, UART_TXD, CMD , ADDRESS, DATA_OUT, CMD_RESP);
        ADDRESS <= X"0002"; -- Instruction
        WB_READ(UART_PERIOD, UART_RXD, UART_TXD, CMD , ADDRESS, DATA_OUT, CMD_RESP);
        ADDRESS <= X"0003"; -- Cycles
        WB_READ(UART_PERIOD, UART_RXD, UART_TXD, CMD , ADDRESS, DATA_OUT, CMD_RESP);
        wait until rising_edge(clk);
        dstep <= '1';
        wait until rising_edge(clk);
        dstep <= '0';
        ADDRESS <= X"0001"; -- Program Counter
        WB_READ(UART_PERIOD, UART_RXD, UART_TXD, CMD , ADDRESS, DATA_OUT, CMD_RESP);
        ADDRESS <= X"0002"; -- Instruction
        WB_READ(UART_PERIOD, UART_RXD, UART_TXD, CMD , ADDRESS, DATA_OUT, CMD_RESP);
        ADDRESS <= X"0003"; -- Cycles
        WB_READ(UART_PERIOD, UART_RXD, UART_TXD, CMD , ADDRESS, DATA_OUT, CMD_RESP);
        wait until rising_edge(clk);
        dstep <= '1';
        wait until rising_edge(clk);
        dstep <= '0';
        ADDRESS <= X"0001"; -- Program Counter
        WB_READ(UART_PERIOD, UART_RXD, UART_TXD, CMD , ADDRESS, DATA_OUT, CMD_RESP);
        ADDRESS <= X"0002"; -- Instruction
        WB_READ(UART_PERIOD, UART_RXD, UART_TXD, CMD , ADDRESS, DATA_OUT, CMD_RESP);
        ADDRESS <= X"0003"; -- Cycles
        WB_READ(UART_PERIOD, UART_RXD, UART_TXD, CMD , ADDRESS, DATA_OUT, CMD_RESP);

        CMD <= X"01"; -- Command Write
        ADDRESS <= X"0002"; -- Step
        DATA_IN <= (others => '0');
        WB_WRITE(UART_PERIOD, UART_RXD, UART_TXD, CMD , ADDRESS, DATA_IN, CMD_RESP);

        CMD <= X"00"; -- Command Read (Status)
        ADDRESS <= X"0001"; -- Program Counter
        WB_READ(UART_PERIOD, UART_RXD, UART_TXD, CMD , ADDRESS, DATA_OUT, CMD_RESP);
        ADDRESS <= X"0002"; -- Instruction
        WB_READ(UART_PERIOD, UART_RXD, UART_TXD, CMD , ADDRESS, DATA_OUT, CMD_RESP);
        ADDRESS <= X"0003"; -- Cycles
        WB_READ(UART_PERIOD, UART_RXD, UART_TXD, CMD , ADDRESS, DATA_OUT, CMD_RESP);


        wait;

    end process;


end Behavioral;
