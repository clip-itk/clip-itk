#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <errno.h>
#include "clip.h"
#include "coll.h"
#include "../screen/charset.h"
#include "dbfsql.h"
#include "error.ch"

const char subsys[]             = "DBFSQL";
const char er_connect[]         = "Can't connect to database server";
const char er_noconnect[]       = "No such connection";
const char er_nosql[]           = "No SQL statement";
const char er_nostatement[]     = "No statement. PREPARE must be executed first";
const char er_badselect[]       = "SELECT statement expected";
const char er_norowset[]        = "No such rowset";
const char er_nofield[]         = "No field";
const char er_typemismatch[]    = "RDBMS and Clipper types are incompatible or RDBMS type is not supported";
const char er_badstatement[]    = "Non SELECT statement expected";
const char er_orderexist[]      = "Order exists";
const char er_noorder[]         = "No order";
const char er_badorderlen[]     = "Bad length of order key value";
const char er_badordertype[]    = "Unsupported type of order key value";
const char er_badorders[]       = "Bad orders";
const char er_internal[]        = "Internal error (no row)";

static int sql_fillorders(ClipMachine* mp,SQLROWSET* rowset){
	int k;
	int oldrecno = rowset->recno;

	if(rowset->conn->vtbl->fetch(mp,rowset,0,NULL,0,NULL)) return 1;

	for(rowset->recno = 1;rowset->recno <= rowset->lastrec;rowset->recno++){
		for(k=0;k<rowset->ntags;k++){
			if(sql_orderadd(mp,rowset,rowset->taghashes[k])) return 1;
		}
	}
	rowset->recno = oldrecno;
	return 0;
}

int clip_SQLLIST(ClipMachine* mp){
	ClipVar* r = RETPTR(mp);
	long dims[1] = {0};
	int i;

	_clip_array(mp,r,1,dims);
	for(i=0;i<*mp->nsqldrivers;i++){
		ClipVar a;
		ClipVar e;

		memset(&a,0,sizeof(ClipVar));
		memset(&e,0,sizeof(ClipVar));
		_clip_array(mp,&a,1,dims);
		e.t.type = CHARACTER_t;
		e.s.str.len = strlen((*mp->sqldrivers)[i].id);
		e.s.str.buf = (*mp->sqldrivers)[i].id;
		_clip_aadd(mp,&a,&e);
		e.s.str.len = strlen((*mp->sqldrivers)[i].name);
		e.s.str.buf = (*mp->sqldrivers)[i].name;
		_clip_aadd(mp,&a,&e);
		e.s.str.len = strlen((*mp->sqldrivers)[i].desc);
		e.s.str.buf = (*mp->sqldrivers)[i].desc;
		_clip_aadd(mp,&a,&e);
		_clip_aadd(mp,r,&a);
	}
	return 0;
}

int clip_SQLCREATECONN(ClipMachine* mp){
	char* id = _clip_parc(mp,1);
	int conn_item = -1;
	SQLCONN* conn;
	const char* sqlcs = _clip_parc(mp,9);
	int i;

	for(i=0;i<(*mp->nsqldrivers);i++){
		if(strcasecmp(id,(*mp->sqldrivers)[i].id) == 0){
			conn_item = (*(*mp->sqldrivers)[i].connect)(mp);
			if(conn_item==-1){
				return 1;
			}
			break;
		}
	}
	if(i==*mp->nsqldrivers){
		char err[256];
		snprintf(err,sizeof(err),";Unknown RDBMS (bad identifier '%s' or library not linked);",id);
		_clip_trap_err(mp,0,0,0,subsys,ER_NOLIB,err);
		return 1;
	}

	conn = (SQLCONN*)_clip_fetch_c_item(mp,conn_item,_C_ITEM_TYPE_SQL);
	conn->loc = SQL_get_locale(mp,sqlcs);

	_clip_retni(mp,conn_item);
	return 0;
}

int clip_SQLDESTROYCONN(ClipMachine* mp){
	int conn_item = _clip_parni(mp,1);
	SQLCONN* conn = (SQLCONN*)_clip_fetch_c_item(
		mp,conn_item,_C_ITEM_TYPE_SQL);

	if(!conn){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOCONNECT,er_noconnect);
		return 1;
	}
	conn->vtbl->destroyconn(conn);
	_clip_destroy_c_item(mp,conn_item,_C_ITEM_TYPE_SQL);
	return 0;
}

int clip_SQLPREPARE(ClipMachine* mp){
	SQLCONN* conn = (SQLCONN*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	char* sql = _clip_parc(mp,2);
	int res;

	if(!conn){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOCONNECT,er_noconnect);
		return 1;
	}
	if(!sql){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOSQL,er_nosql);
		return 1;
	}
	if((res = conn->vtbl->prepare(mp,conn,sql))==-1) return 1;
	_clip_retni(mp,res);
	return 0;
}

int clip_SQLFREESTMT(ClipMachine* mp){
	int stmt_item = _clip_parni(mp,1);
	SQLSTMT* stmt = (SQLSTMT*)_clip_fetch_c_item(
		mp,stmt_item,_C_ITEM_TYPE_SQL);

	if(!stmt){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOSTATEMENT,er_nostatement);
		return 1;
	}

	_clip_destroy_c_item(mp,stmt->stmt_item,_C_ITEM_TYPE_SQL);
	return 0;
}

int clip_SQLCOMMAND(ClipMachine* mp){
	SQLSTMT* stmt = (SQLSTMT*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	ClipVar* ap = _clip_par(mp,2);
	int res;

	if(!stmt){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOSTATEMENT,er_nostatement);
		return 1;
	}
	if((res = stmt->conn->vtbl->command(mp,stmt,ap)) == -1){
		_clip_destroy_c_item(mp,stmt->stmt_item,_C_ITEM_TYPE_SQL);
		return 1;
	}
	_clip_retni(mp,res);
	return 0;
}

