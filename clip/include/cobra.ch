#ifndef __COBRA_CH__
#define __COBRA_CH__

/* CLIP Object Broker & Application Server: default settings */
#define COBRA_VERSION  0.20
#define COBRA_COMPAT_VERSION  0.20
#define COBRA_BUFLEN   32000
#define COBRA_DEFPORT  3000
#define COBRA_DEFHOST "localhost"
#define COBRA_CONNECT_TIMEOUT 10000
#define COBRA_IO_TIMEOUT 1000

#define COBRA_CRYPTO "des"
#define COBRA_AUTH_SCRIPT "./auth/pam-auth"

/* Error codes */
#define COBRA_ERR_BADVERSION  10001
#define COBRA_ERR_BADLANG     10002
#define COBRA_ERR_BADCHARSET  10003
#define COBRA_ERR_BADCRYPTO   10004
#define COBRA_ERR_BADCOMMAND  10005
#define COBRA_ERR_BADARG      10006
#define COBRA_ERR_BADFILENAME 10007
#define COBRA_ERR_SYSCMD      10008
#define COBRA_ERR_AUTH        10009
#define COBRA_ERR_RUNTIME     10010
#define COBRA_ERR_CODB        10011
#define COBRA_ERR_BADOBJID    10012
#define COBRA_ERR_BADDATA     10013

#define COBRA_ERR_BADANSWER   10015
#define COBRA_ERR_BADQUERY    10016
#define COBRA_ERR_BADINFO     10017

#endif

