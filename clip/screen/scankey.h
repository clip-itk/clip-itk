/*
  $Log: scankey.h,v $
  Revision 1.6  2004/12/15 07:05:37  clip
  uri: add KSET*()

  Revision 1.5  2002/05/28 06:48:27  clip
  scankey tricks
  paul

  Revision 1.4  2002/05/27 14:10:59  clip
  scankey fix
  paul

  Revision 1.3  2002/03/15 11:49:42  clip
  fix for Numlock key scancode in win >= 2k
  paul

  Revision 1.2  2000/12/02 12:46:57  clip
  scancodes
  paul

  Revision 1.1  2000/11/30 14:57:15  clip
  scancode support
  paul

*/

#ifndef SCANKEY_H
#define SCANKEY_H
#include <stdio.h>

long scan_key(unsigned char scancode);
int scan_push(unsigned char scancode);
long scan_check(void);
unsigned int scan_state(void);
unsigned int set_scan_state(int value, int locktype);
extern int scan_numlock_state;
void scan_reset(void);

/* state bits */
#define SCAN_SHIFT	0
#define SCAN_CTRL	2
#define SCAN_ALT	3
#define SCAN_ALTGR	1
#define SCAN_SHIFTL	4
#define SCAN_SHIFTR	5
#define SCAN_CTRLL	6
#define SCAN_CTRLR	7
#define SCAN_CAPSSHIFT	8

#define SCAN_SLOCK	9
#define SCAN_NUMLOCK	10
#define SCAN_CAPSLOCK	11
#define SCAN_INSERT	12

/* from keymap.c */
int load_keymap(FILE *file, char *errbuf, int errbuflen);

#endif
