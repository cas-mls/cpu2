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
            readOut : AXI4_MEMORY_READ_OUT_TYPE_REC;
            addr : std_logic_vector(11 downto 0); 
            id : std_logic_vector(1 downto 0)) 
        return AXI4_MEMORY_READ_OUT_TYPE_REC 
    is
        variable ret : AXI4_MEMORY_READ_OUT_TYPE_REC := readOut;
    begin
        ret.s_axi_araddr := (31 downto addr'length+2 => '0') & addr & "00";
        ret.s_axi_arvalid := '1';
        ret.s_axi_arid := id;
        ret.s_axi_rready := '1';
        return ret;
    end function SetReadAddress;

        Function ClearReadAddress (
            readOut : AXI4_MEMORY_READ_OUT_TYPE_REC; 
            readIn : AXI4_MEMORY_READ_IN_TYPE_REC ) 
        return AXI4_MEMORY_READ_OUT_TYPE_REC 
    is
        variable ret : AXI4_MEMORY_READ_OUT_TYPE_REC := readOut;
    begin
            -- ret.prior_rvalid := readIn.s_axi_rvalid;
            if readIn.s_axi_arready = '1' and
                readOut.s_axi_arvalid = '1' then
                ret.s_axi_arvalid := '0';
                ret.s_axi_arid := (others => '0');
                ret.s_axi_araddr := (others => '0');
            end if;

        return ret;
        
    end function ClearReadAddress;

    Function ClearReadData (
        readOut : AXI4_MEMORY_READ_OUT_TYPE_REC; 
        readIn : AXI4_MEMORY_READ_IN_TYPE_REC ) 
        return AXI4_MEMORY_READ_OUT_TYPE_REC 
    is
        variable ret : AXI4_MEMORY_READ_OUT_TYPE_REC := readOut;
    begin
            -- ret.prior_rvalid := readIn.s_axi_rvalid;
            if readIn.s_axi_arready = '1' and
                readOut.s_axi_arvalid = '1' then
                ret.s_axi_rready := '0';
            end if;

        return ret;
        
    end function ClearReadData;

    function GetReadData (
            readIn : AXI4_MEMORY_READ_IN_TYPE_REC; 
            id : std_logic_vector(1 downto 0)) 
        return std_logic_vector
    is
        variable ret : std_logic_vector(31 downto 0) := (others => '0');
    begin
        if readIn.s_axi_rvalid = '1' and
            readIn.s_axi_rid = id then
            ret := readIn.s_axi_rdata;
        end if;
        return ret;
    end function GetReadData;

    function IsReadDataValid(
        readIn : AXI4_MEMORY_READ_IN_TYPE_REC;
        readOut : AXI4_MEMORY_READ_OUT_TYPE_REC;
        id : std_logic_vector(1 downto 0) )
    return boolean
    is
    begin
        if readOut.s_axi_rready = '1' and
            readIn.s_axi_rvalid = '1' and
            -- readOut.prior_rvalid = '0' and
            readIn.s_axi_rid = id then
            return true;
        else
            return false;
        end if;
    end function IsReadDataValid;

    function OkTowrite(
        writeIn : AXI4_MEMORY_WRITE_IN_TYPE_REC;
        writeOut : AXI4_MEMORY_WRITE_OUT_TYPE_REC )
     return boolean
    is
    begin
        if writeIn.s_axi_awready = '1' 
            and writeOut.s_axi_wvalid = '0' 
            and writeIn.s_axi_wready = '0'
        then
            return true;
        else 
            return false;
        end if;
    end function OkTowrite; 


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


    Function ClearWriteFlags (
            writeOut : AXI4_MEMORY_WRITE_OUT_TYPE_REC; 
            writeIn : AXI4_MEMORY_WRITE_IN_TYPE_REC ) 
        return AXI4_MEMORY_WRITE_OUT_TYPE_REC 
    is
        variable ret : AXI4_MEMORY_WRITE_OUT_TYPE_REC := writeOut;
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
                ret.s_axi_bready := '1';
            end if;

            if writeIn.s_axi_bvalid = '1' 
                and writeOut.s_axi_bready = '1' 
            then
                ret.s_axi_bready := '0';
            end if;
        return ret;
    end function ClearWriteFlags;

    
end Package Body Utilities;
