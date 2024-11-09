--------------------------------------------------------------------------------
-- PROJECT: SIMPLE UART FOR FPGA
--------------------------------------------------------------------------------
-- AUTHORS: Jakub Cabal <jakubcabal@gmail.com>
-- LICENSE: The MIT License, please read LICENSE file
-- WEBSITE: https://github.com/jakubcabal/uart-for-fpga
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UART2WBM is
    Port (
        -- CLOCK AND RESET
        CLK      : in  std_logic;
        RST      : in  std_logic;
        -- UART INTERFACE
        -- UART_TXD : out std_logic;
        -- UART_RXD : in  std_logic;
        TxByte    : out STD_LOGIC_VECTOR (7 downto 0);
        TxAvail   : out STD_LOGIC;
        TxReady   : in  STD_LOGIC; -- not TxStatus(0)
        RdByte    : in  STD_LOGIC_VECTOR (7 downto 0);
        RdValid   : in  STD_LOGIC; -- not RxStatus(0)
    

        -- WISHBONE MASTER INTERFACE
        WB_CYC   : out std_logic;   -- CYC_O The cycle output [CYC_O], when asserted, indicates that a valid bus cycle is in progress.
                                    -- The [CYC_O] signal is asserted during the first data transfer, and remains asserted until the
                                    -- last data transfer.
        WB_STB   : out std_logic;   -- The strobe output [STB_O] indicates a valid data transfer cycle.
                                    -- The SLAVE asserts either the [ACK_I], [ERR_I] or [RTY_I] signals in response to every assertion
                                    -- of the [STB_O] signal.
        WB_WE    : out std_logic;   -- The write enable output [WE_O] indicates whether the current local bus cycle is a READ or WRITE cycle.
                                    -- The signal is negated during READ cycles, and is asserted during WRITE cycles.
                                    -- Set by Command (CMD) bit 0
        WB_ADDR  : out std_logic_vector(15 downto 0);   -- The address output array [ADR_O()] is used to pass a binary address..
        WB_TGA   : out std_logic_vector(6 downto 0); -- Address tag type [TGA_O()] contains information associated with address lines [ADR_O()], and
                                    --is qualified by signal [STB_O].
                                    -- Set by Uart Command (CMD) bits 1-7.
        WB_DOUT  : out std_logic_vector(31 downto 0);   -- The data output array [DAT_O()] is used to pass binary data.
        WB_STALL : in  std_logic;   -- The pipeline stall input [STALL_I] indicates that current slave is not able to accept the transfer in the transaction queue.
        WB_ACK   : in  std_logic;   -- The acknowledge input [ACK_I], when asserted, indicates the normal termination of a bus cycle.
        WB_DIN   : in  std_logic_vector(31 downto 0)    -- DAT_I() The data input array [DAT_I()] is used to pass binary data.
    );
end entity;

architecture RTL of UART2WBM is


    type state is (cmd, addr_low, addr_high, dout0, dout1, dout2, dout3,
        request, wait4ack, response, din0, din1, din2, din3);
    signal fsm_pstate : state;
    signal fsm_nstate : state;

    signal cmd_reg   : std_logic_vector(7 downto 0);
    signal cmd_next  : std_logic_vector(7 downto 0);
    signal addr_reg  : std_logic_vector(15 downto 0);
    signal addr_next : std_logic_vector(15 downto 0);
    signal dout_reg  : std_logic_vector(31 downto 0);
    signal dout_next : std_logic_vector(31 downto 0);
    signal din_reg   : std_logic_vector(31 downto 0);

    signal uart_dout     : std_logic_vector(7 downto 0);
    signal uart_dout_vld : std_logic;
    signal uart_din      : std_logic_vector(7 downto 0);
    signal uart_din_vld  : std_logic;
    signal uart_din_rdy  : std_logic;

    attribute keep          : STRING;
    attribute MARK_DEBUG    : string;
    attribute keep          of fsm_pstate   : signal is "TRUE";
    attribute MARK_DEBUG    of fsm_pstate   : signal is "TRUE";
    attribute keep          of fsm_nstate   : signal is "TRUE";
    attribute MARK_DEBUG    of fsm_nstate   : signal is "TRUE";
    attribute keep          of cmd_reg      : signal is "TRUE";
    attribute MARK_DEBUG    of cmd_reg      : signal is "TRUE";
    attribute keep          of addr_reg     : signal is "TRUE";
    attribute MARK_DEBUG    of addr_reg     : signal is "TRUE";
    attribute keep          of din_reg      : signal is "TRUE";
    attribute MARK_DEBUG    of din_reg      : signal is "TRUE";
    attribute keep          of dout_reg     : signal is "TRUE";
    attribute MARK_DEBUG    of dout_reg     : signal is "TRUE";
    attribute keep          of uart_dout    : signal is "TRUE";
    attribute MARK_DEBUG    of uart_dout    : signal is "TRUE";
    attribute keep          of uart_din     : signal is "TRUE";
    attribute MARK_DEBUG    of uart_din     : signal is "TRUE";


