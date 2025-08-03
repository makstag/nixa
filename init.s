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

.equ .FILL, 0


.section .text.init, "ax"
.balign SIZEOF_PTR
.global init

.macro GLOBAL_POINTER
		.option push
		.option norelax
		la gp, global_ptr$
		.option pop
.endm

.macro PPN, reg, physaddr
		la \reg, \physaddr
		srli \reg, \reg, PAGE_SHIFT
.endm

.macro PTE_SET, table, virtaddr, lvl, physaddr, flags
		la t1, \virtaddr
		srli t1, t1, (PAGE_SHIFT + SATP_BITS * \lvl)
		andi t1, t1, SATP_MASK

		la t0, \table
		add t0, t0, t1

		slli \physaddr, \physaddr, PPN_SHIFT
		addi \physaddr, \physaddr, \flags

		sw \physaddr, .FILL(t0)
.endm

.macro MAP_PAGES, table, virtaddr, size, physaddr, flags
		
.endm


init:
		PPN a2, INIT_BASE
		MAP_PAGES STRUCT_SATP, KERNEL_BASE, data - KERNEL_BASE, a2, PTE_VALID | PTE_EXECUTE | PTE_READ

		PPN a2, pdata
		MAP_PAGES STRUCT_SATP, data, stack_ptr - data, a2, PTE_VALID | PTE_READ | PTE_WRITE

		li t1, SATP_BITS 
		slli t1, t1, SATP_SHIFT 
		PPN t0, STRUCT_SATP
		or t0, t0, t1
		csrw satp, t0
  
		GLOBAL_POINTER
		la sp, stack_ptr

		call main


.macro DEFINE_PAGE, name
.section .bss
.balign PAGE_SIZE
\name:
		.rep PAGE_SIZE
		.byte .FILL
		.endr
.endm

.global STRUCT_SATP
DEFINE_PAGE STRUCT_SATP
