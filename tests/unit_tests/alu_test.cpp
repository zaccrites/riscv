
#include <stdint.h>
#include <gtest/gtest.h>
#include "test_helper.hpp"
#include "Valu.h"
#include "Valu_defines.h"


TEST(Alu, Add)
{
    Valu dut;
    dut.i_AluOp = SVDEF_ALUOP_ADD;
    dut.i_AluOpAlt = 0;

    dut.i_Source1 = 150;
    dut.i_Source2 = 150;
    dut.eval();
    EXPECT_EQ(dut.o_Output, 300);
    EXPECT_EQ(dut.o_Zero, 0);

    dut.i_Source1 = 150;
    dut.i_Source2 = -150;
    dut.eval();
    EXPECT_EQ(dut.o_Output, 0);
    EXPECT_EQ(dut.o_Zero, 1);

    dut.i_Source1 = -150;
    dut.i_Source2 = -150;
    dut.eval();
    EXPECT_EQ(dut.o_Output, -300);
    EXPECT_EQ(dut.o_Zero, 0);
}


TEST(Alu, ShiftLeft)
{
    Valu dut;
    dut.i_AluOp = SVDEF_ALUOP_SLL;
    dut.i_AluOpAlt = 0;
    dut.i_Source1 = 0x12345678;

    for (uint32_t shamt = 0; shamt <= 31; shamt++)
    {
        dut.i_Source2 = shamt;
        dut.eval();
        EXPECT_EQ_HEX(dut.o_Output, dut.i_Source1 << shamt);
    }
}


TEST(Alu, SetLessThan)
{
    Valu dut;
    dut.i_AluOp = SVDEF_ALUOP_SLT;

    dut.i_Source1 = 10;
    dut.i_Source2 = 20;
    dut.eval();
    EXPECT_EQ(dut.o_Output, 1);
    EXPECT_EQ(dut.o_LessThan, 1);

    dut.i_Source1 = 20;
    dut.i_Source2 = 10;
    dut.eval();
    EXPECT_EQ(dut.o_Output, 0);
    EXPECT_EQ(dut.o_LessThan, 0);

    dut.i_Source1 = 10;
    dut.i_Source2 = 10;
    dut.eval();
    EXPECT_EQ(dut.o_Output, 0);
    EXPECT_EQ(dut.o_LessThan, 0);

    dut.i_Source1 = 10;
    dut.i_Source2 = -10;
    dut.eval();
    EXPECT_EQ(dut.o_Output, 0);
    EXPECT_EQ(dut.o_LessThan, 0);

    dut.i_Source1 = -10;
    dut.i_Source2 = 10;
    dut.eval();
    EXPECT_EQ(dut.o_Output, 1);
    EXPECT_EQ(dut.o_LessThan, 1);

    dut.i_Source1 = -20;
    dut.i_Source2 = -10;
    dut.eval();
    EXPECT_EQ(dut.o_Output, 1);
    EXPECT_EQ(dut.o_LessThan, 1);

    dut.i_Source1 = -10;
    dut.i_Source2 = -20;
    dut.eval();
    EXPECT_EQ(dut.o_Output, 0);
    EXPECT_EQ(dut.o_LessThan, 0);

}


TEST(Alu, SetLessThanUnsigned)
{
    Valu dut;
    dut.i_AluOp = SVDEF_ALUOP_SLTU;

    dut.i_Source1 = 0xffffff00;
    dut.i_Source2 = 0xffffffff;
    dut.eval();
    EXPECT_EQ(dut.o_Output, 1);
    EXPECT_EQ(dut.o_LessThanUnsigned, 1);

    dut.i_Source1 = 0xffffffff;
    dut.i_Source2 = 0xffffff00;
    dut.eval();
    EXPECT_EQ(dut.o_Output, 0);
    EXPECT_EQ(dut.o_LessThanUnsigned, 0);

    dut.i_Source1 = 0xffffffff;
    dut.i_Source2 = 0xffffffff;
    dut.eval();
    EXPECT_EQ(dut.o_Output, 0);
    EXPECT_EQ(dut.o_LessThanUnsigned, 0);

}


