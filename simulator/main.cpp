


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



const uint32_t TEXT_SECTION_SIZE { 32 * 1024 };
const uint32_t DATA_SECTION_SIZE { 32 * 1024 };


class Simulator
{
public:

    Simulator() :
        m_Cpu {}
    {
    }

    void tick()
    {
        m_Cpu.i_Clock = 1;
        m_Cpu.eval();
        m_Cpu.i_Clock = 0;
        m_Cpu.eval();
    }

    void reset()
    {
        m_Cpu.i_Reset = 1;
        tick();
        m_Cpu.i_Reset = 0;
    }

    // uint8_t readByte(uint32_t address) const
    // {
    //     // if (address > TEXT_SECTION_SIZE)

    //     // return cpu.cpu__DOT__if__DOT__icache__DOT__r_RAM[]
    // }

    // uint32_t readWord(uint32_t address) const
    // {

    // }

    // void writeByte(uint32_t address, uint8_t value)
    // {

    // }

    // void writeWord(uint32_t address, uint32_t value)
    // {

    // }


    uint32_t getProgramCounter() const
    {
        // return m_Cpu.cpu__DOT__stage_IF__DOT__pc__DOT__r_PC;
        return m_Cpu.o_PC;
    }

    uint32_t getInstructionWord() const
    {
        return m_Cpu.o_InstructionWord;
    }

    uint32_t getRegister(uint8_t id) const
    {
        // The ID is one-based (since x0 is always zero), but x1 as at
        // entry 0 in the simulator's register array.
        if (id == 0) return 0;
        return m_Cpu.cpu__DOT__stage_ID__DOT__registers__DOT__r_Registers[(id % 32) - 1];
    }


    bool loadImage(const char* path)
    {

        std::ifstream fs {path, std::ios::binary};  // TODO: cmd line args
        if ( ! fs.is_open()) return false;

        uint32_t address = 0;
        while (true)
        {
            uint32_t word;
            fs.read(reinterpret_cast<char*>(&word), sizeof(word));
            if (fs.eof()) break;

            if (address < TEXT_SECTION_SIZE / 4)
            {
                m_Cpu.cpu__DOT__stage_IF__DOT__icache__DOT__r_RAM[address / 4] = word;
                address += 4;
            }
            else
            {
                // TODO: Populate data memory too
                break;
            }
        }

        // printf("Read %d program instruction words")


        return true;
    }





private:

    void handleSyscall();

    Vcpu m_Cpu;


};








int main(int argc, char** argv)
{
    // TODO: Parse arguments to load program
    (void)argc;
    (void)argv;

    Simulator simulator;
    // if ( ! simulator.loadImage("/home/zac/riscv/programs/cprogram1/cprogram1.bin"))
    if ( ! simulator.loadImage("/home/zac/riscv/programs/pipeline1/pipeline1.bin"))
    {
        std::cerr << "Failed to load image!" << std::endl;
        return 1;
    }
    simulator.reset();


    // NOTE: Branching still not implemented!
    uint32_t clock = 0;
    while (true)
    {
        if (simulator.getProgramCounter() / 4 > 50)
        {
            break;
        }

        printf(
            "%04d | pc = %08x [word = %08x] | x1 = %08x | x2 = %08x \n",
            clock,
            simulator.getProgramCounter(),
            simulator.getInstructionWord(),
            simulator.getRegister(1),
            simulator.getRegister(2)
        );
        // printf("============================================ \n");
        simulator.tick();
        // printf("============================================ \n");
        // printf("\n\n");


        clock += 1;

    }

    return 0;
}
