/*
	Copyright (C) 2001  ITK
	Author  : Rushad Nabiullin <rust@itk.ru>
	License : (GPL) http://www.itk.ru/clipper/license.html

	$Log: rddclip.c,v $
	Revision 1.94  2004/02/05 13:34:12  clip
	*** empty log message ***
	
	Revision 1.93  2004/02/05 13:21:28  clip
	rust: rddcreateindex(...,cForCondition {8th parameter} )

	Revision 1.92  2004/01/16 10:06:08  clip
	rust: flush buffer on RLOCK()

	Revision 1.91  2003/12/01 12:04:23  clip
	rust: RDDCLOSEALL() closes only tables of current task

	Revision 1.90  2003/08/12 12:51:53  clip
	rust: index on readonly dbf

	Revision 1.89  2003/07/16 07:57:04  clip
	rust: another 'unsafe write'

	Revision 1.88  2003/06/11 07:57:33  clip
	rust: minor fix

	Revision 1.87  2003/06/11 07:52:19  clip
	rust: avoid 'unsafe read' warning in rddsetorder()

	Revision 1.86  2003/06/05 13:20:28  clip
	rust: avoid 'unsafe read' warning and reduntant "gotop()"

	Revision 1.85  2003/05/29 12:47:49  clip
	rust: SIGSEGV when dbseek(NIL)

	Revision 1.84  2003/05/22 11:46:25  clip
	rust: minor fix

	Revision 1.83  2003/05/15 14:39:30  clip
	rust: some speed optimizations for relations

	Revision 1.82  2003/03/21 12:50:59  clip
	rust: avoid warnings "unsafe read/write"

	Revision 1.81  2003/03/12 12:50:43  clip
	rust: tasks share RDDs and subdrivers

	Revision 1.80  2003/03/04 12:47:01  clip
	uri: added C-level exit procedures for closing DB & RDD

	Revision 1.79  2002/12/17 14:02:54  clip
	rust: EXACT or NON-EXACT set scope

	Revision 1.78  2002/12/04 17:03:00  clip
	rust: small fix

	Revision 1.77  2002/12/04 16:49:29  clip
	rust: rdd_m6_newfilter(), rdd_m6_addscoped(), rdd_m6_setareafilter()

	Revision 1.76  2002/12/02 13:48:33  clip
	rust: ignoring case in CDX;
	RDDCREATEINDEX(...,lIgnoreCase) (7th parameter)
	ORDCONDSET(...,lIgnoreCase) (16th parameter)

	Revision 1.75  2002/11/05 14:46:30  clip
	rust: some fixes

	Revision 1.74  2002/10/30 13:04:38  clip
	rust: m6_SetFilter()

	Revision 1.73  2002/10/26 11:10:02  clip
	initial support for localized runtime messages
	messages are in module 'cliprt'
	paul

	Revision 1.72  2002/10/11 09:11:13  clip
	rust: m6_FiltSave()/m6_FiltRestore()

	Revision 1.71  2002/10/01 13:33:17  clip
	rust: build filter list

	Revision 1.70  2002/09/25 13:17:03  clip
	rust: compatibility of INDEX ON behavior and some cleanups

	Revision 1.69  2002/09/02 11:34:19  clip
	rust: rddsetfilter() with aliasing improved

	Revision 1.68  2002/08/30 10:37:58  clip
	rust: rddfilter(<nHandle>) added

	Revision 1.67  2002/08/30 10:16:35  clip
	rust: rddsetfilter(<handle>,<cFilter>,<aAliases>) (<aAliases> added)

	Revision 1.66  2002/08/26 13:11:19  clip
	rust: optimizing rddsetfilter()

	Revision 1.65  2002/05/18 11:12:32  clip
	rust: clipper-style indexes locking (NTX)

	Revision 1.64  2002/05/12 11:55:03  clip
	rust: RDDFIELDNUM(), RDDFIELDDECI(), RDDFIELDSIZE(), RDDFIELDTYPE()

	Revision 1.63  2002/05/12 11:19:39  clip
	rust: some fixes

	Revision 1.62  2002/05/12 09:12:10  clip
	rust: UNLOCK flushes record buffer

	Revision 1.61  2002/05/11 09:44:14  clip
	rust: record buffering bug and some fixes

	Revision 1.60  2002/04/29 09:24:22  clip
	rust: record buffering with RDD mechanism

	Revision 1.59  2002/04/21 11:22:23  clip
	rust: added 2 elements to dbstruct - binary (5th) and nullable (6th)

	Revision 1.58  2002/04/17 12:21:59  clip
	rust: some fixes

	Revision 1.57  2002/04/03 09:37:44  clip
	rust: .DBF signature with various memo formats is corrected

	Revision 1.56  2002/03/21 13:55:55  clip
	rust: error messages

	Revision 1.55  2002/03/21 12:29:47  clip
	rust: error messages

	Revision 1.54  2002/03/21 11:55:15  clip
	rust: big cleaning

	Revision 1.53  2002/03/19 14:25:29  clip
	rust: big cleaning

	Revision 1.52  2002/02/27 14:29:41  clip
	rust: rddclearfilter()

	Revision 1.51  2002/02/26 11:21:23  clip
	rust: small fix

	Revision 1.50  2002/02/22 13:01:48  clip
	alexey: small fix in clip_RDDRLOCK()

	Revision 1.49  2002/02/22 12:44:03  clip
	rust: rddrlock(<nRecno>,[<lReleaseLocks>]) -> lSuccess
		  rddunlock([<nRecno>]),
		  rddunlock() - unlocks current record,
		  rddunlock(0) - unlocks all records

	Revision 1.48  2002/02/22 12:18:08  clip
	rust: rddsetorder(h,<tagname|tagno>)

	Revision 1.47  2002/01/04 12:27:15  clip
	some fixes
	rust

	Revision 1.46  2001/12/22 10:01:21  clip
	some changes
	rust

	Revision 1.45  2001/12/12 13:30:09  clip
	Low level locking - DBF
	rust

	Revision 1.44  2001/12/05 11:55:04  clip
	unused variable
	rust

	Revision 1.43  2001/12/05 11:53:33  clip
	bug in RDDFIELDPOS()
	rust

	Revision 1.42  2001/11/12 11:40:40  clip
	bug in rddclosearea()
	rust

	Revision 1.41  2001/11/12 10:22:55  clip
	rddclosearea() does not close WorkArea
	rust

	Revision 1.40  2001/09/22 13:20:53  clip
	some optimizations
	rust

	Revision 1.39  2001/08/23 14:44:49  clip
	Logging started
	rust

*/
#include <string.h>
#include <limits.h>
#include "../rdd.h"
#include "error.ch"

