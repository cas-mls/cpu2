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

LIBRARY IEEE;
LIBRARY xil_defaultlib;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

USE xil_defaultlib.Utilities.ALL;

---------------------------------------------------------------------------
-- ### IO Processing

--  This handles the address, data, and statuses for IO.

-- #### Instructions

--  * oRWIO - Interface with the IO signals.

-- #### Wire Assignments (outputs)

-- | Signal   | Description                                                  |
-- | -------- | ------------------------------------------------------------ |
-- | IO_ADDR  | Address of the IO peripheral.                                |
-- | IOW_DATA | Data to be written to the peripheral.                        |
-- | IOW_ENA  | Flag indicating the transfer of data from CPU to peripheral. |
-- | IOR_ENA  | Flag indicating the data needs to be transferred from peripheral to CPU. |

-- Note:  Interrupt driven peripheral should use the Interrupts Processing (No special purpose IO interrupts).
-- Note:  Reading the IO (IOR_DATA) is not performed in this process. it is used by other processes.

-- #### Used Wires (Inputs)

-- | Signal           | Description                                                  |
-- | ---------------- | ------------------------------------------------------------ |
-- | INSTRUCTION      | Instruction operation                                        |
-- | MEM_ARG          | The current memory argument from decode.                     |
-- | fsm_inst_cycle_p | Process States:                                              |
-- |                  | RESET_STATE_S           - Reset the CPU.                     |
-- |                  | DECODE_S                    - Instruction Decode and identify operands. |
-- |                  | EXECUTE_S               - Execute the instruction.  To process interrupts, store registers/data. |
-- |                  | CLEANUP_S               - Clean up data after execute.       |
-- | cpuRegs          | The fast CPU registers.                                      |

-- #### Internal Wires:

-- | Signal                   | Description                                      |
-- | ------------------------ | ------------------------------------------------ |
-- | flag/ffflag              | Multiple use flag (e.g., negative logic)         |
-- | opcode/ffopcode          | Instruction operation                            |
-- | memop/ffmemop            | Memory access operation.                         |
-- | regop1/iregop1/ffiregop1 | Instruction identified first register.           |
-- | ireg1value               | Value of the Register pointed to by instruction. |
-- | regop2/iregop2/ffiregop2 | Instruction identified second register.          |
-- | ireg2value               | Value of the Register pointed to by instruction. |
-- | immop/ffimmop            | Immediate value from the instruction.            |
---------------------------------------------------------------------------

ENTITY IoProcess IS
    PORT (
        SYS_CLK : IN STD_LOGIC;
        INSTRUCTION : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        cpuRegs : IN REG_TYPE;
        MEM_ARG : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        fsm_inst_cycle_p : IN CYCLETYPE_FSM;

        IOW_ENA : OUT STD_LOGIC;
        IOR_ENA : OUT STD_LOGIC;
        IO_ADDR : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        IOW_DATA : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        IO_STATUS_REQ : OUT STD_LOGIC
    );

END IoProcess;

ARCHITECTURE Behavioral OF IoProcess IS

    -- Decode information    
    SIGNAL opcode : OPCODETYPE := "00000";
    SIGNAL ffopcode : OPCODETYPE := "00000";
    SIGNAL flag : STD_LOGIC := '0';
    SIGNAL ffflag : STD_LOGIC := '0';
    SIGNAL memop : MEMTYPE;
    SIGNAL ffmemop : MEMTYPE;
    SIGNAL regop1 : REGTYPE;
    SIGNAL iregop1 : INTEGER RANGE 0 TO regOpMax;
    SIGNAL ffiregop1 : INTEGER RANGE 0 TO regOpMax;
    SIGNAL ireg1value : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
    SIGNAL regop2 : REGTYPE;
    SIGNAL iregop2 : INTEGER RANGE 0 TO regOpMax;
    SIGNAL ffiregop2 : INTEGER RANGE 0 TO regOpMax;
    SIGNAL ireg2value : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
    SIGNAL immop : IMMTYPE;
    SIGNAL ffimmop : IMMTYPE;

