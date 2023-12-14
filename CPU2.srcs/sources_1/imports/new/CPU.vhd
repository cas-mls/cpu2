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

--    component Decode
--        Port ( 
----            clk : IN STD_LOGIC;
--            inst : IN STD_LOGIC_VECTOR(31 downto 0);
--            opcode : out OPCODETYPE;
--            highlow : out STD_LOGIC;
--            memop :  out MEMTYPE;
--            regop1 : out REGTYPE;
--            regop2 : out REGTYPE;
--            immop : out IMMTYPE
--        ); 
--    end component;            
        
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

    component Registers 
    Port (  clk : in STD_LOGIC;
            ena : in STD_LOGIC;
            regnum : in STD_LOGIC_VECTOR(3 downto 0);
            we : in std_logic ;
            regin : in STD_LOGIC_VECTOR (31 downto 0);
            regout : out STD_LOGIC_VECTOR (31 downto 0));
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
    signal regop2 : REGTYPE;
    signal immop : IMMTYPE;
    
    signal we : STD_LOGIC :='0';
    signal regin : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal regout : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    
    signal datatmp : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal regnum : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    signal regena : STD_LOGIC;


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

--    decode2 : Decode
--    port map (
--            inst => instruction, 
--            highlow => highlow,
--            opcode  => opcode,
--            memop  =>  memop,
--            regop1  => regop1,
--            regop2  => regop2,
--            immop  => immop
--        );
    
    reg1 : registers
    port map
    (
        clk => clk,
        ena => regena,
        regnum => regnum,
        we => we,
        regin => regin,
        regout => regout    
        );

    opcode <= instruction(31 downto 27);
    -- Spare bit 26
    highlow <= instruction(26);
    memop <= instruction(25 downto 24); 
    regop1 <= instruction(23 downto 20);
    regop2 <= instruction(19 downto 16);
    immop <= instruction(15 downto 0);


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
            regnum <= "0000";
            regin <= X"00000000";
            datatmp <= X"00000000";
            instruction <= X"00000000";
            we <= '0';
            cycle <= prefetch;
            led <= "1111";
            rgb <= "000000";
            regena <= '0';
            ena <= '1';
            wea <= "0";
        else
            case cycle is
                when prefetch =>
                    regena <= '0';
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
                        regena <= '1';
                        we <= '0';
                        regnum <= regop2;
                        cycle <= memrwait;
                    elsif memop = ABSOLUTE then
                        ena <= '1';
                        wea <= "0";
                        addra <= immop(11 downto 0);
                        cycle <= memrwait;
                    else
                        cycle <= memr;
                    end if;
                when memrwait =>
                    if memop = REGREG then
                        datatmp <= regout;
                    elsif memop = ABSOLUTE then
                        datatmp <= dina;
                    end if;
                    cycle <= memr;
                when memr =>
                    if memop = REGREG then
                        datatmp <= regout;
                        led <= datatmp(3 downto 0);
                    elsif memop = ABSOLUTE then
                        datatmp <= dina;
                    end if;
                    cycle <= execute;
                when execute =>
                    if opcode = LOAD then
                        if  memop = REGREG or 
                            memop = ABSOLUTE then
                            we <= '1';
                            regnum <= regop1;
                            regin <= datatmp;
                        elsif memop = IMMEDIATE then
                            regena <= '1';
                            we <= '1';
                            regnum <= regop1;
                            if highlow = '1' then
                                regin(31 downto 16) <= immop;
                            else
                                regin(15 downto 0) <= immop;
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
