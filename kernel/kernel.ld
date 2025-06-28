#include <common.h>

#define LOAD 0x80200000

#define STACKSZ  8192
#define REGISTERSZ 8

OUTPUT_ARCH(riscv)
ENTRY(bootstrap)

SECTIONS
{
	. = LOAD

	.text:
	{
		KEEP(*(.text.bootstrap))
		*(.text .text.*)
	}

	.rodata: ALIGN(REGISTERSZ)
	{
		*(.rodata .rodata.*)
	}

	.data: ALIGN(REGISTERSZ)
	{
		*(.data .data.*)
	}

	.bss: ALIGN(REGISTERSZ)
	{
		*(COMMON)
		*(.bss .bss.*)		
	}

	. = ALIGN(PAGESZ)
	. += STACKSZ
	PROVIDE(stack_top = .)

	. = ALIGN(PAGESZ)
	PROVIDE(end = .)
}
