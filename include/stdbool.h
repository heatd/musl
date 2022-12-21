#ifndef _STDBOOL_H
#define _STDBOOL_H

#if __STDC_VERSION__ < 202311L || !defined(__cplusplus)

#define true 1
#define false 0
#define bool _Bool

#endif

#define __bool_true_false_are_defined 1

#endif
