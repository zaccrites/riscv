
# RISC-V CPU Core

A single-cycle RV32I CPU core


# Getting Started

## Build and Simulation Tools

You'll need these tools to run the simulator:

### Ubuntu

    sudo apt install build-essential verilator cmake ninja-build python3-venv

### MacOS

    TODO

    brew install verilator cmake ninja

### Windows

    TODO

## Vivado

TODO


# Building

Then run these commands to set up the CMake build:

    git clone git@gitlab.com:zaccrites/riscv.git

    python3 -m riscv-venv riscv-venv
    source riscv-venv/bin/activate
    pip install -r riscv/requirements.txt

    cmake -S riscv -B riscv-build -G Ninja
    ninja -C riscv-build


To compile the RISC-V toolchain:

    TODO


Run the simulator test suite:

    riscv-build/tests/unit_tests


To run the simulator on a program:

    TODO


To generate a bitstream and run on an FPGA:

    TODO


