section .text
    global inorder_fixing

;   struct node {
;       int value;
;       struct node *left;
;       struct node *right;
;   } __attribute__((packed));

;;  inorder_fixing(struct node *node, struct node *parent)
;       functia va parcurge in inordine arborele binar de cautare, modificand
;       valorile nodurilor care nu respecta proprietatea de arbore binar
;       de cautare: |node->value > node->left->value, daca node->left exista
;                   |node->value < node->right->value, daca node->right exista.
;
;       Unde este nevoie de modificari se va aplica algoritmul:
;           - daca nodul actual este fiul stang, va primi valoare tatalui - 1,
;                altfel spus: node->value = parent->value - 1;
;           - daca nodul actual este fiul drept, va primi valoare tatalui + 1,
;                altfel spus: node->value = parent->value + 1;

;    @params:
;        node   -> nodul actual din arborele de cautare;
;        parent -> tatal/parintele nodului actual din arborele de cautare;

; ATENTIE: DOAR in frunze pot aparea valori gresite! 
;          Cititi SI fisierul README.md din cadrul directorului pentru exemple,
;          explicatii mai detaliate!

inorder_fixing:
    enter 0, 0
    pusha							; Save the data stored in all registers on stack.
    mov ebx, [ebp + 8]          	; Node parameter.
    mov ecx, [ebp + 12]         	; Parent parameter.
	cmp ebx, 0						; Check the current node is null.
	je exit_function				; If the node is null exit from this function.

	pusha							; Save the data stored in all registers on stack.
	push ebx						; Push node on stack(as parent for node->left).
	push dword [ebx + 4]			; Push node->left on stack.
	call inorder_fixing				; Call recursively the function for the left node.
	add esp, 8						; Clean up the stack.
	popa							; Restore the data in all registers.

    cmp ecx, 0						; Check if the current node is root.
	je continue						; If that's the case, we continue dfs with node-right.
	cmp ebx, [ecx + 4]				; Check if the current node is parent->left.
	je left_child					; If current_node == parent->left,
									; check the bst property for the left part.

	jmp right_child					; Else, current_node == parent->right,
									; check the bst property for the right part.

left_child:
	pusha							; Save data stored in all registers on stack.
	mov esi, [ebx]					; Get node->value.
	mov edi, [ecx]					; Get parent->value.
	cmp esi, edi					; Check node->value < parent->value (bst property).
	jge fix_left					; If node->value >= parent->value, fix the left intruder.
	popa							; Restore the data stored in all registers on stack.
	jmp continue					; Continue dfs with node->right.

fix_left:
    mov [ebx], edi					; Make node->value = parent->value.
	dec dword [ebx]					; Make node->value = parent->value - 1.
	popa							; Restore the data stored in all registers on stack.
	jmp continue					; Continue dfs with node->right.

right_child:
	pusha							; Save the data stored in all registers on stack.
	mov esi, [ebx]					; Get node->value.
	mov edi, [ecx]					; Get parent->value.
	cmp esi, edi					; Check node->value > parent->value (bst property).
	jle fix_right					; If node->value <= parent->value, fix the right intruder. 
	popa							; Restore the data stored in all registers on stack.
	jmp continue					; Continue dfs with node->right.

fix_right:
    mov [ebx], edi					; Make node->value = parent->value.
	inc dword [ebx]					; Make node->value = parent->value + 1.
	popa							; Restore the data stored in all registers on stack.
	jmp continue					; Continue dfs with node->right.

continue:
	pusha							; Save the data stored in all registers on stack.
	push ebx						; Push node on stack (as parent for node->right).
	push dword [ebx + 8]			; Push node->right on stack.
	call inorder_fixing				; Call recursively the function for the right node.
	add esp, 8						; Clean up the stack.
	popa							; Restore in registers the old data.

exit_function:
	popa							; Restore in registers the old data.
	leave							; Exit from function.
    ret
