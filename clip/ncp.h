/*
	Copyright (C) 2002  ITK
	Author  : Paul Lasarev <paul@itk.ru>
	License : (GPL) http://www.itk.ru/clipper/license.html

	$Log: ncp.h,v $
	Revision 1.2  2002/04/22 11:22:07  clip
	include fix
	paul
	
	Revision 1.1  2002/04/22 11:11:20  clip
	remove ncp code from rdd/dbf.c
	create ncp module
	add ncp usage in _file/diskutil _set_lock call
	paul

*/
#ifndef NCP_H
#define NCP_H

#include "clipcfg.h"

#define USE_NCPFS_LOCK 1

int ncp_is_ncpfs(int fd);
int ncp_is_ncpfs_filename(char *filename);
int ncp_openmode(int fd, int exclusive);
int ncp_fcntl(int fd, int flag, void *argp);

#if defined(OS_LINUX) && defined(USE_NCPFS_LOCK)
#define	USE_NCPFS	1
#endif

#endif
