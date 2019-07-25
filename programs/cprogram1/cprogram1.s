
cprogram1.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00010117          	auipc	sp,0x10

00000004 <_sitext>:
   4:	ff010113          	addi	sp,sp,-16 # fff0 <_stack_start>
   8:	00300513          	li	a0,3
   c:	00000593          	li	a1,0
  10:	fe010113          	addi	sp,sp,-32
  14:	00812e23          	sw	s0,28(sp)
  18:	02010413          	addi	s0,sp,32
  1c:	fea42623          	sw	a0,-20(s0)
  20:	feb42423          	sw	a1,-24(s0)
  24:	fec42783          	lw	a5,-20(s0)
  28:	00050f93          	mv	t6,a0
  2c:	fec42f03          	lw	t5,-20(s0)
  30:	00000513          	li	a0,0
  34:	00000073          	ecall
  38:	00478793          	addi	a5,a5,4
  3c:	00078513          	mv	a0,a5
  40:	01c12403          	lw	s0,28(sp)
  44:	02010113          	addi	sp,sp,32
  48:	00200513          	li	a0,2
  4c:	00000073          	ecall

00000050 <main>:
  50:	fe010113          	addi	sp,sp,-32
  54:	00812e23          	sw	s0,28(sp)
  58:	02010413          	addi	s0,sp,32
  5c:	fea42623          	sw	a0,-20(s0)
  60:	feb42423          	sw	a1,-24(s0)
  64:	fec42783          	lw	a5,-20(s0)
  68:	00478793          	addi	a5,a5,4
  6c:	00078513          	mv	a0,a5
  70:	01c12403          	lw	s0,28(sp)
  74:	02010113          	addi	sp,sp,32
  78:	00008067          	ret
