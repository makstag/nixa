#ifndef COMMON_H
#define COMMON_H

typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int uint32;
typedef unsigned long uint64;

#define PAGE_SIZE 4096
#define SIZEOF_PTR 8

#define true 1
#define false 0

#define NULL ((void*)0)

void* memset(void* s, int c, uint64 count);
#endif /* COMMON_H */
