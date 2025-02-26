-- vhdl-linter-disable type-resolved component
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/26/2023 05:47:29 PM
-- Design Name: 
-- Module Name: Computer - Behavioral
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
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;
library xil_defaultlib;
use xil_defaultlib.Utilities.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Computer is
    port (
        rst         : in  STD_LOGIC;
        SYS_CLK     : in  STD_LOGIC;
        led         : out STD_LOGIC_VECTOR (3 downto 0);
        dmode       : in STD_LOGIC;
        dcont       : in STD_LOGIC;
        dstep       : in STD_LOGIC;
        dbreak      : in STD_LOGIC;
        
        uart_txd_out : out STD_LOGIC;
        uart_rxd_in  : in  STD_LOGIC
        --           rgb : out STD_LOGIC_VECTOR (5 downto 0)
    );
end Computer;

architecture Behavioral of Computer is

    component CPU
        port (
            SYS_CLK       : in  STD_LOGIC;
            IO_ADDR       : out STD_LOGIC_VECTOR (7 downto 0);
            IOR_DATA      : in  STD_LOGIC_VECTOR (31 downto 0);
            IOW_DATA      : out STD_LOGIC_VECTOR (31 downto 0);
            IOR_ENA       : out STD_LOGIC;
            IOW_ENA       : out STD_LOGIC;
            IO_STATUS     : in  STD_LOGIC_VECTOR (31 downto 0);
            IO_STATUS_REQ : out STD_LOGIC;
            INTERRUPT     : in  STD_LOGIC_VECTOR (31 downto 0);
            MEM_ENA       : out STD_LOGIC                     := '1';
            MEM_WEA       : out STD_LOGIC_VECTOR(0 downto 0)  := "0";
            MEM_ADDRA     : out STD_LOGIC_VECTOR(11 downto 0) := X"000";
            MEM_DINA      : out STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
            MEM_DOUTA     : in  STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
            MEM_ENB       : out STD_LOGIC                     := '1';
            MEM_WEB       : out STD_LOGIC_VECTOR(0 downto 0)  := "0";
            MEM_ADDRB     : out STD_LOGIC_VECTOR(11 downto 0) := X"000";
            MEM_DINB      : out STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
            MEM_DOUTB     : in  STD_LOGIC_VECTOR(31 downto 0) := X"00000000";

            DEBUGIN     : in DEBUGINTYPE := (
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
                ));
            DEBUGOUT    : out DEBUGOUTTYPE

            );
    end component;

    component cpumemory
        port (
            clka  : in  STD_LOGIC;
            ena   : in  STD_LOGIC;
            wea   : in  STD_LOGIC_VECTOR(0 downto 0);
            addra : in  STD_LOGIC_VECTOR(11 downto 0);
            dina  : in  STD_LOGIC_VECTOR(31 downto 0);
            douta : out STD_LOGIC_VECTOR(31 downto 0);
            clkb  : in  STD_LOGIC;
            enb   : in  STD_LOGIC;
            web   : in  STD_LOGIC_VECTOR(0 downto 0);
            addrb : in  STD_LOGIC_VECTOR(11 downto 0);
            dinb  : in  STD_LOGIC_VECTOR(31 downto 0);
            doutb : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    component UartDevice is
        port (
            CLK       : in  STD_LOGIC;
            RST       : in  STD_LOGIC;
            UART_RXD  : in  STD_LOGIC;
            UART_TXD  : out STD_LOGIC;
            TxByte    : in  STD_LOGIC_VECTOR (7 downto 0);
            TxAvail   : in  STD_LOGIC;
            TxStatus  : out STD_LOGIC_VECTOR (31 downto 0);
            Interrupt : out STD_LOGIC;
            RdByte    : out STD_LOGIC_VECTOR (7 downto 0);
            RdStatus  : out STD_LOGIC_VECTOR (31 downto 0)
        );
    end component;

    component debug is
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
    end component;

    signal ioAddr      : STD_LOGIC_VECTOR (7 downto 0)  := (others => '0');
    signal IORdata     : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal IOWdata     : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal interrupt   : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal IOWena      : STD_LOGIC                      := '0';
    signal IORena      : STD_LOGIC                      := '0';
    signal IOStatus    : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal IOStatusReq : STD_LOGIC                      := '0';

    signal echoIO : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

    -- Memory Information
    signal MEM_CLK   : STD_LOGIC                     := '1';
    signal MEM_ENA   : STD_LOGIC                     := '1';
    signal MEM_WEA   : STD_LOGIC_VECTOR(0 downto 0)  := "0";
    signal MEM_ADDRA : STD_LOGIC_VECTOR(11 downto 0) := X"000";
    signal MEM_DINA  : STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
    signal MEM_DOUTA : STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
    signal MEM_ENB   : STD_LOGIC                     := '1';
    signal MEM_WEB   : STD_LOGIC_VECTOR(0 downto 0)  := "0";
    signal MEM_ADDRB : STD_LOGIC_VECTOR(11 downto 0) := X"000";
    signal MEM_DINB  : STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
    signal MEM_DOUTB : STD_LOGIC_VECTOR(31 downto 0) := X"00000000";

    -- CPU Memory (A)
    signal CPU_MEM_ENA   : STD_LOGIC                     := '1';
    signal CPU_MEM_WEA   : STD_LOGIC_VECTOR(0 downto 0)  := "0";
    signal CPU_MEM_ADDRA : STD_LOGIC_VECTOR(11 downto 0) := X"000";
    signal CPU_MEM_DINA  : STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
    signal CPU_MEM_DOUTA : STD_LOGIC_VECTOR(31 downto 0) := X"00000000";

    -- Debug Memory (A)
    signal DEBUG_MEM_ENA   : STD_LOGIC                     := '1';
    signal DEBUG_MEM_WEA   : STD_LOGIC_VECTOR(0 downto 0)  := "0";
    signal DEBUG_MEM_ADDRA : STD_LOGIC_VECTOR(11 downto 0) := X"000";
    signal DEBUG_MEM_DINA  : STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
    signal DEBUG_MEM_DOUTA : STD_LOGIC_VECTOR(31 downto 0) := X"00000000";

    -- UART Device 
    signal TxByte        : STD_LOGIC_VECTOR (7 downto 0);
    signal TxAvail       : STD_LOGIC;
    signal TxStatus      : STD_LOGIC_VECTOR (31 downto 0);
    signal RdByte        : STD_LOGIC_VECTOR (7 downto 0);
    signal RdStatus      : STD_LOGIC_VECTOR (31 downto 0);
    signal UartInt       : STD_LOGIC;

    signal CpuTxByte        : STD_LOGIC_VECTOR (7 downto 0);
    signal CpuTxAvail       : STD_LOGIC;
    signal CpuTxStatus      : STD_LOGIC_VECTOR (31 downto 0);
    signal CpuRdByte        : STD_LOGIC_VECTOR (7 downto 0);
    signal CpuRdStatus      : STD_LOGIC_VECTOR (31 downto 0);
    signal CpuUartInt       : STD_LOGIC;

    signal DebugTxByte      : STD_LOGIC_VECTOR (7 downto 0);
    signal DebugTxAvail     : STD_LOGIC;
    signal DebugTxStatus    : STD_LOGIC_VECTOR (31 downto 0);
    signal DebugRdByte      : STD_LOGIC_VECTOR (7 downto 0);
    signal DebugUartInt     : STD_LOGIC;
    signal DebugUartInt1    : STD_LOGIC;

    -- Local to eliminate Dual Driver issues
    signal interrupt_L : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

    -- Debug Items
    signal DebugIn      : DEBUGINTYPE := 
        (DebugMode => '0',
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
    -- Debug output
    signal DebugOut     : DEBUGOUTTYPE;
    -- Debug metastability
    signal dmode1       : STD_LOGIC := '0';
    signal dmode2       : STD_LOGIC := '0';
    signal dmode3       : STD_LOGIC := '0';
    signal dcont1       : STD_LOGIC := '0';
    signal dcont2       : STD_LOGIC := '0';
    signal dcont3       : STD_LOGIC := '0';
    signal dbreak1      : STD_LOGIC := '0';
    signal dbreak2      : STD_LOGIC := '0';
    signal dbreak3      : STD_LOGIC := '0';
    signal dstep1       : STD_LOGIC := '0';
    signal dstep2       : STD_LOGIC := '0';
    signal dstep3       : STD_LOGIC := '0';
    signal RdValid      : STD_LOGIC;

    signal dbreakBtn   : STD_LOGIC;
    signal dstepBtn   : STD_LOGIC;
    signal dcontBtn    : STD_LOGIC;

    signal dmemReadCount: integer range 0 to 3;

    attribute keep                          : STRING;
    attribute MARK_DEBUG                    : string;
    attribute keep          of rst          : signal is "TRUE";
    attribute MARK_DEBUG    of rst          : signal is "TRUE";

    -- IO Elements ILA
    -- attribute keep          of ioAddr       : signal is "TRUE";
    -- attribute MARK_DEBUG    of ioAddr       : signal is "TRUE";
    -- attribute keep          of IORdata      : signal is "TRUE";
    -- attribute MARK_DEBUG    of IORdata      : signal is "TRUE";
    -- attribute keep          of IOWdata      : signal is "TRUE";
    -- attribute MARK_DEBUG    of IOWdata      : signal is "TRUE";
    -- attribute keep          of echoIO       : signal is "TRUE";
    -- attribute MARK_DEBUG    of echoIO       : signal is "TRUE";
    -- attribute keep          of IOStatus     : signal is "TRUE";
    -- attribute MARK_DEBUG    of IOStatus     : signal is "TRUE";
    -- attribute keep          of IOStatusReq  : signal is "TRUE";
    -- attribute MARK_DEBUG    of IOStatusReq  : signal is "TRUE";

    -- UARTS ELEMENTS ILA
    -- attribute keep          of uart_rxd_in  : signal is "TRUE";
    -- attribute MARK_DEBUG    of uart_rxd_in  : signal is "TRUE";
    -- attribute keep          of uart_txd_out : signal is "TRUE";
    -- attribute MARK_DEBUG    of uart_txd_out : signal is "TRUE";
    -- attribute keep          of TxByte       : signal is "TRUE";
    -- attribute MARK_DEBUG    of TxByte       : signal is "TRUE";
    -- attribute keep          of TxAvail      : signal is "TRUE";
    -- attribute MARK_DEBUG    of TxAvail      : signal is "TRUE";
    -- attribute keep          of TxStatus     : signal is "TRUE";
    -- attribute MARK_DEBUG    of TxStatus     : signal is "TRUE";
    -- attribute keep          of RdByte       : signal is "TRUE";
    -- attribute MARK_DEBUG    of RdByte       : signal is "TRUE";
    -- attribute keep          of RdStatus     : signal is "TRUE";
    -- attribute MARK_DEBUG    of RdStatus     : signal is "TRUE";

    -- Memory Elements ILA
    -- attribute keep          of MEM_ENA          : signal is "TRUE"; 
    -- attribute MARK_DEBUG    of MEM_ENA          : signal is "TRUE"; 
    -- attribute keep          of MEM_ADDRA        : signal is "TRUE"; 
    -- attribute MARK_DEBUG    of MEM_ADDRA        : signal is "TRUE"; 
    -- attribute keep          of MEM_DOUTA        : signal is "TRUE"; 
    -- attribute MARK_DEBUG    of MEM_DOUTA        : signal is "TRUE"; 
    -- attribute keep          of MEM_ENB          : signal is "TRUE"; 
    -- attribute MARK_DEBUG    of MEM_ENB          : signal is "TRUE"; 
    -- attribute keep          of MEM_WEB          : signal is "TRUE"; 
    -- attribute MARK_DEBUG    of MEM_WEB          : signal is "TRUE"; 
    attribute keep          of MEM_ADDRB        : signal is "TRUE"; 
    attribute MARK_DEBUG    of MEM_ADDRB        : signal is "TRUE"; 
    attribute keep          of MEM_DOUTB        : signal is "TRUE"; 
    attribute MARK_DEBUG    of MEM_DOUTB        : signal is "TRUE"; 

begin

    memory : cpumemory
    port map(
        clka  => MEM_CLK,
        ena   => MEM_ENA,
        wea   => MEM_WEA,
        addra => MEM_ADDRA,
        dina  => MEM_DINA,
        douta => MEM_DOUTA,
        clkb  => MEM_CLK,
        enb   => MEM_ENB,
        web   => MEM_WEB,
        addrb => MEM_ADDRB,
        dinb  => MEM_DINB,
        doutb => MEM_DOUTB
    );

    cpu1 : CPU
    port map(
        SYS_CLK       => SYS_CLK,
        IO_ADDR       => ioAddr,
        IOR_DATA      => IORdata,
        IOW_DATA      => IOWdata,
        IOR_ENA       => IORena,
        IOW_ENA       => IOWena,
        IO_STATUS     => IOStatus,
        IO_STATUS_REQ => IOStatusReq,
        INTERRUPT     => interrupt,
        MEM_ENA   => CPU_MEM_ENA,
        MEM_WEA   => CPU_MEM_WEA,
        MEM_ADDRA => CPU_MEM_ADDRA,
        MEM_DINA  => CPU_MEM_DINA,
        MEM_DOUTA => CPU_MEM_DOUTA,
        MEM_ENB   => MEM_ENB,
        MEM_WEB   => MEM_WEB,
        MEM_ADDRB => MEM_ADDRB,
        MEM_DINB  => MEM_DINB,
        MEM_DOUTB => MEM_DOUTB,

        DEBUGIN     => DebugIn,
        DEBUGOUT    => DebugOut
    );

    uart : UartDevice
    port map(
        CLK       => SYS_CLK,
        RST       => interrupt(0),
        UART_RXD  => uart_rxd_in,
        UART_TXD  => uart_txd_out,
        TxByte    => TxByte,
        TxAvail   => TxAvail,
        TxStatus  => TxStatus,
        Interrupt => UartInt,
        RdByte    => RdByte,
        RdStatus  => RdStatus
    );

    debugger : debug
    port map(
        SYS_CLK   => SYS_CLK,
        RST       => interrupt(0),
        TxByte    => DebugTxByte,
        TxAvail   => DebugTxAvail,
        TxReady   => not DebugTxStatus(0),
        RdByte    => DebugRdByte,
        RdValid   => RdValid,
        MEM_ADDRA => DEBUG_MEM_ADDRA,
        MEM_DOUTA => DEBUG_MEM_DOUTA,
        MEM_DINA => DEBUG_MEM_DINA,
        MEM_ENA => DEBUG_MEM_ENA,
        MEM_WEA => DEBUG_MEM_WEA,

        dmode => dmode,
        dbreakBtn => dbreakBtn,
        dstepBtn => dstepBtn,
        dcontBtn => dcontBtn,
        DebugIn => DebugIn,
        DebugOut => DebugOut
    );

    interrupt <= interrupt_L(31 downto 13)
                 & CpuUartInt
                 & interrupt_L(11 downto 1)
                 & rst;

    MEM_CLK <= SYS_CLK;

    -- Debug/CPU <--> UART MUXes
    TxByte          <= CpuTxByte    when dmode = '0' 
                                    else DebugTxByte;
    TxAvail         <= CpuTxAvail   when dmode = '0' 
                                    else DebugTxAvail;
    CpuTxStatus     <= TxStatus     when dmode = '0'
                                    else (others => '0');
    DebugTxStatus   <= TxStatus     when dmode = '1'
                                    else (others => '0');
    CpuRdByte       <= RdByte       when dmode = '0' 
                                    else (others => '0');
    DebugRdByte     <= RdByte       when dmode = '1'
                                    else (others => '0');
    CpuRdStatus     <= RdStatus     when dmode = '0'
                                    else (others => '0');
    CpuUartInt      <= UartInt      when dmode = '0'
                                   else '0';
    DebugUartInt    <= UartInt     when dmode = '1'
                                   else '0';

    -- Debug/CPU <--> Memory MUXes
    MEM_ENA         <= CPU_MEM_ENA  when DebugOut.Stopped = '0'
                                    else DEBUG_MEM_ENA;
    MEM_WEA         <= CPU_MEM_WEA  when DebugOut.Stopped = '0'
                                    else DEBUG_MEM_WEA;
    MEM_ADDRA       <= CPU_MEM_ADDRA when DebugOut.Stopped = '0'
                                    else DEBUG_MEM_ADDRA;
    MEM_DINA        <= CPU_MEM_DINA when DebugOut.Stopped = '0'
                                    else DEBUG_MEM_DINA;
    CPU_MEM_DOUTA   <= MEM_DOUTA    when DebugOut.Stopped = '0'
                                    else (others => '0');
    DEBUG_MEM_DOUTA <= MEM_DOUTA    when DebugOut.Stopped = '1'
                                    else (others => '0');

    meta_debug_proc : process (SYS_CLK)
    begin

        if rising_edge (SYS_CLK) then
            if RST = '1' then
            else            
                dmode1 <= dmode;
                dmode2 <= dmode1;
                dmode3 <= dmode2;
                -- DebugIn.DebugMode <= dmode3;

                if dmode3 = '1' then
                    dbreak1 <= dbreak;
                    dbreak2 <= dbreak1;
                    dbreak3 <= dbreak2;

                    dcont1 <= dcont;
                    dcont2 <= dcont1;
                    dcont3 <= dcont2;

                    dstep1 <= dstep;
                    dstep2 <= dstep1;
                    dstep3 <= dstep2;

                    if dstep3 = '0' and dstep2 = '1' then 
                        dstepBtn <= '1';
                    elsif dbreak3 = '1' and dbreak2 = '0' then
                        dbreakBtn <= '1';
                    elsif dcont3 = '1' and dcont2 = '0' then
                        dcontBtn <= '1';
                    end if;

                    if dstepBtn = '1' then 
                        dstepBtn <= '0'; 
                    end if;
                    if dbreakBtn = '1' then 
                        dbreakBtn <= '0'; 
                    end if;
                    if dcontBtn = '1' then 
                        dcontBtn <= '0'; 
                    end if;

                    DebugUartInt1 <= DebugUartInt; 
                    if DebugUartInt1 = '1' and DebugUartInt = '0' then -- when interrupt goes high.
                        RdValid <= '1';
                    else
                        RdValid <= '0';
                    end if;

                end if;
            end if;
        end if;
    end process meta_debug_proc;

    Comp : process (SYS_CLK)
    begin

        if rising_edge (SYS_CLK) then
            if rst = '1' or DebugIn.Reset = '1' then
                IORdata                  <= (others => '0');
                interrupt_L(31 downto 1) <= (others => '0');
                IOStatus                 <= (others => '0');
            else
                if ioAddr = X"03" and IOWena = '1'then
                    led <= IOWdata(3 downto 0);
                elsif ioaddr = X"01" and IORena = '1' then
                    IORdata  <= echoIO;
                    IOStatus <= (others => '0');
                elsif ioaddr = X"01" and IOWena = '1' then
                    echoIO   <= IOWdata;
                    IOStatus <= (others => '0');
                elsif ioaddr = X"02" and IOWena = '1' then
                    IOStatus <= X"00000010";
                elsif ioaddr = X"05" and IOWena = '1' then
                    interrupt_L(3) <= IOWdata(0);

                    -- UART Device Interface
                elsif ioaddr = X"0c"
                    and IOWena = '1'
                    and IOStatusReq = '1'
                    then
                    IOStatus <= CpuTxStatus;
                elsif ioaddr = X"0c"
                    and IOWena = '1'
                    and IOStatusReq = '0'
                    then
                    CpuTxByte  <= IOWdata(7 downto 0);
                    CpuTxAvail <= '1';
                elsif ioaddr = X"0c"
                    and IORena = '1'
                    and IOStatusReq = '1'
                    then
                    IOStatus <= CpuRdStatus;
                elsif ioaddr = X"0c"
                    and IORena = '1'
                    and IOStatusReq = '0'
                    then
                    IORdata <= X"000000" & CpuRdByte;
                else
                    CpuTxAvail <= '0';
                    -- IOStatus <= X"00000000";
                end if;
            end if;
        end if;

    end process;


end Behavioral;