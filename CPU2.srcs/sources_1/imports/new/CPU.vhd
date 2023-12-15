----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/29/2023 05:57:00 PM
-- Design Name: 
-- Module Name: CPU - Behavioral
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
--use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_1164.ALL;

use xil_defaultlib.Utilities.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CPU is
  Port (
    rst : IN  STD_LOGIC;
    clk : IN STD_LOGIC;
    led : OUT STD_LOGIC_VECTOR (3 downto 0);
    rgb : OUT STD_LOGIC_VECTOR (5 downto 0)
    );

end CPU;

architecture Behavioral of CPU is

    component Memory
    Port ( 
        clk : IN STD_LOGIC;
        ena : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
    end component;

    signal ProgCounter : unsigned(11 downto 0) := X"000";
    signal cycle : CYCLETYPE := PREFETCH;

    -- Memory Information
    signal ena : STD_LOGIC := '1';
    signal wea : STD_LOGIC_VECTOR(0 DOWNTO 0) := "0";
    signal addra : STD_LOGIC_VECTOR(11 DOWNTO 0) := X"000";
    signal dina : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
    signal douta : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";

    -- Decode information    
    signal instruction : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
    signal opcode : OPCODETYPE := "00000";
    signal highlow : STD_LOGIC :='0';
    signal memop :  MEMTYPE;
    signal regop1 : REGTYPE;
    signal iregop1 : integer;
    signal regop2 : REGTYPE;
    signal iregop2 : integer;
    signal immop : IMMTYPE;
    
    -- Register information
    signal regist : reg_type := (others => (others => '0'));



begin

    memory2 : Memory
    port map (
        ena => ena,
        clk => clk,
        wea => wea,
        addra => addra,
        dina => dina,
        douta => douta
--        led => led
    );

    opcode <= instruction(31 downto 27);
    -- Spare bit 26
    highlow <= instruction(26);
    memop <= instruction(25 downto 24); 
    regop1 <= instruction(23 downto 20);
    regop2 <= instruction(19 downto 16);
    immop <= instruction(15 downto 0);
    iregop1 <= to_integer(unsigned(regop1));
    iregop2 <= to_integer(unsigned(regop2));


    Reg_Proc: process (clk)
    begin
    
--    if falling_edge (clk) then
--            case cycle is
--                when prefetch =>
--                    cycle <= waits;
--                when waits =>
--                    cycle <= fetch;
--                when fetch =>
--                     cycle <= decodes;
--                when decodes =>
--                    cycle <= execute;
--                when execute =>
--                    cycle <= prefetch;
--                when others =>
--                    cycle <= prefetch;
--            end case;
--    end if;
 
    if rising_edge  (clk) then
        if rst = '1' then
            ProgCounter <= X"000";
            addra <= X"000";
            instruction <= X"00000000";
            cycle <= prefetch;
            led <= "1111";
            rgb <= "000000";
            ena <= '1';
            wea <= "0";
        else
            case cycle is
                when prefetch =>
                    ena <= '1';
                    wea <= "0";
                    addra <= STD_LOGIC_VECTOR(unsigned(ProgCounter));
                    cycle <= waits;
                when waits =>
                    cycle <= fetch;
                when fetch =>
                    instruction <= douta;
                    rgb(4 downto 0) <= opcode(4 downto 0);
                    rgb(5) <= memop(0);
                    cycle <= decodes;
                when decodes =>
                    if memop = REGREG then
                        cycle <= execute;
                    elsif memop = ABSOLUTE then
                        ena <= '1';
                        wea <= "0";
                        addra <= immop(11 downto 0);
                        cycle <= memrwait;
                    else
                        cycle <= memr;
                    end if;
                when memrwait =>
                    cycle <= memr;
                when memr =>
                    if memop = ABSOLUTE then
                    end if;
                    cycle <= execute;
                when execute =>
                    if opcode = LOAD then
                        if  memop = REGREG then
                            regist(iregop1) <= regist(iregop2);
                        elsif memop = ABSOLUTE then
                            regist(iregop1) <= douta;
                        elsif memop = IMMEDIATE then
                            if highlow = '1' then
                                regist(iregop1)(31 downto 16) <= immop;
                            else
                                regist(iregop1)(15 downto 0) <= immop;
                            end if;
                        elsif memop = ABSOLUTE then
                        end if;
                    end if;
                    ProgCounter <= ProgCounter + 1;
                    cycle <= memw;
                when MEMW =>
                    cycle <= prefetch;
                when others =>
                    cycle <= prefetch;
            end case;                 
        end if;
     end if;
 

    end process;

end Behavioral;
