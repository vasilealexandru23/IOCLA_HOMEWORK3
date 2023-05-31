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
	pusha						; Save all registers data.
	fld dword [ebp + 8]    		; Load x into FPU stack.
	fmul dword [sqrt_2]    		; Multiply x by sqrt(2).

	fld dword [ebp + 16]   		; Load z into FPU stack.
	fldpi				   		; Load pi into FPU stack.
	fmul				   		; Multiply z by pi.

	; fldlg2
	; f2xm1

	fmul dword [inverse_e]		; Multiply (z * pi) by 1/e.

	fsin                        ; Compute sine of (z * PI * 1/e).
	fmul dword [ebp + 12]       ; Multiply by y

	faddp st1, st0				; Add the results.

	popa						; Restore data into registers.
	leave						; Exit function.
	ret