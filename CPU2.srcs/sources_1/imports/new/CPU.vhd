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
--use ieee.std_logic_arith.all;

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
    
    
    ioAddr  : out STD_LOGIC_VECTOR (7 downto 0);
    IORdata    : in STD_LOGIC_VECTOR (31 downto 0);
    IOWdata   : out STD_LOGIC_VECTOR (31 downto 0);
    IORena: out STD_LOGIC;
    IOWena: out std_logic;
    IOStatus: in STD_LOGIC_VECTOR (7 downto 0);
    interrupt : in STD_LOGIC_VECTOR (4 downto 0)

--    led : OUT STD_LOGIC_VECTOR (3 downto 0);
--    rgb : OUT STD_LOGIC_VECTOR (5 downto 0)
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
    signal flag : STD_LOGIC :='0';
    signal memop :  MEMTYPE;
    signal regop1 : REGTYPE;
    signal iregop1 : integer;
    signal ireg1value : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
    signal regop2 : REGTYPE;
    signal iregop2 : integer;
    signal ireg2value : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
    signal immop : IMMTYPE;
    
    -- Register information
    signal regist : reg_type := (others => (others => '0'));

begin

memory : cpumemory
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
    flag <= douta(26);
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
            ena <= '1';
            wea <= "0";
            addra <= X"000";
            enb <= '1';
            web <= "0";
            addrb <= X"000";
            dinb <= X"00000000";
            regist <= (others => (others =>'0'));
            ireg1value <= (others => '0');
            ireg2value <= (others => '0');
            IOWdata <= (others => '0');
            ioAddr <= (others => '0');
            IORena <= '0';
            IOWena <= '0';
        else
            case cycle is

                ----------------------------------------------------------------
                -- This sets up the instruction address to read.
                when prefetch =>
                    ena <= '1';
                    wea <= "0";
                    addra <= STD_LOGIC_VECTOR(unsigned(ProgCounter));
                    cycle <= waits;

                ----------------------------------------------------------------
                -- This is the Cycle to wait for the Fetch Instruction Memory
                when waits =>
                    cycle <= fetch;

                ----------------------------------------------------------------
                -- This Cycle is not used.
                when datain =>
                    cycle <= fetch;    

                ----------------------------------------------------------------
                -- This is the second Cycle for the Fetch Instruction Memory
                when fetch =>
