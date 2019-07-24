
# Sample instructions for unit testing the instruction decode module.

# $ as instruction_decode_samples.s -o instruction_decode_samples.o
# $ objdump -d instruction_decode_samples.o

.text
main:
    sub x1, x2, x3
    auipc x1, 200
    lui x2, 400

.loop:
    sw x3, 100(x4)
    lw x1, 100(x2)
    bne x1, x3, .loop

.loop2:
    addi x5, x6, 500
    jal x1, .loop2
    jalr x2, 100(x5)
