;   ********
;   TASK2.ASM
;   This file contains the code for task 2. A timer blinks an LED in 20 ms
;   intervals.
;   ********

DEC_CS      EQU     P3.2                ; chip select pin for decoder
DEC_BUS     EQU     P3                  ; port of address bus (2 least significant bits used)
SEG_BUS     EQU     P1                  ; segment bus

            jmp     start               ; jump over interrupt handler
            
            ORG     00Bh                ; timer overflow interrupt handler
            mov     A, SEG_BUS          ; toggle single segment
            xrl     A, #1h
            mov     SEG_BUS, A
            
            mov     TH0, #0B1h          ; reset timer and return
            mov     TL0, #0E7h
            reti

start:      mov     TMOD, #00000001b    ; configure timer 0 to mode 1
            setb    TR0                 ; enable timer 0
            setb    EA                  ; enable global interrupts
            setb    ET0                 ; enable timer 0 overflow interrupt
            
            mov     TH0, #0B1h          ; set timer 0 to 2^16 - 20000 + 7 (overhead)
            mov     TL0, #0E7h
            
            setb    DEC_CS              ; enable leftmost digit
            orl     DEC_BUS, #3h
            
            jmp     $

END
