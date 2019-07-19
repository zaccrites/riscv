
#include <gtest/gtest.h>
#include "test_helper.hpp"
#include "Vinstruction_decode.h"


TEST(InstructionDecode, TestLoad)
{

}


TEST(InstructionDecode, TestOpImm)
{

}


TEST(InstructionDecode, TestAUIPC)
{

}


TEST(InstructionDecode, TestStore)
{

}


TEST(InstructionDecode, TestOp)
{

}


TEST(InstructionDecode, TestLUI)
{

}


TEST(InstructionDecode, TestBranch)
{

}


TEST(InstructionDecode, TestJALR)
{

}


TEST(InstructionDecode, TestJAL)
{
    Vinstruction_decode dut;

    dut.i_InstructionWord = 0b11110000111100001111'10101'1101111;
    dut.eval();
    EXPECT_EQ_HEX(dut.o_IllegalInstruction, 0);
    EXPECT_EQ_HEX(dut.o_rd, 0b10101);
    EXPECT_EQ_HEX(dut.o_Jump, 1);
    EXPECT_EQ_HEX(dut.o_Branch, 0);
}


TEST(InstructionDecode, TestIllegalInstructions)
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
