#ifdef __CLIP__
#include "llibg.ch"
****
function mouseStat()
local ms:=mstate()
return ms[LLM_STATE_CLICKS_LEFT] + ms[LLM_STATE_CLICKS_RIGHT]*2
****
function isShift()
return (numand(kbdstat(),0x03)!=0)
****
function chdisk(cDisk)
local i,ret:=0
for i=asc("C") to asc("Z")
	if !empty(set(chr(i)+":"))
		ret++
	endif
next
diskchange(cDisk)
return ret
****
function ft_putkey(nKey)
__keyboard(nKey, .t.)
return .t.
****
function ALTF()
local ret:=0,ks:=kbdstat()
if numand(ks,0x8)!=0
	ret:=1
elseif numand(ks,0x4)!=0
	ret:=2
elseif numand(ks,0x3)!=0
	ret:=3
endif
return ret
****
func name_disk()
local s,ret:=""
s:=set(_SET_DEFAULT)
ret:=if( substr(s,2,1)==":", LEFT(s,1,2), currDrive() )
return asc(upper(ret))
*****
func sx_setpass()
return ""
*********************************
function __getBadDate(obj)
return obj:badDate()
*********************************
function __getundo(obj)
return 	obj:undo()
*********************************
#endif