#define READLOCK	if((er = rd->vtbl->_rlock(cm,rd,__PROC__))) goto err
#define WRITELOCK	if((er = rd->vtbl->_wlock(cm,rd,__PROC__))) goto err
#define UNLOCK		if((er = rd->vtbl->_ulock(cm,rd,__PROC__))) goto err

#define er_badinstance  _clip_gettext("Bad RDD instance")
#define er_nofield      _clip_gettext("No such field")
#define er_badargument2 _clip_gettext("Bad argument (2)")
#define er_badfilter    _clip_gettext("Bad filter handle")
#define er_noorder      _clip_gettext("No controlling order")

static RDD_DATA* _fetch_rdd(ClipMachine* cm,const char* __PROC__){
	RDD_DATA* rd = (RDD_DATA*)_clip_fetch_c_item(cm,_clip_parni(cm,1),
		_C_ITEM_TYPE_RDD);

	if(_clip_parinfo(cm,1)!=NUMERIC_t){
		rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,er_badinstance);
		return NULL;
	}
	if(!rd){
		rdd_err(cm,EG_NOTABLE,0,__FILE__,__LINE__,__PROC__,er_badinstance);
		return NULL;
	}
	return rd;
}

int clip_RDDUSEAREA(ClipMachine* cm){
	const char* __PROC__ = "RDDUSEAREA";
	const char* driver = _clip_parc(cm,1);
	const char* name = _clip_parc(cm,2);
	int shared = _clip_parl(cm,3);
	int readonly = _clip_parl(cm,4);
	int tempo = _clip_parl(cm,5);
	RDD_DATA* data;
	int er;

	CHECKOPT1(1,CHARACTER_t);
	CHECKARG1(2,CHARACTER_t);
	CHECKOPT1(3,LOGICAL_t);
	CHECKOPT1(4,LOGICAL_t);
	CHECKOPT1(5,LOGICAL_t);

	if(_clip_parinfo(cm,3)==UNDEF_t)
		shared = !(cm->flags & EXCLUSIVE_FLAG);

	if((er = rdd_usearea(cm,driver,name,shared,readonly,tempo,&data,__PROC__)))
		goto err;
	data->area = -1;
	data->rdhandle = _clip_store_c_item(cm,(void*)data,_C_ITEM_TYPE_RDD,destroy_rdd_data);
	_clip_retni(cm,data->rdhandle);
	return 0;
err:
	return er;
}

int clip_RDDCREATE(ClipMachine* cm){
	const char* __PROC__ = "RDDCREATE";
	const char* driver = _clip_parc(cm,1);
	const char* name = _clip_parc(cm,2);
	ClipVar* stru = _clip_par(cm,3);
	int er;

	CHECKOPT1(1,CHARACTER_t);
	CHECKARG1(2,CHARACTER_t);
	CHECKARG1(3,ARRAY_t);

	if((er = rdd_create(cm,driver,NULL,name,stru,__PROC__))) goto err;
	return 0;
err:
	return er;
}

int clip___RDDZAP(ClipMachine* cm){
	const char* __PROC__ = "__RDDZAP";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	int er;

	if(!rd) return EG_NOTABLE;

	if((er = rdd_zap(cm,rd,__PROC__))) goto err;
	return 0;
err:
	return er;
}

int clip_RDDCREATEMEMO(ClipMachine* cm){
	const char* __PROC__ = "RDDCREATEMEMO";
	const char* driver = _clip_parc(cm,1);
	const char* name = _clip_parc(cm,2);
	int er;

	CHECKOPT1(1,CHARACTER_t);
	CHECKARG1(2,CHARACTER_t);

	if((er = rdd_creatememo(cm,driver,name,__PROC__))) goto err;
	return 0;
err:
	return er;
}

int clip_RDDSETINDEX(ClipMachine* cm){
	const char* __PROC__ = "RDDSETINDEX";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	const char* driver = _clip_parc(cm,2);
	const char* name = _clip_parc(cm,3);
	const char* tag = _clip_parc(cm,4);
	int er;

	if(!rd) return EG_NOTABLE;
	CHECKOPT1(2,CHARACTER_t);
	CHECKARG1(3,CHARACTER_t);
	CHECKOPT1(4,CHARACTER_t);

	READLOCK;
	if((er = rdd_setindex(cm,rd,NULL,driver,name,tag,0,__PROC__))) goto err_unlock;
	if((er = rdd_gotop(cm,rd,__PROC__))) goto err_unlock;
	UNLOCK;
	return 0;
err_unlock:
	rd->vtbl->_ulock(cm,rd,__PROC__);
err:
	return er;
}


int clip_RDDSETMEMO(ClipMachine* cm){
	const char* __PROC__ = "RDDSETMEMO";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	const char* driver = _clip_parc(cm,2);
	const char* name = _clip_parc(cm,3);
	int er;

	if(!rd) return EG_NOTABLE;
	CHECKOPT1(2,CHARACTER_t);
	CHECKARG1(3,CHARACTER_t);

	if((er = rdd_setmemo(cm,rd,driver,name,__PROC__))) goto err;
	return 0;
err:
	return er;
}