--                    IOAddr <= X"01";
--                    IOWena <= '1';
--                    IOWdata(4 downto 0) <=  opcode(4 downto 0);
--                    rgb(4 downto 0) <= opcode(4 downto 0);
--                    rgb(5) <= memop(0);
                    cycle <= decodes;

                -- Decoding is complete
                -- Set up memory address for ABSOLUTE and INDEX
                when decodes =>
                    ireg1value <= regist(iregop1);
                    ireg2value <= regist(iregop2);

                    case memop is
                        when REGREG =>
                            case opcode is
                                when oJSR =>
                                    enb <= '1';
                                    web <= "1";
                                    addrb <= regist(iregop1)(11 downto 0);
                                    dinb <= X"00000" & STD_LOGIC_VECTOR(unsigned(ProgCounter + 1));
                                    cycle <= execute;
                                when oRTN =>
                                    enb <= '1';
                                    web <= "0";
                                    addrb <= std_logic_vector(to_unsigned(
                                            to_integer(unsigned(regist(iregop1))) + 1,12));
                                    regist(iregop1) <= std_logic_vector(to_unsigned(
                                            to_integer(unsigned(regist(iregop1))) + 1,32));
                                    cycle <= memrwait;
                                when oRIO =>
                                    IOAddr <= regist(iregop2)(7 downto 0);
                                    IORena <= '1';
                                    cycle <= memr;
                                when oWIO =>
                                    IOAddr <= regist(iregop2)(7 downto 0);
                                    IOWena <= '1';
                                    cycle <= memr;
                                when oPUSH =>
                                    enb <= '1';
                                    web <= "1";
                                    addrb <= regist(iregop1)(11 downto 0);
                                    dinb <= regist(iregop2);
                                    cycle <= execute;
                                when oPOP =>
                                    enb <= '1';
                                    web <= "0";
                                    addrb <= std_logic_vector(to_unsigned(
                                            to_integer(unsigned(regist(iregop1))) + 1,12));
                                    regist(iregop1) <= std_logic_vector(to_unsigned(
                                            to_integer(unsigned(regist(iregop1))) + 1,32));
                                    cycle <= memrwait;
                                when others =>
                                    cycle <= execute;
                            end case;
                        when IMMEDIATE =>
                            case opcode is
                                when oJSR =>
                                    enb <= '1';
                                    web <= "1";
                                    addrb <= regist(iregop1)(11 downto 0);
                                    dinb <= X"00000" & STD_LOGIC_VECTOR(unsigned(ProgCounter + 1));
                                    cycle <= execute;
                                when oRIO =>
                                    IOAddr <= immop(7 downto 0);
                                    IORena <= '1';
                                    cycle <= memr;
                                when oWIO =>
                                    IOAddr <= immop(7 downto 0);
                                    IOWena <= '1';
                                    cycle <= memr;
                                when oPUSH =>
                                    enb <= '1';
                                    web <= "1";
                                    addrb <= regist(iregop1)(11 downto 0);
                                    dinb <= X"0000" & immop;
                                    cycle <= execute;
                                when others =>
                                    cycle <= execute;
                            end case;
                        when ABSOLUTE =>
                            case opcode is
                                when oLD | oADD | oSUB | oAND | oOr | oXor | oShl | oShr | oJMP | oBE | oBLT | oBGT =>
                                    enb <= '1';
                                    web <= "0";
                                    addrb <= immop(11 downto 0);
                                    cycle <= memrwait;
                                when oSTR =>
                                    enb <= '1';
                                    web <= "1";
                                    addrb <= immop(11 downto 0);
                                    cycle <= memrwait;
                                when oRIO =>
                                    IOAddr <= regist(iregop2)(7 downto 0);
                                    enb <= '1';
                                    web <= "1";
                                    addrb <= immop(11 downto 0);
                                    IORena <= '1';
                                    cycle <= memrwait;
                                when oWIO =>
                                    IOAddr <= regist(iregop2)(7 downto 0);
                                    enb <= '1';
                                    web <= "0";
                                    addrb <= immop(11 downto 0);
                                    IOWena <= '1';
                                    cycle <= memrwait;
                                when others =>
                                    cycle <= execute;
                            end case;
                        when INDEX =>
                            case opcode is
                                when oLD | oADD | oSUB | oAND | oOr | oXor | oShl | oShr | oJMP =>
                                    enb <= '1';
                                    web <= "0";
                                    addrb <=    std_logic_vector(to_unsigned(to_integer(unsigned(immop(11 downto 0))) + 
                                                to_integer(unsigned(regist(iregop2))),12));
                                    cycle <= memrwait;
                                when oSTR  =>
                                    enb <= '1';
                                    web <= "1";
                                    addrb <=    std_logic_vector(to_unsigned(to_integer(unsigned(immop(11 downto 0))) + 
                                                to_integer(unsigned(regist(iregop2))),12));
                                    cycle <= memrwait;
                                when others =>
                                    cycle <= execute;
                            end case;
                        when others =>
                            cycle <= execute;
                    end case;
    

                ----------------------------------------------------------------
                -- Cycle to wait for memory to be read.
                -- ABSOLUTE and INDEX operations.
                when memrwait =>
                    cycle <= memr;

                ----------------------------------------------------------------
                -- Second Cycle to wait for memory to be read.
                -- ABSOLUTE and INDEX operations.
                when memr =>
                    cycle <= execute;
                    
                ----------------------------------------------------------------
                -- Execute intruction
                when execute =>
                    case memop is
                        when REGREG =>
                            case opcode is
                                when oLD =>
                                    regist(iregop1) <= ireg2value;
                                when oADD =>
                                    regist(iregop1) <= 
                                        std_logic_vector(to_unsigned(
                                            to_integer(unsigned(ireg1value)) + 
                                            to_integer(unsigned(ireg2value)),32));
                                when oSUB =>
                                    regist(iregop1) <= 
                                        std_logic_vector(to_unsigned(
                                            to_integer(unsigned(ireg1value)) - 
                                            to_integer(unsigned(ireg2value)),32));
                                when oAND =>
                                    if flag = '0' then
                                        regist(iregop1) <= ireg1value and ireg2value;
                                    else
                                        regist(iregop1) <= (ireg1value nand ireg2value);
                                    end if;
                                when oOR =>
                                    if flag = '0' then
                                        regist(iregop1) <= ireg1value or ireg2value;
                                    else
                                        regist(iregop1) <= (ireg1value nor ireg2value);
                                    end if;
                                when oXOR =>
                                    if flag = '0' then
                                        regist(iregop1) <= ireg1value xor ireg2value;
                                    else
                                        regist(iregop1) <= (ireg1value xnor ireg2value);
                                    end if;
                                when oSHL =>
                                    regist(iregop1) <= std_logic_vector(unsigned(ireg1value) 
                                        sll to_integer(unsigned(ireg2value(4 downto 0))));
                                when oSHR =>
                                    regist(iregop1) <= std_logic_vector(unsigned(ireg1value) 
                                        srl to_integer(unsigned(ireg2value(4 downto 0))));
                                when oJMP =>
                                    ProgCounter <= unsigned(ireg2value(11 downto 0));
                                when oJSR =>
                                    regist(iregop1) <= std_logic_vector(to_unsigned(
                                            to_integer(unsigned(ireg1value)) - 1,32));
                                    ProgCounter <= unsigned(ireg2value(11 downto 0));
                                when oRTN =>
                                    ProgCounter <= unsigned(doutb(11 downto 0));
                                when oRIO =>
                                    regist(iregop1) <= IORdata;
                                    regist(0) <= x"000000" & IOStatus;
                                when oWIO =>
                                    IOWdata <= regist(iregop1);
                                    regist(0) <= x"000000" & IOStatus;
                                when oPUSH =>
                                    regist(iregop1) <= std_logic_vector(to_unsigned(
                                            to_integer(unsigned(ireg1value)) - 1,32));
                                when oPOP =>
                                    regist(iregop2) <= doutb;
                                when others =>
                            end case;
                        when IMMEDIATE =>
                            case opcode is
                                when oLD =>
                                    if flag = '1' then
                                        regist(iregop1)(31 downto 16) <= immop;
                                    else
                                        regist(iregop1)(15 downto 0) <= immop;
                                    end if;
                                when oADD =>
                                    if iregop2 = 0 then
                                        regist(iregop1) <= 
                                            std_logic_vector(to_unsigned(to_integer(unsigned(ireg1value)) + 
                                                to_integer(unsigned(immop))
                                                ,32));
                                    else
                                        regist(iregop1) <= 
                                            std_logic_vector(to_unsigned(
                                                to_integer(unsigned(ireg1value)) + 
                                                to_integer(unsigned(ireg2value)) +
                                                to_integer(unsigned(immop))
                                                ,32));
                                    end if;
                                when oSUB =>
                                    if iregop2 = 0 then
                                        regist(iregop1) <= 
                                            std_logic_vector(to_unsigned(
                                                to_integer(unsigned(ireg1value)) - 
                                                to_integer(unsigned(immop))
                                                ,32));
                                    else
                                        regist(iregop1) <= 
                                            std_logic_vector(to_unsigned(
                                                to_integer(unsigned(ireg1value)) - 
                                                to_integer(unsigned(ireg2value)) -
                                                to_integer(unsigned(immop))
                                                ,32));
                                    end if;
                                when oAND =>
                                    if flag = '0' and iregop2 = 0 then
                                        regist(iregop1) <= ireg1value and (X"1111" & immop);
                                    elsif flag = '1' and iregop2 = 0 then
                                        regist(iregop1) <= ireg1value nand (X"1111" & immop);
                                    elsif flag = '0' and iregop2 = 0 then
                                        regist(iregop1) <= ireg1value and ireg2value and (X"1111" & immop);
                                    else
                                        regist(iregop1) <= ireg1value nand (ireg2value nand (X"1111" & immop));
                                    end if;
                                when oOR =>
                                    if flag = '0' and iregop2 = 0 then
                                        regist(iregop1) <= ireg1value or (X"0000" & immop);
                                    elsif flag = '1' and iregop2 = 0 then
                                        regist(iregop1) <= ireg1value nor (X"0000" & immop);
                                    elsif flag = '0' and iregop2 = 0 then
                                        regist(iregop1) <= ireg1value or ireg2value or (X"1111" & immop);
                                    else
                                        regist(iregop1) <= ireg1value nor (ireg2value nor (X"1111" & immop));
                                    end if;
                                when oXOR =>
                                    if flag = '0' and iregop2 = 0 then
                                        regist(iregop1) <= ireg1value xor (X"0000" & immop);
                                    elsif flag = '1' and iregop2 = 0 then
                                        regist(iregop1) <= ireg1value xnor (X"0000" & immop);
                                    elsif flag = '0' and iregop2 = 0 then
                                        regist(iregop1) <= ireg1value xor ireg2value xor (X"1111" & immop);
                                    else
                                        regist(iregop1) <= ireg1value xnor (ireg2value xnor (X"1111" & immop));
                                    end if;
                                when oSHL =>
                                    regist(iregop1) <= std_logic_vector(unsigned(ireg1value) 
                                        sll to_integer(unsigned(immop(4 downto 0))));
                                when oSHR =>
                                    regist(iregop1) <= std_logic_vector(unsigned(ireg1value) 
                                        srl to_integer(unsigned(immop(4 downto 0))));
                                when oJMP =>
                                    ProgCounter <= unsigned(immop(11 downto 0));
                                when oBE =>
                                    if  iregop2 /= 0 
                                        and  ((FLAG = '0' and ireg1value = ireg2value)
                                        or (FLAG = '1' and ireg1value /= ireg2value)) then
                                            ProgCounter <= unsigned(immop(11 downto 0));
                                    elsif iregop2 = 0 
                                        and  ((FLAG = '0' and signed(ireg1value) = 0)
                                        or (FLAG = '1' and signed(ireg1value) /= 0)) then
                                            ProgCounter <= unsigned(immop(11 downto 0));
                                    else
                                        ProgCounter <= ProgCounter + 1;
                                    end if;
                                when oBLT =>
                                    if iregop2 /= 0 
                                        and ((FLAG = '0' and ireg1value < ireg2value) 
                                         or (FLAG = '1' and ireg1value >= ireg2value)) 
                                         then
                                            ProgCounter <= unsigned(immop(11 downto 0));
                                    elsif iregop2 = 0 
                                        and ((FLAG = '0' and signed(ireg1value) < 0) 
                                         or (FLAG = '1' and signed(ireg1value) >= 0))
                                         then
                                            ProgCounter <= unsigned(immop(11 downto 0));
                                    else
                                        ProgCounter <= ProgCounter + 1;
                                    end if;
                                when oBGT =>
                                    if iregop2 /= 0 
                                        and  ((FLAG = '0' and ireg1value > ireg2value) 
                                        or (FLAG = '1' and ireg1value <= ireg2value)) then
                                            ProgCounter <= unsigned(immop(11 downto 0));
                                    elsif iregop2 = 0 
                                        and  ((FLAG = '0' and signed(ireg1value) > 0) 
                                        or (FLAG = '1' and signed(ireg1value) <= 0)) then
                                            ProgCounter <= unsigned(immop(11 downto 0));
                                    else
                                        ProgCounter <= ProgCounter + 1;
                                    end if;
                                when oJSR =>
                                    regist(iregop1) <= std_logic_vector(to_unsigned(
                                            to_integer(unsigned(ireg1value)) - 1,32));
                                    ProgCounter <= unsigned(immop(11 downto 0));
                                when oRIO =>
                                    regist(iregop1) <= IORdata;
                                    regist(0) <= x"000000" & IOStatus;
                                when oWIO =>
                                    IOWdata <= regist(iregop1);
                                    regist(0) <= x"000000" & IOStatus;
                                when oPUSH =>
                                    regist(iregop1) <= std_logic_vector(to_unsigned(
                                            to_integer(unsigned(ireg1value)) - 1,32));
                                when others =>
                            end case;
                        when ABSOLUTE  | INDEX =>
                            case opcode is
                                when oLD =>
                                    regist(iregop1) <= doutb;
                                when oSTR =>
                                    dinb <= ireg1value;
                                when oADD =>
                                    regist(iregop1) <= 
                                        std_logic_vector(to_unsigned(
                                            to_integer(unsigned(ireg1value)) + 
                                            to_integer(unsigned(doutb)),32));
                                when oSUB =>
                                    regist(iregop1) <= 
                                        std_logic_vector(to_unsigned(
                                            to_integer(unsigned(ireg1value)) - 
                                            to_integer(unsigned(doutb)),32));
                                when oAND =>
                                    if FLAG = '0' then
                                        regist(iregop1) <= ireg1value and doutb;
                                    else
                                        regist(iregop1) <= ireg1value nand doutb;
                                    end if;
                                when oOR =>
                                    if FLAG = '0' then
                                        regist(iregop1) <= ireg1value or doutb;
                                    else
                                        regist(iregop1) <= ireg1value nor doutb;
                                    end if;
                                when oXOR =>
                                    if FLAG = '0' then
                                        regist(iregop1) <= ireg1value xor doutb;
                                    else
                                        regist(iregop1) <= ireg1value xnor doutb;
                                    end if;
                                when oSHL =>
                                    regist(iregop1) <= std_logic_vector(unsigned(ireg1value) 
                                        sll to_integer(unsigned(doutb(4 downto 0))));
                                when oSHR =>
                                    regist(iregop1) <= std_logic_vector(unsigned(ireg1value) 
                                        srl to_integer(unsigned(doutb(4 downto 0))));
                                when oJMP =>
                                    ProgCounter <= unsigned(doutb(11 downto 0));
                                when oBE =>
                                    if  iregop2 /= 0 
                                        and  ((FLAG = '0' and ireg1value = ireg2value)
                                        or (FLAG = '1' and ireg1value /= ireg2value)) then
                                            ProgCounter <= unsigned(doutb(11 downto 0));
                                    elsif iregop2 = 0 
                                        and  ((FLAG = '0' and signed(ireg1value) = 0)
                                        or (FLAG = '1' and signed(ireg1value) /= 0)) then
                                            ProgCounter <= unsigned(doutb(11 downto 0));
                                    else
                                        ProgCounter <= ProgCounter + 1;
                                    end if;
                                when oBLT =>
                                    if iregop2 /= 0 
                                        and ((FLAG = '0' and ireg1value < ireg2value) 
                                         or (FLAG = '1' and ireg1value >= ireg2value)) 
                                         then
                                            ProgCounter <= unsigned(doutb(11 downto 0));
                                    elsif iregop2 = 0 
                                        and ((FLAG = '0' and signed(ireg1value) < 0) 
                                         or (FLAG = '1' and signed(ireg1value) >= 0))
                                         then
                                            ProgCounter <= unsigned(doutb(11 downto 0));
                                    else
                                        ProgCounter <= ProgCounter + 1;
                                    end if;
                                when oBGT =>
                                    if iregop2 /= 0 
                                        and  ((FLAG = '0' and ireg1value > ireg2value) 
                                        or (FLAG = '1' and ireg1value <= ireg2value)) then
                                            ProgCounter <= unsigned(doutb(11 downto 0));
                                    elsif iregop2 = 0 
                                        and  ((FLAG = '0' and signed(ireg1value) > 0) 
                                        or (FLAG = '1' and signed(ireg1value) <= 0)) then
                                            ProgCounter <= unsigned(doutb(11 downto 0));
                                    else
                                        ProgCounter <= ProgCounter + 1;
                                    end if;

