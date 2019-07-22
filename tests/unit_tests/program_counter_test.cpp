
#include <gtest/gtest.h>
#include "test_helper.hpp"
#include "Vprogram_counter.h"


TEST(ProgramCounter, AdvanceToNextInstruction)
{
    Vprogram_counter dut;
    dut.i_Clock = 0;
    dut.i_Reset = 0;
    dut.i_Jump = 0;
    dut.i_Branch = 0;
    dut.eval();

    RESET;
    EXPECT_EQ_HEX(dut.o_InstructionPointer, 0x00000000);

    TICK;
    EXPECT_EQ_HEX(dut.o_InstructionPointer, 0x00000004);
    TICK;
    EXPECT_EQ_HEX(dut.o_InstructionPointer, 0x00000008);
    TICK;
    EXPECT_EQ_HEX(dut.o_InstructionPointer, 0x0000000c);
    TICK;
    EXPECT_EQ_HEX(dut.o_InstructionPointer, 0x00000010);

}


TEST(ProgramCounter, Branch)
{
    // Taken vs. untaken
    // BEQ, BNE, BLT, BLTU, BGE, BGEU

    Vprogram_counter dut;
    dut.i_Clock = 0;
    dut.i_Reset = 0;
    dut.i_Jump = 0;
    dut.i_Branch = 0;
    dut.eval();

    dut.i_Branch = 1;
    dut.i_BranchOffset = -4;

    // BEQ
    RESET;
    dut.i_BranchType = 0b000;
    dut.i_AluZero = 1;
    TICK;
    EXPECT_EQ_HEX(dut.o_InstructionPointer, 0x00000000);
    //   not taken
    RESET;
    dut.i_AluZero = 0;
    TICK;
    EXPECT_EQ_HEX(dut.o_InstructionPointer, 0x00000004);

    // BNE
    RESET;
    dut.i_BranchType = 0b001;
    dut.i_AluZero = 0;
    TICK;
    EXPECT_EQ_HEX(dut.o_InstructionPointer, 0x00000000);
    //   not taken
    RESET;
    dut.i_AluZero = 1;
    TICK;
    EXPECT_EQ_HEX(dut.o_InstructionPointer, 0x00000004);

    // BLT
    RESET;
    dut.i_BranchType = 0b100;
    dut.i_AluLessThan = 1;
    TICK;
    EXPECT_EQ_HEX(dut.o_InstructionPointer, 0x00000000);
    //   not taken
    RESET;
    dut.i_AluLessThan = 0;
    TICK;
    EXPECT_EQ_HEX(dut.o_InstructionPointer, 0x00000004);

    // BGE taken
    RESET;
    dut.i_BranchType = 0b101;
    dut.i_AluLessThan = 0;
    TICK;
    EXPECT_EQ_HEX(dut.o_InstructionPointer, 0x00000000);
    //   not taken
    RESET;
    dut.i_AluLessThan = 1;
    TICK;
    EXPECT_EQ_HEX(dut.o_InstructionPointer, 0x00000004);

    // BLTU
    dut.i_BranchType = 0b110;
    dut.i_AluLessThanUnsigned = 1;
    RESET;
    TICK;
    EXPECT_EQ_HEX(dut.o_InstructionPointer, 0x00000000);
    //   not taken
    RESET;
    dut.i_AluLessThanUnsigned = 0;
    TICK;
    EXPECT_EQ_HEX(dut.o_InstructionPointer, 0x00000004);

    // BGEU
    dut.i_BranchType = 0b111;
    dut.i_AluLessThanUnsigned = 0;
    RESET;
    TICK;
    EXPECT_EQ_HEX(dut.o_InstructionPointer, 0x00000000);
    //   not taken
    RESET;
    dut.i_AluLessThanUnsigned = 1;
    TICK;
    EXPECT_EQ_HEX(dut.o_InstructionPointer, 0x00000004);

}


TEST(ProgramCounter, Jump)
{
    Vprogram_counter dut;
    dut.i_Clock = 0;
    dut.i_Reset = 0;
    dut.i_Jump = 0;
    dut.i_Branch = 0;
    dut.eval();

    dut.i_BranchOffset = -4;

    RESET;
    dut.i_Jump = 1;
    TICK;
    EXPECT_EQ_HEX(dut.o_InstructionPointer, 0x00000000);

    RESET;
    dut.i_Jump = 0;
    TICK;
    EXPECT_EQ_HEX(dut.o_InstructionPointer, 0x00000004);

}

// TODO: Test that an exception is raised on an instruction address misalignment
