/*
   Copyright (C) 2002  ITK
   Authors  : Uri Hnykin <uri@itk.ru>, Przemyslaw <druzus@acn.waw.pl>
   License : (GPL) http://www.itk.ru/clipper/license.html
*/
/*
   $Log$
   Revision 1.1  2006/06/22 19:01:31  itk
   uri: initial

   Revision 1.35  2005/08/08 09:00:30  clip
   alena: fix for gcc 4

   Revision 1.34  2004/06/15 11:19:35  clip
   uri: small fix for Kamache

   Revision 1.33  2004/05/20 16:16:50  clip
   uri: add "mod-clip" and some fix in tcpclose()

   Revision 1.32  2004/05/19 08:32:18  clip
   rust: fix for ./configure -m

   Revision 1.31  2004/05/17 14:54:20  clip
   rust: select() before close() on blocking sockets (avoid TIME_WAIT at server)

   Revision 1.30  2004/05/12 10:31:44  clip
   uri: perrPort in tcpgetpeername()

   Revision 1.29  2004/02/16 09:56:03  clip
   uri: small fix in codb, _tcp.c (from Igor Satsyuk <satsyuk@tut.by>)

   Revision 1.29  2004/02/10 10:04  clip
   added function getpeername
   Igor Satsyuk <satsyuk@tut.by>
   igor

   Revision 1.28  2003/09/04 14:04:41  clip
   *** empty log message ***

   Revision 1.27  2003/09/04 13:05:54  clip
   *** empty log message ***

   Revision 1.26  2003/09/02 14:27:42  clip
   changes for MINGW from
   Mauricio Abre <maurifull@datafull.com>
   paul

   Revision 1.25  2003/04/21 12:48:04  clip
   uri: few fixes and new functions

   Revision 1.24  2003/03/17 08:24:59  clip
   Solaris 8 patches
   paul

   Revision 1.23  2003/02/16 10:30:00  clip
   uri: small fix from druzus about "errno"

   Revision 1.22  2003/02/15 12:49:24  clip
   uri: bad code "errno = XXX" changed to "*err = XXX"

   Revision 1.21  2003/02/15 12:35:35  clip
   uri: small fix for cygwin

   Revision 1.20  2003/02/15 11:55:28  clip
   uri: small fix for cygwin

   Revision 1.19  2003/02/14 09:02:50  clip
   uri: warning fix in UDP*()

   Revision 1.18  2003/02/12 12:35:40  clip
   UDP functions
   paul

   Revision 1.17  2002/11/13 07:50:10  clip
   test for utmp in configure
   asdf

   Revision 1.16  2002/10/24 10:53:40  clip
   uri: small fix

   Revision 1.15  2002/10/24 10:39:10  clip
   uri: small fix for freebsd:
*/

#include <string.h>
#include "clip.h"

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/time.h>
#include <errno.h>
#include <sys/types.h>
#ifndef OS_MINGW
	#include <netdb.h>
	#include <netinet/in.h>
	#include <arpa/inet.h>
	#include <sys/socket.h>
#endif

#include "clipcfg.h"
#include "hashcode.h"
#include "error.ch"
#include "fileio.ch"

#ifdef USE_UTMP
#  include <utmp.h>
#endif

#ifdef OS_CYGWIN
#define INET_ADDRSTRLEN  16
#endif

#ifndef INADDR_NONE
#define INADDR_NONE 0
#endif

#ifdef OS_SUNOS
static int
inet_aton(const char *host, struct in_addr *ina)
{
	in_addr_t a;
	a = inet_addr(host);
	if (((int)a) == -1 )
		return -1;

	ina->s_addr = a;

	return 0;
}

#endif

/* get host inetrnet address and store it in ina */
static int tcp_host_addr(const char *host, struct in_addr *ina)
{
	int ret = -1;

	if (host != NULL && *host != '\0')
	{
		/* gethostbyname in WinSock doesn't work with address in
		   standard numbers-and-dots notation so check for n&d first */
		if (inet_aton(host, ina) != 0)
			ret = 0;
		else
		{
			struct hostent *hp = gethostbyname(host);
			if (hp && hp->h_addrtype == AF_INET &&
				hp->h_addr_list != NULL &&
				hp->h_addr_list[0] != NULL)
			{
				memcpy(ina, hp->h_addr_list[0], hp->h_length);
				ret = 0;
			}
		}
	}

	if (ret == -1)
		ina->s_addr = INADDR_NONE;
	else if (ina->s_addr == INADDR_NONE)
		ret = -1;

	return ret;
}

