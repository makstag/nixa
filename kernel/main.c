#define va_list __builtin_va_list
#define va_start __builtin_va_start
#define va_end __builtin_va_end
#define va_arg __builtin_va_arg

struct sbiret
{
    long error;
    long value;
};

struct sbiret sbi_call(unsigned long arg0, unsigned long arg1, unsigned long arg2, unsigned long arg3,
                       unsigned long arg4, unsigned long arg5, unsigned long fid, unsigned long eid)
{
    register long a0 __asm__("a0") = arg0;
    register long a1 __asm__("a1") = arg1;
    register long a2 __asm__("a2") = arg2;
    register long a3 __asm__("a3") = arg3;
    register long a4 __asm__("a4") = arg4;
    register long a5 __asm__("a5") = arg5;
    register long a6 __asm__("a6") = fid;
    register long a7 __asm__("a7") = eid;

    __asm__ __volatile__("ecall"
                         : "=r"(a0), "=r"(a1)
                         : "r"(a0), "r"(a1), "r"(a2), "r"(a3), "r"(a4), "r"(a5), "r"(a6), "r"(a7)
                         : "memory");
    return (struct sbiret){.error = a0, .value = a1};
}

void putchar(char ch)
{
    sbi_call(ch, 0, 0, 0, 0, 0, 0, 1 /* Console Putchar */);
}

void printf(const char* fmt, ...)
{
    va_list vargs;
    va_start(vargs, fmt);

    while (*fmt)
    {
        if (*fmt == '%')
        {
            fmt++; // Skip '%'
            switch (*fmt)
            {          // Считываем следующий символ
            case '\0': // '%' в конце строки формата.
                putchar('%');
                goto end;
            case '%': // Выводим '%'
                putchar('%');
                break;
            case 's': { // Выводим NULL-терминированную строку.
                const char* s = va_arg(vargs, const char*);
                while (*s)
                {
                    putchar(*s);
                    s++;
                }
                break;
            }
            case 'd': { // Выводим целое число в десятичном формате.
                int value = va_arg(vargs, int);
                if (value < 0)
                {
                    putchar('-');
                    value = -value;
                }

                int divisor = 1;
                while (value / divisor > 9)
                    divisor *= 10;

                while (divisor > 0)
                {
                    putchar('0' + value / divisor);
                    value %= divisor;
                    divisor /= 10;
                }

                break;
            }
            case 'x': { // Выводим целое число в шестнадцатеричном формате.
                int value = va_arg(vargs, int);
                for (int i = 7; i >= 0; i--)
                {
                    int nibble = (value >> (i * 4)) & 0xf;
                    putchar("0123456789abcdef"[nibble]);
                }
            }
            }
        }
        else
        {
            putchar(*fmt);
        }

        fmt++;
    }

end:
    va_end(vargs);
}

__attribute__((naked)) void main()
{
    printf("%x\n", &a1);
}
