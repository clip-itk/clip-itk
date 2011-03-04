#include <inkey.ch>

set color to "g+/b"
clear screen
/*clear screen

@ 1,1 to 10,20
@ 4,4 to 20,60 double

? getenv("TERM")
? getenv("CLIP_SCANMODE")
? getenv("CLIP_KEYMAP")

*/

? [asdf"rqew], [&F"ile], [3a23], [3a23]
//? search("[Æa]Ù×Á", "asdfÆÙ×Áasdf" ) // utf-8: search("[Ñ„a]Ñ‹Ð²Ð°", "asdfÑ„Ñ‹Ð²Ð°asdf" )

while .t.
	key:=inkey(0, INKEY_ALL)
	flags:=kbdstat()
	//? key, flags //, chr(key)
        @ 5,5 say '               '
        @ 6,5 say '               '
        @ 5,5 say key
        @ 6,5 say flags
	if  chr(key)=="q"
		quit
	endif
//	if key==1
//		quit
//	endif
end

