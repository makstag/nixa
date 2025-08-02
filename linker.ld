#include <common.h>

OUTPUT_ARCH(riscv)
ENTRY(init)

INIT_BASE = 0x200000
KERNEL_BASE = 0x80200000

OFFSET = KERNEL_BASE - INIT_BASE

HALF_PAGE = 0x800
STACK_SIZE = 0x200000

SECTIONS
{
	. = KERNEL_BASE

	.text: AT(ADDR(.text) - OFFSET)
	{
		KEEP(*(.text.init))
		*(.text .text.*)
	}

	.rodata ALIGN(PAGE_SIZE): AT(ADDR(.rodata) - OFFSET)
	{
		PROVIDE(data = .)
		*(.rodata .rodata.*)
	}

	.data ALIGN(SIZEOF_PTR): AT(ADDR(.data) - OFFSET)
	{
		PROVIDE(global_ptr$ = . + HALF_PAGE)
		*(.data .data.*)
	}

	.bss ALIGN(SIZEOF_PTR): AT(ADDR(.bss) - OFFSET)
	{
		bss = . - OFFSET
		*(COMMON)
		*(.bss .bss.*)
		ebss = . - OFFSET
	}

	. = ALIGN(PAGE_SIZE)
	PROVIDE(stack_ptr = . + STACK_SIZE)
}
