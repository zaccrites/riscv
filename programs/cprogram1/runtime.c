
#include "runtime.h"


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


void printstr(const char* str)
{
    _write(str);
}
