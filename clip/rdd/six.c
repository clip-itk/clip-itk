/*
	Copyright (C) 2001  ITK
	Author   : Rushad Nabiullin <rust@itk.ru>
	License : (GPL) http://www.itk.ru/clipper/license.html

	$Log: six.c,v $
	Revision 1.71  2002/10/11 10:33:10  clip
	rust: m6_IsOptimize()
	
	Revision 1.70  2002/10/11 09:11:13  clip
	rust: m6_FiltSave()/m6_FiltRestore()

	Revision 1.69  2002/10/08 08:04:59  clip
	rust: small fix

	Revision 1.68  2002/10/01 11:28:52  clip
	rust: m6_dbEval()

	Revision 1.67  2002/10/01 11:04:36  clip
	rust: m6_ChgOwner()

	Revision 1.66  2002/09/30 13:32:19  clip
	rust: m6_AddScoped()

	Revision 1.65  2002/09/27 13:50:42  clip
	rust: m6_RecCount()

	Revision 1.64  2002/09/25 13:17:03  clip
	rust: compatibility of INDEX ON behavior and some cleanups

	Revision 1.63  2002/09/19 12:52:05  clip
	rust: bug in Sx_SlimFast()

	Revision 1.62  2002/08/30 10:16:35  clip
	rust: rddsetfilter(<handle>,<cFilter>,<aAliases>) (<aAliases> added)

	Revision 1.61  2002/08/26 14:37:28  clip
	rust: warnings avoided

	Revision 1.60  2002/08/26 11:41:52  clip
	rust: rdd_open() added

	Revision 1.59  2002/08/16 11:48:23  clip
	rust: small fix

	Revision 1.58  2002/08/15 07:15:20  clip
	rust: avoiding warning

	Revision 1.57  2002/08/02 13:40:09  clip
	rust fixes

	Revision 1.56  2002/08/02 11:09:10  clip
	rust: RM_*() => SX_*(), M6_*()

	Revision 1.55  2002/07/25 12:45:19  clip
	rust: Sx_TableName() returns the file name with suffix

	Revision 1.54  2002/04/23 12:03:39  clip
	rust: use _clip_open()

	Revision 1.53  2002/04/23 11:42:38  clip
	rust: use _clip_creat

	Revision 1.52  2002/04/23 11:15:04  clip
	rust: ncpfs fixes

	Revision 1.51  2002/04/03 11:29:08  clip
	rust: [ORD|SX_]KEY[COUNT|NO] without controlling order return [LASTREC|RECNO]()

	Revision 1.50  2002/03/22 11:44:28  clip
	rust: error messages

	Revision 1.49  2002/03/20 14:51:16  clip
	rust: big cleaning

	Revision 1.48  2002/03/20 13:26:08  clip
	rust: big cleaning

	Revision 1.47  2002/03/20 11:03:05  clip
	rust: RDD_Info() without parameter

	Revision 1.46  2002/03/09 14:21:15  clip
	rust: Sx_TableType()

	Revision 1.45  2002/03/09 11:41:57  clip
	rust: SX_DESCEND()

	Revision 1.44  2002/02/15 11:31:00  clip
	rust: -O warnings cleanup

	Revision 1.43  2002/01/16 12:04:56  clip
	rust: some fixes

	Revision 1.42  2002/01/04 12:27:15  clip
	some fixes
	rust

	Revision 1.41  2002/01/02 13:38:22  clip
	Sx_Tags(), Sx_TagUnique()
	rust

	Revision 1.40  2002/01/02 12:51:10  clip
	Sx_TagInfo()
	rust

	Revision 1.39  2001/12/26 15:53:38  clip
	Sx_TagName(), Sx_TagNo(), Sx_TagOrder()
	rust

	Revision 1.38  2001/12/26 15:41:32  clip
	Sx_TagCount()
	rust

	Revision 1.37  2001/12/26 13:26:43  clip
	Sx_Step()
	rust

	Revision 1.36  2001/12/26 12:59:16  clip
	Sx_SlimFast()
	rust

	Revision 1.35  2001/12/26 12:36:30  clip
	Sx_SetTagNo()
	rust

	Revision 1.34  2001/12/26 12:20:24  clip
	Sx_SetTag()
	rust

	Revision 1.33  2001/12/25 11:36:29  clip
	Sx_SetFileOrd()
	rust

	Revision 1.32  2001/12/25 11:14:45  clip
	Sx_SeekLast()
	rust

	Revision 1.31  2001/12/25 10:48:23  clip
	Sx_RollBack()
	rust

	Revision 1.30  2001/12/25 09:26:39  clip
	Sx_RLock()
	rust

	Revision 1.29  2001/12/24 14:21:10  clip
	Sx_MemoExt()
	rust

	Revision 1.28  2001/12/24 13:47:30  clip
	Sx_KillTag()
	rust

	Revision 1.27  2001/12/22 11:01:41  clip
	Sx_KeysIncluded()
	rust

	Revision 1.26  2001/12/22 10:01:00  clip
	several six functions
	rust

	Revision 1.25  2001/12/21 12:22:12  clip
	Sx_KeyNo() -> ORDKEYNO()
	rust

	Revision 1.24  2001/12/12 13:30:09  clip
	Low level locking - DBF
	rust

	Revision 1.23  2001/12/10 09:21:22  clip
	Locking global reviewing...
	rust

	Revision 1.22  2001/12/07 10:37:30  clip
	Sx_IsReadonly(), Sx_IsShared()
	rust

	Revision 1.21  2001/12/06 13:53:46  clip
	Sx_IsDBT() (always .F.), Sx_IsFLocked(), Sx_IsLocked()
	rust

	Revision 1.20  2001/12/05 14:50:32  clip
	Sx_IndexCount(), Sx_IndexName(), Sx_TableName()
	rust

	Revision 1.19  2001/12/05 14:23:34  clip
	Sx_I_IndexName(), Sx_I_TagName(), Sx_IsReindex()
	rust

	Revision 1.18  2001/12/05 12:41:18  clip
	Sx_FNameParser()
	rust

	Revision 1.17  2001/11/23 11:20:43  clip
	_rdd_(case)hashstr() -> _clip_(case)hashword()
	rust

	Revision 1.16  2001/11/23 10:08:08  clip
	some fixes
	rust

	Revision 1.15  2001/11/20 14:10:42  clip
	WILDSEEK, WILDSEEKNEXT, rm_WildMatch()
	rust

	Revision 1.14  2001/11/11 14:46:23  clip
	'alltrim' all field, alias, tag names.
	Bug in rdd_create()
	rust

	Revision 1.13  2001/11/09 12:03:00  clip
	dummy rm_ClrScope(), rm_SetScope(), rm_ClearOrder()
	rust

	Revision 1.12  2001/11/09 11:51:39  clip
	Six: rm_Chill(), rm_Freeze(), rm_Warm(), rm_Thermometer()
	rust

	Revision 1.11  2001/11/09 09:58:31  clip
	rm_AutoOpen(), rm_AutoShare(), rm_BLOB2File()
	rust

	Revision 1.10  2001/11/08 12:39:19  clip
	Six: rmChar(), rmNum(), rmDate(), rmLog()
	rust

	Revision 1.9  2001/11/06 10:42:45  clip
	SIX: RDD_Count(), RDD_Info(), RDD_Name()
	rust

	Revision 1.8  2001/11/05 16:21:39  clip
	RM_SETTRIGGER(), USE ... TRIGGER
	rust

	Revision 1.7  2001/11/05 09:43:48  clip
	Six: rest of trigger events...
	rust

	Revision 1.6  2001/10/30 08:41:38  clip
	many changes
	rust

	Revision 1.5  2001/10/24 08:48:47  clip
	Six types: V3, V4
	rust

	Revision 1.4  2001/10/23 12:01:34  clip
	rm_MemoPack()
	rust

	Revision 1.3  2001/10/22 12:07:05  clip
	many fixes and bugs :)
	rust

	Revision 1.2  2001/10/12 10:05:20  clip
	some fixes
	rust

	Revision 1.1  2001/10/10 15:05:58  clip
	just started
	rust

*/
#include <string.h>
#include <unistd.h>
#include <limits.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <errno.h>
#include <ctype.h>
#include "clipbase.h"
#include "rdd.h"
#include "six.ch"
#include "error.ch"

#define READLOCK	if((er = wa->rd->vtbl->_rlock(cm,wa->rd,__PROC__))) goto err
#define WRITELOCK	if((er = wa->rd->vtbl->_wlock(cm,wa->rd,__PROC__))) goto err
#define UNLOCK		if((er = wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__))) goto err

extern int get_orderno(DBWorkArea* wa,ClipVar* order,ClipVar* index);
extern DBWorkArea* cur_area(ClipMachine * cm);
extern DBWorkArea *get_area(ClipMachine * cm, long area, int any);

extern int clip_ORDKEYNO(ClipMachine* cm);

static const char* er_badfilter		= "Bad filter handle";
static const char* er_invjoin		= "Invalid join type";
static const char* er_notpermitted	= "Operation not permitted";
static const char* er_nomemo		= "Memo file not opened";
static const char* er_nofield		= "No such field";
static const char* er_notmemo		= "Not memo field";
static const char* er_noorder		= "No controlling order";
static const char* er_notable		= "Workarea not in use";
static const char* er_readlock		= "Shared lock error";
static const char* er_writelock		= "Exclusive lock error";
static const char* er_create		= "Create file error";
static const char* er_open			= "Open file error";
static const char* er_write			= "File write error";
static const char* er_read			= "File read error";
static const char* er_badfltfile	= "Bad .flt file";

int clip_M6_NEWFILTER(ClipMachine* cm)
{
	const char* __PROC__ = "SX_NEWFILTER";
	int type = _clip_parinfo(cm,1);
	DBWorkArea* wa = cur_area(cm);
	RDD_FILTER* fp;
	int er;

	CHECKOPT2(1,NUMERIC_t,CHARACTER_t);
	if(!wa){
		_clip_retni(cm,-1);
		return 0;
	}

	READLOCK;
	if(type==NUMERIC_t || type==UNDEF_t){
		unsigned int len = _clip_parni(cm,1);
		if((er = rdd_createuserfilter(cm,wa->rd,&fp,len,__PROC__)))
			goto err_unlock;
	} else if(type==CHARACTER_t){
		char* str = _clip_parc(cm,1);
		if((er = rdd_createfilter(cm,wa->rd,&fp,NULL,str,NULL,__PROC__)))
			goto err_unlock;
	}
	UNLOCK;

	_clip_retni(cm,fp->handle);
	return 0;

err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int
clip_M6_SETAREAFILTER(ClipMachine* cm)
{
	const char* __PROC__ = "SX_SETAREAFILTER";
	DBWorkArea* wa = cur_area(cm);
	int h = _clip_parni(cm,1);
	char expr[PATH_MAX];
	RDD_FILTER* fp;
	int er;

	if(!wa){
		_clip_retl(cm,0);
		return 0;
	}
	CHECKARG1(1,NUMERIC_t);

	fp = (RDD_FILTER*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_RYO);
	if(!fp){
		er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,er_badfilter);
		goto err;
	}
	fp->active = 1;
	if(wa->rd->filter)
		wa->rd->filter->active = 0;
	wa->rd->filter = fp;

	fp->rd = wa->rd;
	rdd_expandmacro(wa->rd->area,0,fp->sfilter,expr);
	if((er = _clip_eval_macro(cm,expr,strlen(expr),&fp->fps->bfilter)))
		goto err;

	_clip_retl(cm,1);
	return 0;
err:
	return er;
}

