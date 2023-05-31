global get_words
global compare_func
global sort
extern printf
extern strtok
extern strcat
extern qsort
extern strcmp
extern strlen

section .data
	delimiters db " ,.", 0 		; delimiters for strtok

section .text

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
sort:
	push ebp
	mov ebp, esp
	pusha

	mov eax, [ebp + 8]			; words
	mov ebx, [ebp + 12]			; number_words
	mov ecx, [ebp + 16]			; size		

    pusha						; Save the data stored in all registers on stack.
	push cmp_func				; Push the compare function for qsort on stack.
	push ecx					; Push the size on stack.
	push ebx					; Push the number of words on stack.
	push eax					; Push the vector to be sorted on stack.
	call qsort					; Call qsort.
	add esp, 16					; Clean up the stack.
	popa						; Restore in registers the old data.

	popa						; Restore in registers the old data.
	leave						; Exit from function.
	ret

cmp_func:
	enter 0, 0	

	push ebx					; Save all registers except eax.
	push ecx
	push edx
	push esi
	push edi

    mov ebx, [ebp + 8]			; Get pointer first string.
	mov ebx, dword [ebx]		; Get the first string.
    mov esi, [ebp + 12]       	; Get pointer to second string.
	mov esi, dword [esi]		; Get the second string.

	push ebx					; Push first string on stack.
	call strlen					; Get the size of the first string.
	add esp, 4					; Clean up the stack.

	mov ebx, [ebp + 8]			; Restore the strings.
	mov ebx, dword [ebx]
	mov esi, [ebp + 12]
	mov esi, dword [esi]

	mov edx, eax				; Get in edx the strlen of first string.
	push edx					; Save strlen(string1) on stack.

	push esi					; Push second string on stack.
	call strlen					; Get the size of the second string.
	add esp, 4					; Clean up the stack.

	pop edx						; Restore strlen(string1) in edx.

	cmp edx, eax				; Compare the sizes of the strings.
	jg done_compare
	je continue_comparing		; Compare with second criteria.

	xor eax, eax				; Cleare this register to return 0.

	pop edi						; Restore the old data in this registers.
	pop esi
	pop edx
	pop ecx
	pop ebx
  
	leave						; Exit from the compare function.
    ret

done_compare:
	xor eax, eax				; Clear the restore register.
	inc eax						; Increase eax to return 1.

	pop edi						; Restore the old data in this registers.
	pop esi
	pop edx
	pop ecx
	pop ebx
  
	leave						; Exit from the compare function.
    ret

continue_comparing:
    push esi					; Push second string on stack.
    push ebx					; Push first string on stack.
    call strcmp					; Compare them lexicographically.
    add esp, 8					; Clean up the stack.

	pop edi						; Restore the old data in this registers.
	pop esi
	pop edx
	pop ecx
	pop ebx
  
	leave						; Exit from the compare function.
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
	enter 0, 0
	pusha						; Save data from this registers on stack.

	mov eax, [ebp + 8]			; text
	mov ebx, [ebp + 12]			; words
	mov ecx, [ebp + 16]			; number_of_words

	push eax					; Save the data stored in all registers on stack.
	push ecx
	push edx
	push esi
	push edi
	push ebx

	push delimiters				; Push delimiters on stack.
	push eax					; Push text on stack.
	call strtok					; Call strtok with our parameters.
	add esp, 8					; Clean up the stack.

	pop ebx						; Restore ebx (words array).
	mov dword [ebx], eax		; Put the first word in our words array.

	pop edi						; Restore registers.
	pop esi
	pop edx
	pop ecx
	pop eax

	add ebx, 4					; Get to the next element.
	dec ecx						; Decrement the number of words.
continue_strtok:
	cmp ecx, 0					; Check if we built all the words.
	je done						; If we have no words, we break the loop.

	push eax					; Save the data stored in all registers on stack.
	push ecx
	push edx
	push esi
	push edi
	push ebx

	push delimiters				; Push delimiters on stack.
	push 0						; Push "NULL" on stack.
	call strtok					; Call strtok with our parameters.
	add esp, 8					; Clean up the stack.

	pop ebx						; Restore ebx (words array).
	mov dword [ebx], eax		; Put the word returned by strtok in our words array.

	pop edi						; Restore registers.
	pop esi
	pop edx
	pop ecx
	pop eax

	add ebx, 4					; Get to the next element.
	dec ecx						; Decrement the number of words.
	jmp continue_strtok			; Continue the loop.

done:
	popa						; Restore in registers the old data.
	leave						; Exit from function.
	ret
