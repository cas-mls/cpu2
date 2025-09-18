----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/01/2025 04:44:35 PM
-- Design Name: 
-- Module Name: sim_AxiMemory - Behavioral
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
use std.env.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sim_AxiMemory is
--  Port ( );
end sim_AxiMemory;

architecture Behavioral of sim_AxiMemory is

  COMPONENT axi_vip_0
    PORT (
      aclk : IN STD_LOGIC;
      aresetn : IN STD_LOGIC;
      s_axi_awaddr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      s_axi_awvalid : IN STD_LOGIC;
      s_axi_awready : OUT STD_LOGIC;
      s_axi_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      s_axi_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axi_wvalid : IN STD_LOGIC;
      s_axi_wready : OUT STD_LOGIC;
      s_axi_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_bvalid : OUT STD_LOGIC;
      s_axi_bready : IN STD_LOGIC;
      s_axi_araddr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      s_axi_arvalid : IN STD_LOGIC;
      s_axi_arready : OUT STD_LOGIC;
      s_axi_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      s_axi_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_rvalid : OUT STD_LOGIC;
      s_axi_rready : IN STD_LOGIC;
      m_axi_awaddr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      m_axi_awvalid : OUT STD_LOGIC;
      m_axi_awready : IN STD_LOGIC;
      m_axi_wdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      m_axi_wstrb : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axi_wvalid : OUT STD_LOGIC;
      m_axi_wready : IN STD_LOGIC;
      m_axi_bresp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      m_axi_bvalid : IN STD_LOGIC;
      m_axi_bready : OUT STD_LOGIC;
      m_axi_araddr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      m_axi_arvalid : OUT STD_LOGIC;
      m_axi_arready : IN STD_LOGIC;
      m_axi_rdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      m_axi_rresp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      m_axi_rvalid : IN STD_LOGIC;
      m_axi_rready : OUT STD_LOGIC 
    );
  END COMPONENT;


        COMPONENT cpuAxiMemory
    PORT (
        rsta_busy : OUT STD_LOGIC;
        rstb_busy : OUT STD_LOGIC;
        s_aclk : IN STD_LOGIC;
        s_aresetn : IN STD_LOGIC;
        s_axi_awid : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_awaddr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axi_awvalid : IN STD_LOGIC;
        s_axi_awready : OUT STD_LOGIC;
        s_axi_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axi_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        s_axi_wvalid : IN STD_LOGIC;
        s_axi_wready : OUT STD_LOGIC;
        s_axi_bid : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_bvalid : OUT STD_LOGIC;
        s_axi_bready : IN STD_LOGIC;
        s_axi_arid : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_araddr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axi_arvalid : IN STD_LOGIC;
        s_axi_arready : OUT STD_LOGIC;
        s_axi_rid : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axi_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_rvalid : OUT STD_LOGIC;
        s_axi_rready : IN STD_LOGIC 
    );
    END COMPONENT;


    constant HALF_PERIOD : TIME := 5 ns;

    constant PERIOD        : TIME    := 10 ns;
    constant CLK_FREQ      : NATURAL := 50e6;
    constant BAUD_RATE     : NATURAL := 115200;
    constant TRANS_COUNT   : NATURAL := 2 ** 8;
    constant CLK_PERIOD    : TIME    := 1 ns * INTEGER(real(1e9)/real(CLK_FREQ));
    constant UART_PERIOD_I : NATURAL := INTEGER(real(1e9)/real(BAUD_RATE));
    constant UART_PERIOD   : TIME    := 1 ns * UART_PERIOD_I;


    signal clk         : STD_LOGIC;


    -- AXI Memory Interface
    signal axi4MemoryWriteOut : AXI4_MEMORY_WRITE_OUT_TYPE_REC := AXI4_MEMORY_WRITE_OUT_DEFAULTS;
    signal axi4MemoryWriteIn : AXI4_MEMORY_WRITE_IN_TYPE_REC;
    signal axi4MemoryReadOut  : AXI4_MEMORY_READ_OUT_TYPE_REC := AXI4_MEMORY_READ_OUT_DEFAULTS;
    signal axi4MemoryReadIn  : AXI4_MEMORY_READ_IN_TYPE_REC;



    signal rsta_busy       : STD_LOGIC;
    signal rstb_busy       : STD_LOGIC;
    signal s_aclk          : STD_LOGIC;
    signal s_aresetn       : STD_LOGIC := '1';

    -- AXI VIP Interface
    signal axi4VMemoryWriteOut : AXI4_MEMORY_WRITE_OUT_TYPE_REC := AXI4_MEMORY_WRITE_OUT_DEFAULTS;
    signal axi4VMemoryWriteIn : AXI4_MEMORY_WRITE_IN_TYPE_REC;
    signal axi4VMemoryReadOut  : AXI4_MEMORY_READ_OUT_TYPE_REC := AXI4_MEMORY_READ_OUT_DEFAULTS;
    signal axi4VMemoryReadIn  : AXI4_MEMORY_READ_IN_TYPE_REC;

    signal test_number : integer := 0;
    signal dataValue : std_logic_vector(31 downto 0) := (others => '0');