int
clip_M6_GETAREAFILTER(ClipMachine* cm)
{
	DBWorkArea* wa = cur_area(cm);

	if(!wa){
		_clip_retni(cm,-1);
		return 0;
	}
	if(wa->rd->filter)
		_clip_retni(cm,wa->rd->filter->handle);
	else
		_clip_retni(cm,-1);
	return 0;
}

int
clip_M6_FREEFILTER(ClipMachine* cm)
{
	const char* __PROC__ = "M6_FREEFILTER";
	int h = _clip_parni(cm,1);
	RDD_FILTER* fp;
	int er;

	CHECKARG1(1,NUMERIC_t);

	fp = (RDD_FILTER*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_RYO);
	if(!fp){
		er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,er_badfilter);
		goto err;
	}
	if(fp->active){
		_clip_retl(cm,0);
	} else {
		if((er = rdd_destroyfilter(cm,fp,__PROC__))) goto err;
		_clip_retl(cm,1);
	}
	return 0;
err:
	return er;
}

int
clip_M6_FILTADDREC(ClipMachine* cm)
{
	const char* __PROC__ = "M6_FILTADDREC";
	int h = _clip_parni(cm,1);
	RDD_FILTER* fp;
	unsigned int rn = _clip_parni(cm,2);
	int er;

	CHECKARG1(1,NUMERIC_t);
	CHECKARG1(2,NUMERIC_t);

	fp = (RDD_FILTER*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_RYO);
	if(!fp){
		er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,er_badfilter);
		goto err;
	}
	if(fp->custom && fp->rmap && rn <= fp->size){
		_rm_setbit(fp->rmap,fp->size,rn);
		_clip_retl(cm,1);
	} else {
		_clip_retl(cm,0);
	}
	return 0;
err:
	return er;
}

int
clip_M6_FILTDROPREC(ClipMachine* cm)
{
	const char* __PROC__ = "M6_FILTDROPREC";
	int h = _clip_parni(cm,1);
	RDD_FILTER* fp;
	unsigned int rn = _clip_parni(cm,2);
	int er;

	CHECKARG1(1,NUMERIC_t);
	CHECKARG1(2,NUMERIC_t);

	fp = (RDD_FILTER*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_RYO);
	if(!fp){
		er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,er_badfilter);
		goto err;
	}
	if(fp->custom && fp->rmap && rn <= fp->size){
		_rm_clrbit(fp->rmap,fp->size,rn);
		_clip_retl(cm,1);
	} else {
		_clip_retl(cm,0);
	}
	return 0;
err:
	return er;
}

int
clip_M6_FILTCHGREC(ClipMachine* cm)
{
	const char* __PROC__ = "M6_FILTCHGREC";
	int h = _clip_parni(cm,1);
	RDD_FILTER* fp;
	unsigned int rn = _clip_parni(cm,2);
	int er;

	CHECKARG1(1,NUMERIC_t);
	CHECKARG1(2,NUMERIC_t);

	fp = (RDD_FILTER*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_RYO);
	if(!fp){
		er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,er_badfilter);
		goto err;
	}
	if(fp->custom && fp->rmap && rn <= fp->size){
		if(_rm_getbit(fp->rmap,fp->size,rn)){
			_rm_clrbit(fp->rmap,fp->size,rn);
		} else {
			_rm_setbit(fp->rmap,fp->size,rn);
		}
		_clip_retl(cm,1);
	} else {
		_clip_retl(cm,0);
	}
	return 0;
err:
	return er;
}

int
clip_M6_ISFILTER(ClipMachine* cm)
{
	const char* __PROC__ = "M6_ISFILTER";
	int h = _clip_parni(cm,1);
	RDD_FILTER* fp;
	int er;

	CHECKOPT1(1,NUMERIC_t);
	if(_clip_parinfo(cm,1) == NUMERIC_t){
		fp = (RDD_FILTER*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_RYO);
	} else {
		DBWorkArea* wa = cur_area(cm);
		if(!wa){
			er = rdd_err(cm, EG_NOTABLE, 0, __FILE__, __LINE__, __PROC__,
				er_notable);
			goto err;
		}
		fp = wa->rd->filter;
	}
	if(!fp){
		er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,er_badfilter);
		goto err;
	}

	_clip_retni(cm,fp->optimize);
	return 0;
err:
	return er;
}

int
clip_M6_FILTJOIN(ClipMachine* cm)
{
	const char* __PROC__ = "M6_FILTJOIN";
	int h1 = _clip_parni(cm,1);
	int h2 = _clip_parni(cm,2);
	int oper = _clip_parni(cm,3);
	RDD_FILTER* f1;
	RDD_FILTER* f2;
	int er;

	CHECKARG1(1,NUMERIC_t);
	CHECKARG1(2,NUMERIC_t);
	CHECKARG1(3,NUMERIC_t);

	if(oper<1 || oper>3){
		er = rdd_err(cm,EG_UNSUPPORTED,0,__FILE__,__LINE__,__PROC__,er_invjoin);
		goto err;
	}
	f1 = (RDD_FILTER*)_clip_fetch_c_item(cm,h1,_C_ITEM_TYPE_RYO);
	f2 = (RDD_FILTER*)_clip_fetch_c_item(cm,h2,_C_ITEM_TYPE_RYO);

	if((er = rm_checkjoin(cm,f1,f2,__PROC__))) goto err;

	if(oper==1){
		if((er = rm_union(cm,f1,f2,__PROC__))) goto err;
	} else if(oper==2){
		if((er = rm_intersect(cm,f1,f2,__PROC__))) goto err;
	} else {
		if(!f1->custom){
			er = rdd_err(cm,EG_UNSUPPORTED,0,__FILE__,__LINE__,__PROC__,
				er_notpermitted);
			goto err;
		}
		if((er = rm_difference(cm,f1,f2,__PROC__))) goto err;
	}
	if(!f2->active){
		if((er = rdd_destroyfilter(cm,f2,__PROC__))) goto err;
	}
	_clip_retl(cm,1);
	return 0;
err:
	return er;
}

int
clip_M6_EVALPARTIAL(ClipMachine* cm)
{
	const char* __PROC__ = "M6_EVALPARTIAL";
	int h = _clip_parni(cm,1);
	ClipVar* block = _clip_spar(cm,2);
	RDD_FILTER* fp;
	unsigned int ret;
	int er;

	CHECKARG1(1,NUMERIC_t);
	CHECKOPT2(2,CCODE_t,PCODE_t);
	if(block && (block->t.type == UNDEF_t))
		block = NULL;

	fp = (RDD_FILTER*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_RYO);
	if(!fp){
		er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,er_badfilter);
		goto err;
	}
	if((er = fp->rd->vtbl->_rlock(cm,fp->rd,__PROC__))) goto err;
	if((er = rm_evalpartial(cm,fp,block,&ret,NULL,__PROC__))) goto err_unlock;
	if((er = fp->rd->vtbl->_ulock(cm,fp->rd,__PROC__))) goto err;
	_clip_retni(cm,ret);
	return 0;
err_unlock:
	fp->rd->vtbl->_ulock(cm,fp->rd,__PROC__);
err:
	return er;
}

int
clip_M6_FILTINVERSE(ClipMachine* cm)
{
	const char* __PROC__ = "M6_FILTINVERSE";
	int h = _clip_parni(cm,1);
	RDD_FILTER* fp;
	unsigned int ret;
	int er;

	CHECKARG1(1,NUMERIC_t);
	fp = (RDD_FILTER*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_RYO);
	if(!fp){
		er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,er_badfilter);
		goto err;
	}
	if((er = fp->rd->vtbl->_rlock(cm,fp->rd,__PROC__))) goto err;
	if((er = rm_evalpartial(cm,fp,NULL,&ret,NULL,__PROC__))) goto err_unlock;
	if((er = fp->rd->vtbl->_ulock(cm,fp->rd,__PROC__))) goto err;
	if((er = rm_inverse(cm,fp,__PROC__))) goto err;
	_clip_retl(cm,1);
	return 0;
err_unlock:
	fp->rd->vtbl->_ulock(cm,fp->rd,__PROC__);
err:
	return er;
}

int
clip_M6_FILTCOPY(ClipMachine* cm)
{
	const char* __PROC__ = "M6_FILTCOPY";
	int h = _clip_parni(cm,1);
	RDD_FILTER* fp;
	RDD_FILTER* ret;
	int er;

	CHECKARG1(1,NUMERIC_t);
	fp = (RDD_FILTER*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_RYO);
	if(!fp){
		er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,er_badfilter);
		goto err;
	}
	if((er = rm_copyfilter(cm,fp,&ret,__PROC__))) goto err;
	_clip_retni(cm,ret->handle);
	return 0;
err:
	return er;
}

int
clip_M6_FILTCOUNT(ClipMachine* cm)
{
	const char* __PROC__ = "M6_FILTCOUNT";
	int h = _clip_parni(cm,1);
	RDD_FILTER* fp;
	unsigned int tmp,cnt;
	int er;

	CHECKARG1(1,NUMERIC_t);
	fp = (RDD_FILTER*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_RYO);
	if(!fp){
		er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,er_badfilter);
		goto err;
	}

	if((er = fp->rd->vtbl->_rlock(cm,fp->rd,__PROC__))) goto err;
	if((er = rm_evalpartial(cm,fp,NULL,&tmp,&cnt,__PROC__))) goto err_unlock;
	if((er = fp->rd->vtbl->_ulock(cm,fp->rd,__PROC__))) goto err;
	_clip_retni(cm,cnt);
	return 0;
err_unlock:
	fp->rd->vtbl->_ulock(cm,fp->rd,__PROC__);
