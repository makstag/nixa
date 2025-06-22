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
		PROVIDE(global_pointer$ = . + OFFSET)
		*(.data .data.*)
	}

	. = ALIGN(PAGE_SIZE)

	.bss:
	{
		PROVIDE(bss_start = .)
		*(COMMON)
		*(.bss .bss.*)
		
		. = ALIGN(PTR_SIZE)
		PROVIDE(bss_end = .)
	}

	. = ALIGN(PAGE_SIZE)

	. += STACK_SIZE
	PROVIDE(stack_top = .)
}
