;#bits 32

;#subruledef source
;{
;    {immediate: i16} => 0xd @ immediate
;    mem[{address: i16}] => 0xe @ address
;    ptr[{r: register}] => 0xf @ r`16
;}

                                                    ; Instruction fields:
                                                    ; | op  | flg | mem | r1 | r2 | imm
#ruledef
{
    noop                                            => 0`32
    ld  r{r1: u4}, r{r2: u4}                        => 2`5  @ 0`1 @ 0`2 @ r1 @ r2 @ 0x0000
    ld  r{r1: u4}, {imm: u32}                       => 2`5  @ 1`1 @ 1`2 @ r1 @ 0x0 @ imm[31:16] @ 2`5  @ 0`1 @ 1`2 @ r1 @ 0x0 @ imm[15:0]
    ldl r{r1: u4}, {imm: u16}                       => 2`5  @ 0`1 @ 1`2 @ r1 @ 0x0 @ imm
    ldh r{r1: u4}, {imm: u16}                       => 2`5  @ 1`1 @ 1`2 @ r1 @ 0x0 @ imm
    ld  r{r1: u4}, mem[{address: u16}]              => 2`5  @ 0`1 @ 2`2 @ r1 @ 0x0 @ address
    ld  r{r1: u4}, r{r2: u4}, mem[{address: u16}]   => 2`5  @ 0`1 @ 3`2 @ r1 @ r2 @ address
    st  r{r1: u4}, mem[{address: u16}]              => 4`5  @ 0`1 @ 2`2 @ r1 @ 0x0 @ address
    st  r{r1: u4}, r{r2: u4}, mem[{address: u16}]   => 4`5  @ 0`1 @ 3`2 @ r1 @ r2 @ address
    add r{r1: u4}, r{r2: u4}                        => 1`5  @ 0`1 @ 0`2 @ r1 @ r2 @ 0x0000
    add r{r1: u4}, {imm: u16}                       => 1`5  @ 0`1 @ 1`2 @ r1 @ 0x0 @ imm
    add r{r1: u4}, r{r2: u4}, {imm: u16}            => 1`5  @ 0`1 @ 1`2 @ r1 @ r2 @ imm
    add r{r1: u4}, mem[{address: u16}]              => 1`5  @ 0`1 @ 2`2 @ r1 @ 0x0 @ address
    add r{r1: u4}, r{r2: u4}, mem[{address: u16}]   => 1`5  @ 0`1 @ 3`2 @ r1 @ r2 @ address
    sub r{r1: u4}, r{r2: u4}                        => 3`5  @ 0`1 @ 0`2 @ r1 @ r2 @ 0x0000
    sub r{r1: u4}, {imm: u16}                       => 3`5  @ 0`1 @ 1`2 @ 0x0 @ r2 @ imm
    sub r{r1: u4}, r{r2: u4}, {imm: u16}            => 3`5  @ 0`1 @ 1`2 @ r1 @ r2 @ imm
    sub r{r1: u4}, mem[{address: u16}]              => 3`5  @ 0`1 @ 2`2 @ r1 @ 0x0 @ address
    sub r{r1: u4}, r{r2: u4}, mem[{address: u16}]   => 3`5  @ 0`1 @ 3`2 @ r1 @ r2 @ address
    jmp r{r2: u4}                                   => 6`5  @ 0`1 @ 0`2 @ 0x0 @ r2 @ 0x0000
    jmp {imm: u16}                                  => 6`5  @ 0`1 @ 1`2 @ 0x0 @ 0x0 @ imm
    jmp mem[{address: u16}]                         => 6`5  @ 0`1 @ 2`2 @ 0x0 @ 0x0 @ address
    jmp r{r2: u4}, mem[{address: u16}]              => 6`5  @ 0`1 @ 3`2 @ 0x0 @ r2 @ address
    be  r{r1: u4}, r{r2: u4}, {imm: u16}            => 12`5 @ 0`1 @ 1`2 @ r1 @ r2 @ imm
    be  r{r1: u4}, r{r2: u4}, mem[{address: u16}]   => 12`5 @ 0`1 @ 2`2 @ r1 @ r2 @ address
    blt r{r1: u4}, r{r2: u4}, {imm: u16}            => 14`5 @ 0`1 @ 1`2 @ r1 @ r2 @ imm
    blt r{r1: u4}, r{r2: u4}, mem[{address: u16}]   => 14`5 @ 0`1 @ 2`2 @ r1 @ r2 @ address
    bgt r{r1: u4}, r{r2: u4}, {imm: u16}            => 16`5 @ 0`1 @ 1`2 @ r1 @ r2 @ imm
    bgt r{r1: u4}, r{r2: u4}, mem[{address: u16}]   => 16`5 @ 0`1 @ 2`2 @ r1 @ r2 @ address
    bne r{r1: u4}, r{r2: u4}, {imm: u16}            => 12`5 @ 1`1 @ 1`2 @ r1 @ r2 @ imm
    bne r{r1: u4}, r{r2: u4}, mem[{address: u16}]   => 12`5 @ 1`1 @ 2`2 @ r1 @ r2 @ address
    bge r{r1: u4}, r{r2: u4}, {imm: u16}            => 14`5 @ 1`1 @ 1`2 @ r1 @ r2 @ imm
    bge r{r1: u4}, r{r2: u4}, mem[{address: u16}]   => 14`5 @ 1`1 @ 2`2 @ r1 @ r2 @ address
    ble r{r1: u4}, r{r2: u4}, {imm: u16}            => 16`5 @ 1`1 @ 1`2 @ r1 @ r2 @ imm
    ble r{r1: u4}, r{r2: u4}, mem[{address: u16}]   => 16`5 @ 1`1 @ 2`2 @ r1 @ r2 @ address
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

jmpIndex = 10
testdata1 = 0x1234
testdata2 = 0x5678
testdata3 = 0x4321

; Testing the load command
START:
; Load and Store Tests
dataIndex = 20
    ldh r1, testdata1           ; Load immediate
    ldl r1, testdata2           ; Load immediate
    ld  r0, r1                  ; Transfer registers
    ldl r4, testdata3           ; Load immediate for store
    ldl r3, dataIndex           ; Index number
    st  r4, mem[DATA1]          ; store address
    st  r0, r3, mem[DATA2-dataIndex]  ; Index + offset
    ld  r5, mem[DATA1]          ; Absolute address
    ld  r6, r3, mem[DATA2-dataIndex]  ; Index + offset
    ldl r SP1,  Stack1 

; Add Instruction Tests
addend1 = 12345
addend2 = 23456
tr = 14
sum = addend1 + addend2
    ld r1, addend1
    ld r2, addend2
    ld r3, sum
    ld r tr, 1
    add r1, r2          ; Register
    bne r1, r3, ADDCOMP
    ld r1, addend1
    ldl r tr, 2
    add r1, addend2     ; Immediate
    bne r1, r3, ADDCOMP
    ld r1, addend1
    ldl r tr, 3
    add r1, mem[AENDMEM]
    bne r1, r3, ADDCOMP
    ld r1, addend1
    ldl r tr, 4
    ldl r4, AENDMEM1 - AENDMEM
    add r1, r4, mem[AENDMEM]
    bne r1, r3, ADDCOMP
    ldl r tr, 5

    jmp ADDCOMP
AENDMEM:
    #d32 addend2
    #res 2
AENDMEM1:
    #d32 addend2
ADDCOMP:

; Branch Tests
eqtest = 0x4444
lesstest = 0x2222
greaterTest = 0x6666
    ld r1, eqtest
    ld r2, eqtest
    ld r3, lesstest
    ld r4, greaterTest
BETESTNE:
    be r1, r3, BLTESTNE   ; FALSE [R1 > R3]- No branch
    be r1, r4, BLTESTNE   ; FALSE [R1 < R4]- No branch
BETEST:
    be r1, r2, BETEST1  ; TRUE [r1 = r2]- Branch Immediate
BETESTMEM:
    #d32 BLTESTNE
BETEST1:
    be r1, r2, mem[BETESTMEM]  ; TRUE [r1 = r2] - Branch Memory
    noop
BLTESTNE:
    blt r2, r1, BGTESTNE   ; FALSE [R2 = R1] - No branch
    blt r4, r1, BGTESTNE   ; FALSE [r4 > r1] - No branch
BLTEST:
    blt r3, r1, BLTEST1  ; TRUE [r3 < r1]- Branch Immediate
BLTESTMEM:
    #d32 BGTESTNE
BLTEST1:
    blt r3, r1, mem[BLTESTMEM]  ; TRUE [r3 < r1] - Branch Memory
    noop
BGTESTNE:
    bgt r2, r1, JMPTEST   ; FALSE [R2 = R1] - No branch
    bgt r3, r1, JMPTEST   ; FALSE [r3 < r1] - No branch
BGTEST:
    bgt r4, r1, BGTEST1  ; TRUE [r4 > r1]- Branch Immediate
BGTESTMEM:
    #d32 JMPTEST
BGTEST1:
    bgt r4, r1, mem[BGTESTMEM]  ; TRUE [r4 > r1] - Branch Memory
    noop

; Jump Tests
JMPTEST:
    ldl r8, JMP1
    ldl r9, jmpIndex
    jmp r8
    noop
    noop
JMPMEM:
    #d32 JMP3
JMPIDX:
    #d32 JMP4-jmpIndex
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
    jmp r9, mem[JMPIDX]
    noop
    noop
    noop
    noop
JMP4:
    jmp START
DATA1:
    #d32 0x5A5A_5A5A
DATA2:
    #d32 0xA5A5_A5A5