/*
	$Log: po_util.h,v $
	Revision 1.3  2002/11/04 10:21:57  clip
	po compatability mode for old gettext utils
	paul
	
	Revision 1.2  2002/10/24 13:05:44  clip
	tdoc: add English GPL text
	paul
	
*/
#ifndef PO_UTIL_H
#define PO_UTIL_H

#include <stdio.h>

typedef struct PoEntry
{
	char *msg;
        char *translated;
	char *msg_plural;
        char **plural;
        int nplural;
	char *file;
	int line;
	struct PoEntry *next;

	int ncomments;
	char **comments;
}
PoEntry;

PoEntry *new_PoEntry(char *msg, char *file, int line, PoEntry * first);
void delete_PoEntry(void *entry);
int cmp_PoEntry(void *p1, void *p2);

int po_write_header(FILE * out);
int po_write_entry(FILE * out, PoEntry * entry, int dupflag);
PoEntry *po_read_entry(FILE * in);

int po_write_entry_compat(FILE * out, PoEntry * entry, int dupflag);
PoEntry *po_read_entry_compat(FILE * in);

int po_parse_template(FILE * in, char *filename, char *start, char *stop,
		      void *par,
		      int (*entry_handler) (void *par, char *filename, int line, char *txt),
		      int (*norm_handler) (void *par, char *txt, int len));

#endif
