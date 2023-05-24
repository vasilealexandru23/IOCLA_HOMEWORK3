extern printf

section .data
	; declare global vars here
	formatString db "%c", 10, 0

section .text
	global reverse_vowels

;;	void reverse_vowels(char *string)
;	Cauta toate vocalele din string-ul `string` si afiseaza-le
;	in ordine inversa. Consoanele raman nemodificate.
;	Modificare se va face in-place
reverse_vowels:
	push ebp
	push esp
	pop ebp

	push dword [ebp + 8] ; Save in eax the string.
	pop eax
	push ecx ; Save data stored in this register.
	push ebx ; Save data stored in this register.

	push eax ; Copiem in ecx valoarea in eax.
	pop ecx

forloop:
	xor ebx, ebx
	mov bl, [eax]
	cmp bl, 0
	je forloop_change

	cmp bl, 'a'
	je save_vowel
	cmp bl, 'e'
	je save_vowel
	cmp bl, 'i'
	je save_vowel
	cmp bl, 'o'
	je save_vowel
	cmp bl, 'u'
	je save_vowel

	inc eax
	jmp forloop

save_vowel:
	push ebx
	inc eax
	jmp forloop

forloop_change:
	xor ebx, ebx
	mov bl, [ecx]
	cmp bl, 0
	je done

	cmp bl, 'a'
	je change_vowel
	cmp bl, 'e'
	je change_vowel
	cmp bl, 'i'
	je change_vowel
	cmp bl, 'o'
	je change_vowel
	cmp bl, 'u'
	je change_vowel

	inc ecx
	jmp forloop_change

change_vowel:
	pop ebx
	mov [ecx], byte bl
	inc ecx
	jmp forloop_change

done:
	pop ebx ; Restore this register.
	pop ecx ; Restore this register.

	push ebp
	pop esp
	pop ebp
	ret