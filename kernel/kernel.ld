#include <common.h>

#define KERNEL_BASE 0x80200000

#define STACK_SIZE  8192
#define REGISTER_SIZE 8

OUTPUT_ARCH(riscv)
ENTRY(bootstrap)

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
