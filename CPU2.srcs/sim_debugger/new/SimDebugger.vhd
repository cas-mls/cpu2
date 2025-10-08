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
use xil_defaultlib.AxiMemory.all;
use xil_defaultlib.DebugPkg.all;

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
            -- AXI Memory Interface
            AXI4_MEMORY_READ_OUT : out AXI4_MEMORY_READ_OUT_TYPE_REC;
            AXI4_MEMORY_READ_IN : in AXI4_MEMORY_READ_IN_TYPE_REC;
            AXI4_MEMORY_WRITE_OUT : out AXI4_MEMORY_WRITE_OUT_TYPE_REC;
            AXI4_MEMORY_WRITE_IN : in AXI4_MEMORY_WRITE_IN_TYPE_REC;
            -- DEBUG Interface
            DEBUGIN     : in DEBUGINTYPE := DEBUGIN_DEFAULTS;
            DEBUGOUT    : out DEBUGOUTTYPE
            );
    end component;

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

    signal clk         : STD_LOGIC;
    signal ioAddr      : STD_LOGIC_VECTOR (7 downto 0)  := (others => '0');
    signal IORdata     : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal IOWdata     : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal IORena      : STD_LOGIC                      := '0';
    signal IOWena      : STD_LOGIC                      := '0';
    signal IOStatus    : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal IOStatusReq : STD_LOGIC                      := '0';
    signal interrupt   : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

    -- AXI Memory Interface
    signal axi4MemoryWriteOut : AXI4_MEMORY_WRITE_OUT_TYPE_REC := AXI4_MEMORY_WRITE_OUT_DEFAULTS;
    signal axi4MemoryWriteIn : AXI4_MEMORY_WRITE_IN_TYPE_REC;
    signal axi4MemoryReadOut  : AXI4_MEMORY_READ_OUT_TYPE_REC;
    signal axi4MemoryReadIn  : AXI4_MEMORY_READ_IN_TYPE_REC;

    signal axi4MemoryWriteOutInit : AXI4_MEMORY_WRITE_OUT_TYPE_REC := AXI4_MEMORY_WRITE_OUT_DEFAULTS;
    signal axi4MemoryWriteOutRun : AXI4_MEMORY_WRITE_OUT_TYPE_REC := AXI4_MEMORY_WRITE_OUT_DEFAULTS;
    signal Init : BOOLEAN := TRUE;

    signal rsta_busy       : STD_LOGIC;
    signal rstb_busy       : STD_LOGIC;
    signal s_aclk          : STD_LOGIC;
    signal s_aresetn       : STD_LOGIC := '0';


    -- Debug Items
    -- Debug Items
    signal DebugIn      : DEBUGINTYPE := DEBUGIN_DEFAULTS;
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
    AXI4_MEMORY_READ_OUT => axi4MemoryReadOut,
    AXI4_MEMORY_READ_IN  => axi4MemoryReadIn,
    AXI4_MEMORY_WRITE_OUT => axi4MemoryWriteOutRun,
    AXI4_MEMORY_WRITE_IN  => axi4MemoryWriteIn,
    DEBUGIN       => DebugIn,
    DEBUGOUT      => DebugOut
);

  cpuMemoryAxi : cpuAxiMemory
  PORT MAP (
    rsta_busy       => rsta_busy,
    rstb_busy       => rstb_busy,
    s_aclk          => s_aclk,
    s_aresetn       => s_aresetn,
    s_axi_awid      => axi4MemoryWriteOut.s_axi_awid,
    s_axi_awaddr    => axi4MemoryWriteOut.s_axi_awaddr,
    s_axi_awvalid   => axi4MemoryWriteOut.s_axi_awvalid,
    s_axi_awready   => axi4MemoryWriteIn.s_axi_awready,
    s_axi_wdata     => axi4MemoryWriteOut.s_axi_wdata,
    s_axi_wstrb     => axi4MemoryWriteOut.s_axi_wstrb,
    s_axi_wvalid    => axi4MemoryWriteOut.s_axi_wvalid,
    s_axi_wready    => axi4MemoryWriteIn.s_axi_wready,
    s_axi_bid       => axi4MemoryWriteIn.s_axi_bid,
    s_axi_bresp     => axi4MemoryWriteIn.s_axi_bresp,
    s_axi_bvalid    => axi4MemoryWriteIn.s_axi_bvalid,
    s_axi_bready    => axi4MemoryWriteOut.s_axi_bready,
    s_axi_arid      => axi4MemoryReadOut.s_axi_arid,
    s_axi_araddr    => axi4MemoryReadOut.s_axi_araddr,
    s_axi_arvalid   => axi4MemoryReadOut.s_axi_arvalid,
    s_axi_arready   => axi4MemoryReadIn.s_axi_arready,
    s_axi_rid       => axi4MemoryReadIn.s_axi_rid,
    s_axi_rdata     => axi4MemoryReadIn.s_axi_rdata,
    s_axi_rresp     => axi4MemoryReadIn.s_axi_rresp,
    s_axi_rvalid    => axi4MemoryReadIn.s_axi_rvalid,
    s_axi_rready    => axi4MemoryReadOut.s_axi_rready
  );

axi4MemoryWriteOut <= axi4MemoryWriteOutRun 
    when not Init 
    else axi4MemoryWriteOutInit;

s_aclk <= clk;

clk <= '0' after HALF_PERIOD when clk = '1' else
       '1' after HALF_PERIOD;

test : process
begin

    interrupt(0) <= '1';
    s_aresetn <= '0';
    for j in 1 to 10 loop
        wait until rising_edge (clk);
    end loop;
    s_aresetn <= '1';

    wait until rsta_busy = '0' and rstb_busy = '0' and rising_edge (clk);
    
    wait until rising_edge (clk);
    wait until rising_edge (clk);
    Init <= TRUE;
    -- #1 Write
    axi4MemoryWriteOutInit.s_axi_awvalid <= '1';
    axi4MemoryWriteOutInit.s_axi_awaddr <= X"00000000";
    axi4MemoryWriteOutInit.s_axi_awid   <= "01";
    axi4MemoryWriteOutInit.s_axi_wvalid  <= '1';
    axi4MemoryWriteOutInit.s_axi_wdata   <= X"00000020";
    axi4MemoryWriteOutInit.s_axi_wstrb   <= "1111";
    axi4MemoryWriteOutInit.s_axi_bready  <= '1';
    wait until rising_edge (clk);
    
    wait until axi4MemoryWriteIn.s_axi_awready = '1'
        and axi4MemoryWriteOutInit.s_axi_awvalid = '1' 
        and rising_edge (clk);
    axi4MemoryWriteOutInit.s_axi_awvalid <= '0';
    axi4MemoryWriteOutInit.s_axi_awaddr <= (others => '0');
    Init <= FALSE;
    interrupt(0) <= '0';

    wait;

end process;

debug : process
begin
    wait until Init = FALSE;

    wait for 0.5us;
    DebugIn.DebugMode <= '1';

    -- Test for Breakpoints
    DebugIn.BreakPoints(0) <= x"120";
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