
# RISC-V CPU Core

A single-cycle RV32I CPU core


# Getting Started

## Simulator

You'll need these tools to run the simulator:

    sudo apt install build-essential verilator cmake ninja-build python3-venv

Then run these commands to set up the CMake build:

    cd /home/zac
    python3 -m venv venv
    source venv/bin/activate
    cd riscv
    pip install -r requirements.txt
    cmake -B ../riscv-build -G Ninja

Then start the build:

    ninja -C ../riscv-build


## Vivado

TODO