err:
	return er;
}

int
clip_M6_ISFILTREC(ClipMachine* cm)
{
	const char* __PROC__ = "M6_ISFILTREC";
	int h = _clip_parni(cm,1);
	RDD_FILTER* fp;
	unsigned int rec = _clip_parni(cm,2);
	int r,er;

	CHECKARG1(1,NUMERIC_t);
	CHECKARG1(2,NUMERIC_t);
	fp = (RDD_FILTER*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_RYO);
	if(!fp){
		er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,er_badfilter);
		goto err;
	}

	if((er = rm_isfiltrec(cm,fp,rec,&r,__PROC__))) goto err;
	_clip_retl(cm,r);
	return 0;
err:
	return er;
}

int
clip_M6_FILTINFO(ClipMachine* cm)
{
	const char* __PROC__ = "M6_FILTINFO";
	int h = _clip_parni(cm,1);
	RDD_FILTER* fp;
	long vect[1];
	ClipVar* rp = RETPTR(cm);
	ClipVar var;
	unsigned int tmp,cnt;
	int er;

	CHECKARG1(1,NUMERIC_t);
	fp = (RDD_FILTER*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_RYO);
	if(!fp){
		er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,er_badfilter);
		goto err;
	}

	vect[0] = 7;
	_clip_array(cm,rp,1,vect);

/*  INFO_EXPR (1) */
	vect[0] = INFO_EXPR-1;
	memset(&var,0,sizeof(ClipVar));
	var.t.type = CHARACTER_t;
	var.s.str.buf = fp->sfilter;
	var.s.str.len = strlen(fp->sfilter);
	_clip_aset(cm,rp,&var,1,vect);

/*  INFO_NONEXPR (2) */
	vect[0] = INFO_NONEXPR-1;
	memset(&var,0,sizeof(ClipVar));
	var.t.type = CHARACTER_t;
	if(fp->optimize==2)
		var.s.str.buf = "";
	else
		var.s.str.buf = fp->sfilter;
	var.s.str.len = strlen(var.s.str.buf);
	_clip_aset(cm,rp,&var,1,vect);

/*  INFO_OPTLVL (3) */
	vect[0] = INFO_OPTLVL-1;
	memset(&var,0,sizeof(ClipVar));
	var.t.type = NUMERIC_t;
	var.n.d = fp->optimize;
	_clip_aset(cm,rp,&var,1,vect);

/*  INFO_COUNT (4) */
	vect[0] = INFO_COUNT-1;
	memset(&var,0,sizeof(ClipVar));
	var.t.type = NUMERIC_t;
	if((er = rm_evalpartial(cm,fp,NULL,&tmp,&cnt,__PROC__))) goto err;
	var.n.d = cnt;
	_clip_aset(cm,rp,&var,1,vect);

/*  INFO_SIZE (5) */
	vect[0] = INFO_SIZE-1;
	memset(&var,0,sizeof(ClipVar));
	var.t.type = NUMERIC_t;
	var.n.d = fp->size;
	_clip_aset(cm,rp,&var,1,vect);

/*  INFO_OWNER (6) */
	vect[0] = INFO_OWNER-1;
	memset(&var,0,sizeof(ClipVar));
	var.t.type = NUMERIC_t;
	var.n.d = (fp->active?1:2);
	_clip_aset(cm,rp,&var,1,vect);

/*  INFO_POS (7) */
	vect[0] = INFO_POS-1;
	memset(&var,0,sizeof(ClipVar));
	var.t.type = NUMERIC_t;
	var.n.d = -1;
	_clip_aset(cm,rp,&var,1,vect);

	return 0;
err:
	return er;
}

int clip_M6_RECCOUNT(ClipMachine* cm){
	const char* __PROC__ = "M6_RECCOUNT";
	DBWorkArea* wa = cur_area(cm);
	RDD_FILTER* fp;
	int i,cnt = 0,er;

	if(!wa){
		er = rdd_err(cm, EG_NOTABLE, 0, __FILE__, __LINE__, __PROC__,
			er_notable);
		goto err;
	}
	fp = wa->rd->filter;
	if(!fp){
		er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,er_badfilter);
		goto err;
	}
	if(fp->rmap){
		for(i=1;i<=fp->size;i++)
			if(_rm_getbit(fp->rmap,fp->size,i))
				cnt++;
	}

	_clip_retni(cm,cnt);
	return 0;
err:
	return er;
}

int clip_M6_ADDSCOPED(ClipMachine* cm){
	const char* __PROC__ = "M6_ADDSCOPED";
	DBWorkArea* wa = cur_area(cm);
	int h = _clip_parni(cm,1);
	RDD_FILTER* fp;
	ClipVar* t = _clip_vptr(_clip_par(cm,2));
	ClipVar* b = _clip_vptr(_clip_par(cm,3));
	int ord = _clip_parni(cm,4)-1;
	int er,i,cnt = 0;

	CHECKARG1(1,NUMERIC_t);
	CHECKOPT1(4,NUMERIC_t);
	if(!wa){
		er = rdd_err(cm, EG_NOTABLE, 0, __FILE__, __LINE__, __PROC__,
			er_notable);
		goto err;
	}
	fp = (RDD_FILTER*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_RYO);
	if(!fp){
		er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,er_badfilter);
		goto err;
	}
	if(!fp->rmap){
		er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,er_badfilter);
		goto err;
	}
	if(_clip_parinfo(cm,4) == UNDEF_t)
		ord = wa->rd->curord;
	if(ord >= wa->rd->ords_opened)
		ord = -1;
	if(ord == -1){
		er = rdd_err(cm,EG_NOORDER,0,__FILE__,__LINE__,__PROC__,er_noorder);
		goto err;
	}

	if(t->t.type == UNDEF_t)
		t = NULL;
	if(b->t.type == UNDEF_t)
		b = NULL;

	READLOCK;
	if((er = wa->rd->orders[ord]->vtbl->setscope(cm,wa->rd,wa->rd->orders[ord],
		t,b,fp->rmap,fp->size,__PROC__))) goto err_unlock;
	UNLOCK;
	for(i=1;i<=fp->size;i++)
		if(_rm_getbit(fp->rmap,fp->size,i))
			cnt++;

	_clip_retni(cm,cnt);
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int clip_M6_CHGOWNER(ClipMachine* cm){
	const char* __PROC__ = "M6_CHGOWNER";
	int h = _clip_parni(cm,1);
	RDD_FILTER* fp;
	int er;

	CHECKARG1(1,NUMERIC_t);
	fp = (RDD_FILTER*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_RYO);
	if(!fp){
		er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,er_badfilter);
		goto err;
	}
	fp->active = 0;
	_clip_retl(cm,1);
	return 0;
err:
	return er;
}

int clip_M6_FILTSAVE(ClipMachine* cm){
	const char* __PROC__ = "M6_FILTSAVE";
	int h = _clip_parni(cm,1);
	char* fname = _clip_parc(cm,2);
	char* path = NULL;
	RDD_FILTER* fp;
	struct flock fl;
	char buf[4];
	int fd,er,bytes;

	CHECKARG1(1,NUMERIC_t);
	CHECKARG1(2,CHARACTER_t);
	fp = (RDD_FILTER*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_RYO);
	if(!fp){
		er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,er_badfilter);
		goto err;
	}
	if((er = _rdd_parsepath(cm,fname,".flt",&path,NULL,EG_CREATE,__PROC__)))
		goto err;

#ifdef OS_CYGWIN
	fd = open(path,O_RDWR|O_BINARY,cm->fileCreateMode);
#else
	fd = open(path,O_RDWR,cm->fileCreateMode);
#endif
	if(fd == -1){
#ifdef OS_CYGWIN
		fd = open(path,O_CREAT|O_TRUNC|O_RDWR|O_BINARY,cm->fileCreateMode);
#else
		fd = open(path,O_CREAT|O_TRUNC|O_RDWR,cm->fileCreateMode);
#endif
	}
	if(fd == -1) goto err_create;

	fl.l_type = F_WRLCK;
	fl.l_whence = SEEK_SET;
	fl.l_start = 0;
	fl.l_len = 1;

	if(fcntl(fd,F_SETLKW,&fl)){
		er = rdd_err(cm,EG_LOCK,errno,__FILE__,__LINE__,__PROC__,
			er_writelock);
		goto err;
	}
	if(ftruncate(fd,0))	goto err_create;
	if(write(fd,"CFLT",4)==-1) goto err_write;
	if(write(fd,&fp->custom,1)==-1) goto err_write;
	_rdd_put_ushort(buf,strlen(fp->sfilter));
	if(write(fd,buf,sizeof(short))==-1) goto err_write;
	if(write(fd,fp->sfilter,_rdd_ushort(buf)+1)==-1) goto err_write;
	_rdd_put_uint(buf,fp->size);
	if(write(fd,buf,sizeof(int))==-1) goto err_write;
	if(fp->rmap){
		bytes = (((fp->size+1) >> 5) + 1) << 2;
		if(write(fd,fp->rmap,bytes)==-1) goto err_write;
	}
	if(close(fd)==-1) goto err_write;
	_clip_retl(cm,1);
	free(path);
	return 0;
err_create:
	er = rdd_err(cm,EG_CREATE,errno,__FILE__,__LINE__,__PROC__,
			er_create);
	goto err;
err_write:
	er = rdd_err(cm,EG_WRITE,errno,__FILE__,__LINE__,__PROC__,
			er_write);
err:
	if(path)
		free(path);
	return er;
}

