/* -*- Mode: C -*-
 *
 * $Id: test-v24.c,v 1.2 2002/09/11 09:11:28 clip Exp $
 * --------------------------------------------------------------------------
 * Copyright  (c) 2001  Joerg Desch <jd@die-deschs.de>
 * -----------------------------------------------------------------------
 * PROJECT: ezV24 -- easy RS232/V24 access
 * MODULE.: TEST-V24.C: a very simple sample application
 * AUTHOR.: Joerg Desch
 * --------------------------------------------------------------------------
 * DESCRIPTION:
 *
 * --------------------------------------------------------------------------
 * COMPILER-FLAGS:
 *
 * --------------------------------------------------------------------------
 * $Log: test-v24.c,v $
 * Revision 1.2  2002/09/11 09:11:28  clip
 * new upstream verson of eZ library
 * paul
 *
 * Revision 1.1.1.1  2002/06/20 09:51:21  jdesch
 * First CVS import of release 0.0.4
 *
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <signal.h>

#include <ezV24/ezV24.h>

#define __TEST_V24_C__


/*+=========================================================================+*/
/*|                      CONSTANT AND MACRO DEFINITIONS                     |*/
/*`========================================================================='*/

/*             .-----------------------------------------------.             */
/* ___________/  local macro declaration                        \___________ */
/*            `-------------------------------------------------'            */

/*+=========================================================================+*/
/*|                          LOCAL TYPEDECLARATIONS                         |*/
/*`========================================================================='*/


/* This is the type of all defined test functions.
 */ 
typedef int (*TestFunct) (void);

/* Here we have the structure which defines a single testcase.
 */
typedef struct tagTESTDEF
{
	char* TestName;
	const char* TestDesc;
	TestFunct theTest;
} test_def_t;



/*+=========================================================================+*/
/*|                            PUBLIC VARIABLES                             |*/
/*`========================================================================='*/

/*+=========================================================================+*/
/*|                             LOCAL VARIABLES                             |*/
/*`========================================================================='*/

char MyPortName[V24_SZ_PORTNAME]={'\0'};
v24_port_t *UsedPort=NULL;

unsigned int MyOpenFlags=V24_STANDARD;
int MyTimeOut=0;

int ExecutionEnabled=1;
int WantWait=0;


/*             .-----------------------------------------------.             */
/* ___________/  all stuff for the single tests                 \___________ */
/*            `-------------------------------------------------'            */

char TestName[50]={""};			     /* Name of the test */

char DescSendOnly[] =
"Test `send-only'\n"\
"Send some (0xAA 0x55 0xA5 0x5A 0x80 0x01) characters bytewise and return.\n"\
"This is a test for v24Putc\n";

char DescSendOnly2[] =
"Test `send-only'\n"\
"Send some (0xAA 0x55 0xA5 0x5A 0x80 0x01) characters on-block and return.\n"\
"This is a test for v24Write\n";

char DescStringQuery[] =
"Test `string-query'\n"\
"This test send the special command string to a SVG-100 device and wait\n"\
"for a string answer. After a `send-only', this function should test the\n"\
"the reception of strings with v24Gets().\n";

char DescSendHello[] =
"Test `send-hello'\n"\
"Send one string \"Hello World.\\n\\r\" and return\n";


static int testSendOnly (void);
static int testSendOnly2 (void);
static int testStringQuery (void);
static int testSendHello (void);

test_def_t Tests[] =
{
    {"send-hello",DescSendHello,testSendHello},
    {"string-query",DescStringQuery,testStringQuery},
    {"send-only",DescSendOnly,testSendOnly},
    {"send-only2",DescSendOnly2,testSendOnly2},
//    {"",Desc,test},    
    {"",NULL,NULL}			     /* the last entry */
};




/*+=========================================================================+*/
/*|                      PROTOTYPES OF LOCAL FUNCTIONS                      |*/
/*`========================================================================='*/

void dumpErrorMessage ( int rc );

static int findTest (void);

static void usage (void);
static void showTestHelp (void);
static void installSignalhandler (void);
static void mySignalHandler (int reason);



/*+=========================================================================+*/
/*|                     IMPLEMENTATION OF THE FUNCTIONS                     |*/
/*`========================================================================='*/



