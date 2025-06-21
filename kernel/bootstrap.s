#include <riscv.h>

		.section .text.bootstrap, "ax", %progbits
		.global bootstrap

bootstrap:
		.option push
		.option norelax
1:
		auipc ra, %pcrel_hi(1f)
		ld ra, %pcrel_lo(1b)(ra)
		jr ra
		.align 3
1:
		RISCV_PTR start
		.option pop

start:
		.option norelax
		.cfi_startproc
		.cfi_undefined ra



		.cfi_endproc
