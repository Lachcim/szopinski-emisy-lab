;   ********
;   TASK1.ASM
;   This file contains the code for task 1. A dedicated subroutine allows the
;   caller to display the specified pattern at the specified position.
;   ********

DEC_CS      EQU     P3.2                ; chip select pin for decoder
DEC_BUS     EQU     P3                  ; port of address bus (2 least significant bits used)
SEG_BUS     EQU     P1                  ; segment bus

            clr     DEC_CS              ; clear output pin
            
            mov     R0, #3              ; example call to pattern displaying subroutine
            mov     R1, #11110110b      ; argument 1: position; argument 2: pattern (pgfedcba)
            call    showPatt
            
            jmp     $

showPatt:   clr     DEC_CS              ; disable decoder
            
            mov     A, R1               ; invert bits of pattern
            xrl     A, #0FFh
            mov     SEG_BUS, A          ; move pattern to segment bus
            
            mov     A, DEC_BUS          ; clear 2 least significant bits of address bus
            anl     A, #0FCh
            orl     A, R0               ; set address
            mov     DEC_BUS, A
            
            setb    DEC_CS              ; enable decoder
            ret

END
