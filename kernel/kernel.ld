OUTPUT_ARCH(riscv)
ENTRY(bootstrap)

OFFSET = 0x800
PAGE_SIZE = 0x1000
STACK_SIZE = 0x2000
KERNEL_START = 0x80200000

SECTIONS
{
	. = KERNEL_START

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
		*(COMMON)
		*(.bss .bss.*)
	}

	. = ALIGN(PAGE_SIZE)

	. += STACK_SIZE
	PROVIDE(stack_top = .)
}
