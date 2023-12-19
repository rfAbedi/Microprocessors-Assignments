.MODEL SMALL
.STACK 64
.DATA
    ; --- IO 8285 PORTS AND CR ---
    PORTA EQU 00H ; OUT - 1ST DIGIT
    PORTB EQU 02H ; OUT - 2ND DIGIT
    PORTC EQU 04H ; IN - KEYPAD
    CNTRLREG EQU 06H
    CNTRLBYTE EQU 10001001B
    ; --- KEYPAD COLUMN ACTIVATIONS ON PORT B ---
    FIRST_COL EQU 00100000B
    SECOND_COL EQU 01000000B
    THIRD_COL EQU 10000000B
    ; -------------------------------------------
    M DB ?
    N DB ?
    KPMN DB ?
    ; -------------------------------------------
    r DB 01H
    x_fact DB ? ; IS USED TO CALCULATE factorial of x
    n_fact DW ?
    r_fact DW ?
    n_r_fact DW ?
    comb DB ? ; ANSWER OF Combination
    OUTER_LOOP_COUNT_TEMP DW ?
    ; -------------------------------------------
.CODE  

MAIN    PROC FAR

    MOV AX, @DATA
	MOV DS, AX

    CALL SET_CNTRLREG
    CALL CLEAR_DIGITS 
    
    CALL TRACK_KEYPAD
    
    CALL DELAY
    CALL DELAY

    ; CALL CLEAR_DIGITS
    CALL CAL_KHPA
    CALL BCD7SEG
    CALL SHOW_NUMBER

ENDLESS:
	JMP ENDLESS

    ; MOV AH, 4CH
    ; INT 21H
MAIN    ENDP


TRACK_KEYPAD PROC
    MOV SI, 00H ; NUMBER OF NUMBERS TAKEN FROM KEYPAD

