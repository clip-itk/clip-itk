/*
	Copyright (C) 2001  ITK
	Author  : Rushad Nabiullin <rust@itk.ru>
	License : (GPL) http://www.itk.ru/clipper/license.html

	$Log: fpt.c,v $
	Revision 1.41  2003/09/02 14:27:43  clip
	changes for MINGW from
	Mauricio Abre <maurifull@datafull.com>
	paul
	
	Revision 1.40  2003/06/21 08:54:47  clip
	rust: CMF (CLIP Memo File) with 64-bit file support started

	Revision 1.39  2003/06/04 11:46:49  clip
	rust: size optimization

	Revision 1.38  2003/05/29 15:26:27  clip
	rust: memory leak in fpt_setvalue()

	Revision 1.37  2003/05/29 10:57:52  clip
	rust: CLIP_MEMO is flex too

	Revision 1.36  2003/03/04 10:31:24  clip
	rust: some cleanings

	Revision 1.35  2003/01/22 10:59:51  clip
	rust: touch updated memo and index on close

	Revision 1.34  2002/12/25 12:18:25  clip
	rust: read arrays from SIxMemo

	Revision 1.33  2002/12/12 13:42:27  clip
	rust: small fix

	Revision 1.32  2002/12/12 11:17:17  clip
	rust: support for non-flex FPT (C52 DBFCDX, SIXCDX)

	Revision 1.31  2002/11/27 12:13:38  clip
	rust: small fix

	Revision 1.30  2002/11/26 15:35:48  clip
	rust: avoid permanent fuu increasing

	Revision 1.29  2002/11/26 12:47:35  clip
	rust: added parameter 'method' to _clip_var2str() and _clip_str2var()

	Revision 1.28  2002/09/19 12:52:17  clip
	rust: flex fpt bug

	Revision 1.27  2002/09/18 08:30:50  clip
	rust: flex fpt with objects

	Revision 1.26  2002/09/17 14:44:05  clip
	rust: flex fpt bug

	Revision 1.25  2002/09/17 09:54:21  clip
	rust: flex fpt

	Revision 1.24  2002/06/03 11:53:48  clip
	rust: memory leak in fpt_getvalue()

	Revision 1.23  2002/04/30 09:10:26  clip
	rust: 'X' field type support

	Revision 1.22  2002/04/19 08:36:05  clip
	rust: initial support of VFP DBF format, "VFPCDX" driver

	Revision 1.21  2002/04/03 09:37:44  clip
	rust: .DBF signature with various memo formats is corrected

	Revision 1.20  2002/03/19 12:41:31  clip
	rust: big cleaning

	Revision 1.19  2001/12/26 12:03:43  clip
	Sx_SetMemoBlock()
	rust

	Revision 1.18  2001/11/09 09:57:36  clip
	bug in fpt_setvalue()
	rust

	Revision 1.17  2001/11/06 10:42:45  clip
	SIX: RDD_Count(), RDD_Info(), RDD_Name()
	rust

	Revision 1.16  2001/11/01 14:51:37  clip
	bug in fpt_pack()
	rust

	Revision 1.15  2001/10/30 08:41:38  clip
	many changes
	rust

	Revision 1.14  2001/10/24 12:12:08  clip
	Six: VariFields
	rust

	Revision 1.13  2001/10/24 08:48:47  clip
	Six types: V3, V4
	rust

	Revision 1.12  2001/10/23 12:01:34  clip
	rm_MemoPack()
	rust

	Revision 1.11  2001/10/22 12:07:05  clip
	many fixes and bugs :)
	rust

	Revision 1.10  2001/10/12 10:05:20  clip
	some fixes
	rust

	Revision 1.9  2001/10/10 15:04:58  clip
	many fixes
	rust

	Revision 1.8  2001/08/23 14:44:49  clip
	Logging started
	rust

*/
#include <string.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>
#include <sys/stat.h>
#include "../rdd.h"
#include "error.ch"
#include "dbinfo.ch"

#define FLEXPAGE_SIZE 1024

#define CLIP_MEMO    0
#define SIX_MEMO     1
#define FLEX_MEMO    2

static RDD_MEMO_VTBL* fpt_vtbl();

static const char* er_corruption = "Corruption in .FPT file detected";

int clip_INIT_FPT(ClipMachine* cm){
	rdd_registermemodriver(cm,fpt_vtbl());
	return 0;
}

