;   ********
;   TASK2.ASM
;   This code toggles a led when a key on the keypad is pressed.
;   ********

LED_PORT    EQU     P1                  ; set symbols for input and output pins
KEYPAD      EQU     P0

            ORG     0h
            jmp     start               ; jump over interrupt handler
            
            ORG     013h
            xrl     LED_PORT, #1        ; interrupt handler: toggle LED
            reti

start:      mov     LED_PORT, #0FFh     ; disable all LEDs
            mov     KEYPAD, #01110000b  ; drive all rows low, configure columns as inputs
            
            setb    IT1                 ; make external interrupt edge-triggered
            setb    EX1                 ; enable external interrupt 1
            setb    EA                  ; enable global interrupts
            
            jmp     $
END
