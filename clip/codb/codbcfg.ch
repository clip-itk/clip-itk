/* clip object data base (CODB) configuration */

#ifndef _CODBCFG_DEFINED

#define _CODBCFG_DEFINED

#define CODB_VERSION "0.6.0"
#define CODB_KNOWLEDGE "0.1.0"

/* space for all IDENT in OODB */
#define CODB_ID_LEN		12
#define DICT_ID_LEN		5
#define DEPOSIT_ID_LEN		2
#define DEP_ID_LEN		DEPOSIT_ID_LEN
// OBJECT_ID_LEN = CODB_ID_LEN - DICT_ID_LEN - DEPOSIT_ID_LEN
#define OBJECT_ID_LEN		5

#define CODB_MEMOSIZE_DEFAULT	32
#define CODB_IDX_PER_CLASS	12
#define CODB_IDX_DATALENGTH	20

#define CODB_MAX_LEN_STRING 	256
#define CODB_MAX_LEN_NUMERIC 	25
#define CODB_MIN_DECIMALS 	-3
#define CODB_MAX_DECIMALS 	9
#define CODB_DICT_CACHE		200
#define CODB_DEP_CACHE		100
#define CODB_PUBLIC_CACHE	400

		/* CODB dictionary list descriptions */
		// ID dictionary
		// name dictionary
		// where is dictionary
		// type   - DBF,MS,PG,ORA
#define CODB_METANAMES {"CLASS","ATTRIBUTE","INDEX","EXTENT","DEPOSIT","TCOLUMN","TVIEW","USER","GROUP"}
#define CODB_DICT_TYPES {"DBF","MS","PG","OR","IB","ODBC"}
#define CODB_DICT_DTYPES {"CODB","CADB"}
#define CODB_DICTTYPE_DEFAULT "DBF"
		// path for type "dbf"
#define CODB_RDD_DEFAULT "DBFCDX"
#define CODB_DDRIVER_DEFAULT "DBF"
#define CODB_IDRIVER_DEFAULT "CDX"

#define CODB_DICTLIST_STRUCTURE { ;
		{"ID"     ,"C",5  ,0}, ;
		{"BODY"   ,"M",10 ,0} ;
		}

/*
name , type, len, dec, lenType, defValue
type - database type: DBF,SQL,....
Dtype - data type: object or account transaction
*/
#define CODB_DICTLIST_BODY { ;
		{"ID"     ,"C",5  ,0,CODB_LENTYPE_NONE ,""}, ;
		{"NAME"   ,"C",25 ,0,CODB_LENTYPE_RTRIM,""}, ;
		{"TYPE"   ,"C",10 ,0,CODB_LENTYPE_RTRIM,""}, ;
		{"DTYPE"  ,"C",10 ,0,CODB_LENTYPE_RTRIM,""}, ;
		{"PATH"   ,"C",256,0,CODB_LENTYPE_RTRIM,""}, ;
		{"HOST"   ,"C",128,0,CODB_LENTYPE_RTRIM,""}, ;
		{"PORT"   ,"N",6  ,0,CODB_LENTYPE_RTRIM,0}, ;
		{"USER"   ,"C",10 ,0,CODB_LENTYPE_RTRIM,""}, ;
		{"DBNAME" ,"C",20 ,0,CODB_LENTYPE_RTRIM,""} ;
		}

#define CODB_ATTR_TYPES { ;
			{"C",[Character]},;
			{"N",[Numeric]},;
			{"D",[Date]},;
			{"L",[Logical]},;
			{"M",[Memo text]},;
			{"O",[Object]},;
			{"X",[Any data]},;
			{"R",[Reference to object]},;
			{"S",[Reference to class]},;
			{"A",[References array]},;
			{"B",[Executable code (code block)]};
			}

#define CODB_REPORT_TYPES { ;
			{"C",[CLIP source as plugins]},;
			{"P",[PRONAR like blank]},;
			{"L",[Linked procedure]};
			}

#define CODB_PLUGINS_TYPES { ;
			{"C",[CLIP source file as codeblock]},;
			{"S",[Shared loadable library]},;
			{"L",[Linked module with main function]};
			}

#define CODB_LENTYPE_NONE	1
#define CODB_LENTYPE_RTRIM	2
#define CODB_LENTYPE_ALLTRIM	3
#define CODB_LENTYPE_PADR	4

#define CODB_ATTR_LENTYPES { ;
			[As is],;
			[Right trim],;
			[Right & Left trim],;
			[Right pad length];
			}



#define CODB_INDEX_TYPES { ;
			{0,[None]},;
			{1,[Optimization]},;
			{2,[Must exist]};
			}

#define CODB_COUNTER_TYPES { ;
			{"LAST",[Last value +1]},;
			{"MAX",[MAX value +1]};
			}

#include "clipcfg.h"

#endif
