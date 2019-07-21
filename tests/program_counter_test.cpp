
#include <gtest/gtest.h>
#include "test_helper.hpp"
#include "Vprogram_counter.h"


#define TICK \
    dut.i_Clock = 1; \
    dut.eval(); \
    dut.i_Clock = 0; \
    dut.eval();

#define RESET \
    dut.i_Reset = 1; \
    TICK; \
    dut.i_Reset = 0;


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
    RESET;

    dut.i_Branch = 1;

    // BEQ
    dut.i_BranchType = 0b000;
    dut.i_BranchAddress = 0x10000000;
    dut.i_AluZero = 1;
    TICK;
    EXPECT_EQ_HEX(dut.o_InstructionPointer, dut.i_BranchAddress);
    dut.i_AluZero = 0;
    TICK;
    EXPECT_NE_HEX(dut.o_InstructionPointer, dut.i_BranchAddress);

    // BNE
    dut.i_BranchType = 0b001;
    dut.i_BranchAddress = 0x20000000;
    dut.i_AluZero = 0;
    TICK;
    EXPECT_EQ_HEX(dut.o_InstructionPointer, dut.i_BranchAddress);
    dut.i_AluZero = 1;
    TICK;
    EXPECT_NE_HEX(dut.o_InstructionPointer, dut.i_BranchAddress);

    // BLT
    dut.i_BranchType = 0b100;
    dut.i_BranchAddress = 0x30000000;
    dut.i_AluLessThan = 1;
    TICK;
    EXPECT_EQ_HEX(dut.o_InstructionPointer, dut.i_BranchAddress);
    dut.i_AluLessThan = 0;
    TICK;
    EXPECT_NE_HEX(dut.o_InstructionPointer, dut.i_BranchAddress);

    // BGE
    dut.i_BranchType = 0b101;
    dut.i_BranchAddress = 0x40000000;
    dut.i_AluLessThan = 0;
    TICK;
    EXPECT_EQ_HEX(dut.o_InstructionPointer, dut.i_BranchAddress);
    dut.i_AluLessThan = 1;
    TICK;
    EXPECT_NE_HEX(dut.o_InstructionPointer, dut.i_BranchAddress);

    // BLTU
    dut.i_BranchType = 0b110;
    dut.i_BranchAddress = 0x50000000;
    dut.i_AluLessThanUnsigned = 1;
    TICK;
    EXPECT_EQ_HEX(dut.o_InstructionPointer, dut.i_BranchAddress);
    dut.i_AluLessThanUnsigned = 0;
    TICK;
    EXPECT_NE_HEX(dut.o_InstructionPointer, dut.i_BranchAddress);

    // BGEU
    dut.i_BranchType = 0b111;
    dut.i_BranchAddress = 0x50000000;
    dut.i_AluLessThanUnsigned = 0;
    TICK;
    EXPECT_EQ_HEX(dut.o_InstructionPointer, dut.i_BranchAddress);
    dut.i_AluLessThanUnsigned = 1;
    TICK;
    EXPECT_NE_HEX(dut.o_InstructionPointer, dut.i_BranchAddress);

}


TEST(ProgramCounter, Jump)
{
    Vprogram_counter dut;
    dut.i_Clock = 0;
    dut.i_Reset = 0;
    dut.i_Jump = 0;
    dut.i_Branch = 0;
    dut.eval();
    RESET;

    dut.i_Jump = 1;
    dut.i_BranchAddress = 0xabcdef00;
    TICK;
    EXPECT_EQ_HEX(dut.o_InstructionPointer, dut.i_BranchAddress);

}

// TODO: Test that an exception is raised on an instruction address misalignment
