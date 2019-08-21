
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
