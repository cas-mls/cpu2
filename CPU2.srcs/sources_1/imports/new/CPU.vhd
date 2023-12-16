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

COMPONENT cpumemory
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    clkb : IN STD_LOGIC;
    enb : IN STD_LOGIC;
    web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addrb : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    dinb : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) 
  );
END COMPONENT;

    signal ProgCounter : unsigned(11 downto 0) := X"000";
    signal cycle : CYCLETYPE := PREFETCH;

    -- Memory Information
    signal ena : STD_LOGIC := '1';
    signal wea : STD_LOGIC_VECTOR(0 DOWNTO 0) := "0";
    signal addra : STD_LOGIC_VECTOR(11 DOWNTO 0) := X"000";
    signal dina : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
    signal douta : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
    signal enb : STD_LOGIC := '1';
    signal web : STD_LOGIC_VECTOR(0 DOWNTO 0) := "0";
    signal addrb : STD_LOGIC_VECTOR(11 DOWNTO 0) := X"000";
    signal dinb : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
    signal doutb : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";

    -- Decode information    
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

your_instance_name : cpumemory
  PORT MAP (
    clka => clk,
    ena => ena,
    wea => wea,
    addra => addra,
    dina => dina,
    douta => douta,
    clkb => clk,
    enb => enb,
    web => web,
    addrb => addrb,
    dinb => dinb,
    doutb => doutb
  );



    opcode <= douta(31 downto 27);
    highlow <= douta(26);
    memop <= douta(25 downto 24); 
    regop1 <= douta(23 downto 20);
    regop2 <= douta(19 downto 16);
    immop <= douta(15 downto 0);
    iregop1 <= to_integer(unsigned(regop1));
    iregop2 <= to_integer(unsigned(regop2));


    Reg_Proc: process (clk)
    begin
    
    if rising_edge  (clk) then
        if rst = '1' then
            ProgCounter <= X"000";
            cycle <= prefetch;
            led <= "1111";
            rgb <= "000000";
            ena <= '1';
            wea <= "0";
            addra <= X"000";
            enb <= '1';
            web <= "0";
            addrb <= X"000";
        else
            case cycle is
                when prefetch =>
                    ena <= '1';
                    wea <= "0";
                    addra <= STD_LOGIC_VECTOR(unsigned(ProgCounter));
                    cycle <= waits;
                when waits =>
                    cycle <= fetch;
                when datain =>
                    cycle <= fetch;    
                when fetch =>
                    rgb(4 downto 0) <= opcode(4 downto 0);
                    rgb(5) <= memop(0);
                    cycle <= decodes;
                when decodes =>
                    if opcode = LOAD then
                        if memop = REGREG then
                            cycle <= execute;
                        elsif memop = ABSOLUTE then
                            enb <= '1';
                            web <= "0";
                            addrb <= immop(11 downto 0);
                            cycle <= memrwait;
                        elsif memop = INDEX then
                            enb <= '1';
                            web <= "0";
                            addrb <=    std_logic_vector(to_unsigned(to_integer(unsigned(immop(11 downto 0))) + 
                                        to_integer(unsigned(regop2)),12));
                            cycle <= memrwait;
                        else -- immediate
                            cycle <= execute;
                        end if;
                    else
                        cycle <= memr;
                    end if;
                when memrwait =>
                    cycle <= memr;
                when memr =>
                    cycle <= execute;
                when execute =>
                    if opcode = LOAD then
                        if  memop = REGREG then
                            regist(iregop1) <= regist(iregop2);
                        elsif memop = IMMEDIATE then
                            if highlow = '1' then
                                regist(iregop1)(31 downto 16) <= immop;
                            else
                                regist(iregop1)(15 downto 0) <= immop;
                            end if;
                        elsif memop = ABSOLUTE then
                        end if;
                    end if;
                    cycle <= memw;
                when MEMW =>
                    if opcode = LOAD then
                        if memop = ABSOLUTE  or memop = INDEX then
                            regist(iregop1) <= doutb;
                        end if;
                    end if;
                    ProgCounter <= ProgCounter + 1;
                    cycle <= prefetch;
                when others =>
                    cycle <= prefetch;
            end case;                 
        end if;
     end if;
 

    end process;

end Behavioral;