int clip_SQLTESTPARSER(ClipMachine* mp){
	SQLCONN* conn = (SQLCONN*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	const char* sql = _clip_parc(mp,2);
	ClipVar* ap = _clip_par(mp,3);
	char* r = conn->vtbl->testparser(mp,strdup(sql),ap);

	_clip_retcn_m(mp,r,strlen(r));
	return 0;
}

int _sql_fetch(ClipMachine* mp,SQLROWSET* rowset){
	if(rowset->recno > rowset->loaded){
		if(rowset->conn->vtbl->fetch(mp,rowset,rowset->recno - rowset->loaded,
			NULL,0,NULL))
			return 1;
	}
	if(rowset->done && (rowset->loaded == 0)){
		rowset->recno = 0;
		rowset->bof = rowset->eof = 1;
	}
	return 0;
}

int clip_SQLCREATEROWSET(ClipMachine* mp){
	ClipVar* rmap = _clip_spar(mp,1);
	SQLSTMT* stmt = (SQLSTMT*)_clip_fetch_c_item(
		mp,_clip_parni(mp,2),_C_ITEM_TYPE_SQL);
	ClipVar* ap = _clip_par(mp,3);
	ClipVar* idname = _clip_par(mp,4);
	ClipVar* orders = _clip_par(mp,5);
	const char* gen_idSQL = _clip_parc(mp,6);
	SQLROWSET* rowset;
	ClipVar *oname,*oexpr,*olen,*el;
	long dims[1];
	int i;

	if(!stmt){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOSTATEMENT,er_nostatement);
		return 1;
	}
	if(orders && orders->t.type != ARRAY_t && orders->t.type != UNDEF_t){
		_clip_trap_err(mp,0,0,0,subsys,EG_ARG,er_badorders);
		return 1;
	}

	rowset = calloc(1,stmt->conn->vtbl->sizeof_rowset);
	rowset->orders = new_HashTable();
	rowset->conn = stmt->conn;
	rowset->stmt = stmt;
	if(orders && orders->t.type == ARRAY_t){
		rowset->ntags = orders->a.count;
		rowset->taghashes = calloc(orders->a.count,sizeof(long));
		for(i=0;i<orders->a.count;i++){
			dims[0] = i;
			if(!(el = _clip_aref(mp,orders,1,dims))){
				_clip_trap_err(mp,0,0,0,subsys,EG_ARG,er_badorders);
				return 1;
			}
			dims[0] = 0;
			if(!(oname = _clip_aref(mp,el,1,dims)) || oname->t.type != CHARACTER_t){
				_clip_trap_err(mp,0,0,0,subsys,EG_ARG,er_badorders);
				return 1;
			}
			rowset->taghashes[i] = _clip_casehashstr(oname->s.str.buf);
			dims[0] = 1;
			if(!(oexpr = _clip_aref(mp,el,1,dims))){
				_clip_trap_err(mp,0,0,0,subsys,EG_ARG,er_badorders);
				return 1;
			}
			dims[0] = 2;
			if((olen = _clip_aref(mp,el,1,dims)) && olen->t.type != NUMERIC_t){
				_clip_trap_err(mp,0,0,0,subsys,EG_ARG,er_badorders);
				return 1;
			}
			if(sql_createorder(mp,rmap,rowset,oname->s.str.buf,oexpr,(olen?olen->n.d:0)))
				return 1;
		}
	}
	if(stmt->conn->vtbl->createrowset(mp,rowset,ap,idname,gen_idSQL)){
		_clip_destroy_c_item(mp,rowset->rowset_item,_C_ITEM_TYPE_SQL);
		return 1;
	}

	if(!rowset->unknownrows && rowset->lastrec==0){
		rowset->bof = rowset->eof = 1;
		rowset->recno = 0;
	} else {
		rowset->recno = 1;
		if(_sql_fetch(mp,rowset)) return 1;
	}

	_clip_retni(mp,rowset->rowset_item);
	return 0;
}

int clip_SQLGETHOT(ClipMachine* mp){
	int rowset_item = _clip_parni(mp,1);
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,rowset_item,_C_ITEM_TYPE_SQL);

	_clip_retl(mp,rowset->hot);
	return 0;
}

int clip_SQLSETHOT(ClipMachine* mp){
	int rowset_item = _clip_parni(mp,1);
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,rowset_item,_C_ITEM_TYPE_SQL);

	rowset->hot = _clip_parl(mp,2);
	return 0;
}

int clip_SQLFILLORDERS(ClipMachine* mp){
	int rowset_item = _clip_parni(mp,1);
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,rowset_item,_C_ITEM_TYPE_SQL);

	return sql_fillorders(mp,rowset);
}

int clip_SQLDESTROYROWSET(ClipMachine* mp){
	int rowset_item = _clip_parni(mp,1);
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,rowset_item,_C_ITEM_TYPE_SQL);
	int r;

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}

	r = HashTable_first(rowset->orders);
	while(r){
		SQLORDER* order = HashTable_current(rowset->orders);

		_clip_destroy(mp,order->block);
		free(order->block);
		if(order->bt)
			bt_destroy(order->bt);
		free(order->rmap);
		free(order->name);
		free(order);
		r = HashTable_next(rowset->orders);
	}
	delete_HashTable(rowset->orders);

	if(rowset->ids)
		free(rowset->ids);

	if(!rowset->done)
		_clip_destroy_c_item(mp,rowset->stmt->stmt_item,_C_ITEM_TYPE_SQL);

	_clip_destroy_c_item(mp,rowset_item,_C_ITEM_TYPE_SQL);
	return 0;
}

int clip_SQLGOTOP(ClipMachine* mp){
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if(rowset->done && !rowset->lastrec){
		rowset->bof = rowset->eof = 1;
		rowset->recno = 0;
		return 0;
	}
	if(rowset->curord){
		if(!rowset->curord->bt || bt_first(rowset->curord->bt)){
			rowset->bof = rowset->eof = 1;
			rowset->recno = 0;
		} else {
			rowset->recno = *(int*)bt_key(rowset->curord->bt);
		}
	}
	rowset->bof = rowset->eof = 0;
	rowset->recno = 1;
	if(_sql_fetch(mp,rowset)) return 1;
	return 0;
}

int clip_SQLGOBOTTOM(ClipMachine* mp){
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if(rowset->done && !rowset->lastrec){
		rowset->bof = rowset->eof = 1;
		rowset->recno = 0;
		return 0;
	}
	if(rowset->curord){
		if(!rowset->curord->bt || bt_last(rowset->curord->bt)){
			rowset->bof = rowset->eof = 1;
			rowset->recno = 0;
		} else {
			rowset->recno = *(int*)bt_key(rowset->curord->bt);
		}
	}
	rowset->bof = rowset->eof = 0;
	if(rowset->conn->vtbl->fetch(mp,rowset,0,NULL,0,NULL)) return 1;
	rowset->recno = rowset->lastrec;
	return 0;
}

