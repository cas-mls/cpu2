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

use xil_defaultlib.Utilities.all;

library UNISIM;
use UNISIM.VComponents.all;

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
        SYS_CLK : in std_logic;
        INSTRUCTION : in std_logic_vector(31 downto 0);
        MEM_ARG : in std_logic_vector(31 downto 0);
        fsm_inst_cycle_p : in CYCLETYPE_FSM;
        fsm_interrupt_cycle_p : in INTERRUPT_FSM;
        interruptSPNum : in integer range 0 to 31;
        IOR_DATA : in std_logic_vector(31 downto 0);
        IO_STATUS : in std_logic_vector(31 downto 0);
        interruptSpAddrValue : in integer range 0 to 2 ** 12 - 1;
        statusWord : out STATUS_WORD_TYPE := (others => '0');
        cpuRegs : out REG_TYPE;
        AluDecodeDone : out std_logic;
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
            )
            )
    );

end ALU;

architecture Behavioral of ALU is

    -- Decode information    
    signal ffopcode : OPCODETYPE := "00000";
    signal ffflag : std_logic := '0';
    signal ffmemop : MEMTYPE;
    signal ffiregop1 : integer;
    signal ffiregop2 : integer;
    signal ffimmop : IMMTYPE;
    signal ireg1value : std_logic_vector(31 downto 0);
    signal ireg2value : std_logic_vector(31 downto 0);

    -- Signed Multiply
    signal SMultRegA : std_logic_vector(31 downto 0);
    signal SMultRegB : std_logic_vector(31 downto 0);
    signal SProduct : std_logic_vector(63 downto 0);

    -- Signed Divide
    signal SDivRegA : std_logic_vector(31 downto 0);
    signal SDivRegAValid : std_logic;
    signal SDivRegB : std_logic_vector(31 downto 0);
    signal SDivRegBValid : std_logic;
    signal SUsrRegNum  : std_logic_vector(3 downto 0);
    signal SQuotRem : std_logic_vector(63 downto 0);
    signal SQuotRemValid: std_logic;
    signal SUsrZeroReg : std_logic_vector(4 downto 0);

    -- Signed Multiply
    signal UMultRegA : std_logic_vector(31 downto 0);
    signal UMultRegB : std_logic_vector(31 downto 0);
    signal UProduct : std_logic_vector(63 downto 0);

    -- Signed Divide
    signal UDivRegA : std_logic_vector(31 downto 0);
    signal UDivRegAValid : std_logic;
    signal UDivRegB : std_logic_vector(31 downto 0);
    signal UDivRegBValid : std_logic;
    signal UUsrRegNum  : std_logic_vector(3 downto 0);
    signal UQuotRem : std_logic_vector(63 downto 0);
    signal UQuotRemValid: std_logic;
    signal UUsrZeroReg : std_logic_vector(4 downto 0);

    signal AValS : signed(32 downto 0);
    signal BValS : signed(32 downto 0);
    signal RValS : signed(32 downto 0);
    signal AValU : unsigned(32 downto 0);
    signal BValU : unsigned(32 downto 0);
    signal RValU : unsigned(32 downto 0);

    -- attribute keep : string;
    -- attribute MARK_DEBUG : string;
    -- attribute keep of SProduct : signal is "TRUE";
    -- attribute MARK_DEBUG of SProduct : signal is "TRUE";

    COMPONENT SIntMult
        PORT (
            CLK : IN STD_LOGIC;
            A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            P : OUT STD_LOGIC_VECTOR(63 DOWNTO 0) 
        );
    END COMPONENT;

    COMPONENT UIntMult
        PORT (
            CLK : IN STD_LOGIC;
            A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            P : OUT STD_LOGIC_VECTOR(63 DOWNTO 0) 
        );
    END COMPONENT;

    COMPONENT SIntDiv
        PORT (
            aclk : IN STD_LOGIC;
            s_axis_divisor_tvalid : IN STD_LOGIC;
            s_axis_divisor_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            s_axis_dividend_tvalid : IN STD_LOGIC;
            s_axis_dividend_tuser : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            s_axis_dividend_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            m_axis_dout_tvalid : OUT STD_LOGIC;
            m_axis_dout_tuser : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(63 DOWNTO 0) 
        );
  END COMPONENT;

  COMPONENT UIntDiv
  PORT (
      aclk : IN STD_LOGIC;
      s_axis_divisor_tvalid : IN STD_LOGIC;
      s_axis_divisor_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      s_axis_dividend_tvalid : IN STD_LOGIC;
      s_axis_dividend_tuser : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axis_dividend_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      m_axis_dout_tvalid : OUT STD_LOGIC;
      m_axis_dout_tuser : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
      m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(63 DOWNTO 0) 
  );
