/*
$Log: dtest.c,v $
Revision 1.2  1999/10/26 19:19:11  axl
start cvs logging (./dbf)

*/

#include <stdio.h>
#include <unistd.h>
#include <string.h>

#include "dbf.h"

#define NREC 1000

int
main(int argc, char **argv)
{
	int i, r = 0;
	struct DbfFile *fp;
	char errbuf[256];
	DbfField fields[] =
	{
		{"character", 'C', 20, 0},
		{"numeric", 'N', 10, 2},
		{"logical", 'L', 1, 0},
		{"date", 'D', 8, 0},
		{"memo", 'M', 10, 0},
	};
	int nfield = sizeof(fields) / sizeof(DbfField);
	char name[] = "test.dbf";

	if (access(name, R_OK))
		fp = create_DbfFile(name, DBF_NTX | DBF_DBT, 0, nfield, fields, dbf_calc, 0, errbuf, sizeof(errbuf));
	else
		fp = open_DbfFile(name, DBF_NTX | DBF_DBT, 0, 1, dbf_calc, 0, errbuf, sizeof(errbuf));

	if (!fp)
	{
		printf("cannot create dbf file '%s': %s\n", name, errbuf);
		return 1;
	}

	r = openIndex_DbfFile(fp, "char", 0, "char");

	if (!r)
		printf("index 'char' opened\n");

	if (r)
	{
		r = createIndex_DbfFile(fp, "char", 0, "char", "numeric", 0);
		/*r = createIndex_DbfFile(fp, "char", 0, "char", "str(numeric)", 0); */
		/*r = createIndex_DbfFile(fp, "char", 0, "char",
		   "str(numeric)+str(numeric)+"
		   "iif(!empty(character) .or. '998'$character .or. '998'$character,lower(character),replicate('D',len(character)))"
		   "+dtos(date)", 0); */
#if 0
		"str(firm_no)+str(dog_no)+"
			"iif(!empty(tovar) .or. '998'$debbcel1 .or. '998'$kredbcel1,lower(tovar),replicate('þ',len(tovar)))"
			"+dtos(odate)"
#endif
			if (r)
			goto err;
		printf("index 'char' created\n");
	}

/*
   r = zap_DbfFile(fp);
   if (r)
   goto err;
   printf("file '%s' zapped\n", name_DbfFile(fp) );
 */

	for (i = 0; i < NREC; ++i)
	{
		char buf[32];
		DbfData item;

		if (append_DbfFile(fp))
			goto err;

		item.type = 'C';
		snprintf(buf, sizeof(buf), "i=%04d", i);
		item.flags = DBFDATA_NONFREE;
		item.u.c.str = buf;
		item.u.c.len = strlen(buf);
		if (setVal_DbfFile(fp, 0, &item))
			goto err;

		item.type = 'N';
		item.u.n = i;
		if (setVal_DbfFile(fp, 1, &item))
			goto err;

		item.type = 'L';
		item.u.l = i % 2;
		if (setVal_DbfFile(fp, 2, &item))
			goto err;

		item.type = 'D';
		item.u.d = i + 6000 * 365;
		if (setVal_DbfFile(fp, 3, &item))
			goto err;

		item.type = 'C';
		snprintf(buf, sizeof(buf), "memo for i=%04d", i);
		item.flags = DBFDATA_NONFREE;
		item.u.c.str = buf;
		item.u.c.len = strlen(buf);
		if (setVal_DbfFile(fp, 4, &item))
			goto err;

	}

	printf("appended %d records\n", i);

	{
		char buf[128];
		DbfData item;

		r = goTop_DbfFile(fp);
		if (r)
			goto err;
		item.type = 'C';
		snprintf(buf, sizeof(buf), "changed memo for i=%04d", i);
		item.flags = DBFDATA_NONFREE;
		item.u.c.str = buf;
		item.u.c.len = strlen(buf);

		if (setVal_DbfFile(fp, 4, &item))
			goto err;
	}

	/*setIndex_DbfFile(fp, 0); */
	/*r = setFilter_DbfFile(fp, "numeric>5");
	   if (r)
	   goto err; */
	/*
	   r = setFilter_DbfFile(fp, "char>='i=0005'");
	   if (r)
	   goto err;
	 */
	{
		DbfData data;
		int found = 0;
		long pos = -3;

		memset(&data, 0, sizeof(DbfData));
		/*
		   data.type = 'C';
		   data.u.c.str = "   2027.00";
		   data.u.c.len = 6;
		   r = seek_DbfFile(fp, &data, 0, &found);
		   recNo_DbfFile(fp, &pos);
		   printf("seek '%s': ret=%d found=%d pos=%ld\n", data.u.c.str,r,found,pos);
		 */
		data.type = 'N';
		data.u.n = 2027;
		data.len = data.dec = 0;
		r = seek_DbfFile(fp, &data, 0, &found);
		recNo_DbfFile(fp, &pos);
		printf("seek '%f': ret=%d found=%d pos=%ld\n", data.u.n, r, found, pos);

		data.type = 'N';
		data.u.n = 3;
		data.len = data.dec = 0;
		r = seek_DbfFile(fp, &data, 0, &found);
		recNo_DbfFile(fp, &pos);
		printf("seek '%f': ret=%d found=%d pos=%ld\n", data.u.n, r, found, pos);

		data.type = 'N';
		data.u.n = 5;
		data.len = data.dec = 0;
		r = seek_DbfFile(fp, &data, 0, &found);
		recNo_DbfFile(fp, &pos);
		printf("seek '%f': ret=%d found=%d pos=%ld\n", data.u.n, r, found, pos);

		r = skip_DbfFile(fp, 1);
		recNo_DbfFile(fp, &pos);
		printf("skip 1: ret=%d fpos=%ld\n", r, pos);
	}

	/*{
	   DbfData low, hi;

	   memset(&low, 0, sizeof(DbfData));
	   low.type = 'C';
	   low.u.c.str = "i=2";
	   low.u.c.len = 3;

	   memset(&hi, 0, sizeof(DbfData));
	   hi.type = 'C';
	   hi.u.c.str = "i=5";
	   hi.u.c.len = 3;

	   r = setRange_DbfFile(fp, "char", &low, &hi);
	   if (r)
	   goto err;
	   } */
/*
   printf("\n");
   for(i=1, r=goTop_DbfFile(fp); !r; r=skip_DbfFile(fp,1), ++i)
   {
   int eof;
   long recno;
   DbfData item;

   if ((r = eof_DbfFile(fp, &eof)))
   goto err;
   if(eof)
   break;
   if ((r = recNo_DbfFile(fp, &recno)))
   goto err;
   if (getVal_DbfFile(fp, 1, &item))
   goto err;
   printf("i:%4d pos: %ld 1:%c:%*.*f\n", i, recno, item.type, item.len, item.dec, item.u.n);
   }

   if (r)
   goto err;
 */
	/*
	   printf("\n");
	   for(i=1, r=goBottom_DbfFile(fp); !r; r=skip_DbfFile(fp,-1), ++i)
	   {
	   int eof;
	   long recno;
	   if ((r = bof_DbfFile(fp, &eof)))
	   goto err;
	   if(eof)
	   break;
	   if ((r = recNo_DbfFile(fp, &recno)))
	   goto err;
	   printf("i:%4d pos: %ld\n", i, recno);
	   }

	   if (r)
	   goto err;
	 */

	goto end;
      err:{
		long pos;

		getError_DbfFile(fp, errbuf, sizeof(errbuf));
		recNo_DbfFile(fp, &pos);
		printf("pos: %ld; error : %s\n", pos, errbuf);
		goto end;
	}

      end:
	close_DbfFile(fp);
	return r;
}
