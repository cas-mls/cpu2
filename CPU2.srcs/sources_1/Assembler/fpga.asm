;#bits 32

;#subruledef source
;{
;    {immediate: i16} => 0xd @ immediate
;    mem[{address: i16}] => 0xe @ address
;    ptr[{r: register}] => 0xf @ r`16
;}

                                                    ; Instruction fields:
                                                    ; | op  | flg | mem | r1 | r2 | imm

#subruledef operands
{
    r{r1: u4}, r{r2: u4}                        => 0`2 @ r1 @ r2 @ 0x0000
    r{r1: u4}, {imm: u16}                       => 1`2 @ r1 @ 0x0 @ imm
    r{r1: u4}, r{r2: u4}, {imm: u16}            => 1`2 @ r1 @ r2 @ imm
    r{r1: u4}, mem[{address: u16}]              => 2`2 @ r1 @ 0x0 @ address
    r{r1: u4}, r{r2: u4}, mem[{address: u16}]   => 3`2 @ r1 @ r2 @ address
}

#subruledef branchop
{
    r{r1: u4}, r{r2: u4}, {imm: u16}            => 1`2 @ r1 @ r2 @ imm
    r{r1: u4}, r{r2: u4}, mem[{address: u16}]   => 2`2 @ r1 @ r2 @ address
}