static int sql_searchtree(ClipMachine* mp,SQLROWSET* rowset,SQLORDER* order){
	ClipVar var;
	void* k = calloc(1,order->len);
	int found;

	*(int*)k = rowset->recno;
	if(_clip_eval(mp,order->block,1,order->rmap,&var))
		return 1;
	switch(var.t.type){
		case CHARACTER_t:
			if(var.s.str.len > order->len){
				free(k);
				return 0;
			}
			memcpy((char*)k+sizeof(int),var.s.str.buf,var.s.str.len);
			break;
		case NUMERIC_t:
			*(double*)((char*)k+sizeof(int)) = var.n.d;
			break;
		case DATE_t:
			*(long*)((char*)k+sizeof(int)) = var.d.julian;
			break;
		case DATETIME_t:
			*(long*)((char*)k+sizeof(int)) = var.dt.julian;
			*(long*)((char*)k+sizeof(int)+sizeof(long)) = var.dt.time;
			break;
		default:
			break;
	}
	_clip_destroy(mp,&var);
	found = bt_seek(order->bt,order,k);
	free(k);
	if(!found){
		_clip_trap_err(mp,0,0,0,subsys,ER_INTERNAL,er_internal);
		return 1;
	}
	return 0;
}

int clip_SQLSKIP(ClipMachine* mp){
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	int rows = _clip_parni(mp,2);
	int oldrecno,skipped = 0;

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if(!rows || (rowset->bof && rowset->eof)){
		_clip_retni(mp,0);
		return 0;
	}
	if(!((rows > 0 && rowset->eof) || (rows < 0 && rowset->bof))){
		rowset->bof = rowset->eof = 0;
		if(rowset->curord){
			int i,j;

			if(sql_searchtree(mp,rowset,rowset->curord)) return 1;
			for(i=0,j=0;i<abs(rows);i++,j++){
				if(rows>0){
					if(bt_next(rowset->curord->bt)){
						rowset->eof = 1;
						break;
					}
				} else {
					if(bt_prev(rowset->curord->bt)){
						rowset->bof = 1;
						break;
					}
				}
			}
			rowset->recno = *(int*)bt_key(rowset->curord->bt);
			skipped = j;
		} else {
			oldrecno = rowset->recno;
			rowset->recno += rows;
			if(_sql_fetch(mp,rowset)) return 1;
			if(rowset->recno<1){
				rowset->recno = 1;
				rowset->bof = 1;
			} else if(rowset->done && rowset->recno>rowset->lastrec){
				rowset->recno = rowset->lastrec;
				rowset->eof = 1;
			}
			skipped = rowset->recno-oldrecno;
		}
	}
	_clip_retni(mp,skipped);
	return 0;
}

int clip_SQLGOTO(ClipMachine* mp){
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	int row = _clip_parni(mp,2);

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if(rowset->lastrec>0 || rowset->unknownrows){
		rowset->bof = rowset->eof = 0;
		rowset->recno = row;
		if(_sql_fetch(mp,rowset)) return 1;
		if(rowset->done && row>rowset->lastrec){
			rowset->recno = rowset->lastrec;
			rowset->eof = 1;
		} else if(row<1){
			rowset->recno = 1;
			rowset->bof = 1;
		}
	}
	_clip_retni(mp,rowset->recno);
	return 0;
}

int clip_SQLBOF(ClipMachine* mp){
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	_clip_retl(mp,rowset->bof?1:0);
	return 0;
}

int clip_SQLEOF(ClipMachine* mp){
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	_clip_retl(mp,rowset->eof?1:0);
	return 0;
}

int clip_SQLRECNO(ClipMachine* mp){
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	_clip_retni(mp,rowset->recno);
	return 0;
}

int clip_SQLLASTREC(ClipMachine* mp){
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	_clip_retni(mp,rowset->lastrec);
	return 0;
}

int clip_SQLGETVALUE(ClipMachine* mp){
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	int fieldno = _clip_parni(mp,2)-1;
	char* data;
	int len;

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if(fieldno<0 || fieldno>=rowset->nfields){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOFIELD,er_nofield);
		return 1;
	}
	if(rowset->recno){
		data = rowset->conn->vtbl->getvalue(rowset,fieldno,&len);
		if(data){
			_clip_retcn(mp,data,len);
		}
	}
	return 0;
}

static int sql_orderdel(ClipMachine* mp,SQLROWSET* rowset,long taghash){
	SQLORDER* order = (SQLORDER*)HashTable_fetch(rowset->orders,taghash);

	if(!order){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOORDER,er_noorder);
		return 1;
	}
	return bt_del(order->bt);
}

int clip_SQLSETVALUE(ClipMachine* mp){
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	int fieldno = _clip_parni(mp,2)-1;
	int len,k;
	char* value = _clip_parcl(mp,3,&len);
	SQLORDER* order;

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if(fieldno<0 || fieldno>=rowset->nfields){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOFIELD,er_nofield);
		return 1;
	}

	if(!value) len = 0;
	if(!rowset->newrec){
		for(k=0;k<rowset->ntags;k++){
			order = (SQLORDER*)HashTable_fetch(rowset->orders,rowset->taghashes[k]);
			if(sql_searchtree(mp,rowset,order)) return 1;
			if(sql_orderdel(mp,rowset,rowset->taghashes[k])) return 1;
		}
	}
	rowset->conn->vtbl->setvalue(rowset,fieldno,value,len);
	if(!rowset->newrec){
		for(k=0;k<rowset->ntags;k++){
			order = (SQLORDER*)HashTable_fetch(rowset->orders,rowset->taghashes[k]);
			if(sql_orderadd(mp,rowset,rowset->taghashes[k])) return 1;
		}
	}
	return 0;
}

int clip_SQLADDKEYS(ClipMachine* mp){
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	int k;

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	for(k=0;k<rowset->ntags;k++){
		if(sql_orderadd(mp,rowset,rowset->taghashes[k])) return 1;
	}
	rowset->newrec = 0;
	return 0;
}

int clip_SQLAPPEND(ClipMachine* mp){
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if(rowset->conn->vtbl->fetch(mp,rowset,0,NULL,0,NULL)) return 1;
	rowset->conn->vtbl->append(rowset);
	rowset->recno = rowset->lastrec;
	rowset->bof = rowset->eof = 0;
	rowset->newrec = 1;
	return 0;
}

