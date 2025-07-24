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

.equ STACK_SIZE, 0x8000

.section .init, "ax"
.align 3
.global init

init:
		.option norelax
		.cfi_startproc
		.cfi_undefined ra

.macro PPN, reg, pt
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

		sd \ppn, 0(t0)
.endm

		csrw sie, zero
		csrw sip, zero 

		PPN t2, L2_CODE 
		PTE_SET L3_KERNEL, KERNEL_BASE, 3, t2, PTE_VALID 

		PPN t2, KERNEL_BASE 
		PTE_SET L2_CODE, KERNEL_BASE, 2, t2, PTE_VALID | PTE_EXECUTE | PTE_READ | PTE_WRITE 

		PPN t2, L2_DATA 
		PTE_SET L3_KERNEL, DATA, 3, t2, PTE_VALID 

		PPN t2, DATA 
		PTE_SET L2_DATA, DATA, 2, t2, PTE_VALID | PTE_READ | PTE_WRITE 

		la a3, END  
		addi a3, a3, STACK_SIZE
		li a2, PAGE_SIZE 
		cssr a4, mhartid
		addi a4, a4, 1
		mul a2, a2, a4
		add a3, a3, a2

		PPN t2, L1_STACK 
		PTE_SET L2_DATA, a3, 2, t2, PTE_VALID 

		PPN t2, a3
		PTE_SET L1_STACK, a3, 1, t2, PTE_VALID | PTE_READ | PTE_WRITE 

		li t1, SATP_BITS 
		slli t1, t1, SATP_SHIFT 
		PPN t0, L3_KERNEL 
		or t0, t0, t1
		csrw satp, t0

		la sp, a3

		call main
		.cfi_endproc
spin:
		wfi
		j spin 

.macro DEFINE_PAGE, name

.align PAGE_SHIFT
\name:
.rep PAGE_SIZE
		.byte 0
.endr

.endm

DEFINE_PAGE L3_KERNEL
DEFINE_PAGE L2_CODE
DEFINE_PAGE L2_DATA
DEFINE_PAGE L1_STACK

