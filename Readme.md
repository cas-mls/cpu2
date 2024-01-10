

# Craig's CPU

This is a simple CPU architecture that I used to verify that I understand how to use FPGAs, VHDL, and write a CPU.  This is my largest project to date.

## Hardware

## Software

## IPs

## Principles

1. Instructions are the same length.
1. Memory is accessed in the same length as Instructions.  Word and Instruction length is 32 bits.
1. All instructions contain the same fields.  Some fields are not used for some instructions.
1. Each instruction contains 2 register fields.
1. Only the store commands will update memory.
1. There will be 16 registers.
1. No status flags are required.  Branches compare 2 registers.

## Instruction Format

|              | Opcode | Flag         | Access <br />(Memory)                                        | Register 1                | Register 2     | Immediate / <br />Address |
| ------------ | ------ | ------------ | ------------------------------------------------------------ | ------------------------- | -------------- | ------------------------- |
| Bit Position | 31-27  | 26           | 25-24                                                        | 23-20                     | 19-16          | 15-0                      |
| Number Bits  | 5      | 1            | 2                                                            | 4                         | 4              | 16                        |
| Description  |        | Hi/Low / Not | 0 = Register / Register<br />1 = Immediate<br />2 = Absolute<br />3 = Indexed | Destination / Accumulator | Source / Index |                           |

***Recommendation: R0 not be used as a user register.***

### Opcode

There are 5 bits for the opcode.  

### Flag

High 1/2 word = 1, Low 1/2 Word = 0

1 = NOT for the following instructions.

### Access (Memory)

### Register 1

### Register 2

Need to talk about Register 0.

### Immediate

limited to 16 bits. It can only load 1/2 word.

## Architecture / Design

### Cycles

The operation cycles in the order: PREFETCH, WAITS, FETCH, DECODE, MEMRWAIT, MEMR, EXECUTE, and MEMW.  Some instructions do not use all of the cycles.  Example: the MEMW only is used during Read / Write IO operations, other operations completely skipped this cycle.  Another exception MEMRWAIT and MEMR cycle are skipped when the operation is not a Memory read (Access / Memory operations 2 and 3).

During each cycle, the Access (Memory) value is selected (Case statement) and then the Opcode is selected (Case).  This is opposite to the normal method of CPU operation (Opcode first, Memory second).

#### PREFETCH

Sets the instruction address.

Start interrupt processing

#### WAITS

Wait for instruction data.

#### FETCH

Wait for instruction data.

#### DECODE

Instruction Data is available and the Instruction is separated into different fields.

The main purpose is to get the values required to perform the operations.  For Memory operations 0 (Register/Register), the register values are obtained.  For Memory Operation 1 the Registers and the Immediate values.  For Memory Operation 2, the Immediate value is used as the Memory address.  For Memory Operation 3, the Register and the Immediate values are added and used as the Memory address.

#### MEMRWAIT

Wait for Read for Access (Memory) types 2 and 3.

The Return from Interrupt (RTI) operation reads the stack for the Interrupt Mask.

#### MEMR

Wait for Read for Access (Memory) types 2 and 3. 

#### EXECUTE

Perform the operations.

#### MEMW

Perform additional items after Execute.  Read and Write operations are the only operations that use this cycle state.

## Instructions

