/* -*- Mode: C -*-
 *
 * $Id: ezV24.c,v 1.5 2003/04/23 09:07:45 clip Exp $
 * --------------------------------------------------------------------------
 * Copyright  (c) 2001,02  Joerg Desch <jd@die-deschs.de>
 * --------------------------------------------------------------------------
 * PROJECT: ezV24 -- easy RS232/V24 access
 * MODULE.: EZV24.C:
 * AUTHOR.: Joerg Desch <jdesch@users.sourceforge.net>
 * --------------------------------------------------------------------------
 * DESCRIPTION:
 *
 * --------------------------------------------------------------------------
 * COMPILER-FLAGS:
 *
 * --------------------------------------------------------------------------
 * $Log: ezV24.c,v $
 * Revision 1.5  2003/04/23 09:07:45  clip
 * uri: small fix
 *
 * Revision 1.4  2003/04/14 09:19:24  clip
 * lock file creation mode fix by Andrei Okhremenko <andreo@sanet.ru>
 * paul
 *
 * Revision 1.3  2002/09/11 09:11:28  clip
 * new upstream verson of eZ library
 * paul
 *
 * Revision 1.2  2002/06/20 11:42:43  jdesch
 * * add error code V24_E_TIMEOUT.
 * * some fixes in the documentation.
 * * some other minor corrections.
 *
 * Revision 1.1.1.1  2002/06/20 09:51:19  jdesch
 * First CVS import of release 0.0.4
 *
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <dirent.h>			     /* we need MAXNAMLEN */
#include <signal.h>			     /* we use kill() */
#include <fcntl.h>
#include <errno.h>
#include <termios.h>
#include <sys/ioctl.h>
#include <sys/stat.h>


#define __EZV24_C__
#include "snprintf.h"
#include "ezV24.h"
#include "ezV24_config.h"


/*+=========================================================================+*/
/*|                      CONSTANT AND MACRO DEFINITIONS                     |*/
/*`========================================================================='*/

/*             .-----------------------------------------------.             */
/* ___________/  local macro declaration                        \___________ */
/*            `-------------------------------------------------'            */

/*+=========================================================================+*/
/*|                          LOCAL TYPEDECLARATIONS                         |*/
/*`========================================================================='*/

/*+=========================================================================+*/
/*|                            PUBLIC VARIABLES                             |*/
/*`========================================================================='*/

/*+=========================================================================+*/
/*|                             LOCAL VARIABLES                             |*/
/*`========================================================================='*/


/** This array is used to map our baudrate constants #V24_B*# to the value used
 * by our target system. The entry #V24_B0# is used as a placeholder for
 * \emph{dropping DTR}.
 */
static int MapBaudrate[V24_NUM_BAUDRATES]=
{
#if EZV24_POSIX_STYLE
    B0, B50, B75, B110, B134, B150, B200, B300, B600, B1200, B1800,
    B2400, B4800, B9600, B19200, B38400, B57600, B115200
#else
#error "unsupported API! Define and implement a EZV24_*_STYLE."
#endif
};


/** This array is used to map the size of the data byte to the value of the
 * target system. The library assume, that we allways have 5-8 bit per byte.
 */
static int MapDatasize[V24_NUM_DATASIZES]=
{
#if EZV24_POSIX_STYLE
    CS5, CS6, CS7, CS8
#else
#error "unsupported API! Define and implement a EZV24_*_STYLE."
#endif
};


/*+=========================================================================+*/
/*|                      PROTOTYPES OF LOCAL FUNCTIONS                      |*/
/*`========================================================================='*/

static void reportError (const v24_port_t *port, const int Errno,
			 const char* caller);

#if EZV24_WANT_LOCKFILE
static int createLockFile (v24_port_t *port);
static int deleteLockFile (v24_port_t *port);
static int buildLockName (v24_port_t *port, char* TheName, size_t Len);
#endif


