/*
    Copyright (C) 2001  ITK
    Autor   : Uri (uri@itk.ru)
    Licence : (GPL) http://www.itk.ru/clipper/licence.html
*/
//procedure main
parameters fname
clear screen
set translate off
if fname == NIL
  ? 'Usage: clip_bl <file.bl>'
else
  set date to british
  set century on
  set epoch to 1900
  progrun(progparse(memoread(fname)))
endif
quit

