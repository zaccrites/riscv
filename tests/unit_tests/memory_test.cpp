
#include "gtest/gtest.h"
#include "test_helper.hpp"
#include "Vmemory.h"
#include "Vmemory_defines.h"


// TODO: Signed half and byte access


TEST(Memory, WordAccess)
{
    Vmemory dut;
    dut.i_Clock = 0;
    dut.eval();

    // for (uint32_t address = 0; address < 16; address += 4) {
    for (uint32_t address = 4; address < 8; address += 4) {
        dut.i_Address = address;
        uint32_t value = 0x12345600 | (address & 0xff);

        dut.i_Mode = SVDEF_STORE_WORD;
        dut.i_ReadEnable = 0;
        dut.i_WriteEnable = 1;
        dut.i_DataIn = value;
        TICK;
        EXPECT_EQ_HEX(dut.o_DataOut, value) << address;
        EXPECT_EQ(dut.o_MisalignedAccess, 0) << address;
        EXPECT_EQ(dut.o_BadInstruction, 0) << address;

        dut.i_Mode = SVDEF_LOAD_WORD;
        dut.i_ReadEnable = 1;
        dut.i_WriteEnable = 0;
        dut.i_DataIn = 0xcccccccc;
        TICK;
        EXPECT_EQ_HEX(dut.o_DataOut, value) << address;
        EXPECT_EQ(dut.o_MisalignedAccess, 0) << address;
        EXPECT_EQ(dut.o_BadInstruction, 0) << address;
    }
}


TEST(Memory, HalfAccess)
{
    Vmemory dut;
    dut.i_Clock = 0;
    dut.i_ReadEnable = 1;
    dut.eval();

    for (uint32_t address = 0; address < 4; address += 2) {
        dut.i_Address = address;
        uint32_t value = 0x1200 | (address & 0xff);

        dut.i_Mode = SVDEF_STORE_HALF;
        dut.i_WriteEnable = 1;
        dut.i_DataIn = value;
        TICK;
        EXPECT_EQ_HEX(dut.o_DataOut, value) << address;

        dut.i_Mode = SVDEF_LOAD_HALF_UNSIGNED;
        dut.i_WriteEnable = 0;
        dut.i_DataIn = 0xcccccccc;
        TICK;
        EXPECT_EQ_HEX(dut.o_DataOut, value) << address;
    }
}


TEST(Memory, ByteAccess)
{
    Vmemory dut;
    dut.i_Clock = 0;
    dut.i_ReadEnable = 1;
    dut.eval();

    for (uint32_t address = 0; address < 4; address += 1) {
        dut.i_Address = address;
        uint32_t value = (address & 0xff);

        dut.i_Mode = SVDEF_STORE_BYTE;
        dut.i_WriteEnable = 1;
        dut.i_DataIn = value;
        TICK;
        EXPECT_EQ_HEX(dut.o_DataOut, value) << address;

        dut.i_Mode = SVDEF_LOAD_BYTE_UNSIGNED;
        dut.i_WriteEnable = 0;
        dut.i_DataIn = 0xcccccccc;
        TICK;
        EXPECT_EQ_HEX(dut.o_DataOut, value) << address;
    }
}
