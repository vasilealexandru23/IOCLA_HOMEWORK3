extern array_idx_1      ;; int array_idx_1

section .text
	global inorder_parc

section .data
	formatDec db "%d", 10, 0

;   struct node {
;       int value;
;       struct node *left;
;       struct node *right;
;   } __attribute__((packed));

;;  inorder_parc(struct node *node, int *array);
;       functia va parcurge in inordine arborele binar de cautare, salvand
;       valorile nodurilor in vectorul array.
;    @params:
;        node  -> nodul actual din arborele de cautare;
;        array -> adresa vectorului unde se vor salva valorile din noduri;

; ATENTIE: vectorul array este INDEXAT DE LA 0!
;          Cititi SI fisierul README.md din cadrul directorului pentru exemple,
;          explicatii mai detaliate!
; HINT: folositi variabila importata array_idx_1 pentru a retine pozitia
;       urmatorului element ce va fi salvat in vectorul array.
;       Este garantat ca aceasta variabila va fi setata pe 0 la fiecare
;       test.

inorder_parc:
	enter 0, 0
	pusha
	mov ebx, [ebp + 8]              ; node
	mov ecx, [ebp + 12]             ; array

	cmp ebx, 0
	je null_ptr

	pusha
	push ecx
	push dword [ebx + 4]
	call inorder_parc
	add esp, 8
	popa

	pusha
	mov eax, [ebx]
	mov edx, [array_idx_1]
	mov [ecx + 4 * edx], eax
	inc edx
	mov [array_idx_1], edx
	popa

	pusha
	push ecx
	push dword [ebx + 8]
	call inorder_parc
	add esp, 8
	popa
	
null_ptr:
	popa
	leave
	ret
