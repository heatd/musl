#include <dlfcn.h>
#include "dynlink.h"

static void *stub_fdlopen(int fd, int mode)
{
	__dl_seterr("Dynamic loading not supported");
	return 0;
}

weak_alias(stub_fdlopen, fdlopen);
