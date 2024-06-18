

# Craig's CPU

This is a simple CPU architecture that I used to verify that I understand how to use FPGAs, VHDL, and write a CPU.  This is my largest project to date.

## Specifications

| Clock Speed.                     |            |
| -------------------------------- | ---------- |
| Word size                        | 32 Bits    |
| Memory                           | 4096 Words |
| Average Instructions per second. | 16.6KIPS   |
| Cache                            | 0          |
| Cores                            | 1          |
| Registers                        | 16         |
| Interrupt                        | 32         |
| IO Addresses                     | 256        |



## Hardware

- Computer (Laptop) - 13th Gen i9-13900 2.20GHz, 32 GB

- Arty-S7 Rev-E with AMD XC7S50-1CSGA324C FPGA

  | Description  | Specification    |
  | ------------ | ---------------- |
  | Logic Slices | 8,150            |
  | 6-Input LUT  | 32,200           |
  | Flip-Flops   | 65,200           |
  | Block RAM    | 337.5 KB         |
  | DPS          | 120              |
  | Clock        | 100 MHz / 12 MHz |


* Connectivity and IO

  | Input/Output     | Specification                    |
  | ---------------- | -------------------------------- |
  | USB              | USB-UART USB-JTAG Programmer     |
  | Pmod Connectors  | 4                                |
  | Other Connectors | Arduino/chipKIT shield connector |
  | Switches         | 4 slide switches                 |
  | Buttons          | 4 Push buttons                   |
  | LEDs             | 4 LEDs, 2 RGB LEDs               |

## Software

- Microsoft Windows 11 Pro
- AMD Vivado v2023.2 (64-bit)
  - VHDL 2K
- Visual Studio Code
  - Extensions
    - VHDL
    - CustomAsm
