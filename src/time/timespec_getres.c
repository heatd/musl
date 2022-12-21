#include <time.h>

int timespec_getres(struct timespec *ts, int base)
{
    clockid_t id = __c23_get_clock(base);
    if (id < 0)
        return 0;
    return __clock_getres(id, ts) < 0 ? 0 : base;
}
