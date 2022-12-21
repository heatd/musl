#include <time.h>

int timespec_get(struct timespec * ts, int base)
{
	clockid_t id = __c23_get_clock(base);
    if (id < 0)
        return 0;
	int ret = __clock_gettime(id, ts);
	return ret < 0 ? 0 : base;
}
