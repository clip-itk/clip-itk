/*
    Copyright (C) 2001  ITK
    Author  : Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
//При использовании Blinker.

#include 'common.ch'
#include 'bdbfmsg.ch'
**********
FUNC BLERRC50

? _CRLF,'BLINKER ERROR', BliErrNum()
**********
PROC BLICALC50
IF Blicalnum() == 1 THEN Blerrc50()

**********
FUNC BLISERNUM
RETURN BDBF_VERSION
