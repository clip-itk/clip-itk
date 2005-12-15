/*
	Copyright (C) 2001  ITK
	Author  : Rushad Nabiullin <rust@itk.ru>
	License : (GPL) http://www.itk.ru/clipper/license.html

	$Log: fpt.c,v $
	Revision 1.44  2005/12/09 16:52:13  clip
	
	crr
	
	Revision 1.43  2005/08/08 09:00:31  clip
	alena: fix for gcc 4

	Revision 1.42  2004/05/24 12:55:22  clip
	rust: full FlexFile support

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

#define FLEX_PAGESIZE   1024
#define FLEX_MAXLEAF    ((FLEX_PAGESIZE-10)/8)
#define FLEX_MAXPARENT  ((FLEX_PAGESIZE-10)/12)

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
	char sig0[16];
	char reserved2[488];
	char sig[12];
	char flexsize[4];
	char flexoffs[4];
	char reserved3[8];
	char sig1[4];
	char reserved4[480];
} FPT_HEADER;

static int fpt_create(ClipMachine* cm,char* name,const char* __PROC__){
	RDD_FILE file;
	FPT_HEADER hdr;
	int fuu,er;
	FPT_HEADER dum;

	memset(&hdr,0,sizeof(FPT_HEADER));
	memset(&dum,0,sizeof(FPT_HEADER));
	fuu = sizeof(FPT_HEADER)/cm->mblocksize;
	fuu += (fuu*cm->mblocksize<sizeof(FPT_HEADER))?1:0;
	_rdd_put_backuint((unsigned char *)hdr.fuu,fuu);
	_rdd_put_backushort((unsigned char *)hdr.blocksize,cm->mblocksize);
	strcpy(hdr.sig,"FlexFile3");
	strcpy(hdr.sig0,"Made by CLIP1");
	hdr.sig[9] = 3;
	_rdd_put_uint((unsigned char *)hdr.sig1,0x10);

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
	_rdd_put_backuint((unsigned char *)hdr.fuu,fuu);
	_rdd_put_uint((unsigned char *)hdr.flexsize,0);
	_rdd_put_uint((unsigned char *)hdr.flexoffs,0);
	return rdd_write(cm,&rm->file,0,sizeof(FPT_HEADER),&hdr,__PROC__);
}


static int fpt_open(ClipMachine* cm,RDD_DATA* rd,RDD_MEMO* rm,const char* __PROC__){
	FPT_HEADER hdr;
	int er;

	if((er = rdd_read(cm,&rm->file,0,sizeof(FPT_HEADER),&hdr,__PROC__)))
		return er;
	rm->blocksize = _rdd_backushort((unsigned char *)hdr.blocksize);
	if(memcmp(hdr.sig0,"SIxMemo",7) == 0)
		rm->format = SIX_MEMO;
	else if(memcmp(hdr.sig0,"Made by CLIP",12) == 0)
		rm->format = CLIP_MEMO;
	else if(memcmp(hdr.sig,"FlexFile3\03",9)==0)
		rm->format = FLEX_MEMO;

	/* Upgrade old dumb CLIP's FlexFile implementation to the right one.*/
	/* Thanks to Przemek (Przemyslaw Czerpak <druzus@priv.onet.pl>) */
	if(rm->format == CLIP_MEMO && !rd->readonly && !hdr.sig0[12]){
		hdr.sig0[12] = '1';
		_rdd_put_uint((unsigned char *)hdr.flexsize,0);
		_rdd_put_uint((unsigned char *)hdr.flexoffs,0);
		if((er = rdd_write(cm,&rm->file,0,sizeof(FPT_HEADER),&hdr,__PROC__)))
			return er;
	}
	return 0;
}


static int fpt_close(ClipMachine* cm,RDD_DATA* rd,RDD_MEMO* rm,const char* __PROC__){
	destroy_rdd_memo(rm);
	return 0;
}

static void _read_six_str(ClipVar* vp,DbfLocale* loc,char** str){
	vp->t.type = CHARACTER_t;
	*str += 2;
	vp->s.str.len = _rdd_uint((unsigned char *)(*str));
	*str += 12;
	vp->s.str.buf = *str;
	*str += vp->s.str.len;
	loc_read(loc,(unsigned char *)vp->s.str.buf,vp->s.str.len);
}

static void _read_six_int(ClipVar* vp,char** str){
	vp->t.type = NUMERIC_t;
	*str += 6;
	vp->n.d = (int)_rdd_uint((unsigned char *)(*str));
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
	vp->d.julian = _rdd_uint((unsigned char *)(*str));
	*str += 8;
}

static void _read_six_log(ClipVar* vp,char** str){
	vp->t.type = LOGICAL_t;
	*str += 6;
	vp->d.julian = _rdd_ushort((unsigned char *)(*str));
	*str += 8;
}

