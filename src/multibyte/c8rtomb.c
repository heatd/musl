#undef __STDC_VERSION__
#define __STDC_VERSION__ 202311L
#include <uchar.h>
#include <errno.h>
#include <wchar.h>
#include "internal.h"

#if __STDC_VERSION < 202311L
typedef unsigned char char8_t;
#endif

size_t c8rtomb(char *__restrict s, char8_t c8, mbstate_t *__restrict ps)
{
    static unsigned internal_state;
	if (!ps) ps = (void *)&internal_state;
	unsigned *x = (unsigned *)ps;

    // If !s, c8rtomb = c8rtomb(internal_buf, '\0', ps).
    if (!s || !c8)
    {
        *x = 0;
        // If we were passed a buffer, store '\0' like we promise.
        if (s) *s = 0;
        return 1;
    }

    if (!CURRENT_UTF8 && c8 >= 0x80)
        return errno = EILSEQ, (size_t) -1;

    *s = c8;
    return 1;
}
