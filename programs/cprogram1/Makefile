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


all: cprogram1.bin


cprogram1.bin: cprogram1.elf
	$(OBJCOPY) -O binary $^ $@


cprogram1.elf: startup.o runtime.o main.o utils.o
	$(LD) $(LDFLAGS) -o $@ $^ $(LDLIBS)
	$(OBJDUMP) -d $@ > cprogram1.s


main.o: main.c runtime.h
	$(CC) $(CFLAGS) -c $< -o $@

runtime.o: runtime.c runtime.h
	$(CC) $(CFLAGS) -c $< -o $@

startup.o: startup.asm
	$(AS) $(ASFLAGS) $< -o $@

utils.o: utils.asm
	$(AS) $(ASFLAGS) $< -o $@


.PHONY: clean
clean:
	rm -f *.o *.elf *.bin *.s
