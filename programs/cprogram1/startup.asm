

.section .reset_vector
_reset_vector:
    j _start


# Currently using direct vectoring, so it's not much of a "table"
.section .vector_table
_vector_table:
    j _interrupt_handler


.section .text
.global _start
_start:
    # TODO: Clear .bss section

    # Setup stack pointer
    la sp, _stack_start
    ebreak

    # Jump to main program
    li a0, 0
    li a1, 0
    jal main

    j _exit



_interrupt_handler:
    # ebreak
    #la a0, intmsg
    #jal _write
    jal c_isr
    mret



.section .data
intmsg: .string "Handled interrupt"
