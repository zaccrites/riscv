


#include <stdint.h>
#include <iostream>
#include <sstream>   // std::stringstream
#include <iomanip>   // std::setw
#include <fstream>
#include <vector>

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

    // // Load a program
    // // TODO: Load from file passed in on command line
    // uint32_t programInstructions[] = {
    //     // 0000000000000000 <_start>:
    //     /*   0:  */   0x01c000ef,  //            jal ra,1c <main>
    //     /*   4:  */   0x00200513,  //            li  a0,2
    //     /*   8:  */   0x00000073,  //            ecall
    //     /*   c:  */   0x00000013,  //            nop
    //     /*  10:  */   0x00000013,  //            nop
    //     /*  14:  */   0x00000013,  //            nop
    //     /*  18:  */   0x0000006f,  //            j   18 <_start+0x18>

    //     // 000000000000001c <main>:
    //       1c:   00a00413            li  s0,10
    //       20:   00000493            li  s1,0
    //       24:   00100913            li  s2,1

    //     // 0000000000000028 <.loop>:
    //       28:   00100513            li  a0,1
    //       2c:   00090593            mv  a1,s2
    //       30:   00048293            mv  t0,s1
    //       34:   00090493            mv  s1,s2
    //       38:   00548933            add s2,s1,t0
    //       3c:   fff40413            addi    s0,s0,-1
    //       40:   fe0414e3            bnez    s0,28 <.loop>
    //       44:   00008067            ret
    // };
    // // memcpy(cpu.cpu__DOT__instruction_memory__DOT__r_RAM, programInstructions, sizeof(programInstructions));

    // TODO: Use #defines for these internal Verilator signal references
    // pProgramMemory[0] = programInstructions[0];
    // pProgramMemory[1] = programInstructions[1];
    // pProgramMemory[2] = programInstructions[2];



    // https://stackoverflow.com/questions/15138785/how-to-read-a-file-into-vector-in-c
    std::ifstream fs {"/home/zac/riscv/programs/test_samples/factorial.bin", std::ios::binary};  // TODO: cmd line args
    // std::istream_iterator<uint32_t> start { fs };
    // std::vector<uint32_t> programInstructions { start, {} };
    std::vector<uint32_t> programInstructions;
    if (fs.is_open())
    {
        // I understand this is not idiomatic C++, but the "right"
        // answer isn't working for me at all.
        while (true)
        {
            // I'll need to repeat this for .data segments as well.
            // I can either try to parse ELF or HEX files, or just
            // keep track of the "address" and start pushing to data
            // memory instead. The linker script can relocate
            // .data to the appropriate place.
            uint32_t instructionWord;
            fs.read(reinterpret_cast<char*>(&instructionWord), sizeof(instructionWord));

            if (fs.eof()) break;
            programInstructions.push_back(instructionWord);
        }
    }
    else
    {
        std::cerr << "Failed to open file!" << std::endl;
        return 1;
    }
    std::cout << "Read " << programInstructions.size() << " instructions from binary file." << std::endl;
    std::copy(std::begin(programInstructions), std::end(programInstructions), std::begin(cpu.cpu__DOT__instruction_memory__DOT__r_RAM));

    for (uint32_t i = 0; i < programInstructions.size() + 4; i++) {
        std::stringstream ss;
        ss << std::hex << std::setfill('0') <<
            "program_memory[" << std::setw(2) << i*4 << "h] = " <<
            "0x" << std::setw(8) << cpu.cpu__DOT__instruction_memory__DOT__r_RAM[i] << std::endl;
        std::cout << ss.str();
    }

    // return 0;


    bool programRunning = true;
    while (programRunning)
    {
        //

        // uint32_t address = cpu.o_InstructionPointer;
        // if (address > 30 * 4) {
        //     std::cerr << "Got to address " << std::hex << address << ", aborting" << std::endl;
        //     break;
        // }

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
                    // "  x0  (zero) = 0x" << std::hex << std::setfill('0') << std::setw(8) << 0 << "\n"
                    "  x1  (ra  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[0] << "\n"
                    // "  x2  (sp  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[1] << "\n"
                    // "  x3  (gp  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[2] << "\n"
                    // "  x4  (tp  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[3] << "\n"
                    // "  x5  (t0  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[4] << "\n"
                    // "  x6  (t1  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[5] << "\n"
                    // "  x7  (t2  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[6] << "\n"
                    "  x8  (s0  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[7] << "\n"
                    // "  x9  (s1  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[8] << "\n"
                    "  x10 (a0  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[9] << "\n"
                    // "  x11 (a1  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[10] << "\n"
                    // "  x12 (a2  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[11] << "\n"
                    // "  x13 (a3  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[12] << "\n"
                    // "  x14 (a4  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[13] << "\n"
                    // "  x15 (a5  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[14] << "\n"
                    // "  x16 (a6  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[15] << "\n"
                    // "  x17 (a7  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[16] << "\n"
                    // "  x18 (s2  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[17] << "\n"
                    // "  x19 (s3  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[18] << "\n"
                    // "  x20 (s4  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[19] << "\n"
                    // "  x21 (s5  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[20] << "\n"
                    // "  x22 (s6  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[21] << "\n"
                    // "  x23 (s7  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[22] << "\n"
                    // "  x24 (s8  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[23] << "\n"
                    // "  x25 (s9  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[24] << "\n"
                    // "  x26 (s10 ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[25] << "\n"
                    // "  x27 (s11 ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[26] << "\n"
                    // "  x28 (t3  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[27] << "\n"
                    // "  x29 (t4  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[28] << "\n"
                    // "  x30 (t5  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[29] << "\n"
                    // "  x31 (t6  ) = 0x" << std::hex << std::setfill('0') << std::setw(8) << cpu.cpu__DOT__registers__DOT__r_Registers[30] << "\n"
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

            }

        }
        else
        {
            // std::cout << std::hex << "At address " << address << std::endl;
        }

    }

    return 0;
}