begin


    cpuMemoryAxi : cpuAxiMemory
  PORT MAP (
    rsta_busy       => rsta_busy,
    rstb_busy       => rstb_busy,
    s_aclk          => s_aclk,
    s_aresetn       => s_aresetn,
    s_axi_awid      => axi4MemoryWriteOut.s_axi_awid,
    s_axi_awaddr    => axi4VMemoryWriteOut.s_axi_awaddr,
    s_axi_awvalid   => axi4VMemoryWriteOut.s_axi_awvalid,
    s_axi_awready   => axi4VMemoryWriteIn.s_axi_awready,
    s_axi_wdata     => axi4VMemoryWriteOut.s_axi_wdata,
    s_axi_wstrb     => axi4VMemoryWriteOut.s_axi_wstrb,
    s_axi_wvalid    => axi4VMemoryWriteOut.s_axi_wvalid,
    s_axi_wready    => axi4VMemoryWriteIn.s_axi_wready,
    s_axi_bid       => axi4MemoryWriteIn.s_axi_bid,
    s_axi_bresp     => axi4VMemoryWriteIn.s_axi_bresp,
    s_axi_bvalid    => axi4VMemoryWriteIn.s_axi_bvalid,
    s_axi_bready    => axi4VMemoryWriteOut.s_axi_bready,
    s_axi_arid      => axi4MemoryReadOut.s_axi_arid,
    s_axi_araddr    => axi4VMemoryReadOut.s_axi_araddr,
    s_axi_arvalid   => axi4VMemoryReadOut.s_axi_arvalid,
    s_axi_arready   => axi4VMemoryReadIn.s_axi_arready,
    s_axi_rid       => axi4MemoryReadIn.s_axi_rid,
    s_axi_rdata     => axi4VMemoryReadIn.s_axi_rdata,
    s_axi_rresp     => axi4VMemoryReadIn.s_axi_rresp,
    s_axi_rvalid    => axi4VMemoryReadIn.s_axi_rvalid,
    s_axi_rready    => axi4VMemoryReadOut.s_axi_rready
  );

  testprotocol : axi_vip_0
  PORT MAP (
    aclk => s_aclk,
    aresetn => s_aresetn,
    s_axi_awaddr => axi4MemoryWriteOut.s_axi_awaddr,
    s_axi_awvalid => axi4MemoryWriteOut.s_axi_awvalid,
    s_axi_awready => axi4MemoryWriteIn.s_axi_awready,
    s_axi_wdata => axi4MemoryWriteOut.s_axi_wdata,
    s_axi_wstrb => axi4MemoryWriteOut.s_axi_wstrb,
    s_axi_wvalid => axi4MemoryWriteOut.s_axi_wvalid,
    s_axi_wready => axi4MemoryWriteIn.s_axi_wready,
    s_axi_bresp => axi4MemoryWriteIn.s_axi_bresp,
    s_axi_bvalid => axi4MemoryWriteIn.s_axi_bvalid,
    s_axi_bready => axi4MemoryWriteOut.s_axi_bready,
    s_axi_araddr => axi4MemoryReadOut.s_axi_araddr,
    s_axi_arvalid => axi4MemoryReadOut.s_axi_arvalid,
    s_axi_arready => axi4MemoryReadIn.s_axi_arready,
    s_axi_rdata => axi4MemoryReadIn.s_axi_rdata,
    s_axi_rresp => axi4MemoryReadIn.s_axi_rresp,
    s_axi_rvalid => axi4MemoryReadIn.s_axi_rvalid,
    s_axi_rready => axi4MemoryReadOut.s_axi_rready,
    m_axi_awaddr => axi4VMemoryWriteOut.s_axi_awaddr,
    m_axi_awvalid => axi4VMemoryWriteOut.s_axi_awvalid,
    m_axi_awready => axi4VMemoryWriteIn.s_axi_awready,
    m_axi_wdata => axi4VMemoryWriteOut.s_axi_wdata,
    m_axi_wstrb => axi4VMemoryWriteOut.s_axi_wstrb,
    m_axi_wvalid => axi4VMemoryWriteOut.s_axi_wvalid,
    m_axi_wready => axi4VMemoryWriteIn.s_axi_wready,
    m_axi_bresp => axi4VMemoryWriteIn.s_axi_bresp,
    m_axi_bvalid => axi4VMemoryWriteIn.s_axi_bvalid,
    m_axi_bready => axi4VMemoryWriteOut.s_axi_bready,
    m_axi_araddr => axi4VMemoryReadOut.s_axi_araddr,
    m_axi_arvalid => axi4VMemoryReadOut.s_axi_arvalid,
    m_axi_arready => axi4VMemoryReadIn.s_axi_arready,
    m_axi_rdata => axi4VMemoryReadIn.s_axi_rdata,
    m_axi_rresp => axi4VMemoryReadIn.s_axi_rresp,
    m_axi_rvalid => axi4VMemoryReadIn.s_axi_rvalid,
    m_axi_rready => axi4VMemoryReadOut.s_axi_rready
  );


