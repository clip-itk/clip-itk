#ifdef __CLIP__
#include "llibg.ch"
****
function mouseStat()
local ms:=mstate()
*return ms[LLM_STATE_LEFT] + ms[LLM_STATE_RIGHT]*2
return 0
****
function is_clipbrd()
return .f.
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
function chDir(cPath)
return  DirChange(cPath)
****
function ft_putkey(nKey)
	__keyboard(nKey)
return .t.
****
function timeslice()
return
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
        if substr(s,2,1)==":"
              	ret := substr(s,1,2)
        else
               	ret := currDrive()
        endif
return asc(upper(ret))
*****
func sx_setpass()
return ""
*****
func ntxpos(arg1,arg2)
return	ordkeyno(arg1)
*****
func ft_onidle()
return
*********************************
function __getBadDate(obj)
return obj:badDate()
*********************************
function __getundo(obj)
return 	obj:undo()
*********************************
#endif

