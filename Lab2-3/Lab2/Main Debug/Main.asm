.MODEL SMALL
.STACK 64
.DATA
    ROM DW 1100000000000000B
    RAM DW 1100010000000000B
    KPMN DB ?

    M DB ?
    N DB ?

    r DB 01H
    x_fact DB ? ; IS USED TO CALCULATE factorial of x
    n_fact DW ?
    r_fact DW ?
    n_r_fact DW ?
    comb DB ? ; ANSWER OF Combination
    OUTER_LOOP_COUNT_TEMP DW ?
.CODE  

MAIN    PROC FAR

    MOV AX, @DATA
	MOV DS, AX

    CALL KPEXT

ENDLESS:
	JMP ENDLESS
MAIN    ENDP



KPEXT    PROC
READ_ROM:

	MOV AX, ROM
	MOV ES, AX
        
	MOV SI, 00H
	MOV CL, ES:[SI] ; READ M
    MOV CH, ES:[SI+1] ; READ N

SAVE_DATA:

    DEC CL
    MOV M, CL
    DEC CH
    MOV N, CH

calculation:
    MOV AX, RAM
    MOV ES, AX

    MOV CX, 0000H; COUNTER = 0
L1:

    CMP CL, M
    JA L1_END ; FINISH WHEN COUNTER > M

        MOV r, CL ; r = COUNTER

        ; --- M! ---
        MOV AH, M
        MOV x_fact, AH ; x = M
        MOV BL, AH
        CALL FACT
        MOV n_fact, AX
        ; ----------

        ; --- r! ---
        MOV DL, r
        MOV x_fact, DL ; x = r
        CALL FACT
        MOV r_fact, AX
        ; ----------

        ; --- (M-r)! ---
        MOV DL, M ; DL = M
        SUB DL, r ; DL = M - r
        MOV x_fact, DL ; x = M - r
        CALL FACT
        MOV n_r_fact, AX
        ; ---------------

        ; --- M!/(r! (M-r)!) ---
        MOV AX, n_fact
        SUB DX, DX
        DIV r_fact
        SUB DX, DX
        DIV n_r_fact
        MOV comb, AL
        ; ----------------------


    SUB BX, BX ; Clear AX
    MOV BL, comb ; AX = comb


WRITE_RAM:
    MOV DI, CX
    MOV ES:[DI], BL ; WRITE COMBINATION IN RAM

    INC CX ; COUNTER++
    INC CX ; COUNTER++
    LOOP L1 ; COUNTER--

L1_END:
    SUB BX, BX
    MOV BL, N
    MOV DI, BX ; DI = N

    MOV BL, ES:[DI] ; READ Nth COMBINATION

    MOV KPMN, BL ; KPMN = M

RET

KPEXT    ENDP
ِ

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