/*+=========================================================================+*/
/*|                     IMPLEMENTATION OF THE FUNCTIONS                     |*/
/*`========================================================================='*/


int v24CountPorts ( unsigned long* BitMask )
{
    int count=-1;

#if defined(__LINUX__) && !defined(__CYGWIN__)
    FILE* proc_fd=NULL;
    char proc_line[80];
    int done=0;
    int i=0;

    if ( BitMask==NULL )
    {
	reportError(NULL,V24_E_NULL_POINTER,"v24CountPorts");
	return -1;
    }

    // maybe we should read an analyse /proc/tty/driver/serial
    // 0: uart:16550A port:3F8 irq:4 tx:0 rx:0
    // 1: uart:16550A port:2F8 irq:3 tx:0 rx:0
    // 2: uart:unknown port:3E8 irq:4

    proc_fd = fopen("/proc/tty/driver/serial","r");
    if ( proc_fd==NULL )
    {
	reportError(NULL,V24_E_NO_PROC_FILE,"v24CountPorts");
	return -1;
    }

    // here we have to detect the portnumber and the uart. The port exist, if
    // either the name is not "unknown" and the fields "tx" or "rx" exists.
    // maybe !strstr(proc_line,"unknown") && strstr(proc_line,"tx:") is good.
    *BitMask = 0;
    do
    {
	if ( fgets(proc_line,77,proc_fd)==NULL )
	{
	    if ( !feof(proc_fd) )	     /* not the end of the file? */
		count = -1;		     /* than it's an error */
	    proc_line[0]='\0';
	    done=1;
	}
	else
	{
	    if ( strstr(proc_line,"unknown")==NULL &&
		 strstr(proc_line,"tx:")!=NULL )
	    {
		// printf("match: %s\n",proc_line);
		(*BitMask) |= 1<<count;
		count++;
	    }
	}
	if ( ++i == 32 )		     /* we have to limit the number of */
	    done=1;			     /* results. */
    }
    while (!done);

    fclose(proc_fd);
#endif
    return count;
}


const char* v24PortName ( int PortNo, char* PortName )
{
    if ( PortName==NULL )
    {
	reportError(NULL,V24_E_NULL_POINTER,"v24PortName");
	return NULL;
    }
#if defined(__LINUX__) && !defined(__CYGWIN__)
    v24_snprintf(PortName,V24_SZ_PORTNAME-1,"/dev/ttyS%d",PortNo);
    PortName[V24_SZ_PORTNAME]='\0';
#elif  defined(__CYGWIN__)
    v24_snprintf(PortName,V24_SZ_PORTNAME-1,"COM%d",PortNo+1);
    PortName[V24_SZ_PORTNAME]='\0';
#else
    PortName[0]='\0';
#endif
    return PortName;
}


v24_port_t* v24OpenPort ( const char* PortName, unsigned int OpenFlags )
{
    v24_port_t *handle=NULL;
    int open_mode;

    /* check for `null pointer'
     */
    if ( PortName==NULL )
    {
	if ( OpenFlags&V24_DEBUG_ON )
	    reportError(NULL,V24_E_NULL_POINTER,"v24OpenPort");
	return NULL;
    }

    /* first we need to alloc and fill our handle structure
     */
    handle = (v24_port_t*)malloc(sizeof(v24_port_t));
    if ( handle==NULL)
    {
	if ( OpenFlags&V24_DEBUG_ON )
	    reportError(NULL,V24_E_NOMEM,"v24OpenPort");
	return NULL;
    }
    handle->Errno=V24_E_OK;
    strncpy(handle->PortName,PortName,V24_SZ_PORTNAME);
    handle->PortName[V24_SZ_PORTNAME]='\0';
    handle->Locked=0;
    handle->TimeoutValue=600;		     /* timeout after 600*0.1s */
    handle->Initialized=0;
    handle->OpenFlags=OpenFlags;

    open_mode = O_RDWR|O_NOCTTY;
    if ( (OpenFlags&V24_NO_DELAY) )	     /* don't want to wait? */
	open_mode |= O_NDELAY;

#if EZV24_WANT_LOCKFILE
    if ( handle->OpenFlags&V24_LOCK )
    {
	if ( createLockFile(handle) != V24_E_OK )
	{
	    reportError(handle,handle->Errno,"v24OpenPort");
	    free(handle);
	    handle=NULL;
	    return NULL;
	}
    }
#endif

    handle->fd = open(handle->PortName,open_mode);
    if ( handle->fd == -1 )
    {
	reportError(handle,V24_E_OPEN,"v24OpenPort");
	free(handle);
	handle=NULL;
	return NULL;
    }

    if ( v24SetParameters(handle,V24_B9600,V24_8BIT,V24_NONE)!=V24_E_OK )
    {
	reportError(handle,handle->Errno,"v24OpenPort");
	free(handle);
	handle=NULL;
	return NULL;
    }

    if ( v24SetTimeouts(handle,600)!=V24_E_OK )
    {
	reportError(handle,handle->Errno,"v24OpenPort");
	free(handle);
	handle=NULL;
	return NULL;
    }
    return handle;
}