| Opcode                                                       | Bits  | Flag              | Access (Memory) #0 <u>Register / Register</u>     | Access (Memory) #1 <u>Immediate</u>                          | Access (Memory) #2 <u>Absolute Memory</u>               | Access (Memory) #3 <u>Index Memory</u>                       |                                                              |
| ------------------------------------------------------------ | ----- | ----------------- | ------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| NOOP                                                         | 00000 | NA                | NA                                                | NA                                                           | NA                                                      | NA                                                           |                                                              |
| ld (Load)                                                    | 00010 | High Bits (16-31) | R2 → R1                                           | Imm → R1                                                     | mem(imm) → R1                                           | mem(r2+imm) → R1                                             |                                                              |
| st (Store)                                                   | 00100 | NA                | NA                                                | NA                                                           | R1 → mem(imm)                                           | R1 → mem(r2+imm)                                             |                                                              |
| jmp (Jump)                                                   | 00110 | NA                | R1 → PC                                           | Imm → PC                                                     | mem(imm) → PC                                           | mem(r2 + mem) → PC                                           |                                                              |
| jsr (Jump Subroutine)                                        | 01000 | NA                | PC+1 → mem(R1), <br />R1-1 → R1, <br />R2 → PC    | PC+1 → mem(R1), <br />R1-1 → R1, <br />Imm → PC              | NA                                                      | NA                                                           | R1 is the  Stack Pointer                                     |
| rtn (Return)                                                 | 01010 | NA                | R1+1 → R1, <br />mem(R1) → PC                     | NA                                                           | NA                                                      | NA                                                           | R1 is the  Stack Pointer                                     |
| be<br />bne (not flag)<br />bz (R2=0)<br />bnz (R2=0, Flag=1) | 01100 | Not               | NA                                                | Imm → PC                                                     | mem(imm) → PC                                           | NA                                                           | R2 <> 0: R1 = R2 R1<>R2 (Flag=1)<br/>R2 = 0: R1 = 0 / R1 <> 0 (Flag=1) |
| bl<br />bge (not flag)<br />bn (R2=0)                        | 01110 | Not               | NA                                                | Imm → PC                                                     | mem(imm) → PC                                           | NA                                                           | R2 <> 0: R1 < R2 / R1>=R2 (Flag =1)<br/>R2 = 0: R1 < 0 / R1 >= 0 (Flag=1) |
| bg<br />ble (not flag)<br />bp (R2=0)                        | 10000 | Not               | NA                                                | Imm → PC                                                     | mem(imm) → PC                                           | NA                                                           | R2 <> 0: R1 > R2 / R1<=R2 (Flag=1)<br/>R2 = 0: R1 > 0 / R1 <= 0 (Flag=1) |
| push                                                         | 10010 | NA                | R2 → mem(R1), <br />R1-1 → R1                     | Imm → mem(R1), <br />R1-1 → R1                               | NA                                                      | NA                                                           | Memory Type 2 and 3 (might be possible with additional cycles) |
| pop                                                          | 10100 | NA                | R1+1 → R1, <br />mem(R1) → R2                     | NA                                                           | NA                                                      | NA                                                           | Memory Type 2 and 3 (might be possible with additional cycles) |
| rio (Read IO)                                                | 10110 | NA                | R2 → IOAddr,<br />IOData →  R1,<br /> Status → R0 | Imm → IOAddr, <br />IOData → R1, <br />Status → R0           | R2 → IOAddr,<br /> IOData → mem(imm), <br />Status → R0 | ~~R1 → IOAddr, <br />IOData → mem(r2+imm), <br />Status → R0~~ | R0 is used for the I/O status.<br />Memory Access 3 is not implemented and is not consistent with others.  But, it would be handy for streams. |
| wio (Write IO)                                               | 11000 | NA                | R2 → IOAddr, <br />R1 → IOData,<br /> Status → R0 | Imm → IOAddr, <br />R1 → IOData, <br />Status → R0           | R2 → IOAddr, <br />mem(imm) → IOData, <br />Status → R0 | ~~R1 → IOAddr, <br />mem(r2+imm) → IOData, <br />Status → R0~~ | R0 is used for the I/O status.<br />Memory Access 3 is not implemented and is not consistent with others.  But, it would be handy for streams. |
| rti (Return from Interrupt)                                  | 11010 | NA                | NA                                                | NA                                                           | NA                                                      | NA                                                           | See Interrupt Section.                                       |
| swi (Software Interrupt)                                     | 11100 | NA                | IR Process Flag → ‘1’ <br />R1 → Interrupt Number | IR Process Flag → ‘1’ <br />Imm  → Interrupt Number          | Not Tested                                              | NA                                                           | See Interrupt Section.                                       |
| iena (Interrupt enable mask)                                 | 11110 | NA                | R1 – IR Stack Pointer,  <br />R2 → InterruptsEna  | R1 –IR Stack Pointer,  <br />Imm → InterruptsEna (Low 16 bits) | R1 – IR Stack Pointer,  <br />mem(imm) → InterruptsEna  | NA                                                           | See Interrupt Section.<br />Interrupt Stack Pointer register number is saved and used for hardware and software interrupt. |
| add                                                          | 00001 | NA                | R1 + R2 → R1                                      | R2 <> 0  : R1 + R2 + Imm → R1 <br />R2 == 0 : R1 + Imm → R1  | R1 + mem(imm) → R1                                      | R1 + mem(r2+imm) → R1                                        |                                                              |
| sub                                                          | 00011 | NA                | R1 - R2 → R1                                      | R2 <> 0  : R1 - R2 - Imm → R1 <br />R2 == 0 : R1 - Imm → R1  | R1 - mem(imm) → R1                                      | R1 - mem(r2+imm) → R1                                        |                                                              |
| and<br />nand (Flag = 1)                                     | 00101 | not               | R1 ∧ mem(imm) → R1                                | R2 <> 0  : R1 ∧ R2 ∧ Imm → R1<br />R2 = 0  : R1 ∧ Imm → R1   | R1 ∧ mem(imm) → R1                                      | R1 ∧ mem(r2+imm) → R1                                        |                                                              |
| or<br />nor (Flag = 1)                                       | 00110 | not               | R1 ∨ mem(imm) → R1                                | R2 <> 0  : R1 ∨ R2 ∨ Imm → R1<br />R2 = 0  : R1 ∨ Imm → R1   | R1 ∧ mem(imm) → R1                                      | R1 ∨ mem(r2+imm) → R1                                        |                                                              |
| xor<br />xnor (Flag = 1)                                     | 01011 | not               | R1 ⊕ mem(imm) → R1                                | R2 <> 0  : R1 ⊕ R2 ⊕ Imm → R1<br />R2 = 0  : R1 ⊕ Imm → R1   | R1 ⊕ mem(imm) → R1                                      | R1 ⊕ mem(r2+imm) → R1                                        |                                                              |
| sl                                                           | 01101 | NA                | R1 << mem(imm) → R1                               | R2 <> 0  : R1  << Imm → R1<br />R2 = 0  : R1 ⊕ Imm → R1      | R1 << mem(imm) → R1                                     | R1<< mem(r2+imm) → R1                                        |                                                              |
| sr                                                           | 01111 | NA                | R1 >> mem(imm) → R1                               | R2 <> 0  : R1 >> Imm → R1<br />R2 = 0  : R1 >> Imm → R1      | R1 >> mem(imm) → R1                                     | R1 >> mem(r2+imm) → R1                                       |                                                              |