int clip_SQLDELETE(ClipMachine* mp){
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if(rowset->conn->vtbl->fetch(mp,rowset,0,NULL,0,NULL)) return 1;
	if(rowset->lastrec>0){
		int oldrecno = rowset->recno;
		int newrecno = 0,k;

		rowset->bof = rowset->eof = 0;
		if(rowset->curord){
			int eof;
			if(sql_searchtree(mp,rowset,rowset->curord)) return 1;
			if((eof = bt_next(rowset->curord->bt))){
				bt_prev(rowset->curord->bt);
			}
			newrecno = *(int*)bt_key(rowset->curord->bt);
			if(newrecno>rowset->recno)
				newrecno--;
			if(!eof)
				bt_prev(rowset->curord->bt);
		}
		for(k=0;k<rowset->ntags;k++){
			SQLORDER* order = (SQLORDER*)HashTable_fetch(rowset->orders,rowset->taghashes[k]);
			if(sql_searchtree(mp,rowset,order)) return 1;
			if(sql_orderdel(mp,rowset,rowset->taghashes[k])) return 1;
		}
		rowset->conn->vtbl->delete_(rowset);
		rowset->lastrec--;
		rowset->loaded--;
		if(rowset->lastrec==0){
			rowset->bof = rowset->eof = 1;
			rowset->recno = 0;
		} else if(newrecno){
			rowset->recno = newrecno;
		} else if(rowset->recno>rowset->lastrec){
			rowset->recno = rowset->lastrec;
			rowset->eof = 1;
		}
		for(k=0;k<rowset->ntags;k++){
			SQLORDER* order = (SQLORDER*)HashTable_fetch(rowset->orders,rowset->taghashes[k]);
			bt_first(order->bt);
			do {
				if(bt_key(order->bt) && *(int*)bt_key(order->bt) > oldrecno)
					(*(int*)bt_key(order->bt))--;
			} while(!bt_next(order->bt));
		}
	}
	return 0;
}

int clip_SQLNFIELDS(ClipMachine* mp){
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	_clip_retni(mp,rowset->nfields);
	return 0;
}

int clip_SQLFIELDNO(ClipMachine* mp){
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	char* fieldname = _clip_parc(mp,2);
	int nfield = -1;

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	while((++nfield<rowset->nfields)&&
		(strncasecmp(rowset->fields[nfield].name,fieldname,MAXFIELDNAME)));
	if(nfield>=rowset->nfields){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOFIELD,er_nofield);
		return 1;
	}

	_clip_retni(mp,nfield+1);
	return 0;
}

int clip_SQLFIELDNAME(ClipMachine* mp){
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	int fieldno = _clip_parni(mp,2);

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if(fieldno < 1 || fieldno > rowset->nfields){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOFIELD,er_nofield);
		return 1;
	}
	_clip_retc(mp,rowset->fields[fieldno-1].name);
	return 0;
}

int clip_SQLFIELDTYPE(ClipMachine* mp){
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	int fieldno = _clip_parni(mp,2);

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if(fieldno < 1 || fieldno > rowset->nfields){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOFIELD,er_nofield);
		return 1;
	}
	_clip_retc(mp,rowset->fields[fieldno-1].ctype);
	return 0;
}

int clip_SQLFIELDTYPESQL(ClipMachine* mp){
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	int fieldno = _clip_parni(mp,2);

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if(fieldno < 1 || fieldno > rowset->nfields){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOFIELD,er_nofield);
		return 1;
	}
	_clip_retni(mp,rowset->fields[fieldno-1].type);
	return 0;
}

int clip_SQLFIELDNULLABLE(ClipMachine* mp){
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	int fieldno = _clip_parni(mp,2);

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if(fieldno < 1 || fieldno > rowset->nfields){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOFIELD,er_nofield);
		return 1;
	}
	_clip_retl(mp,!rowset->fields[fieldno-1].notnull);
	return 0;
}

int clip_SQLFIELDUNSIGNED(ClipMachine* mp){
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	int fieldno = _clip_parni(mp,2);

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if(fieldno < 1 || fieldno > rowset->nfields){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOFIELD,er_nofield);
		return 1;
	}
	_clip_retl(mp,rowset->fields[fieldno-1].unsign);
	return 0;
}

int clip_SQLFIELDBINARY(ClipMachine* mp){
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	int fieldno = _clip_parni(mp,2);
	int newval = _clip_parl(mp,3);

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if(fieldno < 1 || fieldno > rowset->nfields){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOFIELD,er_nofield);
		return 1;
	}
	_clip_retl(mp,rowset->fields[fieldno-1].binary);
	if(_clip_parinfo(mp,3) == LOGICAL_t)
		rowset->fields[fieldno-1].binary = newval;
	return 0;
}

int clip_SQLFIELDLEN(ClipMachine* mp){
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	int fieldno = _clip_parni(mp,2);

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if(fieldno < 1 || fieldno > rowset->nfields){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOFIELD,er_nofield);
		return 1;
	}
	_clip_retni(mp,rowset->fields[fieldno-1].len);
	return 0;
}

int clip_SQLFIELDDEC(ClipMachine* mp){
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	int fieldno = _clip_parni(mp,2);

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if(fieldno < 1 || fieldno > rowset->nfields){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOFIELD,er_nofield);
		return 1;
	}
	_clip_retni(mp,rowset->fields[fieldno-1].dec);
	return 0;
}

int clip_SQLROWID(ClipMachine* mp){
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}

	if(!rowset->ids){
		_clip_retni(mp,rowset->id+1);
	} else if(rowset->nids == 1){
		_clip_retni(mp,rowset->ids[0]+1);
	} else {
		ClipVar* r = RETPTR(mp);
		ClipVar var;
		long vect[1];
		int i;

		vect[0] = rowset->nids;
		_clip_array(mp,r,1,vect);

		for(i=0;i<rowset->nids;i++){
			vect[0] = i;
			memset(&var,0,sizeof(ClipVar));

			var.t.type = NUMERIC_t;
			var.t.len = 10;
			var.t.dec = 2;
			var.n.d = rowset->ids[i]+1;
			_clip_aset(mp,r,&var,1,vect);
		}
	}
	return 0;
}

int clip_SQLNEWID(ClipMachine* mp){
	SQLCONN* conn = (SQLCONN*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	SQLSTMT* stmt = (SQLSTMT*)_clip_fetch_c_item(
		mp,_clip_parni(mp,2),_C_ITEM_TYPE_SQL);

	if(!conn){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOCONNECT,er_noconnect);
		return 1;
	}
	if(!stmt){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOSTATEMENT,er_nostatement);
		return 1;
	}
	conn->vtbl->newid(mp,stmt);
	return 0;
}

int clip_SQLSETLENDEC(ClipMachine* mp){
	double d = _clip_parnd(mp,1);
	int len = _clip_parni(mp,2);
	int dec = _clip_parni(mp,3);

	_clip_retndp(mp,d,len,dec);
	return 0;
}

