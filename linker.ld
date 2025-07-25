#include <common.h>

OUTPUT_ARCH(riscv)
ENTRY(init)

KERNEL_BASE = 0x80200000
INIT_BASE = 0x100000
HALF_PAGE = 0x800
STACK_SIZE = 0x200000

SECTIONS
{
	. = INIT_BASE

	.init.text:
	{
		KEEP(*(.init))
		. = ALIGN(PAGE_SIZE)
		PROVIDE(einit = .)
	}
	
	. = KERNEL_BASE

	.text:
	{
		*(.text .text.*)
	}

	.rodata ALIGN(SIZEOF_PTR):
	{
		*(.rodata .rodata.*)
		. = ALIGN(PAGE_SIZE)
		PROVIDE(erodata = .)
	}

	.data:
	{
		PROVIDE(data = .)
		PROVIDE(global_ptr$ = . + HALF_PAGE)
		. = ALIGN(SIZEOF_PTR)
		*(.data .data.*)
	}

	.bss ALIGN(SIZEOF_PTR):
	{
		*(COMMON)
		*(.bss .bss.*)		
	}

	. = ALIGN(PAGE_SIZE)
	. += STACK_SIZE
	PROVIDE(stack_ptr = .)
}
