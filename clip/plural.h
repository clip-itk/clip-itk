/* 
   $Log$
   Revision 1.1  2006/06/22 19:35:17  itk
   uri: init sf.net repository

   Revision 1.2  2002/10/31 10:33:59  clip
   plural form runtime messages support:
   gettext(cMsgid [,cModule])->cTranslated
   ngettext(cMsgid, cMsgid_plural, nNum, [,cModule]) ->cTranslated
   paul

 Revision 1.1  2002/10/30 12:17:26  clip
 support for plural forms in i18n messages
 paul
*/
#ifndef PLURAL_H
#define PLURAL_H

typedef struct PluralData PluralData;

PluralData *plural_new(char *expr, int elen);
void plural_delete(PluralData *plural);

int plural_eval(PluralData *plural, unsigned long int n);

#endif
