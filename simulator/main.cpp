


#include <stdint.h>
#include <iostream>
#include <sstream>   // std::stringstream
#include <iomanip>   // std::setw
#include <fstream>
#include <vector>
#include <random>

#include <algorithm>
#include <iterator>

#include "Vcpu.h"


#define TICK \
    cpu.i_Clock = 1; \
    cpu.eval(); \
    cpu.i_Clock = 0; \
    cpu.eval();

#define RESET \
    cpu.i_Reset = 1; \
    TICK; \
    cpu.i_Reset = 0;


int main(int argc, char** argv)
{
    // TODO: Parse arguments to load program
    (void)argc;
    (void)argv;

    // TODO: Wrap in class
    Vcpu cpu;
    // RESET;

    // TODO: Integrate this into the wrapper class, at least until
    // the cache is backed by a more standard RAM.
    // auto writeCpuMemory = [&cpu](uint32_t address, uint32_t value) {

    // };
    // auto readCpuMemory = [cpu](uint32_t address) -> uint32_t {

    // }


    // https://stackoverflow.com/questions/15138785/how-to-read-a-file-into-vector-in-c

    std::ifstream fs {"/home/zac/riscv/programs/cprogram1/cprogram1.bin", std::ios::binary};  // TODO: cmd line args
    // std::ifstream fs {"/Users/zaccrites/Code/riscv/programs/cprogram1/cprogram1.bin", std::ios::binary};  // TODO: cmd line args

    // std::istream_iterator<uint32_t> start { fs };
    // std::vector<uint32_t> programInstructions { start, {} };
    if (fs.is_open())
    {
        // Randomize data memory before start.
        // TODO: Randomize unassigned instruction memory too
        // std::random_device dev;
        // std::mt19937 rng(dev());
        // std::uniform_int_distribution<uint8_t> dist(0, 0xffffffff);
        // for (size_t address = 0; address < 0x8000; address++)
        // {
        //     cpu.cpu__DOT__instruction_memory__DOT__r_RAM[address][0] = dist(rng);
        //     cpu.cpu__DOT__instruction_memory__DOT__r_RAM[address][1] = dist(rng);
        //     cpu.cpu__DOT__instruction_memory__DOT__r_RAM[address][2] = dist(rng);
        //     cpu.cpu__DOT__instruction_memory__DOT__r_RAM[address][3] = dist(rng);
        // }

        // I understand this is not idiomatic C++, but the "right"
        // answer isn't working for me at all.
        size_t address = 0;
        while (true)
        {
            // I'll need to repeat this for .data segments as well.
            // I can either try to parse ELF or HEX files, or just
            // keep track of the "address" and start pushing to data
            // memory instead. The linker script can relocate
            // .data to the appropriate place.
            uint32_t word;
            fs.read(reinterpret_cast<char*>(&word), sizeof(word));

            if (fs.eof())
            {
                break;
            }

            if (address < 0x8000/4)
            {
                cpu.cpu__DOT__instruction_memory__DOT__r_RAM[address][0] = static_cast<uint8_t>(word);
                cpu.cpu__DOT__instruction_memory__DOT__r_RAM[address][1] = static_cast<uint8_t>(word >> 8);
                cpu.cpu__DOT__instruction_memory__DOT__r_RAM[address][2] = static_cast<uint8_t>(word >> 16);
                cpu.cpu__DOT__instruction_memory__DOT__r_RAM[address][3] = static_cast<uint8_t>(word >> 24);
            }
            else
            {
                std::cout << std::hex << word << std::endl;
                cpu.cpu__DOT__data_memory__DOT__r_RAM[address - 0x8000/4][0] = static_cast<uint8_t>(word);
                cpu.cpu__DOT__data_memory__DOT__r_RAM[address - 0x8000/4][1] = static_cast<uint8_t>(word >> 8);
                cpu.cpu__DOT__data_memory__DOT__r_RAM[address - 0x8000/4][2] = static_cast<uint8_t>(word >> 16);
                cpu.cpu__DOT__data_memory__DOT__r_RAM[address - 0x8000/4][3] = static_cast<uint8_t>(word >> 24);
            }

            address += 1;
        }
        std::cout << "Read " << (address + 1) << " instructions from binary file." << std::endl;

    }
    else
    {
        std::cerr << "Failed to open file!" << std::endl;
        return 1;
    }




    bool programRunning = true;
    while (programRunning)
    {
        TICK;

        if (cpu.o_Syscall)
        {
            // Get syscall number from a0 (and param from a1)
            uint32_t syscallNumber = cpu.cpu__DOT__registers__DOT__r_Registers[9];
            uint32_t syscallParam = cpu.cpu__DOT__registers__DOT__r_Registers[10];

            switch (syscallNumber)
            {
            case 0:
                // syscall 0: print registers
                //
                // TODO: Use EBREAK instruction for this
                std::cout << "Registers:\n" <<
                    "  x0  (zero) = 0x" << std::hex << std::setfill('0') << std::setw(8) << 0 << "\n"
                    "  x1  (ra  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[0] << "\n"
                    "  x2  (sp  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[1] << "\n"
                    "  x3  (gp  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[2] << "\n"
                    "  x4  (tp  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[3] << "\n"
                    "  x5  (t0  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[4] << "\n"
                    "  x6  (t1  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[5] << "\n"
                    "  x7  (t2  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[6] << "\n"
                    "  x8  (s0  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[7] << "\n"
                    "  x9  (s1  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[8] << "\n"
                    "  x10 (a0  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[9] << "\n"
                    "  x11 (a1  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[10] << "\n"
                    "  x12 (a2  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[11] << "\n"
                    "  x13 (a3  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[12] << "\n"
                    "  x14 (a4  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[13] << "\n"
                    "  x15 (a5  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[14] << "\n"
                    "  x16 (a6  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[15] << "\n"
                    "  x17 (a7  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[16] << "\n"
                    "  x18 (s2  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[17] << "\n"
                    "  x19 (s3  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[18] << "\n"
                    "  x20 (s4  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[19] << "\n"
                    "  x21 (s5  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[20] << "\n"
                    "  x22 (s6  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[21] << "\n"
                    "  x23 (s7  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[22] << "\n"
                    "  x24 (s8  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[23] << "\n"
                    "  x25 (s9  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[24] << "\n"
                    "  x26 (s10 ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[25] << "\n"
                    "  x27 (s11 ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[26] << "\n"
                    "  x28 (t3  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[27] << "\n"
                    "  x29 (t4  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[28] << "\n"
                    "  x30 (t5  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[29] << "\n"
                    "  x31 (t6  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[30] << "\n"
                    << std::endl;
                break;

            case 1:
                // syscall 1: print number in a1
                //
                std::cout << std::dec << std::setw(0) << syscallParam << std::endl;
                break;

            case 2:
                // syscall 2: end the program
                programRunning = false;
                break;

            case 3:
            {
                // syscall 3: print a string
                char buffer[512];

                int i = 0;
                while (true)
                {
                    uint32_t address = syscallParam/4 + (i / 4) - 0x8000/4;
                    std::cout << std::hex << "syscallParam = " << syscallParam << "  | address = " << address << std::endl;
                    char c = cpu.cpu__DOT__data_memory__DOT__r_RAM[address][i % 4];

                    if (c == '\0') break;
                    else if (i == sizeof(buffer) - 1) break;
                    buffer[i++] = c;
                }
                buffer[i] = '\0';

                std::cout << buffer << std::endl;
            }
            break;

            default:
                std::cout << "Unknown syscall number " << std::dec << syscallNumber << std::endl;
                break;

            }

        }

    }

    return 0;
}