typedef struct _FPT_HEADER_ {
	char fuu[4];
	char reserved1[2];
	char blocksize[2];
	char sig0[12];
	char reserved2[492];
	char sig[12];
	char flexdir[4];
	char flexrev[4];
	char counter[4];
	char reserved3[488];
} FPT_HEADER;

typedef struct _FLEX_ITEM_ {
	unsigned int offs;
	unsigned int len;
} FLEX_ITEM;

typedef struct _FPT_FLEX_ {
	unsigned int fuu;
	unsigned int dirpage;
	unsigned int revpage;
	unsigned int counter;
	int nitems;
	FLEX_ITEM items[126];
} FPT_FLEX;

static int fpt_create(ClipMachine* cm,char* name,const char* __PROC__){
	RDD_FILE file;
	FPT_HEADER hdr;
	int fuu,er;
	FPT_HEADER dum;

	memset(&hdr,0,sizeof(FPT_HEADER));
	memset(&dum,0,sizeof(FPT_HEADER));
	fuu = sizeof(FPT_HEADER)/cm->mblocksize;
	fuu += (fuu*cm->mblocksize<sizeof(FPT_HEADER))?1:0;
	_rdd_put_backuint(hdr.fuu,fuu);
	_rdd_put_backushort(hdr.blocksize,cm->mblocksize);
	strcpy(hdr.sig,"FlexFile3");
	strcpy(hdr.sig0,"Made by CLIP");
	hdr.sig[9] = 3;

	memset(&file,0,sizeof(RDD_FILE));
	file.md = (char*)-1;
#ifdef _WIN32
	file.fd = open(name,O_CREAT|O_TRUNC|O_RDWR|O_BINARY,cm->fileCreateMode);
#else
	file.fd = open(name,O_CREAT|O_TRUNC|O_RDWR,cm->fileCreateMode);
#endif
	if(file.fd == -1) goto err;
	if((er = rdd_write(cm,&file,0,sizeof(FPT_HEADER),&hdr,__PROC__)))
		return er;
	if((er = rdd_write(cm,&file,sizeof(FPT_HEADER),
		fuu*cm->mblocksize-sizeof(FPT_HEADER),&dum,__PROC__))) return er;
	if(close(file.fd)==-1) goto err;
	return 0;
err:
	return rdd_err(cm,EG_CREATE,errno,__FILE__,__LINE__,__PROC__,name);
}

static int fpt_zap(ClipMachine* cm,RDD_MEMO* rm,const char* __PROC__){
	FPT_HEADER hdr;
	int fuu,er;

	fuu = sizeof(FPT_HEADER)/rm->blocksize;
	fuu += (fuu*rm->blocksize<sizeof(FPT_HEADER))?1:0;
	if((er = rdd_trunc(cm,&rm->file,fuu*rm->blocksize,__PROC__))) return er;
	if((er = rdd_read(cm,&rm->file,0,sizeof(FPT_HEADER),&hdr,__PROC__)))
		return er;
	_rdd_put_backuint(hdr.fuu,fuu);
	_rdd_put_uint(hdr.flexdir,0);
	_rdd_put_uint(hdr.flexrev,0);
	_rdd_put_uint(hdr.counter,0);
	return rdd_write(cm,&rm->file,0,sizeof(FPT_HEADER),&hdr,__PROC__);
}


static int fpt_open(ClipMachine* cm,RDD_DATA* rd,RDD_MEMO* rm,const char* __PROC__){
	FPT_HEADER hdr;
	int er;

	if((er = rdd_read(cm,&rm->file,0,sizeof(FPT_HEADER),&hdr,__PROC__)))
		return er;
	rm->blocksize = _rdd_backushort(hdr.blocksize);
	if(memcmp(hdr.sig0,"SIxMemo",7) == 0)
		rm->format = SIX_MEMO;
	else if(memcmp(hdr.sig0,"Made by CLIP",12) == 0)
		rm->format = CLIP_MEMO;
	else if(memcmp(hdr.sig,"FlexFile3\03",9)==0)
		rm->format = FLEX_MEMO;
	return 0;
}


static int fpt_close(ClipMachine* cm,RDD_DATA* rd,RDD_MEMO* rm,const char* __PROC__){
	destroy_rdd_memo(rm);
	return 0;
}

