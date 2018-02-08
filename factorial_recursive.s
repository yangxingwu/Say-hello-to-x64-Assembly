.section .data

.section .text
.global _start
_start:
    pushq $4
    call factorial
    addq $8, $rsp

    movq %rax, %rbx
    int $0x80

    factorial:
        pushq
        movq %rsp, %rbp
