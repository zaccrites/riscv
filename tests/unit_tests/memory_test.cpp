
#include "gtest/gtest.h"
#include "test_helper.hpp"
#include "Vmemory.h"
#include "Vmemory_defines.h"


TEST(Memory, main)
{
    Vmemory dut;
    dut.i_Clock = 0;

    dut.i_ReadEnable = 1;

    // TODO: Add test for different read modes
    dut.i_Mode = SVDEF_LOAD_WORD;

    dut.eval();

    // TODO: Generate a C++ header for SystemVerilog cpudefs


    // This is word aligned only at the moment!
    for (uint32_t address = 0; address < 1024; address += 4) {
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
