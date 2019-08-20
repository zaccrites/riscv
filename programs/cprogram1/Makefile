
# TODO: Use CMake instead

RISCV_BIN=/opt/riscv/bin
AS=$(RISCV_BIN)/riscv64-unknown-elf-as
CC=$(RISCV_BIN)/riscv64-unknown-elf-gcc
LD=$(RISCV_BIN)/riscv64-unknown-elf-ld
OBJDUMP=$(RISCV_BIN)/riscv64-unknown-elf-objdump
OBJCOPY=$(RISCV_BIN)/riscv64-unknown-elf-objcopy

ARCH_FLAGS=-march=rv32i -mabi=ilp32
ASFLAGS=--warn $(ARCH_FLAGS)
CFLAGS=-std=gnu11 -Wall -Wextra -Werror -pedantic $(ARCH_FLAGS) -O0 -ffreestanding
LDFLAGS=-T linker.ld --format elf32-littleriscv


all: cprogram1.bin


cprogram1.bin: cprogram1.elf
	$(OBJCOPY) -O binary $^ $@


cprogram1.elf: startup.o runtime.o main.o utils.o
	$(LD) $(LDFLAGS) $^ -o $@
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
