
// Putting this on hold as the tests will all have to change when
// the memory module is pipelined.


// #include "gtest/gtest.h"
// #include "test_helper.hpp"
// #include "Vmemory.h"
// #include "Vmemory_defines.h"


// // TODO: Signed half and byte access


// #define ADDRESS_START   0
// #define ADDRESS_END     4



// static uint32_t readWord(const Vmemory& dut, uint32_t address)
// {
//     return
//         (dut.memory__DOT__r_RAM[address][3] << 24) |
//         (dut.memory__DOT__r_RAM[address][2] << 16) |
//         (dut.memory__DOT__r_RAM[address][1] << 8) |
//         (dut.memory__DOT__r_RAM[address][0]);
// }


// static void writeWord(const Vmemory& dut, uint32_t address, uint32_t value)
// {
//     dut.memory__DOT__r_RAM[address][3] = static_cast<uint8_t>(value >> 24);
//     dut.memory__DOT__r_RAM[address][2] = static_cast<uint8_t>(value >> 16);
//     dut.memory__DOT__r_RAM[address][1] = static_cast<uint8_t>(value >> 8);
//     dut.memory__DOT__r_RAM[address][0] = static_cast<uint8_t>(value);
// }


// TEST(Memory, WordAccess)
// {
//     Vmemory dut;
//     dut.i_Clock = 0;

//     dut.eval();

//     for (uint32_t address = ADDRESS_START; address < ADDRESS_END; address += 4)
//     {
//         writeWord(dut, address, 0xaaaaaaaa);


//         dut.i_Mode = SVDEF_STORE_WORD;
//         dut.i_ReadEnable = 0;
//         dut.i_WriteEnable = 1;
//         dut.i_DataIn = 0xbbbbbbbb;
//         TICK;
//         EXPECT_EQ(dut.o_MisalignedAccess, 0) << address;
//         EXPECT_EQ(dut.o_BadInstruction, 0) << address;
//         EXPECT_EQ_HEX(readWord(dut, address), 0xbbbbbbbb);






//     }

// }


// TEST(Memory, LoadWord)
// {
//     Vmemory dut;
//     dut.i_Clock = 0;
//     dut.i_ReadEnable = 1;
//     dut.i_WriteEnable = 0;
//     dut.i_Mode = SVDEF_LOAD_WORD;
//     dut.eval();

//     for (uint32_t address = ADDRESS_START; address < ADDRESS_END; address += 4)
//     {
//         writeWord(dut, address, 0xaaaaaaaa);
//         TICK;
//         EXPECT_EQ(dut.o_MisalignedAccess, 0) << address;
//         EXPECT_EQ(dut.o_BadInstruction, 0) << address;
//         EXPECT_EQ_HEX(readWord(dut, address), 0xaaaaaaaa);
//     }

// }


// // TEST(Memory, WordAccess)
// // {
// //     Vmemory dut;
// //     dut.i_Clock = 0;
// //     dut.eval();

// //     // for (uint32_t address = 0; address < 16; address += 4) {
// //     for (uint32_t address = 4; address < 8; address += 4) {
// //         dut.memory__DOT__r_RAM[address][0] = 0xaa;
// //         dut.memory__DOT__r_RAM[address][1] = 0xaa;
// //         dut.memory__DOT__r_RAM[address][2] = 0xaa;
// //         dut.memory__DOT__r_RAM[address][3] = 0xaa;

// //         dut.i_Address = address;
// //         uint32_t registerValue = 0x12345600 | (address & 0xff);
// //         uint32_t storedValue = registerValue;
// //         uint32_t loadedValue = registerValue;



// //         // dut.i_Mode = SVDEF_LOAD_WORD;
// //         // dut.i_ReadEnable = 1;
// //         // dut.i_WriteEnable = 0;
// //         // dut.i_DataIn = 0xcccccccc;
// //         // TICK;
// //         // EXPECT_EQ_HEX(dut.o_DataOut, )

// //         dut.i_Mode = SVDEF_STORE_WORD;
// //         dut.i_ReadEnable = 0;
// //         dut.i_WriteEnable = 1;
// //         dut.i_DataIn = registerValue;
// //         TICK;
// //         EXPECT_EQ_HEX(dut.o_DataOut, storedValue) << address;
// //         EXPECT_EQ(dut.o_MisalignedAccess, 0) << address;
// //         EXPECT_EQ(dut.o_BadInstruction, 0) << address;

// //         dut.i_Mode = SVDEF_LOAD_WORD;
// //         dut.i_ReadEnable = 1;
// //         dut.i_WriteEnable = 0;
// //         dut.i_DataIn = 0xcccccccc;
// //         TICK;
// //         EXPECT_EQ_HEX(dut.o_DataOut, loadedValue) << address;
// //         EXPECT_EQ(dut.o_MisalignedAccess, 0) << address;
// //         EXPECT_EQ(dut.o_BadInstruction, 0) << address;
// //     }
// // }


// // TEST(Memory, HalfAccess)
// // {
// //     Vmemory dut;
// //     dut.i_Clock = 0;
// //     dut.i_ReadEnable = 1;
// //     dut.eval();

// //     for (uint32_t address = 0; address < 16; address += 2) {
// //         dut.memory__DOT__r_RAM[address][0] = 0xaa;
// //         dut.memory__DOT__r_RAM[address][1] = 0xaa;
// //         dut.memory__DOT__r_RAM[address][2] = 0xaa;
// //         dut.memory__DOT__r_RAM[address][3] = 0xaa;

// //         dut.i_Address = address;
// //         uint32_t value = 0x1200 | (address & 0xff);
// //         uint32_t storedValue = registerValue;
// //         uint32_t loadedValue = registerValue;



// //         dut.i_Mode = SVDEF_STORE_HALF;
// //         dut.i_WriteEnable = 1;
// //         dut.i_DataIn = value;
// //         TICK;
// //         EXPECT_EQ_HEX(dut.o_DataOut, value) << address;

// //         dut.i_Mode = SVDEF_LOAD_HALF_UNSIGNED;
// //         dut.i_WriteEnable = 0;
// //         dut.i_DataIn = 0xcccccccc;
// //         TICK;
// //         EXPECT_EQ_HEX(dut.o_DataOut, value) << address;
// //     }
// // }


// // TEST(Memory, ByteAccess)
// // {
// //     Vmemory dut;
// //     dut.i_Clock = 0;
// //     dut.i_ReadEnable = 1;
// //     dut.eval();

// //     for (uint32_t address = 0; address < 4; address += 1) {
// //         dut.i_Address = address;
// //         uint32_t value = (address & 0xff);

// //         dut.memory__DOT__r_RAM[address][0] = 0xcc;
// //         dut.memory__DOT__r_RAM[address][1] = 0xcc;
// //         dut.memory__DOT__r_RAM[address][2] = 0xcc;
// //         dut.memory__DOT__r_RAM[address][3] = 0xcc;

// //         dut.i_Mode = SVDEF_STORE_BYTE;
// //         dut.i_WriteEnable = 1;
// //         dut.i_DataIn = value;
// //         TICK;
// //         EXPECT_EQ_HEX(dut.o_DataOut, value) << address;

// //         dut.i_Mode = SVDEF_LOAD_BYTE_UNSIGNED;
// //         dut.i_WriteEnable = 0;
// //         dut.i_DataIn = 0xcccccccc;
// //         TICK;
// //         EXPECT_EQ_HEX(dut.o_DataOut, value) << address;
// //     }
// // }