int v24ClosePort ( v24_port_t *port )
{
    if ( port==NULL )
    {
	reportError(NULL,V24_E_ILLHANDLE,"v24ClosePort");
	return V24_E_ILLHANDLE;
    }
    port->Errno=V24_E_OK;

#if EZV24_WANT_LOCKFILE
    if ( port->OpenFlags&V24_LOCK )
    {
	if ( deleteLockFile(port)!=V24_E_OK )
	{
	    reportError(port,port->Errno,"v24ClosePort");
	}
    }
#endif

    close(port->fd);
    free(port);
    port=NULL;
    return V24_E_OK;
}


int v24SetParameters ( v24_port_t *port, int Baudrate, int Datasize, int Parity )
{
    struct termios options;

    if ( port==NULL )
    {
	reportError(port,V24_E_ILLHANDLE,"v24SetParameters");
	return V24_E_ILLHANDLE;
    }
    port->Errno=V24_E_OK;
    if ( (Baudrate<0) || (Baudrate>=V24_NUM_BAUDRATES) )
    {
	port->Errno=V24_E_ILLBAUD;
	reportError(port,port->Errno,"v24SetParameters");
	return port->Errno;
    }
    port->Baudrate=Baudrate;

    if ( (Datasize<0) || (Datasize>=V24_NUM_DATASIZES) )
    {
	port->Errno=V24_E_ILLDATASZ;
	reportError(port,port->Errno,"v24SetParameters");
    }
    port->Datasize=Datasize;


    /* Get the current options for the port...
     */
    tcgetattr(port->fd,&options);

    /* General Setup: the library is design for `raw mode'. Only 1 stop can be
     * configured. There's no special `break handling'. The input stream
     * shouldn't be modified. Therefore parity error aren't marked and the
     * input mapping is disabled.
     */
#if EZV24_HAVE_CFMAKERAW
    cfmakeraw(&options);
#else
#ifdef __CYGWIN__
    options.c_lflag &= ~(ICANON|ECHO|ECHOE|ECHOK|ECHONL|ISIG|IEXTEN|TOSTOP);
#else
    options.c_lflag &= ~(ICANON|ECHO|ECHOE|ECHOK|ECHONL|ISIG|IEXTEN|NOFLUSH|TOSTOP);
#endif
    options.c_cflag &= ~CSTOPB;
    options.c_iflag &= ~(IGNBRK|BRKINT|PARMRK);
    options.c_iflag &= ~(INLCR|IGNCR|ICRNL|IUCLC|IMAXBEL);
    options.c_oflag &= ~OPOST;
#endif

    /* handle the handshaking according to the open flags
     */
    if ( port->OpenFlags&V24_RTS_CTS )
	options.c_cflag |= CRTSCTS;
    else
	options.c_cflag &= ~CRTSCTS;
    if ( port->OpenFlags&V24_DROP_DTR )
	options.c_cflag |= HUPCL;
    else
	options.c_cflag &= ~HUPCL;
    if ( port->OpenFlags&V24_XON_XOFF )
    {
	options.c_iflag |= (IXON|IXOFF|IXANY);
	options.c_cc[VSTART] = 0x11;	     /* DC1, XON */
	options.c_cc[VSTOP] = 0x13;	     /* DC3, XOFF */
    }
    else
	options.c_iflag &= ~(IXON|IXOFF|IXANY);

    /* Decide wether to block while waiting for character or return immediatly.
     */
    options.c_cc[VMIN] = 0x00;
    if ( port->OpenFlags&V24_NON_BLOCK )
	options.c_cc[VTIME] = 0x00;
    else
	options.c_cc[VTIME] = port->TimeoutValue;


    /* Mask the character size bits and set data bits according to the
     * parameter.
     */
    options.c_cflag &= ~CSIZE;
    options.c_cflag |= MapDatasize[port->Datasize];

    /* Set the handling of the parity bit.
     */
    switch ( Parity )
    {
	case V24_NONE:			     /* disable parity bit */
	    options.c_cflag &= ~PARENB;
	    options.c_iflag &= ~INPCK;
	    break;
	case V24_EVEN:			     /* even parity */
	    options.c_cflag |= PARENB;
	    options.c_cflag &= ~PARODD;
	    options.c_iflag &= ~IGNPAR;
	    options.c_iflag |= INPCK;	     /* removed "|ISTRIP" */
	    break;
	case V24_ODD:			     /* odd parity */
	    options.c_cflag |= PARENB;
	    options.c_cflag |= PARODD;
	    options.c_iflag &= ~IGNPAR;
	    options.c_iflag |= INPCK;	     /* removed "|ISTRIP" */
	    break;
	case V24_IGNORE:		     /* use parity but dont test */
	    options.c_cflag |= PARENB;
	    options.c_iflag |= IGNPAR;
	    break;
	default:
	    port->Errno=V24_E_ILLPARITY;
	    reportError(port,port->Errno,"v24SetParameters");
	    return port->Errno;
    }

    /* We have to enable the receiver and set the port to local mode.
     */
    options.c_cflag |= (CLOCAL|CREAD);

    /* Set the baud rates according to the parameter.
     */
    cfsetispeed(&options,MapBaudrate[port->Baudrate]);
    cfsetospeed(&options,MapBaudrate[port->Baudrate]);

    /* At last we must set the new options for the port.
     */
    tcsetattr(port->fd,TCSANOW,&options);

    port->Initialized=1;
    return port->Errno;
}


