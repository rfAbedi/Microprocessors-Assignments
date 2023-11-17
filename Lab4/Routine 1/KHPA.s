Stack_Size		EQU		0x00000400

				AREA	STACK, NOINIT, READWRITE, ALIGN=3
Stack_Mem		SPACE	Stack_Size
__initial_sp

				PRESERVE8
				THUMB

; Vector Table Mapped to Address 0 at Reset
				AREA	RESET, DATA, READONLY
				EXPORT	__Vectors

__Vectors		DCD		__initial_sp		; Top of Stack
				DCD		Reset_Handler		; Reset Handler

				ALIGN


DATAIN DCB 9

	AREA MYDATA, DATA, READWRITE
COEFS SPACE 36

                AREA    MAIN, CODE, READONLY
    			ENTRY
    			EXPORT Reset_Handler

Reset_Handler
; *** MAIN STARTS HERE ***

; *** REGISTER NAMING ***
ROW RN R12
COL RN R11
FACT_PAR RN R10
FACT_ANS RN R9
ROW_MINUS_FACT RN R8
COL_MINUS_FACT RN R7
DIFF_FACT RN R6
PASCAL_ANS RN R5
; ************************

	LDR R0, =COEFS ; ADDRESS OF COEFS
	BL KHPA
ENDLESS B ENDLESS ; END OF MAIN
; ************************

; *** KHPA ROUTINE / GETS R0 ***
KHPA PROC
	PUSH {LR}
	PUSH {R0}
	LDR R0, =DATAIN
	LDR ROW, [R0]
	POP {R0}
	MOV COL, #1
NEXT_KHPA
	CMP ROW, COL
	BLT KHPA_END
	PUSH {LR, R1, R0, R2}
	BL PASCAL
	LDR R1, =COEFS
	SUB R0, COL, #1
	MOV R2, #4
	MUL R0, R2
	STR PASCAL_ANS, [R1, R0]
	POP {LR, R1, R0, R2}
	ADD COL, COL, #1
	B NEXT_KHPA
KHPA_END
	POP {LR}
	BX LR ; SAVES DATA IN COEFS 
	ENDP
; ********************

; *** PASCAL ROUTINE ***
PASCAL PROC
	PUSH {LR}
	MOV R0, ROW
	MOV R1, COL
	SUB R0, R0, #1
	SUB R1, R1, #1
	; --- (ROW-1)! ---
	MOV FACT_PAR, R0
	BL FACT
	MOV ROW_MINUS_FACT, FACT_ANS
	; --- (COL-1)! ---
	MOV FACT_PAR, R1
	BL FACT
	MOV COL_MINUS_FACT, FACT_ANS
	; --- (ROW-COL)! ---
	SUB R0, R0, R1
	MOV FACT_PAR, R0
	BL FACT
	MOV DIFF_FACT, FACT_ANS
	; ------------------
	PUSH {R0, R1}
	MOV R0, ROW_MINUS_FACT
	MOV R1, COL_MINUS_FACT
	BL DIV
	MOV R1, DIFF_FACT
	BL DIV
	MOV PASCAL_ANS, R0
	POP {R0, R1}
	POP {LR}
	BX LR ; RETURN PASCAL_ANS
	ENDP
; **********************


; *** FACT ROUTINE ***
FACT PROC
	MOV FACT_ANS, #1
FACT_LOOP
	CMP FACT_PAR, #1
	BLE FACT_END
	MUL FACT_ANS, FACT_PAR
	SUB FACT_PAR, FACT_PAR, #1
	B FACT_LOOP
FACT_END
	BX LR ; RETURN
	ENDP
; ********************

; *** DIV ROUTINE R0/R1***
DIV PROC
	; save R2 and R3 on the stack
	PUSH {R2, R3}
	; check if the divisor is zero
	CMP R1, #0
	; if the divisor is zero
	BCC DIV_END
	; check wether R0 is less than R1
	CMP R0, R1
	; branch if it was
	BGE DIV_OK
	; handle this condition
	MOV R1, R0
	MOV R0, #0
	B DIV_END
DIV_OK
	; initialize the quotient in R2 and the remainder in R3
	MOV R2, #0
	MOV R3, R0
	; loop until the remainder is less than the divisor
LOOP
	; subtract the divisor from the remainder
	SUB R3, R3, R1
	; increment the quotient
	ADD R2, R2, #1
	; compare the remainder and the divisor
	CMP R3, R1
	; if the remainder is greater than or equal to the divisor, repeat the loop
	BGE LOOP
	; store the quotient in R0 and the remainder in R1
	MOV R0, R2
	MOV R1, R3
DIV_END
	; restore R2 and R3 from the stack
	POP {R2, R3}
	; return from the subroutine
	BX LR ; returns R0 as Quotient & R1 as Remainder 
	ENDP
; ********************


; *** THE END ***
  END