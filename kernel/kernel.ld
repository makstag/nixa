#include <common.h>

OUTPUT_ARCH(riscv)
ENTRY(bootstrap)

KERNEL_BASE = 0x80200000

STACK_SIZE  = 8192
REGISTER_SIZE = 8

SECTIONS
{
	. = KERNEL_BASE

	.text:
	{
		KEEP(*(.text.bootstrap))
		*(.text .text.*)
	}

	.rodata: ALIGN(REGISTER_SIZE)
	{
		*(.rodata .rodata.*)
	}

	.data: ALIGN(REGISTER_SIZE)
	{
		*(.data .data.*)
	}

	.bss: ALIGN(REGISTER_SIZE)
	{
		*(COMMON)
		*(.bss .bss.*)		
	}

	. = ALIGN(PAGE_SIZE)
	. += STACK_SIZE
	PROVIDE(stack_top = .)

	. = ALIGN(PAGE_SIZE)
	PROVIDE(end = .)
}
