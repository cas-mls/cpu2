-- vhdl-linter-disable type-resolved component
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/18/2024 09:46:44 AM
-- Design Name: 
-- Module Name: UartDevice - Behavioral
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

    --  TxStatus and RdStatus
        -- Bit 0 - Busy
        -- Bits 1-2 AXI-Lite Response
            -- b00 = OKAY   - OK
            -- b01 = EXOKAY - OK with Exclusive Access
            -- b10 = SLVERR - Unsuccessful
            -- b11 = DECERR - Decode Error
        --  Bits 3-10 AXI Uart Lite status
            -- Bit 03   - Rx FIFO Valid Data
            -- Bit 04   - Rx FIFO Full
            -- Bit 05   - Tx FIFO Empty
            -- Bit 06   - Tx FIFO Full
            -- Bit 07   - Intr Enabled
            -- Bit 08   - Overrun Error
            -- Bit 09   - Frame Error
            -- Bit 10   - Parity Error




entity UartDevice is
    Port (  CLK      : in STD_LOGIC;
            RST     : in STD_LOGIC;
            UART_RXD : in STD_LOGIC;
            UART_TXD : out STD_LOGIC;
            TxByte : in STD_LOGIC_VECTOR (7 downto 0);
            TxAvail : in STD_LOGIC;
            TxStatus : out STD_LOGIC_VECTOR (31 downto 0);
            Interrupt : out STD_LOGIC;
            RdByte : out STD_LOGIC_VECTOR (7 downto 0);
            RdStatus : out STD_LOGIC_VECTOR (31 downto 0));
end UartDevice;

architecture Behavioral of UartDevice is

    component SerialDevice115k
        port (
            s_axi_aclk    : in  STD_LOGIC;
            s_axi_aresetn : in  STD_LOGIC;
            interrupt     : out STD_LOGIC;
            s_axi_awaddr  : in  STD_LOGIC_VECTOR(3 downto 0);
            s_axi_awvalid : in  STD_LOGIC;
            s_axi_awready : out STD_LOGIC;
            s_axi_wdata   : in  STD_LOGIC_VECTOR(31 downto 0);
            s_axi_wstrb   : in  STD_LOGIC_VECTOR(3 downto 0);
            s_axi_wvalid  : in  STD_LOGIC;
            s_axi_wready  : out STD_LOGIC;
            s_axi_bresp   : out STD_LOGIC_VECTOR(1 downto 0);
            s_axi_bvalid  : out STD_LOGIC;
            s_axi_bready  : in  STD_LOGIC;
            s_axi_araddr  : in  STD_LOGIC_VECTOR(3 downto 0);
            s_axi_arvalid : in  STD_LOGIC;
            s_axi_arready : out STD_LOGIC;
            s_axi_rdata   : out STD_LOGIC_VECTOR(31 downto 0);
            s_axi_rresp   : out STD_LOGIC_VECTOR(1 downto 0);
            s_axi_rvalid  : out STD_LOGIC;
            s_axi_rready  : in  STD_LOGIC;
            rx            : in  STD_LOGIC;
            tx            : out STD_LOGIC
        );
    end component;  -- vhdl-linter-disable-line component

    -- Read Uart-Light signals
    signal r_s_axi_aresetn : STD_LOGIC;
    signal r_uartInterrupt : STD_LOGIC;
    signal r_s_axi_awaddr : STD_LOGIC_VECTOR(3 downto 0);
    signal r_s_axi_awvalid : STD_LOGIC;
    signal r_s_axi_awready : STD_LOGIC;
    signal r_s_axi_wdata : STD_LOGIC_VECTOR(31 downto 0);
    signal r_s_axi_wvalid : STD_LOGIC;
    signal r_s_axi_wready : STD_LOGIC;
    signal r_s_axi_bresp : STD_LOGIC_VECTOR(1 downto 0);
    signal r_s_axi_bvalid : STD_LOGIC;
    signal r_s_axi_bready : STD_LOGIC;
    signal r_s_axi_araddr : STD_LOGIC_VECTOR(3 downto 0);
    signal r_s_axi_arvalid : STD_LOGIC;
    signal r_s_axi_arready : STD_LOGIC;
    signal r_s_axi_rdata : STD_LOGIC_VECTOR(31 downto 0);
    signal r_s_axi_rresp : STD_LOGIC_VECTOR(1 downto 0);
    signal r_s_axi_rvalid : STD_LOGIC;
    signal r_s_axi_rready : STD_LOGIC;

    -- Other Read Flag signals.
    signal r_initialize : STD_LOGIC;

    -- Write Uart-Light Signals
    signal w_s_axi_aresetn : STD_LOGIC;
    signal w_s_axi_awaddr : STD_LOGIC_VECTOR(3 downto 0);
    signal w_s_axi_awvalid : STD_LOGIC;
    signal w_s_axi_awready : STD_LOGIC;
    signal w_s_axi_wdata : STD_LOGIC_VECTOR(31 downto 0);
    signal w_s_axi_wvalid : STD_LOGIC;
    signal w_s_axi_wready : STD_LOGIC;
    signal w_s_axi_bresp : STD_LOGIC_VECTOR(1 downto 0);
    signal w_s_axi_bvalid : STD_LOGIC;
    signal w_s_axi_bready : STD_LOGIC;
    signal w_s_axi_araddr : STD_LOGIC_VECTOR(3 downto 0);
    signal w_s_axi_arvalid : STD_LOGIC;
    signal w_s_axi_arready : STD_LOGIC;
    signal w_s_axi_rdata : STD_LOGIC_VECTOR(31 downto 0);
    signal w_s_axi_rresp : STD_LOGIC_VECTOR(1 downto 0);
    signal w_s_axi_rvalid : STD_LOGIC;
    signal w_s_axi_rready : STD_LOGIC;
    signal w_UART_RX : STD_LOGIC := '1';

    -- Other Write Flag Signals
    signal w_write_processing : STD_LOGIC;
    signal w_status_processing : STD_LOGIC;
    -- Write Status Flags
    signal w_Busy : STD_LOGIC;
    signal w_Response : STD_LOGIC_VECTOR(1 downto 0);
    signal w_Status : STD_LOGIC_VECTOR(7 downto 0);