### Load 

Perform loads and store operations. 

Operations:

| Assembly                | Addressing        | Code                                   | Clock Cycles | Operation                                        |
| ----------------------- | ----------------- | -------------------------------------- | ------------ | ------------------------------------------------ |
| ld r1, r2               | Register/Register | 10                                     | 5            | R2 → R1                                          |
| ldl r1, Imm             | Immediate (Low)   | 11                                     | 5            | Imm → R1[0:15]                                   |
| ldh r1, Imm             | Immediate (High)  | 15                                     | 5            | Imm → R1[16:31]                                  |
| ld r1, Imm              | Immediate         | 15 and 11<br />Performs two Operations | 10           | Imm[0:15] → R1[0:15]<br />Imm[16:31] → R1[16:31] |
| ld r1, mem[address]     | Absolute          | 12                                     | 7            | mem[address] → R1                                |
| ld r1, r2, mem[address] | Index             | 13                                     | 7            | mem[address+R2] → R1                             |

Limitations:

The Load Immediate will fill the register with 2 separate operations (Load High and Load Low).  The Load Immediate uses a Signed argument, and the Load High/Low uses unsigned.

### Store

Store the contents of the register to memory.

Operations:

| Assembly                | Addressing | Code | Clock Cycles | Operation            |
| ----------------------- | ---------- | ---- | ------------ | -------------------- |
| st r1, mem[address]     | Absolute   | 22   | 7            | R1 → mem[address]    |
| st r1, r2, mem[address] | Index      | 23   | 7            | R1 → mem[address+R2] |

### Jump

Operations:

| Assembly             | Addressing        | Code | Clock Cycles | Operation            |
| -------------------- | ----------------- | ---- | ------------ | -------------------- |
| jmp r1               | Register/Register | 30   | 5            | R1 → PC              |
| jmp Imm              | Immediate         | 31   | 5            | Imm[0:15] → PC       |
| jmp mem[address]     | Absolute          | 32   | 7            | mem[address] → PC    |
| jmp r2, mem[address] | Index             | 33   | 7            | mem[address+R2] → PC |

### Jump Subroutine 

The Jump to Subroutine stores the return address to the Stack which is pointed to by the first Register (Stack Pointer Register).

Operations:

| Assembly   | Addressing        | Code | Clock Cycles | Operation                                       |
| ---------- | ----------------- | ---- | ------------ | ----------------------------------------------- |
| jmp r1, r2 | Register/Register | 40   | 5            | PC+1 → mem(R1)<br />R1-1 → R1<br />R2 → PC      |
| jmp Imm    | Immediate         | 41   | 5            | PC+1 → mem(R1), <br />R1-1 → R1, <br />Imm → PC |

### Return

The Return reads the return address from the Stack which is pointed to by the stack pointer register.

Operations:

| Assembly | Addressing        | Code | Clock Cycles | Operation                    |
| -------- | ----------------- | ---- | ------------ | ---------------------------- |
| rtn r1   | Register/Register | 50   | 7            | R1+1→ R1, <br />mem(R1) → PC |

### Branches

Branches compare the first register with the second register.  If the second register is register zero (0) then it will compare to zero (Example bz r1, aaaa would assemble to 6110 aaaa, if r1 contains 0 then it would branch).

Operations:  

| Assembly                                                     | Addressing | Code | Clock Cycles | Operation                    |
| ------------------------------------------------------------ | ---------- | ---- | ------------ | ---------------------------- |
| be r1, r2, Imm                                               | Immediate  | 61   | 5            | if R1=R2 then Imm → PC       |
| be r1, r2, mem[address]                                      | Absolute   | 62   | 7            | if R1=R2 then mem(imm) → PC  |
| bne r1, r2, Imm                                              | Immediate  | 65   | 5            | if R1!=R2 then Imm → PC      |
| bne r1, r2, mem[address]                                     | Absolute   | 66   | 7            | if R1!=R2 then mem(imm) → PC |
| bz r1, Imm                                                   | Immediate  | 61x0 | 5            | if R1=0 then Imm → PC        |
| bz r1, mem[address]                                          | Absolute   | 62x0 | 7            | if R1=0 then mem(imm) → PC   |
| bnz r1, Imm                                                  | Immediate  | 65x0 | 5            | if R1!=0 then Imm → PC       |
| bnz r1, mem[address]                                         | Absolute   | 66x0 | 7            | if R1!=0 then mem(imm) → PC  |
| blt r1, r2, Imm                                              | Immediate  | 71   | 5            | if R1<R2 then Imm → PC       |
| blt r1, r2, mem[address]                                     | Absolute   | 72   | 7            | if R1<R2 then mem(imm) → PC  |
| bge r1, r2, Imm                                              | Immediate  | 75   | 5            | if R1>=R2 then Imm → PC      |
| bge r1, r2, mem[address]                                     | Absolute   | 76   | 7            | if R1>=R2 then mem(imm) → PC |
| bn r1, Imm                                                   | Immediate  | 71x0 | 5            | if R1<0 then Imm → PC        |
| bn r1, mem[address]                                          | Absolute   | 72x0 | 7            | if R1<0 then mem(imm) → PC   |
| bl r1, r0, Imm<br />(No specific assembly instruction)       | Immediate  | 75x0 | 5            | if R1>=0 then Imm → PC       |
| bl r1, r0, mem[address]<br />(No specific assembly instruction) | Absolute   | 76x0 | 7            | if R1>=0 then mem(imm) → PC  |
| bgt r1, r2, Imm                                              | Immediate  | 81   | 5            | if R1>R2 then Imm → PC       |
| bgt r1, r2, mem[address]                                     | Absolute   | 82   | 7            | if R1>R2 then mem(imm) → PC  |
| ble r1, r2, Imm                                              | Immediate  | 85   | 5            | if R1<=R2 then Imm → PC      |
| ble r1, r2, mem[address]                                     | Absolute   | 86   | 7            | if R1<=R2 then mem(imm) → PC |
| bp r1, Imm                                                   | Immediate  | 81x0 | 5            | if R1>0 then Imm → PC        |
| bp r1, mem[address]                                          | Absolute   | 82x0 | 7            | if R1>0 then mem(imm) → PC   |
| bg r1, r0, Imm<br />(No specific assembly instruction)       | Immediate  | 85x0 | 5            | if R1<=0 then Imm → PC       |
| bg r1, r0, mem[address]<br />(No specific assembly instruction) | Absolute   | 86x0 | 7            | if R1<=0 then mem(imm) → PC  |

### Stack Operations

Stack operations require a stack pointer register for R1.  This is a normal register that can be loaded, stored, pushed, etc.  Multiple stacks can exist using different registers.  By convention, I use register 15 for stack pointer.  Because the stack pointer is regular register, the register can be used to peek at the top of the stack, etc.   The following instructions use the stack: jsr, rtn, push, pop, swi, and hardware interrupts.

