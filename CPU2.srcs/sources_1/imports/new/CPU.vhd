----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Craig Shannon
-- 
-- Create Date: 11/29/2023 05:57:00 PM
-- Design Name: 
-- Module Name: CPU - Behavioral
-- Project Name: Craig's CPU
-- Target Devices: Arty S7
-- Tool Versions: Viviado
-- Description: 
-- 
-- Dependencies: Block Memory Generator
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

use xil_defaultlib.Utilities.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CPU is
  Port (
    clk : IN STD_LOGIC;
    ioAddr  : out STD_LOGIC_VECTOR (7 downto 0);
    IORdata    : in STD_LOGIC_VECTOR (31 downto 0);
    IOWdata   : out STD_LOGIC_VECTOR (31 downto 0);
    IORena: out STD_LOGIC;
    IOWena: out std_logic;
    IOStatus: in STD_LOGIC_VECTOR (7 downto 0);
    interrupt : in STD_LOGIC_VECTOR (31 downto 0);
    metrics : out METRICSTYPE;
    MEM_ENA     : out STD_LOGIC := '1';
    MEM_WEA     : out STD_LOGIC_VECTOR(0 DOWNTO 0)  := "0";
    MEM_ADDRA   : out STD_LOGIC_VECTOR(11 DOWNTO 0) := X"000";
    MEM_DINA    : out STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
    MEM_DOUTA   : in STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
    MEM_ENB     : out STD_LOGIC := '1';
    MEM_WEB     : out STD_LOGIC_VECTOR(0 DOWNTO 0) := "0";
    MEM_ADDRB   : out STD_LOGIC_VECTOR(11 DOWNTO 0) := X"000";
    MEM_DINB    : out STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
    MEM_DOUTB   : in STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000"
    );

end CPU;

architecture Behavioral of CPU is

-- COMPONENT cpumemory
--   PORT (
--     clka : IN STD_LOGIC;
--     ena : IN STD_LOGIC;
--     wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
--     addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
--     dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
--     douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
--     clkb : IN STD_LOGIC;
--     enb : IN STD_LOGIC;
--     web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
--     addrb : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
--     dinb : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
--     doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) 
--   );
-- END COMPONENT;

    signal ProgCounter : unsigned(11 downto 0) := X"000";
    signal cycle : CYCLETYPE := ADDRESS;

    -- Memory Information
    -- signal MEM_ENA : STD_LOGIC := '1';
    -- signal MEM_WEA : STD_LOGIC_VECTOR(0 DOWNTO 0) := "0";
    -- signal MEM_ADDRA : STD_LOGIC_VECTOR(11 DOWNTO 0) := X"000";
    -- signal MEM_DINA : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
    -- signal MEM_DOUTA : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
    -- signal MEM_ENB : STD_LOGIC := '1';
    -- signal MEM_WEB : STD_LOGIC_VECTOR(0 DOWNTO 0) := "0";
    -- signal MEM_ADDRB : STD_LOGIC_VECTOR(11 DOWNTO 0) := X"000";
    -- signal MEM_DINB : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
    -- signal MEM_DOUTB : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";

    -- Decode information    
    signal opcode : OPCODETYPE := "00000";
    signal ffopcode : OPCODETYPE := "00000";
    signal flag : STD_LOGIC :='0';
    signal ffflag : STD_LOGIC :='0';
    signal memop :  MEMTYPE;
    signal ffmemop : MEMTYPE;
    signal regop1 : REGTYPE;
    signal iregop1 : integer;
    signal ffiregop1 : integer;
    signal ireg1value : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
    signal regop2 : REGTYPE;
    signal iregop2 : integer;
    signal ffiregop2 : integer;
    signal ireg2value : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
    signal immop : IMMTYPE;
    signal ffimmop: IMMTYPE;
    
    -- Register information
    signal regist : reg_type := (others => (others => '0'));
    
    -- interrupts
    signal interruptNum : integer := 0;
    signal interNum : integer := 0;
--    signal interruptNum : unsigned(4 DOWNTO 0) := "00000";
    signal isInterrupt : STD_LOGIC := '0';
    signal interruptMask : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
    signal interruptSP : integer range 0 to 31;
    
    -- metrics
    signal cycleCount : unsigned (63 downto 0) := (others => '0');

    -- Wait & Timer
    signal waitEna : std_logic := '0';
    signal waitReg : integer range 0 to 15 := 0;
    signal waitTime : unsigned (31 downto 0) := (others => '0');
    signal waitCount : unsigned (31 downto 0) := (others => '0');
    signal waitResolution : unsigned (15 downto 0) := (others => '0');
    signal waitResCounter : unsigned (15 downto 0) := (others => '0');

    signal timerEna : std_logic := '0';
    signal timerReg : integer range 0 to 15 := 0;
    signal timerTime : unsigned (31 downto 0) := (others => '0');
    signal timerCount : unsigned (31 downto 0) := (others => '0');
    signal timerInt : unsigned (4 downto 0) := "00000";
    signal timerResolution : unsigned (15 downto 0) := (others => '0');
    signal timerResCounter : unsigned (15 downto 0) := (others => '0');
    
