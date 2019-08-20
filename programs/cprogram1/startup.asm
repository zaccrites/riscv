


.section .vector_table
_reset:
    j _start


.section .text
.global _start
_start:
    # TODO: Clear .bss section

    # Setup stack pointer
    la sp, _stack_start

    # Jump to main program
    li a0, 0
    li a1, 0
    jal main

    # Exit simulator
    li a0, 2
    ecall
    j .
    nop
    nop
    nop
