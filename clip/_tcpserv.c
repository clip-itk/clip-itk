/*
   Copyright (C) 2003  JARA
   Authors  : Sergio Zayas
   License : (GPL) http://www.itk.ru/clipper/license.html
   mail : icaro.maneton@lycos.es
*/
/*
   $Log: _tcpserv.c,v $
   Revision 1.6  2004/05/19 08:32:18  clip
   rust: fix for ./configure -m

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

#include "hashcode.h"
#include "error.ch"
#include "fileio.ch"

#ifdef USE_UTMP
#  include <utmp.h>
#endif

#ifdef OS_CYGWIN
#define INET_ADDRSTRLEN  16
#define socklen_t int
#endif


/*****************************/
int clip_TCPLISTEN(ClipMachine *mp)
/* Create a socket and stand for connetions.
  Use : TcpListen( port[, nMaxConn] )
*/
{
	struct sockaddr_in sin;
	long port = 0, timeout = 60000;
	int *err = _clip_fetch_item(mp, HASH_ferror), i;
	char *sport;
	int sock = -1, ret = -1;
	int backlog = 5;
	C_FILE *cf = NULL;
	int arg;

	*err=0;

	if ( _clip_parinfo( mp, 0 ) < 1 ) {
		*err = EINVAL;
		goto err;
	}


	if (_clip_parinfo(mp,1) == NUMERIC_t)
		port = htons(_clip_parnl(mp,1));
	else if ((sport = _clip_parc(mp,1)) != NULL)
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

	if (_clip_parinfo(mp,2) == NUMERIC_t)
		backlog = _clip_parnl(mp,2);


	if ((sock = socket(AF_INET, SOCK_STREAM, 0)) == -1)
		goto err;

	if ((arg = fcntl(sock, F_GETFL, 0)) == -1)
		goto err;
	fcntl(sock, F_SETFL, arg | O_NONBLOCK);

	memset( (void *) &sin, 0, sizeof(sin) );
	sin.sin_family = AF_INET;  /* PF_INET ?? */
	sin.sin_addr.s_addr = INADDR_ANY;
	sin.sin_port = port;

	if (bind( sock, (struct sockaddr *) &sin, sizeof(sin)) == -1 )
	/* Error, no bind */
	{

		*err = EFAULT;
		goto err;

	}

	if ( listen( sock, backlog ) == -1 )
	{
		*err = EFAULT;
		goto err;
	}

	cf = (C_FILE *) calloc(1, sizeof(C_FILE));
	cf->fileno = sock;
	cf->f = NULL;
	cf->type = FT_SOCKET;
	cf->pid = -1;
	cf->timeout = timeout;
	cf->stat = 0;     /* see FS_* flags */
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


int clip_TCPACCEPT(ClipMachine *mp)
/* Return a new socket for pending connections.
	uso : tcpAccept( sock, timeout ) ->  nNewSocket  | -1 == error
*/
{
	int ret = -1;
	int *err    = _clip_fetch_item(mp, HASH_ferror);
	int sock      = _clip_parni(mp, 1);
	int timeout  = _clip_parni(mp, 2 );
	C_FILE *cf  = _clip_fetch_c_item(mp, sock, _C_ITEM_TYPE_FILE);
	struct sockaddr_in sin;
	int socknew;
	socklen_t sinlen = sizeof( sin );
	fd_set readfd;
	struct timeval tv;



	if (cf == NULL || cf->type != FT_SOCKET)
	{
		*err = EBADF;
	}
	else
	{


		if( _clip_parinfo( mp, 2 ) != NUMERIC_t )
			timeout = cf->timeout;

		FD_ZERO( &readfd );
		FD_SET( cf->fileno, &readfd );
		//timeout = 0;
		tv.tv_sec = timeout / 1000;
		tv.tv_usec = (timeout % 1000 ) * 1000;

		if( select( cf->fileno+1, &readfd, NULL, NULL, &tv ) < 1 ) {
			*err = errno;
			_clip_retnl(mp, ret);
			return 0;
		}

		if ((socknew = accept( cf->fileno, (struct sockaddr *) &sin, &sinlen )) == -1 )
			*err = errno;
		else {
			/* Accept correcto. */
			// Se registra el socket en clip.
			cf = (C_FILE *) calloc(1, sizeof(C_FILE));
			cf->fileno = socknew;
			cf->f = NULL;
			cf->type = FT_SOCKET;
			cf->pid = -1;
			cf->timeout = timeout;   /* timeout; */
			cf->stat = 0;     /* see FS_* flags */
			ret = _clip_store_c_item(mp, cf, _C_ITEM_TYPE_FILE, destroy_c_file);
		}

	}
	_clip_retnl(mp, ret);
	return 0;
}



