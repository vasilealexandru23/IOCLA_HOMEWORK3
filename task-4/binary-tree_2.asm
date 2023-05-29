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
	pusha							; Save the data stored in all registers on stack.
	mov ebx, [ebp + 8]              ; Node parameter.
	mov ecx, [ebp + 12]				; Parent parameter.
	mov edx, [ebp + 16]             ; Array parameter.

	cmp ebx, 0						; Check if the current node is null.
	je exit_function				; If the node is null exit from this function.

	pusha							; Save the data stored in all registers on stack.
	push edx						; Push array on stack.
	push ebx						; Push node on stack (as parent of node->left).
	push dword [ebx + 4]			; Push node->left on stack.
	call inorder_intruders			; Call recursively the function for the left node.
	add esp, 12						; Clean up the stack.
	popa							; Restore data in all registers.

	cmp ecx, 0						; Check if the current node is root.
	je continue						; If that's the case, we continue dfs with node->right.
	cmp ebx, [ecx + 4]				; Check if the current node is parent->left.
	je left_child					; If current_node == parent->left, we
									; check the bst property for the left part.

	jmp right_child					; Else, current_node = parrent->right, we
									; check the bst property for the right part.

left_child:
	pusha							; Save data stored in all registers on stack.
	mov esi, [ebx]					; Get node->value.
	mov edi, [ecx]					; Get parent->value.
	cmp esi, edi					; Check node->value < parent->value (bst property).
	jge add_intruders				; If node->value >= parent->value, add intruder in array.
	popa							; Restore the data stored in all registers on stack.
	jmp continue					; Continue dfs with node->right.

right_child:
	pusha							; Save the data stored in all registers on stack.
	mov esi, [ebx]					; Get node->value.
	mov edi, [ecx]					; Get parent->value.
	cmp esi, edi					; Check node->value > parent->value (bst property).
	jle add_intruders				; If node->value <= parent->value, add intruder in array.
	popa							; Restore the data stored in all registers on stack.
	jmp continue					; Continue dfs with node->right.

add_intruders:
	mov ecx, [array_idx_2]			; Get the current index in array.
	mov [edx + 4 * ecx], esi		; Do array[array_idx_2] = node->value.
	inc dword [array_idx_2]			; Increase the index array (array_idx_2++).
	popa							; Restore the data in registers.

continue:
	pusha							; Save the data stored in all registers on stack.
	push edx						; Push array on stack.
	push ebx						; Push node on stack (as parent for node->right).
	push dword [ebx + 8]			; Push node->right on stack.
	call inorder_intruders			; Call recursively the function for the right node.
	add esp, 12						; Clean up the stack.
	popa							; Restore in registers the old data.

exit_function:
	popa							; Restore in registers the old data.
	leave							; Exit from function.
	ret
