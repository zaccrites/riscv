#!/bin/bash

# https://github.com/riscv/riscv-gnu-toolchain/blob/master/README.md

if [[ $EUID -ne 0 ]]; then
    echo "Please run this script as root"
    exit 1
fi

set -e

pushd /tmp
if [ -d riscv-toolchain-install ]; then
    rm -rf riscv-toolchain-install
fi
mkdir riscv-toolchain-install
cd riscv-toolchain-install

git clone --recursive https://github.com/riscv/riscv-gnu-toolchain
cd riscv-gnu-toolchain

# Configure supported arch. Add M, A, etc. extensions as implemented.
# https://github.com/riscv/riscv-gnu-toolchain#installation-linux
./configure --prefix=/opt/riscv --with-arch=rv32i --with-abi=ilp32

make