#### Push

| Assembly     | Addressing        | Code | Clock Cycles | Operation                      |
| ------------ | ----------------- | ---- | ------------ | ------------------------------ |
| push r1, r2  | Register/Register | 90   | 7            | R2 → mem(R1), <br />R1-1 → R1  |
| push r1, Imm | Immediate         | 91   | 7            | Imm → mem(R1), <br />R1-1 → R1 |

#### Pop

| Assembly   | Addressing        | Code | Clock Cycles | Operation                     |
| ---------- | ----------------- | ---- | ------------ | ----------------------------- |
| pop r1, r2 | Register/Register | a0   | 7            | R1+1 → R1, <br />mem(R1) → R2 |

### Input 

| Assembly                     | Addressing        | Code   | Clock Cycles | Operation                                                    |
| ---------------------------- | ----------------- | ------ | ------------ | ------------------------------------------------------------ |
| rio r1, r2                   | Register/Register | b0     | 7            | R2 → IOAddr,<br />IOData →  R1,<br />Status → R0             |
| roi r1, Imm                  | Immediate         | b1     | 7            | Imm → IOAddr, <br />IOData → R1, <br />Status → R0           |
| roi r1, mem[address]         | Absolute          | b2     | 8            | R2 → IOAddr,<br /> IOData → mem(imm), <br />Status → R0      |
| ~~roi r1, r2, mem[address]~~ | ~~Index~~         | ~~b3~~ | ~~8~~        | ~~R1 → IOAddr, <br />IOData → mem(r2+imm), <br />Status → R0~~ |

### Output

| Assembly                     | Addressing        | Code   | Clock Cycles | Operation                                                    |
| ---------------------------- | ----------------- | ------ | ------------ | ------------------------------------------------------------ |
| wio r1, r2                   | Register/Register | b0     | 7            | R2 → IOAddr, <br />R1 → IOData,<br />Status → R0             |
| woi r1, Imm                  | Immediate         | b1     | 7            | Imm → IOAddr, <br />R1 → IOData, <br />Status → R0           |
| woi r1, mem[address]         | Absolute          | b2     | 8            | R2 → IOAddr, <br />mem(imm) → IOData, <br />Status → R0      |
| ~~woi r1, r2, mem[address]~~ | ~~Index~~         | ~~b3~~ | ~~8~~        | ~~R1 → IOAddr, <br />mem(r2+imm) → IOData, <br />Status → R0~~ |

### Add

| Assembly                 | Addressing        | Code | Clock Cycles | Operation             |
| ------------------------ | ----------------- | ---- | ------------ | --------------------- |
| add r1, r2               | Register/Register | 08   | 5            | R1 + R2 → R1          |
| add r1, r2, Imm          | Immediate         | 09   | 5            | R1 + R2 + Imm → R1    |
| add r1, Imm              | Immediate         | 09x0 | 5            | R1 + Imm → R1         |
| add  r1, mem[address]    | Absolute          | 0a   | 7            | R1 + mem(imm) → R1    |
| add r1, r2, mem[address] | Index             | 0b   | 7            | R1 + mem(r2+imm) → R1 |

### Subtract

| Assembly                 | Addressing        | Code | Clock Cycles | Operation             |
| ------------------------ | ----------------- | ---- | ------------ | --------------------- |
| sub r1, r2               | Register/Register | 18   | 5            | R1 + R2 → R1          |
| sub r1, r2, Imm          | Immediate         | 19   | 5            | R1 + R2 + Imm → R1    |
| sub r1, Imm              | Immediate         | 19x0 | 5            | R1 + Imm → R1         |
| sub r1, mem[address]     | Absolute          | 1a   | 7            | R1 + mem(imm) → R1    |
| sub r1, r2, mem[address] | Index             | 1b   | 7            | R1 + mem(r2+imm) → R1 |

### And/Nand

