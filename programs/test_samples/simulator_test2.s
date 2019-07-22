

# Emit fibonacci numbers

.text
_start:
    # Go to main routine
    jal main

    # Terminate the program
    li a0, 2
    ecall

    nop
    nop
    nop
    j .


# s0 - counter
# s1 - a
# s2 - b
# t0 - tmp
main:
    li s0, 10       # calculate the first 10 fibonacci numbers
    li s1, 0
    li s2, 1

.loop:
    # Print b
    li a0, 1
    mv a1, s2
    ecall

    mv t0, s1         # tmp = a
    mv s1, s2         # a = b
    add s2, s1, t0    # b = a + tmp

    addi s0, s0, -1
    bne s0, zero, .loop
    jr ra       # return after 10 iterations

    # Print the intended target address
    li a0, 1
    mv a1, ra
    ecall
    nop
    nop
    nop
