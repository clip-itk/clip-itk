#ifndef _NTNNET

#define OBJ_WILD		65535	// Wild thing, you make
					// my heart swing....
#define OBJ_UNKNOWN		0
#define OBJ_USER		256
#define OBJ_GROUP		512
#define OBJ_PRINTQUEUE		768
#define OBJ_FILESERVER		1024
#define OBJ_JOBSERVER		1280
#define OBJ_GATEWAY		1536
#define OBJ_PRINTSERVER 	1792
#define OBJ_ARCHIVEQUEUE	2048
#define OBJ_ARCHIVESERVER	2304
#define OBJ_JOBQUEUE		2560
#define OBJ_ADMIN		2816
#define OBJ_BRIDGESERVER	9728
#define OBJ_ADVPRINTSERVER	18176


// Property types
#define PRP_ITEM		1
#define PRP_SET 		2


// Broadcast modes
#define BRD_RECALL		0
#define BRD_RECSERVER		1
#define BRD_STORESERV		2
#define BRD_STOREALL		3


// Subarray structure NNETDIRS()
#define ND_NAME 		1
#define ND_CREADATE		2
#define ND_CREATIME		3
#define ND_RIGHTS		4
#define ND_OWNER		5

#define ND_UPDDATE		6
#define ND_UPDTIME		7
#define ND_ARCDATE		8
#define ND_ARCTIME		9
#define ND_ACHIVER		10


// Extended file attributes
#define EXA_TTS 		16
#define EXA_INDEX		32
#define EXA_READAU		64
#define EXA_WRITAU		128


// Subarray structure NNETFILES()
#define NF_NAME 		1
#define NF_SIZE 		2
#define NF_UPDDATE		3
#define NF_UPDTIME		4
#define NF_CREADATE		5
#define NF_ATTR 		6
#define NF_EXTATTR		7
#define NF_OWNER		8

#define NF_ARCDATE		9
#define NF_ARCTIME		10
#define NF_ACHIVER		11


// Subarray structure for NNETSALLST()
#define SAL_NAME     		1
#define SAL_SIZE     		2
#define SAL_DATE     		3
#define SAL_TIME     		4
#define SAL_DELETOR  		5

// Just in case somebody can't live without NNETDELUSR()
// and NNETDELGRP()
#xtranslate NNETDELUSR(<Username>[,<Server>])  => ;
	    NNETDELOBJ(<Username>,OBJ_USER [,<Server>])

#xtranslate NNETDELGRP(<Username>[,<Server>])  => ;
	    NNETDELOBJ(<Username>,OBJ_GROUP [,<Server>])


#define _NTNNET

#endif
