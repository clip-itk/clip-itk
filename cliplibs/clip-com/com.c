/*
   Copyright (C) 2001  ITK
   Authors  : Paul Lasarev <paul@itk.ru>
   License : (GPL) http://www.itk.ru/clipper/license.html
 */

/*
  $Log: com.c,v $
  Revision 1.3  2002/06/24 10:03:00  clip
  don't know what

  Revision 1.2  2002/02/07 12:34:02  clip
  open mode fix
  paul

  Revision 1.1  2002/02/07 11:44:27  clip
  initial
  paul

 */

#include <errno.h>
#include <limits.h>
#include <ctype.h>

#include "hashcode.h"
#include "clip.h"
#include "error.ch"

#include "libezV24/ezV24.h"

static void
destroy_com_port(void *port)
{
	if (port)
		v24ClosePort((v24_port_t *) port);
}

static int keys[32];

int
clip_COM_NUM(ClipMachine * mp)
{
	unsigned long bitmask = 0;
	int r;

	r = v24CountPorts(&bitmask);

	if (r < 0)
		return _clip_trap_err(mp, EG_UNSUPPORTED, 0, 0, __FILE__, __LINE__, "COM_NUM");

	_clip_retni(mp, r + 1);

	return 0;
}

/*
COM_OPEN(nPort|cDevice,[dontused],[dontused],[dontused],l_RTSCTS,l_XONXOFF,lDebug)
*/
int
clip_COM_OPEN(ClipMachine * mp)
{
	int no = _clip_parni(mp, 1);
	char *dev = _clip_parc(mp, 1);
	char buf[V24_SZ_PORTNAME];
	int ctsrts = _clip_parl(mp, 5);
	int xonxoff = _clip_parl(mp, 6);
	int dbg = _clip_parl(mp, 7);
	v24_port_t *gz;
	int *err, k;

	if (!_clip_parinfo(mp, 5) && !!_clip_parinfo(mp, 5))
		ctsrts = 1;

	if (!dev && (no < 1 || no > 32))
		return EG_ARG;

	if (!dev)
	{
		v24PortName(no - 1, buf);
		dev = buf;
	}

	gz = v24OpenPort(dev,
			 V24_STANDARD
			 | V24_LOCK
			 /*| V24_NO_DELAY*/
			 | (ctsrts ? V24_RTS_CTS : 0)
			 | (xonxoff ? V24_XON_XOFF : 0)
			 | V24_DROP_DTR
			 | (dbg ? V24_DEBUG_ON : 0)
			 );

	if (!gz)
	{
		err = _clip_fetch_item(mp, HASH_ferror);
		*err = errno;
		_clip_retl(mp, 0);
		return 0;
	}

	k = _clip_store_c_item(mp, gz, _C_ITEM_TYPE_FILE, destroy_com_port);

	keys[no] = k;

	_clip_retl(mp, 1);

	return 0;
}

int
clip_COM_CLOSE(ClipMachine * mp)
{
	v24_port_t *gz;
	int fd = _clip_parni(mp, 1);
	int ret = -1, *err = _clip_fetch_item(mp, HASH_ferror);

	if (fd < 1 || fd > 32)
		return EG_ARG;
	fd = keys[fd];

	gz = (v24_port_t *) _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	if (gz == NULL)
		return EG_ARG;
	else if (_clip_destroy_c_item(mp, fd, _C_ITEM_TYPE_FILE))
	{
		ret = 0;
		*err = 0;
	}

	_clip_retl(mp, (ret == 0));
	return 0;
}

static int
baud_val(int baud)
{
	switch (baud)
	{
	default:
		return V24_B9600;
	case 0:
		return V24_B0;
	case 50:
		return V24_B50;
	case 75:
		return V24_B75;
	case 110:
		return V24_B110;
	case 134:
		return V24_B134;
	case 150:
		return V24_B150;
	case 200:
		return V24_B200;
	case 300:
		return V24_B300;
	case 600:
		return V24_B600;
	case 1200:
		return V24_B1200;
	case 1800:
		return V24_B1800;
	case 2400:
		return V24_B2400;
	case 4800:
		return V24_B4800;
	case 9600:
		return V24_B9600;
	case 19200:
		return V24_B19200;
	case 38400:
		return V24_B38400;
	case 57600:
		return V24_B57600;
	case 115200:
		return V24_B115200;
	}
}

