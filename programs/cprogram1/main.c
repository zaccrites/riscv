
#include <stddef.h>

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



int factorial(int n)
{
    int result;
    if (n <= 1) result = 1;
    else result = n * factorial(n - 1);
    printnum(result);
    return result;
}


int main()
{

    const char* my_str = "Hello World!";
    printstr(my_str);

    // printnum(factorial(5));
    // printnum(factorial(3));
    printnum(factorial(5));

    return 0;
}