END COMPONENT;

begin

    SignIntMultiply : SIntMult
        PORT MAP (
            CLK => SYS_CLK,
            A => SMultRegA,
            B => SMultRegB,
            P => SProduct
        );
  
    SignIntDivide : SIntDiv
        PORT MAP (
            aclk => SYS_CLK,
            s_axis_divisor_tvalid => SDivRegBValid,
            s_axis_divisor_tdata => SDivRegB,
            s_axis_dividend_tvalid => SDivRegAValid,
            s_axis_dividend_tuser => SUsrRegNum,
            s_axis_dividend_tdata => SDivRegA,
            m_axis_dout_tvalid => SQuotRemValid,
            m_axis_dout_tuser => SUsrZeroReg,
            m_axis_dout_tdata => SQuotRem
        );
  
    UignIntMultiply : UIntMult
        PORT MAP (
            CLK => SYS_CLK,
            A   => UMultRegA,
            B   => UMultRegB,
            P   => UProduct
        );
  
    UignIntDivide : UIntDiv
        PORT MAP (
            aclk                    => SYS_CLK,
            s_axis_divisor_tvalid   => UDivRegBValid,
            s_axis_divisor_tdata    => UDivRegB,
            s_axis_dividend_tvalid  => UDivRegAValid,
            s_axis_dividend_tuser   => UUsrRegNum,
            s_axis_dividend_tdata   => UDivRegA,
            m_axis_dout_tvalid      => UQuotRemValid,
            m_axis_dout_tuser       => UUsrZeroReg,
            m_axis_dout_tdata       => UQuotRem
        );


    alu_proc : process (SYS_CLK)
        variable a_reg_s        : signed(31 downto 0);
        variable b_reg_s        : signed(31 downto 0);
        variable results_reg_s  : signed(31 downto 0);
        variable results_mult_s : signed(63 downto 0);
        variable a_reg_u        : unsigned(32 downto 0);
        variable b_reg_u        : unsigned(32 downto 0);
        variable results_reg_u  : unsigned(32 downto 0);
        variable results_mult_u : unsigned(63 downto 0);
        variable results_ov     : integer;
        variable divideZero     : std_logic;
        variable divRegNum      : integer;

    begin
        if rising_edge (SYS_CLK) then

            -- Default these and later they will be set by the Divide section
            SDivRegAValid <= '0';
            SDivRegBValid <= '0';

            -- Check each cycle for changes in the long operations and update the registers.
            for reg in cpuRegs'range loop
                    if cpuRegs(reg).Countdown > 0 then
                        cpuRegs(reg).Countdown <= cpuRegs(reg).Countdown - 1;
                    else
                        case  cpuRegs(reg).OpCode is
                            when oMul =>
                                cpuRegs(reg).OpCode     <= oNOP;
                                cpuRegs(reg).Countdown  <= 0;
                                if cpuRegs(reg).Flag = '0' then
                                    cpuRegs(reg).Value      <= SProduct(31 downto 0);
                                    statusWord(OverUnderflow) <= 
                                            '0' when signed(SProduct(63 downto 32)) = 0 
                                                    or signed(SProduct(63 downto 32)) = -1 
                                                else '1';
                                else
                                    cpuRegs(reg).Value      <= UProduct(31 downto 0);
                                    statusWord(OverUnderflow) <= 
                                            '0' when signed(SProduct(63 downto 34)) = 0 
                                                else '1';
                                end if;
                            when oAdd =>
                                cpuRegs(reg).OpCode     <= oNOP;
                                cpuRegs(reg).Countdown  <= 0;
                                if cpuRegs(reg).Flag = '0' then
                                    statusWord(OverUnderflow) <=  
                                                (AValS(31) xnor BValS(31)) 
                                            and (AValS(31) xor RValS(31));
                                else
                                    statusWord(OverUnderflow) <= RValU(32);
                                end if;

                            when oSub =>
                                cpuRegs(reg).OpCode     <= oNOP;
                                cpuRegs(reg).Countdown  <= 0;
                                if cpuRegs(reg).Flag = '0' then
                                    statusWord(OverUnderflow) <= 
                                            '1' when AValS < 0 and  BValS > 0 and RValS < AValS
                                                else '0';
                                else
                                    statusWord(OverUnderflow) <=  
                                            '1' when BValU > AValU
                                                else '0';
                                end if;

                            when others =>

                        end case;
                    end if;
            end loop;

            if SQuotRemValid = '1' then
                divideZero := SUsrZeroReg(0);
                divRegNum := to_integer(unsigned(SUsrZeroReg(4 downto 1)));
                if divideZero = '0' then -- Not divide by zero
                    cpuRegs(divRegNum).OpCode <= oNOP; 
                    cpuRegs(divRegNum).Value <= SQuotRem(63 downto 32); -- Quotent
                end if;
                statusWord(DivideByZero) <= divideZero;
            elsif UQuotRemValid = '1' then
                divideZero := UUsrZeroReg(0);
                divRegNum := to_integer(unsigned(UUsrZeroReg(4 downto 1)));
                if divideZero = '0' then -- Not divide by zero
                    -- XXX: This is not right for remainder values.  I think it is 31 downto 0.
                    -- If using the register pair this needs to be worked out better.
                    cpuRegs(divRegNum).OpCode <= oNOP; 
                    cpuRegs(divRegNum).Value <= UQuotRem(63 downto 32); -- Quotent
                end if;
            end if;

            case fsm_inst_cycle_p is
                when RESET_STATE_S =>
                    cpuRegs <= (others => (
                        value       => (others => '0'),
                        opcode      => oNOP,
                        flag        => '0',
                        countdown   => 0 ));
                    statusWord      <= (others => '0');
                    AluDecodeDone   <= '1';
                    SMultRegA        <= (others => '0');
                    SMultRegB        <= (others => '0');
                    SDivRegA         <= (others => '0');
                    SDivRegAValid    <= '0';
                    SDivRegB         <= (others => '0');
                    SDivRegBValid    <= '0';
                    SUsrRegNum       <= (others => '0');
                
                when DECODE_S =>

                    -- Maintain Flip-Flop (Memory) protions of the instruction.
                    -- This removes the timing violations and make the processor faster.
                    -- Might remove the combinatorial logic which should not be used after this cycle.
                    ffopcode <= INSTRUCTION(31 downto 27);
                    ffflag <= INSTRUCTION(26);
                    ffmemop <= INSTRUCTION(25 downto 24);
                    ffiregop1 <= to_integer(unsigned(INSTRUCTION(23 downto 20)));
                    ffiregop2 <= to_integer(unsigned(INSTRUCTION(19 downto 16)));
                    ffimmop <= INSTRUCTION(15 downto 0);
                    -- Save the values of the Register Data.  Again this if or timing operations.
                    ireg1value <= cpuRegs(to_integer(unsigned(INSTRUCTION(23 downto 20)))).Value;
                    ireg2value <= cpuRegs(to_integer(unsigned(INSTRUCTION(19 downto 16)))).Value;

                    if cpuRegs(to_integer(unsigned(INSTRUCTION(23 downto 20)))).OpCode = oNOP 
                        and cpuRegs(to_integer(unsigned(INSTRUCTION(19 downto 16)))).OpCode = oNOP
                    then -- Execute Instruction
                        AluDecodeDone <= '1';
                    else -- Register is locked
                        AluDecodeDone <= '0';
                    end if;


                when EXECUTE_S =>
                    case ffmemop is
                        when REGREG =>
                            a_reg_u := resize(unsigned(ireg1value),33);
                            b_reg_u := resize(unsigned(ireg2value),33);

                        when IMMEDIATE =>
                            if ffiregop2 = 0 then
                                a_reg_u := resize(unsigned(ireg1value),33);
                                b_reg_u := resize(unsigned(ffimmop),33);
                            else
                                a_reg_u := resize(unsigned(ireg2value),33);
                                b_reg_u := resize(unsigned(ffimmop),33);
                            end if;

                        when ABSOLUTE | INDEX =>
                            a_reg_u := resize(unsigned(ireg1value),33);
                            b_reg_u := resize(unsigned(MEM_ARG),33);

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

                        when oRTN =>
                            if ffmemop = REGREG then
                                cpuRegs(ffiregop1).Value <= std_logic_vector(to_unsigned(
                                                        to_integer(unsigned(ireg1value)) + 1, 32));
                            end if;

                        when oRTI =>
                            if ffmemop = REGREG then
                                cpuRegs(interruptSpNum).Value <= std_logic_vector(to_unsigned(
                                                            interruptSpAddrValue + 2, 32));
                            end if;

                        when oADD | oSUB | oMul | oDiv =>
                            if ffflag = '0' then
                                case ffmemop is
                                    when REGREG =>
                                        a_reg_s := signed(ireg1value);
                                        b_reg_s := signed(ireg2value);
                                    when IMMEDIATE =>
                                            if ffiregop2 = 0 then
                                                a_reg_s := signed(ireg1value);
                                                b_reg_s := resize(signed(ffimmop),32);
                                            else
                                                a_reg_s := signed(ireg2value);
                                                b_reg_s := resize(signed(ffimmop),32);
                                            end if;
                                    when ABSOLUTE | INDEX =>
                                        if ffflag = '0' then
                                            a_reg_s := signed(ireg1value);
                                            b_reg_s := signed(MEM_ARG);
                                        end if;
                                    when others =>
                                end case;
                            end if;

                            if ffopcode = oAdd then
                                if ffflag = '0' then
                                    results_reg_s := a_reg_s + b_reg_s;
                                    cpuRegs(ffiregop1).Value <= std_logic_vector(results_reg_s);
                                    cpuRegs(ffiregop1).OpCode <= oAdd;
                                    cpuRegs(ffiregop1).Flag <= '0';
                                    cpuRegs(ffiregop1).Countdown <= 1;
                                    AValS <= resize(a_reg_s,33);
                                    BValS <= resize(b_reg_s,33);

                                else
                                    results_reg_u := a_reg_u + b_reg_u;
                                    cpuRegs(ffiregop1).Value <= std_logic_vector(resize(results_reg_u,32));
                                    RValU <= resize(results_reg_u,33);

                                end if;
                            elsif ffopcode = oSub then
                                if ffflag = '0' then
                                    results_reg_s := a_reg_s - b_reg_s;
                                    cpuRegs(ffiregop1).Value <= std_logic_vector(results_reg_s);
                                    AValS <= resize(a_reg_s,33);
                                    BValS <= resize(b_reg_s,33);
                                    RValS <= resize(results_reg_s,33);

                                else
                                    results_reg_u := a_reg_u - b_reg_u;
                                    cpuRegs(ffiregop1).Value <= std_logic_vector(resize(results_reg_u,32));
                                    AValU <= resize(a_reg_u,33);
                                    BValU <= resize(b_reg_u,33);
                                    RValU <= resize(results_reg_u,33);

                                end if;
                            elsif ffopcode = oMul then
                                if ffflag = '0' then
                                    SMultRegA <= std_logic_vector(a_reg_s);
                                    SMultRegB <= std_logic_vector(b_reg_s);
                                    cpuRegs(ffiregop1).OpCode <= oMul;
                                    cpuRegs(ffiregop1).Flag <= '0';
                                    cpuRegs(ffiregop1).Countdown <= 6;
                                else
                                    UMultRegA <= std_logic_vector(a_reg_u(31 downto 0));
                                    UMultRegB <= std_logic_vector(b_reg_u(31 downto 0));
                                    cpuRegs(ffiregop1).OpCode <= oMul;
                                    cpuRegs(ffiregop1).Flag <= '1';
                                    cpuRegs(ffiregop1).Countdown <= 6;
                                end if;

                            elsif ffopcode = oDiv then
                                if ffflag = '0' then
                                    SDivRegA <= std_logic_vector(a_reg_s);
                                    SDivRegB <= std_logic_vector(b_reg_s);
                                    SDivRegAValid <= '1';
                                    SDivRegBValid <= '1';
                                    SUsrRegNum <= std_logic_vector(to_unsigned(ffiregop1,4));
                                    -- XXX: If remainder is used then need to set the remainder register to oDiv.
                                    cpuRegs(ffiregop1).OpCode <= oDiv;
                                else
                                    UDivRegA <= std_logic_vector(a_reg_u(31 downto 0));
                                    UDivRegB <= std_logic_vector(b_reg_u(31 downto 0));
                                    UDivRegAValid <= '1';
                                    UDivRegBValid <= '1';
                                    UUsrRegNum <= std_logic_vector(to_unsigned(ffiregop1,4));
                                    -- XXX: If remainder is used then need to set the remainder register to oDiv.
                                    cpuRegs(ffiregop1).OpCode <= oDiv;
                                end if;
                            end if;

                        when oAND =>
                            if ffflag = '0' then
                                cpuRegs(ffiregop1).Value <= std_logic_vector(resize(a_reg_u and b_reg_u,32));
                            else
                                cpuRegs(ffiregop1).Value <= std_logic_vector(resize(a_reg_u nand b_reg_u,32));
                            end if;

                        when oOR =>
                            if ffflag = '0' then
                                cpuRegs(ffiregop1).Value <= std_logic_vector(resize(a_reg_u or b_reg_u,32));
                            else
                                cpuRegs(ffiregop1).Value <= std_logic_vector(resize(a_reg_u nor b_reg_u,32));
                            end if;

                        when oXOR =>
                            if ffflag = '0' then
                                cpuRegs(ffiregop1).Value <= std_logic_vector(resize(a_reg_u xor b_reg_u,32));
                            else
                                cpuRegs(ffiregop1).Value <= std_logic_vector(resize(a_reg_u xnor b_reg_u,32));
                            end if;

                        when oSHLR =>
                            if ffflag = '0' then
                                cpuRegs(ffiregop1).Value <= std_logic_vector(resize(a_reg_u sll to_integer(b_reg_u),32));
                            else
                                cpuRegs(ffiregop1).Value <= std_logic_vector(resize(a_reg_u srl to_integer(b_reg_u),32));
                            end if;

                        when oJSR =>
                            case ffmemop is
                                when REGREG =>
                                    cpuRegs(ffiregop1).Value <= std_logic_vector(to_unsigned(
                                                        to_integer(unsigned(ireg1value)) - 1, 32));
                                when IMMEDIATE =>
                                    cpuRegs(ffiregop1).Value <= std_logic_vector(to_unsigned(
                                                        to_integer(unsigned(ireg1value)) - 1, 32));
                                when others =>
                            end case;

                        when oRWIO =>
                            case ffmemop is
                                when REGREG =>
                                    if ffflag = '0' then
                                        cpuRegs(ffiregop1).Value <= IOR_DATA;
                                    end if;
                                when IMMEDIATE =>
                                    if ffflag = '0' then
                                        cpuRegs(ffiregop1).Value <= IOR_DATA;
                                    end if;
                                when others =>
                            end case;

                        when  oIOST =>
                            if ffmemop = REGREG then
                                cpuRegs(ffiregop1).Value <= IO_STATUS;
                            elsif ffmemop = IMMEDIATE then
                                cpuRegs(ffiregop1).Value <= IO_STATUS;
                            end if;

                        when oPUSHPOP =>
                            case ffmemop is
                                when REGREG =>
                                    if ffflag = '0' then -- Push
                                        cpuRegs(ffiregop1).Value <= std_logic_vector(to_unsigned(
                                                            to_integer(unsigned(ireg1value)) - 1, 32));
                                    else -- Pop
                                        cpuRegs(ffiregop1).Value <= std_logic_vector(to_unsigned(
                                                            to_integer(unsigned(ireg1value)) + 1, 32));
                                        cpuRegs(ffiregop2).Value <= MEM_ARG;
                                    end if;
                                when IMMEDIATE =>
                                    if ffflag = '0' then
                                        cpuRegs(ffiregop1).Value <= std_logic_vector(to_unsigned(
                                                            to_integer(unsigned(ireg1value)) - 1, 32));
                                    end if;
                                when others =>
                            end case;
                        
                        when  oSWDM =>
                            if  ffflag = SWDFLAG 
                                and ffmemop = REGREG
                            then
                                cpuRegs(ffiregop1).Value <= statusWord;
                                statusWord <= (others => '0');
                            end if;
    
                        when others =>
                    end case;
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
                    cpuRegs(interruptSpNum).Value <= std_logic_vector(to_unsigned(interruptSpAddrValue - 2, 32));
                when others =>
            end case;
        end if;
    end process alu_proc;

end Behavioral;