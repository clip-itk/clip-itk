/*
    Copyright (C) 2001  ITK
    Autor   : Uri (uri@itk.ru)
    Licence : (GPL) http://www.itk.ru/clipper/licence.html
*/
parameters url

 set translate off
 if url == NIL
 	text

  	html viewer program

 	usage: clip_hv <url>

        endtext

	return
 endif

 hbrowse(,,,, url)