int clip_M6_FILTRESTORE(ClipMachine* cm){
	const char* __PROC__ = "M6_FILTRESTORE";
	char* fname = _clip_parc(cm,1);
	char* path = NULL;
	RDD_FILTER* fp = NULL;
	struct flock fl;
	char buf[4];
	int fd,er,bytes;

	CHECKARG1(1,CHARACTER_t);
	if((er = _rdd_parsepath(cm,fname,".flt",&path,NULL,EG_OPEN,__PROC__)))
		goto err;

#ifdef OS_CYGWIN
	fd = open(path,O_RDONLY|O_BINARY,cm->fileCreateMode);
#else
	fd = open(path,O_RDONLY,cm->fileCreateMode);
#endif

	if(fd == -1) goto err_open;

	fl.l_type = F_RDLCK;
	fl.l_whence = SEEK_SET;
	fl.l_start = 0;
	fl.l_len = 1;

	if(fcntl(fd,F_SETLKW,&fl)){
		er = rdd_err(cm,EG_LOCK,errno,__FILE__,__LINE__,__PROC__,
			er_readlock);
		goto err;
	}

	fp = calloc(1,sizeof(RDD_FILTER));
	fp->fps = calloc(1,sizeof(RDD_FPS));
	if(read(fd,buf,4)==-1) goto err_read;
	if(memcmp(buf,"CFLT",4)){
		er = rdd_err(cm,EG_ARG,errno,__FILE__,__LINE__,__PROC__,
			er_badfltfile);
		goto err;
	}
	if(read(fd,&fp->custom,1)==-1) goto err_read;
	if(read(fd,buf,sizeof(short))==-1) goto err_read;
	fp->sfilter = (char*)calloc(1,_rdd_ushort(buf)+1);
	if(read(fd,fp->sfilter,_rdd_ushort(buf)+1)==-1) goto err_read;
	if(read(fd,buf,sizeof(int))==-1) goto err_read;
	fp->size = _rdd_uint(buf);
	if(fp->size){
		bytes = (((fp->size+1) >> 5) + 1) << 2;
		fp->rmap = calloc(1,bytes);
		if(read(fd,fp->rmap,bytes)==-1) goto err_read;
	}
	fp->nfps = 1;
	fp->handle = _clip_store_c_item(cm,fp,_C_ITEM_TYPE_RYO,destroy_ryo);
	if(close(fd)==-1) goto err_read;
	free(path);
	_clip_retni(cm,fp->handle);
	return 0;
err_open:
	er = rdd_err(cm,EG_OPEN,errno,__FILE__,__LINE__,__PROC__,
			er_open);
	goto err;
err_read:
	er = rdd_err(cm,EG_READ,errno,__FILE__,__LINE__,__PROC__,
			er_read);
err:
	if(path)
		free(path);
	if(fp){
		if(fp->fps)
			free(fp->fps);
		if(fp->sfilter)
			free(fp->sfilter);
		if(fp->rmap)
			free(fp->rmap);
		free(fp);
	}
	return er;
}

int clip_M6_ISOPTIMIZE(ClipMachine* cm){
	const char* __PROC__ = "M6_ISOPTIMIZE";
	char* str = _clip_parc(cm,1);
	RDD_FILTER* fp = calloc(1,sizeof(RDD_FILTER));
	DBWorkArea* wa = cur_area(cm);
	int er;

	CHECKWA(wa);
	CHECKARG1(1,CHARACTER_t);

	if(str){
		fp->sfilter = str;
	}
	if((er = rdd_initrushmore(cm,wa->rd,fp,NULL,1,__PROC__))) goto err;
	_clip_retni(cm,fp->optimize);

	if(fp->rmap)
		free(fp->rmap);
	free(fp);
	return 0;
err:
	if(fp->rmap)
		free(fp->rmap);
	free(fp);
	return er;
}

int clip_SX_BLOB2FILE(ClipMachine* cm){
	const char* __PROC__ = "SX_FILE2BLOB";
	DBWorkArea* wa = cur_area(cm);
	const char* filename = _clip_parc(cm,1);
	const char* fldname = _clip_parc(cm,2);
	char file[PATH_MAX];
	int fd,fno,er;
	ClipVar v;

	memset(&v,0,sizeof(ClipVar));
	CHECKWA(wa);

	if(!wa->rd->memo)
		return rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,
			er_nomemo);

	for(fno=0;fno<wa->rd->nfields;fno++){
		if(strcasecmp(wa->rd->fields[fno].name,fldname)==0)
			break;
	}
	if(fno >= wa->rd->nfields)
		return rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,
			er_nofield);

	if(wa->rd->fields[fno].type != 'M')
		return rdd_err(cm,EG_DATATYPE,0,__FILE__,__LINE__,__PROC__,
			er_notmemo);

	READLOCK;
	if((er = wa->rd->vtbl->getvalue(cm,wa->rd,fno,&v,__PROC__))) goto err_unlock;
	UNLOCK;

	_clip_translate_path(cm,filename,file,sizeof(file));
	fd = _clip_creat(file,O_RDWR,cm->fileCreateMode,1);
	if(fd == -1) goto err_create;
	if(write(fd,v.s.str.buf,v.s.str.len)==-1) goto err_create;
	if(close(fd)==-1) goto err_create;

	_clip_destroy(cm,&v);
	_clip_retl(cm,1);
	return 0;

err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
	goto err;
err_create:
	er = rdd_err(cm,EG_CREATE,errno,__FILE__,__LINE__,__PROC__,file);
err:
	_clip_destroy(cm,&v);
	return er;
}

int clip_SX_FILE2BLOB(ClipMachine* cm){
	const char* __PROC__ = "SX_FILE2BLOB";
	DBWorkArea* wa = cur_area(cm);
	const char* filename = _clip_parc(cm,1);
	const char* fldname = _clip_parc(cm,2);
	/*int action = _clip_parni(cm,3);*/
	char file[PATH_MAX];
	void* buf;
	int fd,fno,er;
	struct stat st;
	ClipVar v;

	memset(&v,0,sizeof(ClipVar));
	CHECKWA(wa);

	if(!wa->rd->memo)
		return rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,
			er_nomemo);

	for(fno=0;fno<wa->rd->nfields;fno++){
		if(strcasecmp(wa->rd->fields[fno].name,fldname)==0)
			break;
	}
	if(fno >= wa->rd->nfields)
		return rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,
			er_nofield);

	if(wa->rd->fields[fno].type != 'M')
		return rdd_err(cm,EG_DATATYPE,0,__FILE__,__LINE__,__PROC__,
			er_notmemo);

	_clip_translate_path(cm,filename,file,sizeof(file));
	if((er = rdd_open(cm,file,1,1,&fd,__PROC__))) goto err;

	if(fstat(fd,&st)==-1) goto err_open;
	buf = malloc(st.st_size);
	if(read(fd,buf,st.st_size)==-1) goto err_open;
	if(close(fd)==-1) goto err_open;

	v.t.type = CHARACTER_t;
	v.t.flags = F_NONE;
	v.t.memo = 0;
	v.s.str.buf = buf;
	v.s.str.len = st.st_size;
	WRITELOCK;
	if((er = wa->rd->vtbl->setvalue(cm,wa->rd,fno,&v,1,__PROC__))) goto err_unlock;
	UNLOCK;

	_clip_destroy(cm,&v);
	_clip_retl(cm,1);
	return 0;

err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err_open:
	er = rdd_err(cm,EG_OPEN,errno,__FILE__,__LINE__,__PROC__,file);
err:
	_clip_destroy(cm,&v);
	return er;
}

int clip_SX_MEMOPACK(ClipMachine* cm){
	const char* __PROC__ = "SX_MEMOPACK";
	int bsize = _clip_parni(cm,1);
	ClipVar* block = _clip_spar(cm,2);
	int step = _clip_parni(cm,3);
	DBWorkArea* wa = cur_area(cm);
	char tmp[PATH_MAX];
	char* s;
	int tmpfd;
	struct stat st;
	int r,er;

	CHECKWA(wa);
	CHECKOPT1(1,NUMERIC_t);
	CHECKOPT2(2,CCODE_t,PCODE_t);
	CHECKOPT1(3,NUMERIC_t);

	if((er = rdd_event(cm,EVENT_PREMEMOPACK,wa->rd->area,0,NULL,&r,__PROC__)))
		return er;
	if(!r)
		return 0;

	if(!wa->rd->memo)
		return 0;
	if(!wa->rd->memo->vtbl->pack)
		return 0;

	if(wa->rd->shared){
		er = rdd_err(cm,EG_SHARED,0,__FILE__,__LINE__,__PROC__,
			er_notpermitted);
		goto err;
	}
	if(wa->rd->readonly){
		er = rdd_err(cm,EG_READONLY,0,__FILE__,__LINE__,__PROC__,
			er_notpermitted);
		goto err;
	}

	if((er = rdd_checkifnew(cm,wa->rd,__PROC__))) goto err;

	if((int)wa->rd->memo->file.md != -1){
		if(munmap(wa->rd->memo->file.md,wa->rd->memo->file.mapsize)==-1)
			goto err_write;
	}
	if(close(wa->rd->memo->file.fd)==-1) goto err_write;

	strcpy(tmp,wa->rd->memo->path);
	s = strrchr(tmp,'/');
	sprintf(s+1,"memo%lx",(long)getpid());
	sprintf(s+9,".%lx",(long)random());
	s[13] = 0;

	if(rename(wa->rd->memo->path,tmp)==-1) goto err_write;

	wa->rd->memo->file.fd = _clip_creat(wa->rd->memo->path,O_RDWR,cm->fileCreateMode,!wa->rd->shared);
	if(wa->rd->memo->file.fd==-1) goto err_open1;

	if((er = rdd_open(cm,tmp,1,1,&tmpfd,__PROC__))) goto err;

	if(wa->rd->memo->vtbl->pack){
		if((er = wa->rd->memo->vtbl->pack(cm,wa->rd,wa->rd->memo,tmpfd,bsize,block,step,__PROC__)))
			goto err;
	}
	if(close(tmpfd)==-1) goto err_write;

	if(fstat(wa->rd->memo->file.fd,&st)==-1) goto err_write;
	wa->rd->memo->file.mapsize = st.st_size;
	wa->rd->memo->file.md = (caddr_t)mmap(0,wa->rd->memo->file.mapsize,
		PROT_READ|PROT_WRITE,MAP_SHARED,wa->rd->memo->file.fd,0);
	remove(tmp);

	if((er = rdd_event(cm,EVENT_POSTMEMOPACK,wa->rd->area,0,NULL,NULL,__PROC__)))
		goto err;
	return 0;
err_write:
	er = rdd_err(cm,EG_WRITE,errno,__FILE__,__LINE__,__PROC__,wa->rd->memo->path);
	goto err;
err_open1:
	er = rdd_err(cm,EG_OPEN,errno,__FILE__,__LINE__,__PROC__,wa->rd->memo->path);
	goto err;
err:
	return er;
}

int clip_SX_SETTRIGGER(ClipMachine* cm){
	const char* __PROC__ = "SX_SETTRIGGER";
	int action = _clip_parni(cm,1);
	const char* trigger = _clip_parc(cm,2);
	DBWorkArea* wa = cur_area(cm);
	int er;

	CHECKWA(wa);
	CHECKARG1(1,NUMERIC_t);
	CHECKOPT1(2,CHARACTER_t);

	_clip_retc(cm,wa->trigger);
	switch(action){
		case TRIGGER_ENABLE:
			if(wa->trighash)
				wa->trig_active = 1;
			break;
		case TRIGGER_DISABLE:
			wa->trig_active = 0;
			break;
		case TRIGGER_REMOVE:
			if(wa->trigger){
				free(wa->trigger);
				wa->trigger = NULL;
			}
			wa->trighash = 0;
			break;
		case TRIGGER_INSTALL:
			if(trigger && trigger[0]){
				if(wa->trigger){
					free(wa->trigger);
					wa->trigger = NULL;
				}
				wa->trighash = 0;
				wa->trigger = strdup(trigger);
				_clip_upstr(wa->trigger,strlen(wa->trigger));
				wa->trighash = _clip_hashstr(wa->trigger);
				wa->trig_active = 1;
			}
			break;
	}
	return 0;
err:
	return er;
}

