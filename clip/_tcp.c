#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/time.h>
#include <errno.h>
#include <netdb.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <sys/socket.h>

#include "clipcfg.h"
#include "clip.h"
#include "hashcode.h"
#include "error.ch"
#include "fileio.ch"

/*****************************/
static int ipaddr2charptr(const char * addr, unsigned char* buf, int lenbuf)
{
	int ret=0;
        const char * beg, * end;
        for ( beg=addr, end=addr; (*end) != 0; end++)
        {
        	if ( (*end) == '.' )
                {
			buf[ret] = (unsigned char) atoi(beg);
                        end++;
                        beg = end;
                        ret++;
                }
                if ( ret >= lenbuf )
                	break;
        }
        if (beg!=end)
        {
		buf[ret] = (unsigned char) atoi(beg);
        	ret++;
        }
        return ret;
}
/*****************************/
static char * charptr2ipaddr(const unsigned char * addr, int len, char *c_format)
{
        char * buf;
        char format[20];
        char *cur;
        int i;
        buf = malloc(100);
        memset(buf,0,100);
        sprintf(format,"%s%s%s","%",c_format,"d.");
        for (i=0; i<len; i++)
        {
        	cur = buf+strlen(buf);
                sprintf(cur,format,(int)addr[i]);
        }
        if (i > 0 )
        	buf[strlen(buf)-1] = 0;
        return buf;
}

/*****************************/
static unsigned long inet_addr(const char *s)
{
	 unsigned long b1,b2,b3,b4;
	 int nf=sscanf(s, "%lu%*[.]%lu%*[.]%lu%*[.]%lu", &b1, &b2, &b3, &b4);

	 if ( nf == 4 )
	 {
	      return  ( (b4 << 24) & 0xff000000)
		    | ( (b3 << 16) & 0xff0000)
		    | ( (b2 << 8)  & 0xff00)
		    | ( b1 & 0xff) ;
	 }
	 else
	 {
		struct sockaddr_in sin;
		struct hostent *hp = gethostbyname(s);
		if (!hp)
			return 0xffffffff;

		if (hp->h_addrtype!=AF_INET)
			return 0xffffffff;

	      #if defined(h_addr)	/* In 4.3, this is a #define */
		memcpy((caddr_t)&sin.sin_addr, hp->h_addr_list[0], hp->h_length);
	      #else
		memcpy((caddr_t)&sin.sin_addr, hp->h_addr, hp->h_length);
	      #endif
	      return sin.sin_addr.s_addr;
	  }
}
/*****************************/
static const char * inet_host_name(const char *s)
{
         unsigned char buf[10];
	 struct hostent *hp;

	 int nf=ipaddr2charptr(s,buf,sizeof(buf)-1);

	 if ( nf >= 4 )
		hp = gethostbyaddr(buf,nf,AF_INET);
	 else
		hp = gethostbyname(s);

	 if (!hp)
		return "";

	 if (hp->h_addrtype!=AF_INET)
		return "";

	 return hp->h_name;
}

/*****************************/
int
clip_GETHOSTBYNAME(ClipMachine *mp)
{
	char * addr = _clip_parc(mp,1);
	char * c_format = _clip_parc(mp,2);
        char * ret;
        char buf[10];
        unsigned long n;

        if ( addr == NULL || *addr==0 )
        {
        	_clip_retc(mp,"");
                return 0;
        }

        n=inet_addr(addr);
        if (n == 0xFFFFFFFF )
        {
        	_clip_retc(mp,"");
                return 0;
        }

        if ( c_format == NULL )
        	c_format = "03";

        buf[0] = (n & 0xFF);
        buf[1] = ((n >> 8) & 0xFF);
        buf[2] = ((n >> 16) & 0xFF);
        buf[3] = ((n >> 24) & 0xFF);

        ret = charptr2ipaddr(buf,4,c_format);
        _clip_retc(mp,ret);
        free(ret);

	return 0;
}

