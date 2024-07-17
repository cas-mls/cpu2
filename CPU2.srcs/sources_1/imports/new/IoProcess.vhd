----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/29/2023 05:57:00 PM
-- Design Name: 
-- Module Name: Decode - Behavioral
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
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

use xil_defaultlib.Utilities.all;

---------------------------------------------------------------------------
--  Process (Clocked) : io_proc
--  Description: This handles the address, data and statuses for IO.
--  Wire Assignments
--      IO_ADDR     - Address of the IO peripheral.
--      IOW_DATA    - Data to be written to the peripheral.
--      IOW_ENA     - Flag indicating the transfer of data from CPU to peripheral.
--      IOR_ENA     - Flag indicating the data needs to be transferred from peripheral to CPU.
--      Note:   Interrupt driven peripheral should use the Interrupts Processing (No special purpose IO interrupts).
--      Note:   Reading the IO (IOR_DATA) is not performed in this process. it is used by other processes.
--  Used Clocked Wires:
--      ffopcode        - oRWIO / Read Write IO
--      ffflag          - 0 = Read (RIO) / 1 = Write (WIO)
--      ffmemop         - Reg/Reg, Immediate, Absolute, and Index
--      fsm_inst_cycle_p
--          Process States:
--              RESET_STATE_S   - Reset the CPU.
--              DECODE_S        - Instruction Decode and identify operands.
--              EXECUTE_S       - Execute the instruction.
--              CLEANUP_S       - Clean up data after execute.
--  Used Combinational Wires:
--      opcode          oRWIO / Read Write IO
--      flag            0 = Read (RIO) / 1 = Write (WIO)
--      memop           Reg/Reg, Immediate, Absolute, and Index
---------------------------------------------------------------------------

entity IoProcess is
  port (
    SYS_CLK : in std_logic;
    INSTRUCTION : in std_logic_vector(31 downto 0);
    cpuRegs : in reg_type;
    MEM_ARG : in std_logic_vector(31 downto 0);
    fsm_inst_cycle_p : in CYCLETYPE_FSM;

    IOW_ENA : out std_logic;
    IOR_ENA : out std_logic;
    IO_ADDR : out std_logic_vector (7 downto 0);
    IOW_DATA : out std_logic_vector (31 downto 0)

  );

end IoProcess;

architecture Behavioral of IoProcess is

  -- Decode information    
  signal opcode : OPCODETYPE := "00000";
  signal ffopcode : OPCODETYPE := "00000";
  signal flag : std_logic := '0';
  signal ffflag : std_logic := '0';
  signal memop : MEMTYPE;
  signal ffmemop : MEMTYPE;
  signal regop1 : REGTYPE;
  signal iregop1 : integer range 0 to regOpMax;
  signal ffiregop1 : integer range 0 to regOpMax;
  signal ireg1value : std_logic_vector(31 downto 0) := X"00000000";
  signal regop2 : REGTYPE;
  signal iregop2 : integer range 0 to regOpMax;
  signal ffiregop2 : integer range 0 to regOpMax;
  signal ireg2value : std_logic_vector(31 downto 0) := X"00000000";
  signal immop : IMMTYPE;
  signal ffimmop : IMMTYPE;

begin

  opcode <= INSTRUCTION(31 downto 27);
  flag <= INSTRUCTION(26);
  memop <= INSTRUCTION(25 downto 24);
  regop1 <= INSTRUCTION(23 downto 20);
  regop2 <= INSTRUCTION(19 downto 16);
  immop <= INSTRUCTION(15 downto 0);
  iregop1 <= to_integer(unsigned(regop1));
  iregop2 <= to_integer(unsigned(regop2));

  io_proc : process (SYS_CLK)
  begin
    if rising_edge (SYS_CLK) then
      case fsm_inst_cycle_p is
        when RESET_STATE_S =>
          IO_ADDR <= (others => '0');
          IOW_DATA <= (others => '0');
          IOW_ENA <= '0';
          IOR_ENA <= '0';
        when DECODE_S =>

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
          ireg1value <= cpuRegs(iregop1);
          ireg2value <= cpuRegs(iregop2);

          if opcode = oRWIO then
            if flag = '0' then
              IOR_ENA <= '1';
            else
              IOW_ENA <= '1';
            end if;
            case memop is
              when REGREG =>
                IO_ADDR <= cpuRegs(iregop2)(7 downto 0);
              when IMMEDIATE =>
                IO_ADDR <= immop(7 downto 0);
              when ABSOLUTE =>
                IO_ADDR <= cpuRegs(iregop2)(7 downto 0);
              when INDEX =>
                IO_ADDR <= cpuRegs(iregop1)(7 downto 0);
              when others =>
            end case;
          end if;
        when EXECUTE_S =>
          if ffopcode = oRWIO then
            if ffflag = '1' then
              IOW_ENA <= '1';
              case ffmemop is
                when REGREG =>
                  IOW_DATA <= cpuRegs(ffiregop1);
                when IMMEDIATE =>
                  IOW_DATA <= cpuRegs(ffiregop1);
                when ABSOLUTE | INDEX =>
                  IOW_DATA <= MEM_ARG;
                when others =>
              end case;
            else
              IOR_ENA <= '1';
            end if;
          end if;
        when CLEANUP_S =>
          if ffopcode = oRWIO then
            if ffflag = '0' then
              IOR_ENA <= '0';
            else
              IOW_ENA <= '0';
            end if;
          end if;
        when others =>
      end case;

    end if;
  end process;

end Behavioral;