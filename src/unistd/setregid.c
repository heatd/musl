#include <unistd.h>
#include "syscall.h"
#include "libc.h"

#include <uapi/cred.h>

int setregid(gid_t rgid, gid_t egid)
{
	return onx_set_gids(SET_GIDS_RGID_VALID | SET_GIDS_EGID_VALID, rgid, egid, -1);
}
