;   ********
;   TASK1A.ASM
;   This file contains the 8-bit variant of task 1.
;   ********

LCD_DB      EQU     P1                  ; set symbols for output pins
LCD_E       EQU     P3.0
LCD_RS      EQU     P3.1

            clr     LCD_E               ; clear output pins
            clr     LCD_RS
            
            mov     A, #30              ; wait for 30 ms for the LCD to initialize
            call    waitMs
            
            mov     LCD_DB, #00111000B  ; function set, 8-bit mode, 2-line display
            call    sendComm
            mov     LCD_DB, #00001110B  ; display on, cursor on, blinking off
            call    sendComm
            mov     LCD_DB, #00000001B  ; clear display
            call    sendComm
            mov     LCD_DB, #00000110B  ; entry mode set, increment, no shift
            call    sendComm
            
            mov     LCD_DB, #'M'        ; send character to display
            call    sendData
            
            jmp     $

sendComm:   clr     LCD_RS              ; clear RS for non-data instructions
            setb    LCD_E               ; toggle E pin
            clr     LCD_E
            
            mov     A, LCD_DB           ; if the command is clear display or cursor home, wait for 2 ms
            dec     A
            jz      longWait
            dec     A
            jz      longWait
            dec     A
            jz      longWait
            
            mov     A, #30              ; otherwise, wait for 40 us (including overhead from jz)
            call    waitUs
            ret
            
longWait:   mov     A, #2
            call    waitMs
            ret
            
sendData:   setb    LCD_RS              ; set RS for data instructions
            setb    LCD_E               ; toggle E pin
            clr     LCD_E
            
            mov     A, #40              ; wait for 40 us
            call    waitUs
            ret
            
waitMs:     clr     C                   ; wait (A * 2 * 2 * 250) microseconds = A milliseconds
            rlc     A
msInner:    mov     R0, #248            ; value 248 accounts for overhead from dec + jnz
            djnz    R0, $
            dec     A
            jnz     msInner
            ret
            
waitUs:     clr     C                   ; clear carry for subtraction and right shift
            subb    A, #7               ; wait (A / 2 * 2) microseconds, 7 accounts for overhead
            rrc     A
            mov     R0, A
            djnz    R0, $
            ret
END