static void _read_six_array(ClipMachine* cm,ClipVar* vp,DbfLocale* loc,char** s,int len){
	char* b = *s;
	char* e = b+len;
	int size,i;
	long dims[1] = {0};

	_clip_array(cm,vp,1,dims);
	*s += 2;
	size = _rdd_uint((unsigned char *)(*s));
	*s += 12;
	for(i=0;i<size;i++){
		int type = _rdd_backushort((unsigned char *)(*s));
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
	len = _rdd_backuint((unsigned char *)(buf+4));
	str = malloc(len+1);
	if((er = rdd_read(cm,&rm->file,id*rm->blocksize+8,len,str,__PROC__)))
		return er;
	str[len] = 0;
	if(_rdd_backuint((unsigned char *)buf)==3){
		_clip_str2var(cm,vp,str,len,0);
		free(str);
	} else if(_rdd_backuint((unsigned char *)buf)==0x8000){
		s = str;
		_read_six_array(cm,vp,rm->loc,&str,len);
		free(s);
	} else {
		vp->s.str.buf = str;
		vp->s.str.len = len;
		if(_rdd_backuint((unsigned char *)buf)==1)
			loc_read(rm->loc,(unsigned char *)vp->s.str.buf,vp->s.str.len);
	}
	return 0;
}
/*
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
*/

typedef struct {
	unsigned int page;
	unsigned int li_offs;
	unsigned int li_size;
} FLEX_ITEM;

typedef struct _FLEX_TREE_ FLEX_TREE;
struct _FLEX_TREE_ {
	int root;
	int leaf;
	unsigned int offs;
	int count;
	int pos;
	FLEX_TREE* parent;
	FLEX_TREE* child;
	FLEX_ITEM* items;
};

static int _flex_splitbranch(ClipMachine* cm,RDD_MEMO* rm,FLEX_TREE* branch,int size,const char* __PROC__);
static int _flex_remove(ClipMachine* cm,RDD_MEMO* rm,FLEX_TREE* tree,int size,const char* __PROC__);

static void _flex_freetree(FLEX_TREE* tree){
	free(tree->items);
	if(tree->child)
		_flex_freetree(tree->child);
	free(tree);
}

static int _flex_newpage(ClipMachine* cm,RDD_MEMO* rm,unsigned int* page,int leaf,const char* __PROC__){
	char buf[FLEX_PAGESIZE-10];
	int er;
	int s;

	if(rm->flex_nremoved){
		rm->flex_nremoved--;
		*page = rm->flex_removed[rm->flex_nremoved];
		rm->flex_removed = (unsigned int*)realloc(rm->flex_removed,sizeof(int)*rm->flex_nremoved);
	} else {
		if((er = rdd_read(cm,&rm->file,0,4,buf,__PROC__)))
			return er;
		*page = _rdd_backuint((unsigned char *)buf)*rm->blocksize;
		_rdd_put_backuint((unsigned char *)buf,_rdd_backuint((unsigned char *)buf)+(FLEX_PAGESIZE/rm->blocksize));
		if((er = rdd_write(cm,&rm->file,0,4,buf,__PROC__)))
			return er;
	}
	_rdd_put_backuint((unsigned char *)buf,0x3e8);
	if((er = rdd_write(cm,&rm->file,*page,4,buf,__PROC__)))
		return er;
	if(leaf)
		s = FLEX_MAXLEAF*8;
	else
		s = FLEX_MAXPARENT*12;
	_rdd_put_backuint((unsigned char *)buf,s+2);
	if((er = rdd_write(cm,&rm->file,*page+4,4,buf,__PROC__)))
		return er;
	_rdd_put_ushort((unsigned char *)buf,leaf?3:2);
	if((er = rdd_write(cm,&rm->file,*page+8,2,buf,__PROC__)))
		return er;
	memset(buf,0xad,s);
	memset(buf+s,0,FLEX_PAGESIZE-10-s);
	if((er = rdd_write(cm,&rm->file,*page+10,sizeof(buf),buf,__PROC__)))
		return er;
	return 0;
}

static int __flex_search(ClipMachine* cm,RDD_MEMO* rm,FLEX_TREE* tree,int l,int size,const char* __PROC__){
	char buf[FLEX_PAGESIZE-10];
	int i,er;

	if((er = rdd_read(cm,&rm->file,tree->offs,4,buf,__PROC__)))
		return er;
	if(_rdd_backuint((unsigned char *)buf) != 0x3e8)
		return rdd_err(cm,EG_CORRUPTION,0,__FILE__,__LINE__,__PROC__,er_corruption);
	if((er = rdd_read(cm,&rm->file,tree->offs+8,2,buf,__PROC__)))
		return er;
	tree->count = _rdd_ushort((unsigned char *)buf)/4;
	tree->leaf = _rdd_ushort((unsigned char *)buf)%4==3;
	if(tree->count > (tree->leaf?FLEX_MAXLEAF:FLEX_MAXPARENT))
		return rdd_err(cm,EG_CORRUPTION,0,__FILE__,__LINE__,__PROC__,er_corruption);
	tree->items = calloc(tree->count,sizeof(FLEX_ITEM));
	if((er = rdd_read(cm,&rm->file,tree->offs+10,sizeof(buf),buf,__PROC__)))
		return er;
	for(i=0;i<tree->count;i++){
		if(tree->leaf){
			tree->items[i].li_size = _rdd_uint((unsigned char *)(buf+i*8+(size?0:4)));
			tree->items[i].li_offs = _rdd_uint((unsigned char *)(buf+i*8+(size?4:0)));
		} else {
			tree->items[i].li_size = _rdd_uint((unsigned char *)(buf+i*12+(size?0:4)));
			tree->items[i].li_offs = _rdd_uint((unsigned char *)(buf+i*12+(size?4:0)));
			tree->items[i].page = _rdd_uint((unsigned char *)(buf+i*12+8));
		}
	}
	tree->pos = 0;
	if(size){
		while((tree->items[tree->pos].li_size < l)
			&& (tree->pos < tree->count - !tree->leaf))
			tree->pos++;
	} else {
		while((tree->items[tree->pos].li_offs < l)
			&& (tree->pos < tree->count - !tree->leaf))
			tree->pos++;
	}
	if(!tree->leaf){
		tree->child = calloc(1,sizeof(FLEX_TREE));
		tree->child->offs = tree->items[tree->pos].page;
		tree->child->parent = tree;
		if((er = __flex_search(cm,rm,tree->child,l,size,__PROC__)))
			return er;
	}
	return 0;
}

static int _flex_search(ClipMachine* cm,RDD_MEMO* rm,FLEX_TREE** ptree,int l,int size,const char* __PROC__){
	FPT_HEADER hdr;
	FLEX_TREE* tree;
	unsigned int rootpage;
	int er;

	if((er = rdd_read(cm,&rm->file,0,sizeof(FPT_HEADER),&hdr,__PROC__)))
		return 0;
	tree = calloc(1,sizeof(FLEX_TREE));
	tree->root = 1;
	tree->offs = _rdd_uint((unsigned char *)(size?hdr.flexsize:hdr.flexoffs));
	if(!tree->offs){
		if((er = _flex_newpage(cm,rm,&rootpage,1,__PROC__)))
			goto err;
		_rdd_put_uint((unsigned char *)(size?hdr.flexsize:hdr.flexoffs),rootpage);
		if((er = rdd_write(cm,&rm->file,hdr.flexsize-hdr.fuu,8,&hdr.flexsize,__PROC__)))
			goto err;
		tree->leaf = 1;
		tree->offs = rootpage;
	} else {
		if((er = __flex_search(cm,rm,tree,l,size,__PROC__)))
			goto err;
	}
	*ptree = tree;
	return er;
err:
	_flex_freetree(tree);
	return er;
}

static FLEX_TREE* _flex_leaf(FLEX_TREE* tree){
	FLEX_TREE* leaf = tree;

	while(leaf->child) leaf = leaf->child;
	return leaf;
}

static int _flex_first(ClipMachine* cm,RDD_MEMO* rm,FLEX_TREE* tree,const char* __PROC__){
	char buf[FLEX_PAGESIZE];
        int er,i;

        tree->child = calloc(1, sizeof(FLEX_TREE));
        tree->child->parent = tree;
        tree->child->offs = tree->items[tree->pos].page;
	if((er = rdd_read(cm,&rm->file,tree->child->offs,4,buf,__PROC__)))
		return er;
	if(_rdd_backuint((unsigned char *)buf) != 0x3e8)
		return rdd_err(cm,EG_CORRUPTION,0,__FILE__,__LINE__,__PROC__,er_corruption);
	if((er = rdd_read(cm,&rm->file,tree->child->offs+8,2,buf,__PROC__)))
		return er;
	tree->child->count = _rdd_ushort((unsigned char *)buf)/4;
	tree->child->leaf = _rdd_ushort((unsigned char *)buf)%4==3;
	if(tree->child->count > (tree->child->leaf?FLEX_MAXLEAF:FLEX_MAXPARENT))
		return rdd_err(cm,EG_CORRUPTION,0,__FILE__,__LINE__,__PROC__,er_corruption);
	tree->child->items = calloc(tree->child->count,sizeof(FLEX_ITEM));
	if((er = rdd_read(cm,&rm->file,tree->child->offs+10,sizeof(buf),buf,__PROC__)))
		return er;
	for(i=0;i<tree->child->count;i++){
		if(tree->child->leaf){
			tree->child->items[i].li_size = _rdd_uint((unsigned char *)(buf+i*8+0));
			tree->child->items[i].li_offs = _rdd_uint((unsigned char *)(buf+i*8+4));
		} else {
			tree->child->items[i].li_size = _rdd_uint((unsigned char *)(buf+i*12+0));
			tree->child->items[i].li_offs = _rdd_uint((unsigned char *)(buf+i*12+4));
			tree->child->items[i].page = _rdd_uint((unsigned char *)(buf+i*12+8));
		}
	}
	tree->child->pos = 0;
        if(!tree->child->leaf)
		if((er = _flex_first(cm,rm,tree->child,__PROC__)))
                	return er;
	return 0;
}

static int __flex_next(ClipMachine* cm,RDD_MEMO* rm,FLEX_TREE* tree,int *out,int *ok,const char* __PROC__){
	FLEX_TREE* parent;
	int er;

	*out = 0;
        *ok = 0;
	tree->pos++;
	if(tree->pos >= tree->count){
		parent = tree->parent;
		if(parent){
			if((er = __flex_next(cm,rm,parent,out,ok,__PROC__)))
				return er;
			if(*out || *ok)
				return 0;
			_flex_freetree(tree);
	    		if((er = _flex_first(cm,rm,parent,__PROC__)))
                        	return er;
			*ok = 1;
		} else {
			*out = 1;
		}
	}
	return 0;
}

static int _flex_next(ClipMachine* cm,RDD_MEMO* rm,FLEX_TREE* tree,int *out,const char* __PROC__){
	int ok;
	tree = _flex_leaf(tree);
        return __flex_next(cm,rm,tree,out,&ok,__PROC__);
}

static int _flex_last(ClipMachine* cm,RDD_MEMO* rm,FLEX_TREE* tree,const char* __PROC__){
	char buf[FLEX_PAGESIZE];
        int er,i;

        tree->child = calloc(1, sizeof(FLEX_TREE));
        tree->child->parent = tree;
        tree->child->offs = tree->items[tree->pos].page;
	if((er = rdd_read(cm,&rm->file,tree->child->offs,4,buf,__PROC__)))
		return er;
	if(_rdd_backuint((unsigned char *)buf) != 0x3e8)
		return rdd_err(cm,EG_CORRUPTION,0,__FILE__,__LINE__,__PROC__,er_corruption);
	if((er = rdd_read(cm,&rm->file,tree->child->offs+8,2,buf,__PROC__)))
		return er;
	tree->child->count = _rdd_ushort((unsigned char *)buf)/4;
	tree->child->leaf = _rdd_ushort((unsigned char *)buf)%4==3;
	if(tree->child->count > (tree->child->leaf?FLEX_MAXLEAF:FLEX_MAXPARENT))
		return rdd_err(cm,EG_CORRUPTION,0,__FILE__,__LINE__,__PROC__,er_corruption);
	tree->child->items = calloc(tree->child->count,sizeof(FLEX_ITEM));
	if((er = rdd_read(cm,&rm->file,tree->child->offs+10,sizeof(buf),buf,__PROC__)))
		return er;
	for(i=0;i<tree->child->count;i++){
		if(tree->child->leaf){
			tree->child->items[i].li_size = _rdd_uint((unsigned char *)(buf+i*8+4));
			tree->child->items[i].li_offs = _rdd_uint((unsigned char *)(buf+i*8+0));
		} else {
			tree->child->items[i].li_size = _rdd_uint((unsigned char *)(buf+i*12+4));
			tree->child->items[i].li_offs = _rdd_uint((unsigned char *)(buf+i*12+0));
			tree->child->items[i].page = _rdd_uint((unsigned char *)(buf+i*12+8));
		}
	}
	tree->child->pos = tree->child->count-1;
        if(!tree->child->leaf)
		if((er = _flex_last(cm,rm,tree->child,__PROC__)))
                	return er;
	return 0;
}

static int __flex_prev(ClipMachine* cm,RDD_MEMO* rm,FLEX_TREE* tree,int* out,int *ok,const char* __PROC__){
	FLEX_TREE* parent;
	int er;

	*out = 0;
        *ok = 0;
	tree->pos--;
	if(tree->pos < 0){
		parent = tree->parent;
		if(parent){
			if((er = __flex_prev(cm,rm,parent,out,ok,__PROC__)))
				return er;
			if(*out || *ok)
				return 0;
			_flex_freetree(tree);
			if((er = _flex_last(cm,rm,parent,__PROC__)))
                        	return er;
			*ok = 1;
		} else {
			*out = 1;
		}
	}
	return 0;
}

static int _flex_prev(ClipMachine* cm,RDD_MEMO* rm,FLEX_TREE* tree,int* out,const char* __PROC__){
	int ok;
	tree = _flex_leaf(tree);
        return __flex_prev(cm,rm,tree,out,&ok,__PROC__);
}

static int _flex_exactsearch(ClipMachine* cm,RDD_MEMO* rm,FLEX_TREE** ptree,unsigned int noffs,int nl,const char* __PROC__){
	FLEX_TREE* leaf;
	int out = 0,er;

	if((er = _flex_search(cm,rm,ptree,nl,1,__PROC__)))
		return er;
	leaf = _flex_leaf(*ptree);
	while((leaf->pos < leaf->count) && (leaf->items[leaf->pos].li_offs != noffs)){
		if((er = _flex_next(cm,rm,*ptree,&out,__PROC__)))
			return er;
		leaf = _flex_leaf(*ptree);
	}
	if(out)
		return rdd_err(cm,EG_CORRUPTION,0,__FILE__,__LINE__,__PROC__,er_corruption);
	return 0;
}

static FLEX_TREE* _flex_root(FLEX_TREE* tree){
	FLEX_TREE* root = tree;

	while(root->parent) root = root->parent;
	return root;
}

int _flex_saveleaf(ClipMachine* cm,RDD_MEMO* rm,FLEX_TREE* leaf,int size,const char* __PROC__){
	char buf[FLEX_PAGESIZE-10];
	char cb[2];
	int i,er;

	memset(buf,0xAD,FLEX_MAXLEAF*8);
	memset(buf+FLEX_MAXLEAF*8,0,sizeof(buf)-FLEX_MAXLEAF*8);
	for(i=0;i<leaf->count;i++){
		_rdd_put_uint((unsigned char *)(buf+i*8+(size?0:4)),leaf->items[i].li_size);
		_rdd_put_uint((unsigned char *)(buf+i*8+(size?4:0)),leaf->items[i].li_offs);
	}
	_rdd_put_ushort((unsigned char *)cb,(short)(leaf->count*4+3));
	if((er = rdd_write(cm,&rm->file,leaf->offs+8,2,cb,__PROC__)))
		return er;
	if((er = rdd_write(cm,&rm->file,leaf->offs+10,sizeof(buf),buf,__PROC__)))
		return er;
	return 0;
}

int _flex_savebranch(ClipMachine* cm,RDD_MEMO* rm,FLEX_TREE* branch,int size,const char* __PROC__){
	char buf[FLEX_PAGESIZE-10];
	char cb[2];
	int i,er;

	memset(buf,0xAD,FLEX_MAXPARENT*12);
	memset(buf+FLEX_MAXPARENT*12,0,sizeof(buf)-FLEX_MAXPARENT*12);
	for(i=0;i<branch->count;i++){
		_rdd_put_uint((unsigned char *)(buf+i*12+(size?0:4)),branch->items[i].li_size);
		_rdd_put_uint((unsigned char *)(buf+i*12+(size?4:0)),branch->items[i].li_offs);
		_rdd_put_uint((unsigned char *)(buf+i*12+8),branch->items[i].page);
	}
	_rdd_put_ushort((unsigned char *)cb,(short)(branch->count*4+2));
	if((er = rdd_write(cm,&rm->file,branch->offs+8,2,cb,__PROC__)))
		return er;
	if((er = rdd_write(cm,&rm->file,branch->offs+10,sizeof(buf),buf,__PROC__)))
		return er;
	return 0;
}

static int _flex_addstick(ClipMachine* cm,RDD_MEMO* rm,FLEX_TREE* child,unsigned int newpage,FLEX_ITEM* left,FLEX_ITEM* right,int size,const char* __PROC__){
	FLEX_TREE* parent = child->parent;
	int er;

	if(!parent){
		FPT_HEADER* hdr = NULL;
		unsigned int newroot;
		char buf[4];

		if((er = _flex_newpage(cm,rm,&newroot,0,__PROC__)))
			return er;
		_rdd_put_uint((unsigned char *)buf,newroot);
		if((er = rdd_write(cm,&rm->file,(int)(size?&hdr->flexsize:&hdr->flexoffs),4,buf,__PROC__)))
			return er;

		parent = (FLEX_TREE*)calloc(1,sizeof(FLEX_TREE));
		parent->root = 1;
		parent->offs = newroot;
		parent->child = child;
		child->parent = parent;
		parent->items = (FLEX_ITEM*)calloc(1,sizeof(FLEX_ITEM));
		parent->count = 1;
	}
	if((parent->count < 0) || (parent->count > FLEX_MAXPARENT))
		return rdd_err(cm,EG_CORRUPTION,0,__FILE__,__LINE__,__PROC__,er_corruption);
	if(parent->count == FLEX_MAXPARENT){
		if((er = _flex_splitbranch(cm,rm,parent,size,__PROC__)))
			return er;
	}
	parent->items = (FLEX_ITEM*)realloc(parent->items,sizeof(FLEX_ITEM)*(parent->count+1));
	memmove(parent->items+parent->pos+2,parent->items+parent->pos+1,12*(parent->count-parent->pos-1));
	parent->items[parent->pos].page = child->offs;
	parent->items[parent->pos].li_offs = left->li_offs;
	parent->items[parent->pos].li_size = left->li_size;
	parent->items[parent->pos+1].page = newpage;
	parent->items[parent->pos+1].li_offs = right->li_offs;
	parent->items[parent->pos+1].li_size = right->li_size;
	parent->count++;
	if((er = _flex_savebranch(cm,rm,parent,size,__PROC__)))
		return er;
	return 0;
}

static int _flex_splitbranch(ClipMachine* cm,RDD_MEMO* rm,FLEX_TREE* branch,int size,const char* __PROC__){
	char buf[FLEX_PAGESIZE];
	char newbuf[FLEX_PAGESIZE];
	int half = branch->count/2;
	unsigned int newpage;
	int er;

	if((er = rdd_read(cm,&rm->file,branch->offs,FLEX_PAGESIZE,buf,__PROC__)))
		return er;
	if(_rdd_backuint((unsigned char *)buf) != 0x3e8)
		return rdd_err(cm,EG_CORRUPTION,0,__FILE__,__LINE__,__PROC__,er_corruption);

	_rdd_put_ushort((unsigned char *)(newbuf+8),(short)((branch->count-half)*4+2));
	memset(newbuf+10,0,FLEX_PAGESIZE-10);
	memset(newbuf+10,0xAD,FLEX_MAXPARENT*12);
	memcpy(newbuf+10,buf+10+half*12,(branch->count-half)*12);
	if((er = _flex_newpage(cm,rm,&newpage,0,__PROC__)))
		return er;
	if((er = rdd_write(cm,&rm->file,newpage+8,FLEX_PAGESIZE-8,newbuf+8,__PROC__)))
		return er;

	_rdd_put_ushort((unsigned char *)(buf+8),(short)(half*4+2));
	memset(buf+10+half*12,0xAD,(branch->count-half)*12);
	memset(buf+10+branch->count*12,0,FLEX_PAGESIZE-(10+branch->count*12));
	if((er = rdd_write(cm,&rm->file,branch->offs+8,FLEX_PAGESIZE-8,buf+8,__PROC__)))
		return er;

	if((er = _flex_addstick(cm,rm,branch,newpage,branch->items+(half-1),branch->items+(branch->count-1),size,__PROC__)))
		return er;
	if(branch->pos < half){
		branch->items = (FLEX_ITEM*)realloc(branch->items,sizeof(FLEX_ITEM)*half);
		branch->count = half;
	} else {
		branch->pos -= half;
		memmove(branch->items,branch->items+half,sizeof(FLEX_ITEM)*(branch->count-half));
		branch->count -= half;
		branch->offs = newpage;
		branch->parent->pos++;
	}
	branch->root = 0;
	return 0;
}

static int _flex_splitleaf(ClipMachine* cm,RDD_MEMO* rm,FLEX_TREE* leaf,int size,const char* __PROC__){
	char buf[FLEX_PAGESIZE];
	char newbuf[FLEX_PAGESIZE];
	int half = leaf->count/2;
	unsigned int newpage;
	int er;

	if((er = rdd_read(cm,&rm->file,leaf->offs,FLEX_PAGESIZE,buf,__PROC__)))
		return er;
	if(_rdd_backuint((unsigned char *)buf) != 0x3e8)
		return rdd_err(cm,EG_CORRUPTION,0,__FILE__,__LINE__,__PROC__,er_corruption);

	_rdd_put_ushort((unsigned char *)(newbuf+8),(short)((leaf->count-half)*4+3));
	memset(newbuf+10,0,FLEX_PAGESIZE-10);
	memset(newbuf+10,0xAD,FLEX_MAXLEAF*8);
	memcpy(newbuf+10,buf+10+half*8,(leaf->count-half)*8);
	if((er = _flex_newpage(cm,rm,&newpage,1,__PROC__)))
		return er;
	if((er = rdd_write(cm,&rm->file,newpage+8,FLEX_PAGESIZE-8,newbuf+8,__PROC__)))
		return er;

	_rdd_put_ushort((unsigned char *)(buf+8),(short)(half*4+3));
	memset(buf+10+half*8,0xAD,(leaf->count-half)*8);
	memset(buf+10+leaf->count*8,0,FLEX_PAGESIZE-(10+leaf->count*8));
	if((er = rdd_write(cm,&rm->file,leaf->offs+8,FLEX_PAGESIZE-8,buf+8,__PROC__)))
		return er;

	if((er = _flex_addstick(cm,rm,leaf,newpage,leaf->items+(half-1),leaf->items+(leaf->count-1),size,__PROC__)))
		return er;
	if(leaf->pos < half){
		leaf->items = (FLEX_ITEM*)realloc(leaf->items,sizeof(FLEX_ITEM)*half);
		leaf->count = half;
	} else {
		leaf->pos -= half;
		memmove(leaf->items,leaf->items+half,sizeof(FLEX_ITEM)*(leaf->count-half));
		leaf->count -= half;
		leaf->offs = newpage;
		leaf->parent->pos++;
	}
	leaf->root = 0;
	return 0;
}

static int _flex_setlastitem(ClipMachine* cm,RDD_MEMO* rm,FLEX_TREE* branch,FLEX_ITEM* item,int size,const char* __PROC__){
	FLEX_ITEM* ci;
	int er;

	if(!branch)
		return 0;
	ci = branch->items+branch->pos;
	ci->li_offs = item->li_offs;
	ci->li_size = item->li_size;
	if((er = _flex_savebranch(cm,rm,branch,size,__PROC__)))
		return er;
	if(branch->pos == branch->count-1){
		if((er = _flex_setlastitem(cm,rm,branch->parent,item,size,__PROC__)))
			return er;
	}
	return er;
}

static int _flex_add(ClipMachine* cm,RDD_MEMO* rm,FLEX_TREE* tree,unsigned int offs,int l,int size,const char* __PROC__){
	FLEX_TREE* leaf = _flex_leaf(tree);
	int er;

	if((leaf->count < 0) || (leaf->count > FLEX_MAXLEAF))
		return rdd_err(cm,EG_CORRUPTION,0,__FILE__,__LINE__,__PROC__,er_corruption);
	if(leaf->count == FLEX_MAXLEAF){
		if((er = _flex_splitleaf(cm,rm,leaf,size,__PROC__)))
			return er;
	}
	leaf->items = realloc(leaf->items,sizeof(FLEX_ITEM)*(leaf->count+1));
	memmove(leaf->items+leaf->pos+1,leaf->items+leaf->pos,sizeof(FLEX_ITEM)*(leaf->count-leaf->pos));
	leaf->items[leaf->pos].li_offs = offs;
	leaf->items[leaf->pos].li_size = l;
	leaf->count++;
	if((er = _flex_saveleaf(cm,rm,leaf,size,__PROC__)))
		return er;
	if(leaf->pos == leaf->count-1){
		if((er = _flex_setlastitem(cm,rm,leaf->parent,leaf->items+(leaf->count-1),size,__PROC__)))
			return er;
	}
	return 0;
}

static int _flex_freeblock(ClipMachine* cm,RDD_MEMO* rm,unsigned int offs,int l,const char* __PROC__){
	FLEX_TREE* tree = NULL;
	FLEX_TREE* leaf = NULL;
	unsigned int noffs;
	int nl,out,er;
	char buf[4];

	if((er = _flex_search(cm,rm,&tree,offs,0,__PROC__)))
		return er;
	leaf = _flex_leaf(tree);
	if((leaf->pos < leaf->count) && (offs+l == leaf->items[leaf->pos].li_offs)){
		noffs = offs+l;
		nl = leaf->items[leaf->pos].li_size;
		if((er = _flex_remove(cm,rm,tree,0,__PROC__)))
			return er;
		_flex_freetree(tree);

		if((er = _flex_exactsearch(cm,rm,&tree,noffs,nl,__PROC__)))
			return er;
		if((er = _flex_remove(cm,rm,tree,1,__PROC__)))
			return er;
		_flex_freetree(tree);

		l += nl;
		if((er = _flex_search(cm,rm,&tree,offs,0,__PROC__)))
			return er;
	} else {
		if((er = _flex_prev(cm,rm,tree,&out,__PROC__)))
			return er;
		if(!out){
			leaf = _flex_leaf(tree);
			nl = leaf->items[leaf->pos].li_size;
			noffs = leaf->items[leaf->pos].li_offs;
			if(noffs+nl == offs){
				if((er = _flex_remove(cm,rm,tree,0,__PROC__)))
					return er;
				_flex_freetree(tree);

				if((er = _flex_exactsearch(cm,rm,&tree,noffs,nl,__PROC__)))
					return er;
				if((er = _flex_remove(cm,rm,tree,1,__PROC__)))
					return er;

				offs = noffs;
				l += nl;
			}
		}
		_flex_freetree(tree);
		if((er = _flex_search(cm,rm,&tree,offs,0,__PROC__)))
			return er;
	}

	_rdd_put_backuint((unsigned char *)buf,0x3e9);
	if((er = rdd_write(cm,&rm->file,offs,4,buf,__PROC__)))
		return er;
	_rdd_put_backuint((unsigned char *)buf,l-8);
	if((er = rdd_write(cm,&rm->file,offs+4,4,buf,__PROC__)))
		return er;

	if((er = _flex_add(cm,rm,tree,offs,l,0,__PROC__)))
		return er;
	tree = _flex_root(tree);
	_flex_freetree(tree);

	if((er = _flex_search(cm,rm,&tree,l,1,__PROC__)))
		return er;
	if((er = _flex_add(cm,rm,tree,offs,l,1,__PROC__)))
		return er;
	tree = _flex_root(tree);
	_flex_freetree(tree);

	return 0;
}

static int flex_freeblock(ClipMachine* cm,RDD_MEMO* rm,int id,const char* __PROC__){
	unsigned int offs = id*rm->blocksize;
	char buf[4];
	int len,b,l,er;

	if(id && (rm->format == CLIP_MEMO || rm->format == FLEX_MEMO)){
		if((er = rdd_read(cm,&rm->file,offs+4,4,buf,__PROC__)))
			return er;
		len = _rdd_backuint((unsigned char *)buf);
		b = (len+8+(rm->blocksize-1))/rm->blocksize;
		l = b*rm->blocksize;

		if((er = _flex_freeblock(cm,rm,offs,l,__PROC__)))
			return er;
/*
		for(i=0;i<rm->flex_nremoved;i++){
			if((er = _flex_freeblock(cm,rm,rm->flex_removed[i],FLEX_PAGESIZE,__PROC__)))
				return er;
		}
		free(rm->flex_removed);
		rm->flex_removed = NULL;
		rm->flex_nremoved = 0;
*/
	}
	return 0;
}

static int _flex_removestick(ClipMachine* cm,RDD_MEMO* rm,FLEX_TREE* child,int size,const char* __PROC__){
	FLEX_TREE* parent = child->parent;
	int er;

	if(parent){
		if(parent->count == 1){
			rm->flex_removed = realloc(rm->flex_removed,(rm->flex_nremoved+1)*sizeof(unsigned int));
			rm->flex_removed[rm->flex_nremoved] = parent->offs;
			rm->flex_nremoved++;

			if((er = _flex_removestick(cm,rm,parent,size,__PROC__)))
				return er;
		} else {
			memmove(parent->items+parent->pos,parent->items+parent->pos+1,sizeof(FLEX_ITEM)*(parent->count-parent->pos-1));
			parent->count--;
			parent->items = (FLEX_ITEM*)realloc(parent->items,sizeof(FLEX_ITEM)*parent->count);
			if((er = _flex_savebranch(cm,rm,parent,size,__PROC__)))
				return er;
			if(parent->pos == parent->count){
				if((er = _flex_setlastitem(cm,rm,parent->parent,parent->items+(parent->count-1),size,__PROC__)))
					return er;
			}
		}
	}
/*
	else {
		char buf[4];
		int pos = (size?(char*)&hdr->flexsize:(char*)&hdr->flexoffs)-(char*)hdr;

		_rdd_put_uint(buf,0);
		if((er = rdd_write(cm,&rm->file,pos,4,buf,__PROC__)))
			return er;
	}
*/
	return 0;
}

static int _flex_remove(ClipMachine* cm,RDD_MEMO* rm,FLEX_TREE* tree,int size,const char* __PROC__){
	FLEX_TREE* leaf = _flex_leaf(tree);
	int er;

	if(leaf->count == 1 && leaf->parent){
		rm->flex_removed = realloc(rm->flex_removed,(rm->flex_nremoved+1)*sizeof(unsigned int));
		rm->flex_removed[rm->flex_nremoved] = leaf->offs;
		rm->flex_nremoved++;

		if((er = _flex_removestick(cm,rm,leaf,size,__PROC__)))
			return er;
	} else {
		memmove(leaf->items+leaf->pos,leaf->items+leaf->pos+1,sizeof(FLEX_ITEM)*(leaf->count-leaf->pos-1));
		leaf->count--;
		leaf->items = (FLEX_ITEM*)realloc(leaf->items,sizeof(FLEX_ITEM)*leaf->count);
		if((er = _flex_saveleaf(cm,rm,leaf,size,__PROC__)))
			return er;
		if(leaf->pos == leaf->count){
			if((er = _flex_setlastitem(cm,rm,leaf->parent,leaf->items+(leaf->count-1),size,__PROC__)))
				return er;
		}
	}
	return 0;
}

static int flex_useblock(ClipMachine* cm,RDD_MEMO* rm,int* id,int len,const char* __PROC__){
	FLEX_TREE* tree = NULL;
	FLEX_TREE* leaf = NULL;
	char fuu[4];
	int b,l,offs,ll,er;

	if(len==0){
		*id = 0;
		return 0;
	}

	b = (len+8+(rm->blocksize-1))/rm->blocksize;
	l = b*rm->blocksize;
	if((er = _flex_search(cm,rm,&tree,l,1,__PROC__)))
		goto err;
	leaf = _flex_leaf(tree);
	if(leaf->pos < leaf->count){
		offs = leaf->items[leaf->pos].li_offs;
		ll = leaf->items[leaf->pos].li_size;
		*id = offs / rm->blocksize;
		if((er = _flex_remove(cm,rm,tree,1,__PROC__)))
			goto err;
		_flex_freetree(tree);
		if((er = _flex_search(cm,rm,&tree,*id*rm->blocksize,0,__PROC__)))
			goto err;
		if((er = _flex_remove(cm,rm,tree,0,__PROC__)))
			goto err;

		if(ll > l){
			if((er = _flex_freeblock(cm,rm,offs+l,ll-l,__PROC__)))
				return er;
		}
	} else {
		if((er = rdd_read(cm,&rm->file,0,4,fuu,__PROC__)))
			goto err;
		*id = _rdd_backuint((unsigned char *)fuu);
		_rdd_put_backuint((unsigned char *)fuu,*id+b);
		if((er = rdd_write(cm,&rm->file,0,4,fuu,__PROC__)))
			goto err;
	}
	_flex_freetree(tree);
/*
	for(i=0;i<rm->flex_nremoved;i++){
		if((er = _flex_freeblock(cm,rm,rm->flex_removed[i],FLEX_PAGESIZE,__PROC__)))
			return er;
	}
	free(rm->flex_removed);
	rm->flex_removed = NULL;
	rm->flex_nremoved = 0;
*/
	return 0;
err:
	_flex_freetree(tree);
	return er;
}

static int _fpt_setvalue(ClipMachine* cm,RDD_MEMO* rm,int id,int type,char* str,int len,const char* __PROC__){
	char buf[4];
	int l = ((len+8)+rm->blocksize-1)/rm->blocksize;
	int tl = l*rm->blocksize-(len+8);
	unsigned int offs = id*rm->blocksize;
	char* tail;
	int er;

	if(!id)
		return 0;
	_rdd_put_backuint((unsigned char *)buf,type);
	if((er = rdd_write(cm,&rm->file,offs,4,buf,__PROC__)))
		return er;
	_rdd_put_backuint((unsigned char *)buf,len);
	if((er = rdd_write(cm,&rm->file,offs+4,4,buf,__PROC__)))
		return er;
	if((er = rdd_write(cm,&rm->file,offs+8,len,str,__PROC__)))
		return er;
	if(tl > 0){
		if(tl>1){
			tail = calloc(1,tl-1);
			if((er = rdd_write(cm,&rm->file,offs+8+len,tl-1,tail,__PROC__))){
				free(tail);
				return er;
			}
			free(tail);
		}
		buf[0] = 0xAF;
		if((er = rdd_write(cm,&rm->file,offs+l*rm->blocksize-1,1,buf,__PROC__)))
			return er;
	}
	return 0;
}

static int fpt_setvalue(ClipMachine* cm,RDD_MEMO* rm,int* id,ClipVar* vp,int binary,const char* __PROC__){
	long l;
	int type,i,er;
	char* str = NULL;

	if(vp->t.type != CHARACTER_t){
		_clip_var2str(cm,vp,&str,&l,0);
	} else {
		l = vp->s.str.len;
		str = _clip_memdup(vp->s.str.buf,l);
		if(!binary)
			loc_write(rm->loc,(unsigned char *)str,l);
	}

	if(vp->t.type != CHARACTER_t){
		type = 3;
	} else {
		type = (binary==0);
	}
	if((er = flex_freeblock(cm,rm,*id,__PROC__))) goto err;
	if((er = flex_useblock(cm,rm,id,l,__PROC__))) goto err;

	for(i=0;i<rm->flex_nremoved;i++){
		if((er = _flex_freeblock(cm,rm,rm->flex_removed[i],FLEX_PAGESIZE,__PROC__)))
			return er;
	}
	free(rm->flex_removed);
	rm->flex_removed = NULL;
	rm->flex_nremoved = 0;

	if((er = _fpt_setvalue(cm,rm,*id,type,str,l,__PROC__))) goto err;
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
	_rdd_put_backushort((unsigned char *)hdr.blocksize,rm->blocksize);
	if(rm->format == FLEX_MEMO || rm->format == CLIP_MEMO){
		strcpy(hdr.sig,"FlexFile3");
		hdr.sig[9] = 3;
	}
	if(rm->format == CLIP_MEMO)
		strcpy(hdr.sig0,"Made by CLIP");
	if(rm->format == SIX_MEMO)
		strcpy(hdr.sig0,"SIxMemo");

	if(write(rm->file.fd,&hdr,sizeof(FPT_HEADER))!=sizeof(FPT_HEADER)) goto err;
	if((er = rd->vtbl->lastrec(cm,rd,(int *)&lastrec,__PROC__))) goto err1;

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
		*id = _rdd_backuint((unsigned char *)m);
		if((er = rdd_write(cm,&rm->file,(*id)*rm->blocksize,len,buf,__PROC__)))
			return er;
		if(len%rm->blocksize){
			if((er = rdd_write(cm,&rm->file,(*id+newbls)*rm->blocksize-1,1,"",__PROC__)))
				return er;
		}
		_rdd_put_backuint((unsigned char *)m,*id+newbls);
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