-- Clock Generation

clk <= '0' after HALF_PERIOD when clk = '1' else
       '1' after HALF_PERIOD;

s_aclk <= clk;



-- test_memory : process
-- begin

--     wait until s_aresetn = '1' and rsta_busy = '0' and rstb_busy = '0' and rising_edge (clk);
    
--     wait until rising_edge (clk);
--     wait until rising_edge (clk);

--     -- #1 Write
--     axi4MemoryWriteOut.s_axi_awvalid <= '1';
--     axi4MemoryWriteOut.s_axi_awaddr <= X"00000000";
--     axi4MemoryWriteOut.s_axi_awid   <= "01";
--     axi4MemoryWriteOut.s_axi_wvalid  <= '1';
--     axi4MemoryWriteOut.s_axi_wdata   <= X"DEADBEEF";
--     axi4MemoryWriteOut.s_axi_wstrb   <= "1111";
--     axi4MemoryWriteOut.s_axi_bready  <= '1';
    
--     wait until axi4MemoryWriteIn.s_axi_awready = '1'
--         and axi4MemoryWriteOut.s_axi_awvalid = '1' 
--         and rising_edge (clk);
--     axi4MemoryWriteOut.s_axi_awvalid <= '0';
--     axi4MemoryWriteOut.s_axi_awaddr <= (others => '0');

--     wait until axi4MemoryWriteIn.s_axi_wready = '1' 
--         and axi4MemoryWriteOut.s_axi_wvalid = '1' 
--         and rising_edge (clk);
--     axi4MemoryWriteOut.s_axi_wvalid <= '0';
--     axi4MemoryWriteOut.s_axi_wdata <= (others => '0');

--     wait until axi4MemoryWriteIn.s_axi_bvalid = '1' 
--         and axi4MemoryWriteOut.s_axi_bready = '1'
--         and rising_edge (clk);
--     axi4MemoryWriteOut.s_axi_bready <= '0';


--     -- #1 Read
--     wait until rising_edge (clk);
--     wait until axi4MemoryReadIn.s_axi_arready = '1' and rising_edge (clk);
--     axi4MemoryReadOut.s_axi_arvalid <= '1';
--     axi4MemoryReadOut.s_axi_araddr  <= X"00000080";
--     axi4MemoryReadOut.s_axi_arid    <= "10";

--     --  This wait is required for the Read to work.
--     wait until rising_edge (clk);
--     wait until rising_edge (clk);
--     wait until rising_edge (clk);
--     wait until rising_edge (clk);
--     axi4MemoryReadOut.s_axi_rready  <= '1';
--     wait until axi4MemoryReadIn.s_axi_arready = '1' and rising_edge (clk);
--     axi4MemoryReadOut.s_axi_arvalid <= '0';

--     wait until axi4MemoryReadIn.s_axi_rvalid = '1' and rising_edge (clk);
--     axi4MemoryReadOut.s_axi_rready  <= '0';

--     -- #2 Read
--     wait until rising_edge (clk);
--     wait until axi4MemoryReadIn.s_axi_arready = '1' and rising_edge (clk);
--     axi4MemoryReadOut.s_axi_arvalid <= '1';
--     axi4MemoryReadOut.s_axi_araddr  <= X"00000000";
--     axi4MemoryReadOut.s_axi_arid    <= "10";

--     --  This wait is required for the Read to work.
--     wait until rising_edge (clk);
--     axi4MemoryReadOut.s_axi_rready  <= '1';
--     wait until axi4MemoryReadIn.s_axi_arready = '1' and rising_edge (clk);
--     axi4MemoryReadOut.s_axi_arvalid <= '0';

--     wait until axi4MemoryReadIn.s_axi_rvalid = '1' and rising_edge (clk);
--     axi4MemoryReadOut.s_axi_rready  <= '0';

