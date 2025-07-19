#include <common.h>

.equ PAGE_SHIFT, 12
.equ PPN_SHIFT, 10

.equ SATP_BITS, 9
.equ SATP_SHIFT, 60
.equ SATP_MASK, 0x1FF

.equ PTE_VALID, 1 << 0
.equ PTE_READ, 1 << 1
.equ PTE_WRITE, 1 << 2
.equ PTE_EXECUTE, 1 << 3

.section .text.boot, "ax"
.align 3
.global boot

boot:
		.option norelax
		.cfi_startproc
		.cfi_undefined ra

.macro PPM, reg, pt
		la \reg, \pt
		srli \reg, \reg, PAGE_SHIFT
.endm

.macro PTE_SET, pt, va, lvl, ppn, flags
		la t1, \va
		srli t1, t1, (PAGE_SHIFT + SATP_BITS * \lvl)
		andi t1, t1, SATP_MASK

		la t0, \pt
		add t0, t0, t1

		slli \ppn, \ppn, PPN_SHIFT
		addi \ppn, \ppn, \flags

		sw \ppn, 0(t0)
.endm



		.cfi_endproc

.macro DEFINE_PAGE, name

.align PAGE_SHIFT
\name:
.rep PAGE_SIZE
		.byte 0
.endr

.endm

DEFINE_PAGE root_table