int main( int argc, char* argv[] )
{
    int HelpOnly=0;
    int TestNr;
    int Done=0;
    int rc;

    fprintf(stderr,"ezV24 library -- simple test application\ncompiled: "__DATE__"\n\n");
    optind=1;     /* start without prog-name */
    do
    {
        switch( getopt(argc,argv,"lnHNrxdhwp:t:") )
        {
	    case 'p':
		if ( optarg )
		{
		    strncpy(MyPortName,optarg,V24_SZ_PORTNAME);
		    MyPortName[V24_SZ_PORTNAME]='\0';
		    fprintf(stderr,"info: use port `%s'\n",MyPortName);
		}
		break;
	    case 't':
		if ( optarg )
		{
		    MyTimeOut=atoi(optarg);
		    if ( MyTimeOut==0 && *optarg!='0' )
			fputs("warning: invalid timeout parm ingnored!\n",stderr);
		}
		break;
	    case 'l':
		MyOpenFlags |= V24_LOCK;
		fputs("info: open with V24_LOCK\n",stderr);
		break;
	    case 'n':
		MyOpenFlags |= V24_NO_DELAY;
		fputs("info: open with V24_NO_DELAY\n",stderr);
		break;
	    case 'r':
		MyOpenFlags |= V24_RTS_CTS;
		fputs("info: open with V24_RTS_CTS\n",stderr);
		break;
	    case 'x':
		MyOpenFlags |= V24_XON_XOFF;
		fputs("info: open with V24_XON_XOFF\n",stderr);
		break;
	    case 'd':
		MyOpenFlags |= V24_DEBUG_ON;
		fputs("info: open with V24_DEBUG_ON\n",stderr);
		break;
	    case 'H':
		HelpOnly=1;
		break;
	    case 'N':
		ExecutionEnabled=0;
		fputs("info: test execution disabled.\n",stderr);
		break;
	    case 'w':
		WantWait=1;
		fputs("info: test specific wait enabled.\n",stderr);
		break;
            case 'h':     // user want's help
            case '?':     // getopt3() reports invalid option 
                usage();
                exit(1);
            default:
                Done=1;
	}
    } while (!Done);


    if ( optind < argc )
    {
	strncpy(TestName,argv[optind],sizeof(TestName)-2);
	TestName[sizeof(TestName)-2]='\0';
    }
    else
    {
	if ( !HelpOnly )
	{
	    fputs("error: you have to select a test.\n",stderr);
	    return 2;
	}
    }
    if ( HelpOnly )
    {
	showTestHelp();
	return 0;
    }
    
    TestNr=findTest();
    if ( TestNr < 0 )
	return 2;

    if ( *MyPortName=='\0' )
    {
	fputs("error: you have to specify a portname using parm `-p'!\n",stderr);
	return 1;
    }
    installSignalhandler();

    /* First we have to open the port.
     */
    if ( MyPortName[0]=='\0' )
    {
	fputs("error: use option -p to specify a valid port!\n",stderr);
	return 1;
    }
    UsedPort=v24OpenPort(MyPortName,MyOpenFlags);
    if ( UsedPort==NULL )
    {
	fputs("error: sorry, open failed!\n",stderr);
	return 1;
    }
    fputs("info: port opened!\n",stderr);
    
    /* than we have to configure the port.
     */
    rc=v24SetParameters(UsedPort,V24_B9600,V24_8BIT,V24_NONE);
    if ( rc!=V24_E_OK )
    {
	dumpErrorMessage(rc);
	v24ClosePort(UsedPort);
	return 1;
    }
    fputs("info: parameter set to 9600,8,N,1\n",stderr);

    if ( MyTimeOut > 0 )
    {
	rc=v24SetTimeouts(UsedPort,MyTimeOut*10);
	if ( rc==V24_E_NOT_IMPLEMENTED )
	    fputs("info: setup of timeout is not available!\n",stderr);
	else if ( rc!=V24_E_OK )
	{
	    dumpErrorMessage(rc);
	    v24ClosePort(UsedPort);
	    return 1;
	}
	else
	    fprintf(stderr,"info: timeout is set to %dsec\n",MyTimeOut);
    }
    

    if ( TestNr>=0 && ExecutionEnabled )
    {
	rc = Tests[TestNr].theTest();
	if ( rc!=V24_E_OK )
	    fprintf(stderr,"error: test returns #%d\n",rc);
    }
    

    /* At the end of all the stuff, we have close the port. ;-)
     */
    rc=v24ClosePort(UsedPort);
    if ( rc!=V24_E_OK )
	dumpErrorMessage(rc);
    else
	fputs("info: port closed!\n",stderr);
    return 0;
}



