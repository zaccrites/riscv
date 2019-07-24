

RISCV_BIN=/opt/riscv/bin
AS=$(RISCV_BIN)/riscv64-unknown-elf-as
CC=$(RISCV_BIN)/riscv64-unknown-elf-gcc
LD=$(RISCV_BIN)/riscv64-unknown-elf-ld
OBJDUMP=$(RISCV_BIN)/riscv64-unknown-elf-objdump
OBJCOPY=$(RISCV_BIN)/riscv64-unknown-elf-objcopy


all: factorial


factorial.bin: factorial.asm
	$(AS) factorial.asm -o factorial.o
	$(LD) factorial.o -o factorial.elf
	$(OBJDUMP) -d factorial.elf | tee factorial.s
	$(OBJCOPY) -O binary factorial.elf factorial.bin


.PHONY: clean
clean:
	rm -f *.o *.elf *.bin
