
#ifndef __CONFIG_DEFINED
#define __CONFIG_DEFINED

		// language compatibilites
#define __NO_PGCH__  // comment for Chinese or other two byte charset`s

			 // define OS type
#define __UNIX__
			 // clipper version cpmpatible defines
//#define CLIPPER50_COMPATIBLE
#define CLIPPER53_COMPATIBLE
//#define FOXPRO_COMPATIBLE
#ifdef CLIPPER53_COMPATIBLE
	// new version clipper 5.3 have in getsys.prg
	// ( readmodal() and command GET )
	// setcursor() function call
	// clipper 5.0 and old version 5.3 don`t have this call
	//
	// #define SETCURSOR_IN_GETSYS
#endif

			// OS compatible defines
#ifdef __UNIX__
    #define CRLF    "&\n"
    #define PATH_DELIM  "/"
    #define FILE_MASK  "*"
    #define OS_SHELL    "/bin/sh"
    #define CLIPROOT_DEFAULT_PATH "/usr/local/clip"
#else
    #define CRLF    "&\r&\n"
    #define PATH_DELIM  "\\"
    #define FILE_MASK  "*.*"
//    #define OS_SHELL    "command.com"
    #define OS_SHELL    getenv("COMSPEC")
    #define CLIPROOT_DEFAULT_PATH "C:\CLIP"
#endif


		   //  maximum len in GET command for edit memo
#define GETOBJ_MAX_MEMO_LEN 1000
		   //  maximum color palette in GET object
#define GET_MAX_COLORS 10
		   //  enable var types for GET object
#define GETS_TYPES "CNDMLT"

		   //  maximum and minimum key codes in inkey()
#define MIN_KEY_CODE   -40
#define MAX_KEY_CODE   500

#define MAX_ALIASES    256

/*DOS-like 2bytes structure in save/rest screen functons*/
#define CLIP_DOS_SCRBUF


#endif