begin

-- memory : cpumemory
--   PORT MAP (
--     clka => clk,
--     ena => MEM_ENA,
--     wea => MEM_WEA,
--     addra => MEM_ADDRA,
--     dina => MEM_DINA,
--     douta => MEM_DOUTA,
--     clkb => clk,
--     enb => MEM_ENB,
--     web => MEM_WEB,
--     addrb => MEM_ADDRB,
--     dinb => MEM_DINB,
--     doutb => MEM_DOUTB
--   );



    opcode <= MEM_DOUTA(31 downto 27);
    flag <= MEM_DOUTA(26);
    memop <= MEM_DOUTA(25 downto 24); 
    regop1 <= MEM_DOUTA(23 downto 20);
    regop2 <= MEM_DOUTA(19 downto 16);
    immop <= MEM_DOUTA(15 downto 0);
    iregop1 <= to_integer(unsigned(regop1));
    iregop2 <= to_integer(unsigned(regop2));

    
    interNum <= 
        0 when interrupt = RESET else
        1 when interrupt = X"00000002" else
        2 when interrupt = X"00000004" else
        3 when interrupt = X"00000008" else
        4 when interrupt = X"00000010" else
        5 when interrupt = X"00000020" else
        6 when interrupt = X"00000040" else
        7 when interrupt = X"00000080" else
        8 when interrupt = X"00000100" else
        9 when interrupt = X"00000200" else
        10 when interrupt = X"00000400" else
        11 when interrupt = X"00000800" else
        12 when interrupt = X"00001000" else
        13 when interrupt = X"00002000" else
        14 when interrupt = X"00004000" else
        15 when interrupt = X"00008000" else
        16 when interrupt = X"00000001" else
        17 when interrupt = X"00000002" else
        18 when interrupt = X"00040000" else
        19 when interrupt = X"00080000" else
        20 when interrupt = X"00100000" else
        21 when interrupt = X"00200000" else
        22 when interrupt = X"00400000" else
        23 when interrupt = X"00800000" else
        24 when interrupt = X"01000000" else
        25 when interrupt = X"02000000" else
        26 when interrupt = X"04000000" else
        27 when interrupt = X"08000000" else
        28 when interrupt = X"10000000" else
        29 when interrupt = X"20000000" else
        30 when interrupt = X"40000000" else
        31 when interrupt = X"80000000" else
        31;
    


    Reg_Proc: process (clk)
    begin
    
    if rising_edge  (clk) then
        if interrupt = RESET then
            ProgCounter <= X"000";
            MEM_ENA <= '1';
            MEM_WEA <= "0";
            MEM_ADDRA <= X"000";
            MEM_ENB <= '1';
            MEM_WEB <= "0";
            MEM_ADDRB <= X"000";
            MEM_DINB <= X"00000000";
            regist <= (others => (others =>'0'));
            ireg1value <= (others => '0');
            ireg2value <= (others => '0');
            IOWdata <= (others => '0');
            ioAddr <= (others => '0');
            IORena <= '0';
            IOWena <= '0';
            isInterrupt <= '1';
            interruptNum <= interNum;
            cycle <= JMPADDR;
            cycleCount <= (others => '0');
            metrics.cycleCount <= (others => '0');
            timerReg <= 0;
            waitReg <= 0;
            timerEna <= '0';
            waitEna <= '0';
        else
            cycleCount <= cycleCount + 1;
            metrics.cycleCount <= cycleCount;
            case cycle is

                ----------------------------------------------------------------
                -- This sets up the instruction address to read.
                when ADDRESS =>
                    MEM_ENA <= '1';
                    MEM_WEA <= "0";
                    MEM_ADDRA <= STD_LOGIC_VECTOR(unsigned(ProgCounter));
                    cycle <= INSTFETCH1;

                ----------------------------------------------------------------
                -- This is the Cycle to wait for the Fetch Instruction Memory
                when INSTFETCH1 =>
                    cycle <= INSTFETCH2;


                ----------------------------------------------------------------
                -- This is the second Cycle for the Fetch Instruction Memory
                when INSTFETCH2 =>
                    cycle <= DECODE;

                -- Decoding is complete
                -- Set up memory address for ABSOLUTE and INDEX
                when DECODE =>
                    ireg1value <= regist(iregop1);
                    ireg2value <= regist(iregop2);
                    ffopcode <= opcode;
                    ffmemop <= memop;
                    ffflag <= flag;
                    ffiregop1 <= iregop1;
                    ffiregop2 <= iregop2;
                    ffimmop <= immop;

                    case memop is
                        when REGREG =>
                            case opcode is
                                when oJSR =>
                                    MEM_ENB <= '1';
                                    MEM_WEB <= "1";
                                    MEM_ADDRB <= regist(iregop1)(11 downto 0);
                                    MEM_DINB <= X"00000" & STD_LOGIC_VECTOR(unsigned(ProgCounter + 1));
                                    cycle <= EXECUTE;
                                when oRTN =>
                                    MEM_ENB <= '1';
                                    MEM_WEB <= "0";
                                    MEM_ADDRB <= std_logic_vector(to_unsigned(
                                            to_integer(unsigned(regist(iregop1))) + 1,12));
                                    regist(iregop1) <= std_logic_vector(to_unsigned(
                                            to_integer(unsigned(regist(iregop1))) + 1,32));
                                    cycle <= MEMFETCH1;
                                when oRWIO =>
                                    if flag = '0' then
                                        IOAddr <= regist(iregop2)(7 downto 0);
                                        IORena <= '1';
                                        cycle <= MEMFETCH2;
                                    else
                                        IOAddr <= regist(iregop2)(7 downto 0);
                                        IOWena <= '1';
                                        cycle <= MEMFETCH2;
                                    end if;
                                when oPUSHPOP =>
                                    if flag = '0' then
                                        MEM_ENB <= '1';
                                        MEM_WEB <= "1";
                                        MEM_ADDRB <= regist(iregop1)(11 downto 0);
                                        MEM_DINB <= regist(iregop2);
                                        cycle <= EXECUTE;
                                    else
                                        MEM_ENB <= '1';
                                        MEM_WEB <= "0";
                                        MEM_ADDRB <= std_logic_vector(to_unsigned(
                                                to_integer(unsigned(regist(iregop1))) + 1,12));
                                        regist(iregop1) <= std_logic_vector(to_unsigned(
                                                to_integer(unsigned(regist(iregop1))) + 1,32));
                                        cycle <= MEMFETCH1;
                                    end if;
                                when oRTI =>
                                    MEM_ADDRB <= std_logic_vector(to_unsigned(
                                            to_integer(unsigned(regist(interruptSP))) + 1,12));
                                    cycle <= MEMFETCH1;
                                when others =>
                                    cycle <= EXECUTE;
                            end case;
                        when IMMEDIATE =>
                            case opcode is
                                when oJSR =>
                                    MEM_ENB <= '1';
                                    MEM_WEB <= "1";
                                    MEM_ADDRB <= regist(iregop1)(11 downto 0);
                                    MEM_DINB <= X"00000" & STD_LOGIC_VECTOR(unsigned(ProgCounter + 1));
                                    cycle <= EXECUTE;
                                when oRWIO =>
                                    if flag = '0' then
                                        IOAddr <= immop(7 downto 0);
                                        IORena <= '1';
                                        cycle <= MEMFETCH2;
                                    else
                                        IOAddr <= immop(7 downto 0);
                                        IOWena <= '1';
                                        cycle <= MEMFETCH2;
                                    end if;
                                when oPUSHPOP =>
                                    if flag = '0' then
                                        MEM_ENB <= '1';
                                        MEM_WEB <= "1";
                                        MEM_ADDRB <= regist(iregop1)(11 downto 0);
                                        MEM_DINB <= X"0000" & immop;
                                        cycle <= EXECUTE;
                                    end if;
                                when others =>
                                    cycle <= EXECUTE;
                            end case;
                        when ABSOLUTE =>
                            case opcode is
                                when oLD | oADD | oSUB | oAND | oOr | oXor | oShl | oShr | oJMP | oBE | oBLT | oBGT | oSWI | oIENA =>
                                    MEM_ENB <= '1';
                                    MEM_WEB <= "0";
                                    MEM_ADDRB <= immop(11 downto 0);
                                    cycle <= MEMFETCH1;
                                when oSTR =>
                                    MEM_ENB <= '1';
                                    MEM_WEB <= "1";
                                    MEM_ADDRB <= immop(11 downto 0);
                                    cycle <= MEMFETCH1;
                                when oRWIO =>
                                    if flag = '0' then
                                        IOAddr <= regist(iregop2)(7 downto 0);
                                        MEM_ENB <= '1';
                                        MEM_WEB <= "1";
                                        MEM_ADDRB <= immop(11 downto 0);
                                        IORena <= '1';
                                        cycle <= MEMFETCH1;
                                    else
                                        IOAddr <= regist(iregop2)(7 downto 0);
                                        MEM_ENB <= '1';
                                        MEM_WEB <= "0";
                                        MEM_ADDRB <= immop(11 downto 0);
                                        IOWena <= '1';
                                        cycle <= MEMFETCH1;
                                    end if;
                                when others =>
                                    cycle <= EXECUTE;
                            end case;
                        when INDEX =>
                            case opcode is
                                when oLD | oADD | oSUB | oAND | oOr | oXor | oShl | oShr | oJMP =>
                                    MEM_ENB <= '1';
                                    MEM_WEB <= "0";
                                    MEM_ADDRB <=    std_logic_vector(to_unsigned(to_integer(unsigned(immop(11 downto 0))) + 
                                                to_integer(unsigned(regist(iregop2))),12));
                                    cycle <= MEMFETCH1;
                                when oSTR  =>
                                    MEM_ENB <= '1';
                                    MEM_WEB <= "1";
                                    MEM_ADDRB <=    std_logic_vector(to_unsigned(to_integer(unsigned(immop(11 downto 0))) + 
                                                to_integer(unsigned(regist(iregop2))),12));
                                    cycle <= MEMFETCH1;
                                when oRWIO =>
                                    if flag = '0' then
                                        IOAddr <= regist(iregop1)(7 downto 0);
                                        MEM_ENB <= '1';
                                        MEM_WEB <= "1";
                                        MEM_ADDRB <= std_logic_vector(to_unsigned(to_integer(unsigned(immop(11 downto 0))) + 
                                                    to_integer(unsigned(regist(iregop2))),12));
                                        IORena <= '1';
                                        cycle <= MEMFETCH1;
                                    else
                                        IOAddr <= regist(iregop1)(7 downto 0);
                                        MEM_ENB <= '1';
                                        MEM_WEB <= "0";
                                        MEM_ADDRB <= std_logic_vector(to_unsigned(to_integer(unsigned(immop(11 downto 0))) + 
                                                    to_integer(unsigned(regist(iregop2))),12));
                                        IOWena <= '1';
                                        cycle <= MEMFETCH1;
                                    end if;
                                when others =>
                                    cycle <= EXECUTE;
                            end case;
                        when others =>
                            cycle <= EXECUTE;
                    end case;
                    if      opcode /= oJMP 
                        and opcode /= oBE 
                        and opcode /= oBLT 
                        and opcode /= oBGT 
                        and opcode /= oJSR 
                        and opcode /= oRTN 
                        and opcode /= oRTI 
                        then -- ignore all Jump operations.
                            MEM_ADDRA <= STD_LOGIC_VECTOR(unsigned(ProgCounter+1));
                    end if;


                ----------------------------------------------------------------
                -- Cycle to wait for memory to be read.
                -- ABSOLUTE and INDEX operations.
                when MEMFETCH1 =>
                    case ffmemop is
                        when REGREG =>
                            case ffopcode is
                                when oRTI =>
                                    MEM_ADDRB <= std_logic_vector(to_unsigned(
                                            to_integer(unsigned(regist(interruptSP))) + 2,12));
                                    regist(interruptSP) <= std_logic_vector(to_unsigned(
                                            to_integer(unsigned(regist(interruptSP))) + 2,32));
                                    cycle <= MEMFETCH2;
                                    -- cycle <= EXECUTE;
                                when others =>
                                    cycle <= MEMFETCH2;
                            end case;
                        when others =>
                            cycle <= MEMFETCH2;
                    end case;

                ----------------------------------------------------------------
                -- Second Cycle to wait for memory to be read.
                -- ABSOLUTE and INDEX operations.
                when MEMFETCH2 =>
                    cycle <= EXECUTE;
                    
                ----------------------------------------------------------------
                -- Execute intruction
                when EXECUTE =>
                    case ffmemop is
                        when REGREG =>
                            case ffopcode is
                                when oLD =>
                                    regist(ffiregop1) <= ireg2value;
                                when oADD =>
                                    regist(ffiregop1) <= 
                                        std_logic_vector(to_signed(
                                            to_integer(signed(ireg1value)) + 
                                            to_integer(signed(ireg2value)),32));
                                when oSUB =>
                                    regist(ffiregop1) <= 
                                        std_logic_vector(to_signed(
                                            to_integer(signed(ireg1value)) - 
                                            to_integer(signed(ireg2value)),32));
                                when oAND =>
                                    if ffflag = '0' then
                                        regist(ffiregop1) <= ireg1value and ireg2value;
                                    else
                                        regist(ffiregop1) <= (ireg1value nand ireg2value);
                                    end if;
                                when oOR =>
                                    if ffflag = '0' then
                                        regist(ffiregop1) <= ireg1value or ireg2value;
                                    else
                                        regist(ffiregop1) <= (ireg1value nor ireg2value);
                                    end if;
                                when oXOR =>
                                    if ffflag = '0' then
                                        regist(ffiregop1) <= ireg1value xor ireg2value;
                                    else
                                        regist(ffiregop1) <= (ireg1value xnor ireg2value);
                                    end if;
                                when oSHL =>
                                    regist(ffiregop1) <= std_logic_vector(unsigned(ireg1value) 
                                        sll to_integer(unsigned(ireg2value(4 downto 0))));
                                when oSHR =>
                                    regist(ffiregop1) <= std_logic_vector(unsigned(ireg1value) 
                                        srl to_integer(unsigned(ireg2value(4 downto 0))));
                                when oJMP =>
                                    ProgCounter <= unsigned(ireg2value(11 downto 0));
                                when oJSR =>
                                    regist(ffiregop1) <= std_logic_vector(to_unsigned(
                                            to_integer(unsigned(ireg1value)) - 1,32));
                                    ProgCounter <= unsigned(ireg2value(11 downto 0));
                                when oRTN =>
                                    ProgCounter <= unsigned(MEM_DOUTB(11 downto 0));
                                when oRTI =>
                                    ProgCounter <= unsigned(MEM_DOUTB(11 downto 0));
                                when oRWIO =>
                                    if ffflag = '0' then
                                        regist(ffiregop1) <= IORdata;
                                        regist(0) <= x"000000" & IOStatus;
                                    else
                                        IOWdata <= regist(ffiregop1);
                                        regist(0) <= x"000000" & IOStatus;
                                    end if;
                                when oPUSHPOP =>
                                    if ffflag = '0' then
                                        regist(ffiregop1) <= std_logic_vector(to_unsigned(
                                                to_integer(unsigned(ireg1value)) - 1,32));
                                    else
                                        regist(iregop2) <= MEM_DOUTB;
                                    end if;
                                when oSWI =>
                                    if interruptMask(ffiregop1) = '1' then
                                        isInterrupt <= '1';
                                        interruptNum <= to_integer(unsigned(ireg1value));
                                    end if;
                                when oIENA =>
                                    interruptSP <= ffiregop1;
                                    interruptMask <= ireg2value;
                                when oWAIT =>
                                    if ffflag = '1' then
                                        if ffiregop1 = waitReg then
                                            waitReg <= 0;
                                            waitResCounter <= (others => '0');
                                            waitCount <= (others => '0');
                                            waitEna <= '0';
                                        elsif ffiregop1 = timerReg then
                                            timerReg  <= 0;
                                            timerResCounter <= (others => '0');
                                            timerCount <= (others => '0');
                                            timerEna <= '0';
                                        end if;
                                    end if;
                                when others =>
                            end case;
                        when IMMEDIATE =>
                            case ffopcode is
                                when oLD =>
                                    if ffflag = '1' then
                                        regist(ffiregop1)(31 downto 16) <= ffimmop;
                                    else
                                        regist(ffiregop1)(15 downto 0) <= ffimmop;
                                    end if;
                                when oADD =>
                                    if iregop2 = 0 then
                                        regist(ffiregop1) <= 
                                            std_logic_vector(to_signed(to_integer(signed(ireg1value)) + 
                                                to_integer(signed(ffimmop))
                                                ,32));
                                    else
                                        regist(ffiregop1) <= 
                                            std_logic_vector(to_signed(
                                                to_integer(signed(ireg1value)) + 
                                                to_integer(signed(ireg2value)) +
                                                to_integer(signed(ffimmop))
                                                ,32));
                                    end if;
                                when oSUB =>
                                    if iregop2 = 0 then
                                        regist(ffiregop1) <= 
                                            std_logic_vector(to_signed(
                                                to_integer(signed(ireg1value)) - 
                                                to_integer(signed(ffimmop))
                                                ,32));
                                    else
                                        regist(ffiregop1) <= 
                                            std_logic_vector(to_signed(
                                                to_integer(signed(ireg1value)) - 
                                                to_integer(signed(ireg2value)) -
                                                to_integer(signed(ffimmop))
                                                ,32));
                                    end if;
                                when oAND =>
                                    if ffflag = '0' and iregop2 = 0 then
                                        regist(ffiregop1) <= ireg1value and (X"1111" & ffimmop);
                                    elsif ffflag = '1' and iregop2 = 0 then
                                        regist(ffiregop1) <= ireg1value nand (X"1111" & ffimmop);
                                    elsif ffflag = '0' and iregop2 = 0 then
                                        regist(ffiregop1) <= ireg1value and ireg2value and (X"1111" & ffimmop);
                                    else
                                        regist(ffiregop1) <= ireg1value nand (ireg2value nand (X"1111" & ffimmop));
                                    end if;
                                when oOR =>
                                    if ffflag = '0' and iregop2 = 0 then
                                        regist(ffiregop1) <= ireg1value or (X"0000" & ffimmop);
                                    elsif ffflag = '1' and iregop2 = 0 then
                                        regist(ffiregop1) <= ireg1value nor (X"0000" & ffimmop);
                                    elsif ffflag = '0' and iregop2 = 0 then
                                        regist(ffiregop1) <= ireg1value or ireg2value or (X"1111" & ffimmop);
                                    else
                                        regist(ffiregop1) <= ireg1value nor (ireg2value nor (X"1111" & ffimmop));
                                    end if;
                                when oXOR =>
                                    if ffflag = '0' and iregop2 = 0 then
                                        regist(ffiregop1) <= ireg1value xor (X"0000" & ffimmop);
                                    elsif ffflag = '1' and iregop2 = 0 then
                                        regist(ffiregop1) <= ireg1value xnor (X"0000" & ffimmop);
                                    elsif ffflag = '0' and iregop2 = 0 then
                                        regist(ffiregop1) <= ireg1value xor ireg2value xor (X"1111" & ffimmop);
                                    else
                                        regist(ffiregop1) <= ireg1value xnor (ireg2value xnor (X"1111" & ffimmop));
                                    end if;
                                when oSHL =>
                                    regist(ffiregop1) <= std_logic_vector(unsigned(ireg1value) 
                                        sll to_integer(unsigned(ffimmop(4 downto 0))));
                                when oSHR =>
                                    regist(ffiregop1) <= std_logic_vector(unsigned(ireg1value) 
                                        srl to_integer(unsigned(ffimmop(4 downto 0))));
                                when oJMP =>
                                    ProgCounter <= unsigned(ffimmop(11 downto 0));
                                when oBE =>
                                    if  iregop2 /= 0 
                                        and  ((ffflag = '0' and ireg1value = ireg2value)
                                        or (ffflag = '1' and ireg1value /= ireg2value)) then
                                            ProgCounter <= unsigned(ffimmop(11 downto 0));
                                    elsif iregop2 = 0 
                                        and  ((ffflag = '0' and signed(ireg1value) = 0)
                                        or (ffflag = '1' and signed(ireg1value) /= 0)) then
                                            ProgCounter <= unsigned(ffimmop(11 downto 0));
                                    else
                                        ProgCounter <= ProgCounter + 1;
                                    end if;
                                when oBLT =>
                                    if iregop2 /= 0 
                                        and ((ffflag = '0' and ireg1value < ireg2value) 
                                         or (ffflag = '1' and ireg1value >= ireg2value)) 
                                         then
                                            ProgCounter <= unsigned(ffimmop(11 downto 0));
                                    elsif iregop2 = 0 
                                        and ((ffflag = '0' and signed(ireg1value) < 0) 
                                         or (ffflag = '1' and signed(ireg1value) >= 0))
                                         then
                                            ProgCounter <= unsigned(ffimmop(11 downto 0));
                                    else
                                        ProgCounter <= ProgCounter + 1;
                                    end if;
                                when oBGT =>
                                    if iregop2 /= 0 
                                        and  ((ffflag = '0' and ireg1value > ireg2value) 
                                        or (ffflag = '1' and ireg1value <= ireg2value)) then
                                            ProgCounter <= unsigned(ffimmop(11 downto 0));
                                    elsif iregop2 = 0 
                                        and  ((ffflag = '0' and signed(ireg1value) > 0) 
                                        or (ffflag = '1' and signed(ireg1value) <= 0)) then
                                            ProgCounter <= unsigned(ffimmop(11 downto 0));
                                    else
                                        ProgCounter <= ProgCounter + 1;
                                    end if;
                                when oJSR =>
                                    regist(ffiregop1) <= std_logic_vector(to_unsigned(
                                            to_integer(unsigned(ireg1value)) - 1,32));
                                    ProgCounter <= unsigned(ffimmop(11 downto 0));
                                when oRWIO =>
                                    if ffflag = '0' then
                                        regist(ffiregop1) <= IORdata;
                                        regist(0) <= x"000000" & IOStatus;
                                    else
                                        IOWdata <= regist(ffiregop1);
                                        regist(0) <= x"000000" & IOStatus;
                                    end if;
                                when oPUSHPOP =>
                                    if ffflag = '0' then
                                        regist(ffiregop1) <= std_logic_vector(to_unsigned(
                                                to_integer(unsigned(ireg1value)) - 1,32));
                                    end if;
                                when oSWI =>
                                    if interruptMask(to_integer(unsigned(ffimmop(4 downto 0)))) = '1' then
                                        isInterrupt <= '1';
                                        interruptNum <= to_integer(unsigned(ffimmop(4 downto 0)));
                                    end if;
                                when oIENA =>
                                    interruptSP <= ffiregop1;
                                    interruptMask <= X"0000" & ffimmop;
                                when oWAIT =>
                                    if ffflag = '0' then
                                        if ffiregop2 = 0 then
                                            waitReg <= ffiregop1;
                                            waitTime <= unsigned(regist(ffiregop1));
                                            waitResolution <= unsigned(ffimmop);
                                            waitCount <= (others => '0');
                                            waitEna <= '1';
                                        else
                                            timerreg <= ffiregop1;
                                            timerTime <= unsigned(regist(ffiregop1));
                                            timerInt <= unsigned(regist(ffiregop2)(4 downto 0));
                                            timerResolution <= unsigned(ffimmop);
                                            timerCount <= (others => '0');
                                            timerEna <= '1';
                                        end if;
                                    -- else
                                    --     if ffiregop1 = waitReg then
                                    --         waitReg <= 0;
                                    --         waitResCounter <= (others => '0');
                                    --         waitCount <= (others => '0');
                                    --         waitEna <= '0';
                                    --     elsif ffiregop1 = timerReg then
                                    --         timerReg  <= 0;
                                    --         timerResCounter <= (others => '0');
                                    --         timerCount <= (others => '0');
                                    --         timerEna <= '0';
                                    --     end if;
                                    end if;
                                when others =>
                            end case;
                        when ABSOLUTE  | INDEX =>
                            case ffopcode is
                                when oLD =>
                                    regist(ffiregop1) <= MEM_DOUTB;
                                when oSTR =>
                                    MEM_DINB <= ireg1value;
                                when oADD =>
                                    regist(ffiregop1) <= 
                                        std_logic_vector(to_signed(
                                            to_integer(signed(ireg1value)) + 
                                            to_integer(signed(MEM_DOUTB)),32));
                                when oSUB =>
                                    regist(ffiregop1) <= 
                                        std_logic_vector(to_signed(
                                            to_integer(signed(ireg1value)) - 
                                            to_integer(signed(MEM_DOUTB)),32));
                                when oAND =>
                                    if ffflag = '0' then
                                        regist(ffiregop1) <= ireg1value and MEM_DOUTB;
                                    else
                                        regist(ffiregop1) <= ireg1value nand MEM_DOUTB;
                                    end if;
                                when oOR =>
                                    if ffflag = '0' then
                                        regist(ffiregop1) <= ireg1value or MEM_DOUTB;
                                    else
                                        regist(ffiregop1) <= ireg1value nor MEM_DOUTB;
                                    end if;
                                when oXOR =>
                                    if ffflag = '0' then
                                        regist(ffiregop1) <= ireg1value xor MEM_DOUTB;
                                    else
                                        regist(ffiregop1) <= ireg1value xnor MEM_DOUTB;
                                    end if;
                                when oSHL =>
                                    regist(ffiregop1) <= std_logic_vector(unsigned(ireg1value) 
                                        sll to_integer(unsigned(MEM_DOUTB(4 downto 0))));
                                when oSHR =>
                                    regist(ffiregop1) <= std_logic_vector(unsigned(ireg1value) 
                                        srl to_integer(unsigned(MEM_DOUTB(4 downto 0))));
                                when oJMP =>
                                    ProgCounter <= unsigned(MEM_DOUTB(11 downto 0));
                                when oBE =>
                                    if  iregop2 /= 0 
                                        and  ((ffflag = '0' and ireg1value = ireg2value)
                                        or (ffflag = '1' and ireg1value /= ireg2value)) then
                                            ProgCounter <= unsigned(MEM_DOUTB(11 downto 0));
                                    elsif iregop2 = 0 
                                        and  ((ffflag = '0' and signed(ireg1value) = 0)
                                        or (ffflag = '1' and signed(ireg1value) /= 0)) then
                                            ProgCounter <= unsigned(MEM_DOUTB(11 downto 0));
                                    else
                                        ProgCounter <= ProgCounter + 1;
                                    end if;
                                when oBLT =>
                                    if iregop2 /= 0 
                                        and ((ffflag = '0' and ireg1value < ireg2value) 
                                         or (ffflag = '1' and ireg1value >= ireg2value)) 
                                         then
                                            ProgCounter <= unsigned(MEM_DOUTB(11 downto 0));
                                    elsif iregop2 = 0 
                                        and ((ffflag = '0' and signed(ireg1value) < 0) 
                                         or (ffflag = '1' and signed(ireg1value) >= 0))
                                         then
                                            ProgCounter <= unsigned(MEM_DOUTB(11 downto 0));
                                    else
                                        ProgCounter <= ProgCounter + 1;
                                    end if;
                                when oBGT =>
                                    if iregop2 /= 0 
                                        and  ((ffflag = '0' and ireg1value > ireg2value) 
                                        or (ffflag = '1' and ireg1value <= ireg2value)) then
                                            ProgCounter <= unsigned(MEM_DOUTB(11 downto 0));
                                    elsif iregop2 = 0 
                                        and  ((ffflag = '0' and signed(ireg1value) > 0) 
                                        or (ffflag = '1' and signed(ireg1value) <= 0)) then
                                            ProgCounter <= unsigned(MEM_DOUTB(11 downto 0));
                                    else
                                        ProgCounter <= ProgCounter + 1;
                                    end if;
                                when oRWIO =>
                                    if ffflag = '0' then
                                        MEM_DINB <= IORdata;
                                        regist(0) <= x"000000" & IOStatus;
                                    else
                                        IOWdata <= MEM_DOUTB;
                                        regist(0) <= x"000000" & IOStatus;
                                    end if;
                                when oSWI =>
                                    if interruptMask(to_integer(unsigned(MEM_DOUTB(4 downto 0)))) = '1' then
                                        isInterrupt <= '1';
                                        interruptNum <= to_integer(unsigned(MEM_DOUTB(4 downto 0)));
                                    end if;
                                when oIENA =>
                                    interruptSP <= ffiregop1;
                                    interruptMask <= MEM_DOUTB;
                                when others =>
                            end case;
                        when others =>
                    end case;
                    
                    if      ffopcode /= oJMP 
                        and ffopcode /= oBE 
                        and ffopcode /= oBLT 
                        and ffopcode /= oBGT 
                        and ffopcode /= oJSR 
                        and ffopcode /= oRTN 
                        and ffopcode /= oRTI 
                        then -- ignore all Jump operations.
                         ProgCounter <= ProgCounter + 1;
                    end if;
                    
                    -- Find the next cycle state....
                    if ffopcode = oRWIO 
                        or ffopcode = oRTI
                        then -- Need additional step.
                        cycle <= CLEANUP;
                    elsif       ffopcode = oWait 
                            and ffflag = '0' 
                            and ffiregop2 = 0 then -- Specific requirement for only WAIT
                        cycle <= WAITS;
                    elsif ffopcode = oSWI then
                        MEM_ADDRB <= regist(interruptSP)(11 downto 0);
                        cycle <= SAVEENA;
                    elsif unsigned(interrupt and interruptMask) /= 0 then
                        MEM_ADDRB <= regist(interruptSP)(11 downto 0);
                        isInterrupt <= '1';
                        interruptNum <= interNum;
                        cycle <= SAVEENA;
                    elsif ffopcode /= oJMP 
                        and ffopcode /= oBE 
                        and ffopcode /= oBLT 
                        and ffopcode /= oBGT 
                        and ffopcode /= oJSR 
                        and ffopcode /= oRTN 
                        and ffopcode /= oRTI 
                        then
                        if ffmemop = ABSOLUTE or ffmemop = INDEX then
                            cycle <= DECODE;
                        else
                            cycle <= INSTFETCH2;
                        end if;
                    else 
                        cycle <= ADDRESS;
                    end if;
                    
                ----------------------------------------------------------------
                -- Update the program counter.
                -- All of these could be included in the Execute cycle and
                -- this state could be eliminated.
                when CLEANUP =>
                    case ffmemop is
                        when REGREG =>
                            case ffopcode is
                                when oRWIO =>
                                    if ffflag = '0' then
                                        IORena <= '0';
                                    else
                                        IOWena <= '0';
                                    end if;
                                when oRTI =>
                                    interruptMask <= MEM_DOUTB;
                                when others =>
                            end case;
                        when IMMEDIATE =>
                            case ffopcode is
                                when oRWIO =>
                                    if ffflag = '0' then
                                        IORena <= '0';
                                    else
                                        IOWena <= '0';
                                    end if;
                                when others =>
                            end case;
                        when ABSOLUTE | INDEX =>
                            case ffopcode is
                                when oRWIO =>
                                    if ffflag = '0' then
                                        IORena <= '0';
                                    else
                                        IOWena <= '0';
                                    end if;
                                when others =>
                            end case;
                        when others => 
                    end case;
                    if opcode = oRTI and waitEna = '1' then
                        cycle <= WAITS;
                    else
                        cycle <= ADDRESS;
                    end if;

            when SAVEENA =>
                if isInterrupt = '1' then
                    MEM_WEB <= "1";
                    MEM_ADDRB <= regist(interruptSP)(11 downto 0);
                    MEM_DINB <= interruptMask;
                    regist(interruptSP) <= std_logic_vector(to_unsigned(
                            to_integer(unsigned(regist(interruptSP))) - 1,32));
                     cycle <= DISABLEINT;
                else
                    cycle <= ADDRESS;
                end if;
            when DISABLEINT =>
                interruptMask <= (others => '0');
                MEM_WEB <= "1";
                MEM_ADDRB <= regist(interruptSP)(11 downto 0);
                MEM_DINB <= X"00000" & STD_LOGIC_VECTOR(unsigned(ProgCounter));
                cycle <= JMPADDR;
            when JMPADDR =>
                regist(interruptSP) <= std_logic_vector(to_unsigned(
                        to_integer(unsigned(regist(interruptSP))) - 1,32));
                MEM_WEB <= "0";
                MEM_ADDRB <= "0000000" & std_logic_vector(to_unsigned(interruptNum,5));
                cycle <= JMPFETCH1;
            when JMPFETCH1 =>
                cycle <= JMPFETCH2;
            when JMPFETCH2 =>
                cycle <= jump;
            when JUMP =>
                ProgCounter <= unsigned(MEM_DOUTB(11 downto 0));
                isInterrupt <= '0';
                cycle <= ADDRESS;
            when WAITS =>
                if waitTime /= 0 and waitEna = '1' and waitCount >= waitTime then
                    waitCount <= (others => '0');
                    waitEna <= '0';
                    cycle <= ADDRESS;
                else
                    cycle <= WAITS;
                end if;
            when others =>
                cycle <= ADDRESS;
            end case;

            -- Wait Counter
            if waitEna = '1' then
                waitResCounter <= waitResCounter + 1;
                if waitResCounter >= waitResolution-1 then
                    waitCount <= waitCount + 1;
                    waitResCounter <= (others => '0');
                end if;
            end if;

            -- Timer Counter and Start Interrupt
            if timerEna = '1' then
                timerResCounter <= timerResCounter + 1;
                if timerResCounter >= timerResolution-1 then
                    timerCount <= timerCount + 1;
                    timerResCounter <= (others => '0');
                    if timerTime /= 0 and timerCount >= timerTime then
                        if interruptMask(to_integer(unsigned(timerInt))) = '1' then
                            isInterrupt <= '1';
                            interruptNum <= to_integer(unsigned(timerInt));
                            cycle <= SAVEENA;
                        end if;
                        timerCount <= (others => '0');
                        timerEna <= '0';
                    end if;
                end if;
            end if;
        end if;
     end if;

    end process;


end Behavioral;
