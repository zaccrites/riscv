
#include <gtest/gtest.h>
#include "test_helper.hpp"
#include "Vregister_file.h"


TEST(RegisterFile, ReadAndWrite)
{
    Vregister_file dut;
    dut.i_Clock = 0;
    dut.eval();

    // Register 0 is zero and read-only.
    dut.i_WriteEnable = 1;
    dut.i_RegDest = 0;
    dut.i_RegSource1 = 0;
    dut.i_RegSource2 = 0;
    dut.i_DataIn = 0x12345678;
    TICK;
    EXPECT_EQ_HEX(dut.o_DataOut1, 0x00000000);
    EXPECT_EQ_HEX(dut.o_DataOut2, 0x00000000);

    // All other registers are writable and retain their values.
    for (int rd = 1; rd <= 31; rd++) {
        dut.i_WriteEnable = 1;
        dut.i_RegDest = rd;
        dut.i_RegSource1 = rd;
        dut.i_RegSource2 = rd - 1;
        dut.i_DataIn = rd;
        TICK;
        EXPECT_EQ_HEX(dut.o_DataOut1, rd);
        EXPECT_EQ_HEX(dut.o_DataOut2, rd - 1);

        dut.i_WriteEnable = 0;
        dut.i_DataIn = 0x12345678;
        EXPECT_EQ_HEX(dut.o_DataOut1, rd);
        EXPECT_EQ_HEX(dut.o_DataOut2, rd - 1);
    }

}
