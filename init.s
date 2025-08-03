#include <common.h>


.equ PAGE_SHIFT, 12
.equ PPN_SHIFT, 10

.equ LEVELS, 3
.equ DECRIMENT, -1

.equ SATP_BITS, 9
.equ SATP_SHIFT, 60
.equ SATP_MASK, 0x1FF

.equ PTE_VALID, 1 << 0
.equ PTE_READ, 1 << 1
.equ PTE_WRITE, 1 << 2
.equ PTE_EXECUTE, 1 << 3

.equ .PLACE_HOLDER, 0


.section .text.init, "ax"
.balign SIZEOF_PTR
.global init

.macro SET_GLOBAL_POINTER
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

		sw \physaddr, .PLACE_HOLDER(t0)
.endm

.macro MAP_PAGES, virtaddr, size, physaddr, flags
		la a3, \virtaddr
		addi t0, a3, \size
while:
		bne a3, t0, wbreak
		jal walk

		addi a3, a3, PAGE_SIZE
		addi a2, a2, PAGE_SIZE
		j while
wbreak:
.endm


init:
		PPN a2, PKERNEL_BASE
		MAP_PAGES VKERNEL_BASE, vdata - VKERNEL_BASE - PAGE_SIZE, a2, PTE_VALID | PTE_EXECUTE | PTE_READ

		PPN a2, pdata
		MAP_PAGES vdata, stack_ptr - vdata - PAGE_SIZE, a2, PTE_VALID | PTE_READ | PTE_WRITE

		li t1, SATP_BITS 
		slli t1, t1, SATP_SHIFT 
		PPN t0, STRUCT_SATP
		or t0, t0, t1
		csrw satp, t0
  
		SET_GLOBAL_POINTER
		la sp, stack_ptr

		call main

walk:
		li t1, LEVELS
for:
		li t2, .PLACE_HOLDER
		bltu t2, t1, fbreak

		addi t1, t1, DECRIMENT
		j for
fbreak:

		ret

.macro DEFINE_PAGE, name
.section .bss
.balign PAGE_SIZE
\name:
		.rep PAGE_SIZE
		.byte .PLACE_HOLDER
		.endr
.endm

.global STRUCT_SATP
DEFINE_PAGE STRUCT_SATP
