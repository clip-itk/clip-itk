/*
	Copyright (C) 2004 Igor Satsyuk <satsyuk@tut.by>
	Author	: Igor Satsyuk <satsyuk@tut.by>
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

#include <stdio.h>
#include <tcpd.h>

#define BUFSIZE 8192

#define ACCESS_DENIED  0
#define ACCESS_GRANTED 1

int allow_severity, deny_severity;

/*---------------------------------------------------
 *  example: tcp-wrap cobra-serv 192.168.170.1  -> 0 - OK | 1 - Error
 * --------------------------------------------------*/
main(int argc, char *argv[])
{
    int retval = ACCESS_DENIED;
    char *daemon, *ipaddr;
    char buf[BUFSIZE];

	/* make standard output line buffered */
	setvbuf(stdout, NULL, _IOLBF, 0);
	while (fgets(buf, BUFSIZE, stdin))
	{
		daemon = buf;
		ipaddr = strchr(buf, '\n');
		if (!ipaddr)
		{
	                fprintf(stderr, "Unexpected input '%s'\n", buf);
			fprintf(stdout, "ERR\n");
			continue;
		}
		*ipaddr = '\0';
		ipaddr = strchr(buf, ' ');
		if (!ipaddr)
		{
        		fprintf(stderr, "Unexpected input '%s'\n", buf);
			fprintf(stdout, "ERR\n");
			continue;
		}
		*ipaddr++ = '\0';

		retval = hosts_ctl(daemon, STRING_UNKNOWN, ipaddr, STRING_UNKNOWN);
		if (retval)
		{
			fprintf(stdout, "OK\n");
		}
		else
		{
			fprintf(stdout, "ERR\n");
		}
	}

    return (retval == ACCESS_GRANTED ? 0 : 1);
}
