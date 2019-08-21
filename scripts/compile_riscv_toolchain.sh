#!/bin/bash

# https://github.com/riscv/riscv-gnu-toolchain/blob/master/README.md

set -e

pushd "$HOME"
if [ -d riscv-toolchain-install ]; then
    rm -rf riscv-toolchain-install
fi
mkdir riscv-toolchain-install
cd riscv-toolchain-install

git clone --recursive https://github.com/riscv/riscv-gnu-toolchain
cd riscv-gnu-toolchain

# Configure supported arch. Add M, A, etc. extensions as implemented.
# https://github.com/riscv/riscv-gnu-toolchain#installation-linux
sh ./configure --prefix="$HOME/riscv-toolchain" --with-arch=rv32i --with-abi=ilp32
make