int clip_STRFTIME(ClipMachine* mp){
	char* frm = _clip_parc(mp,1);
	int offset = _clip_parni(mp,2);
	time_t t = time(NULL)+offset;
	struct tm* tt = gmtime(&t);
	char s[81];

	strftime(s,sizeof(s),frm,tt);
	_clip_retc(mp,s);
	return 0;
}

static SQLLocale koi_locale =
{
/*unsigned char _koi_cmptbl[] = */
	{
		0xc4, 0xb3, 0xda, 0xbf, 0xc0, 0xd9, 0xc3, 0xb4,
		0xc2, 0xc1, 0xc5, 0xdf, 0xdc, 0xdb, 0xdd, 0xde,
		0xb0, 0xb1, 0xb2, 0xf4, 0xfe, 0xf9, 0xfb, 0xf7,
		0xf3, 0xf2, 0xff, 0xf5, 0xf8, 0xfd, 0xfa, 0xf6,
		0xcd, 0xba, 0xd5, 0xf1, 0xd6, 0xc9, 0xb8, 0xb7,
		0xbb, 0xd4, 0xd3, 0xc8, 0xbe, 0xbd, 0xbc, 0xc6,
		0xc7, 0xcc, 0xb5, 0xf0, 0xb6, 0xb9, 0xd1, 0xd2,
		0xcb, 0xcf, 0xd0, 0xca, 0xd8, 0xd7, 0xce, 0xfc,
		0xee, 0xa0, 0xa1, 0xe6, 0xa4, 0xa5, 0xe4, 0xa3,
		0xe5, 0xa8, 0xa9, 0xaa, 0xab, 0xac, 0xad, 0xae,
		0xaf, 0xef, 0xe0, 0xe1, 0xe2, 0xe3, 0xa6, 0xa2,
		0xec, 0xeb, 0xa7, 0xe8, 0xed, 0xe9, 0xe7, 0xea,
		0x9e, 0x80, 0x81, 0x96, 0x84, 0x85, 0x94, 0x83,
		0x95, 0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e,
		0x8f, 0x9f, 0x90, 0x91, 0x92, 0x93, 0x86, 0x82,
		0x9c, 0x9b, 0x87, 0x98, 0x9d, 0x99, 0x97, 0x9a
	},

/*unsigned char _koi_uptbl[] = */
	{
		0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
		0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f,
		0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97,
		0x98, 0x99, 0x9a, 0x9b, 0x9c, 0x9d, 0x9e, 0x9f,
		0xa0, 0xa1, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7,
		0xa8, 0xa9, 0xaa, 0xab, 0xac, 0xad, 0xae, 0xaf,
		0xb0, 0xb1, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6, 0xb7,
		0xb8, 0xb9, 0xba, 0xbb, 0xbc, 0xbd, 0xbe, 0xbf,
		0xe0, 0xe1, 0xe2, 0xe3, 0xe4, 0xe5, 0xe6, 0xe7,
		0xe8, 0xe9, 0xea, 0xeb, 0xec, 0xed, 0xee, 0xef,
		0xf0, 0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7,
		0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff,
		0xe0, 0xe1, 0xe2, 0xe3, 0xe4, 0xe5, 0xe6, 0xe7,
		0xe8, 0xe9, 0xea, 0xeb, 0xec, 0xed, 0xee, 0xef,
		0xf0, 0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7,
		0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff,
	},

/*unsigned char _koi_lowtbl[] = */
	{
		0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
		0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f,
		0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97,
		0x98, 0x99, 0x9a, 0x9b, 0x9c, 0x9d, 0x9e, 0x9f,
		0xa0, 0xa1, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7,
		0xa8, 0xa9, 0xaa, 0xab, 0xac, 0xad, 0xae, 0xaf,
		0xb0, 0xb1, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6, 0xb7,
		0xb8, 0xb9, 0xba, 0xbb, 0xbc, 0xbd, 0xbe, 0xbf,
		0xc0, 0xc1, 0xc2, 0xc3, 0xc4, 0xc5, 0xc6, 0xc7,
		0xc8, 0xc9, 0xca, 0xcb, 0xcc, 0xcd, 0xce, 0xcf,
		0xd0, 0xd1, 0xd2, 0xd3, 0xd4, 0xd5, 0xd6, 0xd7,
		0xd8, 0xd9, 0xda, 0xdb, 0xdc, 0xdd, 0xde, 0xdf,
		0xc0, 0xc1, 0xc2, 0xc3, 0xc4, 0xc5, 0xc6, 0xc7,
		0xc8, 0xc9, 0xca, 0xcb, 0xcc, 0xcd, 0xce, 0xcf,
		0xd0, 0xd1, 0xd2, 0xd3, 0xd4, 0xd5, 0xd6, 0xd7,
		0xd8, 0xd9, 0xda, 0xdb, 0xdc, 0xdd, 0xde, 0xdf,
	},
	{
		0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
		0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f,
		0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97,
		0x98, 0x99, 0x9a, 0x9b, 0x9c, 0x9d, 0x9e, 0x9f,
		0xa0, 0xa1, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7,
		0xa8, 0xa9, 0xaa, 0xab, 0xac, 0xad, 0xae, 0xaf,
		0xb0, 0xb1, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6, 0xb7,
		0xb8, 0xb9, 0xba, 0xbb, 0xbc, 0xbd, 0xbe, 0xbf,
		0xc0, 0xc1, 0xc2, 0xc3, 0xc4, 0xc5, 0xc6, 0xc7,
		0xc8, 0xc9, 0xca, 0xcb, 0xcc, 0xcd, 0xce, 0xcf,
		0xd0, 0xd1, 0xd2, 0xd3, 0xd4, 0xd5, 0xd6, 0xd7,
		0xd8, 0xd9, 0xda, 0xdb, 0xdc, 0xdd, 0xde, 0xdf,
		0xe0, 0xe1, 0xe2, 0xe3, 0xe4, 0xe5, 0xe6, 0xe7,
		0xe8, 0xe9, 0xea, 0xeb, 0xec, 0xed, 0xee, 0xef,
		0xf0, 0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7,
		0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff,
	},
	{
		0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
		0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f,
		0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97,
		0x98, 0x99, 0x9a, 0x9b, 0x9c, 0x9d, 0x9e, 0x9f,
		0xa0, 0xa1, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7,
		0xa8, 0xa9, 0xaa, 0xab, 0xac, 0xad, 0xae, 0xaf,
		0xb0, 0xb1, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6, 0xb7,
		0xb8, 0xb9, 0xba, 0xbb, 0xbc, 0xbd, 0xbe, 0xbf,
		0xc0, 0xc1, 0xc2, 0xc3, 0xc4, 0xc5, 0xc6, 0xc7,
		0xc8, 0xc9, 0xca, 0xcb, 0xcc, 0xcd, 0xce, 0xcf,
		0xd0, 0xd1, 0xd2, 0xd3, 0xd4, 0xd5, 0xd6, 0xd7,
		0xd8, 0xd9, 0xda, 0xdb, 0xdc, 0xdd, 0xde, 0xdf,
		0xe0, 0xe1, 0xe2, 0xe3, 0xe4, 0xe5, 0xe6, 0xe7,
		0xe8, 0xe9, 0xea, 0xeb, 0xec, 0xed, 0xee, 0xef,
		0xf0, 0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7,
		0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff,
	}
};

