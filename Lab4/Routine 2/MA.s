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

DATAIN DCD 6
COEFS DCD 1, 5, 10, 10,  5, 1
	AREA KPSTR, DATA, READWRITE

		AREA    MAIN, CODE, READONLY
		ENTRY
		EXPORT Reset_Handler


Reset_Handler
; *** MAIN STARTS HERE ***

; *** REGISTER NAMING ***
N RN R12
INDEX RN R11
KPSTR_ADDR RN R10
COEFS_ADDR RN R9
; ************************

	BL STR_BINOMIAL_EQ

ENDLESS
	B ENDLESS
; ************************

; *** STR_BINOMIAL_EQ ROUTINE ***
STR_BINOMIAL_EQ PROC
	PUSH {LR}
	
	LDR N, =DATAIN
	LDR N, [N]
	SUB N, N, #1

	MOV INDEX, #0

	LDR KPSTR_ADDR, =KPSTR
	LDR COEFS_ADDR, =COEFS
STR_BINOMIAL_EQ_BACK
	LDR R0, [COEFS_ADDR]
	ADD COEFS_ADDR, COEFS_ADDR, #4
	BL BCD_TO_ASCII_AND_STR
	MOV R0, #' '
	BL STR_AND_INDEX

	CMP INDEX, N
	BEQ Y_STR

X_STR
	MOV R0, #'X'
	BL STR_AND_INDEX

	SUB R0, N, INDEX
	CMP R0, #1
	BEQ Y_STR
	
	MOV R0, #'^'
	BL STR_AND_INDEX

	SUB R0, N, INDEX
	BL BCD_TO_ASCII_AND_STR

	CMP INDEX, #0
	BEQ CHECK_END

Y_STR
	MOV R0, #'Y'
	BL STR_AND_INDEX

	CMP INDEX, #1
	BEQ CHECK_END

	MOV R0, #'^'
	BL STR_AND_INDEX

	MOV R0, INDEX
	BL BCD_TO_ASCII_AND_STR

CHECK_END
	ADD INDEX, INDEX, #1
	CMP INDEX, N
	BGT END_STR_BINOMIAL_EQ

PLUS_STR
	MOV R0, #' '
	BL STR_AND_INDEX
	MOV R0, #'+'
	BL STR_AND_INDEX
	MOV R0, #' '
	BL STR_AND_INDEX

	B STR_BINOMIAL_EQ_BACK
	
END_STR_BINOMIAL_EQ
	POP {LR}
	BX LR ; RETURN
	ENDP
; ********************


; *** STR_AND_INDEX ROUTINE ***
STR_AND_INDEX PROC
	STRB R0, [KPSTR_ADDR]
	ADD KPSTR_ADDR, KPSTR_ADDR, #1
	BX LR ; RETURN
	ENDP
; ********************


; *** BCD_TO_ASCII_AND_STR ROUTINE ***
BCD_TO_ASCII_AND_STR PROC
	MOV R2, #0
	PUSH {LR}
BCD_TO_ASCII_BACK
	MOV R1, #10
	BL DIV
	ADD R1, R1, #'0'

	PUSH {R1}
	ADD R2, R2, #1

	CMP R0, #0
	BNE BCD_TO_ASCII_BACK

STR_BACK
	POP {R0}
	STRB R0, [KPSTR_ADDR]
	ADD KPSTR_ADDR, KPSTR_ADDR, #1

	SUBS R2, R2, #1
	BNE STR_BACK

	POP {LR}
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