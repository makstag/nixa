#include <common.h>

OUTPUT_ARCH(riscv)
ENTRY(init)

KERNEL_BASE = 0x80200000
INIT_BASE = 0x100000
HALF_PAGE = 0x800

SECTIONS
{
	. = KERNEL_BASE
	HIDDEN(OFFSET = KERNEL_BASE - INIT_BASE)

	.init.text: AT(ADDR(.init.text) - OFFSET)
	{
		KEEP(*(.init))
		PROVIDE(einit = ABSOLUTE(.))
	}

	.text ALIGN(PAGE_SIZE):
	{
		*(.text .text.*)
	}

	.rodata ALIGN(PAGE_SIZE):
	{
		*(.rodata .rodata.*)
	}

	.data ALIGN(PAGE_SIZE):
	{
		PROVIDE(data = .)
		PROVIDE(global_pointer$ = . + HALF_PAGE)
		*(.data .data.*)
	}

	.bss ALIGN(PAGE_SIZE):
	{
		*(COMMON)
		*(.bss .bss.*)		
	}

	. = ALIGN(PAGE_SIZE)
	PROVIDE(ekernel = .)
}
