


.section .text
.global _start
_start:

    # TODO: Test the data memory


    # Doesn't work because forwarding isn't implemented!
    #addi x1, x0, 1
    #add  x2, x1, x1
    #add  x2, x2, x1
    #add  x2, x2, x1
    #add  x2, x2, x1

    # Inserting NOPs allows the calculation to work.
    addi x1, x0, 1
    nop
    nop
    add  x2, x1, x0
    nop
    nop
    add  x2, x2, x1
    nop
    nop
    add  x2, x2, x1
    nop
    nop
    add  x2, x2, x1
    nop
    nop
    ######
    add  x2, x2, x2
    nop
    nop
    add  x2, x2, x2
    nop
    nop
    add  x2, x2, x2
    nop
    nop
    add  x2, x2, x2
    nop
    nop
    add  x2, x2, x2
    nop
    nop
    add  x2, x2, x2
    nop
    nop


    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    # j .