/* get name of host pointed by host */
static const char * tcp_host_name(const char *host)
{
	struct in_addr ina;
	const char *ret = "";

	if (host != NULL && *host != '\0')
	{
		struct hostent *hp;

		if (inet_aton(host, &ina) != 0)
			hp = gethostbyaddr((const char *)&ina, sizeof(struct in_addr), AF_INET);
		else
			hp = gethostbyname(host);

		if (hp && hp->h_addrtype == AF_INET )
			ret = hp->h_name;
	}
	return ret;
}


/* try to detected remote terminal IP address */
static int tcp_term_addr(struct in_addr *ina)
{
	char *env_val, *ptr;
	int ret = -1;

	/* REMOTEHOST is set by telnetd */
	if ((env_val = getenv( "REMOTEHOST" )) != NULL &&
		tcp_host_addr(env_val, ina) == 0)
		ret = 0;

	/* SSH_CLIENT is set by sshd but some of
	   implementation doesn't 'export' it */
	if (ret == -1 && (env_val = getenv( "SSH_CLIENT" )) != NULL)
	{
		if ((ptr = strchr(env_val, ' ')) != NULL)
		*ptr = '\0';
		if (tcp_host_addr(env_val, ina) == 0)
		ret = 0;
	}

#ifdef USE_UTMP
	/* If we cannot find a proper address in environment we have
	   to check UTMP entries for our current terminal */
	if (ret == -1)
	{
		struct utmp entry, *ut;
		if ((ptr = ttyname( 0 ) ) != NULL)
		{
		if (strncmp( ptr, "/dev/", 5 ) == 0)
			ptr += 5;
		strcpy(entry.ut_line, ptr);
		setutent();
		if ((ut = getutline(&entry)) != NULL &&
			 ut->ut_addr != 0 && ut->ut_addr != INADDR_NONE &&
			 (ptr = inet_ntoa(*(struct in_addr*) &ut->ut_addr)) != NULL &&
			 tcp_host_addr(ptr, ina) == 0)
			ret=0;
		endutent();
		}
	}
#endif
	if (ret == -1)
		ina->s_addr = INADDR_NONE;
	return ret;
}

/*****************************/
int
clip_IPADDRTRANS(ClipMachine *mp)
{
	char *addr = _clip_parc(mp, 1), *cf = _clip_parc(mp, 2);
	char *ret = "", buf[100], tmpl[30];
	unsigned long b1, b2, b3, b4, nf;

	if (addr != NULL )
	{

		nf = sscanf(addr, "%lu%*[.]%lu%*[.]%lu%*[.]%lu",
				  &b1, &b2, &b3, &b4);
		if ( nf == 4 )
		{
			if (cf == NULL)
				cf = "";
			snprintf(tmpl, sizeof(tmpl),
				 "%%%sd.%%%sd.%%%sd.%%%sd", cf, cf, cf, cf);
			snprintf(buf, sizeof(buf), tmpl, b1, b2, b3, b4);
			ret = buf;
		}
	}

	_clip_retc(mp, ret);
	return 0;
}

/*****************************/
int
clip_IPADDR2BIN(ClipMachine *mp)
{
	char * addr = _clip_parc(mp, 1);
	struct in_addr ina;

	if (tcp_host_addr(addr, &ina) == 0)
		_clip_retcn(mp, (char *)&ina, sizeof(struct in_addr));
	else
		_clip_retc(mp, "");

	return 0;
}

/*****************************/
int
clip_BIN2IPADDR(ClipMachine *mp)
{
	int len;
	char *addr = _clip_parcl(mp, 1, &len);

	if (addr == NULL || len != sizeof(struct in_addr))
		_clip_retc(mp, "");
	else
		_clip_retc(mp, inet_ntoa( *(struct in_addr*)addr));

	return 0;
}

/*****************************/
int
clip_GETHOSTBYNAME(ClipMachine *mp)
{
	char *addr = _clip_parc(mp,1);
	struct in_addr ina;

	if (tcp_host_addr(addr, &ina) == 0)
		_clip_retc(mp, inet_ntoa(ina));
	else
		_clip_retc(mp, "");

	return 0;
}

/*****************************/
int
clip_GETHOSTBYADDR(ClipMachine *mp)
{
	char * addr = _clip_parc(mp, 1);

	if (addr == NULL || *addr == 0)
		_clip_retc(mp, "");
	else
		_clip_retc(mp, (char *) tcp_host_name(addr));

	return 0;
}

