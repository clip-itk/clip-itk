/* -*- Mode: C -*-
 *
 * $Id: ezV24.h,v 1.2 2002/09/11 09:11:28 clip Exp $
 * -----------------------------------------------------------------------
 * Copyright  (c) 2001,02  Joerg Desch <jd@die-deschs.de>
 * -----------------------------------------------------------------------
 * PROJECT: ezV24 -- easy RS232/V24 access
 * MODULE.: EZV24.H: 
 * AUTHOR.: Joerg Desch <jdesch@users.sourceforge.net>
 * -----------------------------------------------------------------------
 * DESCRIPTION:
 *
 * -----------------------------------------------------------------------
 * COMPILER-FLAGS:
 *
 * -----------------------------------------------------------------------
 * $Log: ezV24.h,v $
 * Revision 1.2  2002/09/11 09:11:28  clip
 * new upstream verson of eZ library
 * paul
 *
 * Revision 1.2  2002/06/20 11:42:43  jdesch
 * * add error code V24_E_TIMEOUT.
 * * some fixes in the documentation.
 * * some other minor corrections.
 *
 * Revision 1.1.1.1  2002/06/20 09:51:20  jdesch
 * First CVS import of release 0.0.4
 *
 *
 */

#ifndef __EZV24_H__
#define __EZV24_H__ 1


#include <stdlib.h>			     /* we need size_t */