- [CustomAsm](https://github.com/hlorenzi/customasm) 

## IPs

- Block Memory Generator v8.4

  - Interface Type: Native

  - Memory Type :True Dual Port RAM

  - Port A/B

    - Write Width - 32 bits
    - Read Width - 32 bits
    - Write Depth - 4096
    - Read Depth - 4096
    - Primitive Output Register

  - Other Options

    - Load Init File - Program.coe
    - Fill Remaining Memory Locations - A5

  - Read Latency - 2 cycles

    

## Specifictions

| Clock Speed                     |      |
| ------------------------------- | ---- |
| 32 Bit words                    |      |
| 4096 Word Memory                |      |
| Average Instructions per second |      |
| Cache                           |      |
| No. Cores                       |      |
| No. Registers                   |      |
| No. Interrupt                   |      |
| No. IO Addresses                |      |
|                                 |      |



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

Load instruction - High 1/2 word = 1, Low 1/2 Word = 0

1 = NOT for the following instructions:

- Branch
- And
- Nand
- Or
- Nor
- Xor
- Xnor

### Access (Memory)

Register/Register - The first register is an destination/accumulator.  The second register is a source/memory index.

Immediate - This is 16-bit data that can be used to load or change the accumulator.

Absolute - This gets the address from the 16-bit Immediate part of the instruction.

Index - This gets the address from the addition of the 2nd register and the Immediate part of the instruction.

### Register 1

The first Register is the destination for load, source for the store, and accumulator for Add, Subtract, And, etc.

### Register 2

The Second Register is the source or index.  For Operations (Add, Subtract, Add, etc.) this can be added to the Immediate value.  If Register 0 is used then nothing will be used in the operation.  For Branch instruction the second Register is Register 0 this will cause Register 1 to be compared with 0 (branch zero, branch not zero, branch negative and branch positive, etc).

### Immediate

The immediate part of the instruction is limited to 16 bits. It can only load the lower have of the word.  Setting the flag will cause the load to work on the higher bits.  The Immediate is currently a unsigned integer.

## Architecture / Design

The operation cycles in the order: ADDRESS, INSTFETCH1, INSTFETCH2, DECODE, MEMFETCH1, MEMFETCH2, EXECUTE, and CLEANUP.  Some instructions do not use all of the cycles.  Example: the MEMFETCH1only is used during Read / Write IO operations, other operations completely skipped this cycle.  Another exception MEMFETCH1 and MEMFETCH2 cycle are skipped when the operation is not a Memory read (Access / Memory operations 2 and 3).

During each cycle, the Access (Memory) value is selected (Case statement) and then the Opcode is selected (Case).  This is opposite to the normal method of CPU operation (Opcode first, Memory second).

| Cycle      | Description                                                  |
| ---------- | ------------------------------------------------------------ |
| ADDRESS    | Sets the instruction address.<br />Start interrupt processing |
| INSTFETCH1 | Wait for instruction data.                                   |
| INSTFETCH2 | Wait for instruction data.                                   |
| DECODE     | Instruction Data is available and the Instruction is separated into different fields.<br/>The main purpose is to get the values required to perform the operations.  For Memory operations 0 (Register/Register), the register values are obtained.  For Memory Operation 1 the Registers and the Immediate values.  For Memory Operation 2, the Immediate value is used as the Memory address.  For Memory Operation 3, the Register and the Immediate values are added and used as the Memory address. |
| MEMFETCH1  | Wait for Access (Memory) types 2 and 3.<br />The Return from Interrupt (RTI) operation reads the stack for the Interrupt Mask. |
| MEMFETCH2  | Wait for Read for Access (Memory) types 2 and 3.             |
| EXECUTE    | Perform the operations.                                      |
| CLEANUP    | Perform additional items after Execute.  Read and Write operations are the only operations that use this cycle state to reset the enable flag. |
|            | Interrupt Processing                                         |
| SAVEENA    | IntEna → dinB  <br />reg(InterSP) → reg(InterSP) – 1         |
| DISABLEINT | ’0’ → IntEna(interNum) <br />reg(InterSP) → addrB <br />PC → dinB |
| JMPADDR    | reg(InterSP) → reg(InterSP) – 1 <br />InterNum → addrB       |
| JMPFETCH1  | Wait                                                         |
| JMPFETCH2  | Wait                                                         |
| JUMP       | DoutB → PC                                                   |




```mermaid
stateDiagram
    [*] --> ADDRESS
    ADDRESS --> INSTFETCH1
    INSTFETCH1 --> INSTFETCH2
    INSTFETCH2 --> DECODE
    DECODE --> MEMFETCH1 : addr modes 2 & 3
    MEMFETCH1 --> MEMFETCH2
    MEMFETCH2 --> EXECUTE
    DECODE --> EXECUTE : addr modes 0 & 1
    EXECUTE --> ADDRESS : jumps & branches
    EXECUTE --> CLEANUP : rio & wio
    EXECUTE --> DECODE : addr modes 2 & 3
    EXECUTE --> INSTFETCH2 : addr modes 0 & 1
    EXECUTE --> SAVEENA : interrupt
    SAVEENA --> DISABLEINT
    DISABLEINT --> JMPADDR
    JMPADDR --> JMPFETCH1
    JMPFETCH1 --> JMPFETCH2
    JMPFETCH2 --> JUMP
    JUMP --> ADDRESS
    CLEANUP --> ADDRESS
    
```


## Instructions

| Opcode                                                       | Bits    | Flag              | Address #0 <br /><u>Register / Register</u>                  | Address #1 <br /><u>Immediate</u>                            | Address #2 <br /><u>Absolute Memory</u>           | Address #3 <br /><u>Index Memory</u>                      |
| ------------------------------------------------------------ | ------- | ----------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------- | --------------------------------------------------------- |
| `NOOP`                                                       | `00000` | NA                | NA                                                           | NA                                                           | NA                                                | NA                                                        |
| `ld` (Load)                                                  | `00010` | High Bits (16-31) | $R2 → R1$                                                    | $imm → R1$                                                   | $mem[imm] → R1$                                   | $mem[r2+imm] → R1$                                        |
| `st` (Store)                                                 | `00100` | NA                | NA                                                           | NA                                                           | $R1 → mem[imm]$                                   | $R1 → mem[r2+imm]$                                        |
| `jmp` (Jump)                                                 | `00110` | NA                | $R1 → PC$                                                    | $imm → PC$                                                   | $mem[imm] → PC$                                   | $mem[r2 + mem] → PC$                                      |
| `jsr` (Jump Subroutine)[^1]                                  | `01000` | NA                | $PC+1 → mem[R1]\\R1-1 → R1\\R2 → PC$                         | $PC+1 → mem[R1]\\R1-1 → R1\\imm → PC$                        | NA                                                | NA                                                        |
| `rtn` (Return)[^1]                                           | `01010` | NA                | $R1+1 → R1\\mem(R1) → PC$                                    | NA                                                           | NA                                                | NA                                                        |
| `be`<br />`bne` (not flag)[^2] <br />`bz` (R2=0)<br />`bnz` (R2=0, Flag=1)[^3] | `01100` | Not               | NA                                                           | $imm → PC$                                                   | $mem(imm) → PC$                                   | NA                                                        |
| `bl`<br />`bge` (not flag)[^4] <br />`bn` (R2=0)[^5]         | `01110` | Not               | NA                                                           | $imm → PC$                                                   | $mem(imm) → PC$                                   | NA                                                        |
| `bg`<br />`ble` (not flag)[^6]<br />`bp` (R2=0)[^7]          | `10000` | Not               | NA                                                           | $imm → PC$                                                   | $mem(imm) → PC$                                   | NA                                                        |
| `push`[^1]                                                   | `10010` | 0                 | $R2 → mem(R1)\\R1-1 → R1$                                    | $imm → mem(R1)\\R1-1 → R1$                                   | NA[^8]                                            | NA[^8]                                                    |
| `pop`[^1]                                                    | `10010` | 1                 | $R1+1 → R1\\mem(R1) → R2$                                    | NA                                                           | NA[^8]                                            | NA[^8]                                                    |
| `wait`[^13]                                                  | `10101` | 0                 |                                                              | $R1 --  Counter,\\imm→ resolution\\'1' → waitEna$            |                                                   |                                                           |
| `timer`[^14]                                                 | `10101` | 0                 |                                                              | $R1 -- Counter,\\ R2 -> TimerInt\\imm->resolution\\'1' → TimeeFlag$ |                                                   |                                                           |
| cancel                                                       | 10101   | 1                 | $if (R1 is Wait Register) then\\'0' → waitFlag\\if (R1 is Timer Register) then\\'0' → timerFlag$ |                                                              |                                                   |                                                           |
| `rio` (Read IO)                                              | `10110` | 0                 | $R2 → IOAddr,\\IOData →  R1\\Status → R0$[^9]                | $imm → IOAddr\\IOData → R1\\Status → R0$[^9]                 | $R2 → IOAddr\\IOData → mem(imm)\\Status → R0$[^9] | ~~$R1 → IOAddr\\IOData → mem(r2+imm)\\Status → R0$~~[^10] |
| `wio` (Write IO)                                             | `10110` | 1                 | $R2 → IOAddr\\R1 → IOData\\ Status → R0$[^9]                 | $imm → IOAddr\\R1 → IOData\\Status → R0$[^9]                 | $R2 → IOAddr\\mem(imm) → IOData\\Status → R0$[^9] | ~~$R1 → IOAddr\\mem(r2+imm) → IOData\\Status → R0$~~[^10] |
| `rti` (Return from Interrupt)[^11]                           | `11010` | NA                | NA                                                           | NA                                                           | NA                                                | NA                                                        |
| `swi` (Software Interrupt)[^11]                              | `11100` | NA                | $'1' → IRProcFlag\\R1 → InterNum$                            | $'1' → IRProcFlag\\imm  → InterNum$                          | Not Tested                                        | NA                                                        |
| `iena` (Interrupt enable mask)[^11]: [^12]:                  | `11110` | NA                | $R1 → IRSP,\\R2 → InterEna$                                  | $R1 → IRSP,\\imm → InterEna$                                 | $R1 → IRSP\\mem(imm) → \\InterEna$                | NA                                                        |
| `add`                                                        | `00001` | NA                | $R1 + R2 → R1$                                               | $R1 + R2 + imm → R1 \\ R2 == 0 : R1 + \\imm → R1$            | $R1 + mem(imm) → R1$                              | $R1 + mem(r2+imm)$ → R1                                   |
| `sub`                                                        | `00011` | NA                | $R1 - R2 → R1$                                               | $R1 - R2 - imm → R1\\R2 == 0 : R1 -\\ imm → R1$              | $R1 - mem(imm) → R1$                              | $R1 - mem(r2+imm) → R1$                                   |
| `and`<br />`nand` (Flag = 1)                                 | `00101` | not               | $R1 ∧ R2 → R1$                                               | $R1 ∧ R2 ∧ imm → R1\\R2 = 0  : R1 ∧ \\imm → R1$              | $R1 ∧ mem(imm) → R1$                              | $R1 ∧ mem(r2+imm) → R1$                                   |
| `or`<br />`nor` (Flag = 1)                                   | `00110` | not               | $R1 ∨ R2  → R1$                                              | $R1 ∨ R2 ∨ imm → R1\\R2 = 0  : R1 ∨ \\imm → R1$              | $R1 ∧ mem(imm) → R1$                              | $R1 ∨ mem(r2+imm) → R1$                                   |
| `xor`<br />`xnor` (Flag = 1)                                 | `01011` | not               | $R1 ⊕ R2  → R1$                                              | $R1⊕R2⊕imm→ R1\\R2=0:R1⊕\\imm→R1$                            | $R1 ⊕ mem(imm) → R1$                              | $R1 ⊕ mem(r2+imm) → R1$                                   |
| `sll` (Shift Left Logical)                                   | `01101` | NA                | $R1 << R2  → R1$                                             | $R1<<imm → R1\\R2 = 0  : R1<<\\imm → R1$                     | $R1<<mem(imm) → R1$                               | $R1<<mem(r2+imm) → R1$                                    |
| `srl`(Shift Right Logical)                                   | `01111` | NA                | $R1 >> R2 → R1$                                              | $R1 >> imm → R1\\R2 = 0  : R1 >> \\imm → R1$                 | $R1>>mem(imm) → R1$                               | $R1>>mem(r2+imm) → R1$                                    |

[^1]: R1 is the  Stack Pointer
[^2]: R2 <> 0: R1 = R2 R1<>R2 (Flag=1)
[^3]: R2 = 0: R1 = 0 / R1 <> 0 (Flag=1)
[^4]: R2 <> 0: R1 < R2 / R1>=R2 (Flag =1)
[^5]: R2 = 0: R1 < 0 / R1 >= 0 (Flag=1)
[^6]: R2 <> 0: R1 > R2 / R1<=R2 (Flag=1)
[^7]: R2 = 0: R1 > 0 / R1 <= 0 (Flag=1)
[^8]: Memory Type 2 and 3 (might be possible with additional cycles)
[^9]: R0 is used for the I/O status.  
[^10]: Memory Access 3 is not implemented and is not consistent with others.  But, it would be handy for streams.
[^11]:See Interrupt Section.
[^12]:Interrupt Stack Pointer register number is saved and used for hardware and software interrupt.
[^13]: R2 = 0: Wait statement
[^14]: R2<>0: Timer statement, R2 contains the interrupt handler number




### Instruction Matrix:

|      | 0         | 1    | 2    | 3    | 4    | 5    | 6    | 7    | 8    | 9    | a    | b    | c    | d    | e    | f    |
| ---- | --------- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| 0    |           | <sub>`ld r1, r2`</sub> |      | <sub>`jmp r1`</sub> | <sub>`jsr r1, r2`</sub> | <sub>`rtn r1`</sub> |      |      |      | <sub>`push r1, r2`</sub> |      | <sub>`rio r1, r2`</sub> |  | <sub>`rti`</sub> | <sub>`swi r2`</sub> | <sub>`iena r1, r2`</sub> |
| 1 |  | <sub>`ldl r1, imm`</sub> |      | <sub>`jmp imm`</sub> | <sub>`jsr imm`</sub> |      | <sub>`be r1, r2, imm<br />bz r1, imm`</sub> | <sub>`blt r1, r2, imm<br />bn r1, imm` </sub> | <sub>`bgt r1, r2, imm<br />bp r1, imm`</sub> | <sub>`push r1, imm`</sub> | <sub>`wait r1, imm<br />time r1, r2, imm`</sub> | <sub>`roi r1, imm`</sub>             |  |                | <sub>`swi imm`</sub> | <sub>`iena r1, imm`</sub> |
| 2 |           | <sub>`ld r1, mem [addr]`</sub> | <sub>`st r1, mem [addr]`</sub> | <sub>`jmp mem [addr]`</sub> |      |      | <sub>`be r1, r2, mem [addr]<br />bz r1, mem [addr]`</sub> | <sub>`blt r1, r2, mem[addr] <br /> bn r1, mem[addr]`</sub> | <sub>`bgt r1, r2, mem[addr]<br />bp r1, mem[addr]`</sub> |      |                       | <sub>`roi r1, mem[addr]`</sub>       |  |      | <sub>`swi mem[addr]`</sub> | <sub>`iena r1, mem[addr]`</sub> |
| 3 |           | <sub>`ld r1, r2, mem [addr]`</sub> | <sub>`st r1, r2, mem [addr]`</sub> | <sub>`jmp r2, mem [addr]`</sub> |      |      |      |      |      |      |                       | <sub>`roi r1, r2, mem[addr]`</sub> |  |      |      |      |
| 4 |           |      |      |      |      |      |      |      |      | <sub>`pop r1, r2`</sub> | <sub>`CANC r1`</sub> | <sub>`wio r1, r2`</sub> |      |      |      |      |
| 5 |           | <sub>`ldh r1, imm`</sub> |      |      |      |      | <sub>`bne r1, r2, imm<br />bnz r1, imm`</sub> | <sub>`bge r1, r2, imm<br />bl r1, r0, imm`</sub> | <sub>`ble r1, r2, imm<br />bg r1, r0, imm`</sub> |      |      | <sub>`woi r1, imm`</sub> |      |      |      |      |
| 6 |           |      |      |      |      |      | <sub>`bne r1, r2, mem [addr]<br />bnz r1, mem [addr]`</sub> | <sub>`bge r1, r2, mem[addr]<br />bl r1, r0, mem[addr]`</sub> | <sub>`ble r1, r2, mem[addr]<br />bg r1, r0, mem[addr]`</sub> |      |      | <sub>`woi r1, mem[addr]`</sub> |      |      |      |      |
| 7 |           |      |      |      |      |      |      |      |      |      |      | <sub>`woi r1, r2, mem[addr]`</sub> |      |      |      |      |
| 8 | <sub>`add r1, r2`</sub> | <sub>`sub r1, r2`</sub> | <sub>`and r1, r2`</sub> | <sub>`or r1, r2`</sub> |      | <sub>`xor r1, r2`</sub> | <sub>`sll r1, r2`</sub> | <sub>`srl r1, r2`</sub> |      |      |      |      |      |      |      |      |
| 9 | <sub>`add r1, r2, imm<br />add r1, imm`</sub> | <sub>`sub r1, r2, imm<br />sub r1, imm`</sub> | <sub>`and r1, r2, imm<br />and r1, imm`</sub> | <sub>`or r1, r2, imm <br />or r1, imm`</sub> |      | <sub>`xor r1, r2, imm<br />xor r1, imm`</sub> | <sub>`sll r1, r2, imm<br />sll r1, imm`</sub> | <sub>`srl r1, r2, imm<br />srl r1, imm`</sub> |      |      |      |      |      |      |      |      |
| a | <sub>`add  r1, mem[addr]`</sub> | <sub>`sub r1, mem[addr]`</sub> | <sub>`and r1, mem[addr]`</sub> | <sub>`or r1, mem[addr]`</sub> |      | <sub>`xor r1, mem[addr]`</sub> | <sub>`sll r1, mem[addr]`</sub> | <sub>`srl r1, mem[addr]`</sub> |      |      |      |      |      |      |      |      |
| b | <sub>`add r1, r2, mem[addr]`</sub> | <sub>`sub r1, r2, mem[addr]`</sub> | <sub>`and r1, r2, mem[addr]`</sub> | <sub>`or r1, r2, mem[addr]`</sub> |      | <sub>`xor r1, r2, mem[addr]`</sub> | <sub>`sll r1, r2, mem[addr]`</sub> | <sub>`srl r1, r2, mem[addr]`</sub> |      |      |      |      |      |      |      |      |
| c |                                             |                                             | <sub>`nand r1, r2`</sub>                      | <sub>`nor r1, r2`</sub>                     |                       | <sub>`xnor r1, r2`</sub>                      |                                                           |                                                            |                                                            |                         |                       |                                      |                                      |                |                          |                               |
| d    |                                             |                                             | <sub>`nand r1, r2, imm<br />nand r1, imm`</sub> | <sub>`nor r1, r2, imm<br />nor r1, imm`</sub> |                       | <sub>`xnor r1, r2, imm<br />xnor r1, imm`</sub> |                                                           |                                                            |                                                            |                         |                       |                                      |                                      |                |                          |                               |
| e    |                                             |                                             | <sub>`nand r1, mem[addr]`</sub>               | <sub>`nor r1, mem[addr]`</sub>              |                       | <sub>`xnor r1, mem[addr]`</sub>               |                                                           |                                                            |                                                            |                         |                       |                                      |                                      |                |                          |                               |
| f    |                                             |      | <sub>`nand r1, r2, mem[addr]`</sub> | <sub>`nor r1, r2, mem[addr]`</sub> |      | <sub>`xnor r1, r2, mem[addr]`</sub> |      |      |      |      |      |      |      |      |      |      |



## Instruction Detail

Reduction of cycles will be achieved when the instruction is preloaded (sequentially processed instruction).

### Load 

Perform loads and store operations. The cycles are the maximum cycles for that instruction.  The Load Immediate will fill the register with 2 separate operations (Load High and Load Low).  The Load Immediate uses a Signed argument, and the Load High/Low uses unsigned.

| Assembly                | Addressing        | Code                                   | Clock Cycles | Operation                                        |
| ----------------------- | ----------------- | -------------------------------------- | ------------ | ------------------------------------------------ |
| ld r1, r2               | Register/Register | 10                                     | 5            | R2 → R1                                          |
| ldl r1, Imm             | Immediate (Low)   | 11                                     | 5            | Imm → R1[0:15]                                   |
| ldh r1, Imm             | Immediate (High)  | 15                                     | 5            | Imm → R1[16:31]                                  |
| ld r1, Imm              | Immediate         | 15 and 11<br />Performs two Operations | 10           | Imm[0:15] → R1[0:15]<br />Imm[16:31] → R1[16:31] |
| ld r1, mem[address]     | Absolute          | 12                                     | 7            | mem[address] → R1                                |
| ld r1, r2, mem[address] | Index             | 13                                     | 7            | mem[address+R2] → R1                             |

### Store

Store the contents of the register in memory.

| Assembly                | Addressing | Code | Clock Cycles | Operation            |
| ----------------------- | ---------- | ---- | ------------ | -------------------- |
| st r1, mem[address]     | Absolute   | 22   | 7            | R1 → mem[address]    |
| st r1, r2, mem[address] | Index      | 23   | 7            | R1 → mem[address+R2] |

### Jump

Unconditional jump to a new address.  The index addressing command supports Jump Tables.

| Assembly             | Addressing        | Code | Clock Cycles | Operation            |
| -------------------- | ----------------- | ---- | ------------ | -------------------- |
| jmp r1               | Register/Register | 30   | 5            | R1 → PC              |
| jmp Imm              | Immediate         | 31   | 5            | Imm[0:15] → PC       |
| jmp mem[address]     | Absolute          | 32   | 7            | mem[address] → PC    |
| jmp r2, mem[address] | Index             | 33   | 7            | mem[address+R2] → PC |

### Jump Subroutine 

The Jump to Subroutine stores the return address to the Stack which is pointed to by the first Register (Stack Pointer Register).

| Assembly   | Addressing        | Code | Clock Cycles | Operation                                       |
| ---------- | ----------------- | ---- | ------------ | ----------------------------------------------- |
| jsr r1, r2 | Register/Register | 40   | 5            | PC+1 → mem(R1)<br />R1-1 → R1<br />R2 → PC      |
| jsr imm    | Immediate         | 41   | 5            | PC+1 → mem(R1), <br />R1-1 → R1, <br />imm → PC |

### Return

The Return reads the return address from the Stack which is pointed to by the stack pointer register.

| Assembly | Addressing        | Code | Clock Cycles | Operation                    |
| -------- | ----------------- | ---- | ------------ | ---------------------------- |
| rtn r1   | Register/Register | 50   | 7            | R1+1→ R1, <br />mem(R1) → PC |

### Branches

Branches compare the first register with the second register.  If the second register is register zero (0) then it will compare to zero (Example bz r1, aaaa would assemble to 6110 aaaa, if r1 contains 0 then it would branch).

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
| pop r1, r2 | Register/Register | 94   | 7            | R1+1 → R1, <br />mem(R1) → R2 |

### Input 

This command received input for peripherals.  The IO address is one 8 bits (byte) and the data is one word 32 bits.  The Status is defined by the peripheral, the only requirement is bit 0 is a busy bit.

| Assembly                     | Addressing        | Code   | Clock Cycles | Operation                                                  |
| ---------------------------- | ----------------- | ------ | ------------ | ---------------------------------------------------------- |
| rio r1, r2                   | Register/Register | b0     | 7            | R2 → IOAddr,<br />IOData →  R1,<br />Status → R0           |
| roi r1, Imm                  | Immediate         | b1     | 7            | Imm → IOAddr, <br />IOData → R1, <br />Status → R0         |
| roi r1, mem[address]         | Absolute          | b2     | 8            | R2 → IOAddr,<br /> IOData → mem(imm), <br />Status → R0    |
| roi r1, r2, mem[address]     | Index             | b3     | 8            | R1 → IOAddr, <br />IOData → mem(r2+imm), <br />Status → R0 |

### Output

This command output data to the peripherals.  The IO address is one 8 bits (byte) and the data is one word 32 bits.  The Status is defined by the peripheral, the only requirement is bit 0 is a busy bit.
| Assembly                 | Addressing        | Code | Clock Cycles | Operation                                                  |
| ------------------------ | ----------------- | ---- | ------------ | ---------------------------------------------------------- |
| wio r1, r2               | Register/Register | b4   | 7            | R2 → IOAddr, <br />R1 → IOData,<br />Status → R0           |
| woi r1, Imm              | Immediate         | b5   | 7            | Imm → IOAddr, <br />R1 → IOData, <br />Status → R0         |
| woi r1, mem[address]     | Absolute          | b6   | 8            | R2 → IOAddr, <br />mem(imm) → IOData, <br />Status → R0    |
| woi r1, r2, mem[address] | Index             | b7   | 8            | R1 → IOAddr, <br />mem(r2+imm) → IOData, <br />Status → R0 |

### Add

Performs 2-complement addition.  This does not support carry.

| Assembly                 | Addressing        | Code | Clock Cycles | Operation             |
| ------------------------ | ----------------- | ---- | ------------ | --------------------- |
| add r1, r2               | Register/Register | 08   | 5            | R1 + R2 → R1          |
| add r1, r2, Imm          | Immediate         | 09   | 5            | R1 + R2 + Imm → R1    |
| add r1, Imm              | Immediate         | 09x0 | 5            | R1 + Imm → R1         |
| add  r1, mem[address]    | Absolute          | 0a   | 7            | R1 + mem(imm) → R1    |
| add r1, r2, mem[address] | Index             | 0b   | 7            | R1 + mem(r2+imm) → R1 |

### Subtract

Performs a 2-complement subtraction.  This does not support overflow and carry.

| Assembly                 | Addressing        | Code | Clock Cycles | Operation             |
| ------------------------ | ----------------- | ---- | ------------ | --------------------- |
| sub r1, r2               | Register/Register | 18   | 5            | R1 + R2 → R1          |
| sub r1, r2, Imm          | Immediate         | 19   | 5            | R1 + R2 + Imm → R1    |
| sub r1, Imm              | Immediate         | 19x0 | 5            | R1 + Imm → R1         |
| sub r1, mem[address]     | Absolute          | 1a   | 7            | R1 + mem(imm) → R1    |
| sub r1, r2, mem[address] | Index             | 1b   | 7            | R1 + mem(r2+imm) → R1 |

### And/Nand

Performs the logical "and" or "nand" to the accumulator.

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

Performs the logical "or" or "nor" to the accumulator.

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

Performs the logical "xor" or "xnor" to the accumulator.

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

Performs the shift left logical to the accumulator.

| Assembly                 | Addressing        | Code | Clock Cycles | Operation             |
| ------------------------ | ----------------- | ---- | ------------ | --------------------- |
| sll r1, r2               | Register/Register | 68   | 5            | R1《 mem(imm) → R1    |
| sll r1, r2, Imm          | Immediate         | 69   | 5            | R1《 R2《 Imm → R1    |
| sll r1, Imm              | Immediate         | 69x0 | 5            | R1《 Imm → R1         |
| sll r1, mem[address]     | Absolute          | 6a   | 7            | R1《 mem(imm) → R1    |
| sll r1, r2, mem[address] | Index             | 6b   | 7            | R1《 mem(r2+imm) → R1 |

### Shift Right

Performs the shift right logical to the accumulator.

| Assembly                 | Addressing        | Code | Clock Cycles | Operation             |
| ------------------------ | ----------------- | ---- | ------------ | --------------------- |
| srl r1, r2               | Register/Register | 78   | 5            | R1 》mem(imm) → R1    |
| srl r1, r2, Imm          | Immediate         | 79   | 5            | R1 》R2 》Imm → R1    |
| srl r1, Imm              | Immediate         | 79x0 | 5            | R1 》Imm → R1         |
| srl r1, mem[address]     | Absolute          | 7a   | 7            | R1 》mem(imm) → R1    |
| srl r1, r2, mem[address] | Index             | 7b   | 7            | R1 》mem(r2+imm) → R1 |

### Wait / Timer

The Wait instruction will accept the number of time cycles (R1 with 32-bits), and resolution (immediate 16-bits).  The Timer instruction will accept the number of time cycles (R1 with 32-bits), interrupt number (R2 with lowest 5-bits), and resolution (immediate with 16-bits).   If the wait and timer times is zero then the wait and timer will be set to infinite.

The 32-bit counter of a 100MHz clock will only count for 43 seconds.  The Resolution field extends the time to 782 days, but the precision is maintained at 32 bits.  The precision for the max time (782 days) is 0.6ms.  The system contains a resolution counter and a timer counter.  For each clock cycle the CPU increments the resolution counter.  When the resolution counter reaches the resolution value it increments the timer counter.

```
resolCounter = resolCounter + 1;
if resolCounter >= resolution value then
	timerCounter = timerCounter + 1;
	resolCounter = 0;
	if timerCounter >= timerValue then
		either quit the wait or start the interrupt handler
		timerCounter = 0;
	end if
end if;
```

When the counter cycle is started an enable flag is set.  When the counter is complete, the enable flag is reset. 

For the sync (Wait), when the counter is going, the Wait cycle will be processed.  When the counter is finished, the Wait Cycle is stopped and the start of the regular cycle starts.

For the async (timer) the counter is going the regular cycle continues.  When the counter is finished the cycle is transferred to the interrupt cycle.

| Assembly         | Addressing        | Code | Clock Cycles | Operation                                                    |
| ---------------- | ----------------- | ---- | ------------ | ------------------------------------------------------------ |
| wait r1, Imm     | Immediate         | a1x0 | 5            | R1 →  Wait Timer<br />Imm →  Resolution<br />Enable Wait Timer |
| time r1, r2, Imm | Immediate         | a1   | 5            | R1 →  Timer<br />R2 →  Interrupt Number<br />Imm →  Resolution<br />Enable Timer |
| canc  r1         | Register/Register | a4   | 5            | if R1 is Wait Reg then '0' →  Disable Wait<br />if R1 is Timer Reg then '0' →  Disable Timer |

### Interrupts

#### Interrupt Enable Mask

| Assembly              | Addressing        | Code | Clock Cycles | Operation                                                    |
| --------------------- | ----------------- | ---- | ------------ | ------------------------------------------------------------ |
| iena r1, r2           | Register/Register | f0   | 5            | R1 – IR Stack Pointer,  <br />R2 → Interrupts Enable Mask    |
| iena r1, Imm          | Immediate         | f1   | 5            | R1 –IR Stack Pointer,  <br />Imm → Interrupts Enable Mask(Low 16 bits) |
| iena r1, mem[address] | Absolute          | f2   | 7            | R1 – IR Stack Pointer,  <br />mem(address) → Interrupts Enable Mask |

#### Software Interrupt

The Software Interrupt just sets the Interrupt Process Flag and sets the Interrupt Number.  This will initiate the interrupt process listed before.

There are 32 unique interrupts.  Only 31 can be programmed interrupt 0 is for resetting the CPU.    The CPU contains an interrupt enable mask (32-bit word).  The CPU can only start processing one interrupt at a time.  The interrupts are checked after the execute cycle and start at the next start of the instruction cycle.  Interrupt 0 is the only non-maskable interrupt.

Software interrupts specify as part of the instruction the interrupt to process.  The SW interrupt can start the same interrupt as a hardware interrupt.    The software can reset the CPU by issuing a SW interrupt 0, this has not been tested.

Interrupt Vector:

| interrupt Handler       | Address                                                      |
| ----------------------- | ------------------------------------------------------------ |
| 0 (CPU Reset)           | 0 (Address of the first executable instruction after reset.) |
| 1                       | 1 (Address of the interrupt handler for Interrupt 1.)        |
| ...                     | ...                                                          |
| 31                      | 31 (Address of the interrupt handler for Interrupt 31.)      |
| Executable Instructions | 32                                                           |
| ...                     | ...                                                          |

Interrupt Process initiated by Hardware or Software interrupt.

1. The Software Interrupt Mask is pushed onto the Interrupt Stack
2. The Interrupt Mask is cleared.  The Interrupt handler is responsible for updating the mask, if required.
3. The Program counter is pushed on the Interrupt Stack.
4. The interrupt Handler address is loaded to the Program Counter from the Interrupt Vector.

Return from Interrupt.

1. The interrupt will issue an RTI instruction.
2. The Program Counter will be popped from the Interrupt Stack
3. The Interrupt Mask will be popped from the Interrupt Stack
4. The Instruction Cycle starts over.

| Assembly         | Addressing        | Code | Clock Cycles | Operation                                                    |
| ---------------- | ----------------- | ---- | ------------ | ------------------------------------------------------------ |
| swi r1           | Register/Register | e0   | 5            | Check for Interrupt Enabled.<br />IR Process Flag → ‘1’ <br />R1 → Interrupt Number<br />Perform Hardware Interrupt |
| swi Imm          | Immediate         | e100 | 5            | Check for Interrupt Enabled.<br />IR Process Flag → ‘1’ <br />Imm  → Interrupt Number<br />Perform Hardware Interrupt |
| swi mem[address] | Absolute          | e2   | 7            | Check for Interrupt Enabled.<br />IR Process Flag → ‘1’    <br />mem(address) → Interrupts Enable Mask<br />Perform Hardware Interrupt |

#### Return from Interrupt

| Assembly | Addressing        | Code | Clock Cycles | Operation                                                    |
| -------- | ----------------- | ---- | ------------ | ------------------------------------------------------------ |
| rti      | Register/Register | d000 | 8            | mem(reg(InterSP)+1) → PC <br />mem(reg(InterSP))+2) → IntEna<br />reg(InterSP)+2 → reg(InterSP) |

#### Hardware Interrupt

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