/*****************************/
int
clip_GETTERMADDR(ClipMachine *mp)
{
	struct in_addr ina;

	if (tcp_term_addr(&ina) == 0)
		_clip_retc(mp, inet_ntoa(ina));
	else
		_clip_retc(mp, "");

	return 0;
}
/*****************************/
int
clip_GETHOSTNAME(ClipMachine *mp)
{
	/* return host name of process */
	char buf[256];
	if ( gethostname(buf,255) != 0 )
		_clip_retc(mp, "");
	else
		_clip_retc(mp, buf);
	return 0;
}
/*****************************/
int
clip_GETDOMAINNAME(ClipMachine *mp)
{
	/* return host domain name of process */
	char buf[256];
#ifdef OS_MINGW
	DWORD s;
	GetComputerName(buf, &s);
#else
	if ( getdomainname(buf,255) != 0 )
		_clip_retc(mp, "");
	else
#endif
		_clip_retc(mp, buf);
	return 0;
}

/*****************************/
int
clip_TCPCONNECT(ClipMachine *mp)
{
	C_FILE *cf = NULL;
	struct sockaddr_in sin;
	long port = 0, timeout = 60000; /* maybe we should add _set_ for default timeout */
	int arg = 0, sock = -1, ret = -1, i;
	int *err = _clip_fetch_item(mp, HASH_ferror);
	struct timeval tv;
	char *addr  = _clip_parc(mp,1), *sport;

	*err=0;

	if (_clip_parinfo(mp,0) < 2 || _clip_parinfo(mp,1) != CHARACTER_t)
	{
		*err = EINVAL;
		goto err;
	}

	if (_clip_parinfo(mp,2) == NUMERIC_t)
		port = htons(_clip_parnl(mp,2));
	else if ((sport = _clip_parc(mp,2)) != NULL)
	{
		struct servent *sp;
		if ((sp = getservbyname( (const char *) sport, "tcp")) != NULL)
			port = sp->s_port;
		else
		{
			for (i = 0; sport[i] >= '0' && sport[i] <= '9'; i++);
			if (sport[i] == '\0')
				port = htons(atol(sport));
		}

	}

	if (port == 0)
	{
		*err = EINVAL;
		goto err;
	}

	if (_clip_parinfo(mp,3) == NUMERIC_t)
		timeout = _clip_parnl(mp,3);

	tv.tv_sec = timeout / 1000;
	tv.tv_usec = (timeout % 1000) * 1000;

	if ((sock = socket(AF_INET, SOCK_STREAM, 0)) == -1)
		goto err;

/*
#if !defined(linux) && !defined(SOLARIS_26_X86)
	setsockopt( sock, SOL_SOCKET, SO_SNDTIMEO, (void *)&tv,  sizeof(tv) );
	setsockopt( sock, SOL_SOCKET, SO_RCVTIMEO, (void *)&tv,  sizeof(tv) );
#endif
*/
	if ((arg = fcntl(sock, F_GETFL, 0)) == -1)
		goto err;
	fcntl(sock, F_SETFL, arg | O_NONBLOCK);

	sin.sin_family = AF_INET;
	sin.sin_port = port;
	tcp_host_addr(addr, &sin.sin_addr);

	if (sin.sin_addr.s_addr == INADDR_NONE)
	{
		*err = EFAULT;
		goto err;
	}

	if (connect( sock, (struct sockaddr *) &sin, sizeof(sin)) == -1 )
	{
		fd_set set;

#ifndef OS_MINGW
		if (errno != EINPROGRESS)
			goto err;
#endif

		FD_ZERO(&set);
		FD_SET(sock, &set);

		do  i = _clip_select( sock+1, NULL, &set, NULL, &tv );
		while (i == -1 && errno == EINTR);

		if (i == -1)
			goto err;
		else if (i == 0)
		{
#ifdef OS_MINGW
			*err = EAGAIN;
#else
			*err = ETIMEDOUT;
#endif
		}

		arg = 0;
		i = sizeof(arg);
		if (getsockopt(sock, SOL_SOCKET, SO_ERROR, (void *) &arg, (socklen_t *)(&i)) == -1)
			goto err;
		if (arg != 0)
		{
			*err = arg;
			goto err;
		}
	}

#ifndef OS_MINGW
	if ((arg = fcntl(sock, F_GETFL, 0)) == -1)
		goto err;
	fcntl(sock, F_SETFL, arg | O_NONBLOCK);
#endif

	cf = calloc(1, sizeof(C_FILE));
	cf->fileno = sock;
	cf->f = NULL;
	cf->type = FT_SOCKET;
	cf->pid = -1;
	cf->timeout = timeout;
	cf->stat = 0; /* see FS_* flags */
	ret = _clip_store_c_item(mp, cf, _C_ITEM_TYPE_FILE, destroy_c_file);

	err:
	if (ret == -1)
	{
		if (*err !=0 )
			*err = errno;
		if (sock != -1)
			close(sock);
	}
	_clip_retni(mp, ret);

	return 0;
}

