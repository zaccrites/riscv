
# RISC-V CPU Core

A pipelined RV32I CPU core


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


## RISC-V GCC Toolchain

### Ubuntu

    sudo apt install -y git autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev

### MacOS

    brew install gawk gnu-sed gmp mpfr libmpc isl zlib expat

Other stuff I had to do to get it to build...

* See https://stackoverflow.com/a/50072446. homebrew claimed to install
  version 4.0.2 of mpfr, but didn't supply a `libmpfr.4.dylib` to link against.

### Windows

    TODO


## Vivado

TODO



# Building

Run these commands to set up the CMake build:

    git clone git@gitlab.com:zaccrites/riscv.git

    python3 -m riscv-venv riscv-venv
    source riscv-venv/bin/activate
    pip install -r riscv/requirements.txt

    cmake -S riscv -B riscv-build -G Ninja
    ninja -C riscv-build


Run the simulator test suite:

    riscv-build/tests/unit_tests


To run the simulator on a program:

    TODO

    riscv-build/simulator/simulator


To generate a bitstream and run on an FPGA:

    TODO