static void _read_six_str(ClipVar* vp,DbfLocale* loc,char** str){
	vp->t.type = CHARACTER_t;
	*str += 2;
	vp->s.str.len = _rdd_uint(*str);
	*str += 12;
	vp->s.str.buf = *str;
	*str += vp->s.str.len;
	loc_read(loc,vp->s.str.buf,vp->s.str.len);
}

static void _read_six_int(ClipVar* vp,char** str){
	vp->t.type = NUMERIC_t;
	*str += 6;
	vp->n.d = (int)_rdd_uint(*str);
	*str += 8;
}

static void _read_six_double(ClipVar* vp,int dec,char** str){
	vp->t.type = NUMERIC_t;
	*str += 6;
	vp->n.d = *(double*)*str;
	vp->t.dec = dec;
	*str += 8;
}

static void _read_six_date(ClipVar* vp,char** str){
	vp->t.type = DATE_t;
	*str += 6;
	vp->d.julian = _rdd_uint(*str);
	*str += 8;
}

static void _read_six_log(ClipVar* vp,char** str){
	vp->t.type = LOGICAL_t;
	*str += 6;
	vp->d.julian = _rdd_ushort(*str);
	*str += 8;
}

static void _read_six_array(ClipMachine* cm,ClipVar* vp,DbfLocale* loc,char** s,int len){
	char* b = *s;
	char* e = b+len;
	int size,i;
	long dims[1] = {0};

	_clip_array(cm,vp,1,dims);
	*s += 2;
	size = _rdd_uint(*s);
	*s += 12;
	for(i=0;i<size;i++){
		int type = _rdd_backushort(*s);
		ClipVar v;
		memset(&v,0,sizeof(ClipVar));
		switch(type){
			case 0x4:
				_read_six_str(&v,loc,s);
				_clip_aadd(cm,vp,&v);
				break;
			case 0x800:
				_read_six_double(&v,cm->decimals,s);
				_clip_aadd(cm,vp,&v);
				break;
			case 0x200:
				_read_six_int(&v,s);
				_clip_aadd(cm,vp,&v);
				break;
			case 0x2000:
				_read_six_date(&v,s);
				_clip_aadd(cm,vp,&v);
				break;
			case 0x8000:
				_read_six_log(&v,s);
				_clip_aadd(cm,vp,&v);
				break;
			case 0x80:
				_read_six_array(cm,&v,loc,s,len-(*s-b));
				_clip_aadd(cm,vp,&v);
				break;
			default:
				*s = e;
				break;
		}
		if(*s>=e)
			break;
	}
}

static int fpt_getvalue(ClipMachine* cm,RDD_MEMO* rm,int id,ClipVar* vp,const char* __PROC__){
	int len,er;
	char buf[8];
	char *str,*s;

	if(!id){
		vp->s.str.buf = malloc(1);
		vp->s.str.buf[0] = 0;
		vp->s.str.len = 0;
		return 0;
	}
	if((er = rdd_read(cm,&rm->file,id*rm->blocksize,8,buf,__PROC__)))
		return er;
	len = _rdd_backuint(buf+4);
	str = malloc(len+1);
	if((er = rdd_read(cm,&rm->file,id*rm->blocksize+8,len,str,__PROC__)))
		return er;
	str[len] = 0;
	if(_rdd_backuint(buf)==3){
		_clip_str2var(cm,vp,str,len,0);
		free(str);
	} else if(_rdd_backuint(buf)==0x8000){
		s = str;
		_read_six_array(cm,vp,rm->loc,&str,len);
		free(s);
	} else {
		vp->s.str.buf = str;
		vp->s.str.len = len;
		if(_rdd_backuint(buf)==1)
			loc_read(rm->loc,vp->s.str.buf,vp->s.str.len);
	}
	return 0;
}

