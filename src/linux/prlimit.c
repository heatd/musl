#define _GNU_SOURCE
#include <sys/resource.h>
#include "syscall.h"

int prlimit(pid_t pid, int resource, const struct rlimit *new, struct rlimit *old)
{
	return syscall(SYS_rlimit, pid, resource, old, new, 0);
}