int clip_RDD_COUNT(ClipMachine* cm){
	_clip_retni(cm,cm->ndbdrivers);
	return 0;
}

int clip_RDD_NAME(ClipMachine* cm){
	const char* __PROC__ = "RDD_NAME";
	int no = _clip_parni(cm,1);
	int er;

	CHECKARG1(1,NUMERIC_t);

	_clip_retc(cm,cm->dbdrivers[no-1].id);
	return 0;
err:
	return er;
}

int clip_RDD_INFO(ClipMachine* cm){
	const char* __PROC__ = "RDD_INFO";
	int type = _clip_parinfo(cm,1);
	int no,i,er;
	char* rdd;
	char err[100];
	ClipVar* ap = RETPTR(cm);
	long dim[] = {0};
	ClipVar v;

	memset(&v,0,sizeof(ClipVar));
	if(type == CHARACTER_t){
		rdd = _clip_parc(cm,1);
		for(no=0;no<cm->ndbdrivers;no++)
			if(strncasecmp(rdd,cm->dbdrivers[no].id,6)==0)
				break;
		if(no>=cm->ndbdrivers)
			return 0;
	} else if(type == NUMERIC_t){
		DBWorkArea* wa;

		no = _clip_parni(cm,1)-1;
		if(no<0 || no>=cm->ndbdrivers){
			sprintf(err,bad_arg,1);
			er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,err);
			goto err;
		}
		wa = (DBWorkArea*)cm->areas->items[no];
		for(no=0;no<cm->ndbdrivers;no++)
			if(strncasecmp(wa->driver,cm->dbdrivers[no].id,6)==0)
				break;
	} else {
		for(no=0;no<cm->ndbdrivers;no++)
			if(strncasecmp(cm->def_db_driver,cm->dbdrivers[no].id,6)==0)
				break;
	}

	_clip_array(cm,ap,1,dim);

	v.t.type = CHARACTER_t;
	v.s.str.buf = strdup(cm->dbdrivers[no].id);
	v.s.str.len = strlen(v.s.str.buf);
	_clip_aadd(cm,ap,&v);
	_clip_destroy(cm,&v);

	v.t.type = LOGICAL_t;
	v.l.val = 1;
	_clip_aadd(cm,ap,&v);
	_clip_destroy(cm,&v);

	v.t.type = CHARACTER_t;
	for(i=0;i<cm->ndata_drivers;i++)
		if(strncasecmp(cm->dbdrivers[no].data,cm->data_drivers[i]->id,3)==0)
			break;
	v.s.str.buf = strdup(cm->data_drivers[i]->suff);
	v.s.str.len = strlen(v.s.str.buf);
	_clip_aadd(cm,ap,&v);
	_clip_destroy(cm,&v);

	v.t.type = CHARACTER_t;
	for(i=0;i<cm->nidx_drivers;i++)
		if(strncasecmp(cm->dbdrivers[no].idx,cm->idx_drivers[i]->id,3)==0)
			break;
	v.s.str.buf = strdup(cm->idx_drivers[i]->suff);
	v.s.str.len = strlen(v.s.str.buf);
	_clip_aadd(cm,ap,&v);
	_clip_destroy(cm,&v);

	v.t.type = CHARACTER_t;
	v.s.str.buf = strdup("");
	v.s.str.len = 1;
	_clip_aadd(cm,ap,&v);
	_clip_destroy(cm,&v);

	v.t.type = CHARACTER_t;
	for(i=0;i<cm->nmemo_drivers;i++)
		if(strncasecmp(cm->dbdrivers[no].memo,cm->memo_drivers[i]->id,3)==0)
			break;
	v.s.str.buf = strdup(cm->memo_drivers[i]->suff);
	v.s.str.len = strlen(v.s.str.buf);
	_clip_aadd(cm,ap,&v);
	_clip_destroy(cm,&v);

	v.t.type = CHARACTER_t;
	for(i=0;i<cm->ndata_drivers;i++)
		if(strncasecmp(cm->dbdrivers[no].data,cm->data_drivers[i]->id,3)==0)
			break;
	v.s.str.buf = strdup(cm->data_drivers[i]->desc);
	v.s.str.len = strlen(v.s.str.buf);
	_clip_aadd(cm,ap,&v);
	_clip_destroy(cm,&v);

	v.t.type = CHARACTER_t;
	for(i=0;i<cm->nidx_drivers;i++)
		if(strncasecmp(cm->dbdrivers[no].idx,cm->idx_drivers[i]->id,3)==0)
			break;
	v.s.str.buf = strdup(cm->idx_drivers[i]->desc);
	v.s.str.len = strlen(v.s.str.buf);
	_clip_aadd(cm,ap,&v);
	_clip_destroy(cm,&v);

	v.t.type = CHARACTER_t;
	for(i=0;i<cm->nmemo_drivers;i++)
		if(strncasecmp(cm->dbdrivers[no].memo,cm->memo_drivers[i]->id,3)==0)
			break;
	v.s.str.buf = strdup(cm->memo_drivers[i]->desc);
	v.s.str.len = strlen(v.s.str.buf);
	_clip_aadd(cm,ap,&v);
	_clip_destroy(cm,&v);

	return 0;
err:
	return er;
}

int clip_SXCHAR(ClipMachine* cm){
	const char* __PROC__ = "SXCHAR";
	int len = _clip_parni(cm,1);
	ClipVar* v = _clip_par(cm,2);
	ClipVar* r = RETPTR(cm);
	int er;

	CHECKARG1(1,NUMERIC_t);

	if(len<0)
		len = 0;
	memset(r,0,sizeof(ClipVar));
	r->t.type = CHARACTER_t;
	r->s.str.buf = malloc(len+1);
	r->s.str.len = len;
	switch(_clip_parinfo(cm,2)){
		case CHARACTER_t:
		{
			int l = min(len,v->s.str.len);
			memcpy(r->s.str.buf,v->s.str.buf,l);
			memset(r->s.str.buf+l,' ',len-l);
			break;
		}
		case NUMERIC_t:
		{
			int d = min(v->t.dec,len-(v->t.len-v->t.dec));
			_clip_dtostr(r->s.str.buf,len,d,v->n.d,0);
			break;
		}
		case DATE_t:
		{
			char* s = _clip_date_to_str(v->d.julian,cm->date_format);
			int l = min(len,strlen(s));

			memcpy(r->s.str.buf,s,l);
			memset(r->s.str.buf+l,' ',len-l);
			free(s);
			break;
		}
		case LOGICAL_t:
		{
			if(len>0){
				*r->s.str.buf = v->l.val?'T':'F';
				memset(r->s.str.buf+1,' ',len-1);
			}
			break;
		}
		default:
			memset(r->s.str.buf,' ',len);
			break;
	}
	r->s.str.buf[len] = 0;
	return 0;
err:
	return er;
}

int clip_SXNUM(ClipMachine* cm){
	ClipVar* v = _clip_par(cm,1);

	switch(_clip_parinfo(cm,1)){
		case NUMERIC_t:
			_clip_retnd(cm,v->n.d);
			break;
		case CHARACTER_t:
		{
			int d;
			_clip_retnd(cm,_clip_strtod(v->s.str.buf,&d));
			RETPTR(cm)->t.dec = max(0,v->s.str.len-d-1);
			break;
		}
		case DATE_t:
			_clip_retnd(cm,v->d.julian);
			break;
		case LOGICAL_t:
			_clip_retnd(cm,v->l.val);
			break;
		default:
			_clip_retnd(cm,0);
			break;
	}
	return 0;
}

int clip_SXLOG(ClipMachine* cm){
	ClipVar* v = _clip_par(cm,1);

	switch(_clip_parinfo(cm,1)){
		case LOGICAL_t:
			_clip_retl(cm,v->l.val);
			break;
		case CHARACTER_t:
			if(toupper(*v->s.str.buf)=='T' || toupper(*v->s.str.buf)=='Y')
				_clip_retl(cm,1);
			else
				_clip_retl(cm,0);
			break;
		case NUMERIC_t:
			_clip_retl(cm,v->n.d!=0);
			break;
		default:
			_clip_retl(cm,0);
			break;
	}
	return 0;
}

int clip_SXDATE(ClipMachine* cm){
	ClipVar* v = _clip_par(cm,1);

	switch(_clip_parinfo(cm,1)){
		case DATE_t:
			_clip_retdj(cm,v->d.julian);
			break;
		case CHARACTER_t:
			_clip_retdj(cm,_clip_str_to_date(v->s.str.buf,cm->date_format,cm->epoch));
			break;
		case NUMERIC_t:
			_clip_retdj(cm,v->n.d);
			break;
		default:
			_clip_retdj(cm,0);
			break;
	}
	return 0;
}

int clip_SX_CHILL(ClipMachine* cm){
	const char* __PROC__ = "SX_CHILL";
	ClipVar* order = _clip_par(cm,1);
	ClipVar* index = _clip_par(cm,2);
	DBWorkArea* wa = cur_area(cm);
	int ord,er;

	CHECKWA(wa);
	CHECKOPT2(1,CHARACTER_t,NUMERIC_t);
	CHECKOPT1(2,CHARACTER_t);

	_clip_retl(cm,0);
	ord = get_orderno(wa,order,index);
	if(ord==-1)
		ord = wa->rd->curord;
	if(ord==-1)
		return 0;

	wa->rd->orders[ord]->custom = 0;
	wa->rd->orders[ord]->canadd = 0;

	_clip_retl(cm,1);
	return 0;
err:
	return er;
}

int clip_SX_FREEZE(ClipMachine* cm){
	const char* __PROC__ = "SX_FREEZE";
	ClipVar* order = _clip_par(cm,1);
	ClipVar* index = _clip_par(cm,2);
	DBWorkArea* wa = cur_area(cm);
	int ord,er;

	CHECKWA(wa);
	CHECKOPT2(1,CHARACTER_t,NUMERIC_t);
	CHECKOPT1(2,CHARACTER_t);

	_clip_retl(cm,0);
	ord = get_orderno(wa,order,index);
	if(ord==-1)
		ord = wa->rd->curord;
	if(ord==-1)
		return 0;

	wa->rd->orders[ord]->custom = 1;
	wa->rd->orders[ord]->canadd = 0;

	_clip_retl(cm,1);
	return 0;
err:
	return er;
}

