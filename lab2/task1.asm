;   ********
;   TASK1.ASM
;   This file contains the code for task 1. A dedicated subroutine allows the
;   caller to display the specified pattern at the specified position.
;   ********

DEC_CS      EQU     P3.2                ; chip select pin for decoder
DEC_BUS     EQU     P3                  ; port of address bus (2 least significant bits used)
SEG_BUS     EQU     P1                  ; segment bus

            ORG     0F00h
DIGITS:     DB      11000000b           ; digit pattern lookup table
            DB      11111001b
            DB      10100100b
            DB      10110000b
            DB      10011001b
            DB      10010010b
            DB      10000010b
            DB      11111000b
            DB      10000000b
            DB      10010000b

            ORG     0h
            clr     DEC_CS              ; clear output pin
            
            mov     R0, #3              ; example call to digit displaying subroutine
            mov     R1, #2              ; argument 1: position; argument 2: digit
            call    showDigit
            
            jmp     $

showDigit:  clr     DEC_CS              ; disable decoder

            mov     A, R1               ; fetch digit pattern from memory
            mov     DPL, #LOW(DIGITS)
            mov     DPH, #HIGH(DIGITS)
            movc    A, @A+DPTR
            mov     SEG_BUS, A          ; move pattern to segment bus
            
            mov     A, DEC_BUS
            anl     A, #0FCh            ; clear bits of address bus
            orl     A, R0               ; set address
            mov     DEC_BUS, A
            
            setb    DEC_CS              ; enable decoder
            ret

END
