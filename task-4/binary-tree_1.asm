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
	pusha							; Save the data stored in all registers on stack.
	mov ebx, [ebp + 8]              ; Node parameter.
	mov ecx, [ebp + 12]             ; Array parameter.

	cmp ebx, 0						; Check if the current node is null.
	je null_ptr						; If the node is null exit from this function.

	pusha							; Save the data stored in all registers on stack.
	push ecx						; Push array on stack.
	push dword [ebx + 4]			; Push node->left on stack.
	call inorder_parc				; Call recursively the function for the left node.
	add esp, 8						; Clean up the stack.
	popa							; Restore the registers old data.

	pusha							; Save the data stored in all registers on stack.
	mov eax, [ebx]					; Save in eax the current node's value(node->value).
	mov edx, [array_idx_1]			; Get in edx the index in the array.
	mov [ecx + 4 * edx], eax		; Do array[array_idx_1] = node->value.
	inc edx							; Increment the index in our array.
	mov [array_idx_1], edx			; Update the index in our array.
	popa							; Restore the registers old data.

	pusha							; Save the data stored in all registers on stack.
	push ecx						; Push array on stack.
	push dword [ebx + 8]			; Push node->right on stack.
	call inorder_parc				; Call recursively the function for the right node.
	add esp, 8						; Clean up the stack.
	popa							; Restore the registers old data.
	
null_ptr:
	popa							; Restore the registers old data.
	leave							; Exit from function.
	ret
