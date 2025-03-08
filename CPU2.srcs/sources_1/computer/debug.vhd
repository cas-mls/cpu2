----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/11/2025 07:43:05 PM
-- Design Name: 
-- Module Name: debug - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library xil_defaultlib;
use xil_defaultlib.Utilities.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debug is
    Port ( SYS_CLK : in STD_LOGIC;
           rst : in STD_LOGIC;

            -- UART INTERFACE
            TxByte    : out STD_LOGIC_VECTOR (7 downto 0);
            TxAvail   : out STD_LOGIC;
            TxReady   : in  STD_LOGIC; -- not TxStatus(0)
            RdByte    : in  STD_LOGIC_VECTOR (7 downto 0);
            RdValid   : in  STD_LOGIC; -- not RxStatus(0)
           
           -- Memory Signals
           MEM_ADDRA : out STD_LOGIC_VECTOR(11 downto 0);
           MEM_DOUTA : in STD_LOGIC_VECTOR(31 downto 0);
           MEM_DINA : out STD_LOGIC_VECTOR(31 downto 0);
           MEM_ENA : out STD_LOGIC;
           MEM_WEA : out STD_LOGIC_VECTOR(0 downto 0);
           
           -- Button Signals
           dmode       : in STD_LOGIC;
           dbreakBtn : in STD_LOGIC;
           dstepBtn : in STD_LOGIC;
           dcontBtn : in STD_LOGIC;

           -- Debug Signals
           DebugIn : out DEBUGINTYPE;
           DebugOut : in DEBUGOUTTYPE);
end debug;

