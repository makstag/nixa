#!/bin/zsh
set -xue
make
QEMU=qemu-system-riscv64

$QEMU -machine virt -m 128M -bios default -nographic -serial mon:stdio --no-reboot \
	-kernel test