int v24SetStopbits ( v24_port_t *port, int Stops )
{
    struct termios options;

    if ( port==NULL )
    {
	reportError(port,V24_E_ILLHANDLE,"v24SetStopbits");
	return V24_E_ILLHANDLE;
    }
    port->Errno=V24_E_OK;
    if ( port->Initialized )
    {
	/* Get the current options for the port...
	 */
	if ( Stops==1 )
	{
	    tcgetattr(port->fd,&options);
	    options.c_cflag &= ~CSTOPB;
	    tcsetattr(port->fd,TCSANOW,&options);
	}
	else if ( Stops==2 )
	{
	    tcgetattr(port->fd,&options);
	    options.c_cflag |= CSTOPB;
	    tcsetattr(port->fd,TCSANOW,&options);
	}
	else
	    port->Errno=V24_E_ILLPARM;
    }
    else
    {
	port->Errno=V24_E_NOT_INIT;
	return port->Errno;
    }

    return port->Errno;
}



int v24SetTimeouts ( v24_port_t *port, int TenthOfSeconds )
{
    struct termios options;

    if ( port==NULL )
    {
	reportError(port,V24_E_ILLHANDLE,"v24SetTimeouts");
	return V24_E_ILLHANDLE;
    }
    port->Errno=V24_E_OK;
    if ( TenthOfSeconds <= 0 )
    {
	port->Errno=V24_E_ILLTIMEOUT;
	reportError(port,port->Errno,"v24SetTimeouts");
	return port->Errno;
    }

    port->TimeoutValue=TenthOfSeconds;
    if ( port->Initialized )
    {
	tcgetattr(port->fd,&options);
	options.c_cc[VMIN] = 0;		     /* we want `interchar timeouts' */
	options.c_cc[VTIME] = port->TimeoutValue;
	tcsetattr(port->fd,TCSANOW,&options);
	port->OpenFlags &= ~V24_NON_BLOCK;   /* switch to non-blocking */
    }
    else
	port->Errno=V24_E_NOT_INIT;
    return port->Errno;
}


