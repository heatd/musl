#undef __STDC_VERSION__
#define __STDC_VERSION__ 202311L
#include <uchar.h>
#include <errno.h>
#include <wchar.h>
#include "internal.h"

#if __STDC_VERSION < 202311L
typedef unsigned char char8_t;
#endif

size_t mbrtoc8(char8_t *__restrict pc8, const char * __restrict s, size_t n, mbstate_t *__restrict ps)
{
    static unsigned internal_state;
	if (!ps) ps = (void *)&internal_state;
	unsigned *x = (unsigned *)ps;

    // If !s, mbrtoc8 = mbrtoc8(NULL, "", 1, ps).
    if (!pc8)
    {
        s = "";
        n = 1;
    }

    if (n > 0)
    {
        if (*s == '\0')
        {
            *pc8 = '\0';
            return 0;
        }

        *pc8 = *s;
        return 1;
    }

    return -2;
}
