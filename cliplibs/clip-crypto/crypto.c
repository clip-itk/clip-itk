/*
   Copyright (C) 2001  ITK
   Authors  : Paul Lasarev <paul@itk.ru>
   License : (GPL) http://www.itk.ru/clipper/license.html
 */

/*
   $Log$
   Revision 1.1  2006/06/22 20:12:03  itk
   uri: init sf.net

   Revision 1.2  2005/08/09 08:54:37  clip
   alena: fix for gcc 4

   Revision 1.1  2001/12/25 07:03:46  clip
   symmetric block encrypton/decryption realised
   EVP_ENCRYPT,EVP_DECRYPT
   paul

 */

#include <errno.h>
#include <limits.h>
#include <string.h>

#include <openssl/evp.h>

#include "clip.h"
#include "error.ch"


#define BLOCK_SIZE 4096

static void
crypto_init(void)
{
	static int inited = 0;
	if (inited)
		return;

	OpenSSL_add_all_algorithms();

	inited = 1;
}

static int do_cipher(ClipMachine *mp, int operation);

static const char* alg_names[] =
{
#include "names.h"
0
};

int
clip_EVP_ALG_LIST(ClipMachine *mp)
{
	const char *s;
	int i, n;
	ClipVar *rp = RETPTR(mp), *ap;
	long vect[1];

	for(i=0, n=0; (s=alg_names[i]); i++, n++)
		;
	vect[0] = n;
	_clip_array(mp, rp, 1, vect);

	ap = _clip_vptr(rp);

	for(i=0; (s=alg_names[i]); i++)
	{
		ClipVar *vp;
		vp = ap->a.items + i;
		vp->t.type = CHARACTER_t;
		vp->s.str.buf = strdup(s);
		vp->s.str.len = strlen(s);
	}

	return 0;
}

/*
EVP_ENCRYPT(cStr, cKey [, [cMethod='des-ede3-cbc'] [, [cDigestMethod='md5'] [, [cInitVector='']]]]) --> cEncrypted
*/
int
clip_EVP_ENCRYPT(ClipMachine *mp)
{
	return do_cipher(mp, 1);
}

/*
EVP_DECRYPT(cStr, cKey [, [cMethod='des-ede3-cbc'] [, [cDigestMethod='md5'] [, [cInitVector='']]]]) --> cEncrypted
*/
int
clip_EVP_DECRYPT(ClipMachine *mp)
{
	return do_cipher(mp, 0);
}

static int
do_cipher(ClipMachine *mp, int operation)
{
	const EVP_CIPHER *cipher = 0;
	const EVP_MD *digest = 0;
	char *cipher_name, *digest_name;
	char *key_str, *data, *iv_str, *data_ptr;
	int key_len=0, data_len=0, iv_len=0;
	EVP_CIPHER_CTX ectx;
	unsigned char iv[EVP_MAX_IV_LENGTH];
	unsigned char key[EVP_MAX_KEY_LENGTH];
	char ebuf[BLOCK_SIZE + 8];
	unsigned int ebuflen;
	char *obuf = 0;
	unsigned int olen = 0;
	int l;

	crypto_init();

	if (mp->argc<2)
		return EG_ARG;

	cipher_name = _clip_parc(mp, 3);
	if (!cipher_name)
		cipher_name = "des-ede3-cbc";

	digest_name = _clip_parc(mp, 4);
	if (!digest_name)
		digest_name  = "md5";

	data = _clip_parcl(mp, 1, &data_len);
	if (!data)
		return EG_ARG;

	key_str = _clip_parcl(mp, 2, &key_len);
	if (!key_str)
		return EG_ARG;

	memset(iv, 0, sizeof(iv));
	memset(key, 0, sizeof(key));

	iv_str = _clip_parcl(mp, 5, &iv_len);
	if (iv_str)
	{
		if (iv_len>(int)sizeof(iv))
			iv_len = sizeof(iv);
		memcpy(iv, iv_str, iv_len);
	}

	cipher = EVP_get_cipherbyname(cipher_name);
	if (!cipher)
		return EG_ARG;

	digest = EVP_get_digestbyname(digest_name);
	if (!digest)
		return EG_ARG;


	EVP_BytesToKey(cipher, (EVP_MD*)digest, (const unsigned char *)"clip", (const unsigned char *)key_str, key_len, 1, key, iv);
	EVP_CipherInit(&ectx, cipher, key, iv, operation);

	for(l=0, data_ptr=data; l<data_len; )
	{
		int ll = data_len - l;

		if (ll > BLOCK_SIZE)
			ll = BLOCK_SIZE;

		ebuflen = sizeof(ebuf);
		EVP_CipherUpdate(&ectx, (unsigned char *)ebuf, (int *)&ebuflen, (unsigned char *)data_ptr, ll);

		obuf = (char*) realloc( obuf, olen + ebuflen);
		memcpy(obuf + olen, ebuf, ebuflen);
		olen += ebuflen;

		l += ll;
		data_ptr += ll;
	}

	EVP_CipherFinal(&ectx, (unsigned char *)ebuf, (int *)&ebuflen);

	obuf = (char*) realloc( obuf, olen + ebuflen + 1);
	memcpy(obuf + olen, ebuf, ebuflen);
	olen += ebuflen;
	obuf[olen] = 0;

	_clip_retcn_m(mp, obuf, olen);

	return 0;
}

