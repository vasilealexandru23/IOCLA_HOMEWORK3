/*
 * Don't forget to include "positions.h"
 */

#include "positions.h"

.section .text
.global add_vect

/* 
 * void add_vect(int *v1, int *v2, int n, int *v)
 *
 * add v1 and v2, that have both the length n, and store the result in v3.
 * also, substract from v3 the values provided in positions.S, as described
 * in the task
 */

add_vect:
    pushl   %ebp
    movl    %esp, %ebp
    pushl   %ebx
    pushl   %esi
    pushl   %edi

    movl    8(%ebp), %esi     # v1
    movl    12(%ebp), %edi    # v2
    movl    16(%ebp), %ecx    # n
    movl    20(%ebp), %ebx    # v

    xorl    %eax, %eax        # Initialize accumulator to zero
    jmp addition_loop

; sub_vec:
;     ; subl $1, (%ebx)
;     addl    $4, %esi          # Move v1 pointer to the next element
;     addl    $4, %edi          # Move v2 pointer to the next element
;     addl    $4, %ebx          # Move v pointer to the next element
;     addl    $4, %eax          # Increment the index counter
;     jmp    addition_loop     # Loop until ecx (n) becomes zero

addition_loop:
    movl    (%esi), %edx      # Load v1[i] into %edx
    addl    (%edi), %edx      # Add v2[i] to %edx
    # subl    positions.S(%eax), %edx   # Subtract positions.S[i] from %edx
    movl    %edx, (%ebx)      # Store the result in v[i]

    ; cmp $FIRST_POSITION, %eax
    # jne sub_vec

    addl    $4, %esi          # Move v1 pointer to the next element
    addl    $4, %edi          # Move v2 pointer to the next element
    addl    $4, %ebx          # Move v pointer to the next element
    addl    $4, %eax          # Increment the index counter

    loop    addition_loop     # Loop until ecx (n) becomes zero

    popl    %edi
    popl    %esi
    popl    %ebx

	leave
	ret
