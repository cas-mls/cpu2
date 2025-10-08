-- vhdl-linter-disable not-declared type-resolved component
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/03/2023 09:47:49 PM
-- Design Name: 
-- Module Name: Registers - Behavioral
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

use ieee.numeric_std.all;
use IEEE.STD_LOGIC_1164.all;
-- use ieee.std_logic_unsigned.all;

library UNISIM;
use UNISIM.VComponents.all;

use xil_defaultlib.Utilities.all;
use xil_defaultlib.DebugPkg.all;

---------------------------------------------------------------------------
-- ### Arithmetic Logic Unit (ALU)

-- This handles the updating and operating on the register and is also known as the Arithmetic Logic Unit (ALU).

-- #### Instructions

--  * oLD - Move Register contents, load memory to register
--  * oRTN - Return from JSR (Return from Subroutine)
--  * oRTI - Return from InterruptoRTN
--  * oADD - Add registers, immediate, or memory 
--  * oSUB - Subtract registers, immediate, or memory 
--  * oAND - And or Nand registers, immediate, or memory
--  * oOR - Or or Nor registers, immediate, or memory
--  * oXOR - Xor or Xnor registers, immediate, or memory
--  * oSHL - Shift left registers, immediate, or memory
--  * oSHR - Shift right registers, immediate, or memory
--  * oJSR - Jump and store PC (Jump to Subroutine)
--  * oRWIO - Load and write to IO.
--  * oPUSHPOP - Push or Pop from memory

-- #### Wire Assignments (outputs)
-- | Signal            | Description                                                  |
-- | ----------------- | ------------------------------------------------------------ |
-- | cpuRegs         | The fast CPU registers.

-- #### Used Wires (Inputs)
-- | Signal            | Description                                                  |
-- | ----------------- | ------------------------------------------------------------ |
-- |INSTRUCTION     | Instruction operation
-- |MEM_ARG         | The current memory argument from decode.
-- |fsm_inst_cycle_p | Process States:
-- | |       RESET_STATE_S           - Reset the CPU.
-- | |       EXECUTE_S               - Execute the instruction.  To process interrupts, store registers/data.
-- |  |      CLEANUP_S               - Clean up data after execute.
-- |fsm_interrupt_cycle_p | Process States:
-- |  |      SAVEENA_S (State 2)     - Saves the Interrupt Enable Mask.
-- |  |      JMPADDR_S (State 4)     - Get the Interrupt Handler from address vector.
-- |interruptSPNum
-- |IOR_DATA           | Data from the peripheral device.
-- |IO_STATUS          | The IO status from the peripheral device.
-- |ireg1value         | Value of the Register pointed to by instruction.
-- |ffiregop2          | Instruction identified second register.
-- |ireg2value         | Value of the Register pointed to by instruction.
-- |interruptSpAddrValue    

-- #### Internal Wires:
-- | Signal            | Description                                                  |
-- | ----------------- | ------------------------------------------------------------ |
-- | ffopcode          | Instruction operation
-- | ffflag            | Multiple use flag (e.g., negative logic)
-- | ffmemop           | Memory access operation.
-- | ffiregop1         | Instruction identified first register.
-- | ffiregop2         | Instruction identified second register.
-- | ffimmop           | Immediate value from the instruction.
---------------------------------------------------------------------------

entity ALU is
    port (
        SYS_CLK              : in  STD_LOGIC;
        INSTRUCTION          : in  STD_LOGIC_VECTOR(31 downto 0);
        MEM_ARG              : in  STD_LOGIC_VECTOR(31 downto 0);
        STACK_ARG            : in  STD_LOGIC_VECTOR(31 downto 0);
        fsm_inst_cycle_p     : in  CYCLETYPE_FSM;
        fsm_interrupt_cycle_p: in  INTERRUPT_FSM;
        interruptSPNum       : in  INTEGER range 0 to 31;
        IOR_DATA             : in  STD_LOGIC_VECTOR(31 downto 0);
        IO_STATUS            : in  STD_LOGIC_VECTOR(31 downto 0);
        interruptSpAddrValue : in  INTEGER range 0 to 2 ** 12 - 1;
        statusWord           : out STATUS_WORD_TYPE := (others => '0');
        cpuRegs              : out REG_TYPE;
        AluRegisterLocked    : out STD_LOGIC;

        DEBUGIN              : in  DEBUGINTYPE := DEBUGIN_DEFAULTS
    );

