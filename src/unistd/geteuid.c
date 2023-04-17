#include <unistd.h>
#include "syscall.h"

#include <uapi/cred.h>

uid_t geteuid(void)
{
	uid_t euid;
	int st = onx_get_uids(NULL, &euid, NULL);
	return st < 0 ? st : euid;
}
