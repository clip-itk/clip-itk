
/*
   $Log: testscr.c,v $
   Revision 1.8  2004/10/20 17:22:17  clip
   uri: add set(_SET_UTF8TERM) for terminal with UTF-8

   Revision 1.7  2001/11/26 15:39:50  clip
   Linux console GPM mouse handling
   paul

   Revision 1.6  2000/12/02 13:47:40  clip
   CLIPROOT now may be envar
   paul

   Revision 1.5  2000/12/02 12:46:57  clip
   scancodes
   paul

   Revision 1.4  2000/11/30 15:09:48  clip
   checks
   paul

   Revision 1.3  2000/04/28 17:55:44  clip

   bsd fixes

   Revision 1.2  1999/11/02 23:05:59  axl
   start of logging CVS

 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include "screen.h"

char *CLIPROOT=".";
extern char **environ;
int i;

int
_clip_logg()
{
	return 0;
}

int
task_select_if(int fd, void *p1, void *p2, void *p3, void *p4)
{
	return select(fd, p1, p2, p3, p4);
}

static const char *
colorname(int i)
{
	switch (i)
	{
	case COLOR_BLACK:
		return "BLACK     ";
	case COLOR_BLUE:
		return "BLUE      ";
	case COLOR_GREEN:
		return "GREEN     ";
	case COLOR_CYAN:
		return "CYAN      ";
	case COLOR_RED:
		return "RED       ";
	case COLOR_MAGENTA:
		return "MAGENTA   ";
	case COLOR_YELLOW:
		return "YELLOW    ";
	case COLOR_WHITE:
		return "WHITE     ";
	case COLOR_HI_BLACK:
		return "HI_BLACK  ";
	case COLOR_HI_BLUE:
		return "HI_BLUE   ";
	case COLOR_HI_GREEN:
		return "HI_GREEN  ";
	case COLOR_HI_CYAN:
		return "HI_CYAN   ";
	case COLOR_HI_RED:
		return "HI_RED    ";
	case COLOR_HI_MAGENTA:
		return "HI_MAGENTA";
	case COLOR_HI_YELLOW:
		return "HI_YELLOW ";
	case COLOR_HI_WHITE:
		return "HI_WHITE  ";
	}
	return "";
}

int
main()
{
	ScreenBase base;
	Screen *scr;
	unsigned long key;
	char errbuf[64];
	char buf[128];
	int r, l;

	if ((r = init_tty(&base, 0, environ, 0, NULL, errbuf, sizeof(errbuf))))
	{
		write(2, errbuf, strlen(errbuf));
		write(2, "\n", 1);
		return 1;
	}

	scr = new_Screen(&base);
	clear_Screen(scr);

	for (i = 0; i < 16; i++)
	{
		sprintf(buf, "fg color %d (%s)", i, colorname(i));
		l = strlen(buf);
		memcpy(scr->chars[i] + 10, buf, l);
		memset(scr->colors[i] + 10, i | COLOR_BACK_BLACK, l);
		scr->touched[i] = 1;
	}
	for (i = 0; i < 8; i++)
	{
		sprintf(buf, "bg color %d (%s)", i, colorname(i));
		l = strlen(buf);
		memcpy(scr->chars[i + 16] + 10, buf, l);
		memset(scr->colors[i + 16] + 10, COLOR_HI_WHITE | (i << 4), l);
		scr->touched[i + 16] = 1;
	}
	sync_Screen(scr,0);
	write(1, "asdf", 4);
	key = get_Key(&base);

	redraw_Screen(scr,0);
	sprintf(scr->chars[0], "%lx", key);
	scr->touched[0] = 1;
	beep_Screen(scr);
	sync_Screen(scr,0);

	key = get_Key(&base);

	sprintf(scr->chars[0], "%lx", key);
	scr->touched[0] = 1;
	beep_Screen(scr);
	sync_Screen(scr,0);

	key = get_Key(&base);

	sprintf(scr->chars[0], "%lx; press any key...", key);
	scr->touched[0] = 1;
	beep_Screen(scr);
	sync_Screen(scr,0);
	key = get_Key(&base);

	destroy_tty(&base);

	return 0;
}
