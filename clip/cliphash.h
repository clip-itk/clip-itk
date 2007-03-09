#ifndef CLIPHASH_H
#define CLIPHASH_H

#define CLIP_HASH_LONG
//#define CLIP_HASH_INT

#define clip_hash_t long

#ifdef CLIP_HASH_LONG
	#undef clip_hash_t
	#define clip_hash_t long
#endif
#ifdef CLIP_HASH_INT
	#undef clip_hash_t
	#define clip_hash_t int
#endif

clip_hash_t _clip_hashstr(const char *x);
clip_hash_t _clip_casehashstr(const char *x);
clip_hash_t _clip_hashbytes(long seed, const char *bytes, int len);
clip_hash_t _clip_casehashbytes(long seed, const char *bytes, int len);
clip_hash_t _clip_hashbytes16(long seed, const char *bytes, int len);
clip_hash_t _clip_hashbytes32(long seed, const char *bytes, int len);
/* trim head and tail spaces */
clip_hash_t _clip_hashword(const char *x, int l);
clip_hash_t _clip_casehashword(const char *x, int l);

#endif
