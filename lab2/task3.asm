;   ********
;   TASK3.ASM
;   This file contains the code for task 3. Displays the last four digit of the
;   album number.
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
ALBUM:      DB      2, 8, 1, 0          ; album number in reverse order

            ORG     0h
            jmp     start               ; jump over interrupt handler
            
            ORG     00Bh                ; timer overflow interrupt handler
            mov     A, R0               ; fetch album digit from memory
            mov     DPL, #LOW(ALBUM)
            mov     DPH, #HIGH(ALBUM)
            movc    A, @A+DPTR
            mov     R1, A
            
            call    showDigit           ; call digit displaying subroutine
                                        ; R0 - position, R1 - digit
            
            mov     A, R0               ; decrement iterator and calculate modulo 4
            dec     A
            anl     A, #3h
            mov     R0, A
            
            reti
            
start:      mov     TMOD, #00000001b    ; configure timer 0 to mode 1
            setb    TR0                 ; enable timer 0
            setb    EA                  ; enable global interrupts
            setb    ET0                 ; enable timer 0 overflow interrupt
            
            mov     R0, #3              ; set iterator to 3 and let interrupts handle the animation
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