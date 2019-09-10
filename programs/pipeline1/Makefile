# TODO: Use CMake instead

RISCV=$(HOME)/riscv-toolchain
TOOLCHAIN=riscv32-unknown-elf

AS=$(RISCV)/bin/$(TOOLCHAIN)-as
CC=$(RISCV)/bin/$(TOOLCHAIN)-gcc
LD=$(RISCV)/bin/$(TOOLCHAIN)-ld
OBJDUMP=$(RISCV)/bin/$(TOOLCHAIN)-objdump
OBJCOPY=$(RISCV)/bin/$(TOOLCHAIN)-objcopy

ARCH_FLAGS=-march=rv32i -mabi=ilp32
ASFLAGS=--warn $(ARCH_FLAGS)
CFLAGS=-std=gnu11 -Wall -Wextra -Werror -pedantic $(ARCH_FLAGS) -O0 -ffreestanding
LDFLAGS= \
	-T linker.ld \
	--format elf32-littleriscv \
	-L$(RISCV)/lib/gcc/$(TOOLCHAIN)/9.2.0
LDLIBS= -lgcc


all: pipeline1.bin


pipeline1.bin: pipeline1.elf
	$(OBJCOPY) -O binary $^ $@
	xxd -e $@ > $@.txt


pipeline1.elf: pipeline1.o
	$(LD) $(LDFLAGS) -o $@ $^ $(LDLIBS)
	$(OBJDUMP) -d $@ > pipeline1.s


pipeline1.o: pipeline1.asm
	$(AS) $(ASFLAGS) $< -o $@


.PHONY: clean
clean:
	rm -f *.o *.elf *.bin *.s
