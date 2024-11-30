#include <elf.h>
#include <poll.h>
#include <fcntl.h>
#include <signal.h>
#include <unistd.h>
#include "syscall.h"
#include "atomic.h"
#include "libc.h"

static void dummy(void) {}
weak_alias(dummy, _init);

extern weak hidden void (*const __init_array_start)(void), (*const __init_array_end)(void);

static void dummy1(void *p) {}
weak_alias(dummy1, __init_ssp);

#define AUX_CNT 38

#ifdef __x86_64__

#define __cpuid(__leaf, __eax, __ebx, __ecx, __edx) \
    __asm("  xchgq  %%rbx,%q1\n" \
          "  cpuid\n" \
          "  xchgq  %%rbx,%q1" \
        : "=a"(__eax), "=r" (__ebx), "=c"(__ecx), "=d"(__edx) \
        : "0"(__leaf))

#define __cpuid_count(__leaf, __count, __eax, __ebx, __ecx, __edx) \
    __asm("  xchgq  %%rbx,%q1\n" \
          "  cpuid\n" \
          "  xchgq  %%rbx,%q1" \
        : "=a"(__eax), "=r" (__ebx), "=c"(__ecx), "=d"(__edx) \
        : "0"(__leaf), "2"(__count))

static __inline int __get_cpuid_max (unsigned int __leaf, unsigned int *__sig)
{
    unsigned int __eax, __ebx, __ecx, __edx;
#if __i386__
    int __cpuid_supported;

    __asm("  pushfl\n"
          "  popl   %%eax\n"
          "  movl   %%eax,%%ecx\n"
          "  xorl   $0x00200000,%%eax\n"
          "  pushl  %%eax\n"
          "  popfl\n"
          "  pushfl\n"
          "  popl   %%eax\n"
          "  movl   $0,%0\n"
          "  cmpl   %%eax,%%ecx\n"
          "  je     1f\n"
          "  movl   $1,%0\n"
          "1:"
        : "=r" (__cpuid_supported) : : "eax", "ecx");
    if (!__cpuid_supported)
        return 0;
#endif

    __cpuid(__leaf, __eax, __ebx, __ecx, __edx);
    if (__sig)
        *__sig = __ebx;
    return __eax;
}

static __inline int __get_cpuid (unsigned int __leaf, unsigned int *__eax,
                                 unsigned int *__ebx, unsigned int *__ecx,
                                 unsigned int *__edx)
{
    unsigned int __max_leaf = __get_cpuid_max(__leaf & 0x80000000, 0);

    if (__max_leaf == 0 || __max_leaf < __leaf)
        return 0;

    __cpuid(__leaf, *__eax, *__ebx, *__ecx, *__edx);
    return 1;
}

static __inline int __get_cpuid_count (unsigned int __leaf,
                                       unsigned int __subleaf,
                                       unsigned int *__eax, unsigned int *__ebx,
                                       unsigned int *__ecx, unsigned int *__edx)
{
    unsigned int __max_leaf = __get_cpuid_max(__leaf & 0x80000000, 0);

    if (__max_leaf == 0 || __max_leaf < __leaf)
        return 0;

    __cpuid_count(__leaf, __subleaf, *__eax, *__ebx, *__ecx, *__edx);
    return 1;
}

extern unsigned int __has_avx;

void __init_x86_string(void)
{
	uint32_t eax = 0;
    uint32_t ebx = 0;
    uint32_t ecx = 0;
    uint32_t edx = 0;
	eax = 0x7;
    if (!__get_cpuid_count(0x7, 0, &eax, &ebx, &ecx, &edx))
		return;
	__has_avx = ebx & (1 << 5);
}

#endif

#ifdef __GNUC__
__attribute__((__noinline__))
#endif
void __init_libc(char **envp, char *pn)
{
	size_t i, *auxv, aux[AUX_CNT] = { 0 };
	__environ = envp;
	for (i=0; envp[i]; i++);
	libc.auxv = auxv = (void *)(envp+i+1);
	for (i=0; auxv[i]; i+=2) if (auxv[i]<AUX_CNT) aux[auxv[i]] = auxv[i+1];
	__hwcap = aux[AT_HWCAP];
	if (aux[AT_SYSINFO]) __sysinfo = aux[AT_SYSINFO];
	libc.page_size = aux[AT_PAGESZ];

	if (!pn) pn = (void*)aux[AT_EXECFN];
	if (!pn) pn = "";
	__progname = __progname_full = pn;
	for (i=0; pn[i]; i++) if (pn[i]=='/') __progname = pn+i+1;

	__init_tls(aux);
	__init_ssp((void *)aux[AT_RANDOM]);

#ifdef __x86_64__
	__init_x86_string();
#endif

	if (aux[AT_UID]==aux[AT_EUID] && aux[AT_GID]==aux[AT_EGID]
		&& !aux[AT_SECURE]) return;

	struct pollfd pfd[3] = { {.fd=0}, {.fd=1}, {.fd=2} };
	int r =
#ifdef SYS_poll
	__syscall(SYS_poll, pfd, 3, 0);
#else
	__syscall(SYS_ppoll, pfd, 3, &(struct timespec){0}, 0, _NSIG/8);
#endif
	if (r<0) a_crash();
	for (i=0; i<3; i++) if (pfd[i].revents&POLLNVAL)
		if (__sys_open("/dev/null", O_RDWR)<0)
			a_crash();
	libc.secure = 1;
}

static void libc_start_init(void)
{
	_init();
	uintptr_t a = (uintptr_t)&__init_array_start;
	for (; a<(uintptr_t)&__init_array_end; a+=sizeof(void(*)()))
		(*(void (**)(void))a)();
}

weak_alias(libc_start_init, __libc_start_init);

typedef int lsm2_fn(int (*)(int,char **,char **), int, char **);
static lsm2_fn libc_start_main_stage2;

int __libc_start_main(int (*main)(int,char **,char **), int argc, char **argv,
	void (*init_dummy)(), void(*fini_dummy)(), void(*ldso_dummy)())
{
	char **envp = argv+argc+1;

	/* External linkage, and explicit noinline attribute if available,
	 * are used to prevent the stack frame used during init from
	 * persisting for the entire process lifetime. */
	__init_libc(envp, argv[0]);

	/* Barrier against hoisting application code or anything using ssp
	 * or thread pointer prior to its initialization above. */
	lsm2_fn *stage2 = libc_start_main_stage2;
	__asm__ ( "" : "+r"(stage2) : : "memory" );
	return stage2(main, argc, argv);
}

static int libc_start_main_stage2(int (*main)(int,char **,char **), int argc, char **argv)
{
	char **envp = argv+argc+1;
	__libc_start_init();

	__vdso_init();

	/* Pass control to the application */
	exit(main(argc, argv, envp));
	return 0;
}