static int flex_load(ClipMachine* cm,RDD_MEMO* rm,FPT_FLEX* flex,const char* __PROC__){
	char buf[FLEXPAGE_SIZE];
	int i,er;

	memset(flex,0,sizeof(FPT_FLEX));

	if((er = rdd_read(cm,&rm->file,0,4,buf,__PROC__))) return er;
	flex->fuu = _rdd_backuint(buf);

	if(rm->format == FLEX_MEMO || rm->format == CLIP_MEMO){
		if((er = rdd_read(cm,&rm->file,524,12,buf,__PROC__))) return er;
		flex->dirpage = _rdd_uint(buf+4);
		flex->revpage = _rdd_uint(buf);
		flex->counter = _rdd_uint(buf+8);

		if(!flex->dirpage){
			flex->revpage = flex->fuu*rm->blocksize;
			flex->dirpage = flex->fuu*rm->blocksize + FLEXPAGE_SIZE;
			flex->fuu += (2 * FLEXPAGE_SIZE)/rm->blocksize;
			return 0;
		}

		if((er = rdd_read(cm,&rm->file,flex->dirpage,FLEXPAGE_SIZE,buf,__PROC__)))
			return er;

		if(_rdd_backuint(buf) != 1000 || _rdd_backuint(buf+4) != 1010)
			return rdd_err(cm,EG_CORRUPTION,0,__FILE__,__LINE__,__PROC__,er_corruption);

		if(!(_rdd_ushort(buf+8) & 1)){
			// 0x0a
		} else {
			flex->nitems = (_rdd_ushort(buf+8)-3) >> 2;
			for(i=0;i<flex->nitems;i++){
				flex->items[i].offs = _rdd_uint(buf+10+(i<<3));
				flex->items[i].len = _rdd_uint(buf+10+(i<<3)+4);
			}
		}
	}
	return 0;
}

static int _fpt_drop(ClipMachine* cm,RDD_MEMO* rm,FPT_FLEX* flex,int* id,const char* __PROC__){
	char buf[4];
	int i,l,er;
	unsigned int o,s;
	int fa=0,fb=0,f=0;

	if(!*id)
		return 0;

	if((er = rdd_read(cm,&rm->file,*id*rm->blocksize+4,4,buf,__PROC__)))
		return er;

	l = (_rdd_backuint(buf)+8+rm->blocksize-1)/rm->blocksize;

	if(flex->nitems == 126){
		for(i=1;i<flex->nitems;i++){
			flex->items[i-1] = flex->items[i];
		}
		flex->nitems = 125;
	}

	o = *id*rm->blocksize;
	s = l*rm->blocksize;

	for(i=0;i<flex->nitems;i++){
		fa = (flex->items[i].offs+flex->items[i].len == o);
		fb = (o+s == flex->items[i].offs);
		if(fa || fb){
			if(fa){
				flex->items[i].len += s;
				o = flex->items[i].offs;
				s = flex->items[i].len;
			} else if(fb){
				flex->items[i].offs = o;
				flex->items[i].len += s;
				s = flex->items[i].len;
			}
			_rdd_put_backuint(buf,1001);
			if((er = rdd_write(cm,&rm->file,o,4,buf,__PROC__)))
				return er;
			_rdd_put_backuint(buf,s-8);
			if((er = rdd_write(cm,&rm->file,o+4,4,buf,__PROC__)))
				return er;
			f = 1;
			break;
		}
	}
	if(!f){
		flex->items[flex->nitems].offs = *id*rm->blocksize;
		flex->items[flex->nitems].len = l*rm->blocksize;
		flex->nitems++;
		_rdd_put_backuint(buf,1001);
		if((er = rdd_write(cm,&rm->file,*id*rm->blocksize,4,buf,__PROC__)))
			return er;
		_rdd_put_backuint(buf,l*rm->blocksize-8);
		if((er = rdd_write(cm,&rm->file,*id*rm->blocksize+4,4,buf,__PROC__)))
			return er;
	}
	return 0;
}

static int _fpt_add(ClipMachine* cm,RDD_MEMO* rm,FPT_FLEX* flex,int* id,char* str,int l,int type,const char* __PROC__){
	char buf[4];
	int i,j,ll,er,f = 0;
	unsigned int page = flex->fuu * rm->blocksize;

	ll = (l+8+rm->blocksize-1)/rm->blocksize;
	for(i=0;i<flex->nitems;i++){
		if(l<=flex->items[i].len-8){
			page = flex->items[i].offs;
			flex->items[i].len -= ll*rm->blocksize;
			flex->items[i].offs += ll*rm->blocksize;
			if(!flex->items[i].len){
				for(j=i;j<flex->nitems-1;j++){
					flex->items[j] = flex->items[j+1];
				}
				flex->nitems--;
			} else {
				_rdd_put_backuint(buf,1001);
				if((er = rdd_write(cm,&rm->file,flex->items[i].offs,4,buf,__PROC__)))
					return er;
				_rdd_put_backuint(buf,flex->items[i].len-8);
				if((er = rdd_write(cm,&rm->file,flex->items[i].offs+4,4,buf,__PROC__)))
					return er;
			}
			f = 1;
			break;
		}
	}
	if(!f){
		flex->fuu += ll;
	}

	_rdd_put_backuint(buf,type);
	if((er = rdd_write(cm,&rm->file,page,4,buf,__PROC__))) return er;
	_rdd_put_backuint(buf,l);
	if((er = rdd_write(cm,&rm->file,page+4,4,buf,__PROC__))) return er;

	if((er = rdd_write(cm,&rm->file,page+8,l,str,__PROC__))) return er;

	if((l+8) % rm->blocksize){
		buf[0] = 0xAF;
		if((er = rdd_write(cm,&rm->file,page+ll*rm->blocksize-1,1,buf,__PROC__)))
			return er;
	}

	*id = page/rm->blocksize;
	return 0;
}

