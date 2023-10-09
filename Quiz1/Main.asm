.MODEL SMALL
.STACK 64
.DATA
    DATA1 DB ?
    char DB ?
    lf DB 10
    cr DB 13

.CODE
MAIN    PROC FAR
		
        MOV AX, @DATA
        MOV DS, AX

Routine1:
        MOV AH,01H
        INT 21H ; WAITS FOR USER CLICKING

        MOV AH, AL
        AND AH, 0FH ; ASCII to BCD
        MOV DATA1, AH

Routine2:
        MOV BL, DATA1
        MOV AH, 01H
        INT 21H ; WAITS FOR USER CLICKING
        MOV char, AL

    PRINT_BR:
        MOV DL, lf
        MOV AH, 02H
        INT 21H
        MOV DL, cr
        MOV AH, 02H
        INT 21H ; PRINT NEWLINE

    BACK:
        CMP BL, 00H
        JE FINISH ; IF COUNTER == char JUMP to FINISH
        MOV DL, char
        MOV AH, 02H
        INT 21H
        DEC BL
        LOOP BACK

FINISH:    
        MOV AH, 4CH
        INT 21H

MAIN    ENDP
        END MAIN