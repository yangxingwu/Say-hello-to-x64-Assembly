# %rax - system call number
# %rbx - program exit status code
# %rbp - base pointer register
# %rsp - stack pointer register
# %rip - instruction pointer

.section .data

.section .text
.global _start
_start:
    pushq $7 # push param to stack
    call factorial
    addq $8, %rsp # rewind stack pointer

    movq $1, %rax
    int $0x80

.type factorail, @function
factorial:
    # initial stack
    # -------------
    # | param
    # | return address
    # --------------

    pushq %rbp
    movq %rsp, %rbp

    # stack after pushing old base pointer
    # -------------
    # | param
    # | return address
    # | old base pointer
    # --------------

    # %rax - param
    # %rbx - temp result
    movq 16(%rbp), %rax
    movq $1, %rbx

    loop:
        cmpq $1, %rax
        je exit_loop
        imulq %rax, %rbx
        decq %rax
        jmp loop

    exit_loop:
        popq %rbp
        ret