TRACKING_LOOP:
    CMP SI, 02H
    JE TRACKING_FINISH

    CHECK_FIRST_COL:
        MOV AL, FIRST_COL
        OUT PORTB, AL
        IN AL, PORTC
        AND AL, 0FH ; CHECKS IF ANY BUTTON IN COL IS PRESSED
        JNZ HANDLE_FIRST_COL

    CHECK_SECOND_COL:
        MOV AL, SECOND_COL
        OUT PORTB, AL
        IN AL, PORTC
        AND AL, 0FH ; CHECKS IF ANY BUTTON IN COL IS PRESSED
        JNZ HANDLE_SECOND_COL
    
    CHECK_THIRD_COL:
        MOV AL, THIRD_COL
        OUT PORTB, AL
        IN AL, PORTC
        AND AL, 0FH ; CHECKS IF ANY BUTTON IN COL IS PRESSED
        JNZ HANDLE_THIRD_COL

    JMP TRACKING_LOOP

    HANDLE_FIRST_COL: ; SWITCH CASE FOR CORRESPONDING COLUMN
        CASE_ONE:
            CMP AL, 01H
            JNE CASE_FOUR
            ; --- CHECKS WHETHER THE KEY IS HOLD FOR A PRIOD OF TIME ---
            CALL DELAY
            CALL DELAY
            CALL DELAY
            CALL DELAY
            CALL DELAY
            IN AL, PORTC
            CMP AL, 01H
            JNE CASE_FOUR
            ; -----------------------------------------------------------
            MOV BL, 01H
            CALL SAVE_MN_TO_BX
            JMP TRACKING_LOOP
        CASE_FOUR:
            CMP AL, 02H
            JNE CASE_SEVEN
            ; --- CHECKS WHETHER THE KEY IS HOLD FOR A PRIOD OF TIME ---
            CALL DELAY
            CALL DELAY
            CALL DELAY
            CALL DELAY
            CALL DELAY
            IN AL, PORTC
            CMP AL, 02H
            JNE CASE_SEVEN
            ; -----------------------------------------------------------
            MOV BL, 04H
            CALL SAVE_MN_TO_BX
            JMP TRACKING_LOOP
        CASE_SEVEN:
            CMP AL, 04H
            JNE CASE_STAR
            ; --- CHECKS WHETHER THE KEY IS HOLD FOR A PRIOD OF TIME ---
            CALL DELAY
            CALL DELAY
            CALL DELAY
            CALL DELAY
            CALL DELAY
            IN AL, PORTC
            CMP AL, 04H
            JNE CASE_STAR
            ; -----------------------------------------------------------
            MOV BL, 07H
            CALL SAVE_MN_TO_BX
            JMP TRACKING_LOOP
        CASE_STAR:
            JMP TRACKING_LOOP

    HANDLE_SECOND_COL: ; SWITCH CASE FOR CORRESPONDING COLUMN
        CASE_TWO:
            CMP AL, 01H
            JNE CASE_FIVE
            ; --- CHECKS WHETHER THE KEY IS HOLD FOR A PRIOD OF TIME ---
            CALL DELAY
            CALL DELAY
            CALL DELAY
            CALL DELAY
            CALL DELAY
            IN AL, PORTC
            CMP AL, 01H
            JNE CASE_FIVE
            ; -----------------------------------------------------------
            MOV BL, 02H
            CALL SAVE_MN_TO_BX
            JMP TRACKING_LOOP
        CASE_FIVE:
            CMP AL, 02H
            JNE CASE_EIGHT
            ; --- CHECKS WHETHER THE KEY IS HOLD FOR A PRIOD OF TIME ---
            CALL DELAY
            CALL DELAY
            CALL DELAY
            CALL DELAY
            CALL DELAY
            IN AL, PORTC
            CMP AL, 02H
            JNE CASE_EIGHT
            ; -----------------------------------------------------------
            MOV BL, 05H
            CALL SAVE_MN_TO_BX
            JMP TRACKING_LOOP
        CASE_EIGHT:
            CMP AL, 04H
            JNE CASE_ZERO
            ; --- CHECKS WHETHER THE KEY IS HOLD FOR A PRIOD OF TIME ---
            CALL DELAY
            CALL DELAY
            CALL DELAY
            CALL DELAY
            CALL DELAY
            IN AL, PORTC
            CMP AL, 04H
            JNE CASE_ZERO
            ; -----------------------------------------------------------
            MOV BL, 08H
            CALL SAVE_MN_TO_BX
            JMP TRACKING_LOOP
        CASE_ZERO:
            CMP AL, 08h
            JNE TRACKING_LOOP
            MOV BL, 00H
            CALL SAVE_MN_TO_BX
            JMP TRACKING_LOOP

    HANDLE_THIRD_COL: ; SWITCH CASE FOR CORRESPONDING COLUMN
        CASE_THREE:
            CMP AL, 01H
            JNE CASE_SIX
            ; --- CHECKS WHETHER THE KEY IS HOLD FOR A PRIOD OF TIME ---
            CALL DELAY
            CALL DELAY
            CALL DELAY
            CALL DELAY
            CALL DELAY
            IN AL, PORTC
            CMP AL, 01H
            JNE CASE_SIX
            ; -----------------------------------------------------------   
            MOV BL, 03H
            CALL SAVE_MN_TO_BX
            JMP TRACKING_LOOP
        CASE_SIX:
            CMP AL, 02H
            JNE CASE_NINE
            ; --- CHECKS WHETHER THE KEY IS HOLD FOR A PRIOD OF TIME ---
            CALL DELAY
            CALL DELAY
            CALL DELAY
            CALL DELAY
            CALL DELAY
            IN AL, PORTC
            CMP AL, 02H
            JNE CASE_NINE
            ; -----------------------------------------------------------
            MOV BL, 06H
            CALL SAVE_MN_TO_BX
            JMP TRACKING_LOOP
        CASE_NINE:
            CMP AL, 04H
            JNE CASE_HASH
            ; --- CHECKS WHETHER THE KEY IS HOLD FOR A PRIOD OF TIME ---
            CALL DELAY
            CALL DELAY
            CALL DELAY
            CALL DELAY
            CALL DELAY
            IN AL, PORTC
            CMP AL, 04H
            JNE CASE_HASH
            ; -----------------------------------------------------------
            MOV BL, 09H
            CALL SAVE_MN_TO_BX
            JMP TRACKING_LOOP
        CASE_HASH:
            JMP TRACKING_LOOP
    JMP TRACKING_LOOP
