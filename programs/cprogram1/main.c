
#include "runtime.h"

// int global1;
// int global2 = 100;

// const char* mystring = "Hello World!";


// int myfunc(int x)
// {
//     global1 += global2 + strlen(mystring);
//     return x + global1;
// }


// int main(int argc, char** argv)
// {
    // (void)argv;
    // (void)argc;
    // global2 += f(argc);
    // return myfunc(global2);

int main(int argc, char** argv)
{
    (void)argv;
    return 4 + argc;
}