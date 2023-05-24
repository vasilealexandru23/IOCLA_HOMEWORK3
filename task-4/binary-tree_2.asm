extern array_idx_2      ;; int array_idx_2

section .text
	global inorder_intruders

;   struct node {
;       int value;
;       struct node *left;
;       struct node *right;
;   } __attribute__((packed));

;;  inorder_intruders(struct node *node, struct node *parent, int *array)
;       functia va parcurge in inordine arborele binar de cautare, salvand
;       valorile nodurilor care nu respecta proprietatea de arbore binar
;       de cautare: |node->value > node->left->value, daca node->left exista
;                   |node->value < node->right->value, daca node->right exista
;
;    @params:
;        node   -> nodul actual din arborele de cautare;
;        parent -> tatal/parintele nodului actual din arborele de cautare;
;        array  -> adresa vectorului unde se vor salva valorile din noduri;

; ATENTIE: DOAR in frunze pot aparea valori gresite!
;          vectorul array este INDEXAT DE LA 0!
;          Cititi SI fisierul README.md din cadrul directorului pentru exemple,
;          explicatii mai detaliate!

; HINT: folositi variabila importata array_idx_2 pentru a retine pozitia
;       urmatorului element ce va fi salvat in vectorul array.
;       Este garantat ca aceasta variabila va fi setata pe 0 la fiecare
;       test al functiei inorder_intruders.      

inorder_intruders:
	enter 0, 0
	pusha
	mov ebx, [ebp + 8]              ; node
	mov ecx, [ebp + 12]				; parrent
	mov edx, [ebp + 16]             ; array

	cmp ebx, 0
	je null_ptr

	pusha
	push edx
	push ebx
	push dword [ebx + 4]
	call inorder_intruders
	add esp, 12
	popa

	cmp ecx, 0	
	je continue
	cmp ebx, [ecx + 4]
	je left_child
	jmp right_child

left_child:
	pusha
	mov esi, [ebx]
	mov edi, [ecx]
	cmp edi, esi
	jle add_intruders
	popa
	jmp continue

right_child:
	pusha
	mov esi, [ebx]
	mov edi, [ecx]
	cmp edi, esi
	jge add_intruders
	popa
	jmp continue	

add_intruders:
	mov ecx, [array_idx_2]
	mov [edx + 4 * ecx], esi
	inc ecx
	mov [array_idx_2], ecx
	popa

continue:
	pusha
	push edx
	push ebx
	push dword [ebx + 8]
	call inorder_intruders
	add esp, 12
	popa

null_ptr:
	popa
	leave
	ret
