/*
    Copyright (C) 2001  ITK
    Autor   : Uri (uri@itk.ru)
    Licence : (GPL) http://www.itk.ru/clipper/licence.html
*/
procedure main
parameters fname
clear screen
set translate off
if fname==nil
  ? 'Usage: clip_blank <file.bla>'
else
  set date to british
  set century on
  run_blank(fname,.t.)
endif
quit

