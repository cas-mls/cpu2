
#once
; This is compiled by CustomAsm https://github.com/hlorenzi/customasm/wiki
                                                    ; Instruction fields:
                                                    ; | op  | flg | mem | r1 | r2 | imm

#subruledef operands
{
    r{r1: u4}, r{r2: u4}                        => 0`2 @ r1 @ r2 @ 0x0000
    r{r1: u4}, {imm: u16}                       => 1`2 @ r1 @ 0x0 @ imm
    r{r1: u4}, r{r2: u4}, {imm: u16}            => 1`2 @ r1 @ r2 @ imm
    r{r1: u4}, [{address: u16}]                 => 2`2 @ r1 @ 0x0 @ address
    r{r1: u4}, [{address: u16}+r{r2: u4}]       => 3`2 @ r1 @ r2 @ address

    r{r1: u4}, mem[{address: u16}]              => 2`2 @ r1 @ 0x0 @ address
    r{r1: u4}, r{r2: u4}, mem[{address: u16}]   => 3`2 @ r1 @ r2 @ address
}

#subruledef branchop
{
    r{r1: u4}, r{r2: u4}, {imm: u16}            => 1`2 @ r1 @ r2 @ imm
    r{r1: u4}, r{r2: u4}, mem[{address: u16}]   => 2`2 @ r1 @ r2 @ address
    r{r1: u4}, {imm: u16}                       => 1`2 @ r1 @ 0x0 @ imm
    r{r1: u4}, [{address: u16}]                 => 2`2 @ r1 @ 0x0 @ address

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
    ld  r{r1: u4}, [{address: u16}]                 => 2`5  @ 0`1 @ 2`2 @ r1 @ 0x0 @ address
    ld  r{r1: u4}, [{address: u16}+r{r2: u4}]       => 2`5  @ 0`1 @ 3`2 @ r1 @ r2 @ address
    st  r{r1: u4}, [{address: u16}]                 => 4`5  @ 0`1 @ 2`2 @ r1 @ 0x0 @ address
    st  r{r1: u4}, [{address: u16}+r{r2: u4}]       => 4`5  @ 0`1 @ 3`2 @ r1 @ r2 @ address

    ld  r{r1: u4}, mem[{address: u16}]              => 2`5  @ 0`1 @ 2`2 @ r1 @ 0x0 @ address
    ld  r{r1: u4}, r{r2: u4}, mem[{address: u16}]   => 2`5  @ 0`1 @ 3`2 @ r1 @ r2 @ address
    st  r{r1: u4}, mem[{address: u16}]              => 4`5  @ 0`1 @ 2`2 @ r1 @ 0x0 @ address
    st  r{r1: u4}, r{r2: u4}, mem[{address: u16}]   => 4`5  @ 0`1 @ 3`2 @ r1 @ r2 @ address

    ; ADD
    add {op : operands}                             => 1`5  @ 0`1 @ op
    uadd {op : operands}                            => 1`5  @ 1`1 @ op

    ; SUBTRACT
    sub {op : operands}                             => 3`5  @ 0`1 @ op
    usub {op : operands}                            => 3`5  @ 1`1 @ op

    ; MULTIPLY
    mult {op : operands}                             => 5`5  @ 0`1 @ op
    umult {op : operands}                            => 5`5  @ 1`1 @ op

    ; DIVIDE
    div {op : operands}                             => 7`5  @ 0`1 @ op
    udiv {op : operands}                            => 7`5  @ 1`1 @ op

    ; Logical AND/NAND
    and {op : operands}                             => 9`5  @ 0`1 @ op
    nand {op : operands}                             => 9`5  @ 1`1 @ op

    ; Logical OR/NOR
    or  {op : operands}                             => 11`5  @ 0`1 @ op
    nor {op : operands}                             => 11`5  @ 1`1 @ op
    
    ; Logical XOR/NXOR
    xor {op : operands}                             => 13`5  @ 0`1 @ op
    xnor {op : operands}                             => 13`5  @ 1`1 @ op

    ; Shift Register
    sll {op : operands}                             => 15`5  @ 0`1 @ op
    srl {op : operands}                             => 15`5  @ 1`1 @ op

    ; JUMP
    jmp r{r2: u4}                                   => 6`5  @ 0`1 @ 0`2 @ 0x0 @ r2 @ 0x0000
    jmp {imm: u16}                                  => 6`5  @ 0`1 @ 1`2 @ 0x0 @ 0x0 @ imm
    jmp [{address: u16}]                            => 6`5  @ 0`1 @ 2`2 @ 0x0 @ 0x0 @ address
    jmp [{address: u16}+r{r2: u4}]                  => 6`5  @ 0`1 @ 3`2 @ 0x0 @ r2 @ address

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
    bz  r{r1: u4}, [{address: u16}]                 => 12`5 @ 0`1 @2`2 @ r1 @ 0x0 @ address
    bnz r{r1: u4}, {imm: u16}                       => 12`5 @ 1`1 @1`2 @ r1 @ 0x0 @ imm
    bnz r{r1: u4}, [{address: u16}]                 => 12`5 @ 1`1 @2`2 @ r1 @ 0x0 @ address
    bn  r{r1: u4}, {imm: u16}                       => 14`5 @ 0`1 @1`2 @ r1 @ 0x0 @ imm
    bn  r{r1: u4}, [{address: u16}]                 => 14`5 @ 0`1 @2`2 @ r1 @ 0x0 @ address
    bp  r{r1: u4}, {imm: u16}                       => 16`5 @ 0`1 @1`2 @ r1 @ 0x0 @ imm
    bp  r{r1: u4}, [{address: u16}]                 => 16`5 @ 0`1 @2`2 @ r1 @ 0x0 @ address

    bz  r{r1: u4}, mem[{address: u16}]              => 12`5 @ 0`1 @2`2 @ r1 @ 0x0 @ address
    bnz r{r1: u4}, mem[{address: u16}]              => 12`5 @ 1`1 @2`2 @ r1 @ 0x0 @ address
    bn  r{r1: u4}, mem[{address: u16}]              => 14`5 @ 0`1 @2`2 @ r1 @ 0x0 @ address
    bp  r{r1: u4}, mem[{address: u16}]              => 16`5 @ 0`1 @2`2 @ r1 @ 0x0 @ address

    ; Subroutine
    jsr r{r1: u4}, r{r2: u4}                        => 8`5  @ 0`1 @ 0`2 @ r1 @ r2  @ 0x0000
    jsr r{r1: u4}, {imm: u16}                       => 8`5  @ 0`1 @ 1`2 @ r1 @ 0x0 @ imm
    rtn r{r1: u4}                                   => 10`5 @ 0`1 @ 0`2 @ r1 @ 0x0 @ 0x0000

    ; Input / Output
    rio r{r1: u4}, r{r2: u4}                        => 22`5  @ 0`1 @ 0`2 @ r1 @ r2 @ 0x0000
    rio r{r1: u4}, {imm: u16}                       => 22`5  @ 0`1 @ 1`2 @ r1 @ 0x0 @ imm
    rio r{r2: u4}, [{address: u16}]                 => 22`5  @ 0`1 @ 2`2 @ 0x0 @ r2 @ address
    rio r{r1: u4}, r{r2: u4}, mem[{address: u16}]   => 22`5  @ 0`1 @ 3`2 @ r1 @ r2 @ address

    rio r{r2: u4}, mem[{address: u16}]              => 22`5  @ 0`1 @ 2`2 @ 0x0 @ r2 @ address

    wio r{r1: u4}, r{r2: u4}                        => 22`5  @ 1`1 @ 0`2 @ r1 @ r2 @ 0x0000
    wio r{r1: u4}, {imm: u16}                       => 22`5  @ 1`1 @ 1`2 @ r1 @ 0x0 @ imm
    wio r{r2: u4}, [{address: u16}]              => 22`5  @ 1`1 @ 2`2 @ 0x0 @ r2 @ address
    wio r{r1: u4}, r{r2: u4}, mem[{address: u16}]   => 22`5  @ 1`1 @ 3`2 @ r1 @ r2 @ address

    wio r{r2: u4}, mem[{address: u16}]              => 22`5  @ 1`1 @ 2`2 @ 0x0 @ r2 @ address
    
    rsio r{r1: u4}, r{r2: u4}                       => 24`5  @ 0`1 @ 0`2 @ r1 @ r2 @ 0x0000
    rsio r{r1: u4}, {imm: u16}                      => 24`5  @ 0`1 @ 1`2 @ r1 @ 0x0 @ imm
    wsio r{r1: u4}, r{r2: u4}                       => 24`5  @ 1`1 @ 0`2 @ r1 @ r2 @ 0x0000
    wsio r{r1: u4}, {imm: u16}                      => 24`5  @ 1`1 @ 1`2 @ r1 @ 0x0 @ imm

    ; Stack Operations
    push r{r1: u4}, r{r2: u4}                       => 18`5  @ 0`1 @ 0`2 @ r1 @ r2 @ 0x0000
    push r{r1: u4}, {imm: u16}                      => 18`5  @ 0`1 @ 1`2 @ r1 @ 0x0 @ imm
    pop r{r1: u4}, r{r2: u4}                        => 18`5  @ 1`1 @ 0`2 @ r1 @ r2 @ 0x0000

    ; Interrupt
    RTI                                             => 26`5  @ 0`1 @ 0`2 @ 0x0 @ 0x0 @ 0x0000
    SWI r{r1: u4}                                   => 28`5  @ 0`1 @ 0`2 @ r1 @ 0x0 @ 0x0000
    SWI {imm: u16}                                  => 28`5  @ 0`1 @ 1`2 @ 0x0 @ 0x0 @ imm
    SWI [{address: u16}]                         => 28`5  @ 0`1 @ 2`2 @ 0x0 @ 0x0 @ address
    IENA r{r1: u4}, r{r2: u4}                       => 28`5  @ 1`1 @ 0`2 @ r1 @ r2 @ 0x0000
    IENA r{r1: u4}, {imm: u16}                      => 28`5  @ 1`1 @ 1`2 @ r1 @ 0x0 @ imm
    IENA r{r1: u4}, [{address: u16}]             => 28`5  @ 1`1 @ 2`2 @ r1 @ 0x0 @ address

    SWI mem[{address: u16}]                         => 28`5  @ 0`1 @ 2`2 @ 0x0 @ 0x0 @ address
    IENA r{r1: u4}, mem[{address: u16}]             => 28`5  @ 1`1 @ 2`2 @ r1 @ 0x0 @ address

    ; Status word
    SWD r{r1: u4}                                   => 30`5  @ 0`1 @ 0`2 @ r1 @ 0x0 @ 0x0000
    SWM r{r2: u4}                                   => 30`5  @ 1`1 @ 0`2 @ 0x0 @ r2 @ 0x0000
    SWM {imm: u16}                                  => 30`5  @ 1`1 @ 1`2 @ 0x0 @ 0x0 @ imm
    SWM [{address: u16}]                         => 30`5  @ 1`1 @ 2`2 @ 0x0 @ 0x0 @ address

    SWM mem[{address: u16}]                         => 30`5  @ 1`1 @ 2`2 @ 0x0 @ 0x0 @ address

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

