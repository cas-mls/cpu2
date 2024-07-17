-- vhdl-linter-disable type-resolved
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

    component ALU is
        Port (
            SYS_CLK               : IN STD_LOGIC;
            INSTRUCTION           : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            MEM_ARG               : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            fsm_inst_cycle_p      : IN CYCLETYPE_FSM;
            fsm_interrupt_cycle_p : IN INTERRUPT_FSM;
            interruptSpNum        : IN integer range 0 to 31;
            IOR_DATA              : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            IO_STATUS             : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            ireg1value            : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            ireg2value            : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            interruptSpAddrValue  : IN integer range 0 to 2**12-1; 
            cpuRegs               : OUT reg_type
          );
      
      end component;

      component MemoryAccess is
        Port ( 
            SYS_CLK               : IN STD_LOGIC;
            INSTRUCTION           : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            cpuRegs               : IN reg_type;
    
            fsm_inst_cycle_p      : IN CYCLETYPE_FSM;
            fsm_interrupt_cycle_p : IN INTERRUPT_FSM;
            interruptSPNum        : IN integer range 0 to 31;
            IOR_DATA              : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            IO_STATUS             : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            interruptSpAddrValue  : IN integer range 0 to 2**12-1; 
            interruptRun          : IN STD_LOGIC;
            interruptNum          : IN integer range 0 to interruptNums := 0;
            ProgramCounter        : IN unsigned(11 downto 0);
            interruptMask         : IN STD_LOGIC_VECTOR(interruptNums DOWNTO 0);
      
            MEM_ENB               : OUT STD_LOGIC := '1';
            MEM_WEB               : OUT STD_LOGIC_VECTOR(0 DOWNTO 0) := "0";
            MEM_ADDRB             : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
            MEM_DINB              : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    end component;
    
    component ProgCounter is
        Port ( 
            SYS_CLK               : IN STD_LOGIC;
            INSTRUCTION           : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            cpuRegs               : IN reg_type;
    
            fsm_inst_cycle_p      : IN CYCLETYPE_FSM;
            fsm_interrupt_cycle_p : IN INTERRUPT_FSM;
            MEM_ARG               : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        
            MEM_ENA               : OUT STD_LOGIC := '1';
            MEM_WEA               : OUT STD_LOGIC_VECTOR(0 DOWNTO 0) := "0";
            MEM_ADDRA             : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
            ProgramCounter        : OUT unsigned(11 downto 0)
        );
    end component ProgCounter;
    
    component IoProcess is
        Port ( 
          SYS_CLK : IN STD_LOGIC;
          INSTRUCTION           : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
          cpuRegs               : IN reg_type;
          MEM_ARG               : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
          fsm_inst_cycle_p      : IN CYCLETYPE_FSM;
      
          IOW_ENA               : OUT STD_LOGIC;
          IOR_ENA               : OUT STD_LOGIC;
          IO_ADDR               : OUT STD_LOGIC_VECTOR (7 downto 0);
          IOW_DATA              : OUT STD_LOGIC_VECTOR (31 downto 0)
      
        );
      end component IoProcess;
      
      component WaitTimer is
        Port ( 
          SYS_CLK               : IN STD_LOGIC;
          INSTRUCTION           : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
          cpuRegs               : IN reg_type;
          fsm_inst_cycle_p      : IN CYCLETYPE_FSM;
      
          waitAlarm               : OUT STD_LOGIC;
          waitRun                 : OUT STD_LOGIC;
          waitCancel              : OUT STD_LOGIC;
          timerAlarm              : OUT STD_LOGIC;
          timerInt                : OUT unsigned (4 downto 0)
      
        );
    end component WaitTimer;

    component Interrupt_Entity is
        port (
            SYS_CLK : in std_logic;
            INSTRUCTION : in std_logic_vector(31 downto 0);
            cpuRegs : in reg_type;
            fsm_inst_cycle_p : in CYCLETYPE_FSM;
            MEM_ARG               : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            INTERRUPT   : in STD_LOGIC_VECTOR (31 downto 0);
            timerAlarm : in std_logic;
            timerInt : in unsigned (4 downto 0);
    
            fsm_interrupt_cycle_p   : out INTERRUPT_FSM;
            interruptRun            : out STD_LOGIC := '0';
            interruptNum            : out integer range 0 to interruptNums := 0;
            interruptMask           : out STD_LOGIC_VECTOR(interruptNums DOWNTO 0) := X"00000000";
            interruptSpNum          : out integer range 0 to interruptNums;
            interruptSpAddrValue    : out integer range 0 to 2**12-1
                );
    end component Interrupt_Entity;
    


    signal METRICS     :  METRICSTYPE;

    signal ProgramCounter : unsigned(11 downto 0) := X"000";
    signal fsm_inst_cycle_p : CYCLETYPE_FSM := RESET_STATE_S;
    signal fsm_inst_cycle_n : CYCLETYPE_FSM := RESET_STATE_S;

    -- Decode information    
    signal opcode : OPCODETYPE := "00000";
    signal ffopcode : OPCODETYPE := "00000";
    signal flag : STD_LOGIC :='0';
    signal ffflag : STD_LOGIC :='0';
    signal memop :  MEMTYPE;
    signal ffmemop : MEMTYPE;
    signal regop1 : REGTYPE;
    signal iregop1 : integer range 0 to regOpMax;
    signal ffiregop1 : integer range 0 to regOpMax;
    signal ireg1value : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
    signal regop2 : REGTYPE;
    signal iregop2 : integer range 0 to regOpMax;
    signal ffiregop2 : integer range 0 to regOpMax;
    signal ireg2value : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
    signal immop : IMMTYPE;
    signal ffimmop: IMMTYPE;
    
    -- Register information
    signal cpuRegs : reg_type := (others => (others => '0'));

    -- interrupts
    signal fsm_interrupt_cycle_p : INTERRUPT_FSM := INTRWAIT_S;
    signal interruptRun : STD_LOGIC := '0';
    signal interruptNum : integer range 0 to interruptNums := 0;
    signal interruptMask : STD_LOGIC_VECTOR(interruptNums DOWNTO 0) := X"00000000";
    signal interruptSpNum : integer range 0 to interruptNums;
    signal interruptSpAddrValue : integer range 0 to 2**MEM_ADDRB'length-1;
    
    -- metrics
    signal cycleCount : unsigned (63 downto 0) := (others => '0');

    signal waitRun : std_logic := '0';
    signal waitAlarm : std_logic := '0';
    signal waitCancel : std_logic := '0';

    signal timerAlarm : std_logic := '0';
    signal timerInt : unsigned (4 downto 0) := "00000";
    
    -- Help with ILA debugging by flattening the Wires.
    attribute keep : string;
    attribute MARK_DEBUG : string;
    attribute keep of cpuRegs : signal is "TRUE";
    attribute keep of fsm_inst_cycle_p : signal is "TRUE";
    attribute MARK_DEBUG of cpuRegs : signal is "TRUE";
    attribute MARK_DEBUG of fsm_inst_cycle_p : signal is "TRUE";

    

begin

    opcode  <= MEM_DOUTA(31 downto 27);
    flag    <= MEM_DOUTA(26);
    memop   <= MEM_DOUTA(25 downto 24); 
    regop1  <= MEM_DOUTA(23 downto 20);
    regop2  <= MEM_DOUTA(19 downto 16);
    immop   <= MEM_DOUTA(15 downto 0);
    iregop1 <= to_integer(unsigned(regop1));
    iregop2 <= to_integer(unsigned(regop2));

    alu_entity : alu
    PORT MAP (
        SYS_CLK               => SYS_CLK,
        INSTRUCTION           => MEM_DOUTA,
        MEM_ARG               => MEM_DOUTB,
        fsm_inst_cycle_p      => fsm_inst_cycle_p,
        fsm_interrupt_cycle_p => fsm_interrupt_cycle_p,
        interruptSpNum        => interruptSpNum,
        IOR_DATA              => IOR_DATA,
        IO_STATUS             => IO_STATUS,
        ireg1value            => ireg1value,
        ireg2value            => ireg2value,
        interruptSpAddrValue  => interruptSpAddrValue,
        cpuRegs               => cpuRegs
    );

    memoryAccess_enity : MemoryAccess
    PORT MAP ( 
        SYS_CLK               => SYS_CLK,
        INSTRUCTION           => MEM_DOUTA,
        cpuRegs               => cpuRegs,

        fsm_inst_cycle_p      => fsm_inst_cycle_p,
        fsm_interrupt_cycle_p => fsm_interrupt_cycle_p,
        interruptSPNum        => interruptSPNum,
        IOR_DATA              => IOR_DATA,
        IO_STATUS             => IO_STATUS,
        interruptSpAddrValue  => interruptSpAddrValue,
        interruptRun          => interruptRun,
        interruptNum          => interruptNum,
        ProgramCounter        => ProgramCounter,
        interruptMask         => interruptMask,

        MEM_ENB               => MEM_ENB,
        MEM_WEB               => MEM_WEB,
        MEM_ADDRB             => MEM_ADDRB,
        MEM_DINB              => MEM_DINB
    );


    progCounter_enty: ProgCounter
        PORT MAP ( 
            SYS_CLK               => SYS_CLK,
            INSTRUCTION           => MEM_DOUTA,
            cpuRegs               => cpuRegs,

            fsm_inst_cycle_p      => fsm_inst_cycle_p,
            fsm_interrupt_cycle_p => fsm_interrupt_cycle_p,
            MEM_ARG               => MEM_DOUTB,

            MEM_ENA               => MEM_ENA,
            MEM_WEA               => MEM_WEA,
            MEM_ADDRA             => MEM_ADDRA,
            ProgramCounter        => ProgramCounter
        );

    IoProcess_enty: IoProcess
        PORT MAP ( 
            SYS_CLK               => SYS_CLK,
            INSTRUCTION           => MEM_DOUTA,
            cpuRegs               => cpuRegs,
            MEM_ARG               => MEM_DOUTB,

            fsm_inst_cycle_p      => fsm_inst_cycle_p,

            IOW_ENA               => IOW_ENA,
            IOR_ENA               => IOR_ENA,
            IO_ADDR               => IO_ADDR,
            IOW_DATA              => IOW_DATA
        );

    WaitTimer_enty: WaitTimer
        PORT MAP ( 
            SYS_CLK               => SYS_CLK,
            INSTRUCTION           => MEM_DOUTA,
            cpuRegs               => cpuRegs,

            fsm_inst_cycle_p      => fsm_inst_cycle_p,

            waitAlarm             => waitAlarm,
            waitRun               => waitRun,
            waitCancel            => waitCancel,
            timerAlarm            => timerAlarm,
            timerInt                => timerInt
            );

    Interrupt_enty: Interrupt_Entity
        PORT MAP ( 
            SYS_CLK                 => SYS_CLK,
            INSTRUCTION             => MEM_DOUTA,
            cpuRegs                 => cpuRegs,
            fsm_inst_cycle_p        => fsm_inst_cycle_p,
            MEM_ARG                 => MEM_DOUTB,
            INTERRUPT               => INTERRUPT,
            timerAlarm              =>timerAlarm,
            timerInt                => timerInt,

            fsm_interrupt_cycle_p   => fsm_interrupt_cycle_p,
            interruptRun            => interruptRun,
            interruptNum            => interruptNum,
            interruptMask           => interruptMask,
            interruptSpNum          => interruptSpNum,
            interruptSpAddrValue    => interruptSpAddrValue
        );
    


    instruction_fsm_Proc : process (SYS_CLK)
    begin
        if rising_edge  (SYS_CLK) then
            if (INTERRUPT = RESET) then
                cycleCount <= (others => '0');
                METRICS.cycleCount <= (others => '0');
                fsm_inst_cycle_p <= RESET_STATE_S;
            else
                cycleCount <= cycleCount + 1;
                METRICS.cycleCount <= cycleCount;
                if interruptRun = '1' then
                    fsm_inst_cycle_p <= ADDRESS_S;
                else
                    fsm_inst_cycle_p <= fsm_inst_cycle_n;
                end if;
            end if;
        end if;
    end process;


    instruction_Proc: process (
        fsm_inst_cycle_p, 
        opcode,
        ffopcode,
        ffflag,
        flag,
        memop, 
        waitAlarm,
        waitCancel,
        interruptRun,
        fsm_interrupt_cycle_p
        )
    begin
    
        case fsm_inst_cycle_p is
            -- CPU RESET
            when RESET_STATE_S =>
                fsm_inst_cycle_n <= ADDRESS_S;

            ----------------------------------------------------------------
            -- This sets up the instruction address to read.
            when ADDRESS_S =>
                fsm_inst_cycle_n <= INSTFETCH1_S;

            ----------------------------------------------------------------
            -- This is the Cycle to wait for the Fetch Instruction Memory
            when INSTFETCH1_S =>
                fsm_inst_cycle_n <= INSTFETCH2_S;

            ----------------------------------------------------------------
            -- This is the second Cycle for the Fetch Instruction Memory
            when INSTFETCH2_S =>
                fsm_inst_cycle_n <= DECODE_S;

            ----------------------------------------------------------------
            -- Decoding is completed in the combinatorial logic and should only be used in this cycle.
            --       (opcode, memop, flag, iregop1, iregop2, and immop)
            -- Set up memory address for ABSOLUTE and INDEX
            when DECODE_S =>

                case memop is
                    when REGREG =>
                        case opcode is
                            when oJSR =>
                                fsm_inst_cycle_n <= EXECUTE_S;
                            when oRTN | oRTI =>
                                fsm_inst_cycle_n <= MEMFETCH1_S;
                            when oRWIO =>
                                fsm_inst_cycle_n <= MEMFETCH2_S;
                            when oPUSHPOP =>
                                if flag = '0' then
                                    fsm_inst_cycle_n <= EXECUTE_S;
                                else
                                    fsm_inst_cycle_n <= MEMFETCH1_S;
                                end if;
                            when others =>
                                fsm_inst_cycle_n <= EXECUTE_S;
                        end case;
                    when IMMEDIATE =>
                        case opcode is
                            when oJSR =>
                                fsm_inst_cycle_n <= EXECUTE_S;
                            when oRWIO =>
                                fsm_inst_cycle_n <= MEMFETCH2_S;
                            when oPUSHPOP =>
                                if flag = '0' then
                                    fsm_inst_cycle_n <= EXECUTE_S;
                                end if;
                            when others =>
                                fsm_inst_cycle_n <= EXECUTE_S;
                        end case;
                    when ABSOLUTE =>
                        case opcode is
                            when oLD | oSTR | oADD | oSUB | oAND | oOr | oXor | oShl | oShr | oJMP | oBE | oBLT | oBGT | oSWI | oIENA | oRWIO =>
                                fsm_inst_cycle_n <= MEMFETCH1_S;
                            when others =>
                                fsm_inst_cycle_n <= EXECUTE_S;
                        end case;
                    when INDEX =>
                        case opcode is
                            when oLD | oSTR | oADD | oSUB | oAND | oOr | oXor | oShl | oShr | oJMP | oRWIO =>
                                fsm_inst_cycle_n <= MEMFETCH1_S;
                            when others =>
                                fsm_inst_cycle_n <= EXECUTE_S;
                        end case;
                    when others =>
                        fsm_inst_cycle_n <= EXECUTE_S;
                    end case;


            ----------------------------------------------------------------
            -- Cycle to wait for memory to be read.
            -- ABSOLUTE and INDEX operations.
            when MEMFETCH1_S =>
                fsm_inst_cycle_n <= MEMFETCH2_S;

            ----------------------------------------------------------------
            -- Second Cycle to wait for memory to be read.
            -- ABSOLUTE and INDEX operations.
            when MEMFETCH2_S =>
                fsm_inst_cycle_n <= EXECUTE_S;
                
            ----------------------------------------------------------------
            -- Execute intruction
            when EXECUTE_S =>

                -- Find the next cycle state....
                if ffopcode = oRWIO 
                    or ffopcode = oRTI
                then -- Need additional step.
                    fsm_inst_cycle_n <= CLEANUP_S;

                elsif ffopcode = oWAIT then
                    if ffflag =  '0' -- Wait, Not Cancel
                    then
                        if ffiregop2 = 0  -- Wait, Not Timer
                        then -- Specific requirement for only WAIT
                            fsm_inst_cycle_n <= WAITS_S;
                        else
                            fsm_inst_cycle_n <= ADDRESS_S;
                        end if;
                    else
                        fsm_inst_cycle_n <= ADDRESS_S;
                    end if;
                elsif ffopcode /= oJMP 
                    and ffopcode /= oBE 
                    and ffopcode /= oBLT 
                    and ffopcode /= oBGT 
                    and ffopcode /= oJSR 
                    and ffopcode /= oRTN 
                    and ffopcode /= oRTI 
                    and ffopcode /= oSWI
                then
                    if ffmemop = ABSOLUTE or ffmemop = INDEX then
                        fsm_inst_cycle_n <= DECODE_S;
                    else
                        fsm_inst_cycle_n <= INSTFETCH2_S;
                    end if;
                else 
                    fsm_inst_cycle_n <= ADDRESS_S;
                end if;
                
            when WAITS_S =>
                if waitAlarm = '1' 
                    or waitCancel= '1'
                then
                    fsm_inst_cycle_n <= ADDRESS_S;
                else
                    fsm_inst_cycle_n <= WAITS_S;
                end if;
            ----------------------------------------------------------------
            -- Update the program counter.
            -- All of these could be included in the Execute cycle and
            -- this state could be eliminated.
            when CLEANUP_S =>
                if opcode = oRTI and waitRun = '1' then
                    fsm_inst_cycle_n <= WAITS_S;
                else
                    fsm_inst_cycle_n <= ADDRESS_S;
                end if;
            when others =>
                fsm_inst_cycle_n <= ADDRESS_S;
        end case;
    end process;

    decode_Proc : process (SYS_CLK)
    begin
        if rising_edge  (SYS_CLK) then
            if fsm_inst_cycle_p = DECODE_S
            then
                -- Maintain Flip-Flop (Memory) portions of the instruction.
                -- This removes the timing violations and make the processor faster.
                -- Might remove the combinatorial logic which should not be used after this cycle.
                ffopcode <= opcode;
                ffmemop <= memop;
                ffflag <= flag;
                ffiregop1 <= iregop1;
                ffiregop2 <= iregop2;
                ffimmop <= immop;
                -- Save the values of the Register Data.  Again this ifor timing operations.
                ireg1value <= cpuRegs(iregop1);
                ireg2value <= cpuRegs(iregop2);
            end if;
        end if;

    end process decode_Proc;




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


end Behavioral;
