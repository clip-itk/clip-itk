/* clip object data base (CODB) over DBF descriptions */

#ifndef _CODB_OVERDBF_DEFINED
#define _CODB_OVERDBF_DEFINED

#include "codbcfg.ch"


#define CODB_COUNTER_STRUCTURE { ;
		{"ID"           ,"C",CODB_ID_LEN  ,0},;
		{"NAME"         ,"C",25 ,0},;
		{"VALUE"        ,"N",8  ,0};
		}

/*
META data may be: group,user,attr,class,extent,deposit
*/

#define CODB_DICT_STRUCTURE { ;
		{"ID"      ,"C",CODB_ID_LEN  ,0},;
		{"META"    ,"C",10 ,0},;
		{"HASHNAME","N",12 ,0},;
		{"VERSION" ,"N",3  ,0},;
		{"CRC32"   ,"C",8  ,0},;
		{"BODY"    ,"M",10 ,0};
		}

#define CODB_DICTINDEX_STRUCTURE { ;
		{"ID"       ,"C",CODB_ID_LEN  ,0},;
		{"META"     ,"C",10           ,0},;
		{"NAME"     ,"C",50           ,0},;
		{"CLASS_ID" ,"C",CODB_ID_LEN  ,0},;
		{"SUPER_ID" ,"C",CODB_ID_LEN  ,0},;
		{"EXTENT_ID","C",CODB_ID_LEN  ,0},;
		{"GROUP_ID" ,"C",CODB_ID_LEN  ,0},;
		{"USER_ID"  ,"C",CODB_ID_LEN  ,0},;
		{"VERSION"  ,"N",3 	      ,0};
		}

#define CODB_IDXTABLE_STRUCTURE { ;
		{"OBJECT_ID"    ,"C",CODB_ID_LEN ,0}, ;
		{"CLASS_ID"     ,"C",CODB_ID_LEN ,0}, ;
		{"EXTENT_ID"    ,"C",CODB_ID_LEN ,0}, ;
		{"VERSION"      ,"N",3 		 ,0}, ;
		{"CRC32"        ,"C",8 		 ,0} ;
		}
		/* and CODB_IDX_PER_CLASS elements:
		{"DATAx"        ,"X",CODB_IDX_DATALENGTH ,0}
		*/

#define CODB_EXTENT_STRUCTURE { ;
		{"OBJECT_ID"    ,"C",CODB_ID_LEN ,0}, ;
		{"CLASS_ID"     ,"C",CODB_ID_LEN ,0}, ;
		{"VERSION"      ,"N",3 		 ,0}, ;
		{"BODY"    	,"M",10 ,0} ;
		}

#define CODB_GROUP_BODY { ;
		{"ID"      ,"C",CODB_ID_LEN  ,0,CODB_LENTYPE_RTRIM,""},;
		{"NAME"    ,"C",10           ,0,CODB_LENTYPE_RTRIM,""};
		}

#define CODB_USER_BODY { ;
		{"ID"      ,"C",CODB_ID_LEN  ,0,CODB_LENTYPE_RTRIM,""},;
		{"NAME"    ,"C",10           ,0,CODB_LENTYPE_RTRIM,""},;
		{"GROUP_ID","C",CODB_ID_LEN  ,0,CODB_LENTYPE_RTRIM,""},;
		{"ACCESS"   ,"C",10          ,0,CODB_LENTYPE_PADR,""} ;
		}

		/* attribute decription */
		// mask:    for function transform()
		// lentype: 0-as is, 1-rtrim(), 2-padr(,len), ...
		// index:   0-none, 1-optimization, 2-must exist, ....
		// defvalue: default value as expression for macro operation
		// count - references from classes


		/* extent description */
#define CODB_EXTENT_BODY { ;
		{"ID"        ,"C",CODB_ID_LEN  ,0,CODB_LENTYPE_RTRIM,""},;
		{"NAME"      ,"C",50           ,0,CODB_LENTYPE_RTRIM,""},;
		{"HELP"      ,"M",10           ,0,CODB_LENTYPE_RTRIM,""};
		}

