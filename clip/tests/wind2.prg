//FUNCTION MAIN
clear screen
n1 = WOPEN (1,1,14,68)
@ 1,1,10,10 box '1-1-1-1-1'
@ 2,2 SAY "window1 "+str(wselect())
    INKEY(0)
    n2 = WOPEN (2,2,16,70)
@ 1,1,10,10 box '2-2-2-2-2'
@ 2,2 SAY "window2 "+str(wselect())
    INKEY(0)
	n3 = WOPEN (3,3,18,72)
@ 1,1,10,10 box '3-3-3-3-3'
@ 2,2 SAY "window3 "+str(wselect())
	    INKEY(0)
	    n4 = WOPEN (4,4,20,74)
@ 1,1,10,10 box '4-4-4-4-4'
@ 2,2 SAY "window4 "+str(wselect())
	    INKEY(0)
	    n5 = WOPEN (5,5,22,78)
@ 1,1,10,10 box '5-5-5-5-5'
@ 2,2 SAY "window5 "+str(wselect())
	    INKEY(0)
	    WSELECT(0)
@ 22,2 SAY "window6 "+str(wselect())
	    INKEY(0)
//set color to "W+/b"
//clear screen
//	    INKEY(0)
	    WSELECT(n5)
@ 3,2 SAY "close5"+str(wselect())
	    INKEY(0)
	    WCLOSE()
@ 12,2 SAY "window7"+str(wselect())
	INKEY(0)
	WCLOSE()
@ 12,2 SAY "window8"+str(wselect())
    INKEY(0)
    WCLOSE()
@ 12,2 SAY "window9"+str(wselect())
INKEY(0)
WCLOSE()
