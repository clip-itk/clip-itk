/*
	Copyright (C) 2001  ITK
	Authors  : Uri Hnykin <uri@itk.ru>, Paul Lasarev <paul@itk.ru>, Sergey Rosenfeld <serg@itk.ru>
	License : (GPL) http://www.itk.ru/clipper/license.html
*/
/*
   $Log$
   Revision 1.1  2006/06/22 19:01:29  itk
   uri: initial

   Revision 1.12  2005/08/08 09:00:30  clip
   alena: fix for gcc 4

   Revision 1.11  2003/09/02 14:27:41  clip
   changes for MINGW from
   Mauricio Abre <maurifull@datafull.com>
   paul

   Revision 1.10  2003/07/03 07:15:55  clip
   fix a lot of warnings
   paul

   Revision 1.9  2003/01/23 12:08:51  clip
   uri: added getACP() for unix.

   Revision 1.8  2002/11/12 12:01:09  clip
   uri: small fix

   Revision 1.7  2002/11/12 11:57:04  clip
   uri: small fix for cygwin

   Revision 1.6  2002/10/15 08:39:01  clip
   X clipboard support (use external program xclip)
   Closes #30
   paul

   Revision 1.5  2002/09/12 08:40:07  clip
   uri: added isClipboardAvailable()
    nType parameter for:
     setClipboardData(sData [,nType])
     getClipboardData([,nType])

   Revision 1.4  2002/09/11 10:38:38  clip
   uri: clipBoard functions.

   Revision 1.1  2002/09/11 09:08:39  clip
   uri: sorry, forgot to add the file.


*/

#include <string.h>
#include <stdlib.h>
#include "clip.h"
#include "error.ch"

#ifdef _WIN32
	#ifdef OS_CYGWIN  /* MingW port automatically #includes <windows.h> */
		#include <w32api/windows.h>
	#endif
#else
	#include <unistd.h>
	#include "clipbrd.ch"
	static unsigned char * _clip_clipboard_data [CF_MAX];
	static unsigned char   _clip_clipboard_len  [CF_MAX];
#endif



#ifdef _WIN32
static char *
from_clipboard(int nType, int* len)
{
	char * ret;

	*len = 0;

	if (nType <= 0)
		nType = CF_TEXT;

	if (OpenClipboard(0))
	{
		HANDLE  hmem;
		LPVOID  mem;

		hmem = GetClipboardData(nType);

		if (hmem)
		{
			mem = GlobalLock(hmem);

			*len = strlen(mem);
			ret = malloc((*len)+1);
			memcpy(ret,mem,(*len));
			ret[(*len)] = 0;

			GlobalUnlock(hmem);
		}
		else
		{
			ret = malloc(1);
			ret[0] = 0;
		}
		CloseClipboard();
	}
	else
	{
		ret = malloc(1);
		ret[0] = 0;
	}
	return ret;
}
#else
static unsigned char *
from_clipboard(int nType, int * len)
{
	int xterm_clipboard_present = 0;
	unsigned char * ret = 0;
	/* xterm detecting */
	char path[256], *s;


	*len = 0;
	if (nType <= 0)
		nType = CF_TEXT;

	if (nType >= CF_MAX)
		return NULL;

	s = getenv("DISPLAY");
	if (s && *s)
	{
		snprintf(path, sizeof(path), "%s/bin/xclip", CLIPROOT);
		if (!access(path, X_OK))
		{
			snprintf(path, sizeof(path), "%s/bin/xclip -o", CLIPROOT);
			xterm_clipboard_present = 1;
		}
		if (!xterm_clipboard_present)
		{
			snprintf(path, sizeof(path), "/usr/bin/xclip");
			if (!access(path, X_OK))
			{
				snprintf(path, sizeof(path), "/usr/bin/xclip -o");
				xterm_clipboard_present = 1;
			}
		}
	}

	if (xterm_clipboard_present)
	{
		FILE *f = popen(path, "r");
		if (f)
		{
			int r, l, d;
			l = 0;
			d = 128;

			for(;;)
			{
				ret = realloc(ret, l + d);
				r = fread(ret + l, 1, d, f);
				if (r <= 0)
					break;
				l += r;
			}
			pclose(f);
			ret = realloc(ret, l + 1);
			ret[l] = 0;
			*len = l;
		}
		else
		{
			ret = malloc(1);
			ret[0] = 0;
		}
	}
	else
	{
		if ( _clip_clipboard_data[nType] == NULL )
		{
			ret = malloc(1);
			ret[0] = 0;
		}
		else
		{
			*len = _clip_clipboard_len[nType];
			ret = malloc((*len)+1);
			memcpy(ret,_clip_clipboard_data[nType],(*len)+1);
		}
	}
	return ret;
}
#endif

