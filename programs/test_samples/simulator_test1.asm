
# Build commands:
#   as simulator_test1.s -o simulator_test1.o && objdump -d simulator_test1.o
#   objcopy -O binary simulator_test1.o simulator_test1.bin
#   xxd -e simulator_test1.bin

# TODO: Emit and consume hex file


# Add up the numbers from 1 to 10  (the answer is 45, or 0x2d)

.text
_start:
    addi s0, zero, 1
    addi s0, s0, 2
    addi s0, s0, 3
    addi s0, s0, 4
    addi s0, s0, 5
    addi s0, s0, 6
    addi s0, s0, 7
    addi s0, s0, 8
    addi s0, s0, 9
    add a0, s0, zero
    ecall

    jal ra, _start