BEGIN

    opcode <= INSTRUCTION(31 DOWNTO 27);
    flag <= INSTRUCTION(26);
    memop <= INSTRUCTION(25 DOWNTO 24);
    regop1 <= INSTRUCTION(23 DOWNTO 20);
    regop2 <= INSTRUCTION(19 DOWNTO 16);
    immop <= INSTRUCTION(15 DOWNTO 0);
    iregop1 <= to_integer(unsigned(regop1));
    iregop2 <= to_integer(unsigned(regop2));

    io_proc : PROCESS (SYS_CLK)
    BEGIN
        IF rising_edge (SYS_CLK) THEN

            -- Check for any additional processing after the execute state.
            -- This will run concurrent with the next instruction fetch.
            FOR reg IN cpuRegs'RANGE LOOP
                IF cpuRegs(reg).OpCode = oRWIO
                    OR cpuRegs(reg).OpCode = oIOST
                    THEN
                    IF cpuRegs(reg).Flag = '0' THEN
                        IOR_ENA <= '0';
                    ELSE
                        IOW_ENA <= '0';
                    END IF;
                    IF cpuRegs(reg).OpCode = oIOST THEN
                        IO_STATUS_REQ <= '0';
                    END IF;
                END IF;
            END LOOP;

            CASE fsm_inst_cycle_p IS
                WHEN RESET_STATE_S =>
                    IO_ADDR <= (OTHERS => '0');
                    IOW_DATA <= (OTHERS => '0');
                    IOW_ENA <= '0';
                    IOR_ENA <= '0';
                WHEN DECODE_S =>

                    -- Maintain Flip-Flop (Memory) protions of the instruction.
                    -- This removes the timing violations and make the processor faster.
                    -- Might remove the combinatorial logic which should not be used after this cycle.
                    ffopcode <= opcode;
                    ffmemop <= memop;
                    ffflag <= flag;
                    ffiregop1 <= iregop1;
                    ffiregop2 <= iregop2;
                    ffimmop <= immop;
                    -- Save the values of the Register Data.  Again this is for timing operations.
                    ireg1value <= cpuRegs(iregop1).Value;
                    ireg2value <= cpuRegs(iregop2).Value;

                    IF opcode = oRWIO
                        OR opcode = oIOST
                    THEN
                        IF flag = '0' THEN
                            IOR_ENA <= '1';
                        -- ELSE
                        --     IOW_ENA <= '1';
                        END IF;
                        IF opcode = oIOST THEN
                            IO_STATUS_REQ <= '1';
                        END IF;
                        CASE memop IS
                            WHEN REGREG =>
                                IO_ADDR <= cpuRegs(iregop2).Value(7 DOWNTO 0);
                            WHEN IMMEDIATE =>
                                IO_ADDR <= immop(7 DOWNTO 0);
                            WHEN ABSOLUTE =>
                                IO_ADDR <= cpuRegs(iregop2).Value(7 DOWNTO 0);
                            WHEN INDEX =>
                                IO_ADDR <= cpuRegs(iregop1).Value(7 DOWNTO 0);
                            WHEN OTHERS =>
                        END CASE;
                    END IF;
                WHEN EXECUTE_S =>
                    IF ffopcode = oRWIO THEN
                        IF ffflag = '1' THEN
                            IOW_ENA <= '1';
                            CASE ffmemop IS
                                WHEN REGREG =>
                                    IOW_DATA <= ireg1value;
                                WHEN IMMEDIATE =>
                                    IOW_DATA <= ireg1value;
                                WHEN ABSOLUTE | INDEX =>
                                    IOW_DATA <= MEM_ARG;
                                WHEN OTHERS =>
                            END CASE;
                        ELSE
                            IOR_ENA <= '1';
                        END IF;
                    END IF;

                WHEN OTHERS =>
            END CASE;

        END IF;
    END PROCESS;

END Behavioral;