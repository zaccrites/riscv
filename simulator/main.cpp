


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
    if ( ! simulator.loadImage("/home/zac/riscv/programs/cprogram1/cprogram1.bin"))
    {
        std::cerr << "Failed to load image!" << std::endl;
        return 1;
    }
    simulator.reset();


    while (true)
    {
        uint32_t pc = simulator.getProgramCounter();
        printf("pc = %08x \n", pc);

        if (pc > 4 * 10)
        {
            break;
        }

        simulator.tick();

    }

    return 0;
}