int
clip_TCPREAD(ClipMachine *mp)
{
	int lenbuf = 0, ret = -1;
	int *err    = _clip_fetch_item(mp, HASH_ferror);
	int fd      = _clip_parni(mp, 1);
	char *buf   = _clip_parcl(mp, 2, &lenbuf);
	long len    = _clip_parnl(mp,3);
	int timeout = _clip_parni(mp,4), oldtout;
	C_FILE *cf  = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	_clip_retnl(mp, -1);

	if (cf == NULL || cf->type != FT_SOCKET)
	{
		*err = EBADF;
	}
	else
	{
		if (lenbuf < len)
			len = lenbuf;

		oldtout = cf->timeout;
		if (_clip_parinfo(mp, 4) == NUMERIC_t)
			cf->timeout = timeout;

		if (len > 0)
		{
			if (cf->f == NULL || (cf->stat & FS_BUFFERED) == 0)
				ret = _clip_read(cf, buf, len);
			else
				ret = fread(buf, 1, len, cf->f);
		}
		else
			ret = 0;

		cf->timeout = oldtout;

		*err = ret < 0 ? errno : 0;
	}
	_clip_retnl(mp, ret);
	return 0;
}

int
clip_TCPWRITE(ClipMachine *mp)
{
	int lenbuf = 0, ret = -1;
	int *err    = _clip_fetch_item(mp, HASH_ferror);
	int fd      = _clip_parni(mp, 1);
	char *buf   = _clip_parcl(mp, 2, &lenbuf);
	long len    = _clip_parnl(mp,3);
	int timeout = _clip_parni(mp,4), oldtout;
	C_FILE *cf  = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	if (cf == NULL || cf->type != FT_SOCKET)
		*err = EBADF;
	else
	{
		if (_clip_parinfo(mp, 3) != NUMERIC_t || len > lenbuf)
			len = lenbuf;

		oldtout = cf->timeout;
		if (_clip_parinfo(mp, 4) == NUMERIC_t)
			cf->timeout = timeout;

		if (len > 0)
		{
			if (cf->f == NULL || (cf->stat & FS_BUFFERED) == 0)
				ret = _clip_write(cf, buf, len);
			else
				ret = fwrite(buf, 1, len, cf->f);
		}
		else
			ret = 0;

		cf->timeout = oldtout;

		*err = ret < 0 ? errno : 0;
	}
	_clip_retnl(mp, ret);
	return 0;
}

static int
_clip_sockclose(ClipMachine *mp)
{
	int fd = _clip_parni(mp, 1);
	C_FILE *cf = (C_FILE *) _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);
	int ret = -1, *err = _clip_fetch_item(mp, HASH_ferror);
	fd_set rfds;
	struct timeval tv;
	int arg;

	if (cf == NULL || cf->type != FT_SOCKET)
	{
		*err = EBADF;
	}
	arg = fcntl(cf->fileno, F_GETFL, 0);
	if(!(arg & O_NONBLOCK))
	{
		FD_ZERO(&rfds);
		FD_SET(cf->fileno,&rfds);
		tv.tv_sec = 1; //timeout / 1000;
		tv.tv_usec = 100; //(timeout % 1000) * 1000;
		select(cf->fileno+1,&rfds,NULL,NULL,&tv);
	}
	if (_clip_destroy_c_item(mp, fd, _C_ITEM_TYPE_FILE))
	{
		*err = ret = 0;
	}
	else
	{
		*err = errno;
	}

	/* _clip_retni(mp, ret); TODO? What type of value should return */
	_clip_retl(mp, (ret == 0));
	return 0;
}

int
clip_TCPCLOSE(ClipMachine *mp)
{
	return _clip_sockclose(mp);
}

