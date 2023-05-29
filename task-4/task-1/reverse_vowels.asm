extern printf
extern strchr

section .data
	vowels db "aeiou", 0

section .text
	global reverse_vowels

;;	void reverse_vowels(char *string)
;	Cauta toate vocalele din string-ul `string` si afiseaza-le
;	in ordine inversa. Consoanele raman nemodificate.
;	Modificare se va face in-place
reverse_vowels:
	push ebp						; Simulate enter 0,0.
	push esp
	pop ebp
	pusha

	push dword [ebp + 8] 			; Save in eax the string.
	pop eax

	push eax 						; Push eax on stack.
	pop ecx							; Make a copy of eax and store in ecx.
	jmp iterate_chars				; Iterate over all chars.

iterate_chars:
	xor ebx, ebx					; Clear this register.
	push dword [eax]				; Push the current char on stack.
	pop ebx							; Get in ebx the current char.
	xor bh, bh						; Make zero the useless part.

	cmp bl, 0						; Check if the current char is '\0'.
	je update_string				; If we iterated over all chars, we can change the string.

	pusha							; Push all data from registers on stack.
	push ebx						; Push our char on stack.
	push vowels						; Push our vowels on stack.
	call strchr						; Call strchr to check our char.
	add esp, 8						; Clean up the stack.
	cmp eax, 0						; Check if the current char is vowel.
	jne save_vowel					; If our char is a vowel, we save it.
	popa							; Restore the data into registers.

	inc eax							; Go to the next element in our string.
	jmp iterate_chars				; Continue the loop until we reach the end.

save_vowel:
	popa							; Restore the data into registers.
	push ebx						; Push our vowel on stack.
	inc eax							; Go to the next element in our string.
	jmp iterate_chars				; Continue the loop until we reach the end.

update_string:
	xor ebx, ebx					; Clear this register.
	push dword [ecx]				; Push on stack the current char.
	pop ebx							; Get in ebx the current char.
	xor bh, bh						; Clear the useless part.
	cmp bl, 0						; Check if we reached the end of the string.
	je done							; If we have iterated over all chars, we break the loop.

	pusha							; Push all data from registers on stack.
	push ebx						; Push our char on stack.
	push vowels						; Push our vowels on stack.
	call strchr						; Call strchr to check our char.
	add esp, 8						; Clean up the stack.
	cmp eax, 0						; Check if the current char is vowel.
	jne change_vowel				; If our char is a vowel, we save it.
	popa							; Restore the data into registers.

	inc ecx							; Go to the next element in our string.
	jmp update_string				; Continue the loop until we reached the end.

change_vowel:
	popa							; Restore the data into registers.
	pop ebx							; Get in ebx the vowel saved on stack.

	push eax						; Save the data from this register on stack.
	push dword [ecx]				; Push the current char on stack.
	pop eax							; Get in eax the current char.

	sub ebx, eax					; Simulate swap between the vowels.
	add [ecx], bl

	pop eax							; Restore data in this register.

	inc ecx							; Go to the next element in our string.
	jmp update_string				; Continue the loop until we reached the end.

done:
	popa							; Restore the data into registers.
	push ebp						; Simulate leave.
	pop esp
	pop ebp
	ret