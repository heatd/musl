#ifndef _UCHAR_H
#define _UCHAR_H

#define __STDC_VERSION_UCHAR_H__ 202311L

#ifdef __cplusplus
extern "C" {
#endif

#if __cplusplus < 201103L
typedef unsigned short char16_t;
typedef unsigned char32_t;
#endif

#define __NEED_mbstate_t
#define __NEED_size_t

#include <features.h>
#include <bits/alltypes.h>

#if __STDC_VERSION__ >= 202311L
typedef unsigned char char8_t;
size_t c8rtomb(char *__restrict, char8_t, mbstate_t *__restrict);
size_t mbrtoc8(char8_t *__restrict, const char * __restrict, size_t, mbstate_t *__restrict);
#endif

size_t c16rtomb(char *__restrict, char16_t, mbstate_t *__restrict);
size_t mbrtoc16(char16_t *__restrict, const char *__restrict, size_t, mbstate_t *__restrict);

size_t c32rtomb(char *__restrict, char32_t, mbstate_t *__restrict);
size_t mbrtoc32(char32_t *__restrict, const char *__restrict, size_t, mbstate_t *__restrict);

#ifdef __cplusplus
}
#endif

#endif