typedef struct
{
	char *name;
	SQLLocale *locale;
}
LocData;

static int
cmp_locale(void *p1, void *p2)
{
	return strcmp(((LocData *) p1)->name, ((LocData *) p2)->name);
}

SQLLocale *
SQL_get_locale(ClipMachine * mp, const char* sqlcs)
{
	char *SQLcs;
	SQLLocale *SQL_locale;
	static Coll locales =
	{0, 0, 0, 0, 0, 0};
	LocData ld, *lp;
	int ind;
	char *hostcs;
	cons_CharsetEntry *cs1 = 0, *cs2 = 0;
	int len1 = 0, len2 = 0;
	unsigned char *buf;

	if(sqlcs && sqlcs[0]){
		SQLcs = strdup(sqlcs);
	} else {
		SQLcs = (char *) _clip_fetch_item(mp, _clip_hashstr("SQL_CHARSET"));
		if (!SQLcs)
		{
			_clip_logg(2, "no item SQL_CHARSET, revert to KOI charset");
			return &koi_locale;
		}
	}

	if (!locales.compare)
		init_Coll(&locales, 0, cmp_locale);

	ld.name = SQLcs;
	if (search_Coll(&locales, &ld, &ind))
	{
		lp = (LocData *) locales.items[ind];
		return lp->locale;
	}

	hostcs = _clip_getenv("CLIP_HOSTCS");
	if (!hostcs)
	{
		char *s;

		s = _clip_getenv("LC_ALL");
		if (s && *s)
		{
			hostcs = strrchr(s, '.');
			if (hostcs)
				hostcs++;
			else if (strcmp(s, "C") && strcmp(s, "POSIX"))
				hostcs = s;
		}
	}
	if (!hostcs)
		hostcs = _clip_getenv("CLIP_LANG");
				if ( hostcs == NULL )
			hostcs = _clip_getenv("LANG");

	if (!hostcs)
	{
		_clip_logg(0, "SQL: cannot determine host charset, revert to koi_locale");
		return &koi_locale;
	}

	_clip_logg(2, "load host charset '%s'", hostcs);
	if (load_charset_name(hostcs, &cs1, &len1))
	{
		_clip_logg(0, "SQL: cannot load charset '%s': %s, revert to koi_locale",
			   hostcs, strerror(errno));
		return &koi_locale;
	}

	_clip_logg(2, "load SQL charset '%s'", SQLcs);
	if (load_charset_name(SQLcs, &cs2, &len2))
	{
		_clip_logg(0, "SQL: cannot load charset '%s': %s, revert to koi_locale",
			   SQLcs, strerror(errno));
		return &koi_locale;
	}

	buf = (unsigned char *) calloc(256, 3);

	make_translation(cs1, len1, cs2, len2, buf);
	make_translation(cs2, len2, cs1, len1, buf + 256);

	free(cs1);
	free(cs2);

	SQL_locale = (SQLLocale *) calloc(1, sizeof(SQLLocale));
	lp = (LocData *) calloc(1, sizeof(LocData));
	lp->locale = SQL_locale;
	lp->name = strdup(SQLcs);

	memcpy(SQL_locale->read, buf + 256 + 128, 128);
	memcpy(SQL_locale->write, buf + 128, 128);

	memcpy(SQL_locale->cmp, _clip_cmptbl + 128, 128);
	memcpy(SQL_locale->upper, _clip_uptbl + 128, 128);
	memcpy(SQL_locale->lower, _clip_lowtbl + 128, 128);

	free(buf);
	insert_Coll(&locales, lp);
	return SQL_locale;
}

int clip_SQLLOCREAD(ClipMachine* mp){
	int conn_item = _clip_parni(mp,1);
	SQLCONN* conn = (SQLCONN*)_clip_fetch_c_item(
		mp,conn_item,_C_ITEM_TYPE_SQL);
	ClipVar* str = _clip_vptr(_clip_par(mp,2));
	unsigned char* c;
	unsigned char* e;

	if(!conn){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOCONNECT,er_noconnect);
		return 1;
	}

	c = (unsigned char *)str->s.str.buf;
	if(c && c[0]){
		e = c+str->s.str.len;
		for(;c<e;c++)
			if(*c&0x80)
				*c = conn->loc->read[*c&0x7f];
	}
	return 0;
}

int clip_SQLLOCWRITE(ClipMachine* mp){
	int conn_item = _clip_parni(mp,1);
	SQLCONN* conn = (SQLCONN*)_clip_fetch_c_item(
		mp,conn_item,_C_ITEM_TYPE_SQL);
	ClipVar* str = _clip_vptr(_clip_par(mp,2));
	unsigned char* c;
	unsigned char* e;

	if(!conn){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOCONNECT,er_noconnect);
		return 1;
	}

	c = (unsigned char *)str->s.str.buf;
	if(c && c[0]){
		e = c+str->s.str.len;
		for(;c<e;c++)
			if(*c&0x80)
				*c = conn->loc->write[*c&0x7f];
	}
	return 0;
}

int clip_SQLREFRESH(ClipMachine* mp){
	int rowset_item = _clip_parni(mp,1);
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,rowset_item,_C_ITEM_TYPE_SQL);
	SQLSTMT* stmt = (SQLSTMT*)_clip_fetch_c_item(
		mp,_clip_parni(mp,2),_C_ITEM_TYPE_SQL);
	ClipVar* ap = _clip_par(mp,3);
	int k;

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if(!stmt){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOSTATEMENT,er_nostatement);
		return 1;
	}
	if(rowset->conn->vtbl->fetch(mp,rowset,0,NULL,0,NULL)) return 1;
	for(k=0;k<rowset->ntags;k++){
		if(sql_orderdel(mp,rowset,rowset->taghashes[k])) return 1;
	}
	if(stmt->conn->vtbl->refresh(mp,rowset,stmt,ap) == -1)
		return 1;
	for(k=0;k<rowset->ntags;k++){
		if(sql_orderadd(mp,rowset,rowset->taghashes[k])) return 1;
	}

	return 0;
}

