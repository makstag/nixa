CROSS_COMPILE=riscv64-linux-gnu-

test: test.o test.ld
	${CROSS_COMPILE}ld -T test.ld --no-dynamic-linker -m elf64lriscv -static -nostdlib -s -o test test.o

test.o: test.s
	${CROSS_COMPILE}as -march=rv64i -mabi=lp64 -o test.o -c test.s