int v24Getc ( v24_port_t *port )
{
    unsigned char TheData;

    if ( port==NULL )
    {
	reportError(port,V24_E_ILLHANDLE,"v24Getc");
	return -1;
    }
    if ( v24Read(port,&TheData,1)!=1 )
    {
	reportError(port,port->Errno,"v24Getc");
	return -1;
    }
    return (int)TheData;
}


int v24Putc ( v24_port_t *port, unsigned char TheData )
{
    if ( port==NULL )
    {
	reportError(port,V24_E_ILLHANDLE,"v24Putc");
	return -1;
    }
    if ( v24Write(port,&TheData,1)!=1 )
	reportError(port,port->Errno,"v24Putc");
    return port->Errno;
}


int v24Read ( v24_port_t *port, unsigned char* Buffer, size_t Len )
{
    size_t _read;

    if ( port==NULL )
    {
	reportError(port,V24_E_ILLHANDLE,"v24Read");
	return -1;
    }
    port->Errno=V24_E_OK;
    if ( Buffer==NULL )
    {
	port->Errno=V24_E_NULL_POINTER;
	reportError(port,port->Errno,"v24Read");
	return -1;
    }

    _read=read(port->fd,Buffer,Len);
    if ( _read < 0 )
    {
	port->Errno=V24_E_READ;
	reportError(port,port->Errno,"v24Read");
    }
    else if ( _read == 0 )
    {
	port->Errno=V24_E_TIMEOUT;
    }
    return _read;
}


int v24Write ( v24_port_t *port, const unsigned char* Buffer, size_t Len )
{
    size_t _sent;

    if ( port==NULL )
    {
	reportError(port,V24_E_ILLHANDLE,"v24Write");
	return -1;
    }
    port->Errno=V24_E_OK;
    if ( Buffer==NULL )
    {
	port->Errno=V24_E_NULL_POINTER;
	reportError(port,port->Errno,"v24Write");
	return -1;
    }
    _sent=write(port->fd,Buffer,Len);
    if ( _sent < 0 )
    {
	port->Errno=V24_E_WRITE;
	reportError(port,port->Errno,"v24Write");
    }
    return _sent;
}


int v24Gets ( v24_port_t *port, char* Buffer, size_t BuffSize )
{
    int total;				     /* allready read */
    int nbytes;				     /* size of the read chunk */
    char* bufptr;

    if ( port==NULL )
    {
	reportError(port,V24_E_ILLHANDLE,"v24Gets");
	return -1;
    }
    port->Errno=V24_E_OK;
    if ( Buffer==NULL )
    {
	port->Errno=V24_E_NULL_POINTER;
	reportError(port,port->Errno,"v24Gets");
	return -1;
    }

    /* a string should at least have 1 character and the terminating #\0#. To
     * read a single character, we have #v24Getc#.
     */
    if ( BuffSize<2 )
    {
	port->Errno=V24_E_ILLPARM;
	reportError(port,port->Errno,"v24Gets");
	return -1;
    }

    /* read characters into our string Buffer until we get a
     * EZV24_END_OF_STRING. To be able to check this, we must read `byte for
     * byte' instead of the previous (BuffSize-total-1) chunkwise read.
     */
    total=nbytes=0;
    bufptr=Buffer;
    while ( (nbytes=read(port->fd,bufptr,1)) > 0 )
    {
	bufptr += nbytes;
	total += nbytes;

	/* because we read bytewise, there is no read to detect `half
	 * chunks'. So all we have to is to check if the buffer is full or the
	 * terminating char is read.
	 */
	if ( Buffer[total-1]==EZV24_END_OF_STRING )
	    break;
	if ( total==BuffSize )
	    break;
    }
    if ( nbytes < 0 )
    {
	port->Errno=V24_E_READ;
	reportError(port,port->Errno,"v24Gets");
	return -1;
    }
    *bufptr = '\0';
    return total;
}


