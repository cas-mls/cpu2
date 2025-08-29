----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/04/2023 12:23:45 PM
-- Design Name: 
-- Module Name: Utilities - Package
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

package body Utilities is

    Function SetReadAddress (
            addr : std_logic_vector(11 downto 0); 
            id : std_logic_vector(1 downto 0)) 
        return AXI4_MEMORY_READ_OUT_TYPE_REC 
    is
        variable ret : AXI4_MEMORY_READ_OUT_TYPE_REC := AXI4_MEMORY_READ_OUT_DEFAULTS;
    begin
        ret.s_axi_araddr := (31 downto addr'length+2 => '0') & addr & "00";
        ret.s_axi_arvalid := '1';
        ret.s_axi_arid := id;
        ret.s_axi_rready := '1';
        return ret;
    end function SetReadAddress;


    Function SetWrite (
            addr : std_logic_vector(11 downto 0); 
            id : std_logic_vector(1 downto 0); 
            data : std_logic_vector(31 downto 0)) 
        return AXI4_MEMORY_WRITE_OUT_TYPE_REC
    is
        variable ret : AXI4_MEMORY_WRITE_OUT_TYPE_REC := AXI4_MEMORY_WRITE_OUT_DEFAULTS;
    begin
        ret.s_axi_awaddr := (31 downto addr'length+2 => '0') & addr & "00";
        ret.s_axi_awvalid := '1';
        ret.s_axi_awid := id;
        ret.s_axi_wdata := data;
        ret.s_axi_wstrb := (others => '1');
        ret.s_axi_wvalid := '1';
        ret.s_axi_bready := '1';
        return ret;
    end function SetWrite;

        Function ClearReadAddressData (
            readOut : AXI4_MEMORY_READ_OUT_TYPE_REC; 
            readIn : AXI4_MEMORY_READ_IN_TYPE_REC ) 
        return AXI4_MEMORY_READ_OUT_TYPE_REC 
    is
        variable ret : AXI4_MEMORY_READ_OUT_TYPE_REC := AXI4_MEMORY_READ_OUT_DEFAULTS;
    begin
            if readIn.s_axi_arready = '1' and
                readOut.s_axi_arvalid = '1' then
                ret.s_axi_arvalid := '0';
                ret.s_axi_araddr := (others => '0');
            end if;

            if readIn.s_axi_rvalid = '1' and
                readOut.s_axi_rready = '1' then
                ret.s_axi_rready := '0';
                -- TODO: Could Save off read data in a Flip-Flop here if needed.
                -- Could use the Memory Id as a index in a Latch List.
            end if;
        return ret;
    end function ClearReadAddressData;

    Function ClearWriteFlags (
            writeOut : AXI4_MEMORY_WRITE_OUT_TYPE_REC; 
            writeIn : AXI4_MEMORY_WRITE_IN_TYPE_REC ) 
        return AXI4_MEMORY_WRITE_OUT_TYPE_REC 
    is
        variable ret : AXI4_MEMORY_WRITE_OUT_TYPE_REC := AXI4_MEMORY_WRITE_OUT_DEFAULTS;
    begin

            if writeIn.s_axi_awready = '1' and
                writeOut.s_axi_awvalid = '1' then
                ret.s_axi_awvalid := '0';
                ret.s_axi_awaddr := (others => '0');
            end if;

            if writeIn.s_axi_wready = '1' and
                writeOut.s_axi_wvalid = '1' then
                ret.s_axi_wvalid := '0';
                ret.s_axi_wdata := (others => '0');
            end if;

            if writeIn.s_axi_bvalid = '1' and
                writeOut.s_axi_bready = '1' then
                ret.s_axi_bready := '0';
            end if;
        return ret;
    end function ClearWriteFlags;

    
end Package Body Utilities;
