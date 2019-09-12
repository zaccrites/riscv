


.section .text
.global _start
_start:

    # TODO: Test the data memory


    # Doesn't work because forwarding isn't implemented!
    addi x1, x0, 1
    addi x2, x0, 1
    add  x1, x1, x1
    add  x2, x2, x2
    add  x1, x1, x1
    add  x2, x2, x2
    add  x1, x1, x1
    add  x2, x2, x2
    add  x1, x1, x1
    add  x2, x2, x2
    add  x1, x1, x1
    add  x2, x2, x2

    # # Inserting NOPs allows the calculation to work.
    # addi x1, x0, 1
    # # nop
    # # nop
    # add  x2, x1, x0
    # # nop
    # # nop
    # add  x2, x2, x1
    # # nop
    # # nop
    # add  x2, x2, x1
    # # nop
    # # nop
    # add  x2, x2, x1
    # # nop
    # # nop
    # ######
    # add  x2, x2, x2
    # # nop
    # # nop
    # add  x2, x2, x2
    # # nop
    # # nop
    # add  x2, x2, x2
    # # nop
    # # nop
    # add  x2, x2, x2
    # # nop
    # # nop
    # add  x2, x2, x2
    # # nop
    # # nop
    # add  x2, x2, x2
    # # nop
    # # nop
    # slli x2, x2, 4
    # # nop
    # # nop
    # slli x2, x2, 4
    # # nop
    # # nop
    # slli x2, x2, 4
    # # nop
    # # nop
    # slli x2, x2, 4
    # # nop
    # # nop


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
    nop
    # j .
