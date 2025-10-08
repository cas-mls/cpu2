----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/04/2023 12:23:45 PM
-- Design Name: 
-- Module Name: AxiMemory - Package
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
library xil_defaultlib;

use ieee.numeric_std.all;

use IEEE.STD_LOGIC_1164.ALL;


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;

package AxiMemory is


    -- Memory Records
    constant MEM_ID_NONE : STD_LOGIC_VECTOR(1 downto 0) := "00";
    constant MEM_ID_PC : STD_LOGIC_VECTOR(1 downto 0) := "01";
    constant MEM_ID_ARG : STD_LOGIC_VECTOR(1 downto 0) := "10";
    constant MEM_ID_STACK : STD_LOGIC_VECTOR(1 downto 0) := "11";

    type AXI4_MEMORY_WRITE_OUT_TYPE_REC is record
        s_axi_awid      : STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_awaddr    : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
        s_axi_awvalid   : STD_LOGIC;
        s_axi_wdata     : STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axi_wstrb     : STD_LOGIC_VECTOR(3 DOWNTO 0);
        s_axi_wvalid    : STD_LOGIC;
        s_axi_bready    : STD_LOGIC;
    end record;

    constant AXI4_MEMORY_WRITE_OUT_DEFAULTS : AXI4_MEMORY_WRITE_OUT_TYPE_REC := (
        s_axi_awid => (others => '0'),
        s_axi_awaddr => (others => '0'),
        s_axi_awvalid => '0',
        s_axi_wdata => (others => '0'),
        s_axi_wstrb => (others => '1'),
        s_axi_wvalid => '0',
        s_axi_bready => '0'
    );
    
    type AXI4_MEMORY_READ_OUT_TYPE_REC is record
        s_axi_arid      : STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_araddr    : STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axi_arvalid   : STD_LOGIC;
        s_axi_rready    : STD_LOGIC;
    end record;

    constant AXI4_MEMORY_READ_OUT_DEFAULTS : AXI4_MEMORY_READ_OUT_TYPE_REC := (
        s_axi_arid => (others => '0'),
        s_axi_araddr => (others => '0'),
        s_axi_arvalid => '0',
        s_axi_rready => '0'
    );

    type AXI4_MEMORY_WRITE_IN_TYPE_REC is record
        s_axi_awready   : STD_LOGIC;
        s_axi_wready    : STD_LOGIC;
        s_axi_bid       : STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_bresp     : STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_bvalid    : STD_LOGIC;
    end record;

    constant AXI4_MEMORY_WRITE_IN_DEFAULTS : AXI4_MEMORY_WRITE_IN_TYPE_REC := (
        s_axi_awready => '0',
        s_axi_wready => '0',
        s_axi_bid => (others => '0'),
        s_axi_bresp => (others => '0'),
        s_axi_bvalid => '0'
    );

    type AXI4_MEMORY_READ_IN_TYPE_REC is record
        s_axi_arready   : STD_LOGIC;
        s_axi_rid       : STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_rdata     : STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axi_rresp     : STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_rvalid    : STD_LOGIC;
    end record;

    constant AXI4_MEMORY_READ_IN_DEFAULTS : AXI4_MEMORY_READ_IN_TYPE_REC := (
        s_axi_arready => '0',
        s_axi_rid => (others => '0'),
        s_axi_rdata => (others => '0'),
        s_axi_rresp => (others => '0'),
        s_axi_rvalid => '0'
    );

    Function SetReadAddress (
            readOut : AXI4_MEMORY_READ_OUT_TYPE_REC;
            addr : std_logic_vector(11 downto 0); 
            id : std_logic_vector(1 downto 0)) 
        return AXI4_MEMORY_READ_OUT_TYPE_REC;

    Function AddressIsSet (
            readOut : AXI4_MEMORY_READ_OUT_TYPE_REC; 
            readIn : AXI4_MEMORY_READ_IN_TYPE_REC ) 
        return boolean;

    Function ClearReadAddress (
        readOut : AXI4_MEMORY_READ_OUT_TYPE_REC; 
        readIn : AXI4_MEMORY_READ_IN_TYPE_REC ) 
    return AXI4_MEMORY_READ_OUT_TYPE_REC;

    Function ClearReadData (
        readOut : AXI4_MEMORY_READ_OUT_TYPE_REC; 
        readIn : AXI4_MEMORY_READ_IN_TYPE_REC ) 
    return AXI4_MEMORY_READ_OUT_TYPE_REC;

    Function GetReadData (
        readIn : AXI4_MEMORY_READ_IN_TYPE_REC; 
            id : std_logic_vector(1 downto 0))
    return std_logic_vector;

    Function IsReadDataValid (
        readIn : AXI4_MEMORY_READ_IN_TYPE_REC;
        readOut : AXI4_MEMORY_READ_OUT_TYPE_REC;
        id : std_logic_vector(1 downto 0) )
    return boolean;

    function OkTowrite(
        writeIn : AXI4_MEMORY_WRITE_IN_TYPE_REC;
        writeOut : AXI4_MEMORY_WRITE_OUT_TYPE_REC )
     return boolean;

    Function SetWrite (
            addr : std_logic_vector(11 downto 0); 
            id : std_logic_vector(1 downto 0); 
            data : std_logic_vector(31 downto 0)) 
        return AXI4_MEMORY_WRITE_OUT_TYPE_REC;

        
    Function ClearWriteFlags (
        writeOut : AXI4_MEMORY_WRITE_OUT_TYPE_REC; 
        writeIn : AXI4_MEMORY_WRITE_IN_TYPE_REC ) 
    return AXI4_MEMORY_WRITE_OUT_TYPE_REC;

end Package AxiMemory;