--     -- #3  Read Minimum wait between reads
--     wait until rising_edge (clk);
--     wait until axi4MemoryReadIn.s_axi_arready = '1' and rising_edge (clk);
--     axi4MemoryReadOut.s_axi_arvalid <= '1';
--     axi4MemoryReadOut.s_axi_araddr  <= X"00000084";
--     axi4MemoryReadOut.s_axi_arid    <= "01";
--     --  This wait is required for the Read to work.
--     wait until rising_edge (clk); 
--     axi4MemoryReadOut.s_axi_rready  <= '1';
--     wait until rising_edge (clk); 
--     wait until axi4MemoryReadIn.s_axi_arready = '1' 
--         and axi4MemoryReadOut.s_axi_rready = '1';
--         -- and rising_edge (clk);
--     -- Data available    

--     axi4MemoryReadOut.s_axi_arvalid <= '0';
--     axi4MemoryReadOut.s_axi_rready  <= '0';
--     wait until rising_edge (clk);
--     wait until rising_edge (clk);

--     -- #4  Read Minimum wait between reads
--     wait until rising_edge (clk);
--     wait until axi4MemoryReadIn.s_axi_arready = '1' and rising_edge (clk);
--     axi4MemoryReadOut.s_axi_arvalid <= '1';
--     axi4MemoryReadOut.s_axi_araddr  <= X"00000088";
--     axi4MemoryReadOut.s_axi_arid    <= "01";
--     --  This wait is required for the Read to work.
--     wait until rising_edge (clk); 
--     -- axi4MemoryReadOut.s_axi_rready  <= '1';
--     -- wait until rising_edge (clk); 
--     -- wait until axi4MemoryReadIn.s_axi_arready = '1' 
--         -- and axi4MemoryReadOut.s_axi_rready = '1';
--         -- and rising_edge (clk);
--     -- Data available    

--     axi4MemoryReadOut.s_axi_arvalid <= '0';
--     axi4MemoryReadOut.s_axi_rready  <= '0';
--     wait until rising_edge (clk);
--     wait until rising_edge (clk);


--     report "Simulation Finished" severity note;

--     finish;
-- end process;

reset_process : process
begin
    s_aresetn <= '0';
    wait for PERIOD * 16;
    wait until rising_edge (clk);
    wait until rising_edge (clk);
    s_aresetn <= '1';
    wait;
end process;


test_memory1 : process (clk)
    variable tmpRO : AXI4_MEMORY_READ_OUT_TYPE_REC := AXI4_MEMORY_READ_OUT_DEFAULTS;
    variable tmpWO : AXI4_MEMORY_WRITE_OUT_TYPE_REC := AXI4_MEMORY_WRITE_OUT_DEFAULTS;
    variable readResults : std_logic_vector(31 downto 0) := (others => '0');
begin
    if rising_edge(clk) then
        if s_aresetn = '1' and rsta_busy = '0' and rstb_busy = '0' then
            axi4MemoryWriteOut <= ClearWriteFlags(axi4MemoryWriteOut, axi4MemoryWriteIn);

            -- Test 1 Set Write Address
            if test_number = 1 and axi4MemoryWriteIn.s_axi_awready = '1' then
                tmpWO := SetWrite(X"000", "01", X"DEADBEEF");
                axi4MemoryWriteOut <= tmpWO;
                -- axi4MemoryWriteOut <= SetWrite(X"000", "01", X"DEADBEEF");
                -- axi4MemoryWriteOut <= SetWrite(X"000", "01", X"00000020");
                test_number <= 2;
            elsif test_number = 2 then
                test_number <= 3;
            -- Test 3 Set Read Address
            elsif test_number = 3 and axi4MemoryReadIn.s_axi_arready = '1' then
                tmpRO := SetReadAddress(X"000", "10");
                axi4MemoryReadOut <= tmpRO;
                test_number <= 4;
            -- Test 4 Read Data with Valis
            elsif test_number = 4 then
            -- elsif test_number = 4 and IsReadDataValid(axi4MemoryReadOut, axi4MemoryReadIn, "10") then
                axi4MemoryReadOut <= ClearReadAddressData(axi4MemoryReadOut, axi4MemoryReadIn);
                dataValue <= GetReadData(axi4MemoryReadIn, "10");
                test_number <= 5;
            elsif test_number = 5 then
                dataValue <= GetReadData(axi4MemoryReadIn, "10");
                axi4MemoryReadOut <= ClearReadAddressData(axi4MemoryReadOut, axi4MemoryReadIn);
                report "Read Data 1 = " & to_hstring(to_bitvector(dataValue)) severity note;
                test_number <= 6;
            elsif test_number = 6 then
                report "Read Data 1 = " & to_hstring(to_bitvector(dataValue)) severity note;
                test_number <= 7;
            end if;
        else
            test_number <= 1;
        end if;
    end if;

end process;

end Behavioral;