int v24Puts ( v24_port_t *port, const char* Buffer )
{
    int _sent;

    if ( port==NULL )
    {
	reportError(port,V24_E_ILLHANDLE,"v24Puts");
	return -1;
    }
    port->Errno=V24_E_OK;
    if ( Buffer==NULL )
    {
	port->Errno=V24_E_NULL_POINTER;
	reportError(port,port->Errno,"v24Puts");
	return -1;
    }

    _sent=write(port->fd,Buffer,strlen(Buffer));
    if ( _sent < 0 )
    {
	port->Errno=V24_E_WRITE;
	reportError(port,port->Errno,"v24Puts");
    }
    return _sent;
}


int v24HaveData ( v24_port_t *port )
{
    int CharsWaiting=0;

    if ( port==NULL )
    {
	reportError(port,V24_E_ILLHANDLE,"v24HaveData");
	return -1;
    }
#if defined(__LINUX__) && !defined(__CYGWIN__)
    port->Errno=V24_E_OK;
    ioctl(port->fd,FIONREAD,&CharsWaiting);
    return CharsWaiting;
#else
/* ===== may be this is a portable work-around ===== */
/* #  if defined(F_GETFL) && defined(O_NDELAY) */
/*     int old; */
/*     char c; */
/*     old = fcntl(fd, F_GETFL, 0); */
/*     fcntl(fd, F_SETFL, old | O_NDELAY); */
/*     CharsWaiting = read(port->fd, &c, 1); */
/*     fcntl(fd, F_SETFL, old); */
/*     return CharsWaiting; */
/* #  else */
/*     port->Errno=V24_E_NOT_IMPLEMENTED; */
/*     return -1 ; */
/* #  endif */
/* ================================================= */
    port->Errno=V24_E_NOT_IMPLEMENTED;
    return -1;
#endif
}


int v24FlushRxQueue ( v24_port_t *port )
{
    if ( port==NULL )
    {
	reportError(port,V24_E_ILLHANDLE,"v24FlushRxQueue");
	return V24_E_ILLHANDLE;
    }
    port->Errno=V24_E_OK;
    tcflush(port->fd,TCIFLUSH);
    return port->Errno;
}


int v24FlushTxQueue ( v24_port_t *port )
{
    if ( port==NULL )
    {
	reportError(port,V24_E_ILLHANDLE,"v24FlushTxQueue");
	return V24_E_ILLHANDLE;
    }
    port->Errno=V24_E_OK;
    tcflush(port->fd,TCOFLUSH);
    return port->Errno;
}


int v24SetDTR ( v24_port_t *port, int NewState )
{
    int status;

    if ( port==NULL )
    {
	reportError(port,V24_E_ILLHANDLE,"v24SetDTR");
	return V24_E_ILLHANDLE;
    }
    port->Errno=V24_E_OK;
#if defined(__LINUX__) && !defined(__CYGWIN__)
    ioctl(port->fd,TIOCMGET,&status);
    if ( NewState )
	status |= TIOCM_DTR;
    else
	status &= ~TIOCM_DTR;
    ioctl(port->fd,TIOCMSET,&status);
    return port->Errno;
#else
    port->Errno=V24_E_NOT_IMPLEMENTED;
    return V24_E_NOT_IMPLEMENTED;
#endif
}