#ifdef __cplusplus
extern "C" {
#endif



/*+=========================================================================+*/
/*|                      CONSTANT AND MACRO DEFINITIONS                     |*/
/*`========================================================================='*/

/*  common constant declarations
 */
#define V24_SZ_PORTNAME 25		     /* max. length of the port name */


/**
 */
enum __EZV24_ERROR_CODES
{
    /// no error, all went fine.
    V24_E_OK=0,
    /// `general' illegal parameter.
    V24_E_ILLPARM,
    /// illegal baudrate.
    V24_E_ILLBAUD,
    /// illegal datasize.
    V24_E_ILLDATASZ,
    /// illegal parity.
    V24_E_ILLPARITY,

    /** illegal handle. The parameter specifying the \emph{port handle} is
     * bad. Make sure unused handle are set to #NULL#.
     */
    V24_E_ILLHANDLE,
    /// illegal timeout value.
    V24_E_ILLTIMEOUT,
    /// creation of the lock file failed.
    V24_E_CREATE_LOCK,
    /// lock file can't be opened.
    V24_E_OPEN_LOCK,
    /// unlink of the lock file failed.
    V24_E_KILL_LOCK,
    /// can't write to the lock file.
    V24_E_WRITE_LOCK,

    /** foreign lock file exist. This means, that another process allready has
     * locked the port.
     */
    V24_E_LOCK_EXIST,
    /// not enough memory.
    V24_E_NOMEM,
    /// pointer is #NULL#.
    V24_E_NULL_POINTER,
    /// #open# failed.
    V24_E_OPEN,
    /// #read# failed.
    V24_E_READ,
    /// #write# failed.
    V24_E_WRITE,
    /// library is not initialized.
    V24_E_NOT_INIT,

    /** no #proc# file system. We can't open the virtual file #/proc/tty/...#
     */
    V24_E_NO_PROC_FILE,
    /// function not implemented.
    V24_E_NOT_IMPLEMENTED,
    /// timeout waiting for data.
    V24_E_TIMEOUT,

    /** debugging. Error codes greater than this value are debug messages.
     */
    V24_E_DBG_MESSAGES=100,

    /** stale lock file overwritten. The PID stored in the lock file doesn't
     * exist, so we can overwrite it.
     */
    V24_E_DBG_STALE_LOCK
};


enum __EZV24_BAUDRATE
{
    V24_B0=0,				     /* used to drop DTR */
    V24_B50,				     /* 50 baud */
    V24_B75,				     /* 75 baud */
    V24_B110,				     /* 110 baud */
    V24_B134,				     /* 134.5 baud */
    V24_B150,				     /* 150 baud */
    V24_B200,				     /* 200 baud */
    V24_B300,				     /* 300 baud */
    V24_B600,				     /* 600 baud */
    V24_B1200,				     /* 1200 baud */
    V24_B1800,				     /* 1800 baud */
    V24_B2400,				     /* 2400 baud */
    V24_B4800,				     /* 4800 baud */
    V24_B9600,				     /* 9600 baud */
    V24_B19200,				     /* 19200 baud */
    V24_B38400,				     /* 38400 baud */
    V24_B57600,				     /* 57,600 baud */
    V24_B115200,			     /* 115,200 baud */
    V24_NUM_BAUDRATES			     /* the number of entries */
};


enum __EZV24_DATASIZE
{
    V24_5BIT=0,
    V24_6BIT,
    V24_7BIT,
    V24_8BIT,
    V24_NUM_DATASIZES			     /* number of datasize values */
};


enum __EZV24_PARITY_FLAGS
{
    V24_NONE=0,				     /* disable parity bit */
    V24_EVEN,				     /* even parity */
    V24_ODD,				     /* odd parity */
    V24_IGNORE				     /* use parity but do not test it */
};
    

enum __EZV24_OPEN_FLAGS
{
    V24_STANDARD    = 0x0000,		     /* just empty */
    V24_LOCK        = 0x0001,		     /* lock the port */
    V24_NO_DELAY    = 0x0002,		     /* no wait on DCD */
    V24_RTS_CTS     = 0x0004,		     /* use hardware handshakes */
    V24_XON_XOFF    = 0x0008,		     /* use software handshakes */
    V24_DROP_DTR    = 0x0010,		     /* drop DTR on close the port */
    V24_NON_BLOCK   = 0x0020,		     /* non blocking read */
    V24_DEBUG_ON    = 0x8000		     /* enable stderr messages */
};



/*+=========================================================================+*/
/*|                             TYPEDECLARATIONS                            |*/
/*`========================================================================='*/

struct __EZV24_PORT_HANDLE
{
	int fd;				     /* the file handle */
	int Errno;			     /* error code of last op. */
	int Locked;			     /* Bool if port is locked */
	int lock_fd;			     /* handle of the lockfile or (-1) */
	int Initialized;		     /* Bool if port is configured */
	char PortName[V24_SZ_PORTNAME+1];    /* name of the port */
	unsigned int OpenFlags;		     /* current open flags */
	int Baudrate;			     /* current baudrate */
	int Datasize;			     /* current datasize */
	int Parity;			     /* and current parity */
	int TimeoutValue;		     /* timeout in 1/10 sec */
};

typedef struct __EZV24_PORT_HANDLE v24_port_t;

// typedef void (*v24_error_handler_t)
//     (const v24_port_t *port, const int Errno, const char* caller);


/*+=========================================================================+*/
/*|                            PUBLIC VARIABLES                             |*/
/*`========================================================================='*/

/*+=========================================================================+*/
/*|                     PROTOTYPES OF GLOBAL FUNCTIONS                      |*/
/*`========================================================================='*/



/** Detect installed serial devices. The goal of this function is to detect
 * which serial devices are installed. Therefore the #/proc# file system is
 * used. The content of the virtual file #/proc/tty/driver/serial# must be
 * present. It must hold a specially formatted line for each device (see
 * below). A device is recognized as `installed' if this line doesn't contain
 * the word ``unknown'' but contain the ``tx:''.
 *
 * The line format of the virtual file should look like this:
 *
 * \begin{verbatim} 
   0: uart:16550A port:3F8 irq:4 tx:0 rx:0
   1: uart:16550A port:2F8 irq:3 tx:0 rx:0
   2: uart:unknown port:3E8 irq:4
   \end{verbatim} 
 *
 * The result of the detection is stored in a #unsigned long# variable. For
 * every port found, the corresponding bit is set. The above sample shows us,
 * that port0 (#ttyS0#) and port1 (#ttyS1#) are present. So the bit0 and bit1
 * of the variable referenced by #BitMask# are set.
 *
 * If the function failes to detect the installed ports, a #-1# is return. If
 * all went fine, the number of detected ports is returned.
 *
 * \textbf{Note:} this function can be used without an opened device!
 *
 * @param BitMask    pointer to a #unsigned long# variable.
 * @return (int) number of detected ports or #-1#.
 */
int v24CountPorts ( unsigned long* BitMask );


/** Build a valid port name. This function can be used to build the platform
 * dependent name of the serial device used by #v24OpenPort#. The exact format
 * of the the name is explained at \Ref{v24OpenPort}.
 *
 * The parameter #PortNo# is the number of the port. The parameter #PortName#
 * is a pointer to a string buffer, where the built name is stored.
 * \textbf{Important:} the caller must ensure, that the string buffer
 * referenced by #PortName# could hold #V24_SZ_PORTNAME# characters.
 *
 * To ease the use, the function return the pointer #PortName#.
 *
 * \textbf{Note:} this function can be used without an opened device!
 *
 * @param PortNo    number of the port.
 * @param PortName  resulting name for #v24OpenPort#.
 * @return (const char*) copy of the pointer #PortName#.
 */
const char* v24PortName ( int PortNo, char* PortName );



/** This function opens a serial device for reading and writing. A pointer to a
 * special \emph{handle} is return. This handle must be passed to all futher
 * functions. If the function fails to open the port, a value of #NULL# is
 * returned to indicate the error.
 *
 * The portname is a string which represents the serial device. This
 * representation is platform dependent. The following table shows the naming
 * on several different operating systems. To avoid the usage of this names,
 * you can use \Ref{v24PortName} to build the name for you.
 *
 * \begin{tabular}{lll}
 *  \textbf{System} & \textbf{port-1}& \textbf{port-2} \\
 *  Linux           & /dev/ttyS0  & /dev/ttyS1  \\
 *  IRIX            & /dev/ttyf1  & /dev/ttyf2  \\
 *  HP-UX           & /dev/tty1p0 & /dev/tty2p0 \\
 *  Solaris/SunOS   & /dev/ttya   & /dev/ttyb   \\
 *  Digital UNIX    & /dev/tty01  & /dev/tty02  \\
 *  Windows         & com1:       & com2:
 * \end{tabular}
 *
 * The \emph{open flags} are used to specify a special behaviour ot the
 * library. The following flag can be OR'ed together.
 *
 * \begin{description}
 *   \item[#V24_STANDARD#]	just empty. The defaults are used.
 *   \item[#V24_LOCK#]    	lock the port. Therefore a lock file is
 *                              created. After the port is closed, the lock
 *                              file is removed automagically.
 *   \item[#V24_NO_DELAY#]	no wait on DCD.
 *   \item[#V24_RTS_CTS#] 	use RTS/CTS hardware handshake.
 *   \item[#V24_XON_XOFF#]	use Xon/Xoff software handshake.
 *   \item[#V24_DROP_DTR#]	drop DTR after closing the port.
 *   \item[#V24_NON_BLOCK#]	non blocking read. Using this flag, the read
 *                              access is not delayed. Without this, read will
 *                              wait until a character is received or the
 *                              timeout time is reached.
 *   \item[#V24_DEBUG_ON#]	enable stderr messages.
 * \end{description}
 *
 *
 * Some more word about the lock files: the handling of the lock file
 * (hopefully) accords to the specification from
 * #http://www.pathname.com/fhs/2.0/fhs-5.5.html#.
 *
 * Device lock files, such as the serial device lock files that were originally
 * found in either #/usr/spool/locks# or #/usr/spool/uucp#, must now be stored
 * in #/var/lock#. The naming convention which must be used is #LCK..# followed
 * by the base name of the device.  For example, to lock #/dev/ttyS0# the file
 * #LCK..ttyS0# would be created.
 * 
 * The format used for device lock files must be the HDB UUCP lock file
 * format. The HDB format is to store the process identifier (PID) as a ten
 * byte ASCII decimal number, with a trailing newline. For example, if process
 * 1230 holds a lock file, it would contain the eleven characters: space,
 * space, space, space, space, space, one, two, three, zero, and newline.
 *
 * @param PortName    the name of the device.
 * @param OpenFlags   the OR'ed \emph{open flags}.
 * @return (v24_port_t*) pointer to a handle of the opened device.
 * @see v24ClosePort, v24SetParameters, v24SetTimeouts
 * @memo open a device.
 */
v24_port_t* v24OpenPort ( const char* PortName, unsigned int OpenFlags );


/** This function closes a previously opened device. If a lock file is used,
 * this file will be removed. As a result the #V24_*# error code is
 * returned. Possible errors are V#24_E_ILLHANDLE# and #V24_E_KILL_LOCK#. If
 * all went fine, #V24_E_OK# is returned.
 *
 * @param port pointer to handle of the opened port.
 * @return (int) the #V24_*# error code.
 * @see v24OpenPort
 * @memo close a device.
 */
int v24ClosePort ( v24_port_t *port );


/** After a serial device is opened, the user have to setup the communication
 * parameter. The parameter #port# references the handle of the opened
 * device. With #Baudrate#, the speed can be set as bitrate (bits per
 * second). Use the #__EZV24_BAUDRATE# values as parameter. The size of a
 * transmitted data byte can be passed as #__EZV24_DATASIZE# value to
 * #Datasize#. The last parameter #Parity# defines the parity checking. The
 * possible values are defined in #__EZV24_PARITY_FLAGS#.
 *
 * The number of stop bits is set to #1#. If you need #2# stop bits, you have
 * to call \Ref{v24SetStopbits}.
 *
 * The values returned are: #V24_E_ILLHANDLE#, #V24_E_ILLBAUD#,
 * #V24_E_ILLDATASZ#, #V24_E_ILLPARITY# and #V24_E_OK#.
 *
 * @param port pointer to handle of the opened port.
 * @param Baudrate a #V24_*# constant representing the \emph{baudrate}.
 * @param Datasize a #V24_*# constant representing the size of a data byte.
 * @param Parity a #V24_*# constant representing the parity check mode.
 * @return (int) the #V24_*# error code.
 * @memo setup the communication parameters.
 */
int v24SetParameters ( v24_port_t *port, int Baudrate, int Datasize, int Parity );


/** Setup the number of stop bits. This function should be called directly
 * after \Ref{v24SetParameters}. The parameter #Stops# have to be set to the
 * correct number of stopbits. Valid values are #1# and #2#.
 *
 * The values returned are: #V24_E_OK#, #V24_E_ILLHANDLE#, #V24_E_ILLPARM#,
 * #V24_E_NOT_INIT#.
 *
 * @param port pointer to handle of the opened port.
 * @param Stops the number of stop bits.
 * @return (int) the #V24_*# error code.
 * @see v24SetParameters
 * @memo setup stopbits.
 */
int v24SetStopbits ( v24_port_t *port, int Stops );



/** All read functions may use a timeout mechanism while waiting for
 * characters. If this time limit is exceeded the function abort reading. The
 * timeout mechanism is only active, if the \emph{open flag} #V24_NON_BLOCK#
 * isn't specified.
 *
 * The timeout duration is specified by the parameter #TenthOfSeconds#. This
 * value is given as a multiple of a thenth of a second.
 *
 * The values returned are: #V24_E_OK#, #V24_E_ILLHANDLE#, #V24_E_ILLTIMEOUT#,
 * #V24_E_NOT_INIT#.
 *
 * @param port             pointer to handle of the opened port.
 * @param TenthOfSeconds   the timeout duration.
 * @return (int) the #V24_*# error code.
 * @memo
 */
int v24SetTimeouts ( v24_port_t *port, int TenthOfSeconds );


/** The function tries to read a single character from the opened device. To do
 * this, the function \Ref{v24Read} is used. If we have got some data, the
 * character is returned as integer value. The caller have to cast it to the
 * data type he need. 
 *
 * In a case of an error, the functions returns #-1#. The caller has to use
 * \Ref{v24QueryErrno} to get the exact error code. Contrary to \Ref{v24Read},
 * a timeout is reported as error!
 *
 * Possible error code are #V24_OK#, #V24_E_NULL_POINTER#, #V24_E_ILLHANDLE#,
 * #V24_E_TIMEOUT# or #V24_READ#.
 *
 * @param port pointer to handle of the opened port.
 * @return (int) the character read or #-1#.
 * @see v24QueryErrno, v24Read.
 * @memo read a single character.
 */
int v24Getc ( v24_port_t *port );


/** This function simply send one character. Nothing more and nothing less.
 *
 * The values returned are: #V24_E_OK#, #V24_E_ILLHANDLE#,
 *
 * @param port pointer to handle of the opened port.
 * @param
 * @return
 * @memo write a single character.
 */
int v24Putc ( v24_port_t *port, unsigned char TheData );


/** #v24Read# is the basic function to get one or more received data bytes out
 * of the receive queue. If the queue is empty, the behavious of the function
 * depends on the used \emph{open flags}. Without any open flags, a empty
 * receive queue leads to an error. If the flag #V24_NON_BLOCK# is used, the
 * function will wait for the reception of character. The wait time is limited
 * to the given \emph{timeout time}. If this limit is exceeded, the function
 * aborts waiting. If nothing is read, the returned value is #0#, and the error
 * code is set to #V24_E_TIMEOUT#. At this level it's no real error, so there
 * is no error report for the debug output (see #V24_DEBUG_ON# in
 * \Ref{v24OpenPort}).
 *
 * The parameter #Buffer# references a buffer that should hold the received
 * characters. The parameter #Len# is the number of characters to read.
 *
 * The function returns the number of character read. An error is indicated by
 * a return vlaue of #-1#. Use \Ref{v24QueryErrno} to get the exact error code.
 *
 * Possible error code are #V24_OK#, #V24_E_NULL_POINTER#, #V24_E_ILLHANDLE#,
 * #V24_E_TIMEOUT# or #V24_READ#.
 *
 * \textbf{Note:} the caller has to ensure, that #Buffer# can hold the #Len#
 * characters.
 *
 * @param port pointer to handle of the opened port.
 * @param Buffer pointer to buffer to hold the data.
 * @param Len number of characters to receive.
 * @return (int) number of received characters or #-1#.
 * @see v24QueryErrno, v24Getc, v24Gets.
 * @memo
 */
int v24Read ( v24_port_t *port, unsigned char* Buffer, size_t Len );


/** Send a buffer. This function sends all #Len# characters of the array
 * referenced by #Buffer#. The number of sent bytes is returned. If an error
 * occurs, a #-1# is returned. Use #v24QueryErrno# to retrieve the error code.
 *
 * Possible error code are #V24_OK#, #V24_E_NULL_POINTER#, #V24_E_ILLHANDLE# or
 * #V24_WRITE#. 
 *
 * @param port pointer to handle of the opened port.
 * @param Buffer pointer to buffer.
 * @param Len number of characters to send.
 * @return  (int) number of sent characters or #-1#.
 * @see v24QueryErrno, v24Putc, v24Puts.
 * @memo
 */
int v24Write ( v24_port_t *port, const unsigned char* Buffer, size_t Len  );


/** Receive a string. Unlike #v24Read#, which tries to read a fixed number of
 * character, #v24Gets# read characters unless #BuffSize# characters are
 * fetched, or a \emph{end of line} (#\n#) is recieved. At the end of the game,
 * the number of characters read ist returned. If an error occurs, a #-1# is
 * returned. The characters are stored in #Buffer#. The functions ensures a
 * #\0# terminated string!
 *
 * Possible error code are #V24_OK#, #V24_E_NULL_POINTER#, #V24_E_ILLPARM#,
 * #V24_E_ILLHANDLE# or #V24_WRITE#. To get this error code, use
 * #v24QueryErrno#.
 *
 * A string should at least have 1 character and the terminating #\0#. The
 * parameter #BuffSize# must therefore be greater than 1! If not, the operation
 * results in a #V24_E_ILLPARM# error. To read a single character, we have
 * \Ref{v24Getc}.
 *
 * \textbf{Implementation note:} the current release of the library defines the
 * \emph{end of a string} as a hard coded constant! Search the internal headers
 * #EZV24_END_OF_STRING#.
 *
 * @param port pointer to handle of the opened port.
 * @param Buffer pointer to buffer.
 * @param BuffSize the maximum size of the buffer.
 * @see v24QueryErrno, v24Getc, v24Read.
 * @return (int) number of fetched characters or #-1#.
 */
int v24Gets ( v24_port_t *port, char* Buffer, size_t BuffSize );


/** Send a string. This function simply sends all characters of the ASCIIZ
 * string. A single #\n# is not expanded to #\n\r#! The function returns the
 * number of characters sent, or a #-1# if something fails.  Use
 * #v24QueryErrno# to retrieve the error code.
 *
 * Possible error code are #V24_OK#, #V24_E_NULL_POINTER#, #V24_E_ILLHANDLE# or
 * #V24_WRITE#.
 *
 * \textbf{Implementation note:} the current release of the library defines the
 * \emph{end of a string} as a hard coded constant! Search the internal headers
 * #EZV24_END_OF_STRING#.
 *
 * @param port pointer to handle of the opened port.
 * @param Buffer a pointer to an ASCIIZ string.
 * @see v24QueryErrno, v24Putc, v24Write.
 * @return
 */
int v24Puts ( v24_port_t *port, const char* Buffer );


/** If implemented by the operating system, this function returns the number of
 * character waiting in the receive-queue. If the functions isn't available or
 * if an error happens, a #-1# is returned. Use #v24QueryErrno# to retrieve the
 * error code.
 *
 * Possible error code are #V24_OK#, #V24_E_NOT_IMPLEMENTED# and
 * #V24_E_ILLHANDLE#.
 *
 * @param port pointer to handle of the opened port.
 * @return (int) number of character in the receive-queue.
 * @see v24QueryErrno.
 * @memo
 */
int v24HaveData ( v24_port_t *port );


/** All remaining characters in the receive-queue are removed.
 *
 * @param port pointer to handle of the opened port.
 * @return (int) the #V24_*# error code.
 * @memo
 */
int v24FlushRxQueue ( v24_port_t *port );


/** All remaining characters in the transmit-queue are removed.
 *
 * @param port pointer to handle of the opened port.
 * @return (int) the #V24_*# error code.
 * @memo
 */
int v24FlushTxQueue ( v24_port_t *port );


/** Set the state of the DTR line according to the parameter #NewState#. If
 * #NewsState# is #0# the DTR signal is unset, otherwise it is set.
 *
 * @param port pointer to handle of the opened port.
 * @param NewState the new state to set DTR to.
 * @return (int) the #V24_*# error code.
 * @memo
 */
int v24SetDTR ( v24_port_t *port, int NewState );


/** Set the state of the RTS line according to the parameter #NewState#. If
 * #NewsState# is #0# the RTS signal is unset, otherwise it is set. This is
 * only allowed, if the port don't use \emph{hardware handshaking}. This means,
 * \Ref{v24OpenPort} isn't called with #V24_RTS_CTS#. If hardware handshaking
 * is used while calling this function, it aborts and returns #V24_E_ILLPARM#
 * as error.
 *
 * The values returned are: #V24_E_OK#, #V24_E_ILLHANDLE#, #V24_E_ILLPARM#,
 * #V24_E_NOT_IMPLEMENTED#.
 *
 * @param port pointer to handle of the opened port.
 * @param NewState the new state to set DTR to.
 * @return (int) the #V24_*# error code.
 * @memo
 */
int v24SetRTS (v24_port_t *port, int NewState );


/** This functions returns the platform dependent name of the currently opened
 * device.
 *
 * @param port pointer to handle of the opened port.
 * @return (const char*) the name of the device.
 * @memo
 */
const char* v24QueryPortName ( v24_port_t *port );


/** In some cases it is may be necessary to know the file handle returned by
 * the internal #open# call. To retrieve the current file handle for an opened
 * port, use this function. 
 *
 * @param port pointer to handle of the opened port.
 * @return (int) internal used file handle.
 * @memo
 */
int v24QueryFileHandle ( v24_port_t *port );


/** If possible, all functions return the result of the operation as return
 * code. Some function don't do this. Therefore, the last error code could be
 * retrieved with this function.
 *
 * For example: #v24Read# reports an error by returning a #-1#. To get the
 * exact error code, the application can call #v24QueryErrno#.
 *
 * @param port pointer to handle of the opened port.
 * @return the last error code as #V24_*# constant.
 * @memo
 */
int v24QueryErrno ( v24_port_t *port );



#ifdef __cplusplus
};
#endif

#endif
/* ==[End of file]========================================================== */

