
#include "Cpu2Defns.asm"

#bank program

INT0:
    ; jmp START
    #d32    START

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
    jsr r SP1, MULTTEST
    jsr r SP1, DIVTEST
    jsr r SP1, ADDTEST
    jsr r SP1, SUBTEST
    jsr r SP1, UADDTEST
    jsr r SP1, USUBTEST
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
    jsr r SP1, BRTEST2
    jsr r SP1, BRTEST
    jsr r SP1, JMPTEST
    wio r tr, 0x03    
    jmp LOOP


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


READMEM:
    #d32 0x55555555
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
    st  r4, [DATA1]          ; store address
    ld  r5, [DATA1]          ; Absolute address
    ldl r tr, 2
    bne r4, r5, LSERROR
lsOffset = DATA2-dataIndex
    st  r5, [lsOffset+r3]  ; Index + offset
    ld  r6, [lsOffset+r3]  ; Index + offset
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
ovAddend1 = 0x7FFFFFFF
ovAddend2 = 10
ovSum = ovAddend1 + ovAddend2
    ld r tr, 0x1f
    ld r1, ovAddend1
    ld r2, ovAddend2
    ld r3, ovSum
    add r1, r2          ; Register Overflow

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

UADDTEST:
; Unsigned Add Instruction Tests
uaddend1 = 12345
uaddend2 = 23456
usum = uaddend1 + uaddend2
    ld r tr, 0x10
    ld r1, uaddend1
    ld r2, uaddend2
    ld r3, usum
    add r tr, 1
    uadd r1, r2          ; Register
    bne r1, r3, UADDERROR
    ld r1, uaddend1
    add r tr, 1
    uadd r1, uaddend2     ; Immediate
    bne r1, r3, UADDERROR
    ld r1, uaddend1
    add r tr, 1
    uadd r1, mem[UAENDMEM]
    bne r1, r3, UADDERROR
    ld r1, uaddend1
    add r tr, 1
    ldl r4, UAENDMEM1 - UAENDMEM
    uadd r1, r4, mem[UAENDMEM]
    bne r1, r3, UADDERROR
    add r tr, 1
    jmp UADDCOMP

UAENDMEM:
    #d32 uaddend2
    #res 2
UAENDMEM1:
    #d32 uaddend2
UADDERROR:
    add r ER, 1
UADDCOMP:
    rtn r SP1



; Unsigned SUB Instruction Tests
usubend1 = 12345
usubend2 = 23456
udifference = usubend1 - usubend2
USUBTEST:
    ld r tr, 0x20
    ld r1, usubend1
    ld r2, usubend2
    ld r3, udifference
    add r tr, 1
    usub r1, r2          ; Register
    bne r1, r3, USUBER
    ld r1, usubend1
    add r tr, 1
    usub r1, usubend2     ; Immediate
    bne r1, r3, USUBER
    ld r1, usubend1
    add r tr, 1
    usub r1, mem[USENDMEM]
    bne r1, r3, USUBER
    ld r1, usubend1
    add r tr, 1
    ldl r4, USENDMEM1 - USENDMEM
    usub r1, r4, mem[USENDMEM]
    bne r1, r3, USUBER
    add r tr, 1
    jmp USUBCOMP

USENDMEM:
    #d32 usubend2
    #res 2
USENDMEM1:
    #d32 usubend2
USUBER:
    add r ER, 1
USUBCOMP:
    rtn r SP1

MULTTEST:
; MULT Instruction Tests
multend1 = 12345
multend2 = 23456
prod = multend1 * multend2
ovmultend1 = 0x7FFFFFFF
ovmultend2 = 10
ovprod = ovmultend1 * ovmultend2
    ld r tr, 0x1f
    ld r1, ovmultend1
    ld r2, ovmultend2
    ld r3, ovprod[31:0]
    mult r1, r2          ; Register Overflow

    ld r tr, 0x210
    ld r1, multend1
    ld r2, multend2
    ld r3, prod
    add r tr, 1
    mult r1, r2          ; Register
    bne r1, r3, MULTERROR
    ld r1, multend1
    add r tr, 1
    mult r1, multend2     ; Immediate
    bne r1, r3, MULTERROR
    ld r1, multend1
    add r tr, 1
    mult r1, mem[PRODMEM]
    bne r1, r3, MULTERROR
    ld r1, multend1
    add r tr, 1
    ldl r4, PRODMEM1 - PRODMEM
    mult r1, r4, mem[PRODMEM]
    bne r1, r3, MULTERROR
    add r tr, 1
    jmp MULTCOMP

PRODMEM:
    #d32 multend2
    #res 2
PRODMEM1:
    #d32 multend2
MULTERROR:
    add r ER, 1
MULTCOMP:
    rtn r SP1

DIVTEST:
; DIV Instruction Tests
divend1 = 12345 * 23456
divisor2 = 23456
quot = divend1 / divisor2

    ld r tr, 0x210
    ld r1, divend1
    ld r2, divisor2
    ld r3, quot
    add r tr, 1
    div r1, r2          ; Register
    bne r1, r3, DIVERROR
    ld r1, divend1
    add r tr, 1
    div r1, divisor2     ; Immediate
    bne r1, r3, DIVERROR
    ld r1, divend1
    add r tr, 1
    div r1, mem[QUOTMEM]
    bne r1, r3, DIVERROR
    ld r1, divend1
    add r tr, 1
    ldl r4, QUOTMEM1 - QUOTMEM
    div r1, r4, mem[QUOTMEM]
    bne r1, r3, DIVERROR
    add r tr, 1
    jmp DIVCOMP

QUOTMEM:
    #d32 divisor2
    #res 2
QUOTMEM1:
    #d32 divisor2
DIVERROR:
    add r ER, 1
DIVCOMP:
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