int v24SetRTS ( v24_port_t *port, int NewState )
{
    int status;

    if ( port==NULL )
    {
	reportError(port,V24_E_ILLHANDLE,"v24SetRTS");
	return V24_E_ILLHANDLE;
    }
    port->Errno=V24_E_OK;
    if ( port->OpenFlags&V24_RTS_CTS )
    {
	port->Errno=V24_E_ILLPARM;
	return port->Errno;
    }

#if defined(__LINUX__) && !defined(__CYGWIN__)
    ioctl(port->fd,TIOCMGET,&status);
    if ( NewState )
	status |= TIOCM_RTS;
    else
	status &= ~TIOCM_RTS;
    ioctl(port->fd,TIOCMSET,&status);
    return port->Errno;
#else
    port->Errno=V24_E_NOT_IMPLEMENTED;
    return V24_E_NOT_IMPLEMENTED;
#endif
}


const char* v24QueryPortName ( v24_port_t *port )
{
    if ( port==NULL )
	return NULL;
    return port->PortName;
}


int v24QueryFileHandle ( v24_port_t *port )
{
    if ( port==NULL )
    {
	reportError(port,V24_E_ILLHANDLE,"v24QueryFileHandle");
	return -1;
    }
    return port->fd;
}


int v24QueryErrno ( v24_port_t *port )
{
    if ( port==NULL )
	return V24_E_ILLHANDLE;
    return port->Errno;
}


/*             .-----------------------------------------------.             */
/* ___________/  Group....                                      \___________ */
/*            `-------------------------------------------------'            */


/*+=========================================================================+*/
/*|                    IMPLEMENTATION OF LOCAL FUNCTIONS                    |*/
/*`========================================================================='*/


static void
reportError ( const v24_port_t *port, const int Errno, const char* caller )
{
    if ( port==NULL )
    {
	fprintf(stderr,"ezV24: %s: error %d \n",
		caller, Errno);
    }
    else
    {
	if ( port->OpenFlags&V24_DEBUG_ON )
	{
	    fprintf(stderr,"ezV24: %s: port `%s' error %d \n",
		    caller, port->PortName, Errno);
	}
    }
}




/* -------------------------------------------------------------------------
 * From http://www.pathname.com/fhs/2.0/fhs-5.5.html
 *
 * Device lock files, such as the serial device lock files that were originally
 * found in either /usr/spool/locks or /usr/spool/uucp, must now be stored in
 * /var/lock. The naming convention which must be used is LCK.. followed by the
 * base name of the device.  For example, to lock /dev/cua0 the file LCK..cua0
 * would be created.
 *
 * The format used for device lock files must be the HDB UUCP lock file
 * format. The HDB format is to store the process identifier (PID) as a ten
 * byte ASCII decimal number, with a trailing newline. For example, if process
 * 1230 holds a lock file, it would contain the eleven characters: space,
 * space, space, space, space, space, one, two, three, zero, and newline.
 * -------------------------------------------------------------------------
 */
#if EZV24_WANT_LOCKFILE



