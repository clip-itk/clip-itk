/*
	Copyright (C) 2001  ITK
	Author  : Rushad Nabiullin <rust@itk.ru>
	License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include <string.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>
#include <sys/stat.h>
#include "../rdd.h"
#include "error.ch"
#include "dbinfo.ch"

#define DBT_PAGE_SIZE 512

static RDD_MEMO_VTBL* dbt_vtbl();

int clip_INIT_DBT(ClipMachine* cm){
	rdd_registermemodriver(cm,dbt_vtbl());
	return 0;
}

typedef struct _DBT_HEADER_ {
	char fuu[4];
	char reserved1[12];
	char version;
	char reserved2[495];
} DBT_HEADER;

static int dbt_create(ClipMachine* cm,char* name,const char* __PROC__){
	RDD_FILE file;
	DBT_HEADER hdr;
	int er;

	memset(&hdr,0,sizeof(DBT_HEADER));
	_rdd_put_uint(hdr.fuu,1);
	hdr.version = 0x50;

	memset(&file,0,sizeof(RDD_FILE));
	file.md = (char*)-1;
#ifdef OS_CYGWIN
	file.fd = open(name,O_CREAT|O_TRUNC|O_RDWR|O_BINARY,cm->fileCreateMode);
#else
	file.fd = open(name,O_CREAT|O_TRUNC|O_RDWR,cm->fileCreateMode);
#endif
	if(file.fd == -1) goto err;
	if((er = rdd_write(cm,&file,0,sizeof(DBT_HEADER),(char*)&hdr,__PROC__)))
		return er;
	if(close(file.fd)==-1) goto err;
	return 0;
err:
	return rdd_err(cm,EG_CREATE,errno,__FILE__,__LINE__,__PROC__,name);
}

static int dbt_zap(ClipMachine* cm,RDD_MEMO* rm,const char* __PROC__){
	DBT_HEADER hdr;
	int er;

	if((er = rdd_trunc(cm,&rm->file,sizeof(DBT_HEADER),__PROC__))) return er;
	if((er = rdd_read(cm,&rm->file,0,sizeof(DBT_HEADER),&hdr,__PROC__)))
		return er;
	_rdd_put_uint(hdr.fuu,1);
	return rdd_write(cm,&rm->file,0,sizeof(DBT_HEADER),&hdr,__PROC__);
}

static int dbt_open(ClipMachine* cm,RDD_DATA* rd,RDD_MEMO* rm,const char* __PROC__){
	rm->blocksize = 512;
	return 0;
}

static int dbt_close(ClipMachine* cm,RDD_DATA* rd,RDD_MEMO* rm,const char* __PROC__){
	destroy_rdd_memo(rm);
	return 0;
}

static int dbt_getvalue(ClipMachine* cm,RDD_MEMO* rm,int id,ClipVar* vp,const char* __PROC__){
	char buf[DBT_PAGE_SIZE+1];
	char* pos;
	int len = 0;
	int count = 0;
	int fsize,er;

	vp->s.str.buf = malloc(1);
	vp->s.str.buf[0] = 0;
	vp->s.str.len = 0;

	if(!id)
		return 0;

	if((int)rm->file.md==-1){
		struct stat st;
		fstat(rm->file.fd,&st);
		fsize = st.st_size;
	} else
		fsize = rm->file.mapsize;

	while(1){
		if((id+count)*DBT_PAGE_SIZE+DBT_PAGE_SIZE>fsize){
			int toread = fsize-(id+count)*DBT_PAGE_SIZE;
			if((er = rdd_read(cm,&rm->file,(id+count++)*DBT_PAGE_SIZE,toread,
				buf,__PROC__))) return er;
			buf[toread] = 0x1A;
			buf[toread+1] = 0x1A;
		} else {
			if((er = rdd_read(cm,&rm->file,(id+count++)*DBT_PAGE_SIZE,DBT_PAGE_SIZE+1,
				buf,__PROC__))) return er;
		}
		if((pos = memchr(buf,0x1a,DBT_PAGE_SIZE))){
/*			if(*(pos+1)==0x1a){*/
				vp->s.str.buf = realloc(vp->s.str.buf,len+(pos-buf)+1);
				memcpy(vp->s.str.buf+len,buf,pos-buf);
				vp->s.str.len = len+(pos-buf);
				loc_read(rm->loc,vp->s.str.buf,vp->s.str.len);
				return 0;
/*			}*/
		}
		vp->s.str.buf = realloc(vp->s.str.buf,len+DBT_PAGE_SIZE+1);
		memcpy(vp->s.str.buf+len,buf,DBT_PAGE_SIZE);
		len += DBT_PAGE_SIZE;
	}
	return 0;
}

static int dbt_setvalue(ClipMachine* cm,RDD_MEMO* rm,int* id,ClipVar* vp,int binary,const char* __PROC__){
	ClipVar old;
	int pages,er;
	char* buf;
	int isnew = 0;
	char fuu[4];

	if(vp->t.type != CHARACTER_t)
		return rdd_err(cm,EG_DATATYPE,0,__FILE__,__LINE__,__PROC__,
			"Incompatible types");
	loc_write(rm->loc,vp->s.str.buf,vp->s.str.len);

	if((er = dbt_getvalue(cm,rm,*id,&old,__PROC__))) return er;
	pages = (old.s.str.len + 2) / DBT_PAGE_SIZE + ((old.s.str.len+2)%DBT_PAGE_SIZE!=0);
	if(!*id || vp->s.str.len+2 > pages*DBT_PAGE_SIZE){
		if((er = rdd_read(cm,&rm->file,0,4,fuu,__PROC__))) return er;
		*id = _rdd_uint(fuu);
		isnew = 1;
	}
	pages = (vp->s.str.len + 2) / DBT_PAGE_SIZE + ((vp->s.str.len+2)%DBT_PAGE_SIZE!=0);
	buf = malloc(pages*DBT_PAGE_SIZE);
	memcpy(buf,vp->s.str.buf,vp->s.str.len);
	memset(buf+vp->s.str.len,0x1a,2);
	if((er = rdd_write(cm,&rm->file,*id*DBT_PAGE_SIZE,pages*DBT_PAGE_SIZE,buf,
		__PROC__))) return er;
	free(buf);
	if(isnew){
		_rdd_put_uint(fuu,*id+pages);
		if((er = rdd_write(cm,&rm->file,0,4,fuu,__PROC__))) return er;
	}
	return 0;
}

int dbt_info(ClipMachine* cm,RDD_DATA* rd,RDD_MEMO* rm,int cmd,const char* __PROC__){
	switch(cmd){
		case DBI_MEMOBLOCKSIZE:
		{
			_clip_retni(cm,DBT_PAGE_SIZE);
			break;
		}
	}
	return 0;
}

static RDD_MEMO_VTBL* dbt_vtbl(){
	RDD_MEMO_VTBL* vtbl = (RDD_MEMO_VTBL*)malloc(sizeof(RDD_MEMO_VTBL));

	memset(vtbl,0,sizeof(RDD_MEMO_VTBL));
	strcpy(vtbl->id,"DBT");
	strcpy(vtbl->suff,".dbt");
	strcpy(vtbl->desc,"Generic DBT memo files driver v0.0.1 (c) 2001 Copyright ITK Ltd.");

	vtbl->create	= dbt_create;
	vtbl->zap		= dbt_zap;
	vtbl->open		= dbt_open;
	vtbl->close		= dbt_close;
	vtbl->getvalue	= dbt_getvalue;
	vtbl->setvalue	= dbt_setvalue;
	vtbl->info		= dbt_info;
	return vtbl;
}