int clip_RDDSETRELATION(ClipMachine* cm){
	const char* __PROC__ = "RDDSETRELATION";
	int parent = _clip_parni(cm,1);
	int child = _clip_parni(cm,2);
	RDD_DATA* rd = (RDD_DATA*)_clip_fetch_c_item(cm,parent,_C_ITEM_TYPE_RDD);
	RDD_DATA* crd = (RDD_DATA*)_clip_fetch_c_item(cm,child,_C_ITEM_TYPE_RDD);
	const char* expr = _clip_parc(cm,3);
	int er;

	if(!rd) return EG_NOTABLE;
	CHECKARG1(1,NUMERIC_t);
	CHECKOPT1(2,NUMERIC_t);
	CHECKOPT1(3,CHARACTER_t);

	if(_clip_parinfo(cm,2)==UNDEF_t) crd = NULL;
	if(_clip_parinfo(cm,3)==UNDEF_t) crd = NULL;

	if((er = rdd_flushbuffer(cm,rd,__PROC__))) goto err;
	READLOCK;
	if((er = rdd_setrelation(cm,rd,crd,NULL,expr,1,__PROC__))) goto err_unlock;
	UNLOCK;
	return 0;
err_unlock:
	rd->vtbl->_ulock(cm,rd,__PROC__);
err:
	return er;
}

int clip_RDDCREATEINDEX(ClipMachine* cm){
	const char* __PROC__ = "RDDCREATEINDEX";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	const char* driver = _clip_parc(cm,2);
	const char* name = _clip_parc(cm,3);
	const char* tag = _clip_parc(cm,4);
	const char* expr = _clip_parc(cm,5);
	int unique = _clip_parl(cm,6);
	int lIgnoreCase = _clip_parl(cm,7);
	const char* cfor = _clip_parc(cm,8);
	int er;

	if(!rd) return EG_NOTABLE;
	CHECKOPT1(2,CHARACTER_t);
	CHECKARG1(3,CHARACTER_t);
	CHECKOPT1(4,CHARACTER_t);
	CHECKARG1(5,CHARACTER_t);
	CHECKOPT1(6,LOGICAL_t);
	CHECKOPT1(7,LOGICAL_t);
	CHECKOPT1(8,CHARACTER_t);

	if(_clip_parinfo(cm,6)==UNDEF_t)
		unique = cm->flags & UNIQUE_FLAG;

	rd->os.lIgnoreCase = lIgnoreCase;

	if(rd->os.cForCondition){
		free(rd->os.cForCondition);
		rd->os.cForCondition = NULL;
	}
	if(cfor && cfor[0]){
		int r = _clip_parni(cm,1);
		char forexpr[1024];

		rd->os.cForCondition = malloc(strlen(cfor)+1);
		strcpy(rd->os.cForCondition,cfor);

		memset(forexpr,0,sizeof(forexpr));

		rdd_expandmacro(rd->area,r,cfor,forexpr);

		if((er = _clip_eval_macro(cm,forexpr,strlen(forexpr),&rd->os.bForCondition)))
			goto err;
	}

	if((er = rdd_flushbuffer(cm,rd,__PROC__))) goto err;
	if(rd->readonly){
		READLOCK;
	} else {
		WRITELOCK;
	}
	if((er = rdd_createindex(cm,rd,driver,name,tag,expr,NULL,unique,__PROC__)))
		goto err_unlock;
	UNLOCK;
	return 0;
err_unlock:
	rd->vtbl->_ulock(cm,rd,__PROC__);
err:
	return er;
}

int clip_RDDREINDEX(ClipMachine* cm){
	const char* __PROC__ = "RDDREINDEX";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	int er;

	if(!rd) return EG_NOTABLE;

	if((er = rdd_flushbuffer(cm,rd,__PROC__))) return er;
	return rdd_reindex(cm,rd,__PROC__);
}

int clip_RDDCLEARINDEX(ClipMachine* cm){
	const char* __PROC__ = "RDDCLEARINDEX";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);

	if(!rd) return EG_NOTABLE;

	return rdd_clearindex(cm,rd,__PROC__);
}

int clip_RDDSETORDER(ClipMachine* cm){
	const char* __PROC__ = "RDDSETORDER";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	int er;

	if(!rd) return EG_NOTABLE;
	CHECKOPT2(2,NUMERIC_t,CHARACTER_t);

	if((er = rdd_flushbuffer(cm,rd,__PROC__))) goto err;
	READLOCK;
	if(_clip_parinfo(cm,2)==NUMERIC_t){
		int order = _clip_parni(cm,2);
		if((er = rdd_setorder(cm,rd,order,__PROC__))) goto err_unlock;
	} else {
		const char* tag = _clip_parc(cm,2);
		int i;

		if(tag){
			for(i=0;i<rd->ords_opened;i++){
				if(strcasecmp(rd->orders[i]->name,tag)==0){
					if((er = rdd_setorder(cm,rd,i+1,__PROC__))) goto err_unlock;
					break;
				}
			}
		}
	}
	UNLOCK;
	return 0;
err_unlock:
	rd->vtbl->_ulock(cm,rd,__PROC__);
err:
	return er;
}

int clip_RDDINDEXORD(ClipMachine* cm){
	const char* __PROC__ = "RDDINDEXORD";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);

	if(!rd) return EG_NOTABLE;

	_clip_retni(cm,rd->curord+1);
	return 0;
}

int clip_RDDCLOSEAREA(ClipMachine* cm){
	const char* __PROC__ = "RDDCLOSEAREA";
	int key = _clip_parni(cm,1);
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	int er;

	if(!rd) return EG_NOTABLE;

	if(rd->area!=-1)
		return 0;
	if((er = rdd_flushbuffer(cm,rd,__PROC__))) goto err;
	if(rd->readonly)
		rd->vtbl->_rlock(cm,rd,__PROC__);
	else
		rd->vtbl->_wlock(cm,rd,__PROC__);
	if((er = rdd_closearea(cm,rd,__PROC__))) goto err;
	_clip_destroy_c_item(cm,key,_C_ITEM_TYPE_RDD);
	return 0;
err:
	return er;
}

