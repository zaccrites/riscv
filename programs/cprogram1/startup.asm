

#.section .reset_vector
#_reset_vector:
#    j _start
#
#
## Currently using direct vectoring, so it's not much of a "table"
#.section .vector_table
#_vector_table:
#    j _interrupt_handler


.section .text
.global _start
_start:
    # TODO: Clear .bss section

    li s0, 0
    li s1, 1
    li s2, 2
    li s3, 3
    li s4, 4

    add s5, s0, s1
    add s5, s5, s2
    add s5, s5, s3
    add s5, s5, s4


    ecall





    # Setup stack pointer
    # la sp, _stack_start
    # ebreak
#
    # # Jump to main program
    # li a0, 0
    # li a1, 0
    # jal main
#
    # j _exit



#_interrupt_handler:
#    # ebreak
#    #la a0, intmsg
#    #jal _write
#    jal c_isr
#    mret



#.section .data
#intmsg: .string "Handled interrupt"
