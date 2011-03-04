//FUNCTION MAIN
clear screen
n1 = WOPEN (1,1,14,58)
@ 0,0,10,10 box '111111111'
@ 2,2 SAY "window1 "+str(wselect())
    INKEY(0)
    n2 = WOPEN (2,2,16,50)
@ 0,0,10,10 box '222222222'
@ 2,2 SAY "window2 "+str(wselect())
    INKEY(0)
	n3 = WOPEN (3,3,17,52)
@ 0,0,10,10 box '333333333'
@ 2,2 SAY "window3 "+str(wselect())
	    INKEY(0)
	    n4 = WOPEN (4,4,18,54)
@ 0,0,10,10 box '444444444'
@ 2,2 SAY "window4 "+str(wselect())
	    INKEY(0)
	    n5 = WOPEN (5,5,19,58)
@ 0,0,10,10 box '555555555'
@ 2,2 SAY "window5 "+str(wselect())
	    INKEY(0)
	    WSELECT(0)
@  0,0 SAY "window0 "+str(wselect())
@ 12,0 SAY "after WSELECT(0) screen is not refreshed, but string will be corrupted later"
@ 22,0 SAY "i mean the window N 0 is not rewrited to screen"
	    INKEY(0)
	    WSELECT(n5)
@ 3,2 SAY "window5 is restored by WSELECT()"+str(wselect())
	    INKEY(0)
clear screen
	    INKEY(0)
@ 3,2 SAY "is writed to window5 after clear screen"+str(wselect())
	    INKEY(0)
	    WCLOSE()
@ 3,2 SAY "window4 is restored by WSELECT()"+str(wselect())
	INKEY(0)
	WCLOSE()
@ 3,2 SAY "window3 is restored by WSELECT()"+str(wselect())
    INKEY(0)
    WCLOSE()
@ 3,2 SAY "window2 is restored by WSELECT()"+str(wselect())
INKEY(0)
WCLOSE()
@ 3,2 SAY "window1 is restored by WSELECT()"+str(wselect())
INKEY(0)
WCLOSE()
@ 24,0 SAY "window N 0 is not the same like after SAY to WSELECT(0)"+str(wselect())
INKEY(0)
