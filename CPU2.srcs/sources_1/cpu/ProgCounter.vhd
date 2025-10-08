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
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

use xil_defaultlib.Utilities.ALL;
use xil_defaultlib.AxiMemory.all;
use xil_defaultlib.DebugPkg.all;

---------------------------------------------------------------------------
-- ### Program Counter

-- This handles the program counter (PC) and memory access for obtaining the instruction.  This sets the address of the next instruction (Port A memory access).   This is the fetch.

-- #### Instructions

-- 	* oJMP - Unconditional Jump
-- 	* oJSR - Jump and store PC (Jump to Subroutine)
-- 	* oRTN - Return from JSR (Return from Subroutine)
-- 	* oRTI - Return from Interrupt
-- 	* oBE - Branch Equal, Zero, Not Equal, or Not Zero
-- 	* oBLT - Branch Less Than, Negative, Greater than  and Equal, Not Negative
-- 	* oBGT - Branch Greater Than, Positive, Less than  and Equal, Not Positive

-- #### Wire Assignments (outputs)

-- | Signal          | Description                                                  |
-- | --------------- | ------------------------------------------------------------ |
-- | MEM_ADDRA       | The address to Read or Write memory.                         |
-- | MEM_ENA         | Enable at Address and disable during the Decode for branches. |
-- | MEM_WEA         | Always 0 (Read Only)                                         |
-- | Program Counter | Program counter (address) of the current executed statement. |

-- Note:  Actually setting MEM_DOUTA (writting memory) is not part of this process.
-- Note: The Program Counter is a Combinational output of the internal ProgCounterLocal.

-- #### Used Wires (inputs):

-- | Signal                | Description                                                  |
-- | --------------------- | ------------------------------------------------------------ |
-- | INSTRUCTION           | Current Fetched Instruction                                  |
-- | cpuRegs               | CPU Fast Registers                                           |
-- | fsm_inst_cycle_p      | Process States:                                              |
-- |                       | RESET_STATE_S  - Reset the CPU.                              |
-- |                       | ADDRESS_S    - Setting the address from the program counter.  This sets the clears the memory enable. |
-- |                       | DECODE_S     - Instruction Decode and identify operands.  Sets up the Memory addresses and write data. |
-- |                       | EXECUTE_S    - Execute the instruction.  To process interrupts, store registers/data. |
-- | fsm_interrupt_cycle_p | Process States:                                              |
-- |                       | JUMP_S      - Changes the program counter to address from the interrupt vector. |

-- #### Internal Wires:

-- | Signal           | Description                                                  |
-- | ---------------- | ------------------------------------------------------------ |
-- | opcode/ffopcode  | Instruction operation                                        |
-- | ffflag           | Multiple use flag to modify the instruction operation (e.g., negative logic) |
-- | ffmemop          | Memory access operation (Reg/Reg, Immediate, absolute and indexed). |
-- | ffiregop1        | Instruction identified first register.                       |
-- | ffiregop2        | Instruction identified second register.                      |
-- | ireg1value       | Register value of the first instruction register.            |
-- | ireg2value       | Register value of the second instruction register.           |
-- | ffimmop          | Immediate value from the instruction.                        |
-- | ProgCounterLocal | Local Program Counter used for calculations.                 |

-- Note: During the Decode state, the MEM_DOUTA is separated into opcode, flag, memop, regop1, regop2, and immop combinational wires.  The ff* are clocked flip-flop registers that store the values to be used in other states.
---------------------------------------------------------------------------