end ALU;

architecture Behavioral of ALU is

    -- Decode information    
    signal ffopcode   : OPCODETYPE := "00000";
    signal ffflag     : STD_LOGIC  := '0';
    signal ffmemop    : MEMTYPE;
    signal ffiregop1  : INTEGER range 0 to 15;
    signal ffiregop2  : INTEGER range 0 to 15;
    signal ffimmop    : IMMTYPE;
    signal ireg1value : STD_LOGIC_VECTOR(31 downto 0);
    signal ireg2value : STD_LOGIC_VECTOR(31 downto 0);

    -- Signed Multiply
    signal SMultRegA : STD_LOGIC_VECTOR(31 downto 0);
    signal SMultRegB : STD_LOGIC_VECTOR(31 downto 0);
    signal SProduct  : STD_LOGIC_VECTOR(63 downto 0);

    -- Signed Divide
    signal SDivRegA      : STD_LOGIC_VECTOR(31 downto 0);
    signal SDivRegAValid : STD_LOGIC;
    signal SDivRegB      : STD_LOGIC_VECTOR(31 downto 0);
    signal SDivRegBValid : STD_LOGIC;
    signal SUsrRegNum    : STD_LOGIC_VECTOR(3 downto 0);
    signal SQuotRem      : STD_LOGIC_VECTOR(63 downto 0);
    signal SQuotRemValid : STD_LOGIC;
    signal SUsrZeroReg   : STD_LOGIC_VECTOR(4 downto 0);

    -- Signed Multiply
    signal UMultRegA : STD_LOGIC_VECTOR(31 downto 0);
    signal UMultRegB : STD_LOGIC_VECTOR(31 downto 0);
    signal UProduct  : STD_LOGIC_VECTOR(63 downto 0);

    -- Signed Divide
    signal UDivRegA      : STD_LOGIC_VECTOR(31 downto 0);
    signal UDivRegAValid : STD_LOGIC;
    signal UDivRegB      : STD_LOGIC_VECTOR(31 downto 0);
    signal UDivRegBValid : STD_LOGIC;
    signal UUsrRegNum    : STD_LOGIC_VECTOR(3 downto 0);
    signal UQuotRem      : STD_LOGIC_VECTOR(63 downto 0);
    signal UQuotRemValid : STD_LOGIC;
    signal UUsrZeroReg   : STD_LOGIC_VECTOR(4 downto 0);

    signal AValS : signed(32 downto 0);
    signal BValS : signed(32 downto 0);
    signal RValS : signed(32 downto 0);
    signal AValU : unsigned(32 downto 0);
    signal BValU : unsigned(32 downto 0);
    signal RValU : unsigned(32 downto 0);

    signal delayReg1 : unsigned(31 downto 0);
    signal delayReg2 : unsigned(31 downto 0);

    -- attribute keep : string;
    -- attribute MARK_DEBUG : string;
    -- attribute keep of SProduct : signal is "TRUE";
    -- attribute MARK_DEBUG of SProduct : signal is "TRUE";

    component SIntMult
        port (
            CLK : in  STD_LOGIC;
            A   : in  STD_LOGIC_VECTOR(31 downto 0);
            B   : in  STD_LOGIC_VECTOR(31 downto 0);
            P   : out STD_LOGIC_VECTOR(63 downto 0)
        );
    end component;

    component UIntMult
        port (
            CLK : in  STD_LOGIC;
            A   : in  STD_LOGIC_VECTOR(31 downto 0);
            B   : in  STD_LOGIC_VECTOR(31 downto 0);
            P   : out STD_LOGIC_VECTOR(63 downto 0)
        );
    end component;

    component SIntDiv
        port (
            aclk                   : in  STD_LOGIC;
            s_axis_divisor_tvalid  : in  STD_LOGIC;
            s_axis_divisor_tdata   : in  STD_LOGIC_VECTOR(31 downto 0);
            s_axis_dividend_tvalid : in  STD_LOGIC;
            s_axis_dividend_tuser  : in  STD_LOGIC_VECTOR(3 downto 0);
            s_axis_dividend_tdata  : in  STD_LOGIC_VECTOR(31 downto 0);
            m_axis_dout_tvalid     : out STD_LOGIC;
            m_axis_dout_tuser      : out STD_LOGIC_VECTOR(4 downto 0);
            m_axis_dout_tdata      : out STD_LOGIC_VECTOR(63 downto 0)
        );
    end component;

    component UIntDiv
        port (
            aclk                   : in  STD_LOGIC;
            s_axis_divisor_tvalid  : in  STD_LOGIC;
            s_axis_divisor_tdata   : in  STD_LOGIC_VECTOR(31 downto 0);
            s_axis_dividend_tvalid : in  STD_LOGIC;
            s_axis_dividend_tuser  : in  STD_LOGIC_VECTOR(3 downto 0);
            s_axis_dividend_tdata  : in  STD_LOGIC_VECTOR(31 downto 0);
            m_axis_dout_tvalid     : out STD_LOGIC;
            m_axis_dout_tuser      : out STD_LOGIC_VECTOR(4 downto 0);
            m_axis_dout_tdata      : out STD_LOGIC_VECTOR(63 downto 0)
        );
    end component;

    function SetRegisterValue ( value : STD_LOGIC_VECTOR(31 downto 0) ) 
        return REG_TYPE_REC is
    variable newRegs : REG_TYPE_REC := REG_DEFAULTS;
    begin
        newRegs.Value := value;
        return newRegs;        
    end SetRegisterValue;

