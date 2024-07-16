library IEEE;
library xil_defaultlib;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_1164.ALL;

use xil_defaultlib.Utilities.ALL;

---------------------------------------------------------------------------
--  Process (Clocked) : alu_proc
--  Description:    This handles the updating of the register and is also known as the Arithmatic Logic Unit (ALU).
--  Wire Assignments
--      cpuRegs    - The fast CPU registers.
--  Used Clocked Wires:
--      ffopcode        - Instruction operation
--      ffmemop         - Reg/Reg, Immediate, Absolute, and Index
--      ffiregop1       -
--      ffiregop2       -
--      ffimmop         -
--      ireg1value      - The current value read from the first instruction register.
--      ireg2value      - The current value read from the second instruction register.
--      MEM_DOUTB
--      IOR_DATA
--      IO_STATUS
--      interruptSP
--      fsm_inst_cycle_p
--          Process States:
--              RESET_STATE_S   - Reset the CPU.
--              EXECUTE_S       - Execute the instruction.  To process interrupts, store registers/data.
--              CLEANUP_S       - Clean up data after execute.
--      fsm_interrupt_cycle_p
--          Process States:
--              SAVEENA_S       -
--              JMPADDR_S       -
--  Used Combinational Wires:
---------------------------------------------------------------------------



entity ALU is
    Port (
      SYS_CLK               : IN STD_LOGIC;
      INSTRUCTION           : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      MEM_ARG               : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      fsm_inst_cycle_p      : IN CYCLETYPE_FSM;
      fsm_interrupt_cycle_p : IN INTERRUPT_FSM;
      interruptSPNum        : IN integer range 0 to 31;
      IOR_DATA              : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      IO_STATUS             : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      ireg1value            : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ireg2value            : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      interruptSpAddrValue  : IN integer range 0 to 2**12-1; 
      cpuRegs               : OUT reg_type
      );
  
  end ALU;
  
  architecture Behavioral of ALU is


        -- Decode information    
        signal ffopcode     : OPCODETYPE := "00000";
        signal ffflag       : STD_LOGIC :='0';
        signal ffmemop      : MEMTYPE;
        signal ffiregop1    : integer;
        signal ffiregop2    : integer;
        signal ffimmop      : IMMTYPE;
    

    begin

    alu_proc : process (SYS_CLK)
    begin
        if rising_edge  (SYS_CLK) then
            case fsm_inst_cycle_p is
                when RESET_STATE_S=>
                    cpuRegs <= (others => (others =>'0'));
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

                when EXECUTE_S    =>
                    case ffmemop is
                        when REGREG =>
                            case ffopcode is
                                when oLD =>
                                    cpuRegs(ffiregop1) <= ireg2value;
                                when oRTN =>
                                    cpuRegs(ffiregop1) <= std_logic_vector(to_unsigned(
                                        to_integer(unsigned(ireg1value)) + 1,32));
                                when oRTI =>
                                    cpuRegs(interruptSpNum) <= std_logic_vector(to_unsigned(
                                        interruptSpAddrValue + 2,32));
                                when oADD =>
                                    cpuRegs(ffiregop1) <= 
                                        std_logic_vector(to_signed(
                                            to_integer(signed(ireg1value)) + 
                                            to_integer(signed(ireg2value)),32));
                                when oSUB =>
                                    cpuRegs(ffiregop1) <= 
                                        std_logic_vector(to_signed(
                                            to_integer(signed(ireg1value)) - 
                                            to_integer(signed(ireg2value)),32));
                                when oAND =>
                                    if ffflag = '0' then
                                        cpuRegs(ffiregop1) <= ireg1value and ireg2value;
                                    else
                                        cpuRegs(ffiregop1) <= (ireg1value nand ireg2value);
                                    end if;
                                when oOR =>
                                    if ffflag = '0' then
                                        cpuRegs(ffiregop1) <= ireg1value or ireg2value;
                                    else
                                        cpuRegs(ffiregop1) <= (ireg1value nor ireg2value);
                                    end if;
                                when oXOR =>
                                    if ffflag = '0' then
                                        cpuRegs(ffiregop1) <= ireg1value xor ireg2value;
                                    else
                                        cpuRegs(ffiregop1) <= (ireg1value xnor ireg2value);
                                    end if;
                                when oSHL =>
                                    cpuRegs(ffiregop1) <= std_logic_vector(unsigned(ireg1value) 
                                        sll to_integer(unsigned(ireg2value(4 downto 0))));
                                when oSHR =>
                                    cpuRegs(ffiregop1) <= std_logic_vector(unsigned(ireg1value) 
                                        srl to_integer(unsigned(ireg2value(4 downto 0))));
                                when oJSR =>
                                    cpuRegs(ffiregop1) <= std_logic_vector(to_unsigned(
                                            to_integer(unsigned(ireg1value)) - 1,32));
                                when oRWIO =>
                                    if ffflag = '0' then
                                        cpuRegs(ffiregop1) <= IOR_DATA;
                                    end if;
                                    cpuRegs(0) <= x"000000" & IO_STATUS;
                                when oPUSHPOP =>
                                    if ffflag = '0' then    -- Push
                                        cpuRegs(ffiregop1) <= std_logic_vector(to_unsigned(
                                                to_integer(unsigned(ireg1value)) - 1,32));
                                    else                    -- Pop
                                        cpuRegs(ffiregop1) <= std_logic_vector(to_unsigned(
                                                to_integer(unsigned(ireg1value)) + 1,32));
                                        cpuRegs(ffiregop2) <= MEM_ARG;
                                    end if;
                                when others =>
                            end case;
                        when IMMEDIATE =>
                            case ffopcode is
                                when oLD =>
                                    if ffflag = '1' then
                                        cpuRegs(ffiregop1)(31 downto 16) <= ffimmop;
                                    else
                                        cpuRegs(ffiregop1)(15 downto 0) <= ffimmop;
                                    end if;
                                when oADD =>
                                    if ffiregop2 = 0 then
                                        cpuRegs(ffiregop1) <= 
                                            std_logic_vector(to_signed(to_integer(signed(ireg1value)) + 
                                                to_integer(signed(ffimmop))
                                                ,32));
                                    else
                                        cpuRegs(ffiregop1) <= 
                                            std_logic_vector(to_signed(
                                                to_integer(signed(ireg1value)) + 
                                                to_integer(signed(ireg2value)) +
                                                to_integer(signed(ffimmop))
                                                ,32));
                                    end if;
                                when oSUB =>
                                    if ffiregop2 = 0 then
                                        cpuRegs(ffiregop1) <= 
                                            std_logic_vector(to_signed(
                                                to_integer(signed(ireg1value)) - 
                                                to_integer(signed(ffimmop))
                                                ,32));
                                    else
                                        cpuRegs(ffiregop1) <= 
                                            std_logic_vector(to_signed(
                                                to_integer(signed(ireg1value)) - 
                                                to_integer(signed(ireg2value)) -
                                                to_integer(signed(ffimmop))
                                                ,32));
                                    end if;
                                when oAND =>
                                    if ffflag = '0' and ffiregop2 = 0 then
                                        cpuRegs(ffiregop1) <= ireg1value and (X"1111" & ffimmop);
                                    elsif ffflag = '1' and ffiregop2 = 0 then
                                        cpuRegs(ffiregop1) <= ireg1value nand (X"1111" & ffimmop);
                                    elsif ffflag = '0' and ffiregop2 = 0 then
                                        cpuRegs(ffiregop1) <= ireg1value and ireg2value and (X"1111" & ffimmop);
                                    else
                                        cpuRegs(ffiregop1) <= ireg1value nand (ireg2value nand (X"1111" & ffimmop));
                                    end if;
                                when oOR =>
                                    if ffflag = '0' and ffiregop2 = 0 then
                                        cpuRegs(ffiregop1) <= ireg1value or (X"0000" & ffimmop);
                                    elsif ffflag = '1' and ffiregop2 = 0 then
                                        cpuRegs(ffiregop1) <= ireg1value nor (X"0000" & ffimmop);
                                    elsif ffflag = '0' and ffiregop2 = 0 then
                                        cpuRegs(ffiregop1) <= ireg1value or ireg2value or (X"1111" & ffimmop);
                                    else
                                        cpuRegs(ffiregop1) <= ireg1value nor (ireg2value nor (X"1111" & ffimmop));
                                    end if;
                                when oXOR =>
                                    if ffflag = '0' and ffiregop2 = 0 then
                                        cpuRegs(ffiregop1) <= ireg1value xor (X"0000" & ffimmop);
                                    elsif ffflag = '1' and ffiregop2 = 0 then
                                        cpuRegs(ffiregop1) <= ireg1value xnor (X"0000" & ffimmop);
                                    elsif ffflag = '0' and ffiregop2 = 0 then
                                        cpuRegs(ffiregop1) <= ireg1value xor ireg2value xor (X"1111" & ffimmop);
                                    else
                                        cpuRegs(ffiregop1) <= ireg1value xnor (ireg2value xnor (X"1111" & ffimmop));
                                    end if;
                                when oSHL =>
                                    cpuRegs(ffiregop1) <= std_logic_vector(unsigned(ireg1value) 
                                        sll to_integer(unsigned(ffimmop(4 downto 0))));
                                when oSHR =>
                                    cpuRegs(ffiregop1) <= std_logic_vector(unsigned(ireg1value) 
                                        srl to_integer(unsigned(ffimmop(4 downto 0))));
                                when oJSR =>
                                    cpuRegs(ffiregop1) <= std_logic_vector(to_unsigned(
                                            to_integer(unsigned(ireg1value)) - 1,32));
                                when oRWIO =>
                                    if ffflag = '0' then
                                        cpuRegs(ffiregop1) <= IOR_DATA;
                                        cpuRegs(0) <= x"000000" & IO_STATUS;
                                    else
                                        cpuRegs(0) <= x"000000" & IO_STATUS;
                                    end if;
                                when oPUSHPOP =>
                                    if ffflag = '0' then
                                        cpuRegs(ffiregop1) <= std_logic_vector(to_unsigned(
                                                to_integer(unsigned(ireg1value)) - 1,32));
                                    end if;
                                when others =>
                            end case;
                        when ABSOLUTE  | INDEX =>
                            case ffopcode is
                                when oLD =>
                                    cpuRegs(ffiregop1) <= MEM_ARG;
                                when oSTR =>
                                when oADD =>
                                    cpuRegs(ffiregop1) <= 
                                        std_logic_vector(to_signed(
                                            to_integer(signed(ireg1value)) + 
                                            to_integer(signed(MEM_ARG)),32));
                                when oSUB =>
                                    cpuRegs(ffiregop1) <= 
                                        std_logic_vector(to_signed(
                                            to_integer(signed(ireg1value)) - 
                                            to_integer(signed(MEM_ARG)),32));
                                when oAND =>
                                    if ffflag = '0' then
                                        cpuRegs(ffiregop1) <= ireg1value and MEM_ARG;
                                    else
                                        cpuRegs(ffiregop1) <= ireg1value nand MEM_ARG;
                                    end if;
                                when oOR =>
                                    if ffflag = '0' then
                                        cpuRegs(ffiregop1) <= ireg1value or MEM_ARG;
                                    else
                                        cpuRegs(ffiregop1) <= ireg1value nor MEM_ARG;
                                    end if;
                                when oXOR =>
                                    if ffflag = '0' then
                                        cpuRegs(ffiregop1) <= ireg1value xor MEM_ARG;
                                    else
                                        cpuRegs(ffiregop1) <= ireg1value xnor MEM_ARG;
                                    end if;
                                when oSHL =>
                                    cpuRegs(ffiregop1) <= std_logic_vector(unsigned(ireg1value) 
                                        sll to_integer(unsigned(MEM_ARG(4 downto 0))));
                                when oSHR =>
                                    cpuRegs(ffiregop1) <= std_logic_vector(unsigned(ireg1value) 
                                        srl to_integer(unsigned(MEM_ARG(4 downto 0))));
                                when oRWIO =>
                                    if ffflag = '0' then
                                        cpuRegs(0) <= x"000000" & IO_STATUS;
                                    else
                                        cpuRegs(0) <= x"000000" & IO_STATUS;
                                    end if;
                                when others =>
                            end case;
                        when others =>
                    end case;
                when CLEANUP_S =>
                    if ffopcode = oRWIO then
                        cpuRegs(0) <= x"000000" & IO_STATUS;
                    end if;
                when others =>
            end case;

            case fsm_interrupt_cycle_p is
                when JUMP_S =>
                    cpuRegs(interruptSpNum) <= std_logic_vector(to_unsigned(interruptSpAddrValue - 2, 32));
                when others =>
            end case;
        end if;
    end process alu_proc;

end Behavioral;
