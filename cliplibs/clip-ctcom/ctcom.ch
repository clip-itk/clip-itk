
#ifndef __SERIAL__
  #define __SERIAL__

  #include "clipcfg.h"

  #ifdef OS_LINUX
     #define UUCP_LCK_DIR "/var/lock"
     #define TTY_DEVNAME  "/dev/ttyS"  		/* + nomer of port */
  #else
     #define UUCP_LCK_DIR "/var/spool/lock"
     #define TTY_DEVNAME  "/dev/ttyd"           /* + nomer of port */
  #endif

  #define MCR_ERROR   0     		/* parameter error */
  #define MCR_DTR     1 		/* Data Terminal Redy (DTR) */
  #define MCR_RTS     2 		/* Ready To Send (RTS) */
  #define MCR_OUT1    4 		/* OUT 1 */
  #define MCR_OUT_1   4     		/* */
  #define MCR_OUT2    8 		/* OUT 2 */
  #define MCR_OUT_2   8     		/* */
  #define MCR_LOOP   16 		/* LOOP */

  /* not supported */
  #define MSR_ERROR	       0       /* parameter error */
  #define MSR_DELTA_CTS	       1       /* Delta Clear to Send */
  #define MSR_DELTA_DSR	       2       /* Delta Data Set Ready */
  #define MSR_TERI	       4       /* Trailing Edge Ring Indicator */
  #define MSR_DELTA_DCD	       8       /* Delta Data Carrier Detect */

  #define MSR_CTS    16 	       /* Clear To Send (CTS) */
  #define MSR_DSR    32 	       /* Data Send Read (DSR) */
  #define MSR_RI     64 	       /* RING Indicator (RI) */
  #define MSR_DCD   128 	       /* Data Carrier Detected (DCD) */

  /* not supported */
  #define LSR_ERROR		0      /* Parameter Fehler */
  #define LSR_DATA_READY	1      /* Data	  Ready */
  #define LSR_OVERRUN_ERR 	2      /* Overrun Error */
  #define LSR_PARITY_ERR	4      /* Parity  Error */
  #define LSR_FRAMING_ERR 	8      /* Framing Error */
  #define LSR_BREAK	       16      /* Break   Interrupt */
  #define LSR_TRANS_HOLD_EMPTY 32      /* Transmitter Holding Empty */
  #define LSR_TRANS_EMPTY      64      /* Transmitter Empty */

  #define RS_F_NONE   0
  #define RS_F_RTS    1
  #define RS_F_XON    2
  #define RS_F_XOFF   4

  #define ERR_BADHNDL   -1  	/* zly numer handle */
  #define ERR_TIMEOUT   -5  	/* TIMEOUT */
  #define ERR_INUSE     -7  	/* port juz jest uzywany */
  #define ERR_DEF       -12 	/* b’†d w wewn‘trznych strukturach */
  #define ERR_NODEF     -13	/* nie zdefiniowany nr portu */
  #define ERR_PARAM     -14 	/* b’†d parametru */
  #define ERR_INIT      -15 	/* b’†d otwarcia portu */
  #define ERR_PIPE      -16 	/* po’†czenie przerwane przez drug† strone */
  #define ERR_OUTMEM    -18 	/* za ma’o pami‘ci */

  /* not supported */
  #define SMODE_EMPTY	      1     /* send buffer empty */
  #define SMODE_SOFT	      2     /* wait for release software handshake (X-OFF) */
  #define SMODE_HARD	      4     /* wait for release hardware handshake (CTS) */
  #define SMODE_RFLUSH	      8     /* buffer deleted by remote station */

  /* not supported */
  #define Parity   	      3     /* 2^^1 + 1^u */
  #define PARITY   	      3     /* 2^^1 + 1^u */
  #define LCR_8		    257     /* 2^^8 + 1^u */
  #define CRC_12   	   5011     /* 2^^12 + 2^^11 + 2^^3 + 2^^2 + 2^^1 + 1^u */
  #define CRC_16_X25	  69665     /* 2^^16 + 2^^12 + 2^^5 + 1^u */
  #define CRC_16   	  98309     /* 2^^16 + 2^^15 + 2^^2 + 1^u */

#endif