architecture Behavioral of debug is

    component UART2WBM is
        Port (
            -- CLOCK AND RESET
            CLK      : in  std_logic;
            RST      : in  std_logic;
            -- UART INTERFACE
            TxByte    : out STD_LOGIC_VECTOR (7 downto 0);
            TxAvail   : out STD_LOGIC;
            TxReady   : in  STD_LOGIC; -- not TxStatus(0)
            RdByte    : in  STD_LOGIC_VECTOR (7 downto 0);
            RdValid   : in  STD_LOGIC; -- not RxStatus(0)
        
    
            -- WISHBONE MASTER INTERFACE
            WB_CYC   : out std_logic;   -- CYC_O The cycle output [CYC_O], when asserted, indicates that a valid bus cycle is in progress.
                                        -- The [CYC_O] signal is asserted during the first data transfer, and remains asserted until the
                                        -- last data transfer.
            WB_STB   : out std_logic;   -- The strobe output [STB_O] indicates a valid data transfer cycle.
                                        -- The SLAVE asserts either the [ACK_I], [ERR_I] or [RTY_I] signals in response to every assertion
                                        -- of the [STB_O] signal.
            WB_WE    : out std_logic;   -- The write enable output [WE_O] indicates whether the current local bus cycle is a READ or WRITE cycle.
                                        -- The signal is negated during READ cycles, and is asserted during WRITE cycles.
            WB_ADDR  : out std_logic_vector(15 downto 0);   -- The address output array [ADR_O()] is used to pass a binary address..
            WB_TGA   : out std_logic_vector(6 downto 0); -- Address tag type [TGA_O()] contains information associated with address lines [ADR_O()], and
            WB_DOUT  : out std_logic_vector(31 downto 0);   -- The data output array [DAT_O()] is used to pass binary data.
            WB_STALL : in  std_logic;   -- The pipeline stall input [STALL_I] indicates that current slave is not able to accept the transfer in the transaction queue.
            WB_ACK   : in  std_logic;   -- The acknowledge input [ACK_I], when asserted, indicates the normal termination of a bus cycle.
            WB_DIN   : in  std_logic_vector(31 downto 0)    -- DAT_I() The data input array [DAT_I()] is used to pass binary data.
        );
    end component;

    
    signal dmemReadCount : integer range 0 to 7 := 0;

    -- Wishbone signals
    signal WB_ADDR : STD_LOGIC_VECTOR(15 downto 0);
    signal WB_WE :  STD_LOGIC;
    signal WB_ACK : STD_LOGIC;
    signal WB_CYC : STD_LOGIC;
    signal WB_STB : STD_LOGIC;
    signal WB_TGA : std_logic_vector(6 downto 0);  
    signal WB_STALL : STD_LOGIC;
    signal WB_DIN : STD_LOGIC_VECTOR(31 downto 0);
    signal WB_DOUT : STD_LOGIC_VECTOR(31 downto 0);

    attribute keep                          : STRING;
    attribute MARK_DEBUG                    : string;
    -- attribute keep          of rst          : signal is "TRUE";
    -- attribute MARK_DEBUG    of rst          : signal is "TRUE";

    -- Wishbone Elements ILA
    attribute keep          of WB_TGA       : signal is "TRUE"; 
    attribute MARK_DEBUG    of WB_TGA       : signal is "TRUE"; 
    attribute keep          of WB_ADDR       : signal is "TRUE"; 
    attribute MARK_DEBUG    of WB_ADDR       : signal is "TRUE"; 
    attribute keep          of WB_WE       : signal is "TRUE"; 
    attribute MARK_DEBUG    of WB_WE       : signal is "TRUE"; 
    attribute keep          of WB_ACK       : signal is "TRUE"; 
    attribute MARK_DEBUG    of WB_ACK       : signal is "TRUE"; 
    attribute keep          of WB_CYC       : signal is "TRUE"; 
    attribute MARK_DEBUG    of WB_CYC       : signal is "TRUE"; 
    attribute keep          of WB_DIN       : signal is "TRUE"; 
    attribute MARK_DEBUG    of WB_DIN       : signal is "TRUE"; 
    attribute keep          of WB_DOUT       : signal is "TRUE"; 
    attribute MARK_DEBUG    of WB_DOUT       : signal is "TRUE"; 

    -- Memory Elements ILA
    -- attribute keep          of MEM_ENA          : signal is "TRUE"; 
    -- attribute MARK_DEBUG    of MEM_ENA          : signal is "TRUE"; 
    -- attribute keep          of MEM_WEA          : signal is "TRUE";
    -- attribute MARK_DEBUG    of MEM_WEA          : signal is "TRUE";
    -- attribute keep          of MEM_ADDRA        : signal is "TRUE"; 
    -- attribute MARK_DEBUG    of MEM_ADDRA        : signal is "TRUE"; 
    -- attribute keep          of MEM_DOUTA        : signal is "TRUE"; 
    -- attribute MARK_DEBUG    of MEM_DOUTA        : signal is "TRUE"; 
    -- attribute keep          of MEM_DINA         : signal is "TRUE";
    -- attribute MARK_DEBUG    of MEM_DINA         : signal is "TRUE";

    -- DEBUG ELEMENTS
    attribute keep          of DebugIn      : signal is "TRUE";
    attribute MARK_DEBUG    of DebugIn      : signal is "TRUE";
    -- attribute keep          of DebugOut     : signal is "TRUE";
    -- attribute MARK_DEBUG    of DebugOut     : signal is "TRUE";
    
    -- attribute keep          of dmemReadCount         : signal is "TRUE";
    -- attribute MARK_DEBUG    of dmemReadCount         : signal is "TRUE";
    -- attribute keep          of dcontBtn    : signal is "TRUE"; 
    -- attribute MARK_DEBUG    of dcontBtn    : signal is "TRUE"; 
    -- attribute keep          of dstepBtn    : signal is "TRUE"; 
    -- attribute MARK_DEBUG    of dstepBtn    : signal is "TRUE"; 
    -- attribute keep          of dbreakBtn   : signal is "TRUE"; 
    -- attribute MARK_DEBUG    of dbreakBtn   : signal is "TRUE"; 
    -- attribute keep          of dmode       : signal is "TRUE";
    -- attribute MARK_DEBUG    of dmode       : signal is "TRUE";

    