static int flex_save(ClipMachine* cm,RDD_MEMO* rm,FPT_FLEX* flex,const char* __PROC__){
	char buf[FLEXPAGE_SIZE];
	int i,f,er;

	if(rm->format == FLEX_MEMO || rm->format == CLIP_MEMO)
		_rdd_put_backuint(buf,flex->fuu);
	if((er = rdd_write(cm,&rm->file,0,4,buf,__PROC__))) return er;

	memset(buf,0xad,FLEXPAGE_SIZE);

	flex->counter++;
	_rdd_put_uint(buf,flex->revpage);
	_rdd_put_uint(buf+4,flex->dirpage);
	_rdd_put_uint(buf+8,flex->counter);
	if((er = rdd_write(cm,&rm->file,524,12,buf,__PROC__))) return er;

	_rdd_put_backuint(buf,1000);
	_rdd_put_backuint(buf+4,1010);
	_rdd_put_ushort(buf+8,flex->nitems*4+3);

	f = 1;
	while(f){
		f = 0;
		for(i=0;i<flex->nitems-1;i++){
			if(flex->items[i].len > flex->items[i+1].len){
				int len,offs;
				len = flex->items[i].len;
				offs = flex->items[i].offs;
				flex->items[i].len = flex->items[i+1].len;
				flex->items[i].offs = flex->items[i+1].offs;
				flex->items[i+1].len = len;
				flex->items[i+1].offs = offs;
				f = 1;
			}
		}
	}

	for(i=0;i<flex->nitems;i++){
		_rdd_put_uint(buf+10+i*8,flex->items[i].offs);
		_rdd_put_uint(buf+10+i*8+4,flex->items[i].len);
	}

	if((er = rdd_write(cm,&rm->file,flex->dirpage,FLEXPAGE_SIZE,buf,__PROC__)))
		return er;

	for(i=0;i<flex->nitems;i++){
		_rdd_put_uint(buf+10+i*8,flex->items[i].len);
		_rdd_put_uint(buf+10+i*8+4,flex->items[i].offs);
	}
	if((er = rdd_write(cm,&rm->file,flex->revpage,FLEXPAGE_SIZE,buf,__PROC__)))
		return er;

	return 0;
}

static int fpt_setvalue(ClipMachine* cm,RDD_MEMO* rm,int* id,ClipVar* vp,int binary,const char* __PROC__){
	long l;
	int type,er;
	char* str = NULL;
	FPT_FLEX flex;

	if(vp->t.type != CHARACTER_t){
		_clip_var2str(cm,vp,&str,&l,0);
	} else {
		l = vp->s.str.len;
		str = _clip_memdup(vp->s.str.buf,l);
		if(!binary)
			loc_write(rm->loc,str,l);
	}

	if(vp->t.type != CHARACTER_t){
		type = 3;
	} else {
		type = (binary==0);
	}
	if(rm->format == FLEX_MEMO || rm->format == CLIP_MEMO){
		if((er = flex_load(cm,rm,&flex,__PROC__))) goto err;
		if((er = _fpt_drop(cm,rm,&flex,id,__PROC__))) goto err;
		if((er = _fpt_add(cm,rm,&flex,id,str,l,type,__PROC__))) goto err;
		if((er = flex_save(cm,rm,&flex,__PROC__))) goto err;
	} else {
		int l1,l2,len;
		char buf[8];
		int add = 1;

		if(vp->t.type == UNDEF_t){
			free(str);
			*id = 0;
			return 0;
		}
		l2 = (l+8)/rm->blocksize;
		l2 += (l2*rm->blocksize<(l+8))?1:0;
		if(*id>0){
			if((er = rdd_read(cm,&rm->file,*id*rm->blocksize+4,4,buf,__PROC__)))
				goto err;
			len = _rdd_backuint(buf)+8;
			l1 = len/rm->blocksize;
			l1 += (l1*rm->blocksize<len)?1:0;
			add = (l2>l1);
		}
		len = l2*rm->blocksize-8;
		str = realloc(str,len);
		if(add){
			if((er = rdd_read(cm,&rm->file,0,4,buf,__PROC__))) goto err;
			*id = _rdd_backuint(buf);
			_rdd_put_backuint(buf,*id+l2);
			if((er = rdd_write(cm,&rm->file,0,4,buf,__PROC__))) goto err;
		}
		_rdd_put_backuint(buf,type);
		_rdd_put_backuint(buf+4,l);
		if((l+8) % rm->blocksize)
			str[len-1] = 0xAF;
		if((er = rdd_write(cm,&rm->file,*id*rm->blocksize,8,buf,__PROC__)))
			goto err;
		if((er = rdd_write(cm,&rm->file,*id*rm->blocksize+8,len,str,__PROC__)))
			goto err;
	}
	free(str);
	rm->updated = 1;
	return 0;
err:
	free(str);
	return er;
}

