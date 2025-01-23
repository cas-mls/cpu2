
#include "Cpu2Defns.asm"

#bank program

INT0:
    ; jmp START
    #d32    START
STATUSINT:
    #d32    STATUSHANDLER
INT2:
    #d32    SWINT
INT3:
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
    jsr r SP1, OVERFLOWTEST
    wio r tr, 0x03    
    ;swi 0
    jmp LOOP

STATUSHANDLER:
    swd r4              ; Get Status Word
    add r tr, 10
    RTI

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
    ld r1, 0b100
    ld r5, SWIntTestValue
    ld r4, 0x0
    ld r2, 2
    swi r2
    bnz r4, INTERR
    add r tr, 1
    iena r SP1, r1
    swi 2
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
    iena r SP1, 0b1000
    iena r SP1, mem[INTMASK] ; disable all interrupts.
    bne r6, r7, INTERR
    jmp INTCOMPLETE

INTSW:
    #d32 2

INTMASK:
    #d32 0

INTERR:
    add r ER, 1

INTCOMPLETE:
    rtn r SP1


; Input / Output Tests.
; R0 - Not used
; R1 - ???
; R2 - IO Address
; R3 - Data
; R4 - ???
; R5 - IO Status
IOTESTS:
    ldl r tr, 0x100
    ld  r3, 0x0F ; Data
    ld  r2, 0x01 ; Address
    ld  r1, r3
    wio r1, r2
    wsio r5, r2
    bnz r5, IOERR
    add r tr, 1
    ld  r1, 0x00
    rio r1, r2
    rsio r5, r2
    bne r5, IOERR
    bne r1, r3, IOERR
    add r tr, 1
    ldl r2, 0x02
    wio r1, r2
    wsio r5, r2
    bz r5, IOERR

    ld  r1, r3
    wio r1, 0x1
    wsio r5, 0x1
    bne r5, IOERR
    add r tr, 1
    ld  r1, 0x00
    rio r1, 0x1
    rsio r5, 0x1
    bne r5, IOERR
    bne r1, r3, IOERR
    add r tr, 1
    ldl r2, 0x02
    wio r1, 0x2
    wsio r5, 0x2
    bz r5, IOERR

    ld  r2, 0x01 ; IO Address
    ld  r3, mem[WRITEMEM] ; Data
    ld  r1, 0x00
    wio r2, mem[WRITEMEM]
    wsio r5, r2
    bnz r5, IOERR
    add r tr, 1
    rio r2, mem[READMEM]
    rsio r5, r2
    ld r1, mem[READMEM]
    bnz r5, IOERR
    bne r1, r3, IOERR
    add r tr, 1

    ldl r2, 0x02
    wio r2, mem[WRITEMEM]
    wsio r5, r2
    be r5, IOERR            ; test status not zero.
    add r tr, 1

    ld  r4, -2 ; index -- try negative numbers.
    ld  r2, 0x01 ; IO Address
    ld  r3, mem[WRITEMEM] ; Data
    ld  r1, 0x00
    wio r2, r4, mem[WRITEMEM + 2]
    wsio r5, r2
    bnz r5, IOERR
    add r tr, 1
    ld  r1, 0x00
    st r1, mem[READMEM]
    rio r2, r4, mem[READMEM + 2]
    rsio r5, r2
    ld r1, mem[READMEM]
    bnz r5, IOERR
    bne r1, r3, IOERR
    add r tr, 1



    add r tr, 1
    jmp IOCOMPLETE

READMEM:
    #d32 0x55555555
WRITEMEM:
    #d32 0xff
IOERR:
    add r ER, 1
IOCOMPLETE:
    rtn r SP1

OVERFLOWTEST:
ovAddend1 = 0x7FFFFFFF
ovAddend2 = 10
ovSum = ovAddend1 + ovAddend2
    ld r tr, 0x20
    ld r1, ovAddend1
    ld r2, ovAddend2
    ld r3, ovSum
    ld r4, 0b000        ; Status Word
    ld r5, 0b100        ; Overflow Bit
    add r1, r2          ; Register Overflow
    swd r4              ; Get Status Word

    bne r1, r3, OVERERROR ; check Add Result
    add r tr, 1
    bne r4, r5, OVERERROR   ; Check Overlow Status Bit
    add r tr, 1

    ld r4, 0b000        ; Status Word
    IENA r SP1, 0b10    ; Status Interrupt
    swm 0b100           ; Overflow Interrupt
    ld r1, ovAddend1
    add r1, r2          ; Register Overflow
    bne r4, r5, OVERERROR   ; Check Overlow Status Bit
    ld r1, ovAddend1

    jmp OVERFLOWCOMPLETE

OVERERROR:
    add r ER, 1

OVERFLOWCOMPLETE:
    rtn r SP1