void dumpErrorMessage ( int rc )
{
    switch ( rc )
    {
	case V24_E_OK: fputs("error-msg: V24_E_OK\n",stderr); break;
	case V24_E_ILLBAUD: fputs("error-msg: V24_E_ILLBAUD\n",stderr); break;
	case V24_E_ILLDATASZ: fputs("error-msg: V24_E_ILLDATASZ\n",stderr); break;
	case V24_E_ILLHANDLE: fputs("error-msg: V24_E_ILLHANDLE\n",stderr); break;
	case V24_E_ILLTIMEOUT: fputs("error-msg: V24_E_ILLTIMEOUT\n",stderr); break;
	case V24_E_OPEN_LOCK: fputs("error-msg: V24_E_OPEN\n",stderr); break;
	case V24_E_CREATE_LOCK: fputs("error-msg: V24_E_CREATE_LOCK\n",stderr); break;
	case V24_E_KILL_LOCK: fputs("error-msg: V24_E_KILL_LOCK\n",stderr); break;
	case V24_E_LOCK_EXIST: fputs("error-msg: V24_E_LOCK_EXIST\n",stderr); break;
	case V24_E_NOMEM: fputs("error-msg: V24_E_NOMEM\n",stderr); break;
	case V24_E_NULL_POINTER: fputs("error-msg: V24_E_NULL_POINTER\n",stderr); break;
	case V24_E_OPEN: fputs("error-msg: V24_E_OPEN\n",stderr); break;
	case V24_E_READ: fputs("error-msg: V24_E_READ\n",stderr); break;
	case V24_E_WRITE: fputs("error-msg: V24_E_WRITE\n",stderr); break;
	case V24_E_NOT_IMPLEMENTED: fputs("error-msg: V24_E_NOT_IMPLEMENTED\n",stderr); break;
	case V24_E_DBG_STALE_LOCK: fputs("debug-msg: V24_E_DBG_STALE_LOCK\n",stderr); break;
	default:  fputs("error-msg undefined?!?!\n",stderr); break;
    }
}



/** This functions tries to find the the test referenced by the name given by
 * #TestName#. The array #Tests[]# holds all defined tests. This array is
 * searched using a case intensive string comparison. The functions returns the
 * index of the found test, or (-1) if no test with the given name exist.
 *
 * @return (int) the index of the found test or (-1).
 */
static int findTest (void)
{
    int i;
    
    if ( TestName[0] == '\0')
	return -1;
    
    i=0;
    while ( Tests[i].TestName[0] != '\0' )
    {
	if ( strcasecmp(Tests[i].TestName,TestName)==0 )
	{
	    if ( Tests[i].theTest==NULL )
	    {
		fputs("error: undefined test!\n",stderr);
		return -1;
	    }
	    return i;
	}
	++i;
    }
    fputs("error: unknown test!\n",stderr);
    return -1;
}




/*             .-----------------------------------------------.             */
/* ___________/  the code for all the defined tests             \___________ */
/*            `-------------------------------------------------'            */


static int testSendHello (void)
{
    const char msg[]={"Hello World.\n\r"};
    int rc;
    
    rc=v24Puts(UsedPort,msg);
    if ( rc < strlen(msg) )
	dumpErrorMessage(rc);
    else
	puts("send-hello: test done!\n");    
    return 0;
}