int sql_createorder(ClipMachine* mp,ClipVar* rmap,SQLROWSET* rowset,char* tagname,ClipVar* expr,int len){
	int t4 = expr->t.type;
	char m[1024];
	SQLORDER* order = calloc(1,sizeof(SQLORDER));

	if(!HashTable_insert(rowset->orders,order,_clip_casehashstr(tagname))){
		free(order);
		_clip_trap_err(mp,0,0,0,subsys,ER_ORDEREXIST,er_orderexist);
		return 1;
	}

	order->len = len+sizeof(int);
	order->block = calloc(1,sizeof(ClipVar));
	switch(t4){
		case CHARACTER_t:
			snprintf(m,sizeof(m),"{|rs| rs:getValue(\"%s\")}",expr->s.str.buf);
			break;
		case NUMERIC_t:
			snprintf(m,sizeof(m),"{|rs| rs:getValue(%d)}",(int)expr->n.d);
			break;
		case CCODE_t:
		case PCODE_t:
			_clip_dup(mp,order->block,expr);
			break;
	}
	if(t4 == CHARACTER_t || t4 == NUMERIC_t){
		if(_clip_eval_macro(mp,m,strlen(m),order->block)){
			free(order->block); free(order);
			return 1;
		}
	}
	order->loc = rowset->conn->loc;
	order->rmap = calloc(1,sizeof(ClipVar));
	memcpy(order->rmap,rmap,sizeof(ClipVar));
	order->name = strdup(tagname);
	return 0;
}

static int sql_cmp(SQLLocale* loc,unsigned char* s1,unsigned char* s2,int len){
	int r = 0;
	unsigned char *ss1,*ss2;
	unsigned char* e = s1+len;
	int ch1,ch2;

	for(ss1=s1,ss2=s2;ss1<e && !r;ss1++,ss2++){
		ch1 = _clip_cmptbl[*ss1];
		ch2 = _clip_cmptbl[*ss2];
		r = ch1-ch2;
	}
	return r;
}

static int _sql_char_compare(void* op,void* key1,void* key2,int* uniq){
	SQLORDER* order = (SQLORDER*)op;
	int k1 = *(int*)key1;
	int k2 = *(int*)key2;
	int l,r;

	l = order->len - sizeof(int);
	if(k1 <= 0)
		l = -k1;
	r = sql_cmp(order->loc,(unsigned char*)key1+sizeof(int),(unsigned char*)key2+sizeof(int),l);
	if(!r && k1 >= 0)
		r = k1 - k2;
	return r;
}

static int _sql_num_compare(void* op,void* key1,void* key2,int* uniq){
	int k1 = *(int*)key1;
	int k2 = *(int*)key2;
	double d;
	int r = 0;

	d = *(double*)((char*)key1+sizeof(int)) - *(double*)((char*)key2+sizeof(int));
	if(d<0)	r = -1;
	else if(d>0) r = 1;
	if(!r && k1 > 0)
		r = k1 - k2;
	return r;
}

static int _sql_date_compare(void* op,void* key1,void* key2,int* uniq){
	int k1 = *(int*)key1;
	int k2 = *(int*)key2;
	long r;

	r = *(long*)((char*)key1+sizeof(int)) - *(long*)((char*)key2+sizeof(int));
	if(!r && k1 > 0)
		r = k1 - k2;
	return (int)r;
}

static int _sql_dt_compare(void* op,void* key1,void* key2,int* uniq){
	int k1 = *(int*)key1;
	int k2 = *(int*)key2;
	long r;

	r = *(long*)((char*)key1+sizeof(int)) - *(long*)((char*)key2+sizeof(int));
	if(!r)
		r = *(long*)((char*)key1+sizeof(int)+sizeof(long))
			- *(long*)((char*)key2+sizeof(int)+sizeof(long));
	if(!r && k1 > 0)
		r = k1 - k2;
	return (int)r;
}

int sql_orderadd(ClipMachine* mp,SQLROWSET* rowset,long taghash){
	SQLORDER* order = (SQLORDER*)HashTable_fetch(rowset->orders,taghash);
	ClipVar var;
	void* k;

	if(!order){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOORDER,er_noorder);
		return 1;
	}
	if(_clip_eval(mp,order->block,1,order->rmap,&var))
		return 1;
	if(!order->bt){
		int (*compare)(void* op,void* key1,void* key2,int* uniq);

		switch(var.t.type){
			case CHARACTER_t:
				if(var.t.type == CHARACTER_t && !order->len){
					_clip_destroy(mp,&var);
					_clip_trap_err(mp,0,0,0,subsys,ER_BADORDERLEN,er_badorderlen);
					return 1;
				}
				compare = _sql_char_compare;
				break;
			case NUMERIC_t:
				order->len = sizeof(double)+sizeof(int);
				compare = _sql_num_compare;
				break;
			case DATE_t:
				order->len = sizeof(long)+sizeof(int);
				compare = _sql_date_compare;
				break;
			case DATETIME_t:
				order->len = sizeof(long)*2+sizeof(int);
				compare = _sql_dt_compare;
				break;
			default:
				_clip_destroy(mp,&var);
				_clip_trap_err(mp,0,0,0,subsys,ER_BADORDERTYPE,er_badordertype);
				return 1;
		}
		order->bt = bt_create(0,100,order->len,compare);
	}
	k = calloc(1,order->len);
	*(int*)k = rowset->recno;
	switch(var.t.type){
		case CHARACTER_t:
			memcpy((char*)k+sizeof(int),var.s.str.buf,min(var.s.str.len,order->len));
			break;
		case NUMERIC_t:
			*(double*)((char*)k+sizeof(int)) = var.n.d;
			break;
		case DATE_t:
			*(long*)((char*)k+sizeof(int)) = var.d.julian;
			break;
		case DATETIME_t:
			*(long*)((char*)k+sizeof(int)) = var.dt.julian;
			*(long*)((char*)k+sizeof(int)+sizeof(long)) = var.dt.time;
			break;
		default:
			break;
	}
	if(bt_add(order->bt,order,k)){
		free(k);
		_clip_destroy(mp,&var);
		return 1;
	}
	free(k);
	_clip_destroy(mp,&var);
	return 0;
}

