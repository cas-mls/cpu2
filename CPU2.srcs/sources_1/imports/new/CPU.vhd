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
    SYS_CLK     : IN STD_LOGIC;
    IO_ADDR     : out STD_LOGIC_VECTOR (7 downto 0);
    IOR_DATA    : in STD_LOGIC_VECTOR (31 downto 0);
    IOW_DATA    : out STD_LOGIC_VECTOR (31 downto 0);
    IOR_ENA     : out STD_LOGIC;
    IOW_ENA     : out STD_LOGIC;
    IO_STATUS   : in STD_LOGIC_VECTOR (7 downto 0);
    INTERRUPT   : in STD_LOGIC_VECTOR (31 downto 0);
    -- METRICS     : out METRICSTYPE;
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

    signal METRICS     :  METRICSTYPE;

    signal ProgCounter : unsigned(11 downto 0) := X"000";
    signal fsm_inst_cycle_p : CYCLETYPE := RESET_STATE;
    signal fsm_inst_cycle_n : CYCLETYPE := RESET_STATE;

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
    signal interBitNum : integer := 0;
--    signal interruptNum : unsigned(4 DOWNTO 0) := "00000";
    signal isInterrupt : STD_LOGIC := '0';
    signal interruptMask : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
    signal interruptSP : integer range 0 to 31;
    
    -- metrics
    signal cycleCount : unsigned (63 downto 0) := (others => '0');

    -- Wait & Timer
    signal waitReg : integer range 0 to 15 := 0;
    signal waitTime : unsigned (31 downto 0) := (others => '0');
    signal waitCount : unsigned (31 downto 0) := (others => '0');
    signal waitResolution : unsigned (15 downto 0) := (others => '0');
    signal waitResCounter : unsigned (15 downto 0) := (others => '0');
    signal waitStart : std_logic := '0';
    signal waitRun : std_logic := '0';
    signal waitCancel : std_logic := '0';

    signal timerEna : std_logic := '0';
    signal timerReg : integer range 0 to 15 := 0;
    signal timerTime : unsigned (31 downto 0) := (others => '0');
    signal timerCount : unsigned (31 downto 0) := (others => '0');
    signal timerInt : unsigned (4 downto 0) := "00000";
    signal timerResolution : unsigned (15 downto 0) := (others => '0');
    signal timerResCounter : unsigned (15 downto 0) := (others => '0');
    signal timerStart : std_logic := '0';
    signal timerRun : std_logic := '0';
    signal timerCancel : std_logic := '0';
    
    -- attribute KEEP_HIERARCHY : string;
    -- attribute KEEP_HIERARCHY of Reg_Proc : label is "TRUE";
    attribute keep : string;
    -- attribute keep of ProgCounter : signal is "TRUE";
    
    