static int testStringQuery (void)
{
    const char msg[]={"\x1B]I"};	     /* SVG-100: query ID */
    /*const char msg[]={"ATI\r"};*/	     /* Modem: query ID */
    char answer[128];
    int rc;

    /* fill the string so we can find a abort
     */
    for (rc=0;rc<sizeof(answer);rc++)
	answer[rc]='\0';
    
    rc=v24Puts(UsedPort,msg);
    if ( rc < strlen(msg) )
    {
	fputs("error: testStringQuery: v24Puts failed!\n",stderr);
	dumpErrorMessage(rc);
	return 1;
    }

    if ( WantWait )
    {
	fputs("info: testStringQuery: wait before receive!\n",stderr);
	sleep(10);
	rc=v24HaveData(UsedPort);
	if ( rc < 0 )
	{
	    fputs("error: testStringQuery: v24HaveData failed!\n",stderr);
	    dumpErrorMessage(v24QueryErrno(UsedPort));
	}
	else
	    printf("testStringQuery: %d chars waiting\n",rc);
    }

    rc=v24Gets(UsedPort,answer,sizeof(answer)-1);
    if ( rc < 0 )
    {
	fputs("error: testStringQuery: v24Gets failed!\n",stderr);
	dumpErrorMessage(v24QueryErrno(UsedPort));
	printf("testStringQuery: possible partly answer=`%s'\n",answer);
	return 1;
    }
    printf("testStringQuery: answer=`%s'\n",answer);
    return 0;
}


static int testSendOnly (void)
{
    const unsigned char TestBytes[6]={0xAA,0x55,0xA5,0x5A,0x80,0x01};
    int rc, i;
    
    for ( i=0; i<6; i++ )
    {
	rc=v24Putc(UsedPort,TestBytes[i]);
	if ( rc!=V24_E_OK )
	{
	    dumpErrorMessage(rc);
	    break;
	}
    }
    if ( i==6 )
	puts("send-only: test done!\n");    
    return (rc==V24_E_OK)?0:1;
}


static int testSendOnly2 (void)
{
    const unsigned char TestBytes[6]={0xAA,0x55,0xA5,0x5A,0x80,0x01};
    int rc;
    
    rc=v24Write(UsedPort,TestBytes,6);
    if ( rc<6 )
    {
	dumpErrorMessage(v24QueryErrno(UsedPort));
    }
    if ( rc==6 )
	puts("send-only2: test done!\n");    
    return (rc==6)?0:1;
}





/*+=========================================================================+*/
/*|                    IMPLEMENTATION OF LOCAL FUNCTIONS                    |*/
/*`========================================================================='*/


static void usage (void)
{
    fprintf(stderr,"SYNOPSIS\n");
    fprintf(stderr,"\ttest [options] testname\n");
    fprintf(stderr,"\nDESCRIPTION\n");
    fprintf(stderr,"\tThis program is used as a small test tool to debug the\n");
    fprintf(stderr,"\t`ezV24' library.\n");
    fprintf(stderr,"\nOPTIONS\n");
    fprintf(stderr,"-h\tdisplay this help page.\n");
    fprintf(stderr,"-H\tdisplay or describe the available tests.\n");
    fprintf(stderr,"-p dev\tuse serial port <dev>.\n");
    fprintf(stderr,"-t sec\tset (and reenable) timeout to <sec> seconds.\n");
    fprintf(stderr,"-l\topen with V24_LOCK to use a lock file.\n");
    fprintf(stderr,"-n\topen with V24_NO_DELAY to disable timeouts.\n");
    fprintf(stderr,"-r\topen with V24_RTS_CTS for RTS/CTS handshake.\n");
    fprintf(stderr,"-x\topen with V24_XON_XOFF for XON/OFF handshake.\n");
    fprintf(stderr,"-d\topen with V24_DEBUG_ON to enable buildin error messages.\n");
    fprintf(stderr,"-w\tenable a test specific delay. Not all tests use it.\n");
    fprintf(stderr,"-N\tdo not execute the test, but do all the rest.\n");
}


static void showTestHelp (void)
{
    int TestNr;
    int i;
   
    if ( TestName[0]=='\0' )
    {
	puts("Use `-H' with a test name to get a description of the test!\n");
	puts("List of available test:");
	i=0;
	while ( Tests[i].TestName[0] != '\0' )
	{
	    printf("\t`%s'\n",Tests[i].TestName);
	    ++i;
	}
	return;
    }

    TestNr=findTest();
    if ( TestNr==(-1) )
	return;
    puts("Test description:\n");
    puts(Tests[TestNr].TestDesc);
    puts("");
}


static void installSignalhandler ( void )
{
    signal(SIGINT,mySignalHandler);
    signal(SIGTERM,mySignalHandler);    
}


static void mySignalHandler ( int reason )
{
    // just close the serial port
    v24ClosePort(UsedPort);
    exit(99);
}


/* ==[End of file]========================================================== */