static int
data_val(int data)
{
	switch (data)
	{
	case 5:
		return V24_5BIT;
	case 6:
		return V24_6BIT;
	case 7:
		return V24_7BIT;
	default:
	case 8:
		return V24_8BIT;
	}
}

static int
parity_val(char *p)
{
	if (!p || !*p)
		return V24_NONE;

	switch (toupper(p[0]))
	{
	case 'N':
	default:
		return V24_NONE;
	case 'E':
		return V24_EVEN;
	case 'O':
		return V24_ODD;
	case 'I':
		return V24_IGNORE;
	}

}

/*
       COM_INIT(<nComPort>,[<nBaudRate>],[<cParity>],
                 [<nDataLength>],[<nStopBits>]) --> lInitialized
*/

int
clip_COM_INIT(ClipMachine * mp)
{
	v24_port_t *gz;
	int ret = -1, *err;
	int fd = _clip_parni(mp, 1);
	int baud = 9600, data = 8, stop = 1;
	char *parity = "N";

	if (fd < 1 || fd > 32)
		return EG_ARG;
	fd = keys[fd];

	gz = (v24_port_t *) _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	if (!gz)
		return EG_ARG;

	if (_clip_parinfo(mp, 2) == NUMERIC_t)
		baud = _clip_parni(mp, 2);
	if (_clip_parinfo(mp, 3) == CHARACTER_t)
		parity = _clip_parc(mp, 3);
	if (_clip_parinfo(mp, 4) == NUMERIC_t)
		data = _clip_parni(mp, 4);
	if (_clip_parinfo(mp, 5) == NUMERIC_t)
		stop = _clip_parni(mp, 5);

	err = _clip_fetch_item(mp, HASH_ferror);

	ret = v24SetParameters(gz, baud_val(baud), data_val(data), parity_val(parity));

	_clip_retl(mp, ret ? 0 : 1);

	return 0;
}

/*
       COM_TIMEOUT(<nComPort>,[<nTimeout]) --> nOldTimeout
       nTimeout in 1/10 sec
*/
int
clip_COM_TIMEOUT(ClipMachine * mp)
{
	v24_port_t *gz;
	int fd = _clip_parni(mp, 1);
	int to = _clip_parni(mp, 2);
	int oto;

	if (fd < 1 || fd > 32)
		return EG_ARG;
	fd = keys[fd];

	gz = (v24_port_t *) _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	if (gz == NULL)
	{
		return EG_ARG;
	}

	oto = gz->TimeoutValue;

	if (mp->argc > 1)
	{
		v24SetTimeouts(gz, to);
	}

	_clip_retni(mp, oto);
	return 0;
}

/*
	COM_SEND(<nComPort>,<cString>) --> nLength

	return length of UNSENDED data
*/
int
clip_COM_SEND(ClipMachine * mp)
{
	v24_port_t *gz;
	int len = 0, *err = NULL;
	int fd = _clip_parni(mp, 1);
	char *sptr = NULL, buf[2], *str = _clip_parcl(mp, 2, &len);
	long ret = -1;

	if (fd < 1 || fd > 32)
		return EG_ARG;
	fd = keys[fd];

	gz = (v24_port_t *) _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	if (_clip_parinfo(mp,2)== NUMERIC_t)
        {
        	buf[0] = (char) _clip_parni(mp,2);
                buf[1] = 0;
                len = 1 ;
                sptr = buf;
        }
        else
        	sptr = str;

	if (gz == NULL || !sptr)
	{
		return EG_ARG;
	}

	ret = v24Write(gz, sptr, len);
	err = _clip_fetch_item(mp, HASH_ferror);
	*err = ret < 0 ? errno : 0;

	_clip_retni(mp, (len - ret));

	return 0;
}

int
clip_COM_READ(ClipMachine * mp)
{
	v24_port_t *gz;
	char *buf;
	int *err = NULL, fd, nb = 0;
	long ret = -1;

	fd = _clip_parni(mp, 1);
	nb = _clip_parni(mp, 2);

	if (fd < 1 || fd > 32)
		return EG_ARG;
	fd = keys[fd];

	gz = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	if (gz == NULL)
		return EG_ARG;

	if (!nb)
		nb = 1024;

	buf = (char *) malloc(nb);

	ret = v24Read(gz, buf, nb);
	if (ret < 0)
	{
		err = _clip_fetch_item(mp, HASH_ferror);
		*err = errno;
		ret = 0;
		if (gz->Errno != V24_E_OK)
		{
			free(buf);
			return EG_READ;
		}
	}

	buf = (char *) realloc(buf, ret + 1);
	buf[ret] = 0;
	_clip_retcn_m(mp, buf, ret);

	return 0;
}