int
clip_UDPSOCKET(ClipMachine *mp)
{
	C_FILE *cf = NULL;
	int arg = 0, sock = -1, ret = -1;
	int *err = _clip_fetch_item(mp, HASH_ferror);

	*err=0;
	if ((sock = socket(AF_INET, SOCK_DGRAM, 0)) == -1)
		goto err;

#ifndef OS_MINGW
	if ((arg = fcntl(sock, F_GETFL, 0)) == -1)
		goto err;
	fcntl(sock, F_SETFL, arg | O_NONBLOCK);
#endif

	cf = calloc(1, sizeof(C_FILE));
	cf->fileno = sock;
	cf->f = NULL;
	cf->type = FT_SOCKET;
	cf->pid = -1;
	cf->timeout = 60000;
	cf->stat = 0; /* see FS_* flags */
	ret = _clip_store_c_item(mp, cf, _C_ITEM_TYPE_FILE, destroy_c_file);

	err:
	if (ret == -1)
	{
		if ( *err != 0 )
			*err = errno;
		if (sock != -1)
			close(sock);
	}
	_clip_retni(mp, ret);

	return 0;
}

int
clip_UDPCLOSE(ClipMachine *mp)
{
	return _clip_sockclose(mp);
}

int
clip_UDPBROADCAST(ClipMachine *mp)
{
	int fd = _clip_parni(mp, 1);
	C_FILE *cf = (C_FILE *) _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);
	int *err = _clip_fetch_item(mp, HASH_ferror), ret = -1, arg;

	if (cf == NULL || cf->type != FT_SOCKET)
		*err = EBADF;
	else
	{
		arg = _clip_parl(mp,2);
		ret = setsockopt(cf->fileno, SOL_SOCKET, SO_BROADCAST, (void *) &arg, sizeof(arg));
		*err = ret == -1 ? errno : 0;
	}
	_clip_retni(mp, ret);
	return 0;
}


int
clip_UDPBIND(ClipMachine *mp)
{
	int fd = _clip_parni(mp, 1);
	C_FILE *cf = (C_FILE *) _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);
	char *ipaddr = _clip_parc(mp, 2);
	int port     = _clip_parni(mp,3);
	int ret = -1, *err = _clip_fetch_item(mp, HASH_ferror);
	struct sockaddr_in sin;

	if (cf == NULL || cf->type != FT_SOCKET)
		*err = EBADF;
	else
	{
		memset( (void *) &sin, 0, sizeof(sin) );
		sin.sin_family      = PF_INET;
		sin.sin_addr.s_addr = inet_addr(ipaddr);
		sin.sin_port        = htons(port);
		ret = bind( cf->fileno, (struct sockaddr *) &sin, sizeof(sin) );
		*err = ret == -1 ? errno : 0;
	}
	_clip_retni(mp, ret);
	return 0;
}

int
clip_UDPSENDTO(ClipMachine *mp)
// UDPSENDTO( nCF, cIPaddr, nPort, cMsg, [nLen], [nTimeout] )
{
	int fd = _clip_parni(mp, 1);
	C_FILE *cf = (C_FILE *) _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);
	char *ipaddr = _clip_parc(mp, 2);
	int port     = _clip_parni(mp,3), lenbuf;
	char *msg    = _clip_parcl(mp,4, &lenbuf);
	long len     = _clip_parnl(mp,5);
	int timeout  = _clip_parni(mp,6);
	int ret = -1, *err = _clip_fetch_item(mp, HASH_ferror);
	struct sockaddr_in sin;
	struct timeval tv;
	fd_set set;

	if (cf == NULL || cf->type != FT_SOCKET)
		*err = EBADF;
	else
	{
		if (_clip_parinfo(mp, 5) != NUMERIC_t)
			len = lenbuf;
		if (len > lenbuf)
			len = lenbuf;

		if (_clip_parinfo(mp, 6) != NUMERIC_t)
			timeout = cf->timeout;

		if ( timeout >= 0 ) {
			FD_ZERO(&set);
			FD_SET(cf->fileno, &set);
			tv.tv_sec = timeout / 1000;
			tv.tv_usec = (timeout % 1000) * 1000;
		}

		memset( (void *) &sin, 0, sizeof(sin) );
		sin.sin_family      = PF_INET;
		sin.sin_addr.s_addr = inet_addr(ipaddr);
		sin.sin_port        = htons(port);

		if ( timeout < 0 || select( cf->fileno+1, NULL, &set, NULL, &tv ) > 0 )
		{
			ret = sendto( cf->fileno, msg, len, 0, (struct sockaddr *) &sin, sizeof(sin) );
			*err = ret == -1 ? errno : 0;
		}
		else
#ifdef OS_MINGW
			*err = EAGAIN;
#else
			*err = ETIMEDOUT;
#endif

	}

	_clip_retnl(mp, ret);
	return 0;
}