static int fpt_info(ClipMachine* cm,RDD_DATA* rd,RDD_MEMO* rm,int cmd,const char* __PROC__){
	switch(cmd){
		case DBI_MEMOBLOCKSIZE:
		{
			_clip_retni(cm,rm->blocksize);
			break;
		}
	}
	return 0;
}

static int fpt_pack(ClipMachine* cm,RDD_DATA* rd,RDD_MEMO* rm,int tmpfd,int bsize,ClipVar* block,int step,const char* __PROC__){
	FPT_HEADER hdr;
	unsigned int oldrecno = rd->recno;
	unsigned int lastrec;
	void* buf = NULL;
	int i;
	unsigned int memoid;
	int oldbsize = rm->blocksize;
	unsigned char h[8];
	unsigned int mlen;
	char s = 0xaf;
	unsigned short int vlen;
	int er;

	memset(&hdr,0,sizeof(FPT_HEADER));
	if(bsize)
		rm->blocksize = bsize;
	if(step==0)
		step = 1;
	if(block && block->t.type == UNDEF_t)
		block = NULL;
	_rdd_put_backushort(hdr.blocksize,rm->blocksize);
	if(rm->format == FLEX_MEMO || rm->format == CLIP_MEMO){
		strcpy(hdr.sig,"FlexFile3");
		hdr.sig[9] = 3;
	}
	if(rm->format == CLIP_MEMO)
		strcpy(hdr.sig0,"Made by CLIP");
	if(rm->format == SIX_MEMO)
		strcpy(hdr.sig0,"SIxMemo");

	if(write(rm->file.fd,&hdr,sizeof(FPT_HEADER))!=sizeof(FPT_HEADER)) goto err;
	if((er = rd->vtbl->lastrec(cm,rd,&lastrec,__PROC__))) goto err1;

	for(rd->recno=1;rd->recno<=lastrec;rd->recno++){
		for(i=0;i<rd->nfields;i++){
			if(strchr("MPG",rd->fields[i].type)){
				if((er = rd->vtbl->getmemoid(cm,rd,i,&memoid,NULL,__PROC__)))
					goto err1;
				if(lseek(tmpfd,memoid*oldbsize,SEEK_SET) != memoid*oldbsize)
					goto err;
				if(read(tmpfd,h,8) != 8) goto err;
				mlen = _rdd_backuint(h+4);
				if(!(buf = malloc(mlen))) goto err;
				if(read(tmpfd,buf,mlen) != mlen) goto err;

				memoid = lseek(rm->file.fd,0,SEEK_CUR)/rm->blocksize;
				if(errno) goto err;
				if((er = rd->vtbl->setmemoid(cm,rd,i,memoid,__PROC__)))
					goto err1;
				if(write(rm->file.fd,h,8) != 8) goto err;
				if(write(rm->file.fd,buf,mlen) != mlen) goto err;
				mlen = rm->blocksize - ((mlen+9)%rm->blocksize);
				lseek(rm->file.fd,mlen,SEEK_CUR);
				if(errno) goto err;
				if(write(rm->file.fd,&s,1) != 1) goto err;
				free(buf); buf = NULL;
			} else if((rd->fields[i].type == 'V') && (rd->fields[i].len >= 6)){
				if((er = rd->vtbl->getmemoid(cm,rd,i,&memoid,&vlen,__PROC__)))
					goto err1;
				if(vlen<=rd->fields[i].len-2)
					continue;
				vlen -= rd->fields[i].len-6;
				if(lseek(tmpfd,memoid*oldbsize,SEEK_SET) != memoid*oldbsize)
					goto err;

				if(!(buf = malloc(vlen))) goto err;
				if(read(tmpfd,buf,vlen) != vlen) goto err;

				memoid = lseek(rm->file.fd,0,SEEK_CUR)/rm->blocksize;
				if(errno) goto err;
				if((er = rd->vtbl->setmemoid(cm,rd,i,memoid,__PROC__)))
					goto err1;
				if(write(rm->file.fd,buf,vlen) != vlen) goto err;
				if(vlen%rm->blocksize){
					mlen = rm->blocksize - (vlen%rm->blocksize);
					lseek(rm->file.fd,mlen-1,SEEK_CUR);
					if(errno) goto err;
					if(write(rm->file.fd,"",1) != 1) goto err;
				}
				free(buf); buf = NULL;
			}
		}
		if(block && rd->recno%step==0){
			ClipVar vv;
			if((er = rdd_calc(cm,rd->area,block,&vv,0))) goto err1;
			_clip_destroy(cm,&vv);
		}
	}
	memoid = lseek(rm->file.fd,0,SEEK_CUR)/rm->blocksize;
	if(lseek(rm->file.fd,0,SEEK_SET) != 0) goto err;
	_rdd_put_backuint(h,memoid);
	if(write(rm->file.fd,h,4) != 4) goto err;
	rd->recno = oldrecno;
	return 0;
err:
	er = rdd_err(cm,EG_WRITE,errno,__FILE__,__LINE__,__PROC__,"I/O error");
err1:
	if(buf)
		free(buf);
	rd->recno = oldrecno;
	return er;
}

