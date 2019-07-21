
#include <gtest/gtest.h>
#include "test_helper.hpp"
#include "Vinstruction_decode.h"


// See /programs/test_samples/instruction_decode_sample.s
// for sample program and instruction words used here.

// TODO: More comprehensive tests of control signal outputs?


TEST(InstructionDecode, Load)
{
    Vinstruction_decode dut;
    dut.i_InstructionWord = 0x06412083;  // lw x1, 100(x2)
    dut.eval();
    EXPECT_EQ(dut.o_rd, 1);
    EXPECT_EQ(dut.o_rs1, 2);
    EXPECT_EQ(dut.o_ImmediateData, 100);
    EXPECT_EQ(dut.o_AluOp, 0b000);
    EXPECT_EQ(dut.o_AluOpAlt, 0);
    EXPECT_EQ(dut.o_MemRead, 1);
    EXPECT_EQ(dut.o_RegWrite, 1);
    EXPECT_EQ(dut.o_MemWrite, 0);
}


TEST(InstructionDecode, OpImm)
{
    Vinstruction_decode dut;
    dut.i_InstructionWord = 0x1f430293;  // addi x5, x6, 500
    dut.eval();
    EXPECT_EQ(dut.o_rd, 5);
    EXPECT_EQ(dut.o_rs1, 6);
    EXPECT_EQ(dut.o_ImmediateData, 500);
    EXPECT_EQ(dut.o_AluOp, 0b000);
    EXPECT_EQ(dut.o_AluOpAlt, 0);
    EXPECT_EQ(dut.o_RegWrite, 1);
    EXPECT_EQ(dut.o_MemWrite, 0);
}


TEST(InstructionDecode, AUIPC)
{
    Vinstruction_decode dut;
    dut.i_InstructionWord = 0x000c8097;   // auipc x1, 200
    dut.eval();
    EXPECT_EQ(dut.o_rd, 1);
    EXPECT_EQ(dut.o_ImmediateData, 200 << 12);
    EXPECT_EQ(dut.o_RegWrite, 1);
    EXPECT_EQ(dut.o_MemWrite, 0);
}


TEST(InstructionDecode, Store)
{
    Vinstruction_decode dut;
    dut.i_InstructionWord = 0x06322223;  // sw x3, 100(x4)
    dut.eval();
    EXPECT_EQ(dut.o_rs1, 4);
    EXPECT_EQ(dut.o_rs2, 3);
    EXPECT_EQ(dut.o_ImmediateData, 100);
    EXPECT_EQ(dut.o_AluOp, 0b000);
    EXPECT_EQ(dut.o_AluOpAlt, 0);
    EXPECT_EQ(dut.o_MemWrite, 1);
    EXPECT_EQ(dut.o_RegWrite, 0);
}


TEST(InstructionDecode, Op)
{
    Vinstruction_decode dut;
    dut.i_InstructionWord = 0x403100b3;  // sub x1, x2, x3
    dut.eval();
    EXPECT_EQ(dut.o_rd, 1);
    EXPECT_EQ(dut.o_rs1, 2);
    EXPECT_EQ(dut.o_rs2, 3);
    EXPECT_EQ(dut.o_AluOp, 0b000);
    EXPECT_EQ(dut.o_AluOpAlt, 1);
    EXPECT_EQ(dut.o_RegWrite, 1);
    EXPECT_EQ(dut.o_MemWrite, 0);
}


TEST(InstructionDecode, LUI)
{
    Vinstruction_decode dut;
    dut.i_InstructionWord = 0x00190137;  // lui x2, 400
    dut.eval();
    EXPECT_EQ(dut.o_rd, 2);
    EXPECT_EQ(dut.o_ImmediateData, 400 << 12);
    EXPECT_EQ(dut.o_RegWrite, 1);
    EXPECT_EQ(dut.o_MemWrite, 0);
}


TEST(InstructionDecode, Branch)
{
    Vinstruction_decode dut;
    dut.i_InstructionWord = 0xfe309ce3;  // bne x1, x3, -8
    dut.eval();
    EXPECT_EQ(dut.o_rs1, 1);
    EXPECT_EQ(dut.o_rs2, 3);
    EXPECT_EQ(dut.o_ImmediateData, -8);
    EXPECT_EQ(dut.o_Branch, 1);
    EXPECT_EQ(dut.o_Funct, 0b001);
    EXPECT_EQ(dut.o_AluOp, 0b000);
    EXPECT_EQ(dut.o_AluOpAlt, 1);
    EXPECT_EQ(dut.o_RegWrite, 0);
    EXPECT_EQ(dut.o_MemWrite, 0);
}


TEST(InstructionDecode, JALR)
{
    Vinstruction_decode dut;
    dut.i_InstructionWord = 0x06428167;  // jalr x2, 100(x5)
    dut.eval();
    EXPECT_EQ(dut.o_rd, 2);
    EXPECT_EQ(dut.o_rs1, 5);
    EXPECT_EQ(dut.o_ImmediateData, 100);
    EXPECT_EQ(dut.o_Jump, 1);
    EXPECT_EQ(dut.o_RegWrite, 1);
    EXPECT_EQ(dut.o_MemWrite, 0);
}


TEST(InstructionDecode, JAL)
{
    Vinstruction_decode dut;
    dut.i_InstructionWord = 0xffdff0ef;  // jal x1, -4
    dut.eval();
    EXPECT_EQ(dut.o_rd, 1);
    EXPECT_EQ(dut.o_ImmediateData, -4);
    EXPECT_EQ_HEX(dut.o_Jump, 1);
    EXPECT_EQ(dut.o_RegWrite, 1);
    EXPECT_EQ(dut.o_MemWrite, 0);
}


TEST(InstructionDecode, IllegalInstructions)
{
    Vinstruction_decode dut;

    // All zeros is always an illegal instruction
    dut.i_InstructionWord = 0x00000000;
    dut.eval();
    EXPECT_EQ_HEX(dut.o_IllegalInstruction, 1);

    // Currently any instruction not ending in 0b...11 is illegal.
    dut.i_InstructionWord = 0x00000001;
    dut.eval();
    EXPECT_EQ_HEX(dut.o_IllegalInstruction, 1);
    dut.i_InstructionWord = 0x00000002;
    dut.eval();
    EXPECT_EQ_HEX(dut.o_IllegalInstruction, 1);
    dut.i_InstructionWord = 0x00000003;
    dut.eval();
    EXPECT_EQ_HEX(dut.o_IllegalInstruction, 0);

}
