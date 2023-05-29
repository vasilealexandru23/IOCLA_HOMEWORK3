extern sqrt
extern sin

section .text
	global do_math

section .data
	inverse_e 	dd 0.36787944
	sqrt_2 		dd 1.41421356

;; float do_math(float x, float y, float z)
;  returns x * sqrt(2) + y * sin(z * PI * 1/e)
do_math:
	enter 0, 0
	pusha
	fninit
	; cALCULATE X * SQRT(2)
	fld dword [ebp + 8]    ; Load x into FPU stack
	fmul dword [sqrt_2]    ; Multiply by sqrt(2)

	; Calculate y * sin(z * PI * 1/e)
	fld dword [ebp + 16]           ; Load z into FPU stack
	fldpi
	fmul

	fldlg2
	f2xm1

	; fmul dword [inverse_e]          ; Multiply by 1/e

	fsin                           ; Compute sine
	fmul dword [ebp + 12]           ; Multiply by y

	; ; Add the two results
	faddp st1, st0

	popa
	leave
	ret