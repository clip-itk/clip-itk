/*
   (c) 2001, Przemys³aw Czerpak
*/
/*
   $Log: serial.c,v $
   Revision 1.3  2002/02/07 12:22:40  clip
   uri: HZ:

   Revision 1.2  2002/02/07 11:20:56  clip
   uri: all target in Makefile is work

*/

#include "ctcom.ch"

#include <sys/types.h>
#include <signal.h>
#include <sys/time.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <error.h>
#include <string.h>
#include <termios.h>
#include <stdlib.h>

char *LCK_DIR = UUCP_LCK_DIR;

struct com_param
{
  int fd;
  char *dev;
  struct termios oldtio, newtio;
  struct com_param *next;
};

struct com_param *com_list = NULL;

static struct com_param * find_com( int fd )
{
  struct com_param *com;

  com = com_list;
  while ( com != NULL && com->fd != fd )
    com = com->next;

  return com;
}

static void
fname_lock( char *buf, int n, char *port, char *lck_dir )
{
  char *ptr;

  snprintf(buf, n, "%s/LCK..%s", lck_dir,
            (ptr = strrchr(port, '/')) == (char *)NULL ? port : ptr + 1);
}

static void
rm_lock( char *port, char *lck_dir )
{
  char lck_file[256];

  fname_lock( lck_file, sizeof(lck_file), port, lck_dir );
  unlink(lck_file);
}

static int
mk_lock( char *port, char *lck_dir )
/* return 0=OK, -1=error, 1=locked by other proces */
{
  char lck_file[256], buf[64];
  struct stat stt;
  int pid=-1, fd, n, mask;

  /* is lock file directory present? */
  if( stat(lck_dir, &stt) == 0 ) {
    fname_lock( lck_file, sizeof(lck_file), port, lck_dir );

    pid = 0;
    if( (fd = open(lck_file, O_RDONLY)) >= 0) {
      n = read(fd, buf, sizeof(buf));
      close(fd);
      if( n == 4 ) /* Kermit-style lockfile. */
        pid = *(int *)buf;
      else if( n > 0 ) {      /* Ascii lockfile. */
        buf[n] = 0;
        sscanf(buf, "%d", &pid);
      }
      if( pid > 0 && kill((pid_t)pid, 0) < 0 && errno == ESRCH ) {
        /* death lockfile - remove it */
        unlink(lck_file);
        sleep(1);
        pid = 0;
      } else
        pid = 1;
    }
    if( pid == 0 ) {
      mask = umask(022);
      fd = open(lck_file, O_WRONLY | O_CREAT | O_EXCL, 0666);
      umask(mask);
      if( fd >= 0 ) {
        /* chown(lck_file, (uid_t)real_uid, (gid_t)real_gid); */
        snprintf( buf, sizeof(buf), "%10ld\tRC-SOFT\n", (long)getpid() );
        write( fd, buf, strlen(buf) );
        close(fd);
      } else
        pid = 1;
    }
  }
  return pid;
}

static int
make_cflag(int * result, int speed, int data, int stop, char parity, int flow )
{
  int ret, cflag=0;

  switch ( speed )
  {
    case      150: cflag |=    B150; break;
    case      200: cflag |=    B200; break;
    case      300: cflag |=    B300; break;
    case      600: cflag |=    B600; break;
    case     1200: cflag |=   B1200; break;
    case     1800: cflag |=   B1800; break;
    case     2400: cflag |=   B2400; break;
    case     4800: cflag |=   B4800; break;
    case     9600: cflag |=   B9600; break;
    case    19200: cflag |=  B19200; break;
    case    38400: cflag |=  B38400; break;
    case    57600: cflag |=  B57600; break;
    case   115200: cflag |= B115200; break;
    case   230400: cflag |= B230400; break;
    case   460800: cflag |= B460800; break;
    case   500000: cflag |= B500000; break;
    case   576000: cflag |= B576000; break;
    case   921600: cflag |= B921600; break;
    default: ret=ERR_PARAM;
  }

  switch ( data )
  {
    case 5: cflag |= CS5; break;
    case 6: cflag |= CS6; break;
    case 7: cflag |= CS7; break;
    case 8: cflag |= CS8; break;
    default: ret=ERR_PARAM;
  }

  switch ( stop )
  {
    case 1: break;
    case 2: cflag |= CSTOPB; break;
    default: ret=ERR_PARAM;
  }

  switch ( parity )
  {
    case 'n':
    case 'N': break;
    case 'e':
    case 'E': cflag |= PARENB; break;
    case 'o':
    case 'O': cflag |= PARENB | PARODD; break;
    default: ret=ERR_PARAM;
  }

  if( flow | RS_F_RTS )
    cflag |= CRTSCTS;

  cflag |= CLOCAL | CREAD;

  *result = cflag;

return ret;
}

