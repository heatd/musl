#ifndef _INTERNAL_SYS_MUSL_DEFS_H
#define _INTERNAL_SYS_MUSL_DEFS_H

/* Macro to convert pointers to void * - works due to ?:'s type conversion rules
 * It is used extensively in C23 generics for const-preserving conversions
 */
#define __cvvp(P) (1 ? (P) : (void *) 0)

#endif