TEST(Alu, ShiftRightLogical)
{
    Valu dut;
    dut.i_AluOp = SVDEF_ALUOP_SRL;
    dut.i_AluOpAlt = 0;
    dut.i_Source1 = 0x12345678;

    for (uint32_t shamt = 0; shamt <= 31; shamt++)
    {
        dut.i_Source2 = shamt;
        dut.eval();
        EXPECT_EQ_HEX(dut.o_Output, dut.i_Source1 >> shamt);
    }
}



TEST(Alu, ShiftRightArithmetic)
{
    Valu dut;
    dut.i_AluOp = SVDEF_ALUOP_SRL;
    dut.i_AluOpAlt = 1;

    // With cleared MSB
    dut.i_Source1 = 0x12345678;
    dut.i_Source2 = 0;
    dut.eval();
    EXPECT_EQ_HEX(dut.o_Output, 0x12345678);

    dut.i_Source2 = 4;
    dut.eval();
    EXPECT_EQ_HEX(dut.o_Output, 0x01234567);

    dut.i_Source2 = 8;
    dut.eval();
    EXPECT_EQ_HEX(dut.o_Output, 0x00123456);

    dut.i_Source2 = 12;
    dut.eval();
    EXPECT_EQ_HEX(dut.o_Output, 0x00012345);

    dut.i_Source2 = 16;
    dut.eval();
    EXPECT_EQ_HEX(dut.o_Output, 0x00001234);

    dut.i_Source2 = 20;
    dut.eval();
    EXPECT_EQ_HEX(dut.o_Output, 0x00000123);

    dut.i_Source2 = 24;
    dut.eval();
    EXPECT_EQ_HEX(dut.o_Output, 0x00000012);

    dut.i_Source2 = 28;
    dut.eval();
    EXPECT_EQ_HEX(dut.o_Output, 0x00000001);


    // With set MSB
    dut.i_Source1 = 0x92345678;
    dut.i_Source2 = 0;
    dut.eval();
    EXPECT_EQ_HEX(dut.o_Output, 0x92345678);

    dut.i_Source2 = 4;
    dut.eval();
    EXPECT_EQ_HEX(dut.o_Output, 0xf9234567);

    dut.i_Source2 = 8;
    dut.eval();
    EXPECT_EQ_HEX(dut.o_Output, 0xff923456);

    dut.i_Source2 = 12;
    dut.eval();
    EXPECT_EQ_HEX(dut.o_Output, 0xfff92345);

    dut.i_Source2 = 16;
    dut.eval();
    EXPECT_EQ_HEX(dut.o_Output, 0xffff9234);

    dut.i_Source2 = 20;
    dut.eval();
    EXPECT_EQ_HEX(dut.o_Output, 0xfffff923);

    dut.i_Source2 = 24;
    dut.eval();
    EXPECT_EQ_HEX(dut.o_Output, 0xffffff92);

    dut.i_Source2 = 28;
    dut.eval();
    EXPECT_EQ_HEX(dut.o_Output, 0xfffffff9);

}


TEST(Alu, BitwiseAnd)
{
    Valu dut;
    dut.i_AluOp = SVDEF_ALUOP_AND;
    dut.i_Source1 = 0x12345678;
    dut.i_Source2 = 0xaabcdeff;
    dut.eval();
    EXPECT_EQ_HEX(dut.o_Output, dut.i_Source1 & dut.i_Source2);
}


TEST(Alu, BitwiseOr)
{
    Valu dut;
    dut.i_AluOp = SVDEF_ALUOP_OR;
    dut.i_Source1 = 0x12345678;
    dut.i_Source2 = 0xaabcdeff;
    dut.eval();
    EXPECT_EQ_HEX(dut.o_Output, dut.i_Source1 | dut.i_Source2);
}


TEST(Alu, BitwiseXor)
{
    Valu dut;
    dut.i_AluOp = SVDEF_ALUOP_XOR;
    dut.i_Source1 = 0x12345678;
    dut.i_Source2 = 0xaabcdeff;
    dut.eval();
    EXPECT_EQ_HEX(dut.o_Output, dut.i_Source1 ^ dut.i_Source2);
}
