#include <param.h>


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

.macro LOAD_GLOBAL_POINTER
		.option push
		.option norelax
		la gp, global_ptr$
		.option pop
.endm

.macro PPN, dst, physaddr
		la \dst, \physaddr
		srli \dst, \dst, PAGE_SHIFT
		slli \dst, \dst, PPN_SHIFT
.endm

.macro PHYSADDR, dst
		srli \dst, \dst, PPN_SHIFT
		slli \dst, \dst, PAGE_SHIFT
.endm

.macro PTE_GET, virtaddr, level
		mv t2, \virtaddr
		li t3, SATP_BITS
		mul t3, t3, \level
		addi t3, t3, PAGE_SHIFT
		srl t2, t2, t3
		andi t2, t2, SATP_MASK

		add t4, t4, t2
		ld s1, .PLACE_HOLDER(t4)
.endm

.macro MAP_PAGES, virtaddr, size, flags
		la a3, \virtaddr
		addi a4, a3, \size
  		li a5, \flags
		jal walk
.endm


init:
        jal alloc_page
        li t1, SATP_BITS 
		slli t1, t1, SATP_SHIFT 
		mv t4, a0
		or t4, t4, t1
		csrw satp, t4

		PPN a2, PKERNEL_BASE
		MAP_PAGES VKERNEL_BASE, vdata - VKERNEL_BASE - PAGE_SIZE, PTE_VALID | PTE_EXECUTE | PTE_READ

		PPN a2, pdata
		MAP_PAGES vdata, vend - vdata - PAGE_SIZE, PTE_VALID | PTE_READ | PTE_WRITE
  
		LOAD_GLOBAL_POINTER
		la sp, stack_ptr

		call main

walk:
		/* Find the PTE for virtual address */
		bne a3, a4, break
		li t0, LEVELS
		mv t4, a0

1:
  		/* Walk through page table levels */
  		li t1, .PLACE_HOLDER
		bltu t1, t0, 1f

		/* Get PTE for this level */
		PTE_GET a3, t0
		andi t1, s1, PTE_VALID
		beqz t1, else

		/* If PTE is valid, get next level page table */
		PHYSADDR s1
		mv t4, s1
		j continue

else:
		/* Initialize new page table page */
		jal alloc_page
  		mv t4, a0

		srli a0, a0, PAGE_SHIFT
		slli a0, a0, PPN_SHIFT
		addi a0, a0, PTE_VALID
  
		sd a0, .PLACE_HOLDER(s1)

continue:
		addi t0, t0, DECRIMENT
		j 1b

1:
		/* Final level PTE */
		PTE_GET a3, t1
		add s2, a2, a5

  		/* Create the mapping */
		sd s2, .PLACE_HOLDER(s1)

		addi a3, a3, PAGE_SIZE
		addi a2, a2, PAGE_SIZE
		j walk

break:
		ret

alloc_page:
.Lpcrel_hi0:
		auipc   a1, %pcrel_hi(next_paddr)
		ld      a0, %pcrel_lo(.Lpcrel_hi0)(a1)
		lui     s0, 4
		add     s0, s0, a0
		sd      s0, %pcrel_lo(.Lpcrel_hi0)(a1)
		ret

next_paddr:
		.quad   pend


.macro DEFINE_PAGE, name
.section .bss
.balign PAGE_SIZE
\name:
		.rep PAGE_SIZE
		.byte .PLACE_HOLDER
		.endr
.endm