int clip_UDPRECVFROM(ClipMachine *mp)
// UDPRECVFROM( nCF, @cIPadr, @nPort, @cMsg, [nLen], [nTimeout] )
{
	int fd = _clip_parni(mp, 1), lenbuf, sln;
	C_FILE *cf = (C_FILE *) _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);
	char *msg    = _clip_parcl(mp,4, &lenbuf);
	long len     = _clip_parnl(mp,5);
	int timeout  = _clip_parni(mp,6);
	int ret = -1, *err = _clip_fetch_item(mp, HASH_ferror);
	char ipaddr[INET_ADDRSTRLEN];
	struct sockaddr_in sin;
	struct timeval tv;
	fd_set set;

	if (cf == NULL || cf->type != FT_SOCKET)
		*err = EBADF;
	else
	{
		if (_clip_parinfo(mp, 5) != NUMERIC_t || len > lenbuf)
			len = lenbuf;

		if (_clip_parinfo(mp, 6) != NUMERIC_t)
			timeout = cf->timeout;

		if ( timeout >= 0 ) {
			FD_ZERO(&set);
			FD_SET(cf->fileno, &set);
			tv.tv_sec = timeout / 1000;
			tv.tv_usec = (timeout % 1000) * 1000;
		}

		memset( (void *) &sin, 0, sizeof(sin) );
		sin.sin_family      = PF_INET;
		sln = sizeof(sin);
		if ( timeout < 0 || select( cf->fileno+1, &set, NULL, NULL, &tv ) > 0 )
			ret = recvfrom( cf->fileno, msg, len, 0, (struct sockaddr *) &sin, (socklen_t *)(&sln) );
		else
#ifdef OS_MINGW
			*err = EAGAIN;
#else
			*err = ETIMEDOUT;
#endif

		if ( ret >= 0 )
		{
#ifdef _WIN32
			_clip_storc(mp, inet_ntoa( *(struct in_addr*)ipaddr), 2, 0);
			_clip_storni(mp, ntohs(sin.sin_port), 3, 0);
#else
			if ( inet_ntop( PF_INET, &sin.sin_addr.s_addr, ipaddr, INET_ADDRSTRLEN ) == NULL )
				ret = -1;
			else
			{
				_clip_storc(mp, ipaddr, 2, 0);
				_clip_storni(mp, ntohs(sin.sin_port), 3, 0);
			}
#endif
		}

		*err = ret == -1 ? errno : 0;
	}

	_clip_retnl(mp, ret);
	return 0;
}

int clip_TCPGETPEERNAME(ClipMachine *mp)
/* Get the address of the peer to which a socket is connected.
   using : tcpGetPeerName( sock, @cIPadr ) ->  0 - OK  | -1 == error
*/
{
	int ret     = -1, sln;
	int *err    = _clip_fetch_item(mp, HASH_ferror);
	int fd      = _clip_parni(mp, 1);
	C_FILE *cf  = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);
	char ipaddr[INET_ADDRSTRLEN];
	struct sockaddr_in sin;

	_clip_retnl(mp, -1);

	if (cf == NULL || cf->type != FT_SOCKET)
	{
	*err = EBADF;
	}
	else
	{
	sln = sizeof(sin);
	ret = getpeername(cf->fileno, (struct sockaddr *) &sin, (socklen_t *)(&sln));

	*err = ret < 0 ? errno : 0;

	if ( ret >= 0 )
	{
#ifdef _WIN32
		_clip_storc(mp, inet_ntoa( *(struct in_addr*)ipaddr), 2, 0);
#else
		if ( inet_ntop( PF_INET, &sin.sin_addr.s_addr, ipaddr, INET_ADDRSTRLEN ) == NULL )
			ret = -1;
		else
			_clip_storc(mp, ipaddr, 2, 0);
#endif
		_clip_storni(mp,ntohs(sin.sin_port),3,0);
	}
	else
		_clip_storni(mp,-1,3,0);

	}

	_clip_retnl(mp, ret);
	return 0;
}