#define CODB_DEPOSIT_BODY { ;
		{"ID"       ,"C",CODB_ID_LEN   ,0,CODB_LENTYPE_RTRIM,""}, ;
		{"NAME"     ,"C",50            ,0,CODB_LENTYPE_RTRIM,""}, ;
		{"NUMBER"   ,"C",DEPOSIT_ID_LEN,0,CODB_LENTYPE_NONE,""}, ;
		{"MEMOSIZE" ,"N",4             ,0,CODB_LENTYPE_RTRIM,CODB_MEMOSIZE_DEFAULT} ;
		}

#define CODB_ATTR_BODY { ;
		{"ID"        ,"C",CODB_ID_LEN  ,0,CODB_LENTYPE_RTRIM,""},;
		{"NAME"      ,"C",50           ,0,CODB_LENTYPE_RTRIM,""},;
		{"TYPE"      ,"C",1            ,0,CODB_LENTYPE_RTRIM,"C"},;
		{"LEN"       ,"N",5            ,0,CODB_LENTYPE_RTRIM,1},;
		{"DEC"       ,"N",2            ,0,CODB_LENTYPE_RTRIM,0},;
		{"MASK"      ,"C",25           ,0,CODB_LENTYPE_RTRIM,""},;
		{"LENTYPE"   ,"N",1            ,0,CODB_LENTYPE_RTRIM,1},;
		{"REF_TO"    ,"C",CODB_ID_LEN  ,0,CODB_LENTYPE_RTRIM,""},;
		{"DEFVALUE"  ,"C",30           ,0,CODB_LENTYPE_RTRIM,""},;
		{"COUNTER"   ,"C",25           ,0,CODB_LENTYPE_RTRIM,""},;
		{"NOT_NULL"  ,"L",1            ,0,CODB_LENTYPE_RTRIM,.f.},;
		{"NOT_EMPTY" ,"L",1            ,0,CODB_LENTYPE_RTRIM,.f.},;
		{"SOURCE"    ,"M",10           ,0,CODB_LENTYPE_RTRIM,""},;
		{"CODE"      ,"M",10           ,0,CODB_LENTYPE_RTRIM,""},;
		{"HELP"      ,"M",10           ,0,CODB_LENTYPE_RTRIM,""},;
		{"COUNT"     ,"N",6            ,0,CODB_LENTYPE_RTRIM,""};
		}

//        	{"INDEX"     ,"N",1            ,0,CODB_LENTYPE_RTRIM,0},;

		/* classes description */
#define CODB_CLASS_BODY { ;
		{"ID"        ,"C",CODB_ID_LEN  ,0,CODB_LENTYPE_RTRIM,""},;
		{"NAME"      ,"C",50           ,0,CODB_LENTYPE_RTRIM,""},;
		{"SUPER_ID"  ,"C",CODB_ID_LEN  ,0,CODB_LENTYPE_RTRIM,""},;
		{"EXTENT_ID" ,"C",CODB_ID_LEN  ,0,CODB_LENTYPE_RTRIM,""},;
		{"EXPR_ESSENCE","C",200        ,0,CODB_LENTYPE_RTRIM,""},;
		{"UNIQUE_KEY","C",20           ,0,CODB_LENTYPE_RTRIM,""},;
		{"UNSTABLE"  ,"L",1            ,0,CODB_LENTYPE_NONE,.f.},;
		{"LOG_NEED"  ,"L",1            ,0,CODB_LENTYPE_NONE,.f.},;
		{"HAVE_COUNTERS","L",1         ,0,CODB_LENTYPE_NONE,.f.},;
		{"ATTR_LIST" ,"A",0            ,0,0		    ,{}},;
		{"IDX_LIST"  ,"A",0            ,0,0		    ,{}};
		}

#define CODB_TVIEW_BODY { ;
		{"ID"        ,"C",CODB_ID_LEN  ,0,CODB_LENTYPE_RTRIM,""},;
		{"NAME"      ,"C",50           ,0,CODB_LENTYPE_RTRIM,""},;
		{"CLASS_ID"  ,"C",CODB_ID_LEN  ,0,CODB_LENTYPE_RTRIM,""},;
		{"EXTENT_ID" ,"C",CODB_ID_LEN  ,0,CODB_LENTYPE_RTRIM,""},;
		{"GROUP_ID"  ,"C",CODB_ID_LEN  ,0,CODB_LENTYPE_RTRIM,""},;
		{"USER_ID"   ,"C",CODB_ID_LEN  ,0,CODB_LENTYPE_RTRIM,""},;
		{"HEADER"    ,"C",80           ,0,CODB_LENTYPE_RTRIM,""},;
		{"FOOTER"    ,"C",80           ,0,CODB_LENTYPE_RTRIM,""},;
		{"COL_LIST"  ,"A",0            ,0,0		    ,{}};
		}