entity ProgCounter is
    Port ( 
        SYS_CLK               : IN STD_LOGIC;
        INSTRUCTION           : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        cpuRegs               : IN REG_TYPE;

        fsm_inst_cycle_p      : IN CYCLETYPE_FSM;
        fsm_inst_cycle_n      : IN CYCLETYPE_FSM;
        fsm_interrupt_cycle_p : IN INTERRUPT_FSM;
        MEM_ARG               : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        STACK_ARG             : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    
        -- AXI Memory Interface
        PC_MEMORY_OUT          : OUT AXI4_MEMORY_READ_OUT_TYPE_REC;
        PC_MEMORY_IN         : IN  AXI4_MEMORY_READ_IN_TYPE_REC;

        ARG_MEMORY_READ_OUT : in AXI4_MEMORY_READ_OUT_TYPE_REC;
        ARG_MEMORY_READ_IN  : in AXI4_MEMORY_READ_IN_TYPE_REC;


        ProgramCounter        : OUT PCTYPE;
        JumpDisablePipline    : OUT STD_LOGIC;
        AluRegisterLocked         : in std_logic;
        DEBUGIN     : in DEBUGINTYPE := DEBUGIN_DEFAULTS
    );
end ProgCounter;

architecture Behavioral of ProgCounter is

    -- Decode information    
    signal opcode : OPCODETYPE := "00000";
    signal ffopcode : OPCODETYPE := "00000";
    signal flag : STD_LOGIC := '0';
    signal ffflag : STD_LOGIC :='0';
    signal ffmemop : MEMTYPE;
    signal ffiregop1 : integer range 0 to regOpMax;
    signal ireg1value : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
    signal ffiregop2 : integer range 0 to regOpMax;
    signal ireg2value : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
    signal ffimmop: IMMTYPE;

    signal ProgCounterLocal : PCTYPE;

    signal FirstRTIData : boolean := true;

    -- attribute keep : string;
    -- attribute MARK_DEBUG : string;
    -- attribute keep of ProgCounterLocal : signal is "TRUE";
    -- attribute MARK_DEBUG of ProgCounterLocal : signal is "TRUE";
    -- attribute keep of ProgramCounter : signal is "TRUE";
    -- attribute MARK_DEBUG of ProgramCounter : signal is "TRUE";