| Assembly                  | Addressing        | Code | Clock Cycles | Operation             |
| ------------------------- | ----------------- | ---- | ------------ | --------------------- |
| and r1, r2                | Register/Register | 28   | 5            | R1 ∧ mem(imm) → R1    |
| and r1, r2, Imm           | Immediate         | 29   | 5            | R1 ∧ R2 ∧ Imm → R1    |
| and r1, Imm               | Immediate         | 29x0 | 5            | R1 ∧ Imm → R1         |
| and r1, mem[address]      | Absolute          | 2a   | 7            | R1 ∧ mem(imm) → R1    |
| and r1, r2, mem[address]  | Index             | 2b   | 7            | R1 ∧ mem(r2+imm) → R1 |
| nand r1, r2               | Register/Register | 2c   | 5            | R1 ⊼ mem(imm) → R1    |
| nand r1, r2, Imm          | Immediate         | 2d   | 5            | R1 ⊼ R2 ⊼ Imm → R1    |
| nand r1, Imm              | Immediate         | 2dx0 | 5            | R1 ⊼ Imm → R1         |
| nand r1, mem[address]     | Absolute          | 2e   | 7            | R1 ⊼ mem(imm) → R1    |
| nand r1, r2, mem[address] | Index             | 2f   | 7            | R1 ⊼ mem(r2+imm) → R1 |

### Or/Nor

| Assembly                 | Addressing        | Code | Clock Cycles | Operation             |
| ------------------------ | ----------------- | ---- | ------------ | --------------------- |
| or r1, r2                | Register/Register | 38   | 5            | R1 ∨ mem(imm) → R1    |
| or r1, r2, Imm           | Immediate         | 39   | 5            | R1 ∨ R2 ∨ Imm → R1    |
| or r1, Imm               | Immediate         | 39x0 | 5            | R1 ∨ Imm → R1         |
| or r1, mem[address]      | Absolute          | 3a   | 7            | R1 ∨ mem(imm) → R1    |
| or r1, r2, mem[address]  | Index             | 3b   | 7            | R1 ∨ mem(r2+imm) → R1 |
| nor r1, r2               | Register/Register | 3c   | 5            | R1 ⊽ mem(imm) → R1    |
| nor r1, r2, Imm          | Immediate         | 3d   | 5            | R1 ⊽ R2 ⊽ Imm → R1    |
| nor r1, Imm              | Immediate         | 3dx0 | 5            | R1 ⊽ Imm → R1         |
| nor r1, mem[address]     | Absolute          | 3e   | 7            | R1 ⊽ mem(imm) → R1    |
| nor r1, r2, mem[address] | Index             | 3f   | 7            | R1 ⊽ mem(r2+imm) → R1 |

### Xor/Xnor

| Assembly                  | Addressing        | Code | Clock Cycles | Operation              |
| ------------------------- | ----------------- | ---- | ------------ | ---------------------- |
| xor r1, r2                | Register/Register | 58   | 5            | R1 ⊕ mem(imm) → R1     |
| xor r1, r2, Imm           | Immediate         | 59   | 5            | R1 ⊕ R2 ⊕ Imm → R1     |
| xor r1, Imm               | Immediate         | 59x0 | 5            | R1 ⊕ Imm → R1          |
| xor r1, mem[address]      | Absolute          | 5a   | 7            | R1 ⊕ mem(imm) → R1     |
| xor r1, r2, mem[address]  | Index             | 5b   | 7            | R1 ⊕ mem(r2+imm) → R1  |
| xnor r1, r2               | Register/Register | 5c   | 5            | R1 ⊙ mem(imm) → R1     |
| xnor r1, r2, Imm          | Immediate         | 5d   | 5            | R1 ⊙ R2 ⊙ Imm → R1     |
| xnor r1, Imm              | Immediate         | 5dx0 | 5            | R1 ⊙ Imm → R1          |
| xnor r1, mem[address]     | Absolute          | 5e   | 7            | R1 ⊙ mem(imm) → R1     |
| xnor r1, r2, mem[address] | Index             | 5f   | 7            | R1 ⊙  mem(r2+imm) → R1 |

### Shift Left

| Assembly                 | Addressing        | Code | Clock Cycles | Operation             |
| ------------------------ | ----------------- | ---- | ------------ | --------------------- |
| sll r1, r2               | Register/Register | 68   | 5            | R1《 mem(imm) → R1    |
| sll r1, r2, Imm          | Immediate         | 69   | 5            | R1《 R2《 Imm → R1    |
| sll r1, Imm              | Immediate         | 69x0 | 5            | R1《 Imm → R1         |
| sll r1, mem[address]     | Absolute          | 6a   | 7            | R1《 mem(imm) → R1    |
| sll r1, r2, mem[address] | Index             | 6b   | 7            | R1《 mem(r2+imm) → R1 |

