----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/19/2024 03:32:31 PM
-- Design Name: 
-- Module Name: SimUartDevice - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SimUartDevice is
--  Port ( );
end SimUartDevice;

architecture Behavioral of SimUartDevice is

    component UartDevice is
        Port (  CLK         : in STD_LOGIC;
                RST         : in STD_LOGIC;
                UART_RXD    : in STD_LOGIC;
                UART_TXD    : out STD_LOGIC;
                TxByte      : in STD_LOGIC_VECTOR (7 downto 0);
                TxAvail     : in STD_LOGIC;
                TxStatus    : out STD_LOGIC_VECTOR (31 downto 0);
                Interrupt   : out STD_LOGIC;
                RdByte      : out STD_LOGIC_VECTOR (7 downto 0);
                RdStatus    : out STD_LOGIC_VECTOR (31 downto 0)
                );
    end component;

    signal CLK         : STD_LOGIC;
    signal RST         : STD_LOGIC;
    signal UART_RXD    : STD_LOGIC;
    signal UART_TXD    : STD_LOGIC;
    signal TxByte      : STD_LOGIC_VECTOR (7 downto 0);
    signal TxAvail     : STD_LOGIC;
    signal TxStatus    : STD_LOGIC_VECTOR (31 downto 0);
    signal Interrupt   : STD_LOGIC;
    signal RdByte      : STD_LOGIC_VECTOR (7 downto 0);
    signal RdStatus    : STD_LOGIC_VECTOR (31 downto 0);
    
    constant PERIOD : TIME := 10 ns;
    constant CLK_FREQ : NATURAL := 50e6;
    constant BAUD_RATE : NATURAL := 115200;
    constant TRANS_COUNT : NATURAL := 2 ** 8;
    constant CLK_PERIOD : TIME := 1 ns * INTEGER(real(1e9)/real(CLK_FREQ));
    constant UART_PERIOD_I : NATURAL := INTEGER(real(1e9)/real(BAUD_RATE));
    constant UART_PERIOD : TIME := 1 ns * UART_PERIOD_I;

    signal r_xtr : STD_LOGIC_VECTOR(7 downto 0);

    procedure UART_DRIVER (
        constant UART_PER : TIME;
        signal UART_DIN : in STD_LOGIC_VECTOR(7 downto 0);
        signal UART_TXD : out STD_LOGIC
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

    uartDev : UartDevice
    port map(
        CLK         => CLK      ,
        RST         => RST      ,
        UART_RXD    => UART_RXD ,
        UART_TXD    => UART_TXD ,
        TxByte      => TxByte   ,
        TxAvail     => TxAvail  ,
        TxStatus    => TxStatus ,
        Interrupt   => Interrupt,
        RdByte      => RdByte   ,
        RdStatus    => RdStatus         
    );

    CLK <= '0' after PERIOD / 2 when clk = '1'
           else
           '1' after PERIOD / 2;

    Reset_Proc : process
    begin
        RST <= '1';
        wait on CLK; -- look for first clock
        wait until rising_edge (CLK);

        RST <= '0' after PERIOD * 5; -- relese reset

        wait; -- wait forever
    end process;
    
    test_proc_read : process
    begin
        UART_RXD <= '1';

        wait until RST = '0';
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

    test_proc_write : process
    begin
        wait until rising_edge(clk);
        wait for PERIOD * 9;
        -- Send Data to UART to tranmit.
        wait for PERIOD * 4;
        TxByte <= X"55";
        TxAvail <= '1';
        wait until rising_edge(clk);
        TxAvail <= '0';

        wait until TxStatus(0) = '0';
        TxByte <= X"AA";
        TxAvail <= '1';
        wait until rising_edge(clk);
        TxAvail <= '0';

        wait until TxStatus(0) = '0';
        wait for PERIOD * 3;
        TxByte <= X"00";
        TxAvail <= '1';
        wait until rising_edge(clk);
        TxAvail <= '0';

        wait until TxStatus(0) = '0';
        wait for PERIOD * 4;
        TxByte <= X"11";
        TxAvail <= '1';
        wait until rising_edge(clk);
        TxAvail <= '0';

        identifier : for i in 0 to 16 loop
            wait until TxStatus(0) = '0';
            TxByte <= STD_LOGIC_VECTOR(to_unsigned(i, TxByte'length));
            TxAvail <= '1';
            wait until rising_edge(clk);
            TxAvail <= '0';
        end loop; -- identifier
        wait;
    end process; -- test_proc_read


end Behavioral;