begin

    opcode <= MEM_DOUTA(31 downto 27);
    flag <= MEM_DOUTA(26);
    memop <= MEM_DOUTA(25 downto 24); 
    regop1 <= MEM_DOUTA(23 downto 20);
    regop2 <= MEM_DOUTA(19 downto 16);
    immop <= MEM_DOUTA(15 downto 0);
    iregop1 <= to_integer(unsigned(regop1));
    iregop2 <= to_integer(unsigned(regop2));

    interBitNum <= 
        0 when INTERRUPT = RESET else
        1 when INTERRUPT = X"00000002" else
        2 when INTERRUPT = X"00000004" else
        3 when INTERRUPT = X"00000008" else
        4 when INTERRUPT = X"00000010" else
        5 when INTERRUPT = X"00000020" else
        6 when INTERRUPT = X"00000040" else
        7 when INTERRUPT = X"00000080" else
        8 when INTERRUPT = X"00000100" else
        9 when INTERRUPT = X"00000200" else
        10 when INTERRUPT = X"00000400" else
        11 when INTERRUPT = X"00000800" else
        12 when INTERRUPT = X"00001000" else
        13 when INTERRUPT = X"00002000" else
        14 when INTERRUPT = X"00004000" else
        15 when INTERRUPT = X"00008000" else
        16 when INTERRUPT = X"00000001" else
        17 when INTERRUPT = X"00000002" else
        18 when INTERRUPT = X"00040000" else
        19 when INTERRUPT = X"00080000" else
        20 when INTERRUPT = X"00100000" else
        21 when INTERRUPT = X"00200000" else
        22 when INTERRUPT = X"00400000" else
        23 when INTERRUPT = X"00800000" else
        24 when INTERRUPT = X"01000000" else
        25 when INTERRUPT = X"02000000" else
        26 when INTERRUPT = X"04000000" else
        27 when INTERRUPT = X"08000000" else
        28 when INTERRUPT = X"10000000" else
        29 when INTERRUPT = X"20000000" else
        30 when INTERRUPT = X"40000000" else
        31 when INTERRUPT = X"80000000" else
        31;


    fsm_Proc : process (SYS_CLK)
    begin
        if rising_edge  (SYS_CLK) then
            if (INTERRUPT = RESET) then
                fsm_inst_cycle_p <= RESET_STATE;
            else
                fsm_inst_cycle_p <= fsm_inst_cycle_n;
            end if;
        end if;
    end process;


    Reg_Proc: process (
        fsm_inst_cycle_p, 
        opcode,
        flag,
        memop <= 
        waitRun, 
        timerRun,
        interBitNum,
        INTERRUPT
        )
    begin
    
    -- if rising_edge  (SYS_CLK) then
        -- if INTERRUPT = RESET then
        --     -- MEM_ENA <= '1';
        --     -- MEM_WEA <= "0";
        --     -- MEM_ADDRA <= X"000";
        --     MEM_ENB <= '1';
        --     MEM_WEB <= "0";
        --     MEM_ADDRB <= X"000";
        --     MEM_DINB <= X"00000000";
        --     regist <= (others => (others =>'0'));
        --     ireg1value <= (others => '0');
        --     ireg2value <= (others => '0');
        --     IOW_DATA <= (others => '0');
        --     IO_ADDR <= (others => '0');
        --     IOR_ENA <= '0';
        --     IOW_ENA <= '0';
        --     isInterrupt <= '1';
        --     if INTERRUPT /= NOINTERRUPT then
        --         interruptNum <= interBitNum;
        --     end if;
            -- fsm_inst_cycle_n <= RESET_STATE;
        --     cycleCount <= (others => '0');
        --     METRICS.cycleCount <= (others => '0');
        --     timerReg <= 0;
        --     waitReg <= 0;
        --     timerEna <= '0';
        -- else
            cycleCount <= cycleCount + 1;
            METRICS.cycleCount <= cycleCount;
            case fsm_inst_cycle_p is
                -- CPU RESET
                when RESET_STATE =>
                    -- regist <= (others => (others =>'0'));
                    -- ireg1value <= (others => '0');
                    -- ireg2value <= (others => '0');
                    -- IOW_DATA <= (others => '0');
                    -- IO_ADDR <= (others => '0');
                    -- IOR_ENA <= '0';
                    -- IOW_ENA <= '0';
                    -- isInterrupt <= '1';
                    if INTERRUPT /= NOINTERRUPT then
                        interruptNum <= interBitNum;
                    end if;
                    fsm_inst_cycle_n <= JMPADDR;
                    cycleCount <= (others => '0');
                    METRICS.cycleCount <= (others => '0');
                    timerReg <= 0;
                    waitReg <= 0;
                    timerEna <= '0';

                ----------------------------------------------------------------
                -- This sets up the instruction address to read.
                when ADDRESS =>
                    -- MEM_ENA <= '1';
                    -- MEM_WEA <= "0";
                    -- MEM_ADDRA <= STD_LOGIC_VECTOR(unsigned(ProgCounter));
                    fsm_inst_cycle_n <= INSTFETCH1;

                ----------------------------------------------------------------
                -- This is the Cycle to wait for the Fetch Instruction Memory
                when INSTFETCH1 =>
                    fsm_inst_cycle_n <= INSTFETCH2;


                ----------------------------------------------------------------
                -- This is the second Cycle for the Fetch Instruction Memory
                when INSTFETCH2 =>
                    fsm_inst_cycle_n <= DECODE;

                ----------------------------------------------------------------
                -- Decoding is completed in the combinatorial logic and should only be used in this cycle.
                --       (opcode, memop, flag, iregop1, iregop2, and immop)
                -- Set up memory address for ABSOLUTE and INDEX
                when DECODE =>

                    -- -- Maintain Flip-Flop (Memory) protions of the instruction.
                    -- -- This removes the timing violations and make the processor faster.
                    -- -- Might remove the combinatorial logic which should not be used after this cycle.
                    -- ffopcode <= opcode;
                    -- ffmemop <= memop;
                    -- ffflag <= flag;
                    -- ffiregop1 <= iregop1;
                    -- ffiregop2 <= iregop2;
                    -- ffimmop <= immop;
                    -- -- Save the values of the Register Data.  Again this ifor timing operations.
                    -- ireg1value <= regist(iregop1);
                    -- ireg2value <= regist(iregop2);

                    case memop is
                        when REGREG =>
                            case opcode is
                                when oJSR =>
                                    -- MEM_ENB <= '1';
                                    -- MEM_WEB <= "1";
                                    -- MEM_ADDRB <= regist(iregop1)(11 downto 0);
                                    -- MEM_DINB <= X"00000" & STD_LOGIC_VECTOR(unsigned(ProgCounter + 1));
                                    fsm_inst_cycle_n <= EXECUTE;
                                when oRTN =>
                                    -- MEM_ENB <= '1';
                                    -- MEM_WEB <= "0";
                                    -- MEM_ADDRB <= std_logic_vector(to_unsigned(
                                    --         to_integer(unsigned(regist(iregop1))) + 1,12));
                                    -- regist(iregop1) <= std_logic_vector(to_unsigned(
                                    --         to_integer(unsigned(regist(iregop1))) + 1,32));
                                    fsm_inst_cycle_n <= MEMFETCH1;
                                when oRWIO =>
                                    if flag = '0' then
                                        IO_ADDR <= regist(iregop2)(7 downto 0);
                                        IOR_ENA <= '1';
                                        fsm_inst_cycle_n <= MEMFETCH2;
                                    else
                                        IO_ADDR <= regist(iregop2)(7 downto 0);
                                        IOW_ENA <= '1';
                                        fsm_inst_cycle_n <= MEMFETCH2;
                                    end if;
                                when oPUSHPOP =>
                                    if flag = '0' then
                                        -- MEM_ENB <= '1';
                                        -- MEM_WEB <= "1";
                                        -- MEM_ADDRB <= regist(iregop1)(11 downto 0);
                                        -- MEM_DINB <= regist(iregop2);
                                        fsm_inst_cycle_n <= EXECUTE;
                                    else
                                        -- MEM_ENB <= '1';
                                        -- MEM_WEB <= "0";
                                        -- MEM_ADDRB <= std_logic_vector(to_unsigned(
                                        --         to_integer(unsigned(regist(iregop1))) + 1,12));
                                        -- regist(iregop1) <= std_logic_vector(to_unsigned(
                                        --         to_integer(unsigned(regist(iregop1))) + 1,32));
                                        fsm_inst_cycle_n <= MEMFETCH1;
                                    end if;
                                when oRTI =>
                                    -- MEM_ADDRB <= std_logic_vector(to_unsigned(
                                    --         to_integer(unsigned(regist(interruptSP))) + 1,12));
                                    fsm_inst_cycle_n <= MEMFETCH1;
                                when others =>
                                    fsm_inst_cycle_n <= EXECUTE;
                            end case;
                        when IMMEDIATE =>
                            case opcode is
                                when oJSR =>
                                    -- MEM_ENB <= '1';
                                    -- MEM_WEB <= "1";
                                    -- MEM_ADDRB <= regist(iregop1)(11 downto 0);
                                    -- MEM_DINB <= X"00000" & STD_LOGIC_VECTOR(unsigned(ProgCounter + 1));
                                    fsm_inst_cycle_n <= EXECUTE;
                                when oRWIO =>
                                    if flag = '0' then
                                        IO_ADDR <= immop(7 downto 0);
                                        IOR_ENA <= '1';
                                        fsm_inst_cycle_n <= MEMFETCH2;
                                    else
                                        IO_ADDR <= immop(7 downto 0);
                                        IOW_ENA <= '1';
                                        fsm_inst_cycle_n <= MEMFETCH2;
                                    end if;
                                when oPUSHPOP =>
                                    if flag = '0' then
                                        -- MEM_ENB <= '1';
                                        -- MEM_WEB <= "1";
                                        -- MEM_ADDRB <= regist(iregop1)(11 downto 0);
                                        -- MEM_DINB <= X"0000" & immop;
                                        fsm_inst_cycle_n <= EXECUTE;
                                    end if;
                                when others =>
                                    fsm_inst_cycle_n <= EXECUTE;
                            end case;
                        when ABSOLUTE =>
                            case opcode is
                                when oLD | oADD | oSUB | oAND | oOr | oXor | oShl | oShr | oJMP | oBE | oBLT | oBGT | oSWI | oIENA =>
                                    -- MEM_ENB <= '1';
                                    -- MEM_WEB <= "0";
                                    -- MEM_ADDRB <= immop(11 downto 0);
                                    fsm_inst_cycle_n <= MEMFETCH1;
                                when oSTR =>
                                    -- MEM_ENB <= '1';
                                    -- MEM_WEB <= "1";
                                    -- MEM_ADDRB <= immop(11 downto 0);
                                    fsm_inst_cycle_n <= MEMFETCH1;
                                when oRWIO =>
                                    if flag = '0' then
                                        IO_ADDR <= regist(iregop2)(7 downto 0);
                                        -- MEM_ENB <= '1';
                                        -- MEM_WEB <= "1";
                                        -- MEM_ADDRB <= immop(11 downto 0);
                                        IOR_ENA <= '1';
                                        fsm_inst_cycle_n <= MEMFETCH1;
                                    else
                                        IO_ADDR <= regist(iregop2)(7 downto 0);
                                        -- MEM_ENB <= '1';
                                        -- MEM_WEB <= "0";
                                        -- MEM_ADDRB <= immop(11 downto 0);
                                        IOW_ENA <= '1';
                                        fsm_inst_cycle_n <= MEMFETCH1;
                                    end if;
                                when others =>
                                    fsm_inst_cycle_n <= EXECUTE;
                            end case;
                        when INDEX =>
                            case opcode is
                                when oLD | oADD | oSUB | oAND | oOr | oXor | oShl | oShr | oJMP =>
                                    -- MEM_ENB <= '1';
                                    -- MEM_WEB <= "0";
                                    -- MEM_ADDRB <=    std_logic_vector(to_unsigned(to_integer(unsigned(immop(11 downto 0))) + 
                                    --             to_integer(unsigned(regist(iregop2))),12));
                                    fsm_inst_cycle_n <= MEMFETCH1;
                                when oSTR  =>
                                    -- MEM_ENB <= '1';
                                    -- MEM_WEB <= "1";
                                    -- MEM_ADDRB <=    std_logic_vector(to_unsigned(to_integer(unsigned(immop(11 downto 0))) + 
                                    --             to_integer(unsigned(regist(iregop2))),12));
                                    fsm_inst_cycle_n <= MEMFETCH1;
                                when oRWIO =>
                                    if flag = '0' then
                                        IO_ADDR <= regist(iregop1)(7 downto 0);
                                        -- MEM_ENB <= '1';
                                        -- MEM_WEB <= "1";
                                        -- MEM_ADDRB <= std_logic_vector(to_unsigned(to_integer(unsigned(immop(11 downto 0))) + 
                                        --             to_integer(unsigned(regist(iregop2))),12));
                                        IOR_ENA <= '1';
                                        fsm_inst_cycle_n <= MEMFETCH1;
                                    else
                                        IO_ADDR <= regist(iregop1)(7 downto 0);
                                        -- MEM_ENB <= '1';
                                        -- MEM_WEB <= "0";
                                        -- MEM_ADDRB <= std_logic_vector(to_unsigned(to_integer(unsigned(immop(11 downto 0))) + 
                                        --             to_integer(unsigned(regist(iregop2))),12));
                                        IOW_ENA <= '1';
                                        fsm_inst_cycle_n <= MEMFETCH1;
                                    end if;
                                when others =>
                                    fsm_inst_cycle_n <= EXECUTE;
                            end case;
                        when others =>
                            fsm_inst_cycle_n <= EXECUTE;
                        end case;
                    -- if      opcode /= oJMP 
                    --     and opcode /= oBE 
                    --     and opcode /= oBLT 
                    --     and opcode /= oBGT 
                    --     and opcode /= oJSR 
                    --     and opcode /= oRTN 
                    --     and opcode /= oRTI 
                    --     then -- ignore all Jump operations.
                    --         MEM_ADDRA <= STD_LOGIC_VECTOR(unsigned(ProgCounter+1));
                    --     end if;


                ----------------------------------------------------------------
                -- Cycle to wait for memory to be read.
                -- ABSOLUTE and INDEX operations.
                when MEMFETCH1 =>
                    case ffmemop is
                        when REGREG =>
                            case ffopcode is
                                when oRTI =>
                                    -- MEM_ADDRB <= std_logic_vector(to_unsigned(
                                    --         to_integer(unsigned(regist(interruptSP))) + 2,12));
                                    -- regist(interruptSP) <= std_logic_vector(to_unsigned(
                                    --         to_integer(unsigned(regist(interruptSP))) + 2,32));
                                    fsm_inst_cycle_n <= MEMFETCH2;
                                when others =>
                                    fsm_inst_cycle_n <= MEMFETCH2;
                            end case;
                        when others =>
                            fsm_inst_cycle_n <= MEMFETCH2;
                    end case;

                ----------------------------------------------------------------
                -- Second Cycle to wait for memory to be read.
                -- ABSOLUTE and INDEX operations.
                when MEMFETCH2 =>
                    fsm_inst_cycle_n <= EXECUTE;
                    
                ----------------------------------------------------------------
                -- Execute intruction
                when EXECUTE =>
                    case ffmemop is
                        when REGREG =>
                            case ffopcode is
                                when oLD =>
                                    -- regist(ffiregop1) <= ireg2value;
                                when oADD =>
                                    -- regist(ffiregop1) <= 
                                    --     std_logic_vector(to_signed(
                                    --         to_integer(signed(ireg1value)) + 
                                    --         to_integer(signed(ireg2value)),32));
                                when oSUB =>
                                    -- regist(ffiregop1) <= 
                                    --     std_logic_vector(to_signed(
                                    --         to_integer(signed(ireg1value)) - 
                                    --         to_integer(signed(ireg2value)),32));
                                when oAND =>
                                    -- if ffflag = '0' then
                                    --     regist(ffiregop1) <= ireg1value and ireg2value;
                                    -- else
                                    --     regist(ffiregop1) <= (ireg1value nand ireg2value);
                                    -- end if;
                                when oOR =>
                                    -- if ffflag = '0' then
                                    --     regist(ffiregop1) <= ireg1value or ireg2value;
                                    -- else
                                    --     regist(ffiregop1) <= (ireg1value nor ireg2value);
                                    -- end if;
                                when oXOR =>
                                    -- if ffflag = '0' then
                                    --     regist(ffiregop1) <= ireg1value xor ireg2value;
                                    -- else
                                    --     regist(ffiregop1) <= (ireg1value xnor ireg2value);
                                    -- end if;
                                when oSHL =>
                                    -- regist(ffiregop1) <= std_logic_vector(unsigned(ireg1value) 
                                    --     sll to_integer(unsigned(ireg2value(4 downto 0))));
                                when oSHR =>
                                    -- regist(ffiregop1) <= std_logic_vector(unsigned(ireg1value) 
                                    --     srl to_integer(unsigned(ireg2value(4 downto 0))));
                                when oJMP =>
                                when oJSR =>
                                    -- regist(ffiregop1) <= std_logic_vector(to_unsigned(
                                    --         to_integer(unsigned(ireg1value)) - 1,32));
                                when oRTN =>
                                when oRTI =>
                                when oRWIO =>
                                    if ffflag = '0' then
                                    --     regist(ffiregop1) <= IOR_DATA;
                                    --     regist(0) <= x"000000" & IO_STATUS;
                                    else
                                        IOW_DATA <= regist(ffiregop1);
                                    --     regist(0) <= x"000000" & IO_STATUS;
                                    end if;
                                when oPUSHPOP =>
                                    -- if ffflag = '0' then
                                    --     regist(ffiregop1) <= std_logic_vector(to_unsigned(
                                    --             to_integer(unsigned(ireg1value)) - 1,32));
                                    -- else
                                    --     regist(iregop2) <= MEM_DOUTB;
                                    -- end if;
                                when oSWI =>
                                    if interruptMask(ffiregop1) = '1' then
                                        isInterrupt <= '1';
                                        interruptNum <= to_integer(unsigned(ireg1value));
                                    end if;
                                when oIENA =>
                                    interruptSP <= ffiregop1;
                                    interruptMask <= ireg2value;
                                when oWAIT => -- Wait and Timer Cancel
                                    if ffflag = '1' then
                                        -- Interrupt processing can cancel the wait.
                                        if ffiregop1 = waitReg then
                                            waitReg <= 0;
                                            waitCancel <= '1';
                                        elsif ffiregop1 = timerReg then
                                            timerReg  <= 0;
                                            timerCancel <= '0';
                                        end if;
                                    end if;
                                when others =>
                            end case;
                        when IMMEDIATE =>
                            case ffopcode is
                                when oLD =>
                                    -- if ffflag = '1' then
                                    --     regist(ffiregop1)(31 downto 16) <= ffimmop;
                                    -- else
                                    --     regist(ffiregop1)(15 downto 0) <= ffimmop;
                                    -- end if;
                                when oADD =>
                                    -- if iregop2 = 0 then
                                    --     regist(ffiregop1) <= 
                                    --         std_logic_vector(to_signed(to_integer(signed(ireg1value)) + 
                                    --             to_integer(signed(ffimmop))
                                    --             ,32));
                                    -- else
                                    --     regist(ffiregop1) <= 
                                    --         std_logic_vector(to_signed(
                                    --             to_integer(signed(ireg1value)) + 
                                    --             to_integer(signed(ireg2value)) +
                                    --             to_integer(signed(ffimmop))
                                    --             ,32));
                                    -- end if;
                                when oSUB =>
                                    -- if iregop2 = 0 then
                                    --     regist(ffiregop1) <= 
                                    --         std_logic_vector(to_signed(
                                    --             to_integer(signed(ireg1value)) - 
                                    --             to_integer(signed(ffimmop))
                                    --             ,32));
                                    -- else
                                    --     regist(ffiregop1) <= 
                                    --         std_logic_vector(to_signed(
                                    --             to_integer(signed(ireg1value)) - 
                                    --             to_integer(signed(ireg2value)) -
                                    --             to_integer(signed(ffimmop))
                                    --             ,32));
                                    -- end if;
                                when oAND =>
                                    -- if ffflag = '0' and iregop2 = 0 then
                                    --     regist(ffiregop1) <= ireg1value and (X"1111" & ffimmop);
                                    -- elsif ffflag = '1' and iregop2 = 0 then
                                    --     regist(ffiregop1) <= ireg1value nand (X"1111" & ffimmop);
                                    -- elsif ffflag = '0' and iregop2 = 0 then
                                    --     regist(ffiregop1) <= ireg1value and ireg2value and (X"1111" & ffimmop);
                                    -- else
                                    --     regist(ffiregop1) <= ireg1value nand (ireg2value nand (X"1111" & ffimmop));
                                    -- end if;
                                when oOR =>
                                    -- if ffflag = '0' and iregop2 = 0 then
                                    --     regist(ffiregop1) <= ireg1value or (X"0000" & ffimmop);
                                    -- elsif ffflag = '1' and iregop2 = 0 then
                                    --     regist(ffiregop1) <= ireg1value nor (X"0000" & ffimmop);
                                    -- elsif ffflag = '0' and iregop2 = 0 then
                                    --     regist(ffiregop1) <= ireg1value or ireg2value or (X"1111" & ffimmop);
                                    -- else
                                    --     regist(ffiregop1) <= ireg1value nor (ireg2value nor (X"1111" & ffimmop));
                                    -- end if;
                                when oXOR =>
                                    -- if ffflag = '0' and iregop2 = 0 then
                                    --     regist(ffiregop1) <= ireg1value xor (X"0000" & ffimmop);
                                    -- elsif ffflag = '1' and iregop2 = 0 then
                                    --     regist(ffiregop1) <= ireg1value xnor (X"0000" & ffimmop);
                                    -- elsif ffflag = '0' and iregop2 = 0 then
                                    --     regist(ffiregop1) <= ireg1value xor ireg2value xor (X"1111" & ffimmop);
                                    -- else
                                    --     regist(ffiregop1) <= ireg1value xnor (ireg2value xnor (X"1111" & ffimmop));
                                    -- end if;
                                when oSHL =>
                                    -- regist(ffiregop1) <= std_logic_vector(unsigned(ireg1value) 
                                    --     sll to_integer(unsigned(ffimmop(4 downto 0))));
                                when oSHR =>
                                    -- regist(ffiregop1) <= std_logic_vector(unsigned(ireg1value) 
                                    --     srl to_integer(unsigned(ffimmop(4 downto 0))));
                                when oJMP =>
                                when oBE =>
                                when oBLT =>
                                when oBGT =>
                                when oJSR =>
                                    -- regist(ffiregop1) <= std_logic_vector(to_unsigned(
                                    --         to_integer(unsigned(ireg1value)) - 1,32));
                                when oRWIO =>
                                    if ffflag = '0' then
                                        -- regist(ffiregop1) <= IOR_DATA;
                                        -- regist(0) <= x"000000" & IO_STATUS;
                                    else
                                        IOW_DATA <= regist(ffiregop1);
                                        -- regist(0) <= x"000000" & IO_STATUS;
                                    end if;
                                when oPUSHPOP =>
                                    -- if ffflag = '0' then
                                    --     regist(ffiregop1) <= std_logic_vector(to_unsigned(
                                    --             to_integer(unsigned(ireg1value)) - 1,32));
                                    -- end if;
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
                                            if waitRun = '0' then
                                                waitReg <= ffiregop1;
                                                waitTime <= unsigned(regist(ffiregop1));
                                                waitResolution <= unsigned(ffimmop);
                                                waitStart <= '1';
                                                -- fsm_inst_cycle_n <= WAITS;
                                            else
                                                -- fsm_inst_cycle_n <= ADDRESS;
                                            end if;
                                        else
                                            timerreg <= ffiregop1;
                                            timerTime <= unsigned(regist(ffiregop1));
                                            timerInt <= unsigned(regist(ffiregop2)(4 downto 0));
                                            timerResolution <= unsigned(ffimmop);
                                            timerEna <= '1';
                                            timerStart <= '1';
                                        end if;
                                    end if;
                                when others =>
                            end case;
                        when ABSOLUTE  | INDEX =>
                            case ffopcode is
                                when oLD =>
                                    -- regist(ffiregop1) <= MEM_DOUTB;
                                when oSTR =>
                                    -- MEM_DINB <= ireg1value;
                                when oADD =>
                                    -- regist(ffiregop1) <= 
                                    --     std_logic_vector(to_signed(
                                    --         to_integer(signed(ireg1value)) + 
                                    --         to_integer(signed(MEM_DOUTB)),32));
                                when oSUB =>
                                    -- regist(ffiregop1) <= 
                                    --     std_logic_vector(to_signed(
                                    --         to_integer(signed(ireg1value)) - 
                                    --         to_integer(signed(MEM_DOUTB)),32));
                                when oAND =>
                                    -- if ffflag = '0' then
                                    --     regist(ffiregop1) <= ireg1value and MEM_DOUTB;
                                    -- else
                                    --     regist(ffiregop1) <= ireg1value nand MEM_DOUTB;
                                    -- end if;
                                when oOR =>
                                    -- if ffflag = '0' then
                                    --     regist(ffiregop1) <= ireg1value or MEM_DOUTB;
                                    -- else
                                    --     regist(ffiregop1) <= ireg1value nor MEM_DOUTB;
                                    -- end if;
                                when oXOR =>
                                    -- if ffflag = '0' then
                                    --     regist(ffiregop1) <= ireg1value xor MEM_DOUTB;
                                    -- else
                                    --     regist(ffiregop1) <= ireg1value xnor MEM_DOUTB;
                                    -- end if;
                                when oSHL =>
                                    -- regist(ffiregop1) <= std_logic_vector(unsigned(ireg1value) 
                                    --     sll to_integer(unsigned(MEM_DOUTB(4 downto 0))));
                                when oSHR =>
                                    -- regist(ffiregop1) <= std_logic_vector(unsigned(ireg1value) 
                                    --     srl to_integer(unsigned(MEM_DOUTB(4 downto 0))));
                                when oJMP =>
                                when oBE =>
                                when oBLT =>
                                when oBGT =>
                                when oRWIO =>
                                    if ffflag = '0' then
                                        -- MEM_DINB <= IOR_DATA;
                                        -- regist(0) <= x"000000" & IO_STATUS;
                                    else
                                        IOW_DATA <= MEM_DOUTB;
                                        -- regist(0) <= x"000000" & IO_STATUS;
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
                    
                    -- if      ffopcode /= oJMP 
                    --     and ffopcode /= oBE 
                    --     and ffopcode /= oBLT 
                    --     and ffopcode /= oBGT 
                    --     and ffopcode /= oJSR 
                    --     and ffopcode /= oRTN 
                    --     and ffopcode /= oRTI 
                    --     -- and ffopcode /= oWait
                    --     then -- ignore all Jump operations.
                    -- end if;
                    
                    -- Find the next cycle state....
                    if ffopcode = oRWIO 
                        or ffopcode = oRTI
                    then -- Need additional step.
                        fsm_inst_cycle_n <= CLEANUP;
                    elsif ffopcode = oWait 
                        and ffflag = '0' 
                        and ffiregop2 = 0 
                    then -- Specific requirement for only WAIT
                        fsm_inst_cycle_n <= WAITS;
                    elsif ffopcode = oSWI then
                        -- MEM_ADDRB <= regist(interruptSP)(11 downto 0);
                        fsm_inst_cycle_n <= SAVEENA;
                    elsif unsigned(INTERRUPT and interruptMask) /= 0 then
                        -- MEM_ADDRB <= regist(interruptSP)(11 downto 0);
                        isInterrupt <= '1';
                        interruptNum <= interBitNum;
                        fsm_inst_cycle_n <= SAVEENA;
                    elsif ffopcode /= oJMP 
                        and ffopcode /= oBE 
                        and ffopcode /= oBLT 
                        and ffopcode /= oBGT 
                        and ffopcode /= oJSR 
                        and ffopcode /= oRTN 
                        and ffopcode /= oRTI 
                    then
                        if ffmemop = ABSOLUTE or ffmemop = INDEX then
                            fsm_inst_cycle_n <= DECODE;
                        else
                            fsm_inst_cycle_n <= INSTFETCH2;
                        end if;
                    else 
                        fsm_inst_cycle_n <= ADDRESS;
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
                                        IOR_ENA <= '0';
                                    else
                                        IOW_ENA <= '0';
                                    end if;
                                when oRTI =>
                                    interruptMask <= MEM_DOUTB;
                                when others =>
                            end case;
                        when IMMEDIATE =>
                            case ffopcode is
                                when oRWIO =>
                                    if ffflag = '0' then
                                        IOR_ENA <= '0';
                                    else
                                        IOW_ENA <= '0';
                                    end if;
                                when others =>
                            end case;
                        when ABSOLUTE | INDEX =>
                            case ffopcode is
                                when oRWIO =>
                                    if ffflag = '0' then
                                        IOR_ENA <= '0';
                                    else
                                        IOW_ENA <= '0';
                                    end if;
                                when others =>
                            end case;
                        when others => 
                    end case;
                    if opcode = oRTI and waitRun = '1' then
                        fsm_inst_cycle_n <= WAITS;
                    else
                        fsm_inst_cycle_n <= ADDRESS;
                    end if;

            when SAVEENA =>
                if isInterrupt = '1' then
                    -- MEM_WEB <= "1";
                    -- MEM_ADDRB <= regist(interruptSP)(11 downto 0);
                    -- MEM_DINB <= interruptMask;
                    -- regist(interruptSP) <= std_logic_vector(to_unsigned(
                    --         to_integer(unsigned(regist(interruptSP))) - 1,32));
                     fsm_inst_cycle_n <= DISABLEINT;
                else
                    fsm_inst_cycle_n <= ADDRESS;
                end if;
            when DISABLEINT =>
                interruptMask <= (others => '0');
                -- MEM_WEB <= "1";
                -- MEM_ADDRB <= regist(interruptSP)(11 downto 0);
                -- MEM_DINB <= X"00000" & STD_LOGIC_VECTOR(unsigned(ProgCounter));
                fsm_inst_cycle_n <= JMPADDR;
            when JMPADDR =>
                -- regist(interruptSP) <= std_logic_vector(to_unsigned(
                --         to_integer(unsigned(regist(interruptSP))) - 1,32));
                -- MEM_WEB <= "0";
                -- MEM_ADDRB <= "0000000" & std_logic_vector(to_unsigned(interruptNum,5));
                fsm_inst_cycle_n <= JMPFETCH1;
            when JMPFETCH1 =>
                fsm_inst_cycle_n <= JMPFETCH2;
            when JMPFETCH2 =>
                fsm_inst_cycle_n <= jump;
           when JUMP =>
                isInterrupt <= '0';
                fsm_inst_cycle_n <= ADDRESS;
            when WAITS =>
                if waitRun = '1' then
                    fsm_inst_cycle_n <= WAITS;
                else
                    waitStart <= '0';
                    fsm_inst_cycle_n <= ADDRESS;
                end if;
            when others =>
                fsm_inst_cycle_n <= ADDRESS;
            end case;
        -- end if;

            if timerRun = '0' and timerEna = '1' then
                timerEna <= '0';
                timerStart <= '0';
                if interruptMask(to_integer(unsigned(timerInt))) = '1' then
                    isInterrupt <= '1';
                    interruptNum <= to_integer(unsigned(timerInt));
                    fsm_inst_cycle_n <= SAVEENA;
                end if;
            end if;

            -- Timer Counter and Start Interrupt
            -- if timerEna = '1' then
            --     timerResCounter <= timerResCounter + 1;
            --     if timerResCounter >= timerResolution-1 then
            --         timerCount <= timerCount + 1;
            --         timerResCounter <= (others => '0');
            --         if timerTime /= 0 and timerCount >= timerTime then
            --             if interruptMask(to_integer(unsigned(timerInt))) = '1' then
            --                 isInterrupt <= '1';
            --                 interruptNum <= to_integer(unsigned(timerInt));
            --                 fsm_inst_cycle_n <= SAVEENA;
            --             end if;
            --             timerCount <= (others => '0');
            --             timerEna <= '0';
            --         end if;
            --     end if;
            -- end if;
    --     end if;
    --  end if;

    end process;

    memoryAccess_proc : process (SYS_CLK) 
    begin
        if rising_edge  (SYS_CLK) then
            case fsm_inst_cycle_p is
                when RESET_STATE=>
                    MEM_ENB <= '1';
                    MEM_WEB <= "0";
                    MEM_ADDRB <= X"000";
                    MEM_DINB <= X"00000000";
                when ADDRESS    =>
                when INSTFETCH1 =>
                when INSTFETCH2 => 
                when DECODE     =>
                    case memop is
                        when REGREG =>
                            case opcode is
                                when oJSR =>
                                    MEM_ENB <= '1';
                                    MEM_WEB <= "1";
                                    MEM_ADDRB <= regist(iregop1)(11 downto 0);
                                    MEM_DINB <= X"00000" & STD_LOGIC_VECTOR(unsigned(ProgCounter + 1));
                                when oRTN =>
                                    MEM_ENB <= '1';
                                    MEM_WEB <= "0";
                                    MEM_ADDRB <= std_logic_vector(to_unsigned(
                                            to_integer(unsigned(regist(iregop1))) + 1,12));
                                when oPUSHPOP =>
                                    if flag = '0' then
                                        MEM_ENB <= '1';
                                        MEM_WEB <= "1";
                                        MEM_ADDRB <= regist(iregop1)(11 downto 0);
                                        MEM_DINB <= regist(iregop2);
                                    else
                                        MEM_ENB <= '1';
                                        MEM_WEB <= "0";
                                        MEM_ADDRB <= std_logic_vector(to_unsigned(
                                                to_integer(unsigned(regist(iregop1))) + 1,12));
                                    end if;
                                when oRTI =>
                                    MEM_ADDRB <= std_logic_vector(to_unsigned(
                                            to_integer(unsigned(regist(interruptSP))) + 1,12));
                                when others =>
                            end case;
                        when IMMEDIATE =>
                            case opcode is
                                when oJSR =>
                                    MEM_ENB <= '1';
                                    MEM_WEB <= "1";
                                    MEM_ADDRB <= regist(iregop1)(11 downto 0);
                                    MEM_DINB <= X"00000" & STD_LOGIC_VECTOR(unsigned(ProgCounter + 1));
                                when oPUSHPOP =>
                                    if flag = '0' then
                                        MEM_ENB <= '1';
                                        MEM_WEB <= "1";
                                        MEM_ADDRB <= regist(iregop1)(11 downto 0);
                                        MEM_DINB <= X"0000" & immop;
                                    end if;
                                when others =>
                            end case;
                        when ABSOLUTE =>
                            case opcode is
                                when oLD | oADD | oSUB | oAND | oOr | oXor | oShl | oShr | oJMP | oBE | oBLT | oBGT | oSWI | oIENA =>
                                    MEM_ENB <= '1';
                                    MEM_WEB <= "0";
                                    MEM_ADDRB <= immop(11 downto 0);
                                when oSTR =>
                                    MEM_ENB <= '1';
                                    MEM_WEB <= "1";
                                    MEM_ADDRB <= immop(11 downto 0);
                                when oRWIO =>
                                    if flag = '0' then
                                        MEM_ENB <= '1';
                                        MEM_WEB <= "1";
                                        MEM_ADDRB <= immop(11 downto 0);
                                    else
                                        MEM_ENB <= '1';
                                        MEM_WEB <= "0";
                                        MEM_ADDRB <= immop(11 downto 0);
                                    end if;
                                when others =>
                            end case;
        
                        when INDEX =>
                            case opcode is
                                when oLD | oADD | oSUB | oAND | oOr | oXor | oShl | oShr | oJMP =>
                                    MEM_ENB <= '1';
                                    MEM_WEB <= "0";
                                    MEM_ADDRB <=    std_logic_vector(to_unsigned(to_integer(unsigned(immop(11 downto 0))) + 
                                                to_integer(unsigned(regist(iregop2))),12));
                                when oSTR  =>
                                    MEM_ENB <= '1';
                                    MEM_WEB <= "1";
                                    MEM_ADDRB <=    std_logic_vector(to_unsigned(to_integer(unsigned(immop(11 downto 0))) + 
                                                to_integer(unsigned(regist(iregop2))),12));
                                when oRWIO =>
                                    if flag = '0' then
                                        MEM_ENB <= '1';
                                        MEM_WEB <= "1";
                                        MEM_ADDRB <= std_logic_vector(to_unsigned(to_integer(unsigned(immop(11 downto 0))) + 
                                                    to_integer(unsigned(regist(iregop2))),12));
                                    else
                                        MEM_ENB <= '1';
                                        MEM_WEB <= "0";
                                        MEM_ADDRB <= std_logic_vector(to_unsigned(to_integer(unsigned(immop(11 downto 0))) + 
                                                    to_integer(unsigned(regist(iregop2))),12));
                                    end if;
                                when others =>
                            end case;
                        when others =>
                    end case;
                when MEMFETCH1  =>
                    case ffmemop is
                        when REGREG =>
                            case ffopcode is
                                when oRTI =>
                                    MEM_ADDRB <= std_logic_vector(to_unsigned(
                                            to_integer(unsigned(regist(interruptSP))) + 2,12));
                                when others =>
                            end case;
                        when others =>
                        end case;

                when MEMFETCH2  =>
                when EXECUTE    =>
                    case ffmemop is
                        when REGREG =>
                            case ffopcode is
                                when oSWI =>
                                    MEM_ADDRB <= regist(interruptSP)(11 downto 0);
                                when others =>
                            end case;
                        when ABSOLUTE  | INDEX =>
                            case ffopcode is
                                when oSTR =>
                                    MEM_DINB <= ireg1value;
                                when oRWIO =>
                                    if ffflag = '0' then
                                        MEM_DINB <= IOR_DATA;
                                    end if;
                                when others =>
                            end case;
                        when others =>
                    end case;
                    if unsigned(INTERRUPT and interruptMask) /= 0 then
                        MEM_ADDRB <= regist(interruptSP)(11 downto 0);
                    end if;
    

                when CLEANUP    =>
                when SAVEENA    =>
                    if isInterrupt = '1' then
                        MEM_WEB <= "1";
                        MEM_ADDRB <= regist(interruptSP)(11 downto 0);
                        MEM_DINB <= interruptMask;
                    end if;                        
                when DISABLEINT =>
                    MEM_WEB <= "1";
                    MEM_ADDRB <= regist(interruptSP)(11 downto 0);
                    MEM_DINB <= X"00000" & STD_LOGIC_VECTOR(unsigned(ProgCounter));
                when JMPADDR    =>
                    MEM_WEB <= "0";
                    MEM_ADDRB <= "0000000" & std_logic_vector(to_unsigned(interruptNum,5));    
                when JMPFETCH1  =>
                when JMPFETCH2  =>
                when JUMP       =>
                when WAITS      =>
                when others =>
            end case;
        end if;
    end process memoryAccess_proc;



    procCounter_proc : process (SYS_CLK)
    begin
        if rising_edge  (SYS_CLK) then
            case fsm_inst_cycle_p is
                when RESET_STATE=>
                    MEM_ENA <= '1';
                    MEM_WEA <= "0";
                    MEM_ADDRA <= X"000";
                    ProgCounter <= X"000";

                when ADDRESS    =>
                    MEM_ENA <= '1';
                    MEM_WEA <= "0";
                    MEM_ADDRA <= STD_LOGIC_VECTOR(unsigned(ProgCounter));
                when INSTFETCH1 =>
                when INSTFETCH2 => 
                when DECODE     =>
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

                when MEMFETCH1  =>
                when MEMFETCH2  =>
                when EXECUTE    =>
                    case ffmemop is
                        when REGREG     =>
                            case ffopcode is
                                when oJMP | oJSR =>
                                    ProgCounter <= unsigned(ireg2value(11 downto 0)); 
                                when oRTN | oRTI =>
                                    ProgCounter <= unsigned(MEM_DOUTB(11 downto 0));
                                when others =>
                                    ProgCounter <= ProgCounter + 1;
                            end case;
                        when IMMEDIATE  =>
                            case ffopcode is
                                when oJMP | oJSR =>
                                ProgCounter <= unsigned(ffimmop(11 downto 0));
                                when oRTN | oRTI =>
                                    ProgCounter <= unsigned(MEM_DOUTB(11 downto 0));
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
                                when others =>
                                    ProgCounter <= ProgCounter + 1;
                            end case;
                        when ABSOLUTE | INDEX =>
                        case ffopcode is
                            when oJMP | oJSR =>
                                ProgCounter <= unsigned(MEM_DOUTB(11 downto 0));
                            when oRTN | oRTI =>
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
                            when others =>
                                ProgCounter <= ProgCounter + 1;
                        end case;
                    when others     =>
                    end case;
                when CLEANUP    =>
                when SAVEENA    =>
                when DISABLEINT =>
                when JMPADDR    =>
                when JMPFETCH1  =>
                when JMPFETCH2  =>
                when JUMP       =>
                    ProgCounter <= unsigned(MEM_DOUTB(11 downto 0));
                when WAITS      =>
                when others =>
            end case;
        end if;
    end process procCounter_proc;

    alu : process (SYS_CLK)
    begin
        if rising_edge  (SYS_CLK) then
            case fsm_inst_cycle_p is
                when RESET_STATE=>
                    regist <= (others => (others =>'0'));

                when ADDRESS    =>
                when INSTFETCH1 =>
                when INSTFETCH2 => 
                when DECODE     =>

                    -- Maintain Flip-Flop (Memory) protions of the instruction.
                    -- This removes the timing violations and make the processor faster.
                    -- Might remove the combinatorial logic which should not be used after this cycle.
                    ffopcode <= opcode;
                    ffmemop <= memop;
                    ffflag <= flag;
                    ffiregop1 <= iregop1;
                    ffiregop2 <= iregop2;
                    ffimmop <= immop;
                    -- Save the values of the Register Data.  Again this ifor timing operations.
                    ireg1value <= regist(iregop1);
                    ireg2value <= regist(iregop2);


                    case memop is
                        when REGREG =>
                            case opcode is
                                when oRTN =>
                                    regist(iregop1) <= std_logic_vector(to_unsigned(
                                            to_integer(unsigned(regist(iregop1))) + 1,32));
                                when oPUSHPOP =>
                                    if flag = '0' then
                                    else
                                        regist(iregop1) <= std_logic_vector(to_unsigned(
                                                to_integer(unsigned(regist(iregop1))) + 1,32));
                                    end if;
                                when others =>
                            end case;
                        when others =>
                    end case;


                when MEMFETCH1  =>
                    case ffmemop is
                        when REGREG =>
                            case ffopcode is
                                when oRTI =>
                                    regist(interruptSP) <= std_logic_vector(to_unsigned(
                                            to_integer(unsigned(regist(interruptSP))) + 2,32));
                                when others =>
                            end case;
                        when others =>
                    end case;



                when MEMFETCH2  =>
                when EXECUTE    =>

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
                                when oJSR =>
                                    regist(ffiregop1) <= std_logic_vector(to_unsigned(
                                            to_integer(unsigned(ireg1value)) - 1,32));
                                when oRTN =>
                                when oRTI =>
                                when oRWIO =>
                                    if ffflag = '0' then
                                        regist(ffiregop1) <= IOR_DATA;
                                        regist(0) <= x"000000" & IO_STATUS;
                                    else
                                        -- IOW_DATA <= regist(ffiregop1);
                                        regist(0) <= x"000000" & IO_STATUS;
                                    end if;
                                when oPUSHPOP =>
                                    if ffflag = '0' then
                                        regist(ffiregop1) <= std_logic_vector(to_unsigned(
                                                to_integer(unsigned(ireg1value)) - 1,32));
                                    else
                                        regist(iregop2) <= MEM_DOUTB;
                                    end if;
                                when oSWI =>
                                    -- if interruptMask(ffiregop1) = '1' then
                                    --     isInterrupt <= '1';
                                    --     interruptNum <= to_integer(unsigned(ireg1value));
                                    -- end if;
                                when oIENA =>
                                    -- interruptSP <= ffiregop1;
                                    -- interruptMask <= ireg2value;
                                when oWAIT => -- Wait and Timer Cancel
                                    -- if ffflag = '1' then
                                    --     -- Interrupt processing can cancel the wait.
                                    --     if ffiregop1 = waitReg then
                                    --         waitReg <= 0;
                                    --         waitCancel <= '1';
                                    --     elsif ffiregop1 = timerReg then
                                    --         timerReg  <= 0;
                                    --         timerCancel <= '0';
                                    --     end if;
                                    -- end if;
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
                                when oBE =>
                                when oBLT =>
                                when oBGT =>
                                when oJSR =>
                                    regist(ffiregop1) <= std_logic_vector(to_unsigned(
                                            to_integer(unsigned(ireg1value)) - 1,32));
                                when oRWIO =>
                                    if ffflag = '0' then
                                        regist(ffiregop1) <= IOR_DATA;
                                        regist(0) <= x"000000" & IO_STATUS;
                                    else
                                        -- IOW_DATA <= regist(ffiregop1);
                                        regist(0) <= x"000000" & IO_STATUS;
                                    end if;
                                when oPUSHPOP =>
                                    if ffflag = '0' then
                                        regist(ffiregop1) <= std_logic_vector(to_unsigned(
                                                to_integer(unsigned(ireg1value)) - 1,32));
                                    end if;
                                when oSWI =>
                                    -- if interruptMask(to_integer(unsigned(ffimmop(4 downto 0)))) = '1' then
                                    --     isInterrupt <= '1';
                                    --     interruptNum <= to_integer(unsigned(ffimmop(4 downto 0)));
                                    -- end if;
                                when oIENA =>
                                    -- interruptSP <= ffiregop1;
                                    -- interruptMask <= X"0000" & ffimmop;
                                when oWAIT =>
                                    -- if ffflag = '0' then
                                    --     if ffiregop2 = 0 then
                                    --         if waitRun = '0' then
                                    --             waitReg <= ffiregop1;
                                    --             waitTime <= unsigned(regist(ffiregop1));
                                    --             waitResolution <= unsigned(ffimmop);
                                    --             waitStart <= '1';
                                    --             -- fsm_inst_cycle_n <= WAITS;
                                    --         else
                                    --             -- fsm_inst_cycle_n <= ADDRESS;
                                    --         end if;
                                    --     else
                                    --         timerreg <= ffiregop1;
                                    --         timerTime <= unsigned(regist(ffiregop1));
                                    --         timerInt <= unsigned(regist(ffiregop2)(4 downto 0));
                                    --         timerResolution <= unsigned(ffimmop);
                                    --         timerEna <= '1';
                                    --         timerStart <= '1';
                                    --     end if;
                                    -- end if;
                                when others =>
                            end case;
                        when ABSOLUTE  | INDEX =>
                            case ffopcode is
                                when oLD =>
                                    regist(ffiregop1) <= MEM_DOUTB;
                                when oSTR =>
                                    -- MEM_DINB <= ireg1value;
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
                                when oBE =>
                                when oBLT =>
                                when oBGT =>
                                when oRWIO =>
                                    if ffflag = '0' then
                                        -- MEM_DINB <= IOR_DATA;
                                        regist(0) <= x"000000" & IO_STATUS;
                                    else
                                        -- IOW_DATA <= MEM_DOUTB;
                                        regist(0) <= x"000000" & IO_STATUS;
                                    end if;
                                when oSWI =>
                                    -- if interruptMask(to_integer(unsigned(MEM_DOUTB(4 downto 0)))) = '1' then
                                    --     isInterrupt <= '1';
                                    --     interruptNum <= to_integer(unsigned(MEM_DOUTB(4 downto 0)));
                                    -- end if;
                                when oIENA =>
                                    -- interruptSP <= ffiregop1;
                                    -- interruptMask <= MEM_DOUTB;
                                when others =>
                            end case;
                        when others =>
                    end case;


                when CLEANUP    =>
                when SAVEENA    =>
                    if isInterrupt = '1' then
                        -- MEM_WEB <= "1";
                        -- MEM_ADDRB <= regist(interruptSP)(11 downto 0);
                        -- MEM_DINB <= interruptMask;
                        regist(interruptSP) <= std_logic_vector(to_unsigned(
                                to_integer(unsigned(regist(interruptSP))) - 1,32));
                    --      fsm_inst_cycle_n <= DISABLEINT;
                    -- else
                    --     fsm_inst_cycle_n <= ADDRESS;
                    end if;

                when DISABLEINT =>
                when JMPADDR    =>
                    regist(interruptSP) <= std_logic_vector(to_unsigned(
                            to_integer(unsigned(regist(interruptSP))) - 1,32));
                when JMPFETCH1  =>
                when JMPFETCH2  =>
                when JUMP       =>
                when WAITS      =>
                when others =>
            end case;
        end if;
    end process alu;