#define CODB_TCOLUMN_BODY { ;
		{"ID"        ,"C",CODB_ID_LEN  ,0,CODB_LENTYPE_RTRIM  ,""},;
		{"NAME"      ,"C",50           ,0,CODB_LENTYPE_RTRIM  ,""},;
		{"HEADER"    ,"C",80           ,0,CODB_LENTYPE_RTRIM  ,""},;
		{"FOOTER"    ,"C",80           ,0,CODB_LENTYPE_RTRIM  ,""},;
		{"WIDTH"     ,"N",2            ,0,0                   ,0 },;
		{"EXPR"      ,"C",250          ,0,CODB_LENTYPE_RTRIM  ,""},;
		{"DEPEND_OF" ,"C",20           ,0,CODB_LENTYPE_ALLTRIM,0 },;
		{"REFS"      ,"A",0            ,0,0                   ,{} };
		}

#define CODB_REPORT_BODY { ;
		{"ID"        ,"C",CODB_ID_LEN  ,0,CODB_LENTYPE_RTRIM,""},;
		{"NAME"      ,"C",50           ,0,CODB_LENTYPE_RTRIM,""},;
		{"TYPE"      ,"C",1            ,0,CODB_LENTYPE_RTRIM,"C"},;
		{"FILENAME"  ,"C",256          ,0,CODB_LENTYPE_RTRIM,""},;
		{"CLASS_ID"  ,"C",CODB_ID_LEN  ,0,CODB_LENTYPE_RTRIM,""},;
		{"EXTENT_ID" ,"C",CODB_ID_LEN  ,0,CODB_LENTYPE_RTRIM,""},;
		{"GROUP_ID"  ,"C",CODB_ID_LEN  ,0,CODB_LENTYPE_RTRIM,""},;
		{"USER_ID"   ,"C",CODB_ID_LEN  ,0,CODB_LENTYPE_RTRIM,""};
		}

#define CODB_PLUGINS_BODY { ;
		{"ID"        ,"C",CODB_ID_LEN  ,0,CODB_LENTYPE_RTRIM,""},;
		{"NAME"      ,"C",50           ,0,CODB_LENTYPE_RTRIM,""},;
		{"TYPE"      ,"C",1            ,0,CODB_LENTYPE_RTRIM,"C"},;
		{"FILENAME"  ,"C",256          ,0,CODB_LENTYPE_RTRIM,""},;
		{"MAINFUNC"  ,"C",50           ,0,CODB_LENTYPE_RTRIM,""},;
		{"CLASS_ID"  ,"C",CODB_ID_LEN  ,0,CODB_LENTYPE_RTRIM,""};
		}

#define CODB_INDEX_BODY { ;
		{"ID"        ,"C",CODB_ID_LEN  ,0,CODB_LENTYPE_RTRIM,""},;
		{"NAME"      ,"C",50           ,0,CODB_LENTYPE_RTRIM ,""},;
		{"EXPR"      ,"C",250          ,0,CODB_LENTYPE_RTRIM,"{|oData,oDeposit|}"};
		}

#define CODB_COUNTER_BODY { ;
		{"ID"        ,"C",CODB_ID_LEN  ,0,CODB_LENTYPE_RTRIM,""},;
		{"NAME"      ,"C",50           ,0,CODB_LENTYPE_RTRIM ,""},;
		{"TYPE"      ,"C",4            ,0,CODB_LENTYPE_RTRIM ,"MAX"},;
		{"DEPOSIT"   ,"C",DEPOSIT_ID_LEN,0,CODB_LENTYPE_NONE,""}, ;
		{"MAX_VALUE" ,"N",6		,0,CODB_LENTYPE_NONE,0}, ;
		{"LAST_VALUE","N",6		,0,CODB_LENTYPE_NONE,0} ;
		}


/* end of codb_dbf.ch*/
#endif

