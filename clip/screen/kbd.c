
/*
   $Log: kbd.c,v $
   Revision 1.6  2004/07/08 07:21:05  clip
   uri: small fix for kbdstat()

   Revision 1.5  2001/10/29 06:51:21  clip
   fix text fopen modes
   paul

   Revision 1.4  2001/05/30 10:19:43  clip
   VT switch in scan mode on console
   paul

   Revision 1.3  2000/12/02 13:47:40  clip
   CLIPROOT now may be envar
   paul

   Revision 1.2  2000/12/02 12:46:57  clip
   scancodes
   paul

   Revision 1.1  2000/11/30 14:57:15  clip
   scancode support
   paul

 */

#include <stdio.h>
#include <signal.h>
#include <termios.h>
#include <stdlib.h>
#include <unistd.h>

#include "scankey.h"

char *CLIPROOT=".";
static struct termios ts, ts0;
int scr_scan_mode = 0;

static void
exit_f(void)
{
/* restore normal mode */
	printf("\033[R");
	fflush(stdout);
	tcsetattr(0, TCSANOW, &ts0);
}

static void
sig_f(int sig)
{
	exit(sig);
}

int
main(int argc, char **argv)
{
	int i;
	char errbuf[128];
	FILE *file;


	if (argc<2)
	{
		printf("usage: %s keymap\n", argv[0]);
		return 1;
	}

	file = fopen(argv[1], "rt");
	if (!file)
	{
		printf("cannot open file %s\n", argv[1]);
		return 2;
	}


	if (load_keymap(file, errbuf, sizeof(errbuf)))
	{
		printf("load_keymap error: %s\n", errbuf);
		exit(1);
	}
	fclose(file);

	tcgetattr(0, &ts);
	ts0 = ts;
	cfmakeraw(&ts);
	tcsetattr(0, TCSANOW, &ts);

	atexit(exit_f);
	signal(SIGINT, sig_f);
	signal(SIGTERM, sig_f);
	signal(SIGHUP, sig_f);

/* switch into scanmode */
	printf("\033[S");

	printf("\r\n");

	for (i = 0; i < 100; i++)
	{
		unsigned char b;
		long key;
		int state;

		state = scan_state();
		printf("\r\nstate: %d\r\n", state );

		if (!read(0, &b, 1))
			break;

		/*printf("read: %x\r\n", (int)b); */

		key = scan_key(b);
		if (key)
		{
			state = scan_state();
			printf("scan_key: %ld (%c), state=%d\r\n", key, (int) ((key > 32 && key < 256) ? key : 32), state);
			if (key == 'q')
				exit(0);
		}
	}

	return 0;
}