int clip_SX_WARM(ClipMachine* cm){
	const char* __PROC__ = "SX_WARM";
	ClipVar* order = _clip_par(cm,1);
	ClipVar* index = _clip_par(cm,2);
	DBWorkArea* wa = cur_area(cm);
	int ord,er;

	CHECKWA(wa);
	CHECKOPT2(1,CHARACTER_t,NUMERIC_t);
	CHECKOPT1(2,CHARACTER_t);

	_clip_retl(cm,0);
	ord = get_orderno(wa,order,index);
	if(ord==-1)
		ord = wa->rd->curord;
	if(ord==-1)
		return 0;

	wa->rd->orders[ord]->custom = 0;
	wa->rd->orders[ord]->canadd = 1;

	_clip_retl(cm,1);
	return 0;
err:
	return er;
}

int clip_SX_THERMOMETER(ClipMachine* cm){
	const char* __PROC__ = "SX_WARM";
	ClipVar* order = _clip_par(cm,1);
	ClipVar* index = _clip_par(cm,2);
	DBWorkArea* wa = cur_area(cm);
	int ord,er;

	CHECKWA(wa);
	CHECKOPT2(1,CHARACTER_t,NUMERIC_t);
	CHECKOPT1(2,CHARACTER_t);

	_clip_retni(cm,0);
	ord = get_orderno(wa,order,index);
	if(ord==-1)
		ord = wa->rd->curord;
	if(ord==-1)
		return 0;

	if(wa->rd->orders[ord]->custom && !wa->rd->orders[ord]->canadd)
		_clip_retni(cm,4);
	else if(!wa->rd->orders[ord]->custom && !wa->rd->orders[ord]->canadd)
		_clip_retni(cm,3);
	else if(!wa->rd->orders[ord]->custom && wa->rd->orders[ord]->canadd)
		_clip_retni(cm,1);
	return 0;
err:
	return er;
}

int clip_SX_CLEARORDER(ClipMachine* cm){
/* dummy */
	_clip_retl(cm,0);
	return 0;
}

int clip_SX_WILDMATCH(ClipMachine* cm){
	const char* __PROC__ = "SX_WILDMATCH";
	const char* pattern = _clip_parc(cm,1);
	const char* string = _clip_parc(cm,2);
	int er;

	CHECKARG1(1,CHARACTER_t);
	CHECKARG1(2,CHARACTER_t);

	_clip_retl(cm,_clip_glob_match(string,pattern,1)!=-1);
	return 0;
err:
	return er;
}

