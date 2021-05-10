;   ********
;   TASK1.ASM
;   This file contains the code for task 1. A dedicated subroutine allows the
;   caller to display the specified digit at the specified position.
;   ********

DEC_CS      EQU     P3.2                ; chip select pin for decoder
DEC_PORT    EQU     P3                  ; port of 2-bit address bus
DEC_OFFSET  EQU     3                   ; offset of 2-bit address bus
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
            
main:       mov     R0, #0              ; example calls to digit displaying subroutine
            mov     R1, #2
            call    showDigit
            
            mov     R0, #1
            mov     R1, #1
            call    showDigit
            
            mov     R0, #2
            mov     R1, #3
            call    showDigit
            
            mov     R0, #3
            mov     R1, #7
            call    showDigit
            
            jmp     main                ; loop over calls to demonstrate that they work
            
showDigit:  ret
