
#include "runtime.h"
#include <stdbool.h>
#include <stdint.h>

// int f(int x)
// {
//     return x;
// }




// int strlen(const char* str)
// {
//     int length;
//     for (length = 0; *str != '\0'; length++);
//     return length;
// }




void _write(const char*);
void _writenum(int);
void _exit(void);


void printstr(const char* str)
{
    _write(str);
}

void printnum(int value)
{
    _writenum(value);
}

void exit(void)
{
    _exit();
}






// Until M extension is supported, I guess.
// https://gcc.gnu.org/onlinedocs/gcc-3.1/gccint/Library-Calls.html
int32_t __mulsi3(int32_t a, int32_t b)
{
    // This is probably extremely unoptimized.
    int result = 0;
    int counter = (b < 0) ? -b : b;
    while (counter)
    {
        result += a;
        counter -= 1;
    }

    return b < 0 ? -result : result;
}
