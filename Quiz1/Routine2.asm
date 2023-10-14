.MODEL SMALL
.STACK 64
.DATA
    DATA1 DB 04H
    char BYTE ?
.CODE

MAIN    PROC FAR
        MOV AX,@DATA
        MOV DS,AX
        MOV BL, DATA1
        MOV AH, 01H
        INT 21H ; WAITS FOR USER CLICKING
        MOV char, AL
    BACK:
        CMP BL, 00H
        JE FINISH
        ; --- PRINT char ---
        MOV DL, char
        MOV AH, 02H
        INT 21H
        ; ------------------
        DEC BL
        LOOP BACK
    FINISH:
		MOV AH, 4CH
        INT 21H
MAIN    ENDP

END MAIN