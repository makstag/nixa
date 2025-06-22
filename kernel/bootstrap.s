#include <riscv.h>

		.section .text.bootstrap, "ax"
		.align 3
		.global bootstrap

bootstrap:
		.cfi_startproc
		.cfi_undefined ra

		/* Zero-out BSS */
		la a4, bss_start
		la a5, bss_end
.Lbss_zero:
		sd zero, (a4)
		add a4, a4, PTR_SIZE
		blt a4, a5, .Lbss_zero

		/* Disable and clear all interrupts */
		csrw sie, zero
		csrw sip, zero

		

		.option push
		.option norelax
		la gp, global_pointer$
		.option pop

		la sp, stack_top

		.cfi_endproc
