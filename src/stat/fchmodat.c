#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include "syscall.h"

int fchmodat(int fd, const char *path, mode_t mode, int flag)
{
	int ret = __syscall(SYS_fchmodat, fd, path, mode, flag);
	return __syscall_ret(ret);
}