/*
	COM_FLUSH(<nComPort>) --> lClear
*/
int
clip_COM_FLUSH(ClipMachine * mp)
{
	v24_port_t *gz;
	int fd = _clip_parni(mp, 1);

	if (fd < 1 || fd > 32)
		return EG_ARG;
	fd = keys[fd];

	gz = (v24_port_t *) _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);
	if (!gz)
		return (EG_ARG);

	_clip_retl(mp, v24FlushRxQueue(gz) ? 0 : 1);

	return 0;
}

/*
       COM_SFLUSH(<nComPort>) --> lDeleted
*/
int
clip_COM_SFLUSH(ClipMachine * mp)
{
	v24_port_t *gz;
	int fd = _clip_parni(mp, 1);

	if (fd < 1 || fd > 32)
		return EG_ARG;
	fd = keys[fd];

	gz = (v24_port_t *) _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);
	if (!gz)
		return (EG_ARG);

	_clip_retl(mp, v24FlushTxQueue(gz) ? 0 : 1);

	return 0;
}

/*
       COM_SOFT(<nComPort>,[<lNewHandshake>],[<cXONchar>],
                 [<cXOFFchar>]) --> lOldHandshake
*/
int
clip_COM_SOFT(ClipMachine * mp)
{
	v24_port_t *gz;
	int fd = _clip_parni(mp, 1);
	int flag = _clip_parl(mp, 2);
	int oflag;

	if (fd < 1 || fd > 32)
		return EG_ARG;
	fd = keys[fd];

	gz = (v24_port_t *) _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);
	if (!gz)
		return (EG_ARG);

	oflag = gz->OpenFlags & V24_XON_XOFF;

	if (mp->argc > 1)
	{
		if (flag)
			gz->OpenFlags |= V24_XON_XOFF;
		else
			gz->OpenFlags &= ~V24_XON_XOFF;

		v24SetParameters(gz, gz->Baudrate, gz->Datasize, gz->Parity);
	}

	_clip_retl(mp, oflag ? 1 : 0);

	return 0;
}

/*
       COM_HARD(<nComPort>,<lNewHandshake>,[<lDTR/DSR>])
                 --> lOldHandshake
*/
int
clip_COM_HARD(ClipMachine * mp)
{
	v24_port_t *gz;
	int fd = _clip_parni(mp, 1);
	int flag = _clip_parl(mp, 2);
	int oflag;

	if (fd < 1 || fd > 32)
		return EG_ARG;
	fd = keys[fd];

	gz = (v24_port_t *) _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);
	if (!gz)
		return (EG_ARG);

	oflag = gz->OpenFlags & V24_RTS_CTS;

	if (mp->argc > 1)
	{
		if (flag)
			gz->OpenFlags |= V24_RTS_CTS;
		else
			gz->OpenFlags &= ~V24_RTS_CTS;

		v24SetParameters(gz, gz->Baudrate, gz->Datasize, gz->Parity);
	}

	_clip_retl(mp, oflag ? 1 : 0);

	return 0;
}

/*
       COM_DTR(<nComPort>,[<lNewDTRStatus>]) --> lOldDTRStatus
       note - really returns success code
*/
int
clip_COM_DTR(ClipMachine * mp)
{
	v24_port_t *gz;
	int fd = _clip_parni(mp, 1);
	int flag = _clip_parl(mp, 2);
	int oflag;

	if (fd < 1 || fd > 32)
		return EG_ARG;
	fd = keys[fd];
	gz = (v24_port_t *) _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);
	if (!gz)
		return (EG_ARG);

	oflag = 0;

	if (mp->argc > 1)
	{
		oflag = v24SetDTR(gz, flag);
	}

	_clip_retl(mp, oflag ? 0 : 1);

	return 0;
}

/*
       COM_COUNT(<nComPort>) --> nTotalCharacters
*/
int
clip_COM_COUNT(ClipMachine * mp)
{
	v24_port_t *gz;
	int fd = _clip_parni(mp, 1);
	int n;

	if (fd < 1 || fd > 32)
		return EG_ARG;
	fd = keys[fd];
	gz = (v24_port_t *) _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);
	if (!gz)
		return (EG_ARG);

	n = v24HaveData(gz);

	_clip_retni(mp, n);

	return 0;
}
