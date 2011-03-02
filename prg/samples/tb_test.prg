// Limits for a2edit
#include "error.ch"
#define MAX_COLUMNS 10
#define MAX_RECORDS 150


parameters nfunc, dbf , index

local i,j, col_names, atest, fields, m, m2, h
local error, bSaveHandler

if nfunc==NIL
   TEXT

   use this program with parameters:
   1 - browse()
   2 - dbedit()
   3 - achoice()
   4 - a2edit()

   and file name for open database

   ENDTEXT
   return
endif
if empty(dbf)
   ? "DBF file not defined"
endif

nfunc= val(nfunc)

set ("DBF_CHARSET","ALT" )
set color to "N/W, N/BG, B/W, B/BG, B/W, B/BG, R/W, B/R "

if nfunc < 3
    bSaveHandler := ERRORBLOCK( {|x| BREAK(x)} )
	   ? dbf
	   ?
    BEGIN SEQUENCE
	   USE (dbf) //INDEX (index)

    RECOVER USING error
	IF error:genCode == EG_OPEN
	    ?? "Error opening file(s)"

	ELSE
	    ?? "Usage: Tbdemo <dbf> [<index>]"
	ENDIF
	QUIT
    END

    //ERRORBLOCK(bSaveHandler)
endif

do case
   case nfunc==1
	browse(2,3,15,45)
   case nfunc==2
	fields:={"FIRM_NO","FIRM_KEY","TELEFON"}
	h:={"a","Name","Phone"}
	fields:=NIL
	h:=NIL
	dbedit(2,3,15,78,fields,,,h)
	//dbedit(2,3,15,45)
   case nfunc==3
	//m:={"a1111","b2222","c3333","d4444","5555","6666","7777","8888","9999","0000","0101","0202"}
	m:={"a1111","b2222","c3333","d4444"}
	m2:={.t.,.f.,.f.,.t.}
	achoice(6,1,12,12,m,m2)
   case nfunc==4
	atest:={}
	col_names:={}
	for i=1 to MAX_COLUMNS
	    aadd(atest,{})
	    for j=1 to MAX_RECORDS
		aadd(atest[i],strzero(i,4,0)+"_"+strzero(j,6,0))
	    next
	    aadd(col_names,"cname_"+strzero(i,4,0))
	next
	a2edit(2,3,15,78,atest,/*user_func*/,/*pictures*/,col_names)
endcase



