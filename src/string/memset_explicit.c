#include <string.h>

void *memset_explicit(void *ptr, int c, size_t n)
{
    memset(ptr, c, n);
    __asm__ __volatile__ ("" : : "r"(ptr) : "memory");
    return ptr;
}
