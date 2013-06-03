#ifndef POSTGRES_CH
#define POSTGRES_CH

/* Basic PostgreSQL types */

#define PGT_ABSTIME		702					// 4	Implemented!	!
#define PGT_ACLITEM		1033				// 8	?
#define PGT_BOOL		16					// 1	Implemented!	!
#define PGT_BOX			603					// 32	Implemented!	!
#define PGT_BPCHAR		1042				// -1	Implemented!	!
#define PGT_BYTEA		17					// -1	Implemented!	!
#define PGT_CHAR		1042				// -1	Implemented!	!
#define PGT_CID			29					// 4	Implemented!	!
#define PGT_CIDR		650					// -1	Implemented!	!
#define PGT_CIRCLE		718					// 24	Implemented!	!
#define PGT_DATE		1082				// 4	Implemented!	!
#define PGT_DATETIME	1184				// 8	Text only		!
#define PGT_FILENAME	605					// 256	Implemented!	!
#define PGT_FLOAT4		700					// 4	Implemented!	!
#define PGT_FLOAT8		701					// 8	Implemented!	!
#define PGT_INET		869					// -1	Implemented!	!
#define PGT_INT2		21					// 2	Implemented!	!
#define PGT_INT28		22					// 16	Implemented!	!
#define PGT_INT4		23					// 4	Implemented!	!
#define PGT_INT8		20					// 8	?
#define PGT_LINE		628					// 32	? Not implemented in Postgres
#define PGT_LSEG		601					// 32	Implemented!	!
#define PGT_MACADDR		829					// 6    ?
#define PGT_MONEY		790					// 4	Implemented!	!
#define PGT_NAME		19					// 32	Implemented!	!
#define PGT_NUMERIC		1700				// -1	Implemented!	!
#define PGT_OID			26					// 4	Implemented!	!
#define PGT_OID8		30					// 32	Implemented!	!
#define PGT_PATH		602					// -1	Implemented!	!
#define PGT_POINT		600					// 16	Implemented!	!
#define PGT_POLYGON		604					// -1   Implemented!	!
#define PGT_REGPROC		24					// 4	?
#define PGT_RELTIME		703					// 4	Implemented!	!
#define PGT_SMGR		210					// 2	?
#define PGT_TEXT		25					// -1	Implemented!	!
#define PGT_TID			27					// 6	?
#define PGT_TIME		1083				// 8	Text only		!
#define PGT_TIMESPAN	1186				// 12	Text only		!
#define PGT_TIMESTAMP	1296				// 4	Implemented!	!
#define PGT_TINTERVAL	704					// 12	?
#define PGT_UNKNOWN		705					// -1
#define PGT_VARCHAR		1043				// -1	Implemented!	!
#define PGT_XID			28					// 4	Implemented!	!


/* PostgreSQL messages */
#define SQL_PG_SILENT_NOTICES				//Silence Postgres Notices

#endif
