#include <riscv.h>

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

	. = ALIGN(PAGE_SIZE)

	.rodata:
	{
		*(.rodata .rodata.*)
	}

	. = ALIGN(PAGE_SIZE)

	.data:
	{
		*(.data .data.*)
	}

	. = ALIGN(PAGE_SIZE)

	.bss:
	{
		*(COMMON)
		*(.bss .bss.*)		
	}

	. = ALIGN(PAGE_SIZE)

	. += STACK_SIZE
	PROVIDE(stack_top = .)
}