static int
make_iflag(int * result, int speed, int data, int stop, char parity, int flow )
{
  int ret=0, iflag=0;

  if( flow | RS_F_XON )
    iflag |= IXON;
  if( flow | RS_F_XOFF )
    iflag |= IXOFF;

  iflag |= IGNPAR | IGNBRK;

  *result = iflag;
  return ret;
}


int
ctcom_open( char *dev, int speed, int data, int stop, char parity, int flow )
{
  int fd, ret=0, cflag=0, iflag=0;
  struct com_param *com;

  ret = make_iflag(&iflag,speed,data,stop,parity,flow);
  ret = make_cflag(&cflag,speed,data,stop,parity,flow);

  if ( dev == NULL || strlen( dev ) == 0 )
    ret=ERR_PARAM;

  if ( ret == 0 ) {
    com = (struct com_param*) malloc(sizeof(*com));
    if ( com ) {
      com->dev = (char *) malloc( strlen(dev) );
      if ( com->dev )
        strcpy( com->dev, dev );
      else {
        free( com );
        ret = ERR_OUTMEM;
      }
    } else
      ret = ERR_OUTMEM;
  }

  if ( ret == 0 ) {
    ret = mk_lock( dev, LCK_DIR );
    if ( ret < 0 )
      ret = ERR_INIT;
    else if ( ret > 0 )
      ret = ERR_INUSE;

    if ( ret == 0 ) {
      fd = open( dev, O_RDWR | O_NOCTTY | O_NONBLOCK );
      if ( fd < 0 ) {
        ret = ERR_INIT;
        rm_lock( dev, LCK_DIR );
      }
    }

    if ( ret == 0 ) {
      com->fd = fd;
      com->next = com_list;
      com_list = com;

      tcgetattr(com->fd,&com->oldtio); /* save current port settings */

      memset( (void *) &com->newtio, 0, sizeof(com->newtio) );
      com->newtio.c_cflag = cflag;
      com->newtio.c_iflag = iflag;
      com->newtio.c_oflag = 0;
      com->newtio.c_lflag = 0;       /* set input mode (non-canonical, no echo,...) */

      com->newtio.c_cc[VTIME] = 1;   /* inter-character timer unused */
      com->newtio.c_cc[VMIN]  = 0;   /* read when unless one char received */

      tcflush(com->fd, TCIOFLUSH);
      tcsetattr(com->fd, TCSANOW, &com->newtio);

      ret = fd;
    } else {
      free( com->dev );
      free( com );
    }
  }
  return ret;
}


int
ctcom_read( int fd, char *buf, int n, int decsec )
{
  struct timeval tv;
  fd_set rfds;
  int retval;

  FD_ZERO(&rfds);
  FD_SET(fd,&rfds);

  tv.tv_sec = (decsec / 10);
  tv.tv_usec = (decsec % 10) * 100000;

  if( decsec < 0 || ( retval = select(fd+1, &rfds, NULL, NULL, &tv) ) > 0 ) {
    retval = read(fd, buf, n);
    if( ( retval == 0 && decsec >= 0 ) || ( retval == -1 && errno == EPIPE ) )
      retval = ERR_PIPE;
  }
  return retval;
}

int
ctcom_write( int fd, char *buf, int n, int decsec )
{
  struct timeval tv;
  fd_set wfds;
  int retval;

  FD_ZERO(&wfds);
  FD_SET(fd,&wfds);

  tv.tv_sec = (decsec / 10);
  tv.tv_usec = (decsec % 10) * 100000;

  if ( decsec < 0 || ( retval = select(fd+1, NULL, &wfds, NULL, &tv) ) > 0 ) {
    retval = write(fd, buf, n);
    if( retval == -1 && errno == EPIPE )
      retval = ERR_PIPE;
  }
  return retval;
}

int ctcom_ready( int fd )
{
  struct timeval tv;
  fd_set rfds;

  FD_ZERO(&rfds);
  FD_SET(fd,&rfds);

  tv.tv_sec = 0;
  tv.tv_usec = 0;

  if( select(fd+1, &rfds, NULL, NULL, &tv) > 0 )
    return 1;

  return 0;
}

int
ctcom_reinit( int fd )
{
  struct com_param *com;
  int retval = ERR_PARAM;

  if( (com = find_com( fd )) ) {
    tcflush( com->fd, TCIOFLUSH );
    tcsetattr( com->fd, TCSANOW, &com->newtio );
    retval = 0;
  }
  return retval;
}