int clip_SQLCREATEORDER(ClipMachine* mp){
	ClipVar* rmap = _clip_spar(mp,1);
	int rowset_item = _clip_parni(mp,2);
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,rowset_item,_C_ITEM_TYPE_SQL);
	char* tagname = _clip_parc(mp,3);
	ClipVar* expr = _clip_par(mp,4);
	int t4 = _clip_parinfo(mp,4);
	int len = _clip_parni(mp,5);
	long taghash = _clip_casehashstr(tagname);
	int oldrecno;

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if(t4 != CHARACTER_t && t4 != NUMERIC_t && t4 != CCODE_t && t4 != PCODE_t){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}

	if(rowset->conn->vtbl->fetch(mp,rowset,0,NULL,0,NULL)) return 1;

	if(sql_createorder(mp,rmap,rowset,tagname,expr,len)) return 1;
	rowset->ntags++;
	rowset->taghashes = realloc(rowset->taghashes,rowset->ntags*sizeof(long));
	rowset->taghashes[rowset->ntags-1] = _clip_casehashstr(tagname);

	oldrecno = rowset->recno;
	for(rowset->recno = 1;rowset->recno <= rowset->lastrec;rowset->recno++){
		if(sql_orderadd(mp,rowset,taghash)) return 1;
	}
	rowset->recno = oldrecno;
	return 0;
}

int sql_seek(ClipMachine* mp,SQLROWSET* rowset,ClipVar* val,int soft,int* found){
	void* k;

	*found = 0;
	if(!rowset->curord)
		return 0;

	if(!rowset->curord->bt)
		return 0;

	k = calloc(1,rowset->curord->len);
	switch(val->t.type){
		case CHARACTER_t:
			if(val->s.str.len > rowset->curord->len){
				free(k);
				return 0;
			}
			*(int*)k = -val->s.str.len;
			memcpy((char*)k+sizeof(int),val->s.str.buf,val->s.str.len);
			break;
		case NUMERIC_t:
			*(double*)((char*)k+sizeof(int)) = val->n.d;
			break;
		case DATE_t:
			*(long*)((char*)k+sizeof(int)) = val->d.julian;
			break;
		case DATETIME_t:
			*(long*)((char*)k+sizeof(int)) = val->dt.julian;
			*(long*)((char*)k+sizeof(int)+sizeof(long)) = val->dt.time;
			break;
		default:
			break;
	}
	*found = bt_seek(rowset->curord->bt,rowset->curord,k);
	free(k);
	if(*found || soft)
		rowset->recno = *(int*)bt_key(rowset->curord->bt);
	return 0;
}

int clip_SQLSEEK(ClipMachine* mp){
	int rowset_item = _clip_parni(mp,1);
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,rowset_item,_C_ITEM_TYPE_SQL);
	ClipVar* val = _clip_par(mp,2);
	int soft = _clip_parl(mp,3);
	int found;

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}

	if(sql_seek(mp,rowset,val,soft,&found)) return 1;
	_clip_retl(mp,found);
	return 0;
}

int clip_SQLSETORDER(ClipMachine* mp){
	int rowset_item = _clip_parni(mp,1);
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,rowset_item,_C_ITEM_TYPE_SQL);
	const char* tagname = _clip_parc(mp,2);

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if(rowset->curord)
		_clip_retc(mp,rowset->curord->name);
	if(_clip_parinfo(mp,2) == CHARACTER_t){
		if(!tagname || !tagname[0]){
			rowset->curord = NULL;
		} else {
			rowset->curord = HashTable_fetch(rowset->orders,_clip_casehashstr(tagname));
		}
	}
	return 0;
}

int clip_SQLGENID(ClipMachine* mp){
	int rowset_item = _clip_parni(mp,1);
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,rowset_item,_C_ITEM_TYPE_SQL);

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}

	if(rowset->conn->vtbl->genid)
		return rowset->conn->vtbl->genid(mp,rowset);
	return 0;
}

int clip_SQLSTART(ClipMachine* mp){
	int conn_item = _clip_parni(mp,1);
	SQLCONN* conn = (SQLCONN*)_clip_fetch_c_item(
		mp,conn_item,_C_ITEM_TYPE_SQL);
	const char* p1 = _clip_parc(mp,2);
	const char* p2 = _clip_parc(mp,3);

	if(!conn){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOCONNECT,er_noconnect);
		return 1;
	}
	if(conn->vtbl->start)
		return conn->vtbl->start(mp,conn,p1,p2);
	return 0;
}

int clip_SQLCOMMIT(ClipMachine* mp){
	int conn_item = _clip_parni(mp,1);
	SQLCONN* conn = (SQLCONN*)_clip_fetch_c_item(
		mp,conn_item,_C_ITEM_TYPE_SQL);

	if(!conn){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOCONNECT,er_noconnect);
		return 1;
	}
	if(conn->vtbl->commit)
		return conn->vtbl->commit(mp,conn);
	return 0;
}
int clip_SQLROLLBACK(ClipMachine* mp){
	int conn_item = _clip_parni(mp,1);
	SQLCONN* conn = (SQLCONN*)_clip_fetch_c_item(
		mp,conn_item,_C_ITEM_TYPE_SQL);

	if(!conn){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOCONNECT,er_noconnect);
		return 1;
	}
	if(conn->vtbl->rollback)
		return conn->vtbl->rollback(mp,conn);
	return 0;
}

int clip_SQLFETCH(ClipMachine* mp){
	int rowset_item = _clip_parni(mp,1);
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,rowset_item,_C_ITEM_TYPE_SQL);
	int recs = _clip_parni(mp,2);
	ClipVar* eval = _clip_vptr(_clip_par(mp,3));
	int every = _clip_parni(mp,4);
	ClipVar* ors = _clip_spar(mp,5);

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if(!every)
		every = 1;
	if(rowset->conn->vtbl->fetch(mp,rowset,recs,eval,every,ors)) return 1;

	_clip_retni(mp,rowset->loaded);
	return 0;
}

int clip_SQLFETCHED(ClipMachine* mp){
	int rowset_item = _clip_parni(mp,1);
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,rowset_item,_C_ITEM_TYPE_SQL);

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}

	_clip_retni(mp,rowset->loaded);
	return 0;
}

int clip_SQLKEYNO(ClipMachine* mp){
	SQLROWSET* rowset = (SQLROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	int keyno = 0;

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if(rowset->curord){
		if(!rowset->curord->bt)
			keyno = rowset->recno;
		else if(!bt_first(rowset->curord->bt)){
			keyno++;
			while(rowset->recno != *(int*)bt_key(rowset->curord->bt)){
				bt_next(rowset->curord->bt);
				keyno++;
			}
		}
	} else {
		keyno = rowset->recno;
	}
	_clip_retni(mp,keyno);
	return 0;
}