/*****************************/
int
clip_GETHOSTBYADDR(ClipMachine *mp)
{
	char * addr = _clip_parc(mp,1);
        if ( addr == NULL || *addr==0 )
        {
        	_clip_retc(mp,"");
                return 0;
        }
        _clip_retc(mp,(char *)inet_host_name(addr));
	return 0;
}

/*****************************/
int
clip_IPADDR2BIN(ClipMachine *mp)
{
	char * addr = _clip_parc(mp,1);
        unsigned char buf[10];
        int nf;
        if ( addr == NULL || *addr==0 )
        {
        	_clip_retc(mp,"");
                return 0;
        }
        nf=ipaddr2charptr(addr,buf,sizeof(buf)-1);
        _clip_retcn(mp,buf,nf);
        return 0;
}

/*****************************/
int
clip_BIN2IPADDR(ClipMachine *mp)
{
	int len;
	char * addr = _clip_parcl(mp,1,&len);
	char * c_format = _clip_parc(mp,2);
        char *ret;
        if ( addr == NULL || *addr==0 )
        {
        	_clip_retc(mp,"");
                return 0;
        }
        if ( c_format == NULL )
        	c_format = "03";
        ret=charptr2ipaddr(addr,len,c_format);
        _clip_retc(mp,ret);
        free(ret);
        return 0;
}
/*****************************/
int
clip_TCPCONNECT(ClipMachine *mp)
{
	C_FILE *cf = NULL;
	struct sockaddr_in sin;
	long timeout = 60000;
	int sock=-1, *err=NULL;
	int arg=0,ret;
	struct timeval tv;

	char *addr  = _clip_parc(mp,1);
	char *sport = _clip_parc(mp,2);
	long port    = _clip_parnl(mp,2);
	err = _clip_fetch_item(mp, HASH_ferror);
	*err=0;

	_clip_retni(mp,-1);
	if ( _clip_parinfo(mp,0) < 2 )
	{
		*err = errno;
		return 0;
	}

	if ( _clip_parinfo(mp,3)==NUMERIC_t )
		timeout = _clip_parnl(mp,3);
	tv.tv_sec = timeout / 1000;
	tv.tv_usec = (timeout % 1000) * 1000;

	sock = socket(AF_INET, SOCK_STREAM, 0);
	if (sock < 0)
	{
		*err = errno;
		return 0;
	}
/*
#if !defined(linux) && !defined(SOLARIS_26_X86)
	setsockopt( sock, SOL_SOCKET, SO_SNDTIMEO, (void *)&tv,  sizeof(tv) );
	setsockopt( sock, SOL_SOCKET, SO_RCVTIMEO, (void *)&tv,  sizeof(tv) );
#endif
*/
	arg = fcntl( sock, F_GETFL, arg );
	fcntl( sock, F_SETFL,  arg | O_NONBLOCK );

	sin.sin_family = AF_INET;
	sin.sin_addr.s_addr = inet_addr( addr );
	if (sin.sin_addr.s_addr == 0xffffffff)
	{
		*err=EFAULT;
		return 0;
	}
	sin.sin_port=0;
	if ( port > 0  )
		sin.sin_port = (int) htons ( (unsigned short) port ) ;
	else
	{
		struct servent *sp = getservbyname( (const char *) sport, "tcp");
		if ( sp!=NULL )
			sin.sin_port = sp->s_port;
	}
	if ( sin.sin_port == 0  )
	{
		*err=EINVAL;
		return 0;
	}

	errno=0;
	if ( connect( sock, (struct sockaddr *) & sin, sizeof(sin) )  )
	{
		int ret;
		fd_set set;
		if (errno!=EINPROGRESS)
		{
			*err=errno;
			return 0;
		}
		FD_ZERO( &set);
		FD_SET( sock, &set);
		//do  ret = select( FD_SETSIZE, &set, &set, NULL, &tv );
		do  ret = select( sock+1, &set, &set, NULL, &tv );
		while ( ret>0 && ! (FD_ISSET(sock, &set)) );
		if (ret==0)
		{
			*err = ETIMEDOUT;
			return 0;
		}
		if (ret<0)
		{
			*err = errno;
			return 0;
		}
	}
	else
	{
		*err = errno;
		return 0;
	}

	arg = fcntl( sock, F_GETFL, arg );
	fcntl( sock, F_SETFL,  arg | O_NONBLOCK );

	cf = (C_FILE *) calloc(1, sizeof(C_FILE));
        cf->f = NULL;
        cf->fileno = sock;
        cf->type = FT_SOCKET;
	ret = _clip_store_c_item(mp, cf, _C_ITEM_TYPE_FILE, NULL);

	_clip_retni(mp,ret);
	return 0;
}

