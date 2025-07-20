#include <common.h>

OUTPUT_ARCH(riscv)
ENTRY(boot)

KERNEL_BASE = 0x80200000

SECTIONS
{
	. = KERNEL_BASE

	.text:
	{
		KEEP(*(.text.boot))
		*(.text .text.*)
	}

	.rodata: ALIGN(PAGE_SIZE)
	{
		PROVIDE(DATA = .)
		*(.rodata .rodata.*)
	}

	.data: ALIGN(PAGE_SIZE)
	{
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