int clip_RDDCLOSEALL(ClipMachine* cm){
	const char* __PROC__ = "RDDCLOSEALL";
	RDD_DATA* rd;
	int key,i,er;

	for(i=0;i<cm->container->len;i++){
		if(cm->container->items[i].type == _C_ITEM_TYPE_RDD){
			rd = (RDD_DATA*)cm->container->items[i].item;
			if(rd->cm == cm && rd->area==-1){
				key = cm->container->items[i].key;
				if((er = rdd_flushbuffer(cm,rd,__PROC__))) goto err;
				if(rd->readonly)
					rd->vtbl->_rlock(cm,rd,__PROC__);
				else
					rd->vtbl->_wlock(cm,rd,__PROC__);
				if((er = rdd_closearea(cm,rd,__PROC__))) goto err;
				_clip_destroy_c_item(cm,key,_C_ITEM_TYPE_RDD);
				rd = (RDD_DATA*)_clip_fetch_c_item_type(cm,_C_ITEM_TYPE_RDD,&key);
			}
		}
	}
	return 0;
err:
	return er;
}

int clip_RDDSEEK(ClipMachine* cm){
	const char* __PROC__ = "RDDSEEK";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	ClipVar* v = _clip_par(cm,2);
	int soft = _clip_parl(cm,3);
	int last = _clip_parl(cm,4);
	int found,er;

	_clip_retl(cm,0);
	if(!rd) return EG_NOTABLE;
	CHECKOPT1(3,LOGICAL_t);
	CHECKOPT1(4,LOGICAL_t);

	if(!v)
		return 0;

	if(_clip_parinfo(cm,3)==UNDEF_t)
		soft = (cm->flags & SOFTSEEK_FLAG);
	if((er = rdd_flushbuffer(cm,rd,__PROC__))) goto err;
	READLOCK;
	if((er = rdd_seek(cm,rd,v,soft,last,&found,__PROC__))) goto err_unlock;
	UNLOCK;
	_clip_retl(cm,found);
	return 0;
err_unlock:
	rd->vtbl->_ulock(cm,rd,__PROC__);
err:
	return er;
}

int clip_RDDGOTOP(ClipMachine* cm){
	const char* __PROC__ = "RDDGOTOP";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	int er;

	if(!rd) return EG_NOTABLE;

	if((er = rdd_flushbuffer(cm,rd,__PROC__))) goto err;
	READLOCK;
	if((er = rdd_gotop(cm,rd,__PROC__))) goto err_unlock;
	UNLOCK;
	return 0;
err_unlock:
	rd->vtbl->_ulock(cm,rd,__PROC__);
err:
	return er;
}

int clip_RDDGOBOTTOM(ClipMachine* cm){
	const char* __PROC__ = "RDDGOBOTTOM";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	int er;

	if(!rd) return EG_NOTABLE;

	if((er = rdd_flushbuffer(cm,rd,__PROC__))) goto err;
	READLOCK;
	if((er = rdd_gobottom(cm,rd,__PROC__))) goto err_unlock;
	UNLOCK;
	return 0;
err_unlock:
	rd->vtbl->_ulock(cm,rd,__PROC__);
err:
	return er;
}

int clip_RDDSKIP(ClipMachine* cm){
	const char* __PROC__ = "RDDSKIP";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	int recs = _clip_parni(cm,2);
	int er;

	if(!rd) return EG_NOTABLE;
	CHECKOPT1(2,NUMERIC_t);

	if(_clip_parinfo(cm,2)==UNDEF_t) recs = 1;

	if((er = rdd_flushbuffer(cm,rd,__PROC__))) goto err;
	READLOCK;
	if((er = rdd_skip(cm,rd,recs,__PROC__))) goto err_unlock;
	UNLOCK;
	return 0;
err_unlock:
	rd->vtbl->_ulock(cm,rd,__PROC__);
err:
	return er;
}

int clip_RDDGOTO(ClipMachine* cm){
	const char* __PROC__ = "RDDGOTO";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	int rec = _clip_parni(cm,2);
	int er;

	if(!rd) return EG_NOTABLE;
	CHECKARG1(2,NUMERIC_t);

	if((er = rdd_flushbuffer(cm,rd,__PROC__))) goto err;
	READLOCK;
	if((er = rdd_goto(cm,rd,rec,__PROC__))) goto err_unlock;
	UNLOCK;
	return 0;
err_unlock:
	rd->vtbl->_ulock(cm,rd,__PROC__);
err:
	return er;
}

int clip_RDDGOTOKEY(ClipMachine* cm){
	const char* __PROC__ = "RDDGOTOKEY";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	unsigned int rec = _clip_parni(cm,2);
	int ok,er;

	if(!rd) return EG_NOTABLE;
	CHECKARG1(2,NUMERIC_t);
	if(rd->curord == -1)
		return 0;

	if((er = rdd_flushbuffer(cm,rd,__PROC__))) goto err;
	READLOCK;
	if((er = rdd_gotokey(cm,rd,rd->orders[rd->curord],rec,&ok,__PROC__)))
		goto err_unlock;
	UNLOCK;
	return 0;
err_unlock:
	rd->vtbl->_ulock(cm,rd,__PROC__);
err:
	return er;
}

int clip_RDDBOF(ClipMachine* cm){
	const char* __PROC__ = "RDDBOF";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	int bof,er;

	if(!rd) return EG_NOTABLE;

	if((er = rdd_bof(cm,rd,&bof,__PROC__))) goto err;
	_clip_retl(cm,bof);
	return 0;
err:
	return er;
}

int clip_RDDEOF(ClipMachine* cm){
	const char* __PROC__ = "RDDEOF";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	int eof,er;

	if(!rd) return EG_NOTABLE;

	if((er = rdd_eof(cm,rd,&eof,__PROC__))) goto err;
	_clip_retl(cm,eof);
	return 0;
err:
	return er;
}

int clip_RDDRECNO(ClipMachine* cm){
	const char* __PROC__ = "RDDRECNO";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	int recno,er;

	if(!rd) return EG_NOTABLE;

	if((er = rdd_recno(cm,rd,&recno,__PROC__))) goto err;
	_clip_retni(cm,recno);
	return 0;
err:
	return er;
}