### Shift Right

| Assembly                 | Addressing        | Code | Clock Cycles | Operation             |
| ------------------------ | ----------------- | ---- | ------------ | --------------------- |
| srl r1, r2               | Register/Register | 78   | 5            | R1 》mem(imm) → R1    |
| srl r1, r2, Imm          | Immediate         | 79   | 5            | R1 》R2 》Imm → R1    |
| srl r1, Imm              | Immediate         | 79x0 | 5            | R1 》Imm → R1         |
| srl r1, mem[address]     | Absolute          | 7a   | 7            | R1 》mem(imm) → R1    |
| srl r1, r2, mem[address] | Index             | 7b   | 7            | R1 》mem(r2+imm) → R1 |

### Interrupts

#### Interrrupt Enable Mask

| Assembly              | Addressing        | Code | Clock Cycles | Operation                                                    |
| --------------------- | ----------------- | ---- | ------------ | ------------------------------------------------------------ |
| iena r1, r2           | Register/Register | f0   | 5            | R1 – IR Stack Pointer,  <br />R2 → Interrupts Enable Mask    |
| iena r1, Imm          | Immediate         | f1   | 5            | R1 –IR Stack Pointer,  <br />Imm → Interrupts Enable Mask(Low 16 bits) |
| iena r1, mem[address] | Absolute          | f2   | 7            | R1 – IR Stack Pointer,  <br />mem(address) → Interrupts Enable Mask |

#### Software Interrupt

The Software Interrupt just sets the Interrupt Process Flag and sets the Interrupt Number.  This will initiate the interrupt process listed before.

| Assembly         | Addressing        | Code | Clock Cycles | Operation                                                    |
| ---------------- | ----------------- | ---- | ------------ | ------------------------------------------------------------ |
| swi r2           | Register/Register | e0   | 5            | IR Process Flag → ‘1’ <br />R1 → Interrupt Number            |
| swi Imm          | Immediate         | e100 | 5            | IR Process Flag → ‘1’ <br />Imm  → Interrupt Number          |
| swi mem[address] | Absolute          | e2   | 7            | IR Process Flag → ‘1’    <br />mem(address) → Interrupts Enable Mask |

#### Return from Interrupt

| Assembly | Addressing        | Code | Clock Cycles | Operation                                                    |
| -------- | ----------------- | ---- | ------------ | ------------------------------------------------------------ |
| rti      | Register/Register | d000 | 8            | mem(reg(InterSP)+1) → PC <br />mem(reg(InterSP))+2) → IntEna<br />reg(InterSP)+2 → reg(InterSP) |

There are 32 unique interrupts.  Only 31 can be programmed interrupt 0 is for resetting the CPU.    The CPU contains an interrupt enable mask (32-bit word).  The CPU can only start processing one interrupt at a time.  The interrupts are checked at the start of an instruction cycle (PREFETCH cycle).  Interrupt 0 is the only non-maskable interrupt.

Software interrupts specify as part of the instruction the interrupt to process.  The SW interrupt can start the same interrupt as a hardware interrupt.    The software can reset the CPU by issuing a SW interrupt 0, this has not been tested.

Interrupt Process initiated by Hardware or Software interrupt.

| **Cycle**        | **Interrupt Process**                         |
| ---------------- | --------------------------------------------- |
| PREFETCH         | reg(InterSP) → addrB                          |
| SAVEENA2         | IntEna → dinB reg(InterSP) → reg(InterSP) – 1 |
| INTERRUPTDISABLE | ’0’ → IntEna(interNum)                        |
| PUSHPC1          | reg(InterSP) → addrB                          |
| PUSHPC2          | PC+1 → dinB reg(InterSP) → reg(InterSP) – 1   |
| JINTERRUPT       | InterNum → addrA                              |
| WAIT1            | Wait                                          |
| WAIT2            | Wait                                          |
| JUMP             | DoutA → PC                                    |

Return from interrupt processing:

| **Cycle** | **Return Process**                       |
| --------- | ---------------------------------------- |
| DECODES   | reg(InterSP)+1 → addrB                   |
| MEMRWAIT  | reg(InterSP))+2 → addrB                  |
| MEMR      | Wait                                     |
| EXECUTE   | DoutB → PC reg(InterSP)+2 → reg(InterSP) |
| MEMW      | DoutB → IntEna                           |



### 

