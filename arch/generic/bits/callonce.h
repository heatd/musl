#ifndef CALL_ONCE_INIT
#define CALL_ONCE_INIT 0
typedef int once_flag;
void call_once(once_flag *, void (*)(void));
#endif
