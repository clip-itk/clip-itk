/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "config.ch"
#include "button.ch"

#ifdef __UNIX__
  #define SB_UPSYM      "ì" // utf-8: "‚å†"
  #define SB_DOWNSYM    "õ" // utf-8: "‚å°"
  #define SB_LEFTSYM    "<"
  #define SB_RIGHTSYM   ">"
  #define SB_THUMBSYM   "#"
#else
  #define SB_UPSYM      chr(24)
  #define SB_DOWNSYM    chr(25)
  #define SB_LEFTSYM    chr(27)
  #define SB_RIGHTSYM   chr(26)
  #define SB_THUMBSYM   "í" // utf-8: "‚ñì"
#endif
#define SB_FILLSYM    "ê" // utf-8: "‚ñë"

***************************************************
function scrollBar(nstart,nend,noffset,bsBlock,orient)

  local obj
  orient:=iif(orient==NIL,1,orient)
  orient:=max(1,min(2,orient))
  if orient==1
     obj:=scrollBarVertical(nstart,nend,noffset,bsBlock)
  else
     obj:=scrollBarGorizontal(nstart,nend,noffset,bsBlock)
  endif
  obj:classname	:="SCROLLBAR"
  obj:bitmaps	:= NIL
  obj:cargo	:= NIL
  obj:colorSpec	:= setcolor()
  obj:current	:= 1
  obj:end	:= nend
  obj:offset	:= noffset
  obj:orient	:= orient
  obj:sblock	:= bsBlock
  obj:start	:= nstart
  obj:thumbPos	:= 1
  obj:total	:= 100
  obj:barLength	:= max(nend-nstart-1,0)
return obj

***************************************************
static function scrollBarVertical(nstart,nend,noffset,bsBlock)
  local obj
  obj=map()
  obj:subtype   := "VERTICAL"
  obj:style	:= SB_UPSYM+SB_FILLSYM+SB_THUMBSYM+SB_DOWNSYM
  _recover_scrollbar(obj)
return obj

***************************************************
static function scrollBarGorizontal(nstart,nend,noffset,bsBlock)
  local obj
  obj=map()
  obj:subtype   := "GORIZONTAL"
  obj:style	:= SB_LEFTSYM+SB_FILLSYM+SB_THUMBSYM+SB_RIGHTSYM
  _recover_scrollbar(obj)
return obj
***********************************
function _recover_scrollbar(obj)
	if obj:subtype=="VERTICAL"
  		obj:display	:= @sbv_display()
  		obj:update	:= @sbv_display()
  		obj:hitTest	:= @sbv_hitTest()
        else
  		obj:display	:= @sbg_display()
  		obj:update	:= @sbg_display()
  		obj:hitTest	:= @sbg_hitTest()
        endif
return
***********************************
static func sbv_display(self)
   local i,ccc
   ccc:=self:current
   if ccc< (self:total/2)
      ccc--
   endif
   self:thumbPos:=round((ccc/self:total)*self:barLength,0)
   self:thumbPos:=min(self:barLength,max(1,self:thumbPos))
   dispOutAt(self:start,self:offset, substr(self:style,1,1), self:colorSpec)
   for i=self:start+1 to self:end-1
       dispOutAt(i, self:offset, substr(self:style,2,1), self:colorSpec)
   next
   dispOutAt(self:start+self:thumbPos, self:offset,;
           substr(self:style,3,1), self:colorSpec )
   dispOutAt(self:end, self:offset, substr(self:style,4,1), self:colorSpec)
   setpos(self:start+self:thumbPos, self:offset)
return self

***********************************
static func sbg_display(self)
   local i,ccc
   ccc:=self:current
   if ccc< (self:total/2)
      ccc--
   endif
   self:thumbPos:=round((ccc/self:total)*self:barLength,0)
   self:thumbPos:=min(self:barLength,max(1,self:thumbPos))
   dispOutAt(self:offset,self:start, substr(self:style,1,1), self:colorSpec)
   for i=self:start+1 to self:end-1
       dispOutAt(self:offset, i, substr(self:style,2,1), self:colorSpec)
   next
   dispOutAt(self:offset, self:start+self:thumbPos,;
            substr(self:style,3,1), self:colorSpec )
   dispOutAt(self:offset, self:end, substr(self:style,4,1), self:colorSpec)
   setpos(self:offset, self:start+self:thumbPos)
return self

***********************************
static func sbv_hitTest(self,mouseRow,mouseCol)
       local ret:=0, pos:=mouseRow
       if mouseCol==self:offset
	  if pos>self:start .and. pos<self:start+self:thumbPos
	     ret=HTSCROLLBLOCKDEC
	  endif
	  if pos>self:start+self:thumbPos .and. pos<self:end
	     ret=HTSCROLLBLOCKINC
	  endif
	  if pos==self:start+self:thumbPos
	     ret=HTSCROLLTHUMBDRAG
	  endif
	  if pos==self:start
	     ret=HTSCROLLUNITDEC
	  endif
	  if pos==self:end
	     ret=HTSCROLLUNITINC
	  endif
       endif
return ret

***********************************
static func sbg_hitTest(self,mouseRow,mouseCol)
       local ret:=0, pos:=mouseCol
       if mouseRow==self:offset
	  if pos>self:start .and. pos<self:start+self:thumbPos
	     ret=HTSCROLLBLOCKDEC
	  endif
	  if pos>self:start+self:thumbPos .and. pos<self:end
	     ret=HTSCROLLBLOCKINC
	  endif
	  if pos==self:start+self:thumbPos
	     ret=HTSCROLLTHUMBDRAG
	  endif
	  if pos==self:start
	     ret=HTSCROLLUNITDEC
	  endif
	  if pos==self:end
	     ret=HTSCROLLUNITINC
	  endif
       endif
return ret