static int
createLockFile ( v24_port_t *port )
{
    char LockFile[MAXNAMLEN+1];
    char buf[64];
    int len, pid;
    int fd;
    mode_t oldmask;

    if ( port==NULL )
    {
	reportError(port,V24_E_ILLHANDLE,"createLockFile");
	return V24_E_ILLHANDLE;
    }
    port->Errno=V24_E_OK;
    port->lock_fd=(-1);

    /*  First we need the name of the lockfile of our port.
     */
    if ( buildLockName (port,LockFile,sizeof(LockFile)-1)!=V24_E_OK )
	return port->Errno;

    /* Do we have allready a lock file?
     */
    fd = open(LockFile,O_RDONLY);
    if ( fd < 0 )
    {
	if ( errno != ENOENT )
	{
	    /* something strange happened... */
	    port->Errno=V24_E_OPEN_LOCK;
	    reportError(port,port->Errno,"createLockFile");
	    return port->Errno;
	}
    }
    else
    {
	/* lock file exists. check if the lock is valid or stale
	 */
	len = read(fd,buf,sizeof buf);
	close( fd );
	if ( len )
	{
	    pid = atoi( buf );
	    if ( pid == getpid() )	     /* hey, that's us! */
	    {
		port->Locked=1;
		return port->Errno;
	    }

	    /* check if the pid exists
	     */
	    if ( kill(pid,0) == 0 )
	    {
		port->Errno=V24_E_LOCK_EXIST;
		/* yes, the process exists. lock is thus valid */
		reportError(port,port->Errno,"createLockFile");
		return port->Errno;
	    }
	    else
	    {
		reportError(port,V24_E_DBG_STALE_LOCK,"createLockFile");
	    }
	}
    }

    /* Here we have to create the lock file
     */
    oldmask=umask(0002);
    fd=creat(LockFile,S_IREAD|S_IWRITE|S_IRGRP|S_IWGRP);
    umask(oldmask);
    if (fd < 0)
    {
	port->Errno=V24_E_CREATE_LOCK;
	reportError(port,port->Errno,"createLockFile");
	return port->Errno;
    }
    else
    {
	/* Now write our pid to lock file, so others know who locked the port.
	 */
	v24_snprintf (buf,sizeof(buf),"%10d\n",getpid());
	len = write(fd,buf,strlen(buf));
	close(fd);
	if ( len <= 0 )
	{
	    port->Errno=V24_E_WRITE_LOCK;
	    reportError(port,port->Errno,"createLockFile");
	    return port->Errno;
	}
    }
    port->Locked=1;
    return port->Errno;
}


static int
deleteLockFile ( v24_port_t *port )
{
    char LockFile[MAXNAMLEN+1];
    if ( port==NULL )
    {
	reportError(port,V24_E_ILLHANDLE,"deleteLockFile");
	return V24_E_ILLHANDLE;
    }
    port->Errno=V24_E_OK;
    if ( !port->Locked )
	return port->Errno;

    /*  First we need the name of the lockfile of our port.
     */
    if ( buildLockName (port,LockFile,sizeof(LockFile)-1)!=V24_E_OK )
	return port->Errno;

    if ( unlink(LockFile) )
    {
	port->Errno=V24_E_KILL_LOCK;
	if ( port->OpenFlags&V24_DEBUG_ON )
	    reportError(port,port->Errno,"deleteLockFile");
    }
    else
	port->Locked=0;
    return port->Errno;
}

static int
buildLockName ( v24_port_t *port, char* TheName, size_t Len )
{
    char device[32];
    char* ptr;

    if ( port==NULL )
    {
	reportError(port,V24_E_ILLHANDLE,"buildLockName");
	return V24_E_ILLHANDLE;
    }
    port->Errno=V24_E_OK;
    if ( TheName==NULL )
    {
	port->Errno=V24_E_NULL_POINTER;
	reportError(port,port->Errno,"buildLockName");
	return port->Errno;
    }

    /* extract device name */
    ptr = strrchr (port->PortName,'/');
    if ( ptr )
    {
	/* we found a /dev/ style tty name */
	strncpy (device,++ptr,sizeof(device)-1);
    }
    else
    {
	/* no /dev/ specified. weird, but lets try it anyway */
	strncpy (device,port->PortName,sizeof(device)-1);
    }
    device[sizeof(device)-1]='\0';
    v24_snprintf (TheName,Len,"%s/LCK..%s",EZV24_LOCK_PATH,device);
    return port->Errno;
}

#endif /* EZV24_WANT_LOCKFILE */
/* ------------------------------------------------------------------------- */



/* ==[End of file]========================================================== */

