#include <param.h>

OUTPUT_ARCH(riscv)
ENTRY(init)

PKERNEL_BASE = 0x200000
VKERNEL_BASE = 0x80200000

OFFSET = VKERNEL_BASE - PKERNEL_BASE

HALF_PAGE = 0x800
STACK_SIZE = 0x200000

SECTIONS
{
	. = VKERNEL_BASE

	.text: AT(ADDR(.text) - OFFSET)
	{
		KEEP(*(.text.init))
		*(.text .text.*)
	}

	.rodata ALIGN(PAGE_SIZE): AT(ADDR(.rodata) - OFFSET)
	{
		PROVIDE(vdata = .)
		PROVIDE(pdata = . - OFFSET)
		*(.rodata .rodata.*)
	}

	.data ALIGN(SIZEOF_PTR): AT(ADDR(.data) - OFFSET)
	{
		PROVIDE(global_ptr$ = . + HALF_PAGE)
		*(.data .data.*)
	}

	.bss ALIGN(SIZEOF_PTR): AT(ADDR(.bss) - OFFSET)
	{
		*(COMMON)
		*(.bss .bss.*)
	}

	. = ALIGN(PAGE_SIZE)
	PROVIDE(stack_ptr = . + STACK_SIZE)
}
