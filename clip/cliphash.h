#ifndef CLIPHASH_H
#define CLIPHASH_H

long _clip_hashstr(const char *x);
long _clip_casehashstr(const char *x);
long _clip_hashbytes(long seed, const char *bytes, int len);
long _clip_casehashbytes(long seed, const char *bytes, int len);
/* trim head and tail spaces */
long _clip_hashword(const char *x, int l);
long _clip_casehashword(const char *x, int l);

#endif
