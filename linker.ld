#include <common.h>

OUTPUT_ARCH(riscv)
ENTRY(init)

INIT_BASE = 0x100000
KERNEL_BASE = 0x80200000
HALF_PAGE = 0x800
STACK_SIZE = 0x200000

SECTIONS
{
	. = KERNEL_BASE
	HIDDEN(OFFSET = KERNEL_BASE - INIT_BASE)

	.init.text: AT(ADDR(.init.text) - OFFSET)
	{
		KEEP(*(.init))
		einit = ABSOLUTE(.)
	}

	.text:
	{
		*(.text .text.*)
		. = ALIGN(PAGE_SIZE)
		PROVIDE(etext = .)
	}

	.rodata ALIGN(SIZEOF_PTR):
	{
		*(.rodata .rodata.*)
	}

	.data ALIGN(SIZEOF_PTR):
	{
		global_ptr$ = . + HALF_PAGE
		*(.data .data.*)
	}

	.bss ALIGN(SIZEOF_PTR):
	{
		bss = .
		*(COMMON)
		*(.bss .bss.*)
		. = ALIGN(SIZEOF_PTR)
		ebss = .
	}

	. = ALIGN(PAGE_SIZE)
	. += STACK_SIZE
	PROVIDE(stack_ptr = .)
}