begin

    process (CLK)
    begin
        if (rising_edge(CLK)) then
            cmd_reg  <= cmd_next;
            addr_reg <= addr_next;
            dout_reg <= dout_next;
        end if;
    end process;

    WB_WE <= cmd_reg(0);
    WB_TGA <= cmd_reg(7 downto 1);
    WB_ADDR <= addr_reg;
    WB_DOUT <= dout_reg;

    uart_dout_vld <= RdValid;
    uart_dout <= RdByte;

    uart_din_rdy <= TxReady;
    TxByte <= uart_din;
    TxAvail <= uart_din_vld;

    process (CLK)
    begin
        if (rising_edge(CLK)) then
            if (WB_ACK = '1') then
                din_reg <= WB_DIN;
            end if;
        end if;
    end process;

    -- -------------------------------------------------------------------------
    --  FSM
    -- -------------------------------------------------------------------------

    process (CLK)
    begin
        if (rising_edge(CLK)) then
            if (RST = '1') then
                fsm_pstate <= cmd;
            else
                fsm_pstate <= fsm_nstate;
            end if;
        end if;
    end process;

    process (fsm_pstate, uart_dout, uart_dout_vld, cmd_reg, addr_reg, dout_reg,
        WB_STALL, WB_ACK, uart_din_rdy, din_reg)
    begin
        fsm_nstate   <= cmd;
        cmd_next     <= cmd_reg;
        addr_next    <= addr_reg;
        dout_next    <= dout_reg;
        WB_STB       <= '0';
        WB_CYC       <= '0';
        uart_din     <= cmd_reg;
        uart_din_vld <= '0';

        case fsm_pstate is
            when cmd => -- idle and read request cmd from UART
                cmd_next <= uart_dout;

                if (uart_dout_vld = '1') then
                    fsm_nstate <= addr_low;
                else
                    fsm_nstate <= cmd;
                end if;

            when addr_low => -- read low bits of address from UART
                addr_next(7 downto 0) <= uart_dout;

                if (uart_dout_vld = '1') then
                    fsm_nstate <= addr_high;
                else
                    fsm_nstate <= addr_low;
                end if;

            when addr_high => -- read high bits of address from UART
                addr_next(15 downto 8) <= uart_dout;

                if (uart_dout_vld = '1') then
                    if (cmd_reg(0) = '1') then
                        fsm_nstate <= dout0; -- write cmd
                    else
                        fsm_nstate <= request; -- read cmd
                    end if;
                else
                    fsm_nstate <= addr_high;
                end if;

            when dout0 => -- read data byte 0 from UART (write cmd only)
                dout_next(7 downto 0) <= uart_dout;

                if (uart_dout_vld = '1') then
                    fsm_nstate <= dout1;
                else
                    fsm_nstate <= dout0;
                end if;

            when dout1 => -- read data byte 1 from UART (write cmd only)
                dout_next(15 downto 8) <= uart_dout;

                if (uart_dout_vld = '1') then
                    fsm_nstate <= dout2;
                else
                    fsm_nstate <= dout1;
                end if;

            when dout2 => -- read data byte 2 from UART (write cmd only)
                dout_next(23 downto 16) <= uart_dout;

                if (uart_dout_vld = '1') then
                    fsm_nstate <= dout3;
                else
                    fsm_nstate <= dout2;
                end if;

            when dout3 => -- read data byte 3 from UART (write cmd only)
                dout_next(31 downto 24) <= uart_dout;

                if (uart_dout_vld = '1') then
                    fsm_nstate <= request; -- write request
                else
                    fsm_nstate <= dout3;
                end if;

            when request => -- send WR or RD request to Wishbone bus
                WB_STB <= '1'; -- request is valid
                WB_CYC <= '1';

                if (WB_STALL = '0') then
                    fsm_nstate <= wait4ack;
                else
                    fsm_nstate <= request;
                end if;

            when wait4ack => -- wait for ACK on Wishbone bus
                WB_CYC <= '1';

                if (WB_ACK = '1') then
                    fsm_nstate <= response;
                else
                    fsm_nstate <= wait4ack;
                end if;

            when response => -- send response cmd to UART
                uart_din     <= cmd_reg;
                uart_din_vld <= '1';

                if (uart_din_rdy = '1') then
                    if (cmd_reg(0) = '1') then
                        fsm_nstate <= cmd; -- idle or new read request cmd (write cmd only)
                    else
                        fsm_nstate <= din0; -- send read data to UART (read cmd only)
                    end if;
                else
                    fsm_nstate <= response;
                end if;

            when din0 => -- send read data byte 0 to UART (read cmd only)
                uart_din     <= din_reg(7 downto 0);
                uart_din_vld <= '1';

                if (uart_din_rdy = '1') then
                    fsm_nstate <= din1;
                else
                    fsm_nstate <= din0;
                end if;

            when din1 => -- send read data byte 1 to UART (read cmd only)
                uart_din     <= din_reg(15 downto 8);
                uart_din_vld <= '1';

                if (uart_din_rdy = '1') then
                    fsm_nstate <= din2;
                else
                    fsm_nstate <= din1;
                end if;

            when din2 => -- send read data byte 2 to UART (read cmd only)
                uart_din     <= din_reg(23 downto 16);
                uart_din_vld <= '1';

                if (uart_din_rdy = '1') then
                    fsm_nstate <= din3;
                else
                    fsm_nstate <= din2;
                end if;

            when din3 => -- send read data byte 3 to UART (read cmd only)
                uart_din     <= din_reg(31 downto 24);
                uart_din_vld <= '1';

                if (uart_din_rdy = '1') then
                    fsm_nstate <= cmd;
                else
                    fsm_nstate <= din3;
                end if;

        end case;
    end process;

end architecture;
