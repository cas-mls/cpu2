
; This is compiled by CustomAsm https://github.com/hlorenzi/customasm/wiki


#include "Cpu2Defns.asm"

#bank program


INT0:
    #d32    START

SP1 = 15 ; Stack Pointer Register
Stack1 = 0xB00 ; Stack Location

LedIo = 3 ; IO Address for the Leds
WaitRes = 100000000 / 100000 ; 1 Clocks in one millisecond
Wait = 50000 ; Wait Time 1/2 second.
MaxCount = 16 ; Count 0 to 15
CountReg = 1; 
MaxCountReg = 2;
WaitReg = 3;

#addr 32
START:
    ld r SP1,  Stack1
    ld r CountReg, #0 ; initialize the count
    ld r MaxCountReg, MaxCount
    ld r WaitReg, Wait
LOOP:
    wio r CountReg, LedIo   ; Display LED count
    wait r WaitReg, WaitRes ; Wait 1/2 second
    add r CountReg, #1
    blt r CountReg, r MaxCountReg, LOOP
    ldl  r CountReg, #0
    jmp LOOP