int clip_RDDLASTREC(ClipMachine* cm){
	const char* __PROC__ = "RDDLASTREC";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	int lastrec,er;

	if(!rd) return EG_NOTABLE;

	READLOCK;
	if((er = rdd_lastrec(cm,rd,&lastrec,__PROC__))) goto err_unlock;
	UNLOCK;
	_clip_retni(cm,lastrec);
	return 0;
err_unlock:
	rd->vtbl->_ulock(cm,rd,__PROC__);
err:
	return er;
}

int clip_RDDKEYNO(ClipMachine* cm){
	const char* __PROC__ = "RDDKEYNO";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	int keyno = 0,er;

	if(!rd) return EG_NOTABLE;

	if((er = rdd_flushbuffer(cm,rd,__PROC__))) goto err;
	READLOCK;
	if((er = rdd_keyno(cm,rd,&keyno,__PROC__))) goto err_unlock;
	UNLOCK;
	_clip_retni(cm,keyno);
	return 0;
err_unlock:
	rd->vtbl->_ulock(cm,rd,__PROC__);
err:
	return er;
}

int clip_RDDLASTKEY(ClipMachine* cm){
	const char* __PROC__ = "RDDLASTKEY";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	int lastkey = 0,er;

	if(!rd) return EG_NOTABLE;

	if((er = rdd_flushbuffer(cm,rd,__PROC__))) goto err;
	READLOCK;
	if((er = rdd_lastkey(cm,rd,&lastkey,__PROC__))) goto err_unlock;
	UNLOCK;
	_clip_retni(cm,lastkey);
	return 0;
err_unlock:
	rd->vtbl->_ulock(cm,rd,__PROC__);
err:
	return er;
}

int clip_RDDGETVALUE(ClipMachine* cm){
	const char* __PROC__ = "RDDGETVALUE";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	int type = _clip_parinfo(cm,2);
	int er;

	if(!rd) return EG_NOTABLE;
	READLOCK;
	if(type==CHARACTER_t){
		const char* fname = _clip_parc(cm,2);
		if((er = rdd_getvaluebn(cm,rd,fname,__PROC__))) goto err_unlock;
	} else if(type==NUMERIC_t){
		int no = _clip_parni(cm,2)-1;
		if((er = rdd_getvalue(cm,rd,no,__PROC__))) goto err_unlock;
	} else {
		er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,er_nofield);
		goto err_unlock;
	}
	UNLOCK;
	return 0;
err_unlock:
	rd->vtbl->_ulock(cm,rd,__PROC__);
err:
	return er;
}

int clip_RDDSETVALUE(ClipMachine* cm){
	const char* __PROC__ = "RDDSETVALUE";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	int type = _clip_parinfo(cm,2);
	ClipVar* vp = _clip_par(cm,3);
	int er;

	if(!rd) return EG_NOTABLE;
	WRITELOCK;
	if(type==CHARACTER_t){
		const char* fname = _clip_parc(cm,2);
		if((er = rdd_setvaluebn(cm,rd,fname,vp,__PROC__))) goto err_unlock;
	} else if(type==NUMERIC_t){
		int no = _clip_parni(cm,2)-1;
		if(no<0 || no>=rd->nfields){
			er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,er_nofield);
			goto err_unlock;
		}
		if((er = rdd_setvalue(cm,rd,no,vp,__PROC__))) goto err_unlock;
	} else {
		er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,er_nofield);
		goto err_unlock;
	}
	UNLOCK;
	return 0;
err_unlock:
	rd->vtbl->_ulock(cm,rd,__PROC__);
err:
	return er;
}

int clip_RDDREAD(ClipMachine* cm){
	const char* __PROC__ = "RDDREAD";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	int er;

	if(!rd) return EG_NOTABLE;
	if((er = rdd_flushbuffer(cm,rd,__PROC__))) goto err;
	READLOCK;
	if((er = rdd_dbread(cm,rd,RETPTR(cm),__PROC__))) goto err_unlock;
	UNLOCK;
	return 0;
err_unlock:
	rd->vtbl->_ulock(cm,rd,__PROC__);
err:
	return er;
}

int clip_RDDWRITE(ClipMachine* cm){
	const char* __PROC__ = "RDDWRITE";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	ClipVar* ap = _clip_par(cm,2);
	int er;

	if(!rd) return EG_NOTABLE;
	CHECKARG1(2,MAP_t);

	_clip_retl(cm,1);
	WRITELOCK;
	if((er = rdd_dbwrite(cm,rd,ap,__PROC__))) goto err_unlock;
	UNLOCK;
	if((er = rdd_flushbuffer(cm,rd,__PROC__))) goto err;
	return 0;
err_unlock:
	rd->vtbl->_ulock(cm,rd,__PROC__);
err:
	return er;
}

int clip_RDDAPPEND(ClipMachine* cm){
	const char* __PROC__ = "RDDAPPEND";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	ClipVar* ap = _clip_par(cm,2);
	int neterr,er;

	if(!rd) return EG_NOTABLE;
	CHECKOPT1(2,MAP_t);

	if((er = rdd_flushbuffer(cm,rd,__PROC__))) goto err;
	WRITELOCK;
	if((er = rdd_append(cm,rd,&neterr,__PROC__))) goto err_unlock;
	if(ap && ap->t.type!=UNDEF_t)
		if((er = rdd_dbwrite(cm,rd,ap,__PROC__))) goto err_unlock;
	UNLOCK;
	if(ap && ap->t.type!=UNDEF_t)
		if((er = rdd_flushbuffer(cm,rd,__PROC__))) goto err;
	_clip_retl(cm,1);
	return 0;
err_unlock:
	rd->vtbl->_ulock(cm,rd,__PROC__);
err:
	return er;
}

int clip_RDDSETFILTER(ClipMachine* cm){
	const char* __PROC__ = "RDDSETFILTER";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	const char* str = _clip_parc(cm,2);
	ClipVar* a = _clip_par(cm,3);
	int lNoOptimize = _clip_parl(cm,4);
	RDD_FILTER* fp;
	int er;

	if(!rd) return EG_NOTABLE;
	CHECKARG1(2,CHARACTER_t);
	CHECKOPT1(3,ARRAY_t);
	CHECKOPT1(4,LOGICAL_t);

	if((er = rdd_clearfilter(cm,rd,__PROC__))) goto err;

	if((er = rdd_flushbuffer(cm,rd,__PROC__))) goto err;
	READLOCK;
	if((er = rdd_createfilter(cm,rd,&fp,NULL,str,a,lNoOptimize,__PROC__))) goto err_unlock;
	fp->active = 1;
	rd->filter = fp;
	if((er = _rdd_calcfiltlist(cm,rd,__PROC__))) goto err_unlock;
	UNLOCK;
	return 0;
err_unlock:
	rd->vtbl->_ulock(cm,rd,__PROC__);
err:
	return er;
}

int clip_RDDFILTER(ClipMachine * cm)
{
	const char* __PROC__ = "RDDFILTER";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);

	if(!rd) return EG_NOTABLE;

	_clip_retc(cm,"");
	if(rd->filter && rd->filter->sfilter)
		_clip_retc(cm,rd->filter->sfilter);
	return 0;
}

int clip_RDDCLEARFILTER(ClipMachine* cm){
	const char* __PROC__ = "RDDCLEARFILTER";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);

	if(!rd) return EG_NOTABLE;

	return rdd_clearfilter(cm,rd,__PROC__);
}

int clip_RDDDELETE(ClipMachine* cm){
	const char* __PROC__ = "RDDDELETE";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	int er;

	if(!rd) return EG_NOTABLE;

	if((er = rdd_flushbuffer(cm,rd,__PROC__))) goto err;
	WRITELOCK;
	if((er = rdd_delete(cm,rd,__PROC__))) goto err_unlock;
	UNLOCK;
	return 0;
err_unlock:
	rd->vtbl->_ulock(cm,rd,__PROC__);
err:
	return er;
}

int clip_RDDRECALL(ClipMachine* cm){
	const char* __PROC__ = "RDDRECALL";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	int er;

	if(!rd) return EG_NOTABLE;

	if((er = rdd_flushbuffer(cm,rd,__PROC__))) goto err;
	WRITELOCK;
	if((er = rdd_recall(cm,rd,__PROC__))) goto err_unlock;
	UNLOCK;
	return 0;
err_unlock:
	rd->vtbl->_ulock(cm,rd,__PROC__);
err:
	return er;
}

int clip_RDDDELETED(ClipMachine* cm){
	const char* __PROC__ = "RDDDELETED";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	int deleted,er;

	if(!rd) return EG_NOTABLE;

	READLOCK;
	if((er = rdd_deleted(cm,rd,&deleted,__PROC__))) goto err_unlock;
	UNLOCK;
	_clip_retl(cm,deleted);
	return 0;
err_unlock:
	rd->vtbl->_ulock(cm,rd,__PROC__);
err:
	return er;
}

int clip_RDDINDEXKEY(ClipMachine* cm){
	const char* __PROC__ = "RDDINDEXKEY";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);

	if(!rd) return EG_NOTABLE;

	if(rd->curord!=-1)
		_clip_retc(cm,rd->orders[rd->curord]->expr);
	return 0;
}

int clip_RDDFCOUNT(ClipMachine* cm){
	const char* __PROC__ = "RDDFCOUNT";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);

	if(!rd) return EG_NOTABLE;

	_clip_retni(cm,rd->nfields);
	return 0;
}

int clip_RDDFIELDPOS(ClipMachine* cm){
	const char* __PROC__ = "RDDFIELDPOS";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	char* fname = _clip_parc(cm,2);

	if(!rd) return EG_NOTABLE;

	_clip_retni(cm,_rdd_fieldno(rd,_clip_casehashword(fname,strlen(fname)))+1);
	return 0;
}

int clip_RDDFIELDNAME(ClipMachine* cm){
	const char* __PROC__ = "RDDFIELDNAME";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	int fno = _clip_parni(cm,2);

	if(!rd) return EG_NOTABLE;

	if(fno>rd->nfields)
		_clip_retc(cm,"");
	else
		_clip_retc(cm,rd->fields[fno-1].name);
	return 0;
}

int clip_RDDLOCATE(ClipMachine * cm)
{
	const char *__PROC__ = "RDDLOCATE";
	int r = _clip_parni(cm,1);
	char* fe = _clip_parc(cm,2);
	char* we = _clip_parc(cm,3);
	ClipVar *vnext = _clip_par(cm,4);
	ClipVar *vrec = _clip_par(cm,5);
	ClipVar *vrest = _clip_par(cm,6);
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	ClipVar fexpr;
	ClipVar wexpr;
	int found,er;
	char expexp[1024];

	if(!rd) return EG_NOTABLE;
	CHECKARG1(2,CHARACTER_t);
	CHECKOPT1(3,CHARACTER_t);

	memset(&fexpr,0,sizeof(ClipVar));
	memset(&wexpr,0,sizeof(ClipVar));
	memset(expexp,0,sizeof(expexp));
	rdd_expandmacro(rd->area,r,fe,expexp);
	if((er = rdd_flushbuffer(cm,rd,__PROC__))) goto err;
	READLOCK;
	if((er = _clip_eval_macro(cm,expexp,strlen(expexp),&fexpr)))
		goto err_unlock;
	if(we){
		memset(expexp,0,sizeof(expexp));
		rdd_expandmacro(rd->area,r,we,expexp);
		if((er = _clip_eval_macro(cm,expexp,strlen(expexp),&wexpr)))
			goto err_unlock;
	}
	if((er = rdd_locate(cm,rd,fe,&fexpr,&wexpr,vnext,vrec,vrest,&found,__PROC__)))
		goto err_unlock;
	UNLOCK;

	_clip_destroy(cm,&fexpr);
	_clip_destroy(cm,&wexpr);

	_clip_retl(cm,found);
	return 0;
err_unlock:
	rd->vtbl->_ulock(cm,rd,__PROC__);
err:
	_clip_destroy(cm,&fexpr);
	_clip_destroy(cm,&wexpr);
	return er;
}

int
clip_RDDCONTINUE(ClipMachine * cm){
	const char *__PROC__ = "RDDCONTINUE";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	int found;
	int er;

	if(!rd) return EG_NOTABLE;

	if((er = rdd_flushbuffer(cm,rd,__PROC__))) goto err;
	READLOCK;
	if((er = rdd_continue(cm,rd,&found,__PROC__))) goto err_unlock;
	UNLOCK;

	_clip_retl(cm,found);
	return 0;
err_unlock:
	rd->vtbl->_ulock(cm,rd,__PROC__);
err:
	return er;
}

int clip_RDDSTRUCT(ClipMachine* cm){
	const char* __PROC__ = "RDDSTRUCT";
	int nfld, i;
	ClipVar *rp = RETPTR(cm);
	long vect[2];
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);

	if(!rd) return EG_NOTABLE;

	nfld = rd->nfields;
	vect[0] = nfld;
	vect[1] = 4;
	_clip_array(cm,rp,2,vect);

	for(i=0;i<nfld;i++){
		ClipVar var;
		RDD_FIELD* fp = &rd->fields[i];

		vect[0] = i;
		memset(&var,0,sizeof(ClipVar));

		var.t.type = CHARACTER_t;
		var.s.str.buf = fp->name;
		var.s.str.len = strlen(fp->name);
		vect[1] = 0;
		_clip_aset(cm,rp,&var,2,vect);

		var.s.str.buf = malloc(2);
		var.s.str.buf[0] = fp->type;
		var.s.str.buf[1] = 0;
		var.s.str.len = 1;
		vect[1] = 1;
		_clip_aset(cm,rp,&var,2,vect);
		free(var.s.str.buf);

		var.t.type = NUMERIC_t;
		var.n.d = fp->len;
		var.t.memo = 0;
		vect[1] = 2;
		_clip_aset(cm,rp,&var,2,vect);

		var.n.d = fp->dec;
		vect[1] = 3;
		_clip_aset(cm,rp,&var,2,vect);
	}
	return 0;
}

int clip_RDDORDSCOPE(ClipMachine* cm){
	const char* __PROC__ = "RDDORDSCOPE";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	int scope = _clip_parni(cm,2);
	ClipVar* v = _clip_par(cm,3);
	int er;

	if(!rd) return EG_NOTABLE;
	CHECKARG1(1,NUMERIC_t);

	if((er = rdd_flushbuffer(cm,rd,__PROC__))) goto err;
	READLOCK;
	if(scope==0){
		if((er = rdd_scopetop(cm,rd,v,__PROC__))) goto err_unlock;
	} else if(scope==1){
		if((er = rdd_scopebottom(cm,rd,v,__PROC__))) goto err_unlock;
	} else {
		er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,er_badargument2);
		goto err_unlock;
	}
	UNLOCK;
	return 0;
err_unlock:
	rd->vtbl->_ulock(cm,rd,__PROC__);
err:
	return er;
}

int clip_RDDNEWFILTER(ClipMachine* cm)
{
	const char* __PROC__ = "RDDNEWFILTER";
	int type = _clip_parinfo(cm,2);
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	RDD_FILTER* fp;
	int er;

	if(!rd) return EG_NOTABLE;

	if((er = rdd_flushbuffer(cm,rd,__PROC__))) goto err;
	READLOCK;
	if(type==NUMERIC_t || type==UNDEF_t){
		unsigned int len = _clip_parni(cm,2);
		if((er = rdd_createuserfilter(cm,rd,&fp,len,__PROC__))) goto err_unlock;
	} else if(type==CHARACTER_t){
		char* str = _clip_parc(cm,2);
		if((er = rdd_createfilter(cm,rd,&fp,NULL,str,NULL,0,__PROC__))) goto err_unlock;
	} else {
		er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,er_badargument2);
		goto err_unlock;
	}
	UNLOCK;
	_clip_retni(cm,fp->handle);
	return 0;
err_unlock:
	rd->vtbl->_ulock(cm,rd,__PROC__);
err:
	return er;
}

int
clip_RDDSETAREAFILTER(ClipMachine* cm)
{
	const char* __PROC__ = "RDDSETAREAFILTER";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	int h = _clip_parni(cm,2);
	RDD_FILTER* fp;
	int er;

	if(!rd) return EG_NOTABLE;
	CHECKARG1(2,NUMERIC_t);

	fp = (RDD_FILTER*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_RYO);
	if(!fp){
		er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,er_badfilter);
		goto err;
	}
	fp->active = 1;
	if(rd->filter)
		rd->filter->active = 0;
	rd->filter = fp;
	_clip_retl(cm,1);
	return 0;
err:
	return er;
}

int
clip_RDDGETAREAFILTER(ClipMachine* cm)
{
	const char* __PROC__ = "RDDGETAREAFILTER";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);

	if(!rd) return EG_NOTABLE;

	if(rd->filter)
		_clip_retni(cm,rd->filter->handle);
	else
		_clip_retni(cm,-1);
	return 0;
}

int
clip_RDDRLOCK(ClipMachine* cm)
{
	const char* __PROC__ = "RDDRLOCK";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	unsigned int recno = _clip_parni(cm,2);
	int lrelease = _clip_parl(cm,3);
	int r,er;

	if(!rd) return EG_NOTABLE;

	CHECKOPT1(2,NUMERIC_t);
	CHECKOPT1(3,LOGICAL_t);

	if(recno==0)
		recno = rd->recno;

	if (_clip_parinfo(cm,3)==UNDEF_t)
		lrelease = 1;

	if((er = rdd_flushbuffer(cm,rd,__PROC__))) goto err;
	if(lrelease){
		if((er = rdd_ulock(cm,rd,0,0,__PROC__))) goto err;
	}

	if((er = rdd_rlock(cm,rd,recno,&r,__PROC__))) goto err;

	_clip_retl(cm,r);
	return 0;
err:
	return er;
}