int
ctcom_init( int fd, int speed, int data, int stop, char parity, int flow  )
{
  int ret=0, cflag=0, iflag=0;
  struct com_param *com;
  int retval = ERR_PARAM;

  ret = make_iflag(&iflag,speed,data,stop,parity,flow);
  ret = make_cflag(&cflag,speed,data,stop,parity,flow);

  if ( ret != 0 )
  	return retval;

  if( (com = find_com( fd )) ) {
    tcflush( com->fd, TCIOFLUSH );
    com->newtio.c_cflag = cflag;
    com->newtio.c_iflag = iflag;
    tcsetattr( com->fd, TCSANOW, &com->newtio );
    retval = 0;
  }
  return retval;
}

int
ctcom_close( int fd )
{
  struct com_param **pcom, *com;
  int retval = ERR_PARAM;

  pcom=&com_list;
  while( *pcom != NULL && (*pcom)->fd != fd )
    pcom = &(*pcom)->next;

  if( *pcom != NULL ) {
    com = *pcom;
    tcsetattr( com->fd, TCSANOW, &com->oldtio );
    tcflush( com->fd, TCIOFLUSH );
    if ( com->dev ) {
      rm_lock( com->dev, LCK_DIR );
      free( com->dev );
    }
    close( com->fd );
    *pcom = com->next;
    free( com );
    retval = 0;
  }
  return retval;
}

void
ctcom_closeall()
{
  while( com_list!=NULL && ctcom_close(com_list->fd)==0 );
}

int
ctcom_clrbuf( int fd, int decsec )
{
  struct com_param *com;
  int retval=ERR_PARAM;

  if( (com = find_com( fd )) )
    retval = tcflush(fd, TCIFLUSH);

  return retval;
}

int
ctcom_msr( int fd )
{
  struct com_param *com;
  int retval=ERR_PARAM, msr_bits;

  if( (com = find_com( fd )) ) {
    if( ioctl(fd, TIOCMGET, &msr_bits) == 0 ) {
      retval = 0;
      if( msr_bits & TIOCM_CTS ) retval |= MSR_CTS;
      if( msr_bits & TIOCM_DSR ) retval |= MSR_DSR;
      if( msr_bits & TIOCM_RI )  retval |= MSR_RI;
      if( msr_bits & TIOCM_CD )  retval |= MSR_DCD;
    }
  }
  return retval;
}

int
ctcom_cts( int fd )
{
  int retval;

  if( (retval = ctcom_msr( fd )) >= 0 )
    retval &= MSR_CTS;
  return retval;
}

int
ctcom_dsr( int fd )
{
  int retval;

  if( (retval = ctcom_msr( fd )) >= 0 )
    retval &= MSR_DSR;
  return retval;
}

int
ctcom_ring( int fd )
{
  int retval;

  if( (retval = ctcom_msr( fd )) >= 0 )
    retval &= MSR_RI;
  return retval;
}

int
ctcom_dcd( int fd )
{
  int retval;

  if( (retval = ctcom_msr( fd )) >= 0 )
    retval &= MSR_DCD;
  return retval;
}

int
ctcom_mcr( int fd, int mcr )
{
  struct com_param *com;
  int retval=ERR_PARAM, bits;

  if( (com = find_com( fd )) ) {
    if( ioctl(fd, TIOCMGET, &bits) == 0 ) {
      if( mcr >= 0 ) {
        bits &= ~(TIOCM_DTR|TIOCM_RTS);
        if( mcr & MCR_DTR  ) bits |= TIOCM_DTR;
        if( mcr & MCR_RTS  ) bits |= TIOCM_RTS;
     /* if( mcr & MCR_OUT1 ) bits |= TIOCM_ST;
        if( mcr & MCR_OUT2 ) bits |= TIOCM_SR;
        if( mcr & MCR_LOOP ) bits |= TIOCM_LE; */
        ioctl(fd, TIOCMSET, bits);
      }
      retval = 0;
      if( bits & TIOCM_DTR ) retval |= MCR_DTR;
      if( bits & TIOCM_RTS ) retval |= MCR_RTS;
    }
  }
  return retval;
}

int
ctcom_rts( int fd, int set )
{
  int retval;

  if( (retval = ctcom_mcr( fd, -1 )) >= 0 ) {
    if( set && (retval & MCR_RTS) == 0 ) {
      retval |= MCR_RTS;
      retval = ctcom_mcr( fd, retval );
    }
  }
  return retval;
}

int
ctcom_dtr( int fd, int set )
{
  int retval;

  if( (retval = ctcom_mcr( fd, -1 )) >= 0 ) {
    if( set && (retval & MCR_DTR) == 0 ) {
      retval |= MCR_DTR;
      retval = ctcom_mcr( fd, retval );
    }
  }
  return retval;
}

