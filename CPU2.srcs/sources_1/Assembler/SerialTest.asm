
; This is compiled by CustomAsm https://github.com/hlorenzi/customasm/wiki


#include "Cpu2Defns.asm"

#bank program

SP1 = 15 ; Stack Pointer Register
Stack1 = 0xB00 ; Stack Location
IOADDR = 4;
RINDEX = 5;
WINDEX = 6;
BUSY = 0b1`16

LedIo = 3 ; IO Address for the Leds
WaitRes = 100000000 / 100000 ; 1 Clocks in one millisecond
Wait = 50000 ; Wait Time 1/2 second.
MaxCount = 16 ; Count 0 to 15
CountReg = 1; 
MaxCountReg = 2;
WaitReg = 3;


INT0:
    #d32    START

SERIALINTERRUPT:
#addr 12
    #d32    SERIALHANDLER

#addr 32
START:
    ld r SP1,  Stack1
    ld r CountReg, 0 ; initialize the count
    ld r MaxCountReg, MaxCount
    ld r WaitReg, Wait
    ld r IOADDR, 12
    ld r RINDEX, 0
    ld r WINDEX, 0
    iena r SP1, 0b1000000000000`16
    jsr r SP1, WRITESERIAL
    jsr r SP1, WRITESERIAL
    jsr r SP1, WRITESERIAL
    jsr r SP1, WRITESERIAL

LOOP:
    wio r CountReg, LedIo   ; Display LED count
    wait r WaitReg, WaitRes ; Wait 1/2 second
    add r CountReg, 1
    blt r CountReg, r MaxCountReg, LOOP
    ldl  r CountReg, 0
    jsr r SP1, WRITESERIAL
    jmp LOOP
WRITESERIAL:
    push    r SP1, R10
LOOPWB:
    wsio    r10, r IOADDR
    and     r10, 0b1`16
    bnz     r10, LOOPWB
    wio     r IOADDR, r WINDEX, mem[WRITEDATA]
    add     r WINDEX, 1
    ld      r10, 3
    blt     r WINDEX, r10, WRITERET
    ld      r WINDEX, 1
WRITERET:
    pop     r SP1, r10
    rtn     r SP1

SERIALHANDLER:
    push    r SP1, R10
    ; push    r SP1, R11
LOOPRB:
    rsio    r10, r IOADDR
    ; ld      R11, R10
    and     r10, 0b1`16
    bnz     r10, LOOPRB
    ; and     r11, 0b1000`16
    ; bz      r11, LOOPRB
    rio     r IOADDR, r RINDEX, mem[READDATA]
    add     R RINDEX, 1
    ; pop     r SP1, r11
    pop     r SP1, r10
    rti

WRITEDATA:
    #d32    "\0\0\01"
    #d32    "\0\0\02"
    #d32    "\0\0\03"
READDATA:
