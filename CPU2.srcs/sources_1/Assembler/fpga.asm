
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
    r{r1: u4}, {imm: u16}                       => 1`2 @ r1 @ 0x0 @ imm
    r{r1: u4}, mem[{address: u16}]              => 2`2 @ r1 @ 0x0 @ address
}


#ruledef
{
    noop                                            => 0`32


    ; Load & Store
     ld  r{r1: u4}, r{r2: u4}                        => 2`5  @ 0`1 @ 0`2 @ r1 @ r2 @ 0x0000
    ld  r{r1: u4}, {imm: i32}                       => 2`5  @ 1`1 @ 1`2 @ r1 @ 0x0 @ imm[31:16] @ 2`5  @ 0`1 @ 1`2 @ r1 @ 0x0 @ imm[15:0]
    ; ld r{r1: u4}, {imm: u16}                        => 2`5  @ 0`1 @ 1`2 @ r1 @ 0x0 @ imm
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

    ; Logical AND/NAND
    and {op : operands}                             => 5`5  @ 0`1 @ op
    nand {op : operands}                             => 5`5  @ 1`1 @ op

    ; Logical OR/NOR
    or  {op : operands}                             => 7`5  @ 0`1 @ op
    nor {op : operands}                             => 7`5  @ 1`1 @ op
    
    ; Logical XOR/NXOR
    xor {op : operands}                             => 11`5  @ 0`1 @ op
    xnor {op : operands}                             => 11`5  @ 1`1 @ op

    ; Shift Register
    sll {op : operands}                             => 13`5  @ 0`1 @ op
    srl {op : operands}                             => 15`5  @ 0`1 @ op

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
    bz  r{r1: u4}, {imm: u16}                       => 12`5 @ 0`1 @1`2 @ r1 @ 0x0 @ imm
    bz  r{r1: u4}, mem[{address: u16}]              => 12`5 @ 0`1 @2`2 @ r1 @ 0x0 @ address
    bnz r{r1: u4}, {imm: u16}                       => 12`5 @ 1`1 @1`2 @ r1 @ 0x0 @ imm
    bnz r{r1: u4}, mem[{address: u16}]              => 12`5 @ 1`1 @2`2 @ r1 @ 0x0 @ address
    bn  r{r1: u4}, {imm: u16}                       => 14`5 @ 0`1 @1`2 @ r1 @ 0x0 @ imm
    bn  r{r1: u4}, mem[{address: u16}]              => 14`5 @ 0`1 @2`2 @ r1 @ 0x0 @ address
    bp  r{r1: u4}, {imm: u16}                       => 16`5 @ 0`1 @1`2 @ r1 @ 0x0 @ imm
    bp  r{r1: u4}, mem[{address: u16}]              => 16`5 @ 0`1 @2`2 @ r1 @ 0x0 @ address

    ; Subroutine
    jsr r{r1: u4}, r{r2: u4}                        => 8`5  @ 0`1 @ 0`2 @ r1 @ r2  @ 0x0000
    jsr r{r1: u4}, {imm: u16}                       => 8`5  @ 0`1 @ 1`2 @ r1 @ 0x0 @ imm
    rtn r{r1: u4}                                   => 10`5 @ 0`1 @ 0`2 @ r1 @ 0x0 @ 0x0000

    ; Input / Output
    rio r{r1: u4}, r{r2: u4}                        => 22`5  @ 0`1 @ 0`2 @ r1 @ r2 @ 0x0000
    rio r{r1: u4}, {imm: u16}                       => 22`5  @ 0`1 @ 1`2 @ r1 @ 0x0 @ imm
    rio r{r2: u4}, mem[{address: u16}]              => 22`5  @ 0`1 @ 2`2 @ 0x0 @ r2 @ address
    rio r{r1: u4}, r{r2: u4}, mem[{address: u16}]   => 22`5  @ 0`1 @ 3`2 @ r1 @ r2 @ address


    wio r{r1: u4}, r{r2: u4}                        => 22`5  @ 1`1 @ 0`2 @ r1 @ r2 @ 0x0000
    wio r{r1: u4}, {imm: u16}                       => 22`5  @ 1`1 @ 1`2 @ r1 @ 0x0 @ imm
    wio r{r2: u4}, mem[{address: u16}]              => 22`5  @ 1`1 @ 2`2 @ 0x0 @ r2 @ address
    wio r{r1: u4}, r{r2: u4}, mem[{address: u16}]   => 22`5  @ 1`1 @ 3`2 @ r1 @ r2 @ address
    
    ; Stack Operations
    push r{r1: u4}, r{r2: u4}                       => 18`5  @ 0`1 @ 0`2 @ r1 @ r2 @ 0x0000
    push r{r1: u4}, {imm: u16}                      => 18`5  @ 0`1 @ 1`2 @ r1 @ 0x0 @ imm
    pop r{r1: u4}, r{r2: u4}                        => 18`5  @ 1`1 @ 0`2 @ r1 @ r2 @ 0x0000

    ; Interrupt
    RTI                                             => 26`5  @ 0`1 @ 0`2 @ 0x0 @ 0x0 @ 0x0000
    SWI r{r1: u4}                                   => 28`5  @ 0`1 @ 0`2 @ r1 @ 0x0 @ 0x0000
    SWI {imm: u16}                                  => 28`5  @ 0`1 @ 1`2 @ 0x0 @ 0x0 @ imm
    SWI mem[{address: u16}]                         => 28`5  @ 0`1 @ 2`2 @ 0x0 @ 0x0 @ address
    IENA r{r1: u4}, r{r2: u4}                       => 30`5  @ 0`1 @ 0`2 @ r1 @ r2 @ 0x0000
    IENA r{r1: u4}, {imm: u16}                      => 30`5  @ 0`1 @ 1`2 @ r1 @ 0x0 @ imm
    IENA r{r1: u4}, mem[{address: u16}]             => 30`5  @ 0`1 @ 2`2 @ r1 @ 0x0 @ address

    ; WAIT/TIMER & CANCEL
    wait r{r1: u4}, {imm: u16}                      => 20`5 @ 0`1 @ 1`2 @ r1 @ 0x0 @ imm
    time r{r1: u4}, r{r2: u4}, {imm: u16}           => 20`5 @ 0`1 @ 1`2 @ r1 @ r2 @ imm
    canc r{r1: u4}                                  => 20`5 @ 1`1 @ 0`2 @ r1 @ 0x0 @ 0x0000

}

#bankdef program
{
    #bits 32
    #addr 0x0000
    #size 0x1000
    #outp 0
}



#bank program


INT0:
    ; jmp START
    #d32    START
INT1:
    #d32    SWINT
INT2:
    #d32    HWINT
#addr 10
INTTIMER:
    #d32    TIMERHANDLER

SP1 = 15 ; Stack Pointer Register
Stack1 = 0xB00 ; Stack Location

testdata1 = 0x1234
testdata2 = 0x5678
testdata3 = 0x4321
tr = 14
ER = 13
#addr 32
START:
    ldl r SP1,  Stack1
    ldl r ER, 0
LOOP:
    ldl r ER, 0
    jsr r SP1, WAITTEST
    jsr r SP1, IOTESTS
    jsr r SP1, INTERRUPTTEST
    jsr r SP1, STACKTESTS
    jsr r SP1, ANDTEST
    jsr r SP1, NANDTEST
    jsr r SP1, ORTEST
    jsr r SP1, NORTEST
    jsr r SP1, XORTEST
    jsr r SP1, XNORTEST
    jsr r SP1, SLLTEST
    jsr r SP1, SRLTEST
    jsr r SP1, LSTEST
    jsr r SP1, ADDTEST
    jsr r SP1, SUBTEST
    jsr r SP1, BRTEST2
    jsr r SP1, BRTEST
    jsr r SP1, JMPTEST
    ; wio r ER, 0x03    
    wio r tr, 0x03    
    jmp LOOP

SWINT:
    add r tr, 10
    ld r4, SWIntTestValue
    RTI

HWINT:
    wio r10, 0x05 ; Tell the tester to cancel the interrupt.
    add r tr, 100
    ld r6, HWIntTestValue
    RTI

TIMERHANDLER:
    add r tr, 1
    rti

WAITTEST:
    ldl r tr, 0x130
    ld r1, 10
    wait r1, 10         ; test wait (10 res * 10 Wait Cycles 100 System Cycles)
    add r tr, 1
    ld r1, 4
    ld r2, 10
    iena r SP1, 1<<10
    time r1, r2, 8      ; test timer
    add r tr, 1
    ld r3, 2
    wait r3, 5
    canc r1             ; test cancel
    add r tr, 1
    time r1, r2, 4      ; test interrupting WAIT.  WAIT should complete in the correct time.
    wait r1, 10
    ld r1, 0
    ;wait r1, 10        ; infinit wait
    ;time r1, r2, 8      ; infinit timer
    jmp WAITCOMPLETE

WAITCOMPLETE:
    rtn r SP1

INTERRUPTTEST:
SWIntTestValue = 0x54545
HWIntTestValue = 0x665566
    ldl r tr, 0x120
    ld r1, 0b10
    ld r5, SWIntTestValue
    ld r4, 0x0
    ld r2, 1
    swi r2
    bnz r4, INTERR
    add r tr, 1
    iena r SP1, r1
    swi 1
    bne r5, r4, INTERR 
    add r tr, 1
    ld r4, 0x0
    swi mem[INTSW]
    bne r5, r4, INTERR 
    add r tr, 1
    ; Hardware Interrupt
    ld r6, 0x0
    ld r7, HWIntTestValue
    ld r9, 0x1
    ld r10, 0x0
    wio r9, 0x05 ; Tell Tester to send (set) interrupt
    wio r10, 0x05 ; Tell the tester to cancel the interrupt.
    bnz r6, INTERR
    wio r9, 0x05 ; Tell Tester to send (set) interrupt
    iena r SP1, 0b100
    iena r SP1, mem[INTMASK] ; disable all interrupts.
    bne r6, r7, INTERR
    jmp INTCOMPLETE

INTSW:
    #d32 1

INTMASK:
    #d32 0

INTERR:
    add r ER, 1

INTCOMPLETE:
    rtn r SP1

; Stack Tests
STACKTESTS:
    ldl r tr, 0x110
    ld r2, 0x54321
    ld r3, 0x55555
    ld r4, 0x1234
    push r SP1, r2
    push r SP1, 0x1234
    pop r SP1, r5
    bne r4, r5, STACKERR
    add r tr, 1
    push r SP1, r3
    pop r SP1, r5
    bne r3, r5, STACKERR
    add r tr, 1
    pop r SP1, r5
    bne r2, r5, STACKERR
    add r tr, 1
    jmp STACKCOMPLETE

STACKERR:
    add r ER, 1
STACKCOMPLETE:
    rtn r SP1


; Input / Output Tests.
IOTESTS:
    ldl r tr, 0x100
    ld  r3, 0x0F ; Data
    ld  r2, 0x01 ; Address
    ld  r1, r3
    wio r1, r2
    bnz r0, IOERR
    add r tr, 1
    ld  r1, 0x00
    rio r1, r2
    bne r0, IOERR
    bne r1, r3, IOERR
    add r tr, 1
    ldl r2, 0x02
    wio r1, r2
    bz r0, IOERR

    ld  r1, r3
    wio r1, 0x1
    bne r0, IOERR
    add r tr, 1
    ld  r1, 0x00
    rio r1, 0x1
    bne r0, IOERR
    bne r1, r3, IOERR
    add r tr, 1
    ldl r2, 0x02
    wio r1, 0x2
    bz r0, IOERR

    ld  r2, 0x01 ; IO Address
    ld  r3, mem[WRITEMEM] ; Data
    ld  r1, 0x00
    wio r2, mem[WRITEMEM]
    bnz r0, IOERR
    add r tr, 1
    rio r2, mem[READMEM]
    ld r1, mem[READMEM]
    bnz r0, IOERR
    bne r1, r3, IOERR
    add r tr, 1

    ldl r2, 0x02
    wio r2, mem[WRITEMEM]
    be r0, IOERR            ; test status not zero.
    add r tr, 1

    ld  r4, -2 ; index -- try negative numbers.
    ld  r2, 0x01 ; IO Address
    ld  r3, mem[WRITEMEM] ; Data
    ld  r1, 0x00
    wio r2, r4, mem[WRITEMEM + 2]
    bnz r0, IOERR
    add r tr, 1
    ld  r1, 0x00
    st r1, mem[READMEM]
    rio r2, r4, mem[READMEM + 2]
    ld r1, mem[READMEM]
    bnz r0, IOERR
    bne r1, r3, IOERR
    add r tr, 1



    add r tr, 1
    jmp IOCOMPLETE

READMEM:
    #d32 0x0
WRITEMEM:
    #d32 0xff
IOERR:
    add r ER, 1
IOCOMPLETE:
    rtn r SP1

; Load and Store Tests
dataIndex = 20
LSTEST:
    ldh r1, testdata1           ; Load immediate
    ldl r1, testdata2           ; Load immediate
    ld  r0, r1                  ; Transfer registers
    ldl r tr, 1
    bne r0, r1, LSERROR
    ldl r4, testdata3           ; Load immediate for store
    ldl r3, dataIndex           ; Index number
    st  r4, mem[DATA1]          ; store address
    ld  r5, mem[DATA1]          ; Absolute address
    ldl r tr, 2
    bne r4, r5, LSERROR
    st  r5, r3, mem[DATA2-dataIndex]  ; Index + offset
    ld  r6, r3, mem[DATA2-dataIndex]  ; Index + offset
    ldl r tr, 3
    bne r5, r6, LSERROR
    ldl r tr, 4
    jmp LSCOMPLETE
LSERROR:
    add r ER, 1
LSCOMPLETE:
    rtn r SP1

ADDTEST:
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
    bne r1, r3, ADDERROR
    ld r1, addend1
    ldl r tr, 0x12
    add r1, addend2     ; Immediate
    bne r1, r3, ADDERROR
    ld r1, addend1
    add r tr, 1
    add r1, mem[AENDMEM]
    bne r1, r3, ADDERROR
    ld r1, addend1
    add r tr, 1
    ldl r4, AENDMEM1 - AENDMEM
    add r1, r4, mem[AENDMEM]
    bne r1, r3, ADDERROR
    add r tr, 1
    jmp ADDCOMP

AENDMEM:
    #d32 addend2
    #res 2
AENDMEM1:
    #d32 addend2
ADDERROR:
    add r ER, 1
ADDCOMP:
    rtn r SP1



; SUB Instruction Tests
subend1 = 12345
subend2 = 23456
difference = subend1 - subend2
SUBTEST:
    ld r tr, 0x20
    ld r1, subend1
    ld r2, subend2
    ld r3, difference
    add r tr, 1
    sub r1, r2          ; Register
    bne r1, r3, SUBER
    ld r1, subend1
    add r tr, 1
    sub r1, subend2     ; Immediate
    bne r1, r3, SUBER
    ld r1, subend1
    add r tr, 1
    sub r1, mem[SENDMEM]
    bne r1, r3, SUBER
    ld r1, subend1
    add r tr, 1
    ldl r4, SENDMEM1 - SENDMEM
    sub r1, r4, mem[SENDMEM]
    bne r1, r3, SUBER
    add r tr, 1

    jmp SUBCOMP
SENDMEM:
    #d32 subend2
    #res 2
SENDMEM1:
    #d32 subend2
SUBER:
    add r ER, 1
SUBCOMP:
    rtn r SP1


ANDTEST:
; AND Instruction Tests
andend1 = 12345
andend2 = 23456
andresults = andend1 & andend2
    ld r tr, 0x60
    ld r1, andend1
    ld r2, andend2
    ld r3, andresults
    add r tr, 1
    and r1, r2          ; Register
    bne r1, r3, ANDERROR
    ld r1, andend1
    add r tr, 1
    and r1, andend2     ; Immediate
    bne r1, r3, ANDERROR
    ld r1, andend1
    add r tr, 1
    and r1, mem[ANDMEM]
    bne r1, r3, ANDERROR
    ld r1, andend1
    add r tr, 1
    ldl r4, ANDMEM1 - ANDMEM
    and r1, r4, mem[ANDMEM]
    bne r1, r3, ANDERROR
    add r tr, 1
    jmp ANDCOMP

ANDMEM:
    #d32 andend2
    #res 2
ANDMEM1:
    #d32 andend2
ANDERROR:
    add r ER, 1
ANDCOMP:
    rtn r SP1

NANDTEST:
; NAND Instruction Tests
nandend1 = 12345
nandend2 = 23456
nandresults = !(nandend1 & nandend2)
    ld r tr, 0x70
    ld r1, nandend1
    ld r2, nandend2
    ld r3, nandresults
    add r tr, 1
    nand r1, r2          ; Register
    bne r1, r3, NANDERROR
    ld r1, nandend1
    add r tr, 1
    nand r1, nandend2     ; Immediate
    bne r1, r3, NANDERROR
    ld r1, nandend1
    add r tr, 1
    nand r1, mem[NANDMEM]
    bne r1, r3, NANDERROR
    ld r1, nandend1
    add r tr, 1
    ldl r4, NANDMEM1 - NANDMEM
    nand r1, r4, mem[NANDMEM]
    bne r1, r3, NANDERROR
    add r tr, 1
    jmp NANDCOMP

NANDMEM:
    #d32 nandend2
    #res 2
NANDMEM1:
    #d32 nandend2
NANDERROR:
    add r ER, 1
NANDCOMP:
    rtn r SP1


ORTEST:
; OR Instruction Tests
orend1 = 12345
orend2 = 23456
orresults = orend1 | orend2
    ld r tr, 0x80
    ld r1, orend1
    ld r2, orend2
    ld r3, orresults
    add r tr, 1
    or r1, r2          ; Register
    bne r1, r3, ORERROR
    ld r1, orend1
    add r tr, 1
    or r1, orend2     ; Immediate
    bne r1, r3, ORERROR
    ld r1, orend1
    add r tr, 1
    or r1, mem[ORMEM]
    bne r1, r3, ORERROR
    ld r1, orend1
    add r tr, 1
    ldl r4, ORMEM1 - ORMEM
    or r1, r4, mem[ORMEM]
    bne r1, r3, ORERROR
    add r tr, 1
    jmp ORCOMP

ORMEM:
    #d32 orend2
    #res 2
ORMEM1:
    #d32 orend2
ORERROR:
    add r ER, 1
ORCOMP:
    rtn r SP1


NORTEST:
; NOR Instruction Tests
norend1 = 12345
norend2 = 23456
norresults = !(norend1 | norend2)
    ld r tr, 0x90
    ld r1, norend1
    ld r2, norend2
    ld r3, norresults
    add r tr, 1
    nor r1, r2          ; Register
    bne r1, r3, NORERROR
    ld r1, norend1
    add r tr, 1
    nor r1, norend2     ; Immediate
    bne r1, r3, NORERROR
    ld r1, norend1
    add r tr, 1
    nor r1, mem[NORMEM]
    bne r1, r3, NORERROR
    ld r1, norend1
    add r tr, 1
    ldl r4, NORMEM1 - NORMEM
    nor r1, r4, mem[NORMEM]
    bne r1, r3, NORERROR
    add r tr, 1
    jmp NORCOMP

NORMEM:
    #d32 norend2
    #res 2
NORMEM1:
    #d32 norend2
NORERROR:
    add r ER, 1
NORCOMP:
    rtn r SP1

XORTEST:
; XOR Instruction Tests
xorend1 = 12345
xorend2 = 23456
xorresults = xorend1 ^ xorend2
    ld r tr, 0xa0
    ld r1, xorend1
    ld r2, xorend2
    ld r3, xorresults
    add r tr, 1
    xor r1, r2          ; Register
    bne r1, r3, XORERROR
    ld r1, xorend1
    add r tr, 1
    xor r1, xorend2     ; Immediate
    bne r1, r3, XORERROR
    ld r1, xorend1
    add r tr, 1
    xor r1, mem[XORMEM]
    bne r1, r3, XORERROR
    ld r1, xorend1
    add r tr, 1
    ldl r4, XORMEM1 - XORMEM
    xor r1, r4, mem[XORMEM]
    bne r1, r3, XORERROR
    add r tr, 1
    jmp XORCOMP

XORMEM:
    #d32 xorend2
    #res 2
XORMEM1:
    #d32 xorend2
XORERROR:
    add r ER, 1
XORCOMP:
    rtn r SP1


XNORTEST:
; XNOR Instruction Tests
xnorend1 = 12345
xnorend2 = 23456
xnorresults = !(xnorend1 ^ xnorend2)
    ld r tr, 0xb0
    ld r1, xnorend1
    ld r2, xnorend2
    ld r3, xnorresults
    add r tr, 1
    xnor r1, r2          ; Register
    bne r1, r3, XNORERROR
    ld r1, xnorend1
    add r tr, 1
    xnor r1, xnorend2     ; Immediate
    bne r1, r3, XNORERROR
    ld r1, xnorend1
    add r tr, 1
    xnor r1, mem[XNORMEM]
    bne r1, r3, XNORERROR
    ld r1, xnorend1
    add r tr, 1
    ldl r4, XNORMEM1 - XNORMEM
    xnor r1, r4, mem[XNORMEM]
    bne r1, r3, XNORERROR
    add r tr, 1
    jmp XNORCOMP

XNORMEM:
    #d32 xnorend2
    #res 2
XNORMEM1:
    #d32 xnorend2
XNORERROR:
    add r ER, 1
XNORCOMP:
    rtn r SP1


SLLTEST:
; SLL Instruction Tests
sllend1 = 12345
sllend2 = 10
sllresults = (sllend1 << sllend2)[31:0]
    ld r tr, 0xc0
    ld r1, sllend1
    ld r2, sllend2
    ld r3, sllresults
    add r tr, 1
    sll r1, r2          ; Register
    bne r1, r3, SLLERROR
    ld r1, sllend1
    add r tr, 1
    sll r1, sllend2     ; Immediate
    bne r1, r3, SLLERROR
    ld r1, sllend1
    add r tr, 1
    sll r1, mem[SLLMEM]
    bne r1, r3, SLLERROR
    ld r1, sllend1
    add r tr, 1
    ldl r4, SLLMEM1 - SLLMEM
    sll r1, r4, mem[SLLMEM]
    bne r1, r3, SLLERROR
    add r tr, 1
    jmp SLLCOMP

SLLMEM:
    #d32 sllend2
    #res 2
SLLMEM1:
    #d32 sllend2
SLLERROR:
    add r ER, 1
SLLCOMP:
    rtn r SP1


SRLTEST:
; SRL Instruction Tests
srlend1 = 12345
srlend2 = 5
srlresults = srlend1 >> srlend2
    ld r tr, 0xd0
    ld r1, srlend1
    ld r2, srlend2
    ld r3, srlresults
    add r tr, 1
    srl r1, r2          ; Register
    bne r1, r3, SRLERROR
    ld r1, srlend1
    add r tr, 1
    srl r1, srlend2     ; Immediate
    bne r1, r3, SRLERROR
    ld r1, srlend1
    add r tr, 1
    srl r1, mem[SRLMEM]
    bne r1, r3, SRLERROR
    ld r1, srlend1
    add r tr, 1
    ldl r4, SRLMEM1 - SRLMEM
    srl r1, r4, mem[SRLMEM]
    bne r1, r3, SRLERROR
    add r tr, 1
    jmp SRLCOMP

SRLMEM:
    #d32 srlend2
    #res 2
SRLMEM1:
    #d32 srlend2
SRLERROR:
    add r ER, 1
SRLCOMP:
    rtn r SP1

; Branch Tests
eqtest = 0x4444
lesstest = 0x2222
greaterTest = 0x6666
BRTEST:
    ld r tr, 0x30
    ld r1, eqtest
    ld r2, eqtest
    ld r3, lesstest
    ld r4, greaterTest
BETESTNE:
    be r1, r3, BRERR   ; FALSE [R1 > R3]- No branch
    add r tr, 1
    be r1, r4, BRERR   ; FALSE [R1 < R4]- No branch
    add r tr, 1
BETEST:
    bne r1, r2, BRERR ; FALSE [r1 = r2] - No Branch
    add r tr, 1
    be r1, r2, BETEST1  ; TRUE [r1 = r2]- Branch Immediate
    jmp BRERR
BETESTMEM:
    #d32 BLTESTNE
BETEST1:
    add r tr, 1
    bne r1, r2, mem[BRCOMPMEM] ; FALSE [r1 = r2] - No Branch
    add r tr, 1
    be r1, r2, mem[BETESTMEM]  ; TRUE [r1 = r2] - Branch Memory
    jmp BRERR
BLTESTNE:
    add r tr, 1
    bge r3, r1, BRERR    ; FALSE [R2 >= R1] = No Branch
    add r tr, 1
    blt r2, r1, BRERR   ; FALSE [R2 = R1] - No branch
    add r tr, 1
    blt r4, r1, BRERR   ; FALSE [r4 > r1] - No branch
    add r tr, 1
BLTEST:
    blt r3, r1, BLTEST1  ; TRUE [r3 < r1]- Branch Immediate
    jmp BRERR

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
    bgt r2, r1, BRERR   ; FALSE [R2 = R1] - No branch
    add r tr, 1
    bgt r3, r1, BRERR   ; FALSE [r3 < r1] - No branch
    add r tr, 1
BGTEST:
    bgt r4, r1, BGTEST1  ; TRUE [r4 > r1]- Branch Immediate
    jmp BRERR
BRCOMPMEM:
    #d32 BRERR
BGTEST2MEM:
    #d32 BGTEST2
BGTEST1:
    add r tr, 1
    bgt r4, r1, mem[BGTEST2MEM]  ; TRUE [r4 > r1] - Branch Memory
    jmp BRERR
    noop
BGTEST2:
    add r tr, 1
    jmp BRCOMPLETE

BRERR:
    add r ER, 1

BRCOMPLETE:
    rtn r SP1

; Branch Tests #2
zerotest = 0
negtest = -10000
posTest = 20000
BRTEST2:
    ld r tr, 0x130
    ld r1, zerotest
    ld r2, zerotest
    ld r3, negtest
    ld r4, posTest
BETESTZERO:
    be r3, BR2ERR   ; FALSE [R3 /= 0]- No branch
    add r tr, 1
    bz r4, BR2ERR   ; FALSE [R4 /= 0]- No branch
    add r tr, 1
    bnz r1, BR2ERR ; FALSE [r1 = 0] - No Branch
    add r tr, 1
    be r1, BEZEROTEST  ; TRUE [r1 = 0]- Branch Immediate
    jmp BR2ERR
BZTESTMEM:
    #d32 BNTESTNE
BEZEROTEST:
    add r tr, 1
    bne r1, mem[BR2COMPMEM] ; FALSE [r1 = r2] - No Branch
    add r tr, 1
    be r1, mem[BZTESTMEM]  ; TRUE [r1 = r2] - Branch Memory
    jmp BRERR
BNTESTNE:
    add r tr, 1
    bge r3, BRERR    ; FALSE [R2 >= 0] = No Branch
    add r tr, 1
    bn r1, BRERR   ; FALSE [R2 = R1] - No branch
    add r tr, 1
    blt r4, BRERR   ; FALSE [r4 > 0] - No branch
    add r tr, 1
BNTEST:
    bn r3, BNTEST1  ; TRUE [r3 < 0]- Branch Immediate
    jmp BRERR

BNTESTMEM:
    #d32 BPTESTNE
BNTEST1:
    add r tr, 1
    bge r3, mem[BNTESTMEM]  ; FALSE [r3 < 0] - Branch Memory
    add r tr, 1
    blt r3, mem[BNTESTMEM]  ; TRUE [r3 < 0] - Branch Memory
    noop
BPTESTNE:
    add r tr, 1
    bgt r2, BR2ERR   ; FALSE [R2 = 0] - No branch
    add r tr, 1
    bgt r3, BR2ERR   ; FALSE [r3 < 0] - No branch
    add r tr, 1
BPTEST:
    bp r4, BPTEST1  ; TRUE [r4 > 0]- Branch Immediate
    jmp BRERR
BR2COMPMEM:
    #d32 BR2ERR
BPTEST2MEM:
    #d32 BGTEST2
BPTEST1:
    add r tr, 1
    bgt r4, r1, mem[BPTEST2MEM]  ; TRUE [r4 > r1] - Branch Memory
    jmp BRERR
    noop
BPTEST2:
    add r tr, 1
    jmp BR2COMPLETE

BR2ERR:
    add r ER, 1

BR2COMPLETE:
    rtn r SP1

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
    rtn r SP1

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
