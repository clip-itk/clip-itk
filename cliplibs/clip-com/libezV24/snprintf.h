#ifndef __SNPRINTF_H__
#define __SNPRINTF_H__

int
#ifdef __STDC__
v24_snprintf(char *str, size_t n, char const *fmt, ...);
#else
v24_snprintf(str, n, fmt, va_alist);
#endif

#endif
