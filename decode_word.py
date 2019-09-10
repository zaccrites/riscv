"""Decode a RISC-V instruction word."""

# TODO: Disassemble the word

import sys
import argparse


def get_bits(word, high_bit, low_bit):
    mask = 0
    bit_count = high_bit - low_bit + 1
    for i in range(bit_count):
        mask |= 1 << i
    return mask & (word >> low_bit)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('word')
    args = parser.parse_args()

    # TODO: This interface could be better.
    # Probably also done by argparse.
    word = int(args.word, 16)

    funct12 = get_bits(word, 31, 20)
    rs2 = get_bits(word, 24, 20)
    rs1 = get_bits(word, 19, 15)
    funct3 = get_bits(word, 14, 12)
    rd = get_bits(word, 11, 7)
    opcode = get_bits(word, 6, 2)
    suffix = get_bits(word, 1, 0)


    # TODO: Determine which immediate to show using the opcode.

    # TODO: Sign extension
    i_imm = get_bits(word, 30, 20)
    print(f'I-Type Immediate: {i_imm:d}')

    print(f'Opcode: {opcode:02x}h    ({opcode:05b})')
    print(f'Suffix: {suffix:02b}b')




if __name__ == '__main__':
    sys.exit(main())