begin


    wb   : UART2WBM
    port map (
        CLK       => SYS_CLK,
        RST       => rst,
        TxByte    => TxByte,
        TxAvail   => TxAvail,
        TxReady   => TxReady,
        RdByte    => RdByte,
        RdValid   => RdValid,
        WB_CYC    => WB_CYC  ,
        WB_STB    => WB_STB  ,
        WB_WE     => WB_WE   ,
        WB_ADDR   => WB_ADDR ,
        WB_TGA    => WB_TGA  ,
        WB_DOUT   => WB_DOUT ,
        WB_STALL  => WB_STALL,
        WB_ACK    => WB_ACK  ,
        WB_DIN    => WB_DIN  
    );


    debug : process (SYS_CLK)
    begin
        if rising_edge (SYS_CLK) then
            if rst = '1' or DebugOut.Reset = '1' then
                WB_ACK <= '0';
                WB_STALL <= '0';
                DebugIn <= (
                    DebugMode => '0',
                    BreakPoints => (others => (others => '0')),
                    Break => '0',
                    Step => '0',
                    Continue => '0',
                    BWhenReg => 0,
                    BWhenValue => (others => '0'),
                    BWhenOp => REG_NOTHING,
                    Reset => '0',
                    UpdateValue => (
                        Number => 0,
                        Value => (others => '0'),
                        Valid => '0'
                    ),
                    UpdateReg => (
                        Number => 0,
                        Value => (others => '0'),
                        Valid => '0'
                    )
                );
                dmemReadCount <= 0;
                MEM_ADDRA <= (others => '0');
                MEM_ENA <= '0';
                MEM_WEA(0) <= '0';
                MEM_DINA <= (others => '0');
            else
                DebugIn.DebugMode <= dmode;
                if dstepBtn = '1' then
                    DebugIn.Step <= '1';
                elsif dbreakBtn = '1' then
                    DebugIn.Break <= '1';
                elsif dcontBtn = '1' then
                    DebugIn.Continue <= '1';
                end if;

                if DebugIn.Break = '1' then
                    DebugIn.Break <= '0';
                elsif DebugIn.Continue = '1' then
                    DebugIn.Continue <= '0';
                elsif DebugIn.Step = '1' then
                    DebugIn.Step <= '0';
                end if;

                if WB_CYC = '1' then
                    case WB_TGA is
                        when TGA_STATUS =>
                            if WB_WE = '0' then -- STATUS COMMAND
                                case DEBUG_DATA'VAL(to_integer(unsigned(WB_ADDR))) is
                                    when DBG_STATE =>              -- VALUE 0
                                        WB_DIN <= X"0000000" & B"000" & DebugOut.Stopped;
                                    when DBG_PROG_COUNTER =>        -- VALUE 1
                                        WB_DIN <= X"00000" & STD_LOGIC_VECTOR(Debugout.ProgCounter);
                                    when DBG_INSTRUCTION =>         -- VALUE 2
                                        WB_DIN <= Debugout.Instruction;
                                    when DBG_CYCLES =>              -- VALUE 3
                                        WB_DIN <= STD_LOGIC_VECTOR(Debugout.CycleCount(31 downto 0));
                                    when DBG_INTERRUPT =>           -- VALUE 4
                                        WB_DIN <= DebugOut.Interrupt;
                                    when DGB_INTERRUPT_MASK =>      -- VALUE 5
                                        WB_DIN <= DebugOut.InterruptMask;
                                    when DBG_STATUS =>              -- VALUE 6
                                        WB_DIN <= DebugOut.Status;
                                    when DBG_STATUS_MASK =>         -- VALUE 7
                                        WB_DIN <= DebugOut.StatusMask;
                                    when DBG_MEMORY_ARG =>          -- VALUE 8
                                        WB_DIN <= DebugOut.MEMORY_ARG;
                                    when others =>
                                end case;
                            else
                                case DEBUG_DATA'VAL(to_integer(unsigned(WB_ADDR))) is
                                    when DBG_PROG_COUNTER  -- Only valid for updates
                                            | DBG_INTERRUPT 
                                            | DGB_INTERRUPT_MASK 
                                            | DBG_STATUS 
                                            | DBG_STATUS_MASK 
                                            =>
                                        DebugIn.UpdateValue.Number <= to_integer(unsigned(WB_ADDR(3 downto 0)));
                                        DebugIn.UpdateValue.Value <= WB_DOUT;
                                        DebugIn.UpdateValue.Valid <= '1';
                                    when others =>
                                end case;
                            end if;
                            WB_ACK <= '1';
                            
                        when TGA_STEP =>
                            if WB_WE = '1' then -- STEP COMMAND
                                DebugIn.Step <= '1';
                            end if;
                            WB_ACK <= '1';

                        when TGA_CONTINUE =>
                            if WB_WE = '1' then -- CONTINUE COMMAND
                                DebugIn.Continue <= '1';
                            end if;
                            WB_ACK <= '1';

                        when TGA_BREAK =>
                            if WB_WE = '1' then -- BREAK COMMAND
                               DebugIn.Break <= '1';
                            end if;
                            WB_ACK <= '1';

                        when TGA_BREAKAT =>
                            if WB_WE = '1' then -- BREAK COMMAND
                                DebugIn.BreakPoints(to_integer(unsigned(WB_ADDR(3 downto 0))))
                                    <= unsigned(WB_DOUT(11 downto 0));
                            end if;
                            WB_ACK <= '1';

                        when TGA_BREAKWHEN =>
                            if WB_WE = '1' then -- BREAK COMMAND
                                DebugIn.BWhenReg <= to_integer(unsigned(WB_ADDR(3 downto 0)));
                                DebugIn.BWhenOp <= REG_COMPARE'VAL(to_integer(unsigned(WB_ADDR(7 downto 5))));
                                DebugIn.BWhenValue <= WB_DOUT(31 downto 0);
                            end if;
                            WB_ACK <= '1';

                        when TGA_RESET =>
                            if WB_WE = '1' then
                                DebugIn.Reset <= '1';
                            else
                                DebugIn.Reset <= '0';
                            end if;
                            WB_ACK <= '1';

                        when TGA_REGISTERS => -- REGISTER COMMAND
                            if WB_WE = '0' then
                                WB_DIN <= Debugout.Regs(to_integer(unsigned(WB_ADDR(3 downto 0))));
                            else
                                DebugIn.UpdateReg.Number <= to_integer(unsigned(WB_ADDR(3 downto 0)));
                                DebugIn.UpdateReg.Value <= WB_DOUT;
                                DebugIn.UpdateReg.Valid <= '1';
                            end if;
                            WB_ACK <= '1';

                        when TGA_MEMORY => -- MEMORY COMMAND
                            if WB_WE = '0' then
                                if dmemReadCount < 3 then
                                    MEM_ADDRA <= WB_ADDR(11 downto 0);
                                    MEM_ENA <= '1';
                                    MEM_WEA(0) <= '0';
                                    dmemReadCount <= dmemReadCount + 1;
                                else
                                    MEM_ENA <= '0';
                                    WB_DIN <= MEM_DOUTA;
                                    WB_ACK <= '1';
                                    dmemReadCount <= 0;
                                end if;
                            else
                                if dmemReadCount < 1 then
                                    MEM_ADDRA <= WB_ADDR(11 downto 0);
                                    MEM_ENA <= '1';
                                    MEM_WEA(0) <= '1';
                                    MEM_DINA <= WB_DOUT;
                                    dmemReadCount <= dmemReadCount + 1;
                                else
                                    MEM_ENA <= '0';
                                    MEM_WEA(0) <= '0';
                                    WB_ACK <= '1';
                                    dmemReadCount <= 0;
                                end if;
                            end if;
                        when others =>
                    end case;

                else
                    WB_ACK <= '0';
                    dmemReadCount <= 0;
                    DebugIn.UpdateReg.Valid <= '0';
                    DebugIn.UpdateValue.Valid <= '0';
                end if;
            end if;
        end if;
    end process;

end Behavioral;
