
# Calculate a factorial


# https://github.com/riscv/riscv-asm-manual/blob/master/riscv-asm.md

.text
_start:
    jal main

    # Terminate the program
    li a0, 2
    ecall
    nop
    j .          # Just in case something goes wrong


main:
    mv s11, ra

    # Calculate 6!
    li s0, 6           # Running product
    mv s1, s0          # Multiplier (to be decremented)
1:
    addi s1, s1, -1
    beqz s1, 2f

    mv a0, s0
    mv a1, s1
    jal multiply
    mv s0, a0

    j 1b
2:

    # Store answer to memory (just for fun)
    li sp, 8
    sw s0, -4(sp)

    # Print answer
    li a0, 1
    lw a1, -4(sp)           # <--- Not working (or the store isn't working, either way)
    ecall
    mv a1, s0
    ecall

    jr s11



# Calculate multiplication by repeated addition.
# Assumes a0 and a1 are unsigned.
#   Return a0 * a1 in a0
#
# Probably not optimal assembly.
multiply:
    beqz a0, .return
    beqz a1, .retzero
    mv t0, a0  # increment to add by
    li t1, 1
.looptop:
    beq a1, t1, .return
    add a0, t0, a0
    addi a1, a1, -1
    j .looptop
.retzero:
    li a0, 0
.return:
    jr ra
