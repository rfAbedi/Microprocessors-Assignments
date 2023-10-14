.MODEL SMALL
.STACK 64
.DATA
    n DB ?
    lf DB 10
    cr DB 13
    RESULT DW 3 DUP(?)
.CODE

MAIN    PROC FAR

    ; --- Data Segmant Define ---
    MOV AX, @DATA
    MOV DS, AX
    ; ---------------------------

get_n:
    ; --- GETS CHR FROM USER ---
    MOV AH,01H
    INT 21H 
    ; --------------------------

    ; --- ASCII to BCD ---
    MOV AH, AL
    AND AH, 0FH
    ; --------------------
    MOV n, AH ; SAVE TO n

    CALL PRINT_BR

    CALL FACT

    ; ; --- PRINT n ---
    ; MOV DL, AL
    ; MOV AH, 02H
    ; INT 21H
    ; ; ---------------



    ; --- TERMINATE ---
    MOV AH, 4CH
    INT 21H
    ; -----------------

MAIN    ENDP


PRINT_BR PROC ; PRINTS NEWLINE

    MOV DL, lf
    MOV AH, 02H
    INT 21H
    MOV DL, cr
    MOV AH, 02H
    INT 21H
    RET

PRINT_BR ENDP


FACT PROC ; CALCULATE FACTORIAL OF n AND STORE IT IN (DX, AX)

    ; --- COUNTER = 1 ---
    MOV BL, 01H
    ; -------------------

    ; --- AX = 1 ---
    MOV AX, 01H
    ; --------------

    BACK:
    ; --- FINISH IF COUNTER == n ---
    CMP BL, n
    JA FINISH
    ; ------------------------------
    MUL BL ; (DX, AX) = BL * AX
    INC BL ; BL++
    LOOP BACK ;

    FINISH:
    RET
    ; THE ANSWER IS STORED IN (DX, AX)
    
FACT ENDP

END MAIN