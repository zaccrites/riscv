
#include "gtest/gtest.h"
#include "test_helper.hpp"
#include "Vmemory.h"


TEST(Memory, main)
{
    Vmemory dut;
    dut.i_Clock = 0;
    dut.eval();

    for (uint32_t address = 0; address < 1024; address++) {
        dut.i_Address = address;
        uint32_t value = 0x12340000 | (address & 0x0000ffff);

        dut.i_WriteEnable = 1;
        dut.i_DataIn = value;
        TICK;
        EXPECT_EQ_HEX(dut.o_DataOut, value) << address;

        dut.i_WriteEnable = 0;
        dut.i_DataIn = 0xdeadbeef;
        TICK;
        EXPECT_EQ_HEX(dut.o_DataOut, value) << address;

    }

}