static int fpt_getvchar(ClipMachine* cm,RDD_MEMO* rm,int len,unsigned int id,char* buf,const char* __PROC__){
	return rdd_read(cm,&rm->file,id*rm->blocksize,len,buf,__PROC__);
}

static int fpt_setvchar(ClipMachine* cm,RDD_MEMO* rm,int len,int oldlen,unsigned int* id,char* buf,const char* __PROC__){
	int oldbls = (oldlen+rm->blocksize-1)/rm->blocksize;
	int newbls = (len+rm->blocksize-1)/rm->blocksize;
	char m[4];
	int er;

	if((*id) && newbls <= oldbls){
		if((er = rdd_write(cm,&rm->file,(*id)*rm->blocksize,len,buf,__PROC__)))
			return er;
	} else {
		if((er = rdd_read(cm,&rm->file,0,4,m,__PROC__))) return er;
		*id = _rdd_backuint(m);
		if((er = rdd_write(cm,&rm->file,(*id)*rm->blocksize,len,buf,__PROC__)))
			return er;
		if(len%rm->blocksize){
			if((er = rdd_write(cm,&rm->file,(*id+newbls)*rm->blocksize-1,1,"",__PROC__)))
				return er;
		}
		_rdd_put_backuint(m,*id+newbls);
		if((er = rdd_write(cm,&rm->file,0,4,m,__PROC__))) return er;
	}
	return 0;
}

static RDD_MEMO_VTBL* fpt_vtbl(){
	RDD_MEMO_VTBL* vtbl = (RDD_MEMO_VTBL*)calloc(1,sizeof(RDD_MEMO_VTBL));

	strcpy(vtbl->id,"FPT");
	strcpy(vtbl->suff,".fpt");
	strcpy(vtbl->desc,"Generic FPT memo files driver v0.0.1 (c) 2001 Copyright ITK Ltd.");

	vtbl->create     = fpt_create;
	vtbl->pack       = fpt_pack;
	vtbl->zap        = fpt_zap;
	vtbl->open       = fpt_open;
	vtbl->close      = fpt_close;
	vtbl->getvalue   = fpt_getvalue;
	vtbl->setvalue   = fpt_setvalue;
	vtbl->getvchar   = fpt_getvchar;
	vtbl->setvchar   = fpt_setvchar;
	vtbl->getvalue64 = NULL;
	vtbl->setvalue64 = NULL;
	vtbl->getvchar64 = NULL;
	vtbl->setvchar64 = NULL;
	vtbl->info       = fpt_info;
	return vtbl;
}

