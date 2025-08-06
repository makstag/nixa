#inclue "common.h"

void* memset(void* s, int c, uint64 count)
{
    char* xs = s;

    while (count--)
        *xs++ = c;
    return s;
}
