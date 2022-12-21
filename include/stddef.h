#ifndef _STDDEF_H
#define _STDDEF_H

#define __STDC_VERSION_STDDEF_H__ 202311L

#if __cplusplus >= 201103L
#define NULL nullptr
#elif defined(__cplusplus)
#define NULL 0L
#else
#define NULL ((void*)0)
#endif

#define __NEED_ptrdiff_t
#define __NEED_size_t
#define __NEED_wchar_t
#if __STDC_VERSION__ >= 201112L || __cplusplus >= 201103L
#define __NEED_max_align_t
#endif

#include <bits/alltypes.h>

#if __GNUC__ > 3
#define offsetof(type, member) __builtin_offsetof(type, member)
#else
#define offsetof(type, member) ((size_t)( (char *)&(((type *)0)->member) - (char *)0 ))
#endif

#if __STDC_VERSION__ >= 202311L

// Unreachable macro - expands to a void expression that invokes UB if reached
#define unreachable() __builtin_unreachable()

#endif

#if __STDC_VERSION__ >= 202311L && !defined(__cplusplus)
typedef typeof(nullptr) nullptr_t;
#endif

#endif