-- intrCounter_proc : process (SYS_CLK)
-- begin
--     if rising_edge  (SYS_CLK) then
--         case fsm_interrupt_cycle_p is
--             when NO_INTERRUPT =>
--                 interruptCounter <= 0;
--             when JMPADDR_I =>
--                 interruptCounter <= interruptCounter + 1;
--             when others =>
--         end case;
--     end if;
-- end process intrCounter_proc;



    wait_p : process (SYS_CLK, fsm_inst_cycle_p, waitCancel)
    begin
        if rising_edge  (SYS_CLK) then
            if fsm_inst_cycle_p = RESET_STATE 
                or  waitCancel = '1' then
                waitResCounter <= (others => '0');
                waitCount <= (others => '0');
                waitRun <= '0';
            else
                if waitStart = '1' and waitRun = '0' then
                    waitResCounter <= (others => '0');
                    waitCount <= (others => '0');
                    waitRun <= '1';
                elsif waitTime /= 0 then -- Infinite wait when Wait Time = 0
                    -- Wait Counter
                    waitResCounter <= waitResCounter + 1;
                    if waitResCounter >= waitResolution-1 then
                        waitCount <= waitCount + 1;
                        waitResCounter <= (others => '0');
                        if waitCount >= waitTime then
                            waitCount <= (others => '0');
                            waitRun <= '0';
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process wait_p;

    timer_p : process (SYS_CLK, fsm_inst_cycle_p, timerCancel)
    begin
        if rising_edge  (SYS_CLK) then
            if     fsm_inst_cycle_p = RESET_STATE 
                or  timerCancel = '1' then
                timerResCounter <= (others => '0');
                timerCount <= (others => '0');
                timerRun <= '0';
            else
                if      timerStart = '1' 
                    and timerRun = '0' then
                    timerResCounter <= (others => '0');
                    timerCount <= (others => '0');
                    timerRun <= '1';
                elsif timerTime /= 0 then -- Infinite wait when Wait Time = 0
                    timerResCounter <= timerResCounter + 1;
                    if timerResCounter >= timerResolution-1 then
                        timerCount <= timerCount + 1;
                        timerResCounter <= (others => '0');
                        if timerCount >= timerTime then
                            timerCount <= (others => '0');
                            timerRun <= '0';
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process timer_p;


end Behavioral;
