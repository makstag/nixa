#include <asm.h>

		.section .text.bootstrap, "ax"
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

		/* Zero-out BSS */
		lla a4, bss_start
		lla a5, bss_end
bss_zero:
		sd zero, (a4)
		add a4, a4, SIZEOF_PTR
		blt a4, a5, bss_zero

		/* Disable and clear all interrupts */
		csrw sie, zero
		csrw sip, zero

		.cfi_endproc
