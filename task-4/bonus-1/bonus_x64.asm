section .text
	global intertwine

;; void intertwine(int *v1, int n1, int *v2, int n2, int *v);
;
;  Take the 2 arrays, v1 and v2 with varying lengths, n1 and n2,
;  and intertwine them
;  The resulting array is stored in v
intertwine:
	push	rbp
	mov 	rbp, rsp

	; RDI v1
	; RSI n1	
	; RDX v2
	; RCX n2
	; R8 v

	mov rbx, rsi				; Get in rbx n1.
	add rbx, rcx 				; Get in rbx the size of the final vector.

	xor r9, r9 					; Iterator in v1.
	xor r10, r10 			 	; Iterator in v2.
	xor r11, r11 				; Iterator over final v

iterate_v1:
	cmp r11, rbx				; Check if the iterator in v reached the end.
	jge done					; If we created the entire v, we break from loop.
	jmp push_v1					; Add element from v1.

push_v1:
	cmp r9, rsi					; Check if the iterator in v1 reached the end.
	jge push_v2					; If the iterator in v1 reached the end, we add from v2.
	mov eax, dword [rdi]		; Get in eax the v1[i].
	mov [r8 + 4 * r11], eax		; Add the element to v.
	inc r9						; Increment iterator in v1 (i++).
	add rdi, 4					; Go to the next element in v1.
	inc r11						; Increment iterator in v.
	jmp push_v2					; Add element from v2.

push_v2:
	cmp r10, rcx				; Check if the iterator in v2 reached the end.
	jge iterate_v1				; Continue the loop.
	mov eax, dword [rdx]		; Get in eax the v2[i].
	mov [r8 + 4 * r11], eax		; Add the element in v.
	inc r10						; Increment iterator in v2.
	add rdx, 4					; Go to the next element in v2.
	inc r11						; Increment iterator in v.
	jmp iterate_v1				; Continue the loop.

done:
	leave						; Exit the function.
	ret