begin

    SignIntMultiply : SIntMult
    port map(
        CLK => SYS_CLK,
        A   => SMultRegA,
        B   => SMultRegB,
        P   => SProduct
    );

    SignIntDivide : SIntDiv
    port map(
        aclk                   => SYS_CLK,
        s_axis_divisor_tvalid  => SDivRegBValid,
        s_axis_divisor_tdata   => SDivRegB,
        s_axis_dividend_tvalid => SDivRegAValid,
        s_axis_dividend_tuser  => SUsrRegNum,
        s_axis_dividend_tdata  => SDivRegA,
        m_axis_dout_tvalid     => SQuotRemValid,
        m_axis_dout_tuser      => SUsrZeroReg,
        m_axis_dout_tdata      => SQuotRem
    );

    UignIntMultiply : UIntMult
    port map(
        CLK => SYS_CLK,
        A   => UMultRegA,
        B   => UMultRegB,
        P   => UProduct
    );

    UignIntDivide : UIntDiv
    port map(
        aclk                   => SYS_CLK,
        s_axis_divisor_tvalid  => UDivRegBValid,
        s_axis_divisor_tdata   => UDivRegB,
        s_axis_dividend_tvalid => UDivRegAValid,
        s_axis_dividend_tuser  => UUsrRegNum,
        s_axis_dividend_tdata  => UDivRegA,
        m_axis_dout_tvalid     => UQuotRemValid,
        m_axis_dout_tuser      => UUsrZeroReg,
        m_axis_dout_tdata      => UQuotRem
    );

    alu_proc : process (SYS_CLK)
        variable a_reg_s         : signed(31 downto 0);
        variable b_reg_s         : signed(31 downto 0);
        variable results_reg_s   : signed(31 downto 0);
        variable results_mult_s  : signed(63 downto 0);
        variable a_reg_u         : unsigned(32 downto 0);
        variable b_reg_u         : unsigned(32 downto 0);
        variable results_reg_u   : unsigned(32 downto 0);
        variable results_mult_u  : unsigned(63 downto 0);
        variable results_ov      : INTEGER;
        variable divideZero      : STD_LOGIC;
        variable divRegNum       : INTEGER;
        variable localStatusWord : STATUS_WORD_TYPE := (others => '0');

    begin
        if rising_edge (SYS_CLK) then

            -- Default these and later they will be set by the Divide section
            SDivRegAValid <= '0';
            SDivRegBValid <= '0';

            -- Check each cycle for changes in the long operations and update the registers.
            for reg in cpuRegs'range loop
                -- Countdown to 1 instead of zero, the last cycle is the result.
                -- if cpuRegs(reg).OpCode /= oNOP then
                if cpuRegs(reg).Countdown > 0 then
                    cpuRegs(reg).Countdown <= cpuRegs(reg).Countdown - 1;
                else
                    case cpuRegs(reg).OpCode is
                        when oMul =>
                            if cpuRegs(reg).Flag = '0' then
                                cpuRegs(reg) <= SetRegisterValue(SProduct(31 downto 0));
                                -- XXX: Fix the status word processing for timing issues.
                                -- localStatusWord(OverUnderflow) := 
                                --         '0' when signed(SProduct(63 downto 32)) = 0 
                                --                 or signed(SProduct(63 downto 32)) = -1 
                                --             else '1';
                            else
                                cpuRegs(reg) <= SetRegisterValue(UProduct(31 downto 0));
                                -- XXX: Fix the status word processing for timing issues.
                                -- localStatusWord(OverUnderflow) := 
                                --         '0' when signed(UProduct(63 downto 34)) = 0 
                                --             else '1';
                            end if;

                        when oAdd =>
                            cpuRegs(reg) <= SetRegisterValue(STD_LOGIC_VECTOR(delayReg1));
                            if cpuRegs(reg).Flag = '0' then
                                -- XXX: Fix the status word processing for timing issues.
                                -- localStatusWord(OverUnderflow) :=  
                                --             (AValS(31) xnor BValS(31)) 
                                --         and (AValS(31) xor RValS(31));
                            else
                                -- XXX: Fix the status word processing for timing issues.
                                -- localStatusWord(OverUnderflow) := RValU(32);
                            end if;

                        when oSub =>
                            cpuRegs(reg) <= SetRegisterValue(STD_LOGIC_VECTOR(delayReg1));
                            if cpuRegs(reg).Flag = '0' then
                                -- XXX: Fix the status word processing for timing issues.
                                -- localStatusWord(OverUnderflow) := 
                                --         '1' when AValS < 0 and  BValS > 0 and RValS < AValS
                                --             else '0';
                            else
                                -- XXX: Fix the status word processing for timing issues.
                                -- localStatusWord(OverUnderflow) :=  
                                --         '1' when BValU > AValU
                                --             else '0';
                            end if;

                        when oRWIO =>
                            if cpuRegs(reg).flag = '0'
                                and (cpuRegs(reg).memop = REGREG
                                    or cpuRegs(reg).memop = IMMEDIATE) 
                            then 
                                cpuRegs(reg) <= SetRegisterValue(IOR_DATA);
                            end if;

                        when oIOST =>
                            cpuRegs(reg) <= SetRegisterValue(IO_STATUS);

                        when oRTI =>
                            cpuRegs(reg) <= SetRegisterValue(cpuRegs(reg).Value);

                        when oAND | oOR | oXOR | oShLR | oJmp | oSWDM =>
                            cpuRegs(reg) <= SetRegisterValue(STD_LOGIC_VECTOR(delayReg1));

                        when oJsr | oRTN =>
                            cpuRegs(reg) <= SetRegisterValue(STD_LOGIC_VECTOR(delayReg2));

                        when oPUSHPOP =>
                            if cpuRegs(reg).Flag = '0' then -- Push
                                -- Update Stack Pointer
                                cpuRegs(reg) <= SetRegisterValue(STD_LOGIC_VECTOR(delayReg2));
                            else -- Pop 
                                -- Update the Register Value and Stack Pointer
                                if cpuRegs(reg).RegOpNum = 1 then
                                    -- Pop and update the Register
                                    cpuRegs(reg) <= SetRegisterValue(STD_LOGIC_VECTOR(delayReg1));
                                else
                                    -- Update Stack Pointer
                                    cpuRegs(reg) <= SetRegisterValue(STD_LOGIC_VECTOR(delayReg2));
                                end if;
                            end if;

                        when others =>

                    end case;

                end if;
                -- end if;
            end loop;

            if SQuotRemValid = '1' then
                divideZero := SUsrZeroReg(0);
                divRegNum  := to_integer(unsigned(SUsrZeroReg(4 downto 1)));
                if divideZero = '0' then -- Not divide by zero
                    cpuRegs(divRegNum).OpCode <= oNOP;
                    cpuRegs(divRegNum).Value  <= SQuotRem(63 downto 32); -- Quotent
                end if;
                -- XXX: Fix the status word processing for timing issues.
                -- statusWord(DivideByZero) <= divideZero;
            elsif UQuotRemValid = '1' then
                divideZero := UUsrZeroReg(0);
                divRegNum  := to_integer(unsigned(UUsrZeroReg(4 downto 1)));
                if divideZero = '0' then -- Not divide by zero
                    -- XXX: This is not right for remainder values.  I think it is 31 downto 0.
                    -- If using the register pair this needs to be worked out better.
                    cpuRegs(divRegNum).OpCode <= oNOP;
                    cpuRegs(divRegNum).Value  <= UQuotRem(63 downto 32); -- Quotent
                end if;
            end if;

            -- XXX: Fix the status word processing for timing issues.
            -- statusWord <= localStatusWord;

            case fsm_inst_cycle_p is
                when RESET_STATE_S =>
                    cpuRegs           <= (others => REG_DEFAULTS);
                    statusWord        <= (others => '0');
                    AluRegisterLocked <= '0';
                    SMultRegA         <= (others => '0');
                    SMultRegB         <= (others => '0');
                    SDivRegA          <= (others => '0');
                    SDivRegAValid     <= '0';
                    SDivRegB          <= (others => '0');
                    SDivRegBValid     <= '0';
                    SUsrRegNum        <= (others => '0');

                when DECODE_S =>

                    -- Waiting for a unlocked register then use the Flip-Flop register values.
                    if AluRegisterLocked = '0' then 
                        -- Maintain Flip-Flop (Memory) protions of the instruction.
                        -- This removes the timing violations and make the processor faster.
                        -- Might remove the combinatorial logic which should not be used after this cycle.
                        ffopcode  <= INSTRUCTION(31 downto 27);
                        ffflag    <= INSTRUCTION(26);
                        ffmemop   <= INSTRUCTION(25 downto 24);
                        ffiregop1 <= to_integer(unsigned(INSTRUCTION(23 downto 20)));
                        ffiregop2 <= to_integer(unsigned(INSTRUCTION(19 downto 16)));
                        ffimmop   <= INSTRUCTION(15 downto 0);
                        -- Save the values of the Register Data.  Again this if or timing operations.
                        ireg1value <= cpuRegs(to_integer(unsigned(INSTRUCTION(23 downto 20)))).Value;
                        ireg2value <= cpuRegs(to_integer(unsigned(INSTRUCTION(19 downto 16)))).Value;

                        if cpuRegs(to_integer(unsigned(INSTRUCTION(23 downto 20)))).OpCode = oNOP
                            then
                            cpuRegs(to_integer(unsigned(INSTRUCTION(23 downto 20)))).memop <= INSTRUCTION(25 downto 24);
                            cpuRegs(to_integer(unsigned(INSTRUCTION(23 downto 20)))).flag  <= INSTRUCTION(26);
                        end if;

                        if cpuRegs(to_integer(unsigned(INSTRUCTION(23 downto 20)))).OpCode /= oNOP
                            or cpuRegs(to_integer(unsigned(INSTRUCTION(19 downto 16)))).OpCode /= oNOP
                        then -- Register needs to be locked
                            AluRegisterLocked <= '1';
                        end if;
                    end if;

                when EXECUTE_S =>

                    -- Default the current register to a NOP.
                    -- Later this will be set to the instruction.
                    if AluRegisterLocked = '0' then

                        case ffmemop is
                            when REGREG =>
                                a_reg_u := resize(unsigned(ireg1value), 33);
                                b_reg_u := resize(unsigned(ireg2value), 33);
                                a_reg_s := signed(ireg1value);
                                b_reg_s := signed(ireg2value);

                            when IMMEDIATE =>
                                if ffiregop2 = 0 then
                                    a_reg_u := resize(unsigned(ireg1value), 33);
                                    b_reg_u := resize(unsigned(ffimmop), 33);
                                    a_reg_s := signed(ireg1value);
                                    b_reg_s := resize(signed(ffimmop), 32);
                                else
                                    a_reg_u := resize(unsigned(ireg2value), 33);
                                    b_reg_u := resize(unsigned(ffimmop), 33);
                                    a_reg_s := signed(ireg2value);
                                    b_reg_s := resize(signed(ffimmop), 32);
                                end if;

                            when ABSOLUTE | INDEX =>
                                a_reg_u := resize(unsigned(ireg1value), 33);
                                b_reg_u := resize(unsigned(MEM_ARG), 33);
                                if ffflag = '0' then
                                    a_reg_s := signed(ireg1value);
                                    b_reg_s := signed(MEM_ARG);
                                end if;

                            when others =>

                        end case;

                        case ffopcode is
                            when oLD =>
                                case ffmemop is
                                    when REGREG =>
                                        cpuRegs(ffiregop1).Value <= ireg2value;
                                    when IMMEDIATE =>
                                        if ffflag = '1' then
                                            cpuRegs(ffiregop1).Value(31 downto 16) <= ffimmop;
                                        else
                                            cpuRegs(ffiregop1).Value(15 downto 0) <= ffimmop;
                                        end if;
                                    when ABSOLUTE | INDEX =>
                                        cpuRegs(ffiregop1).Value <= MEM_ARG;
                                    when others =>
                                end case;

                            when oADD =>
                                if ffflag = '0' then
                                    results_reg_s := a_reg_s + b_reg_s;
                                    delayReg1 <= unsigned(results_reg_s);
                                    AValS     <= resize(a_reg_s, 33);
                                    BValS     <= resize(b_reg_s, 33);
                                    RValS     <= resize(results_reg_s, 33);

                                else
                                    results_reg_u := a_reg_u + b_reg_u;
                                    delayReg1 <= resize(results_reg_u, 32);
                                    RValU     <= resize(results_reg_u, 33);
                                end if;
                                cpuRegs(ffiregop1).OpCode    <= ffopcode;
                                cpuRegs(ffiregop1).Countdown <= 0;

                            when oSUB =>
                                if ffflag = '0' then
                                    results_reg_s := a_reg_s - b_reg_s;
                                    delayReg1 <= unsigned(results_reg_s);
                                    AValS     <= resize(a_reg_s, 33);
                                    BValS     <= resize(b_reg_s, 33);
                                    RValS     <= resize(results_reg_s, 33);

                                else
                                    results_reg_u := a_reg_u - b_reg_u;
                                    delayReg1 <= resize(results_reg_u, 32);
                                    AValU     <= resize(a_reg_u, 33);
                                    BValU     <= resize(b_reg_u, 33);
                                    RValU     <= resize(results_reg_u, 33);

                                end if;
                                cpuRegs(ffiregop1).OpCode    <= ffopcode;
                                cpuRegs(ffiregop1).Countdown <= 0;

                            when oMul =>
                                if ffflag = '0' then
                                    SMultRegA <= STD_LOGIC_VECTOR(a_reg_s);
                                    SMultRegB <= STD_LOGIC_VECTOR(b_reg_s);
                                else
                                    UMultRegA <= STD_LOGIC_VECTOR(a_reg_u(31 downto 0));
                                    UMultRegB <= STD_LOGIC_VECTOR(b_reg_u(31 downto 0));
                                end if;
                                cpuRegs(ffiregop1).OpCode    <= ffopcode;
                                cpuRegs(ffiregop1).Countdown <= 6;

                            when oDiv =>
                                if ffflag = '0' then
                                    SDivRegA      <= STD_LOGIC_VECTOR(a_reg_s);
                                    SDivRegB      <= STD_LOGIC_VECTOR(b_reg_s);
                                    SDivRegAValid <= '1';
                                    SDivRegBValid <= '1';
                                    SUsrRegNum    <= STD_LOGIC_VECTOR(to_unsigned(ffiregop1, 4));
                                    -- XXX: If remainder is used then need to set the remainder register to oDiv.
                                else
                                    UDivRegA      <= STD_LOGIC_VECTOR(a_reg_u(31 downto 0));
                                    UDivRegB      <= STD_LOGIC_VECTOR(b_reg_u(31 downto 0));
                                    UDivRegAValid <= '1';
                                    UDivRegBValid <= '1';
                                    UUsrRegNum    <= STD_LOGIC_VECTOR(to_unsigned(ffiregop1, 4));
                                    -- XXX: If remainder is used then need to set the remainder register to oDiv.
                                end if;
                                cpuRegs(ffiregop1).OpCode <= ffopcode;

                            when oAND =>
                                if ffflag = '0' then
                                    delayReg1 <= resize(a_reg_u and b_reg_u, 32);
                                else
                                    delayReg1 <= resize(a_reg_u nand b_reg_u, 32);
                                end if;
                                cpuRegs(ffiregop1).OpCode    <= ffopcode;
                                cpuRegs(ffiregop1).Countdown <= 0;

                            when oOR =>
                                if ffflag = '0' then
                                    delayReg1 <= resize(a_reg_u or b_reg_u, 32);
                                else
                                    delayReg1 <= resize(a_reg_u nor b_reg_u, 32);
                                end if;
                                cpuRegs(ffiregop1).OpCode    <= ffopcode;
                                cpuRegs(ffiregop1).Countdown <= 0;

                            when oXOR =>
                                if ffflag = '0' then
                                    delayReg1 <= resize(a_reg_u xor b_reg_u, 32);
                                else
                                    delayReg1 <= resize(a_reg_u xnor b_reg_u, 32);
                                end if;
                                cpuRegs(ffiregop1).OpCode    <= ffopcode;
                                cpuRegs(ffiregop1).Countdown <= 0;

                            when oSHLR =>
                                if ffflag = '0' then
                                    delayReg1 <= resize(a_reg_u sll to_integer(b_reg_u), 32);
                                else
                                    delayReg1 <= resize(a_reg_u srl to_integer(b_reg_u), 32);
                                end if;
                                cpuRegs(ffiregop1).OpCode    <= ffopcode;
                                cpuRegs(ffiregop1).Countdown <= 0;

                            when oJSR =>
                                delayReg2 <= to_unsigned(
                                             to_integer(unsigned(ireg2value)) - 1, 32);
                                cpuRegs(ffiregop2).OpCode    <= ffopcode;
                                cpuRegs(ffiregop2).Countdown <= 0;

                            when oPUSHPOP =>
                                case ffmemop is
                                    when REGREG =>
                                        if ffflag = '0' then -- Push
                                            delayReg2 <= to_unsigned(
                                                         to_integer(unsigned(ireg2value)) - 1, 32);
                                            cpuRegs(ffiregop2).OpCode    <= ffopcode;
                                            cpuRegs(ffiregop2).Flag      <= ffflag;
                                            cpuRegs(ffiregop2).RegOpNum  <= 2;
                                            cpuRegs(ffiregop2).Countdown <= 0;

                                        else -- Pop
                                            delayReg2 <= to_unsigned(
                                                         to_integer(unsigned(ireg2value)) + 1, 32);
                                            cpuRegs(ffiregop2).OpCode    <= ffopcode;
                                            cpuRegs(ffiregop2).Flag      <= ffflag;
                                            cpuRegs(ffiregop2).RegOpNum  <= 2;
                                            cpuRegs(ffiregop2).Countdown <= 0;

                                            delayReg1                    <= unsigned(STACK_ARG);
                                            cpuRegs(ffiregop1).OpCode    <= ffopcode;
                                            cpuRegs(ffiregop1).Flag      <= ffflag;
                                            cpuRegs(ffiregop1).RegOpNum  <= 1;
                                            cpuRegs(ffiregop1).Countdown <= 0;
                                        end if;
                                    when IMMEDIATE =>
                                        if ffflag = '0' then
                                            delayReg2 <= to_unsigned(
                                                         to_integer(unsigned(ireg2value)) - 1, 32);
                                            cpuRegs(ffiregop2).OpCode    <= ffopcode;
                                            cpuRegs(ffiregop2).Flag      <= ffflag;
                                            cpuRegs(ffiregop2).RegOpNum  <= 2;
                                            cpuRegs(ffiregop2).Countdown <= 0;
                                        end if;
                                    when others =>
                                end case;

                            when oRTI =>
                                if ffmemop = REGREG then
                                    cpuRegs(interruptSpNum).Value <= STD_LOGIC_VECTOR(to_unsigned(
                                                                     interruptSpAddrValue + 2, 32));
                                end if;
                                cpuRegs(ffiregop1).OpCode    <= ffopcode;
                                cpuRegs(ffiregop1).Countdown <= 0;

                            when oRWIO =>
                                if ffflag = '0' then -- IO Read
                                    if ffmemop = INDEX then
                                        cpuRegs(ffiregop2).OpCode    <= ffopcode;
                                        cpuRegs(ffiregop2).Flag      <= ffflag;
                                        cpuRegs(ffiregop2).MemOp    <= ffmemop;
                                        cpuRegs(ffiregop2).Countdown <= 0;
                                        cpuRegs(ffiregop2).RegOpNum  <= 2;
                                    end if;
                                    cpuRegs(ffiregop1).OpCode    <= ffopcode;
                                    cpuRegs(ffiregop1).Flag      <= ffflag;
                                    cpuRegs(ffiregop2).MemOp    <= ffmemop;
                                    cpuRegs(ffiregop1).Countdown <= 0;
                                    cpuRegs(ffiregop1).RegOpNum  <= 1;
                                end if;

                            when oIOST =>
                                cpuRegs(ffiregop1).OpCode    <= ffopcode;
                                cpuRegs(ffiregop1).Flag      <= ffflag;
                                cpuRegs(ffiregop1).Countdown <= 0;
                                cpuRegs(ffiregop1).RegOpNum <= 1;

                            when oRTN =>
                                if ffmemop = REGREG then
                                    delayReg2 <= to_unsigned(
                                                 to_integer(unsigned(ireg2value)) + 1, 32);
                                end if;
                                cpuRegs(ffiregop2).OpCode    <= ffopcode;
                                cpuRegs(ffiregop2).Countdown <= 0;

                            when oSWDM =>
                                if ffflag = SWDFLAG
                                    and ffmemop = REGREG
                                    then
                                    delayReg1  <= unsigned(statusWord);
                                    statusWord <= (others => '0');
                                end if;
                                cpuRegs(ffiregop1).OpCode    <= ffopcode;
                                cpuRegs(ffiregop1).Countdown <= 0;

                            when others =>

                            
                        end case;
                    else
                        if cpuRegs(ffiregop1).OpCode = oNOP
                            and cpuRegs(ffiregop2).OpCode = oNOP
                        then -- Unlock the register.
                            AluRegisterLocked <= '0';
                            ireg1value <= cpuRegs(ffiregop1).Value;
                        end if;
                    end if;
                when DEBUGWAIT_S =>
                    if DEBUGIN.UpdateReg.Valid = '1'
                        then
                        cpuRegs(DEBUGIN.UpdateReg.Number).Value <= DEBUGIN.UpdateReg.Value;
                    end if;
                    if DEBUGIN.UpdateValue.Valid = '1' then
                        if DEBUG_DATA'VAL(DEBUGIN.UpdateValue.Number) = DBG_STATUS
                            then
                            statusWord <= DEBUGIN.UpdateValue.Value;
                        end if;
                    end if;
                when others =>
            end case;

            case fsm_interrupt_cycle_p is
                when JUMP_S =>
                    cpuRegs(interruptSpNum).Value <= STD_LOGIC_VECTOR(to_unsigned(interruptSpAddrValue - 2, 32));
                when others =>
            end case;
        end if;
    end process alu_proc;

end Behavioral;