int
clip_TCPREAD(ClipMachine *mp)
{
	int ret,lenbuf, *err=NULL;
	int fHandle   = _clip_parni(mp,1);
	char *buf     = _clip_parcl(mp,2,&lenbuf);
	long len      = _clip_parnl(mp,3);
	int timeout   = _clip_parni(mp,4);
	fd_set set;
	struct timeval tv;
	C_FILE *cf = _clip_fetch_c_item(mp, fHandle, _C_ITEM_TYPE_FILE);

        _clip_retni(mp,-1);
	if (cf == NULL || cf->fileno <=1 )
        	return 0;

        fHandle = cf->fileno;

	memset(buf,0,lenbuf);
	if ( timeout == 0 ) timeout=60000;
	if ( len<=0 || len>lenbuf) len=lenbuf;

	tv.tv_sec = timeout / 1000;
	tv.tv_usec = (timeout % 1000) * 1000;

	err = _clip_fetch_item(mp, HASH_ferror);
	*err = 0 ;

	FD_ZERO( &set);
	FD_SET( fHandle, &set);

	_clip_retni(mp,0);
	ret = select( fHandle+1, &set, 0, 0, &tv );
	if (ret<=0)
	{
		*err = errno;
		return 0;
	}

	ret = read(fHandle, buf, len);

	if (ret < 0 )
		*err = errno ;

	_clip_retnl(mp, ret);
	return 0;
}

int
clip_TCPWRITE(ClipMachine *mp)
{
	int ret,lenbuf, *err=NULL;
	int fHandle   = _clip_parni(mp,1);
	char *buf     = _clip_parcl(mp,2,&lenbuf);
	long len      = _clip_parnl(mp,3);
	int timeout   = _clip_parni(mp,4);
	fd_set set;
	struct timeval tv;

	C_FILE *cf = _clip_fetch_c_item(mp, fHandle, _C_ITEM_TYPE_FILE);

        _clip_retni(mp,-1);
	if (cf == NULL || cf->fileno <= 1 )
        	return 0;

        fHandle = cf->fileno;

	if ( timeout == 0 ) timeout=60000;
	if ( len<=0 || len>lenbuf) len=lenbuf;

	tv.tv_sec = timeout / 1000;
	tv.tv_usec = (timeout % 1000) * 1000;

	err = _clip_fetch_item(mp, HASH_ferror);
	*err = 0 ;

	FD_ZERO( &set);
	FD_SET( fHandle, &set);

	_clip_retni(mp,0);
	ret = select( fHandle+1, 0, &set, 0, &tv );
	if (ret<=0)
	{
		*err = errno;
		return 0;
	}

	ret = write(fHandle, buf, len);

	if (ret < 0 )
		*err = errno ;

	_clip_retnl(mp, ret);
	return 0;
}

int
clip_TCPCLOSE(ClipMachine *mp)
{
	int ret, *err=NULL;
	int fHandle,fd  = _clip_parni(mp,1);

	C_FILE *cf = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

        _clip_retni(mp,-1);
	if (cf == NULL || cf->fileno <= 1 )
        	return 0;

        fHandle = cf->fileno;

	err = _clip_fetch_item(mp, HASH_ferror);
	*err = 0 ;
	ret = close ( fHandle );
	_clip_destroy_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	if (ret != 0 )
		*err = errno ;

	_clip_retl(mp, ret==0 );
	return 0;
}