#ruledef
{
    noop                                            => 0`32

    ; Load & Store
    ld  r{r1: u4}, r{r2: u4}                        => 2`5  @ 0`1 @ 0`2 @ r1 @ r2 @ 0x0000
    ld  r{r1: u4}, {imm: i32}                       => 2`5  @ 1`1 @ 1`2 @ r1 @ 0x0 @ imm[31:16] @ 2`5  @ 0`1 @ 1`2 @ r1 @ 0x0 @ imm[15:0]
    ldl r{r1: u4}, {imm: u16}                       => 2`5  @ 0`1 @ 1`2 @ r1 @ 0x0 @ imm
    ldh r{r1: u4}, {imm: u16}                       => 2`5  @ 1`1 @ 1`2 @ r1 @ 0x0 @ imm
    ld  r{r1: u4}, mem[{address: u16}]              => 2`5  @ 0`1 @ 2`2 @ r1 @ 0x0 @ address
    ld  r{r1: u4}, r{r2: u4}, mem[{address: u16}]   => 2`5  @ 0`1 @ 3`2 @ r1 @ r2 @ address
    st  r{r1: u4}, mem[{address: u16}]              => 4`5  @ 0`1 @ 2`2 @ r1 @ 0x0 @ address
    st  r{r1: u4}, r{r2: u4}, mem[{address: u16}]   => 4`5  @ 0`1 @ 3`2 @ r1 @ r2 @ address

    ; ADD
    add {op : operands}                             => 1`5  @ 0`1 @ op

    ; SUBTRACT
    sub {op : operands}                             => 3`5  @ 0`1 @ op

    ; JUMP
    jmp r{r2: u4}                                   => 6`5  @ 0`1 @ 0`2 @ 0x0 @ r2 @ 0x0000
    jmp {imm: u16}                                  => 6`5  @ 0`1 @ 1`2 @ 0x0 @ 0x0 @ imm
    jmp mem[{address: u16}]                         => 6`5  @ 0`1 @ 2`2 @ 0x0 @ 0x0 @ address
    jmp r{r2: u4}, mem[{address: u16}]              => 6`5  @ 0`1 @ 3`2 @ 0x0 @ r2 @ address

    ; BRANCH
    be  {op : branchop}                             => 12`5 @ 0`1 @ op
    blt {op : branchop}                             => 14`5 @ 0`1 @ op
    bgt {op : branchop}                             => 16`5 @ 0`1 @ op
    bne {op : branchop}                             => 12`5 @ 1`1 @ op
    bge {op : branchop}                             => 14`5 @ 1`1 @ op
    ble {op : branchop}                             => 16`5 @ 1`1 @ op

    ; Subroutine
    jsr r{r1: u4}, r{r2: u4}                        => 8`5  @ 0`1 @ 0`2 @ r1 @ r2  @ 0x0000
    jsr r{r1: u4}, {imm: u16}                       => 8`5  @ 0`1 @ 1`2 @ r1 @ 0x0 @ imm
    rtn r{r1: u4}                                   => 10`5 @ 0`1 @ 0`2 @ r1 @ 0x0 @ 0x0000
}

#bankdef program
{
    #bits 32
    #addr 0x0000
    #size 0x0C00
    #outp 0
}

#bank program

SP1 = 15 ; Stack Pointer Register
Stack1 = 0xB00 ; Stack Location

testdata1 = 0x1234
testdata2 = 0x5678
testdata3 = 0x4321
tr = 14

; Testing the load command
START:
    ldl r SP1,  Stack1
; Load and Store Tests
dataIndex = 20
    ldh r1, testdata1           ; Load immediate
    ldl r1, testdata2           ; Load immediate
    ld  r0, r1                  ; Transfer registers
    ldl r tr, 1
    bne r0, r1, LSCOMPLETE
    ldl r4, testdata3           ; Load immediate for store
    ldl r3, dataIndex           ; Index number
    st  r4, mem[DATA1]          ; store address
    ld  r5, mem[DATA1]          ; Absolute address
    ldl r tr, 2
    bne r4, r5, LSCOMPLETE
    st  r5, r3, mem[DATA2-dataIndex]  ; Index + offset
    ld  r6, r3, mem[DATA2-dataIndex]  ; Index + offset
    ldl r tr, 3
    bne r5, r6, LSCOMPLETE
    ldl r tr, 4
    jmp LSCOMPLETE

LSCOMPLETE:

; Add Instruction Tests
addend1 = 12345
addend2 = 23456
sum = addend1 + addend2
    ld r tr, 0x10
    ld r1, addend1
    ld r2, addend2
    ld r3, sum
    ld r tr, 0x11
    add r1, r2          ; Register
    bne r1, r3, ADDCOMP
    ld r1, addend1
    ldl r tr, 0x12
    add r1, addend2     ; Immediate
    bne r1, r3, ADDCOMP
    ld r1, addend1
    add r tr, 1
    add r1, mem[AENDMEM]
    bne r1, r3, ADDCOMP
    ld r1, addend1
    add r tr, 1
    ldl r4, AENDMEM1 - AENDMEM
    add r1, r4, mem[AENDMEM]
    bne r1, r3, ADDCOMP
    add r tr, 1

    jmp ADDCOMP
AENDMEM:
    #d32 addend2
    #res 2
AENDMEM1:
    #d32 addend2
ADDCOMP:



; SUB Instruction Tests
subend1 = 12345
subend2 = 23456
difference = subend1 - subend2
    ld r tr, 0x20
    ld r1, subend1
    ld r2, subend2
    ld r3, difference
    add r tr, 1
    sub r1, r2          ; Register
    bne r1, r3, SUBCOMP
    ld r1, subend1
    add r tr, 1
    sub r1, subend2     ; Immediate
    bne r1, r3, SUBCOMP
    ld r1, subend1
    add r tr, 1
    sub r1, mem[SENDMEM]
    bne r1, r3, SUBCOMP
    ld r1, subend1
    add r tr, 1
    ldl r4, SENDMEM1 - SENDMEM
    sub r1, r4, mem[SENDMEM]
    bne r1, r3, SUBCOMP
    add r tr, 1

    jmp SUBCOMP
SENDMEM:
    #d32 subend2
    #res 2
SENDMEM1:
    #d32 subend2
SUBCOMP:



; Branch Tests
eqtest = 0x4444
lesstest = 0x2222
greaterTest = 0x6666
    ld r tr, 0x30
    ld r1, eqtest
    ld r2, eqtest
    ld r3, lesstest
    ld r4, greaterTest
BETESTNE:
    be r1, r3, BRCOMPLETE   ; FALSE [R1 > R3]- No branch
    add r tr, 1
    be r1, r4, BRCOMPLETE   ; FALSE [R1 < R4]- No branch
    add r tr, 1
BETEST:
    bne r1, r2, BRCOMPLETE ; FALSE [r1 = r2] - No Branch
    add r tr, 1
    be r1, r2, BETEST1  ; TRUE [r1 = r2]- Branch Immediate
    jmp BRCOMPLETE
BETESTMEM:
    #d32 BLTESTNE
BETEST1:
    add r tr, 1
    bne r1, r2, mem[BRCOMPMEM] ; FALSE [r1 = r2] - No Branch
    add r tr, 1
    be r1, r2, mem[BETESTMEM]  ; TRUE [r1 = r2] - Branch Memory
    jmp BRCOMPLETE
BLTESTNE:
    add r tr, 1
    bge r3, r1, BRCOMPLETE    ; FALSE [R2 >= R1] = No Branch
    add r tr, 1
    blt r2, r1, BRCOMPLETE   ; FALSE [R2 = R1] - No branch
    add r tr, 1
    blt r4, r1, BRCOMPLETE   ; FALSE [r4 > r1] - No branch
    add r tr, 1
BLTEST:
    blt r3, r1, BLTEST1  ; TRUE [r3 < r1]- Branch Immediate
    jmp BRCOMPLETE

BLTESTMEM:
    #d32 BGTESTNE
BLTEST1:
    add r tr, 1
    bge r3, r1, mem[BLTESTMEM]  ; TRUE [r3 < r1] - Branch Memory
    add r tr, 1
    blt r3, r1, mem[BLTESTMEM]  ; TRUE [r3 < r1] - Branch Memory
    noop
BGTESTNE:
    add r tr, 1
    bgt r2, r1, JMPTEST   ; FALSE [R2 = R1] - No branch
    add r tr, 1
    bgt r3, r1, JMPTEST   ; FALSE [r3 < r1] - No branch
    add r tr, 1
BGTEST:
    bgt r4, r1, BGTEST1  ; TRUE [r4 > r1]- Branch Immediate
BRCOMPMEM:
    #d32 BRCOMPLETE
BGTEST2MEM:
    #d32 BGTEST2
BGTEST1:
    add r tr, 1
    bgt r4, r1, mem[BGTEST2MEM]  ; TRUE [r4 > r1] - Branch Memory
    noop
BGTEST2:
    add r tr, 1

BRCOMPLETE:

; Jump Tests
jmpIndex = 10

JMPTEST:
    ld r tr, 0x40
    ldl r8, JMP1
    ldl r9, jmpIndex
    jmp r8
    noop
    noop
JMPMEM:
    #d32 JMP3
JMPIDX:
    #d32 JMP4
JMP1:
    jmp JMP2
    noop
    noop
JMP2:
    jmp mem[JMPMEM]
    noop
    noop
    noop
JMP3:
    jmp r9, mem[JMPIDX-jmpIndex]
    noop
    noop
    noop
    noop
JMP4:
JMPCOMPLETE:

    ld r tr, 0x50
    ld r1, SUB1
    jsr r15, r1
    add r tr, 1
    jsr r15, SUB1
    add r tr, 1
SUBCOMPLETE:

END:
    jmp START

SUB1:
    add r tr, 1
    rtn r15

DATA1:
    #d32 0x5A5A_5A5A
DATA2:
    #d32 0xA5A5_A5A5