int
clip_RDDUNLOCK(ClipMachine* cm)
{
	const char* __PROC__ = "RDDUNLOCK";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	unsigned int recno = _clip_parni(cm,2);
	int er;

	if(!rd) return EG_NOTABLE;

	CHECKOPT1(2,NUMERIC_t);

	if(_clip_parinfo(cm,2) == UNDEF_t){
		recno = rd->recno;
	}

	if((er = rdd_flushbuffer(cm,rd,__PROC__))) goto err;
	if((er = rdd_ulock(cm,rd,recno,1,__PROC__))) goto err;
	return 0;
err:
	return er;
}

int
clip_RDDFIELDDECI(ClipMachine* cm)
{
	const char* __PROC__ = "RDDFIELDDECI";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	int fno = _clip_parni(cm,2)-1;
	int dec = 0,er;

	CHECKARG1(1,NUMERIC_t);

	if(rd){
		if(fno >= 0 && fno < rd->nfields)
			dec = rd->fields[fno].dec;
	}
	_clip_retni(cm,dec);
	return 0;
err:
	return er;
}

int
clip_RDDFIELDNUM(ClipMachine* cm)
{
	return clip_RDDFIELDPOS(cm);
}

int
clip_RDDFIELDSIZE(ClipMachine* cm)
{
	const char* __PROC__ = "RDDFIELDSIZE";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	int fno = _clip_parni(cm,2)-1;
	int len = 0,er;

	CHECKARG1(1,NUMERIC_t);

	if(rd){
		if(fno >= 0 && fno < rd->nfields)
			len = rd->fields[fno].len;
	}
	_clip_retni(cm,len);
	return 0;
err:
	return er;
}

int
clip_RDDFIELDTYPE(ClipMachine* cm)
{
	const char* __PROC__ = "RDDFIELDTYPE";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	int fno = _clip_parni(cm,2)-1;
	char type[2] = " ";
	int er;

	CHECKARG1(1,NUMERIC_t);

	if(rd){
		if(fno >= 0 && fno < rd->nfields)
			type[0] = rd->fields[fno].type;
	}

	_clip_retc(cm,type);
	return 0;
err:
	return er;
}

/* SIX */

int clip_RDD_M6_NEWFILTER(ClipMachine* cm)
{
	const char* __PROC__ = "RDD_M6_NEWFILTER";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	int type = _clip_parinfo(cm,2);
	RDD_FILTER* fp;
	int er;

	if(!rd) return EG_NOTABLE;
	CHECKOPT2(2,NUMERIC_t,CHARACTER_t);

	READLOCK;
	if(type==NUMERIC_t || type==UNDEF_t){
		unsigned int len = _clip_parni(cm,2);
		if((er = rdd_createuserfilter(cm,rd,&fp,len,__PROC__)))
			goto err_unlock;
	} else if(type==CHARACTER_t){
		char* str = _clip_parc(cm,2);
		if((er = rdd_createfilter(cm,rd,&fp,NULL,str,NULL,0,__PROC__)))
			goto err_unlock;
	}
	UNLOCK;

	_clip_retni(cm,fp->handle);
	return 0;

err_unlock:
	rd->vtbl->_ulock(cm,rd,__PROC__);
err:
	return er;
}

int clip_RDD_M6_SETAREAFILTER(ClipMachine* cm)
{
	const char* __PROC__ = "RDD_M6_SETAREAFILTER";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	int h = _clip_parni(cm,2);
	char expr[PATH_MAX];
	RDD_FILTER* fp;
	int er;

	if(!rd) return EG_NOTABLE;
	CHECKARG1(2,NUMERIC_t);

	fp = (RDD_FILTER*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_RYO);
	if(!fp){
		er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,er_badfilter);
		goto err;
	}
	fp->active = 1;
	if(rd->filter)
		rd->filter->active = 0;
	rd->filter = fp;

	fp->rd = rd;
	if(!fp->custom){
		rdd_expandmacro(rd->area,0,fp->sfilter,expr);
		if((er = _clip_eval_macro(cm,expr,strlen(expr),&fp->fps->bfilter)))
			goto err;
	}

	_clip_retl(cm,1);
	return 0;
err:
	return er;
}

int
clip_RDD_M6_GETAREAFILTER(ClipMachine* cm)
{
	const char* __PROC__ = "RDD_M6_GETAREAFILTER";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);

	if(!rd) return EG_NOTABLE;

	if(rd->filter)
		_clip_retni(cm,rd->filter->handle);
	else
		_clip_retni(cm,-1);
	return 0;
}

int clip_RDD_M6_ADDSCOPED(ClipMachine* cm){
	const char* __PROC__ = "RDD_M6_ADDSCOPED";
	RDD_DATA* rd = _fetch_rdd(cm,__PROC__);
	int h = _clip_parni(cm,2);
	RDD_FILTER* fp;
	ClipVar* t = _clip_vptr(_clip_par(cm,3));
	ClipVar* b = _clip_vptr(_clip_par(cm,4));
	int ord = _clip_parni(cm,5)-1;
	int er;

	if(!rd) return EG_NOTABLE;
	CHECKARG1(2,NUMERIC_t);
	CHECKOPT1(5,NUMERIC_t);

	fp = (RDD_FILTER*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_RYO);
	if(!fp){
		er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,er_badfilter);
		goto err;
	}
	if(!fp->rmap){
		er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,er_badfilter);
		goto err;
	}
	if(_clip_parinfo(cm,5) == UNDEF_t)
		ord = rd->curord;
	if(ord >= rd->ords_opened)
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
	if((er = rd->orders[ord]->vtbl->setscope(cm,rd,rd->orders[ord],
		t,b,fp->rmap,fp->size,0,__PROC__))) goto err_unlock;
	UNLOCK;

	return 0;
err_unlock:
	rd->vtbl->_ulock(cm,rd,__PROC__);
err:
	return er;
}
