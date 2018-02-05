.section .data

.section .text
.global _start
_start:
    pushq $2
    pushq $3
    call power
    addq $16, %rsp

    # save the first answer
    pushq %rax

    pushq $5
    pushq $2
    call power
    addq $16, %rsp

    popq %rbx
    addq %rax, %rbx
    movq $1, %rax
    int $0x80

# when we call a function, we usually push the params into
# the stack and store the old %ebp in stack
#
# ----------------------
# | param N
# | ...
# | param 2
# | param 1
# | return address
# | old base pointer %ebp
# --------------------------

.type power, @function
power:
    # push old base pointer to stack
    pushq %rbp
    # make the base pointer point to the top of stack frame
    movq %rsp, %rbp
    # reserve a local storage
    subq $8, %rsp

    # get the first param
    movq 16(%rbp), %rbx
    # get the second param
    movq 24(%rbp), %rcx

    # store the temp result
    movq %rbx, -8(%rbp)

    power_loop:
        cmpq $1, %rcx
        je end_power_loop
        movq -8(%rbp), %rax
        imulq %rbx, %rax
        movq %rax, -8(%rbp)
        decq %rcx
        jmp power_loop

    end_power_loop:
        # store the result
        movq -8(%rbp), %rax
        #  restore stack pointer
        movq %rbp, %rsp
        # restore base pointer
        popq %rbp
        ret
