
# rv8.io/asm.html


.section .vector_table
_reset:
    j _start


.section .text
.global _start
_start:
#     # Clear .bss section
#     la t0, _sbss
#     la t1, _ebss
# 1:
#     bge t0, t1, 2f
#     sw x0, 0(t0)
#     addi t0, x0, 4
#     j 1b
# 2:

    # Setup stack pointer
    la sp, _stack_start

    # Jump to main program
    # li a0, 4
    # la a1, fake_argv
    li a0, 3
    li a1, 0
    # jal main

    # mv s0, a0
    # mv s1, a1
    # li a0, 0
    # ecall

    # Print status code
    #mv a1, a0
    #li a0, 1
    #ecall




    addi    sp,sp,-32 # ffe0 <_edata+0x7fe0>
    sw  s0,28(sp)
    addi    s0,sp,32
    sw  a0,-20(s0)
    sw  a1,-24(s0)


    # BUG: a5=0 after this, then it should =3
    # Either the load or store to the intended stack address is failing
    lw  a5,-20(s0)



    mv t6, a0
    lw t5, -20(s0)


    li a0, 0
    ecall


    addi    a5,a5,4
    mv  a0,a5
    lw  s0,28(sp)
    addi    sp,sp,32
    # ret






    # Terminate the program
    #li a0, 3
    #la a1, term_msg
    #ecall
    li a0, 2
    ecall
    #j .
    #nop
    #nop
    #nop


# .section .rodata
# term_msg: .string   "Ending program\n"
# fake_argv:
#     .string  "cprogram1"
#     .string  "arg1"
#     .string  "arg2"
#     .string  "arg3"
