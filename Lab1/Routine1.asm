.MODEL SMALL
.STACK 64
.DATA
    TEN DW 000AH
    n DB ?
    r DB 01H
    x_fact DB ? ; IS USED TO CALCULATE factorial of x
    lf DB 10
    cr DB 13
    n_fact DW ?
    r_fact DW ?
    n_r_fact DW ?
    comb DB ? ; ANSWER OF Combination
    OUTER_LOOP_COUNT_TEMP DW ?
    STACK_COUNT DB 00H
    STROUT DB 50 DUP(0)
.CODE

MAIN    PROC FAR

    ; --- Data Segmant Define ---
    MOV AX, @DATA
    MOV DS, AX
    MOV DI, OFFSET STROUT
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
    DEC AH
    MOV n, AH ; SAVE TO n

    CALL PRINT_BR


calculation:
    MOV CX, 0000H; COUNTER = 0
L1:
    ; MOV BL, n
    ; CMP CL, BL
    CMP CL, n
    JA L1_END ; FINISH WHEN COUNTER > n

        MOV r, CL ; r = COUNTER

        ; --- n! ---
        MOV AH, n
        MOV x_fact, AH ; x = n
        MOV BL, AH
        CALL FACT
        SHL DX, 16 ; SHIFT LEFT 16 BITS
        OR DX, AX ; CONCAT DX AND AX
        MOV n_fact, DX
        ; ----------

        ; --- r! ---
        MOV DL, r
        MOV x_fact, DL ; x = r
        CALL FACT
        SHL DX, 16 ; SHIFT LEFT 16 BITS
        OR DX, AX ; CONCAT DX AND AX
        MOV r_fact, DX
        ; ----------

        ; --- (n-r)! ---
        MOV DL, n ; DL = n
        SUB DL, r ; DL = n - r
        MOV x_fact, DL ; x = n - r
        CALL FACT
        SHL DX, 16 ; SHIFT LEFT 16 BITS
        OR DX, AX ; CONCAT DX AND AX
        MOV n_r_fact, DX
        ; ---------------

        ; --- n!/(r! (n-r)!) ---
        MOV AX, n_fact
        SUB DX, DX
        DIV r_fact
        SUB DX, DX
        DIV n_r_fact
        MOV comb, AL
        ; ----------------------


    SUB AX, AX ; Clear AX
    MOV AL, comb ; AX = comb

convert_to_ascii:
        SUB DX, DX ; Clear DX for division
        DIV TEN ; Divide AX by 10
        ADD DL, '0' ; Convert the remainder to ASCII

        ; ************ PUSH NUMBERS TO PRINT IT (REVERSE OF REVERSE = ITSELF) ************
        PUSH DX
        INC STACK_COUNT
        ; *********************************************************************************

        CMP AX, 0000H ; CHECKING IF AX IS ZERO
        JNE convert_to_ascii ; JUMP IF AS IS ZERO



save_ascii:
    ; ************ POP NUMBERS TO PRINT IT (REVERSE OF REVERSE = ITSELF) ************
    CMP STACK_COUNT, 00H
    JE save_end
    POP DX
    DEC STACK_COUNT
    ; ********************************************************************************


    ; **************************** SAVE OUTPUT comb NUMBERS AS ASCII ****************************
    MOV [DI], DL
    INC DI
    ; *******************************************************************************************

    ; --- PRINT char ---
    MOV BX, AX
    MOV AH, 02H
    INT 21H
    MOV AX, BX
    ; ------------------
    
    JMP save_ascii

save_end:

    ; --- SAVE AND PRINT SPACE ---
    MOV [DI], ' ' ; SAVE THE SPACE BETWEEN NUMBERS
    INC DI
    MOV DL, 20H ; load ASCII code of space into DL
    MOV AH, 02H ; select service 02H (print character)
    INT 21H ; call DOS interrupt
    ; ----------------------------

    INC CX ; COUNTER++
    INC CX ; COUNTER++
    LOOP L1 ; COUNTER--

L1_END:


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
    ; THE ANSWER IS STORED IN (DX, AX)
    
FACT ENDP

END MAIN