int clip_SX_WILDSEEK(ClipMachine* cm){
	const char* __PROC__ = "SX_WILDSEEK";
	const char* pattern = _clip_parc(cm,1);
	int cont = _clip_parl(cm,2);
	DBWorkArea* wa = cur_area(cm);
	int found,er;

	CHECKWA(wa);
	CHECKARG1(1,CHARACTER_t);
	CHECKOPT1(2,LOGICAL_t);

	READLOCK;
	if(rdd_wildseek(cm,wa->rd,pattern,cont,&found,__PROC__)) goto err_unlock;
	UNLOCK;

	wa->found = found;
	_clip_retl(cm,found);
	return 0;

err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int clip_SX_FNAMEPARSER(ClipMachine* cm){
	const char* __PROC__ = "SX_FNAMEPARSER";
	const char* fname = _clip_parc(cm,1);
	int lpath = _clip_parl(cm,2);
	int lext = _clip_parl(cm,3);
	const char *s,*e;
	char *r;
	int er;

	CHECKARG1(1,CHARACTER_t);
	CHECKOPT1(2,LOGICAL_t);
	CHECKOPT1(3,LOGICAL_t);

	s = fname;
	e = fname+strlen(fname);
	if(!lpath && !lext){
		s = max(s,strrchr(fname,'/'));
		s = max(s,strrchr(fname,'\\'));
		if(s>fname)
			s++;
		e = strrchr(fname,'.');
		if(!(e && *(e+1) != '/' && *(e+1) != '\\'))
			e = NULL;
		if(e<s)
			e = fname+strlen(fname);
	} else if(!lpath && lext){
		s = max(s,strrchr(fname,'/'));
		s = max(s,strrchr(fname,'\\'));
		if(s>fname)
			s++;
	} else if(lpath && !lext){
		e = strrchr(fname,'.');
		if(!(e && *(e+1) != '/' && *(e+1) != '\\'))
			e = NULL;
		if(e<s)
			e = fname+strlen(fname);
	}
	r = calloc(1,e-s+1);
	memcpy(r,s,e-s);
	_clip_retcn_m(cm,r,e-s);
	return 0;
err:
	return er;
}

int clip_SX_I_INDEXNAME(ClipMachine* cm){
	const char* __PROC__ = "SX_I_INDEXNAME";
	DBWorkArea* wa = cur_area(cm);

	CHECKWA(wa);
	_clip_retc(cm,wa->rd->indexing);
	return 0;
}

int clip_SX_I_TAGNAME(ClipMachine* cm){
	const char* __PROC__ = "SX_I_TAGNAME";
	DBWorkArea* wa = cur_area(cm);

	CHECKWA(wa);
	_clip_retc(cm,wa->rd->tagindexing);
	return 0;
}

int clip_SX_ISREINDEX(ClipMachine* cm){
	const char* __PROC__ = "SX_ISREINDEX";
	DBWorkArea* wa = cur_area(cm);

	CHECKWA(wa);
	_clip_retl(cm,wa->rd->reindexing);
	return 0;
}

int clip_SX_INDEXCOUNT(ClipMachine* cm){
	const char* __PROC__ = "SX_INDEXCOUNT";
	DBWorkArea* wa = cur_area(cm);

	CHECKWA(wa);
	_clip_retni(cm,wa->rd->idxs_opened);
	return 0;
}

int clip_SX_INDEXNAME(ClipMachine* cm){
	const char* __PROC__ = "SX_INDEXNAME";
	DBWorkArea* wa = cur_area(cm);
	ClipVar* order = _clip_par(cm,1);
	int ord,er;

	CHECKWA(wa);
	CHECKOPT2(1,CHARACTER_t,NUMERIC_t);

	_clip_retc(cm,"");
	ord = get_orderno(wa,order,NULL);
	if(ord==-1)
		ord = wa->rd->curord;
	if(ord==-1)
		return 0;
	_clip_retc(cm,wa->rd->orders[ord]->index->name);
	return 0;
err:
	return er;
}

int clip_SX_TABLENAME(ClipMachine* cm){
	DBWorkArea* wa = cur_area(cm);
	char* s = wa->rd->path;

	_clip_retc(cm,"");
	if(!wa)
		return 0;

	s = max(s,strrchr(wa->rd->path,'/'));
	s = max(s,strrchr(wa->rd->path,'\\'));
	if(s > wa->rd->path)
		s++;
	_clip_retc(cm,s);
	return 0;
}

int clip_SX_INDEXTYPE(ClipMachine* cm){
	const char* __PROC__ = "SX_INDEXTYPE";
	DBWorkArea* wa = cur_area(cm);
	ClipVar* index = _clip_par(cm,1);
	int ord,er;
	ClipVar order;

	CHECKWA(wa);
	CHECKOPT2(1,CHARACTER_t,NUMERIC_t);

	_clip_retni(cm,0);
	memset(&order,0,sizeof(ClipVar));
	order.t.type = NUMERIC_t;
	order.n.d = 1;
	if(!index)
		ord = -1;
	else
		ord = get_orderno(wa,&order,index);
	if(ord==-1)
		ord = wa->rd->curord;
	if(ord==-1)
		return 0;
	_clip_retni(cm,wa->rd->orders[ord]->vtbl->ismulti?3:2);
	return 0;
err:
	return er;
}

int clip_SX_ISFLOCKED(ClipMachine* cm){
	const char* __PROC__ = "SX_ISFLOCKED";
	DBWorkArea* wa = cur_area(cm);

	CHECKWA(wa);
	_clip_retl(cm,wa->rd->flocked);
	return 0;
}

int clip_SX_ISLOCKED(ClipMachine* cm){
	const char* __PROC__ = "SX_ISLOCKED";
	DBWorkArea* wa = cur_area(cm);
	int recno = _clip_parni(cm,1);
	int r = 0,i,er;

	CHECKWA(wa);
	CHECKOPT1(1,NUMERIC_t);

	if(!recno)
		recno = wa->rd->recno;
	for(i=0;i<wa->rd->nlocks;i++){
		if(wa->rd->locks[i]==recno){
			r = 1;
			break;
		}
	}
	_clip_retl(cm,r);
	return 0;
err:
	return er;
}

int clip_SX_ISREADONLY(ClipMachine* cm){
	const char* __PROC__ = "SX_ISREADONLY";
	DBWorkArea* wa = cur_area(cm);

	CHECKWA(wa);

	_clip_retl(cm,wa->rd->readonly);
	return 0;
}

int clip_SX_ISSHARED(ClipMachine* cm){
	const char* __PROC__ = "SX_ISSHARED";
	DBWorkArea* wa = cur_area(cm);

	CHECKWA(wa);

	_clip_retl(cm,wa->rd->shared);
	return 0;
}

int clip_SX_KEYGOTO(ClipMachine* cm){
	const char* __PROC__ = "SX_KEYGOTO";
	DBWorkArea* wa = cur_area(cm);
	ClipVar* order = _clip_par(cm,1);
	ClipVar* index = _clip_par(cm,2);
	unsigned int keyno = _clip_parni(cm,3);
	int ord,ok,er;

	CHECKWA(wa);
	CHECKARG1(3,NUMERIC_t);

	ord = get_orderno(wa,order,index);
	_clip_retl(cm,0);
	if(ord==-1)
		return 0;

	READLOCK;
	if((er = rdd_gotokey(cm,wa->rd,wa->rd->orders[ord],keyno,&ok,__PROC__)))
		goto err_unlock;
	UNLOCK;

	_clip_retl(cm,ok);
	return 0;

err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int clip_SX_KEYSINCLUDED(ClipMachine* cm){
	const char* __PROC__ = "SX_KEYSINCLUDED";
	DBWorkArea* wa = cur_area(cm);

	CHECKWA(wa);

	_clip_retni(cm,wa->rd->keysincluded);
	return 0;
}

int clip_SX_KILLTAG(ClipMachine* cm){
	const char* __PROC__ = "SX_KILLTAG";
	DBWorkArea* wa = cur_area(cm);
	int lAll = _clip_parl(cm,1);
	ClipVar* order = _clip_par(cm,1);
	ClipVar* index = _clip_par(cm,2);
	int t1 = _clip_parinfo(cm,1);
	RDD_INDEX* ri;
	int ord=0,i,er;

	CHECKARG2(1,CHARACTER_t,LOGICAL_t);
	_clip_retl(cm,0);
	CHECKWA(wa);
	CHECKOPT1(2,CHARACTER_t);

	if(t1 == LOGICAL_t){
		if(!lAll)
			return 0;
	} else {
		lAll = 0;
	}

	if(lAll && (_clip_parinfo(cm,2) == CHARACTER_t)){
		ri = NULL;
		for(i=0;i<wa->rd->idxs_opened;i++){
			if(strcasecmp(wa->rd->indices[i]->name,index->s.str.buf)==0){
				ri = wa->rd->indices[i];
				break;
			}
		}
		if(!ri)
			return 0;
	} else {
		ord = get_orderno(wa,order,index);
		if(ord == -1)
			ord = wa->rd->curord;
		if(ord == -1)
			return 0;
		ri = wa->rd->orders[ord]->index;
	}


	WRITELOCK;
	if(lAll){
		while(ri->norders>0){
			if((er = rdd_orddestroy(cm,wa->rd,ri->orders[0],__PROC__)))
				goto err_unlock;
		}
	} else {
		if((er = rdd_orddestroy(cm,wa->rd,wa->rd->orders[ord],__PROC__)))
			goto err_unlock;
	}
	UNLOCK;

	if(ri->norders==0){
		if((int)(ri->file.md)!=-1){
			if(munmap(ri->file.md,ri->file.mapsize)==-1) goto err_close;
		}
		if(close(ri->file.fd)==-1) goto err_close;
		if(remove(ri->path)==-1) goto err_close;
		if((er = ri->vtbl->close(cm,wa->rd,ri,__PROC__))) return er;
		for(i=ri->indexno;i<wa->rd->idxs_opened-1;i++){
			wa->rd->indices[i] = wa->rd->indices[i+1];
			wa->rd->indices[i]->indexno = i;
		}
		wa->rd->idxs_opened--;
		wa->rd->indices = (RDD_INDEX**)realloc(wa->rd->indices,wa->rd->idxs_opened*sizeof(RDD_INDEX*));
	}
	_clip_retl(cm,1);
	return 0;

err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
	goto err;
err_close:
	er = rdd_err(cm,EG_CLOSE,errno,__FILE__,__LINE__,__PROC__,ri->path);
err:
	return er;
}

int SX_LOCKRETRY(ClipMachine* cm){
/* dummy */
	_clip_retni(cm,0);
	return 0;
}

int clip_SX_MEMOEXT(ClipMachine* cm){
	const char* __PROC__ = "SX_MEMOEXT";
	const char* ext = _clip_parc(cm,1);
	int i,j,er;

	CHECKOPT1(1,CHARACTER_t);

	for(i=0;i<cm->ndbdrivers;i++){
		if(strncasecmp(cm->def_db_driver,cm->dbdrivers[i].id,
			sizeof(cm->def_db_driver))==0){
			for(j=0;j<cm->nmemo_drivers;j++){
				if(strncasecmp(cm->memo_drivers[j]->id,cm->dbdrivers[i].memo,
					sizeof(cm->memo_drivers[j]->id))==0){

					_clip_retc(cm,cm->memo_drivers[j]->suff);
					if(ext && ext[0]){
						memset(cm->memo_drivers[j]->suff,0,5);
						strncpy(cm->memo_drivers[j]->suff,ext,min(4,strlen(ext)));
						for(i=0;i<4;i++)
							cm->memo_drivers[j]->suff[i] =
								tolower(cm->memo_drivers[j]->suff[i]);
					}
					break;
				}
			}
			break;
		}
	}
	return 0;
err:
	return er;
}

int clip_SX_RLOCK(ClipMachine* cm){
	const char* __PROC__ = "SX_RLOCK";
	DBWorkArea* wa = cur_area(cm);
	int t = _clip_parinfo(cm,1);
	ClipVar *ap,*vp;
	int ok = 1,aok,i,er;

	CHECKOPT2(1,ARRAY_t,NUMERIC_t);
	_clip_retl(cm,0);
	if(!wa) return 0;

	if(t==ARRAY_t){
		ap = _clip_vptr(_clip_par(cm,1));
		for(i=0;i<ap->a.count;i++){
			vp = _clip_vptr(&ap->a.items[i]);
			if((er = rdd_rlock(cm,wa->rd,(unsigned int)vp->n.d,&aok,__PROC__)))
				return er;
			if(!aok)
				ok = 0;
		}
	} else if(t==NUMERIC_t){
		if((er = rdd_rlock(cm,wa->rd,_clip_parni(cm,1),&ok,__PROC__))) return er;
	} else if(t==UNDEF_t){
		if((er = rdd_rlock(cm,wa->rd,wa->rd->recno,&ok,__PROC__))) return er;
	}
	_clip_retl(cm,ok);
	return 0;
err:
	return er;
}

int clip_SX_ROLLBACK(ClipMachine* cm){
	const char* __PROC__ = "SX_ROLLBACK";
	int nwa = _clip_parni(cm,1);
	DBWorkArea* wa;
	int i,j,er;

	CHECKOPT1(1,NUMERIC_t);
	if(nwa > 0)
		wa = get_area(cm,nwa,0);
	else
		wa = cur_area(cm);

	_clip_retl(cm,0);
	if(!wa)
		return 0;

	if (nwa > 0)
		wa = get_area(cm, nwa, 0);
	else
		wa = cur_area(cm);

	WRITELOCK;
	for(i=0;i<wa->rd->nfields;i++){
		if(wa->rd->data[i]){
			if((er = rdd_setvalue(cm,wa->rd,i,wa->rd->data[i],__PROC__)))
				goto err_unlock;
			_clip_destroy(cm,wa->rd->data[i]);
			free(wa->rd->data[i]);
			wa->rd->data[i] = NULL;
		}
	}
	for(j=0;j<wa->rd->rels_opened;j++){
		RDD_DATA* child = wa->rd->relations[j]->child;
		for(i=0;i<child->nfields;i++){
			if(child->data[i]){
				if((er = rdd_setvalue(cm,child,i,child->data[i],__PROC__)))
					goto err_unlock;
				_clip_destroy(cm,child->data[i]);
				free(child->data[i]);
				child->data[i] = NULL;
			}
		}
	}
	UNLOCK;

	_clip_retl(cm,1);
	return 0;

err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int clip_SX_SEEKLAST(ClipMachine* cm){
	const char* __PROC__ = "SX_SEEKLAST";
	DBWorkArea* wa = cur_area(cm);
	ClipVar* v = _clip_par(cm,1);
	int soft = _clip_parl(cm,2);
	int found,er;

	CHECKOPT1(2,LOGICAL_t);

	if(!wa) return 0;
	if(_clip_parinfo(cm,2) == UNDEF_t)
		soft = (cm->flags & SOFTSEEK_FLAG);

	READLOCK;
	if((er = rdd_seek(cm,wa->rd,v,soft,1,&found,__PROC__))) goto err_unlock;
	UNLOCK;

	wa->found = (found?1:0);
	_clip_retl(cm, found);
	return 0;

err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int clip_SX_FILEORDER(ClipMachine* cm){
	DBWorkArea* wa = cur_area(cm);

	_clip_retni(cm,0);
	if(!wa) return 0;

	if(wa->rd->curord != -1)
		_clip_retni(cm,wa->rd->orders[wa->rd->curord]->index->indexno+1);
	return 0;
}

int clip_SX_SETFILEORD(ClipMachine* cm){
	const char* __PROC__ = "SX_SETFILEORD";
	DBWorkArea* wa = cur_area(cm);
	int ord = _clip_parni(cm,1)-1;
	int er;

	CHECKARG1(1,NUMERIC_t);

	if(!wa) return 0;

	if(wa->rd->curord == -1)
		_clip_retni(cm,0);
	else
		_clip_retni(cm,wa->rd->orders[wa->rd->curord]->index->indexno+1);

	if(ord >= 0 && ord < wa->rd->idxs_opened){
		if((er = rdd_setorder(cm,wa->rd,wa->rd->indices[ord]->orders[0]->orderno+1,
			__PROC__))) goto err;
	} else if(ord==-1){
		if((er = rdd_setorder(cm,wa->rd,0,__PROC__))) goto err;
	}
	return 0;
err:
	return er;
}

int clip_SX_SETTAG(ClipMachine* cm){
	const char* __PROC__ = "SX_SETTAG";
	DBWorkArea* wa = cur_area(cm);
	ClipVar* order = _clip_par(cm,1);
	ClipVar* index = _clip_par(cm,2);
	int ord,er;

	if(!wa) return 0;
	CHECKOPT2(1,CHARACTER_t,NUMERIC_t);
	CHECKOPT1(2,CHARACTER_t);

	_clip_retl(cm,0);

	ord = get_orderno(wa,order,index);
	if(ord < -1 || ord>=wa->rd->ords_opened || _clip_parinfo(cm,0)==0)
		return 0;

	READLOCK;
	if((er = rdd_setorder(cm, wa->rd, ord+1, __PROC__)))
		goto err_unlock;
	UNLOCK;

	_clip_retl(cm,1);
	return 0;

err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int clip_SX_SETTAGNO(ClipMachine* cm){
	const char* __PROC__ = "SX_SETTAGNO";
	DBWorkArea* wa = cur_area(cm);
	ClipVar* order = _clip_par(cm,1);
	ClipVar* index = _clip_par(cm,2);
	ClipVar in;
	int ord,er;

	if(!wa) return 0;
	CHECKOPT2(1,CHARACTER_t,NUMERIC_t);
	CHECKOPT1(2,CHARACTER_t);

	_clip_retl(cm,0);

	if(_clip_parinfo(cm,2)==0){
		index = &in;
		if(wa->rd->curord == -1)
			return 0;
		memset(index,0,sizeof(ClipVar));
		index->t.type = NUMERIC_t;
		index->n.d = wa->rd->orders[wa->rd->curord]->index->indexno;
	}

	ord = get_orderno(wa,order,index);
	if(ord < -1 || ord>=wa->rd->ords_opened || _clip_parinfo(cm,0)==0)
		return 0;

	READLOCK;
	if((er = rdd_setorder(cm, wa->rd, ord+1, __PROC__)))
		goto err_unlock;
	UNLOCK;

	_clip_retl(cm,1);
	return 0;

err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int clip_SX_SLIMFAST(ClipMachine* cm){
	const char* __PROC__ = "SX_SLIMFAST";
	const char* str = _clip_parc(cm,1);
	const char* s;
	char *ret,*r;
	char quote = 0;
	int er;

	CHECKARG1(1,CHARACTER_t);

	if(!str)
		str = "";

	ret = calloc(1,strlen(str)+1);
	for(s=str,r=ret;*s;s++){
		if(quote && ((*s == quote) || ((quote == '[') && (*s == ']')))){
			quote = 0;
			*(r++) = *s;
			continue;
		}
		if(*s == '[' || *s == '"' || *s == '\'')
			quote = *s;
		if(quote){
			*(r++) = *s;
			continue;
		}
		if((*s == ' ') && ((r > ret) && (*(r-1) == ' ')))
			continue;
		*(r++) = _clip_toupper(*s);
	}
	*r = 0;
	_clip_retc(cm,ret);
	free(ret);
	return 0;
err:
	return er;
}

int clip_SX_STEP(ClipMachine* cm){
	DBWorkArea* wa = cur_area(cm);

	_clip_retni(cm,0);
	if(!wa) return 0;

	_clip_retni(cm,wa->rd->os.nInterval);
	return 0;
}

int clip_SX_TAGCOUNT(ClipMachine* cm){
	const char* __PROC__ = "SX_TAGCOUNT";
	DBWorkArea* wa = cur_area(cm);
	ClipVar* index = _clip_par(cm,1);
	RDD_INDEX* ri = NULL;
	int er;

	CHECKOPT2(1,CHARACTER_t,NUMERIC_t);

	_clip_retni(cm,0);
	if(!wa) return 0;

	if(!index || index->t.type == UNDEF_t){
		if(wa->rd->curord == -1)
			return 0;
		ri = wa->rd->orders[wa->rd->curord]->index;
	} else if(index->t.type == NUMERIC_t){
		int no = index->n.d-1;
		if(no >=0 && no < wa->rd->idxs_opened)
			ri = wa->rd->indices[no];
	} else {
		int i;

		for(i=0;i<wa->rd->idxs_opened;i++){
			if(strcasecmp(wa->rd->indices[i]->name,index->s.str.buf)==0){
				ri = wa->rd->indices[i];
				break;
			}
		}
	}

	if(!ri)
		return 0;

	_clip_retni(cm,ri->norders);
	return 0;
err:
	return er;
}

int clip_SX_TAGNO(ClipMachine* cm){
	DBWorkArea* wa = cur_area(cm);
	RDD_ORDER* ro;
	RDD_INDEX* ri;
	int i;

	_clip_retni(cm,0);

	if(!wa) return 0;

	if(wa->rd->curord == -1)
		return 0;

	ro = wa->rd->orders[wa->rd->curord];
	ri = ro->index;
	for(i=0;i<ri->norders;i++){
		if(ro == ri->orders[i]){
			_clip_retni(cm,i+1);
			break;
		}
	}
	return 0;
}

int clip_SX_TAGINFO(ClipMachine* cm){
	const char* __PROC__ = "SX_TAGINFO";
	DBWorkArea* wa = cur_area(cm);
	ClipVar* index = _clip_par(cm,1);
	RDD_INDEX* ri = NULL;
	long vect[2] = {0,0};
	ClipVar* rp = RETPTR(cm);
	int i,er;

	CHECKOPT2(1,CHARACTER_t,NUMERIC_t);

	if(!wa){
		_clip_array(cm,rp,1,vect);
		return 0;
	}

	if(!index || index->t.type == UNDEF_t){
		if(wa->rd->curord == -1){
			_clip_array(cm,rp,1,vect);
			return 0;
		}
		ri = wa->rd->orders[wa->rd->curord]->index;
	} else if(index->t.type == NUMERIC_t){
		int no = index->n.d-1;
		if(no >=0 && no < wa->rd->idxs_opened)
			ri = wa->rd->indices[no];
	} else {
		int i;

		for(i=0;i<wa->rd->idxs_opened;i++){
			if(strcasecmp(wa->rd->indices[i]->name,index->s.str.buf)==0){
				ri = wa->rd->indices[i];
				break;
			}
		}
	}

	if(!ri){
		_clip_array(cm,rp,1,vect);
		return 0;
	}

	vect[0] = ri->norders;
	vect[1] = 6;
	_clip_array(cm,rp,2,vect);

	for(i=0;i<ri->norders;i++){
		ClipVar v;
		RDD_ORDER* ro = ri->orders[i];

		vect[0] = i;
		memset(&v,0,sizeof(ClipVar*));

		v.t.type = CHARACTER_t;
		v.s.str.buf = ro->name;
		v.s.str.len = strlen(ro->name);
		vect[1] = 0;
		_clip_aset(cm,rp,&v,2,vect);

		v.t.type = CHARACTER_t;
		v.s.str.buf = ro->expr;
		v.s.str.len = strlen(ro->name);
		vect[1] = 1;
		_clip_aset(cm,rp,&v,2,vect);

		v.t.type = CHARACTER_t;
		v.s.str.buf = ro->cforexpr;
		v.s.str.len = ro->cforexpr?strlen(ro->cforexpr):0;
		vect[1] = 2;
		_clip_aset(cm,rp,&v,2,vect);

		v.t.type = LOGICAL_t;
		v.l.val = ro->unique;
		vect[1] = 3;
		_clip_aset(cm,rp,&v,2,vect);

		v.t.type = LOGICAL_t;
		v.l.val = ro->descend;
		vect[1] = 4;
		_clip_aset(cm,rp,&v,2,vect);

		v.t.type = LOGICAL_t;
		v.l.val = ro->custom;
		vect[1] = 5;
		_clip_aset(cm,rp,&v,2,vect);
	}
	return 0;
err:
	return er;
}

int clip_SX_TAGS(ClipMachine* cm){
	const char* __PROC__ = "SX_TAGS";
	DBWorkArea* wa = cur_area(cm);
	ClipVar* index = _clip_par(cm,1);
	RDD_INDEX* ri = NULL;
	long vect[1] = {0};
	ClipVar* rp = RETPTR(cm);
	int i,er;

	CHECKOPT2(1,CHARACTER_t,NUMERIC_t);

	if(!wa){
		_clip_array(cm,rp,1,vect);
		return 0;
	}

	if(!index || index->t.type == UNDEF_t){
		if(wa->rd->curord == -1){
			_clip_array(cm,rp,1,vect);
			return 0;
		}
		ri = wa->rd->orders[wa->rd->curord]->index;
	} else if(index->t.type == NUMERIC_t){
		int no = index->n.d-1;
		if(no >=0 && no < wa->rd->idxs_opened)
			ri = wa->rd->indices[no];
	} else {
		int i;

		for(i=0;i<wa->rd->idxs_opened;i++){
			if(strcasecmp(wa->rd->indices[i]->name,index->s.str.buf)==0){
				ri = wa->rd->indices[i];
				break;
			}
		}
	}

	if(!ri){
		_clip_array(cm,rp,1,vect);
		return 0;
	}

	vect[0] = ri->norders;
	_clip_array(cm,rp,1,vect);

	for(i=0;i<ri->norders;i++){
		ClipVar v;
		RDD_ORDER* ro = ri->orders[i];

		v.t.type = CHARACTER_t;
		v.s.str.buf = ro->name;
		v.s.str.len = strlen(ro->name);
		vect[0] = i;
		_clip_aset(cm,rp,&v,1,vect);
	}
	return 0;
err:
	return er;
}

int clip_SX_TAGUNIQUE(ClipMachine* cm){
	const char* __PROC__ = "SX_TAGUNIQUE";
	ClipVar* order = _clip_par(cm,1);
	ClipVar* index = _clip_par(cm,2);
	DBWorkArea* wa = cur_area(cm);
	int ord,er;

	CHECKOPT2(1,CHARACTER_t,NUMERIC_t);
	CHECKOPT2(2,CHARACTER_t,NUMERIC_t);

	_clip_retl(cm,0);
	if(!wa) return 0;

	ord = get_orderno(wa,order,index);
	if(ord==-1)
		return 0;

	_clip_retl(cm,wa->rd->orders[ord]->unique);
	return 0;
err:
	return er;
}

int clip_SX_VSIGLEN(ClipMachine* cm){
	const char* __PROC__ = "SX_VSIGLEN";
	DBWorkArea* wa = cur_area(cm);
	int t = _clip_parinfo(cm,1);
	int fno = -1,er;

	CHECKARG2(1,CHARACTER_t,NUMERIC_t);

	_clip_retni(cm,0);

	if(!wa)
		return 0;

	if(t==CHARACTER_t){
		char* fname = _clip_parc(cm,1);
		if(fname)
			fno = _rdd_fieldno(wa->rd,_clip_casehashword(fname,strlen(fname)));
	} else {
		fno = _clip_parni(cm,1)-1;
	}

	if(fno<0 || fno>=wa->rd->nfields)
		return 0;

	if(wa->rd->fields[fno].type == 'V' && wa->rd->fields[fno].len != 3 &&
		wa->rd->fields[fno].len != 4){
		_clip_retni(cm,max(wa->rd->fields[fno].len-6,0));
	} else {
		_clip_retni(cm,wa->rd->fields[fno].len);
	}
	return 0;
err:
	return er;
}

int clip_SX_DESCEND(ClipMachine* cm){
	const char* __PROC__ = "SX_DESCEND";
	DBWorkArea* wa = cur_area(cm);
	ClipVar* order = _clip_par(cm,1);
	ClipVar* index = _clip_par(cm,2);
	int res,ord,er;

	CHECKWA(wa);
	CHECKOPT2(1,CHARACTER_t,NUMERIC_t);
	CHECKOPT2(2,CHARACTER_t,NUMERIC_t);

	ord = get_orderno(wa,order,index);
	if(ord==-1)
		return rdd_err(cm,EG_NOORDER,0,__FILE__,__LINE__,__PROC__,
			er_noorder);

	if((er = wa->rd->orders[ord]->vtbl->descend(cm,wa->rd->orders[ord],
		!wa->rd->orders[ord]->descend,&res,__PROC__))) return er;
	return 0;
err:
	return er;

}

int clip_SX_TABLETYPE(ClipMachine* cm){
	DBWorkArea* wa = cur_area(cm);

	_clip_retni(cm,0);
	if(!wa)
		return 0;
	_clip_retni(cm,1);
	return 0;
}
