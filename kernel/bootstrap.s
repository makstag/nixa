#include <common.h>

		.section .text.bootstrap, "ax"
		.align 3
		.global bootstrap

bootstrap:
		.cfi_startproc
		.cfi_undefined ra

		/* Disable and clear all interrupts */
		csrw sie, zero
		csrw sip, zero



		la sp, stack_top

		.cfi_endproc
