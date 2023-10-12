.MODEL SMALL
.STACK 64
.DATA
    DATA1 DB ?
.CODE  

MAIN    PROC FAR
		
        MOV AX, @DATA
        MOV DS, AX

Routine1:   MOV AH,01H
            INT 21H

            MOV AH, AL
            AND AH, 0FH
            MOV DATA1, AH
            
        MOV AH, 4CH
        INT 21H
MAIN    ENDP

        END MAIN