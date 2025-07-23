#include <common.h>

OUTPUT_ARCH(riscv)
ENTRY(boot)

KERNEL_BASE = 0x80200000

SECTIONS
{
	. = KERNEL_BASE

	.pgtable:
	{
		*(.pgtable)
		PROVIDE(PGTABLE = .)
	}

	.text: ALIGN(PAGE_SIZE)
	{
		KEEP(*(.text.init))
		*(.text .text.*)
	}

	.rodata: ALIGN(PAGE_SIZE)
	{
		*(.rodata .rodata.*)
	}

	.data: ALIGN(PAGE_SIZE)
	{
		PROVIDE(DATA = .)
		*(.data .data.*)
	}

	.bss: ALIGN(PAGE_SIZE)
	{
		*(COMMON)
		*(.bss .bss.*)		
	}

	. = ALIGN(PAGE_SIZE)
	PROVIDE(END = .)
}
