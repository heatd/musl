#include <time.h>

/* TIME_UTC, TIME_MONOTONIC, etc are all defined as being greater than 0 by the spec,
 * so make TIME_ defines match with POSIX ones (with a +1 offset as CLOCK_REALTIME = 0 and TIME_UTC > 0)
 */

/* The largest clock that we implement is {TIME, CLOCK}_TAI */
#define TIME_MAX (TIME_TAI + 1)

clockid_t __c23_get_clock(int base)
{
    if (base == 0 || base >= TIME_MAX)
        return -1;
    return base - 1;
}
