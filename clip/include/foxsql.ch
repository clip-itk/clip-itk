#ifndef _FOXSQL_DEFINED

#define _FOXSQL_DEFINED

#command CREATE TABLE <(filename)> ;
		FROM [ARRAY] <arr> ;
		[VIA <ddriver>]    ;
		=> ;
		dbcreate(<(filename)>,<arr>,<ddriver>)

#command CREATE DBF <(filename)>   ;
		FROM [ARRAY] <arr> ;
		[VIA <ddriver>]    ;
		=> ;
		dbcreate(<(filename)>,<arr>,<ddriver>)

#command CREATE TABLE <(data)>	;
		[VIA <ddriver>]   ;
		=> ;
	      fx_dbcreate(<(data)>,<ddriver>)

#command INSERT INTO <(data)>	   ;
		VALUES <valData> ;
		[VIA <ddriver>]    ;
		=> ;
	      fx_insert(<(data)>,<"valData">,<ddriver>)

#command INSERT INTO <(data)>	   ;
	     FROM ARRAY <valData>  ;
		[VIA <ddriver>]    ;
		=> ;
	      fx_insert(<(data)>,<valData>,<ddriver>)

#command INSERT INTO <(data)>	   ;
	     FROM MEMVAR           ;
		[VIA <ddriver>]    ;
		=> ;
	      fx_insert(<(data)>,,<ddriver>)

#command SELECT <*x*> => fx_select("select "+ \[<x>\])

#command SELECT <whatever>              => dbSelectArea( <(whatever)> )

/* output query result */
#define  SQL_TO_NONE 	0
#define  SQL_TO_FILE 	1
#define  SQL_TO_CURSOR 	2
#define  SQL_TO_DBF 	3
#define  SQL_TO_TABLE 	3
#define  SQL_TO_PRINTER	4
#define  SQL_TO_ARRAY	5
#define  SQL_TO_MAP	6
#define  SQL_TO_OBJECT	6
#define  SQL_TO_ANYMAP  7  // result as MAP for subquery ANY,EXIST,ALL

/* direction in GROUP BY */
#define  SQL_DIRECTION_NONE  0
#define  SQL_DIRECTION_ASC   1
#define  SQL_DIRECTION_DESC  2

/* compare operation in WHERE operator */
#define  SQL_OPER_EXACTEQUAL  	1     // "v1 == v2 "
#define  SQL_OPER_EQUAL		2     // "v1 = v2 "
#define  SQL_OPER_NOTEQUAL  	3     // "v1 != v2 "
#define  SQL_OPER_GREAT 	4     // "v1 > v2 "
#define  SQL_OPER_GREATEQUAL 	5     // "v1 >= v2 "
#define  SQL_OPER_LESS	 	6     // "v1 < v2 "
#define  SQL_OPER_LESSEQUAL 	7     // "v1 <= v2 "
#define  SQL_OPER_PERCENT 	8     // "v1 % v2 "
#define  SQL_OPER_LIKE 		9     // "v1 LIKE v2"
#define  SQL_OPER_BETWEEN 	11    // "v1 BETWEEN c1 and c2"
#define  SQL_OPER_IN 		12    // "v1 IN v2"

#define  SQL_OPER_EXIST     	15     // "EXIST (select ...)"
//#define  SQL_OPER_NOTEXIST	16     // "NOT EXIST (select ..)"
#define  SQL_OPER_ALL   	17     // "v1 <oper> ALL <subquery>"
#define  SQL_OPER_ANY   	18     // "v1 <oper> ANY <subquery>"
#define  SQL_OPER_SOME   	18     // "v1 <oper> SOME <subquery>"

#define  SQL_OPER_SELECT   	100    // " select .. from (select from)"

/* subquery in  WHERE */
#define  SQL_OPER_GROUPOPEN   	21     // " ( "
#define  SQL_OPER_GROUPCLOSE   	22     // " )"

/* bulev operator in WHERE*/
#define  SQL_OPER_NOT		31     // " NOT "
#define  SQL_OPER_AND		32     // " AND "
#define  SQL_OPER_OR		33     // " OR "
#define  SQL_OPER_XOR		34     // " XOR "

/* subquery in  WHERE */

/* for optimization  WHERE constructions */
#define  SQL_TAG_NONE   	0      // empty tag
#define  SQL_TAG_LOGICAL   	1      // logical operation
#define  SQL_TAG_OPER   	2      // compare operation
#define  SQL_TAG_COMPARE   	3      // compare operation as Lvar <oper> Rval
#define  SQL_TAG_FUNC   	4      // call function
#define  SQL_TAG_FIELD   	5      // field value
#define  SQL_TAG_CONST   	6      // constant value
#define  SQL_TAG_SUBQUERY   	7      // subquery expression

#define  SQL_TAG_GROUP   	8      // group operation as ()

#endif
