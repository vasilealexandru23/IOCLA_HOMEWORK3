extern strcmp
extern strcat

section .data
	back db "..", 0
	curr db ".", 0
	slash db "/", 0

section .text
	global pwd

;;	void pwd(char **directories, int n, char *output)
;	Adauga in parametrul output path-ul rezultat din
;	parcurgerea celor n foldere din directories
pwd:
    enter 0,0
    pusha

	mov eax, [ebp + 8]			; directories
	mov ecx, [ebp + 12]			; n
	mov edx, [ebp + 16]			; output	

	xor edi, edi				; Index in the for loop.
	xor esi, esi 				; Keep track of items on stack.
	jmp iterate_words			; Start iteration over words.

pusha_without_edx:
	push eax
	push ebx
	push ecx
	push edi
	push esi
	ret

iterate_words:
	cmp edi, ecx				; Check if we reached the end.
	je done						; If we iterated over all words, we can build the path.
	mov ebx, [eax + 4 * edi]	; Get the word for the current index.

	pusha						; Save all registers on stack.
	push ebx					; Push on stack the current string.
	push curr					; Push on stack the string ".".
	call strcmp	
	add esp, 8					; Restore the stack.
	cmp eax, 0					; Check if the curent string is ".".
	je restore_and_continue		; Go to the next word.
	popa						; Restore the registers.

	pusha						; Save again, the registers for the next comparation.
	push ebx					; Push on stack the current string.
	push back					; Push on stack the string "..".
	call strcmp
	add esp, 8					; Restore the stack.
	cmp eax, 0					; Check if the current string is "..".
	je pop_back					; Remove from stack the last folder in the path.
	popa						; Restore the registers.

	inc esi						; Increase the number of folders in the path.
	push ebx					; Add current folder in the path (in stack).
	jmp continue_iteration		; Continue iteration over words.

pop_back:
	popa						; Restore the registers.
	cmp esi, 0					; Check if we have folders in the path.
	je continue_iteration

	dec esi						; Decrease the number of folders in the pack.
	add esp, 4					; Pop last folder from the path.

	inc edi						; Increase the index in the vector of words.
	jmp iterate_words			; Continue the loop.

continue_iteration:
	inc edi						; Increase the index in the vector.
	jmp iterate_words			; Continue the loop.

restore_and_continue:
	popa						; Restore the registers.
	jmp continue_iteration		; Continue the loop.

done:
	mov ecx, esi ; make a copy

build_path:
	cmp esi, 0
	je add_backslash

	mov ebx, [esp + 4 * esi - 4]

	; push edi
	; call pusha_without_edx	
	push eax
	push ebx
	push ecx
	push edi
	push esi
	; pop edi

	push slash
	push edx
	call strcat
	add esp, 8
	mov edx, eax

	push ebx
	push edx
	call strcat
	add esp, 8
	mov edx, eax

	pop esi
	pop edi
	pop ecx
	pop ebx
	pop eax
	
	dec esi
	jmp build_path

add_backslash:
	push eax
	push ebx
	push ecx
	push edi
	push esi

	push slash
	push edx
	call strcat
	add esp, 8
	mov edx, eax

	pop esi
	pop edi
	pop ecx
	pop ebx
	pop eax

	imul ecx, 4
	add esp, ecx
	popa

	leave
	ret