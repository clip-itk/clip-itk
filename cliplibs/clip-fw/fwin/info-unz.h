#define ZIP_OK              0
#define ZIP_FILEERROR      -1
#define ZIP_INTERNALERROR  -2
#define ZIP_NOMOREITEMS     1

typedef struct
{
   BYTE internal[ 8 ];
   WORD wTime, wDate;
   LONG lSize, lCompressSize, lHeaderOffset;
   BYTE szFileName[ 80 ];
   WORD wPackMethod;
   BYTE bAttr;
} TZipRec, * pTZipRec;

// Hi byte= number before period, Lo byte=number after period
WORD pascal GetUnzipDllVersion( void );

int pascal GetFirstInZip( LPSTR zipfilename, pTZipRec zprec );

int pascal GetNextInZip( pTZipRec zprec );

void pascal CloseZipFile( pTZipRec zprec );

BOOL pascal IsZip( LPSTR zipFileName );

WORD pascal UnzipFile( LPSTR szName, LPSTR szOutName, LONG offset,
                       HWND hFileAction, int iCmdNotification );