--                                when oBE =>
--                                    if  (FLAG = '0' and ireg1value = ireg2value) 
--                                     or (FLAG = '1' and ireg1value /= ireg2value) then
--                                        ProgCounter <= unsigned(doutb(11 downto 0));
--                                    else
--                                        ProgCounter <= ProgCounter + 1;
--                                    end if;
--                                when oBLT =>
--                                    if  (FLAG = '0' and ireg1value < ireg2value) 
--                                     or (FLAG = '1' and ireg1value >=ireg2value) then
--                                        ProgCounter <= unsigned(doutb(11 downto 0));
--                                    else
--                                        ProgCounter <= ProgCounter + 1;
--                                    end if;
--                                when oBGT =>
--                                    if  (FLAG = '0' and ireg1value > ireg2value) 
--                                     or (FLAG = '1' and ireg1value <= ireg2value) then
--                                        ProgCounter <= unsigned(doutb(11 downto 0));
--                                    else
--                                        ProgCounter <= ProgCounter + 1;
--                                    end if;
                                when oRIO =>
                                    dinb <= IORdata;
                                    regist(0) <= x"000000" & IOStatus;
                                when oWIO =>
                                    IOWdata <= doutb;
                                    regist(0) <= x"000000" & IOStatus;
                                when others =>
                            end case;
                        when others =>
                    end case;
                    
                    if      opcode /= oJMP 
                        and opcode /= oBE 
                        and opcode /= oBLT 
                        and opcode /= oBGT 
                        and opcode /= oJSR 
                        and opcode /= oRTN then -- ignore all Jump operations.
                         ProgCounter <= ProgCounter + 1;
                    end if;
                    if opcode = oRIO or opcode = oWIO then
                        cycle <= MEMW;
                    else
                        cycle <= prefetch;
                    end if;


                ----------------------------------------------------------------
                -- Update the program counter.
                -- All of these could be included in the Execute cycle and
                -- this state could be eliminated.
                when MEMW =>
                    case memop is
                        when REGREG =>
                            case opcode is
                                when oRIO =>
                                    IORena <= '0';
                                when oWIO =>
                                    IOWena <= '0';
                                when others =>
                            end case;
                        when IMMEDIATE =>
                            case opcode is
                                when oRIO =>
                                    IORena <= '0';
                                when oWIO =>
                                    IOWena <= '0';
                                when others =>
                            end case;
                        when ABSOLUTE | INDEX =>
                            case opcode is
                                when oRIO =>
                                    IORena <= '0';
                                when oWIO =>
                                    IOWena <= '0';
                                when others =>
                            end case;
                        when others => 
                    end case;
                   cycle <= prefetch;
                when others =>
                    cycle <= prefetch;
            end case;                 
        end if;
     end if;
 

    end process;

end Behavioral;
