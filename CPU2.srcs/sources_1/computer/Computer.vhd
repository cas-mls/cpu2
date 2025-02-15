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
                Reset => '0');
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

    -- component UART2WBM is
    --     Port (
    --         -- CLOCK AND RESET
    --         CLK      : in  std_logic;
    --         RST      : in  std_logic;
    --         -- UART INTERFACE
    --         -- UART_TXD : out std_logic;
    --         -- UART_RXD : in  std_logic;
    --         TxByte    : out STD_LOGIC_VECTOR (7 downto 0);
    --         TxAvail   : out STD_LOGIC;
    --         TxReady   : in  STD_LOGIC; -- not TxStatus(0)
    --         RdByte    : in  STD_LOGIC_VECTOR (7 downto 0);
    --         RdValid   : in  STD_LOGIC; -- not RxStatus(0)
        
    
    --         -- WISHBONE MASTER INTERFACE
    --         WB_CYC   : out std_logic;   -- CYC_O The cycle output [CYC_O], when asserted, indicates that a valid bus cycle is in progress.
    --                                     -- The [CYC_O] signal is asserted during the first data transfer, and remains asserted until the
    --                                     -- last data transfer.
    --         WB_STB   : out std_logic;   -- The strobe output [STB_O] indicates a valid data transfer cycle.
    --                                     -- The SLAVE asserts either the [ACK_I], [ERR_I] or [RTY_I] signals in response to every assertion
    --                                     -- of the [STB_O] signal.
    --         WB_WE    : out std_logic;   -- The write enable output [WE_O] indicates whether the current local bus cycle is a READ or WRITE cycle.
    --                                     -- The signal is negated during READ cycles, and is asserted during WRITE cycles.
    --         WB_ADDR  : out std_logic_vector(15 downto 0);   -- The address output array [ADR_O()] is used to pass a binary address..
    --         WB_TGA   : out std_logic_vector(6 downto 0); -- Address tag type [TGA_O()] contains information associated with address lines [ADR_O()], and
    --         WB_DOUT  : out std_logic_vector(31 downto 0);   -- The data output array [DAT_O()] is used to pass binary data.
    --         WB_STALL : in  std_logic;   -- The pipeline stall input [STALL_I] indicates that current slave is not able to accept the transfer in the transaction queue.
    --         WB_ACK   : in  std_logic;   -- The acknowledge input [ACK_I], when asserted, indicates the normal termination of a bus cycle.
    --         WB_DIN   : in  std_logic_vector(31 downto 0)    -- DAT_I() The data input array [DAT_I()] is used to pass binary data.
    --     );
    -- end component;
    

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

    -- -- Wishbone Protocol
    -- signal WB_CYC   : std_logic;   -- CYC_O The cycle output [CYC_O], when asserted, indicates that a valid bus cycle is in progress.
    -- -- The [CYC_O] signal is asserted during the first data transfer, and remains asserted until the
    -- -- last data transfer.
    -- signal WB_STB   : std_logic;   -- The strobe output [STB_O] indicates a valid data transfer cycle.
    --     -- The SLAVE asserts either the [ACK_I], [ERR_I] or [RTY_I] signals in response to every assertion
    --     -- of the [STB_O] signal.
    -- signal WB_WE    : std_logic;   -- The write enable output [WE_O] indicates whether the current local bus cycle is a READ or WRITE cycle.
    --     -- The signal is negated during READ cycles, and is asserted during WRITE cycles.
    -- signal WB_ADDR  : std_logic_vector(15 downto 0);   -- The address output array [ADR_O()] is used to pass a binary address..
    -- signal WB_TGA   : std_logic_vector(6 downto 0);     -- Address tag type [TGA_O()] contains information associated with address lines [ADR_O()]
    -- signal WB_DOUT  : std_logic_vector(31 downto 0);   -- The data output array [DAT_O()] is used to pass binary data.
    -- signal WB_STALL : std_logic;   -- The pipeline stall input [STALL_I] indicates that current slave is not able to accept the transfer in the transaction queue.
    -- signal WB_ACK   : std_logic;   -- The acknowledge input [ACK_I], when asserted, indicates the normal termination of a bus cycle.
    -- signal WB_DIN   : std_logic_vector(31 downto 0);   -- DAT_I() The data input array [DAT_I()] is used to pass binary data.

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
        Reset => '0');
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

    -- attribute keep                          : STRING;
    -- attribute MARK_DEBUG                    : string;
    -- attribute keep          of rst          : signal is "TRUE";
    -- attribute MARK_DEBUG    of rst          : signal is "TRUE";

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

    -- DEBUG ELEMENTS
    -- attribute keep          of DebugIn      : signal is "TRUE";
    -- attribute MARK_DEBUG    of DebugIn      : signal is "TRUE";
    -- attribute keep          of DebugOut     : signal is "TRUE";
    -- attribute MARK_DEBUG    of DebugOut     : signal is "TRUE";
    -- attribute keep          of dcontUart    : signal is "TRUE"; 
    -- attribute MARK_DEBUG    of dcontUart    : signal is "TRUE"; 
    -- attribute keep          of dstepUart    : signal is "TRUE"; 
    -- attribute MARK_DEBUG    of dstepUart    : signal is "TRUE"; 
    -- attribute keep          of dbreakUart   : signal is "TRUE"; 
    -- attribute MARK_DEBUG    of dbreakUart   : signal is "TRUE"; 
    -- attribute keep          of DebugTxByte  : signal is "TRUE"; 
    -- attribute MARK_DEBUG    of DebugTxByte  : signal is "TRUE"; 

    -- Wishbone Elements ILA
    -- attribute keep          of WB_TGA       : signal is "TRUE"; 
    -- attribute MARK_DEBUG    of WB_TGA       : signal is "TRUE"; 
    -- attribute keep          of WB_ADDR       : signal is "TRUE"; 
    -- attribute MARK_DEBUG    of WB_ADDR       : signal is "TRUE"; 
    -- attribute keep          of WB_WE       : signal is "TRUE"; 
    -- attribute MARK_DEBUG    of WB_WE       : signal is "TRUE"; 
    -- attribute keep          of WB_ACK       : signal is "TRUE"; 
    -- attribute MARK_DEBUG    of WB_ACK       : signal is "TRUE"; 
    -- attribute keep          of WB_CYC       : signal is "TRUE"; 
    -- attribute MARK_DEBUG    of WB_CYC       : signal is "TRUE"; 
    -- attribute keep          of WB_DIN       : signal is "TRUE"; 
    -- attribute MARK_DEBUG    of WB_DIN       : signal is "TRUE"; 
    -- attribute keep          of WB_DOUT       : signal is "TRUE"; 
    -- attribute MARK_DEBUG    of WB_DOUT       : signal is "TRUE"; 

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
    -- attribute keep          of MEM_ADDRB        : signal is "TRUE"; 
    -- attribute MARK_DEBUG    of MEM_ADDRB        : signal is "TRUE"; 
    -- attribute keep          of MEM_DOUTB        : signal is "TRUE"; 
    -- attribute MARK_DEBUG    of MEM_DOUTB        : signal is "TRUE"; 

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

    -- wb   : UART2WBM
    -- port map (
    --     CLK       => SYS_CLK,
    --     RST       => interrupt(0),
    --     TxByte    => DebugTxByte,
    --     TxAvail   => DebugTxAvail,
    --     TxReady   => not DebugTxStatus(0),
    --     RdByte    => DebugRdByte,
    --     RdValid   => RdValid,
    --     WB_CYC    => WB_CYC  ,
    --     WB_STB    => WB_STB  ,
    --     WB_WE     => WB_WE   ,
    --     WB_ADDR   => WB_ADDR ,
    --     WB_TGA    => WB_TGA  ,
    --     WB_DOUT   => WB_DOUT ,
    --     WB_STALL  => WB_STALL,
    --     WB_ACK    => WB_ACK  ,
    --     WB_DIN    => WB_DIN  
    -- );

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

    -- debug : process (SYS_CLK)
    -- begin
    --     if rising_edge (SYS_CLK) then
    --         if rst = '1' then
    --             WB_ACK <= '0';
    --             WB_STALL <= '0';
    --             -- WB_DIN <= (others => '0');
    --             -- dbreakUart <= '0';
    --             -- dstepUart <= '0';
    --             -- dcontUart <= '0';
    --             DebugIn.BreakPoints <= (others => (others => '0'));
    --             DebugIn.BWhenReg <= 0;
    --             DebugIn.BWhenValue <= (others => '0');
    --             DebugIn.BWhenOp <= REG_NOTHING;
    --             dmemReadCount <= 0;
    --             DEBUG_MEM_ADDRA <= (others => '0');
    --             DEBUG_MEM_ENA <= '0';
    --             DEBUG_MEM_WEA(0) <= '0';
    --             DEBUG_MEM_DINA <= (others => '0');

    --         else
    --             if dstepBtn = '1' then
    --                 DebugIn.Step <= '1';
    --             elsif dbreakBtn = '1' then
    --                 DebugIn.Break <= '1';
    --             elsif dcontBtn = '1' then
    --                 DebugIn.Continue <= '1';
    --             end if;

    --             if DebugIn.Break = '1' then
    --                 DebugIn.Break <= '0';
    --             elsif DebugIn.Continue = '1' then
    --                 DebugIn.Continue <= '0';
    --             elsif DebugIn.Step = '1' then
    --                 DebugIn.Step <= '0';
    --             end if;

    --             if WB_CYC = '1' then
    --                 case WB_TGA is
    --                     when TGA_STATUS =>
    --                         if WB_WE = '0' then -- STATUS COMMAND
    --                             case DEBUG_DATA'VAL(to_integer(unsigned(WB_ADDR))) is
    --                                 when DBG_STATE =>              -- VALUE 0
    --                                     WB_DIN <= X"0000000" & B"000" & DebugOut.Stopped;
    --                                 when DBG_PROG_COUNTER =>        -- VALUE 1
    --                                     WB_DIN <= X"00000" & STD_LOGIC_VECTOR(Debugout.ProgCounter);
    --                                 when DBG_INSTRUCTION =>         -- VALUE 2
    --                                     WB_DIN <= Debugout.Instruction;
    --                                 when DBG_CYCLES =>              -- VALUE 3
    --                                     WB_DIN <= STD_LOGIC_VECTOR(Debugout.CycleCount(31 downto 0));
    --                                 when DBG_INTERRUPT =>           -- VALUE 4
    --                                     WB_DIN <= DebugOut.Interrupt;
    --                                 when DGB_INTERRUPT_MASK =>      -- VALUE 5
    --                                     WB_DIN <= DebugOut.InterruptMask;
    --                                 when DBG_STATUS =>              -- VALUE 6
    --                                     WB_DIN <= DebugOut.Status;
    --                                 when DBG_STATUS_MASK =>         -- VALUE 7
    --                                     WB_DIN <= DebugOut.StatusMask;
    --                                 when DBG_MEMORY_ARG =>          -- VALUE 8
    --                                     WB_DIN <= DebugOut.MEMORY_ARG;
    --                                 when others =>
    --                             end case;
    --                         end if;
    --                         WB_ACK <= '1';
                            
    --                     when TGA_STEP =>
    --                         if WB_WE = '1' then -- STEP COMMAND
    --                             DebugIn.Step <= '1';
    --                             -- dstepUart <= '1';
    --                             -- if dstepUart = '1' then
    --                             --     dstepUart <= '0';
    --                             -- end if;
    --                         end if;
    --                         WB_ACK <= '1';

    --                     when TGA_CONTINUE =>
    --                         if WB_WE = '1' then -- CONTINUE COMMAND
    --                             DebugIn.Continue <= '1';
    --                             -- dcontUart <= '1';
    --                             -- if dcontUart = '1' then
    --                             --     dcontUart <= '0';
    --                             -- end if;
    --                         end if;
    --                         WB_ACK <= '1';

    --                     when TGA_BREAK =>
    --                         if WB_WE = '1' then -- BREAK COMMAND
    --                            DebugIn.Break <= '1';
    --                             -- dbreakUart <= '1';
    --                             -- if dbreakUart = '1' then
    --                             --     dbreakUart <= '0';
    --                             -- end if;
    --                         end if;
    --                         WB_ACK <= '1';

    --                     when TGA_BREAKAT =>
    --                         if WB_WE = '1' then -- BREAK COMMAND
    --                             DebugIn.BreakPoints(to_integer(unsigned(WB_ADDR(3 downto 0))))
    --                                 <= unsigned(WB_DOUT(11 downto 0));
    --                         end if;
    --                         WB_ACK <= '1';

    --                     when TGA_BREAKWHEN =>
    --                         if WB_WE = '1' then -- BREAK COMMAND
    --                             DebugIn.BWhenReg <= to_integer(unsigned(WB_ADDR(3 downto 0)));
    --                             DebugIn.BWhenOp <= REG_COMPARE'VAL(to_integer(unsigned(WB_ADDR(7 downto 5))));
    --                             DebugIn.BWhenValue <= WB_DOUT(31 downto 0);
    --                         end if;
    --                         WB_ACK <= '1';

    --                     when TGA_RESET =>
    --                         if WB_WE = '0' then
    --                             DebugIn.Reset <= '1';
    --                         else
    --                             DebugIn.Reset <= '0';
    --                         end if;

    --                     when TGA_REGISTERS => -- REGISTER COMMAND
    --                         if WB_WE = '0' then
    --                             WB_DIN <= Debugout.Regs(to_integer(unsigned(WB_ADDR(3 downto 0)))).Value;
    --                         else
    --                             -- TODO: Debug write CPU Registers.
    --                             -- This would require DebugIn to have the CPURegs.
    --                             -- Also, the CPU Regs for the ALU and Debug Needs to be MUXed.
    --                             -- This is possible, not hard, but, I will leave it for later.
    --                         end if;
    --                         WB_ACK <= '1';

    --                     when TGA_MEMORY => -- MEMORY COMMAND
    --                         if WB_WE = '0' then
    --                             if dmemReadCount /= 3 then
    --                                 DEBUG_MEM_ADDRA <= WB_ADDR(11 downto 0);
    --                                 DEBUG_MEM_ENA <= '1';
    --                                 DEBUG_MEM_WEA(0) <= '0';
    --                                 dmemReadCount <= dmemReadCount + 1;
    --                             else
    --                                 DEBUG_MEM_ENA <= '0';
    --                                 WB_DIN <= DEBUG_MEM_DOUTA;
    --                                 WB_ACK <= '1';
    --                                 dmemReadCount <= 0;
    --                             end if;
    --                         else
    --                             if dmemReadCount /= 1 then
    --                                 DEBUG_MEM_ADDRA <= WB_ADDR(11 downto 0);
    --                                 DEBUG_MEM_ENA <= '1';
    --                                 DEBUG_MEM_WEA(0) <= '1';
    --                                 DEBUG_MEM_DINA <= WB_DOUT;
    --                                 dmemReadCount <= dmemReadCount + 1;
    --                             else
    --                                 DEBUG_MEM_ENA <= '0';
    --                                 DEBUG_MEM_WEA(0) <= '0';
    --                                 WB_ACK <= '1';
    --                                 dmemReadCount <= 0;
    --                             end if;
    --                         end if;
    --                     when others =>
    --                 end case;
                    

    --             else
    --                 WB_ACK <= '0';
    --             end if;
    --         end if;
    --     end if;
    -- end process;

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