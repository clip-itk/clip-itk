/*
    Copyright (C) 2005  ITK
    Author  : Elena V. Kornilova <alena@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include <string.h>
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <gtk/gtk.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"

int
clip_GTK_RCPARSESTRING(ClipMachine * cm)
{
        const gchar *str = _clip_parc(cm, 1);

        CHECKARG(1, CHARACTER_t);

	gtk_rc_parse_string(str);

	return 0;
err:
	return 1;
}


