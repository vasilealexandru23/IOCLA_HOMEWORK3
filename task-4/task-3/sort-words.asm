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
	delimiters db " ,.", 0 	; delimiters for strtok

section .text

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
sort:
	push ebp
	mov ebp, esp
	pusha

	mov eax, [ebp + 8]		; words
	mov ebx, [ebp + 12]		; number_words
	mov ecx, [ebp + 16]		; size		

	push ebx
	push ecx
	push edx
	push esi
	push edi

	push cmp_func
	push ecx
	push ebx
	push eax
	call qsort
	add esp, 16

	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx

	popa
	leave
	ret

cmp_func:
	push ebp
    mov ebp, esp

	push ebx
	push ecx
	push edx
	push esi
	push edi

    mov ebx, [ebp + 8]      ; pointer to first string
	mov ebx, dword [ebx]
    mov esi, [ebp + 12]       ; pointer to second string
	mov esi, dword [esi]

	push ebx
	call strlen
	add esp, 4

	mov ebx, [ebp + 8]
	mov ebx, dword [ebx]
	mov esi, [ebp + 12]
	mov esi, dword [esi]

	mov edx, eax
	push edx

	push esi
	call strlen
	add esp, 4

	pop edx

	cmp edx, eax
	jg done_compare
	je continue_comparing

	xor eax, eax

	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
  
    mov esp, ebp
    pop ebp
    ret

done_compare:
	xor eax, eax
	inc eax

	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
  
    mov esp, ebp
    pop ebp
    ret

    ; Compare the strings using strcmp
continue_comparing:
    push esi
    push ebx
    call strcmp
    add esp, 8

	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
  
    mov esp, ebp
    pop ebp
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
	push ebp
	mov ebp, esp
	pusha

	mov eax, [ebp + 8]		; text
	mov ebx, [ebp + 12]		; words
	mov ecx, [ebp + 16]		; number_of_words
	xor edx, edx

	push eax
	push ecx
	push edx
	push esi
	push edi
	push ebx

	push delimiters
	push eax
	call strtok
	add esp, 8

	pop ebx
	mov dword [ebx], eax

	pop edi
	pop esi
	pop edx
	pop ecx
	pop eax

	add ebx, 4
	dec ecx
continue_strtok:
	inc edx
	cmp ecx, 0
	je done

 	push eax
	push ecx
	push edx
	push esi
	push edi
	push ebx

	push delimiters
	push 0
	call strtok
	add esp, 8

	pop ebx
	mov dword [ebx], eax

	pop edi
	pop esi
	pop edx
	pop ecx
	pop eax

	dec ecx
	add ebx, 4
	jmp continue_strtok

done:
	imul edx, 4
	sub ebx, edx

	popa
	leave
	ret