#ifdef _WIN32
static int
to_clipboard(const unsigned char * data, int nType, int len)
{
	HANDLE  hmem;
	unsigned char *mem;

	if (! OpenClipboard(0) )
		return 0;

	if (nType <= 0)
		nType = CF_TEXT;

	hmem = GlobalAlloc(GMEM_MOVEABLE | GMEM_DDESHARE, len+1);
	mem = GlobalLock(hmem);

	memcpy(mem,data,len+1);

	GlobalUnlock(hmem);

	EmptyClipboard();
	SetClipboardData(nType, hmem);

	CloseClipboard();
	return 1;
}
#else
static int
to_clipboard(const unsigned char * data, int nType, int len)
{
	int xterm_clipboard_present = 0;
	char path[256], *s;

	if (nType <= 0)
		nType = CF_TEXT;

	if (nType >= CF_MAX)
		return 0;

	/* xterm detecting */
	s = getenv("DISPLAY");
	if (s && *s)
	{
		snprintf(path, sizeof(path), "%s/bin/xclip", CLIPROOT);
		if (!access(path, X_OK))
		{
			snprintf(path, sizeof(path), "%s/bin/xclip -i", CLIPROOT);
			xterm_clipboard_present = 1;
		}
		if (!xterm_clipboard_present)
		{
			snprintf(path, sizeof(path), "/usr/bin/xclip");
			if (!access(path, X_OK))
			{
				snprintf(path, sizeof(path), "/usr/bin/xclip -i");
				xterm_clipboard_present = 1;
			}
		}
	}

	if (xterm_clipboard_present)
	{
		FILE *f = popen(path, "w");
		if (f)
		{
			int r, l, d;
			l = 0;
			d = len;

			while(l < d)
			{
				r = fwrite(data + l, 1, d - l, f);
				if (r <= 0)
					break;
				l += r;
			}
			pclose(f);
		}

		return 1;
	}


	if ( _clip_clipboard_data[nType] != NULL )
		free(_clip_clipboard_data[nType]);
	_clip_clipboard_data[nType] = malloc(len+1);
	_clip_clipboard_len [nType] = len;
	memcpy(_clip_clipboard_data[nType],data,len+1);
	return 1;
}
#endif


int
clip_GETCLIPBOARDDATA(ClipMachine * mp)
{
	int len;
	char * data = (char *)from_clipboard( _clip_parni(mp,1), &len );
	_clip_retcn_m(mp,data,len);
	return 0;
}

int
clip_SETCLIPBOARDDATA(ClipMachine * mp)
{
	int len;
	char * data = _clip_parcl(mp,1,&len);
	if ( data == NULL )
		_clip_retl(mp,0);
	else
		_clip_retl(mp,to_clipboard((const unsigned char *)data,_clip_parni(mp,2),len));

	return 0;
}

#ifdef _WIN32
int
clip_ISCLIPBOARDFORMATAVAILABLE(ClipMachine * mp)
{
	_clip_retl(mp, IsClipboardFormatAvailable(_clip_parni(mp,1)));
	return 0;
}
#else
int
clip_ISCLIPBOARDFORMATAVAILABLE(ClipMachine * mp)
{
	int f=_clip_parni(mp,1);
	_clip_retl(mp, f > 0 && f < CF_MAX );
	return 0;
}
#endif

#ifdef _WIN32
static unsigned char *
_clip_win_cp(int who)
{
	int cp_num = 0;
	unsigned char * buf;
	switch (who)
	{
		case 1:
			cp_num = GetConsoleCP();
			break;
		case 2:
			cp_num = GetACP();
			break;
		case 3:
			cp_num = GetOEMCP();
			break;
		case 4:
			cp_num = GetConsoleOutputCP();
			break;
	}
	buf = malloc(10);
	snprintf(buf,10,"cp%d",cp_num);
	return buf;
}


int
clip_GETCONSOLECP(ClipMachine * mp)
{
	char * s = _clip_win_cp(1);
	_clip_retcn_m(mp,s,strlen(s));
	return 0;
}
int
clip_GETANSICP(ClipMachine * mp)
{
	char * s = _clip_win_cp(2);
	_clip_retcn_m(mp,s,strlen(s));
	return 0;
}
int
clip_GETACP(ClipMachine * mp)
{
	return clip_GETANSICP(mp);
}
int
clip_GETOEMCP(ClipMachine * mp)
{
	char * s = _clip_win_cp(3);
	_clip_retcn_m(mp,s,strlen(s));
	return 0;
}

int
clip_GETCONSOLEOUTPUTCP(ClipMachine * mp)
{
	char * s = _clip_win_cp(4);
	_clip_retcn_m(mp,s,strlen(s));
	return 0;
}

#else

int
clip_GETCONSOLECP(ClipMachine * mp)
{
	_clip_retc(mp,_clip_getenv("CLIP_CLIENTCS"));
	return 0;
}
int
clip_GETANSICP(ClipMachine * mp)
{
	_clip_retc(mp,_clip_hostcs);
	return 0;
}
int
clip_GETACP(ClipMachine * mp)
{
	return clip_GETANSICP(mp);
}
int
clip_GETOEMCP(ClipMachine * mp)
{
	_clip_retc(mp,_clip_hostcs);
	return 0;
}
int
clip_GETCONSOLEOUTPUTCP(ClipMachine * mp)
{
	_clip_retc(mp,_clip_getenv("CLIP_CLIENTCS"));
	return 0;
}
#endif