begin

    w_s_axi_aresetn <= not RST;
    r_s_axi_aresetn <= not RST;
    TxStatus <= B"000000000000000000000" & w_Status & w_Response & w_Busy;

    uartRead : SerialDevice115k
    port map(
        s_axi_aclk    => CLK,
        s_axi_aresetn => r_s_axi_aresetn,
        interrupt     => r_uartInterrupt,
        s_axi_awaddr  => r_s_axi_awaddr,
        s_axi_awvalid => r_s_axi_awvalid,
        s_axi_awready => r_s_axi_awready,
        s_axi_wdata   => r_s_axi_wdata,
        s_axi_wstrb   => X"F",
        s_axi_wvalid  => r_s_axi_wvalid,
        s_axi_wready  => r_s_axi_wready,
        s_axi_bresp   => r_s_axi_bresp,
        s_axi_bvalid  => r_s_axi_bvalid,
        s_axi_bready  => r_s_axi_bready,
        s_axi_araddr  => r_s_axi_araddr,
        s_axi_arvalid => r_s_axi_arvalid,
        s_axi_arready => r_s_axi_arready,
        s_axi_rdata   => r_s_axi_rdata,
        s_axi_rresp   => r_s_axi_rresp,
        s_axi_rvalid  => r_s_axi_rvalid,
        s_axi_rready  => r_s_axi_rready,
        rx            => UART_RXD
    );

    read : process (CLK)
    begin

        if rising_edge(CLK) then

            if RST = '1' then
                r_s_axi_araddr <= (others => '0');
                r_s_axi_arvalid <= '0';
                r_initialize <= '1';
                interrupt <= '0';
                RdStatus <= (others => '0');
                r_s_axi_bready <= '1';
            else
                if r_initialize = '1' then
                    -- Set Control Register
                    r_s_axi_awaddr <= X"c";
                    r_s_axi_wdata <= X"00000010";
                    r_s_axi_awvalid <= '1';
                    r_s_axi_wvalid <= '1';
                    r_s_axi_rready <= '1';
                    if r_s_axi_wready = '1' then
                        r_s_axi_awvalid <= '0';
                        r_s_axi_wvalid <= '0';
                        r_s_axi_rready <= '0';
                        r_initialize <= '0';
                    end if;
                elsif r_uartInterrupt = '1'
                then
                    RdStatus(0) <= '1';
                elsif RdStatus(0) = '1'
                    and r_s_axi_arvalid = '0' -- Wait for Last Status is completed.  -- XXX - better check would be r_s_axi_arready, but doesn't work
                    and r_s_axi_rvalid = '0' -- to start reading.
                then -- Read Data
                    r_s_axi_araddr <= X"0";
                    r_s_axi_arvalid <= '1';
                    interrupt <= '1';
                else
                    if r_s_axi_rready = '0'
                        and r_s_axi_rvalid = '0'
                        and RdStatus(0) = '0'
                    then -- Get Status Register.
                        r_s_axi_araddr <= X"8";
                        r_s_axi_arvalid <= '1';
                    end if;
                end if;

                if r_s_axi_arready = '1' then
                    r_s_axi_arvalid <= '0';
                    r_s_axi_rready <= '1';
                end if;

                if r_s_axi_rvalid = '1'
                then
                    r_s_axi_rready <= '0';
                    if r_s_axi_araddr = X"0"
                    then -- Read Data
                        RdByte <= r_s_axi_rdata(7 downto 0);
                        interrupt <= '0';
                        RdStatus(0) <= '0';
                        RdStatus(2 downto 1) <= r_s_axi_rresp;
                    elsif r_s_axi_araddr = X"8"
                    then -- Read Status
                        RdStatus(10 downto 3) <= r_s_axi_rdata(7 downto 0);
                    end if;
                end if;
            end if;
        end if;
    end process;

    uartWrite : SerialDevice115k
    port map(
        s_axi_aclk    => CLK,
        s_axi_aresetn => w_s_axi_aresetn,
        s_axi_awaddr  => w_s_axi_awaddr,
        s_axi_awvalid => w_s_axi_awvalid,
        s_axi_awready => w_s_axi_awready,
        s_axi_wdata   => w_s_axi_wdata,
        s_axi_wstrb   => X"F",
        s_axi_wvalid  => w_s_axi_wvalid,
        s_axi_wready  => w_s_axi_wready,
        s_axi_bresp   => w_s_axi_bresp,
        s_axi_bvalid  => w_s_axi_bvalid,
        s_axi_bready  => w_s_axi_bready,
        s_axi_araddr  => w_s_axi_araddr,
        s_axi_arvalid => w_s_axi_arvalid,
        s_axi_arready => w_s_axi_arready,
        s_axi_rdata   => w_s_axi_rdata,
        s_axi_rresp   => w_s_axi_rresp,
        s_axi_rvalid  => w_s_axi_rvalid,
        s_axi_rready  => w_s_axi_rready,
        rx            => w_UART_RX,
        tx            => UART_TXD
    );



    write_proc : process (CLK)

    begin

        if rising_edge(CLK) then
            if RST = '1' then
                w_s_axi_awaddr <= (others => '0');
                w_s_axi_awvalid <= '0';
                w_s_axi_wdata <= (others => '0');
                w_s_axi_wvalid <= '0';
                w_Busy <= '0';
            else
                if w_Busy = '0' then
                    if TxAvail = '1' then -- Set up Write
                        w_Busy <= '1'; -- Set Busy Flag
                        w_s_axi_awaddr <= X"4";
                        w_s_axi_awvalid <= '1';
                        w_s_axi_wdata <= X"000000" & TxByte;
                        w_s_axi_wvalid <= '1';
                    end if;
                else -- Busy
                    if w_s_axi_wready = '1' then -- Finish Write
                        w_s_axi_awvalid <= '0';
                        w_s_axi_wvalid <= '0';
                        w_Busy <= '0';
                    end if;
                end if;

            end if;
        end if;
    end process write_proc; -- write_proc

    write_status_proc : process (CLK)
    begin

        if rising_edge(CLK) then
            if RST = '1' then
                w_Status <= (others => '0');
                w_s_axi_rready <= '1';
                w_s_axi_araddr <= X"8";
                w_s_axi_arvalid <= '1';
            else
                if w_Busy = '0' then
                    if w_s_axi_arready = '1' then
                        w_s_axi_arvalid <= '1';
                    end if;
                    if w_s_axi_rvalid = '1' then
                        w_s_axi_arvalid <= '0';
                        w_Status <= w_s_axi_rdata(7 downto 0);
                    end if;
                end if;
            end if;
        end if;

    end process write_status_proc;

    write_response_proc : process (CLK)
    begin

        if rising_edge(CLK) then
            if RST = '1' then
                w_Response <= (others => '0');
                w_s_axi_bready <= '1';
            else
                if w_Busy = '0' then
                    if w_s_axi_bvalid = '1' then
                        w_Response <= w_s_axi_bresp;
                    end if;
                end if;
            end if;
        end if;

    end process write_response_proc;


end Behavioral;