TRACKING_FINISH:
    RET
TRACK_KEYPAD ENDP


SAVE_MN_TO_BX PROC ; GETS BL AS PARAMTER
    CMP SI, 01H 
    JE SAVE_N ; FINISH IF THE PRESSED NUMBER IS N (LAST/2ND NUMBER)
SAVE_M: ; FIRST NUMBER
    MOV DH, BL
    JMP SAVE_FINISH
SAVE_N: ; SECOND NUMBER
    MOV DL, BL
    JMP SAVE_FINISH
SAVE_FINISH:
    CALL SHOW_NUMBER
    CALL DELAY
    INC SI
    RET
SAVE_MN_TO_BX ENDP


SHOW_NUMBER PROC ; GETS DX AS PARAMETER
    PUSH AX
    MOV AL, DH
    OUT PORTA, AL
    MOV AL, DL
    OUT PORTB, AL
    POP AX
    RET
SHOW_NUMBER ENDP


CLEAR_DIGITS PROC ; MAKES ALL DIGITS ZERO
    MOV DX, 0000H
    CALL SHOW_NUMBER
    RET
CLEAR_DIGITS ENDP


SET_CNTRLREG PROC
    MOV AL, CNTRLBYTE
    MOV DX, CNTRLREG
    OUT DX, AL
    RET
SET_CNTRLREG ENDP


DELAY PROC
   PUSH CX
   MOV CX, 0F000H
   LOOP1: 
      NOP
      LOOP LOOP1
   POP CX
RET
DELAY ENDP


CAL_KHPA    PROC
    DEC DH
    MOV M, DH
    DEC DL
    MOV N, DL

    ; --- M! ---
    MOV AH, M
    MOV x_fact, AH ; x = M
    MOV BL, AH
    CALL FACT
    MOV n_fact, AX
    ; ----------

    ; --- N! ---
    MOV DL, N
    MOV x_fact, DL ; x = N
    CALL FACT
    MOV r_fact, AX
    ; ----------

    ; --- (M-N)! ---
    MOV DL, M ; DL = M
    SUB DL, N ; DL = M - N
    MOV x_fact, DL ; x = M - N
    CALL FACT
    MOV n_r_fact, AX
    ; ---------------

    ; --- M!/(N! (M-N)!) ---
    MOV AX, n_fact
    SUB DX, DX
    DIV r_fact
    SUB DX, DX
    DIV n_r_fact
    MOV comb, AL
    ; ----------------------

    MOV DL, comb ; DL = comb (answer in binary)
RET
CAL_KHPA ENDP


FACT PROC ; Saves x! IN (DX, AX)

    MOV OUTER_LOOP_COUNT_TEMP, CX

    MOV CX, 01H ; COUNTER = 1
    MOV AX, 01H ; AX = 1 
    MOV DX, 0000H ; CLEAR DX

BACK:
    MOV BH, 00H
    MOV BL, x_fact
    CMP CX, BX
    JA FINISH ; FINISH WHEN COUNTER > x
    MUL CX ; (DX, AX) = CX * AX
    INC CX ; COUNTER++
    INC CX ; COUNTER++
    LOOP BACK ; COUNTER--


FINISH:
    MOV CX, OUTER_LOOP_COUNT_TEMP
    RET
    
FACT ENDP ; THE ANSWER IS STORED IN (DX, AX)


BIN2BCD PROC ; TAKES DL AS PARAMETER
    XOR AH, AH
    MOV AL, DL
    MOV BL, 0AH ; AL / 10
    DIV BL
    MOV BH, AL ; AL = Quotient (Left Digit) | AL / 10
    MOV BL, AH ; AH = Remainder (Right Digit) | AL % 10
RET
BIN2BCD ENDP ; RETURNS A 8-bit BCD IN BX


BCD7SEG PROC ; TAKES DL AS PARAMETER
    CALL BIN2BCD
    MOV DX, BX
RET
BCD7SEG ENDP ; RETURNS DX AS A BCD NO. FOR 7SEG


; DO NOT REMOVE THIS LINE:
    END MAIN