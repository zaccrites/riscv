#!/bin/bash

# https://github.com/riscv/riscv-gnu-toolchain/blob/master/README.md

if [[ $EUID -ne 0 ]]; then
    echo "Please run this script as root"
    exit 1
fi

set -e

apt-get install -y git autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev

pushd /tmp
if [ -d riscv-toolchain-install ]; then
    rm -rf riscv-toolchain-install
fi
mkdir riscv-toolchain-install
cd riscv-toolchain-install

git clone --recursive https://github.com/riscv/riscv-gnu-toolchain
cd riscv-gnu-toolchain
./configure --prefix=/opt/riscv
make