begin

    opcode <= INSTRUCTION(31 downto 27);
    flag <= INSTRUCTION(26);

    -- Output Values
    ProgramCounter <= ProgCounterLocal;
  
    procCounter_proc : process (SYS_CLK)
        variable varLocalProgCounter : PCTYPE := X"000";
        variable varJumpExpected : boolean := false;

    begin
        if rising_edge  (SYS_CLK) then

            varJumpExpected := false;
            PC_MEMORY_OUT <= 
                ClearReadAddress(
                    PC_MEMORY_OUT, 
                    PC_MEMORY_IN);

            if fsm_inst_cycle_n = DECODE_S THEN
                PC_MEMORY_OUT.s_axi_rready <= '0';
            end if;

            case fsm_inst_cycle_p is
                when RESET_STATE_S=>
                    ProgCounterLocal <= X"000";
                    JumpDisablePipline <= '1';
                    PC_MEMORY_OUT <= AXI4_MEMORY_READ_OUT_DEFAULTS;

                when INSTFETCH_S =>

                when DECODE_S     =>

                    -- Maintain Flip-Flop (Memory) protions of the instruction.
                    -- This removes the timing violations and make the processor faster.
                    -- Might remove the combinatorial logic which should not be used after this cycle.
                    ffopcode    <= INSTRUCTION(31 downto 27);
                    ffflag      <= INSTRUCTION(26);
                    ffmemop     <= INSTRUCTION(25 downto 24);
                    ffiregop1   <= to_integer(unsigned(INSTRUCTION(23 downto 20)));
                    ffiregop2   <= to_integer(unsigned(INSTRUCTION(19 downto 16)));
                    ffimmop     <= INSTRUCTION(15 downto 0);
                    -- Save the values of the Register Data.  Again this ifor timing operations.
                    ireg1value <= cpuRegs(to_integer(unsigned(INSTRUCTION(23 downto 20)))).Value;
                    ireg2value <= cpuRegs(to_integer(unsigned(INSTRUCTION(19 downto 16)))).Value;
                    FirstRTIData <= false;

                when MEMFETCH_S =>
                    if  ffopcode = oRTI then
                        if IsReadDataValid(
                                ARG_MEMORY_READ_IN, 
                                ARG_MEMORY_READ_OUT, 
                                MEM_ID_STACK) then
                            if not FirstRTIData then
                                FirstRTIData <= true;
                                varLocalProgCounter := unsigned(STACK_ARG(ProgCounterLocal'Range));
                                varJumpExpected := true;
                            end if;
                        end if;
                    end if;

                when EXECUTE_S    =>
                    if AluRegisterLocked = '0' 
                    then -- Execute Instruction

                        case ffopcode is
                            when oJMP | oJSR =>
                                case ffmemop is
                                    when REGREG     =>
                                        varLocalProgCounter := unsigned(ireg1value(ProgCounterLocal'Range)); 
                                    when IMMEDIATE  =>
                                        varLocalProgCounter := unsigned(ffimmop(ProgCounterLocal'Range));
                                    when ABSOLUTE | INDEX =>
                                        varLocalProgCounter := unsigned(MEM_ARG(ProgCounterLocal'Range));
                                    when others     =>
                                end case;
                                varJumpExpected := true;

                            when oRTI =>
                                varJumpExpected := true;

                            when oRTN =>
                                varLocalProgCounter := unsigned(STACK_ARG(ProgCounterLocal'Range));
                                varJumpExpected := true;
                                
                            when oBE =>
                                case ffmemop is
                                    when IMMEDIATE  =>
                                        if  ffiregop2 /= 0 
                                            and  ((ffflag = '0' and ireg1value = ireg2value)
                                            or (ffflag = '1' and ireg1value /= ireg2value)) then
                                                varLocalProgCounter := unsigned(ffimmop(ProgCounterLocal'Range));
                                                varJumpExpected := true;
                                        elsif ffiregop2 = 0 
                                            and  ((ffflag = '0' and signed(ireg1value) = 0)
                                            or (ffflag = '1' and signed(ireg1value) /= 0)) then
                                                varLocalProgCounter := unsigned(ffimmop(ProgCounterLocal'Range));
                                                varJumpExpected := true;
                                        else
                                            varLocalProgCounter := ProgCounterLocal + 1;
                                        end if;
                                    when ABSOLUTE | INDEX =>
                                        if  ffiregop2 /= 0 
                                            and  ((ffflag = '0' and ireg1value = ireg2value)
                                            or (ffflag = '1' and ireg1value /= ireg2value)) then
                                                varLocalProgCounter := unsigned(MEM_ARG(ProgCounterLocal'Range));
                                                varJumpExpected := true;
                                        elsif ffiregop2 = 0 
                                            and  ((ffflag = '0' and signed(ireg1value) = 0)
                                            or (ffflag = '1' and signed(ireg1value) /= 0)) then
                                                varLocalProgCounter := unsigned(MEM_ARG(ProgCounterLocal'Range));
                                                varJumpExpected := true;
                                        else
                                            varLocalProgCounter := ProgCounterLocal + 1;
                                        end if;
                                    when others     =>
                                end case;

                            when oBLT =>
                                case ffmemop is
                                    when IMMEDIATE  =>
                                        if ffiregop2 /= 0 
                                            and ((ffflag = '0' and ireg1value < ireg2value) 
                                                or (ffflag = '1' and ireg1value >= ireg2value)) 
                                                then
                                                    varLocalProgCounter := unsigned(ffimmop(ProgCounterLocal'Range));
                                                    varJumpExpected := true;
                                        elsif ffiregop2 = 0 
                                            and ((ffflag = '0' and signed(ireg1value) < 0) 
                                                or (ffflag = '1' and signed(ireg1value) >= 0))
                                                then
                                                    varLocalProgCounter := unsigned(ffimmop(ProgCounterLocal'Range));
                                                    varJumpExpected := true;
                                        else
                                            varLocalProgCounter := ProgCounterLocal + 1;
                                        end if;
                                    when ABSOLUTE | INDEX =>
                                        if ffiregop2 /= 0 
                                            and ((ffflag = '0' and ireg1value < ireg2value) 
                                                or (ffflag = '1' and ireg1value >= ireg2value)) 
                                            then
                                                varLocalProgCounter := unsigned(MEM_ARG(ProgCounterLocal'Range));
                                                varJumpExpected := true;
                                        elsif ffiregop2 = 0 
                                            and ((ffflag = '0' and signed(ireg1value) < 0) 
                                                or (ffflag = '1' and signed(ireg1value) >= 0))
                                        then
                                            varLocalProgCounter := unsigned(MEM_ARG(ProgCounterLocal'Range));
                                            varJumpExpected := true;
                                        else
                                            varLocalProgCounter := ProgCounterLocal + 1;
                                        end if;
                                    when others     =>
                                end case;

                            when oBGT =>
                                case ffmemop is
                                    when IMMEDIATE  =>
                                        if ffiregop2 /= 0 
                                            and  ((ffflag = '0' and ireg1value > ireg2value) 
                                            or (ffflag = '1' and ireg1value <= ireg2value)) then
                                                varLocalProgCounter := unsigned(ffimmop(ProgCounterLocal'Range));
                                                varJumpExpected := true;
                                        elsif ffiregop2 = 0 
                                            and  ((ffflag = '0' and signed(ireg1value) > 0) 
                                            or (ffflag = '1' and signed(ireg1value) <= 0)) then
                                                varLocalProgCounter := unsigned(ffimmop(ProgCounterLocal'Range));
                                                varJumpExpected := true;
                                        else
                                            varLocalProgCounter := ProgCounterLocal + 1;
                                        end if;
                                    when ABSOLUTE | INDEX =>
                                        if ffiregop2 /= 0 
                                            and  ((ffflag = '0' and ireg1value > ireg2value) 
                                            or (ffflag = '1' and ireg1value <= ireg2value)) then
                                                varLocalProgCounter := unsigned(MEM_ARG(ProgCounterLocal'Range));
                                                varJumpExpected := true;
                                        elsif ffiregop2 = 0 
                                            and  ((ffflag = '0' and signed(ireg1value) > 0) 
                                            or (ffflag = '1' and signed(ireg1value) <= 0)) then
                                                varLocalProgCounter := unsigned(MEM_ARG(ProgCounterLocal'Range));
                                                varJumpExpected := true;
                                        else
                                            varLocalProgCounter := ProgCounterLocal + 1;
                                        end if;
                                    when others     =>
                                end case;

                            when others =>
                                varLocalProgCounter := ProgCounterLocal + 1;
                        end case;
                    else
                        ireg1value <= cpuRegs(ffiregop1).Value;
                    end if;
                when DEBUGSTABLEIZE_S =>
                when DEBUGWAIT_S =>
                    if  DEBUGIN.UpdateValue.Valid = '1' then
                        if DEBUG_DATA'VAL(DEBUGIN.UpdateValue.Number) = DBG_PROG_COUNTER
                        then
                            varLocalProgCounter := unsigned(DEBUGIN.UpdateValue.Value(ProgCounterLocal'Range));
                        end if;
                    end if;
                when others =>
            end case;

            case fsm_interrupt_cycle_p is
                when JUMP2_S       =>
                    varLocalProgCounter := unsigned(MEM_ARG(ProgCounterLocal'Range));
                when others =>
            end case;

            if fsm_interrupt_cycle_p = JUMP2_S
                or (fsm_inst_cycle_n = EXECUTE_S
                    and not varJumpExpected)
            then
                ProgCounterLocal <= varLocalProgCounter;
                PC_MEMORY_OUT <= SetReadAddress(
                    PC_MEMORY_OUT, 
                    STD_LOGIC_VECTOR(resize(unsigned(varLocalProgCounter), 12)), 
                    MEM_ID_PC);

            elsif fsm_inst_cycle_n = INSTFETCH_S and varJumpExpected then 
                ProgCounterLocal <= varLocalProgCounter;
                PC_MEMORY_OUT <= SetReadAddress(
                    PC_MEMORY_OUT, 
                    STD_LOGIC_VECTOR(resize(unsigned(varLocalProgCounter), 12)), 
                    MEM_ID_PC);
            end if;
            
        end if;
    end process procCounter_proc;
end Behavioral;