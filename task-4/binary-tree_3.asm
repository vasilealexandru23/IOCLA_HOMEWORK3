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
    pusha
    mov ebx, [ebp + 8]          ; node
    mov ecx, [ebp + 12]         ; parrent
	cmp ebx, 0
	je null_ptr

	pusha
	push ebx
	push dword [ebx + 4]
	call inorder_fixing
	add esp, 8
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
	jle fix_left
	popa
	jmp continue

fix_left:
    dec edi
    mov [ebx], edi
    popa
    jmp continue

right_child:
	pusha
	mov esi, [ebx]
	mov edi, [ecx]
	cmp edi, esi
	jge fix_right
	popa
	jmp continue	

fix_right:
    inc edi
    mov [ebx], edi
    popa
    jmp continue

continue:
    pusha
	push ebx
	push dword [ebx + 8]
	call inorder_fixing
	add esp, 8
	popa


null_ptr:
    popa
    leave
    ret
