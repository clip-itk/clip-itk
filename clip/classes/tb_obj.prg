/*
	Copyright (C) 2001  ITK
	Author   : Uri (uri@itk.ru)
	License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "tbrowse.ch"
#include "inkey.ch"
#include "button.ch"

//#define DEBUG_CALL

*********************************
func TBrowseDB(Lrow,Lcol,Rrow,Rcol)
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"browseDB")
#endif
return TBrowseNew(Lrow,Lcol,Rrow,Rcol,.t.)

*********************************
func TBrowseNew(Lrow,Lcol,Rrow,Rcol,db)
	   local obj

#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"browseNew")
#endif
	   obj		:= map()
	   obj:nTop		:=Lrow
	   obj:nLeft	:=Lcol
	   obj:nBottom	:=Rrow
	   obj:nRight	:=Rcol
	   obj:classname	:= "TBROWSE"
	   obj:autoLite	:= .t.
	   obj:cargo	:= NIL
	   obj:colCount	:= 0
	   obj:colorSpec	:= setcolor()
	   obj:colPos	:= 1
	   obj:rowPos	:= 1
	   obj:mColPos	:= 0
	   obj:mRowPos	:= 0
	   obj:rowcount	:= rRow-lrow
	   obj:colSep	:= " "
	   obj:headSep	:= " "
	   obj:footSep	:= " "
	   obj:freeze	:= 0
	   obj:leftVisible	:= 1
	   obj:chop		:= .f. /* показывать неполностью вмещаемые колонки ?*/
           obj:hiliteType	:= 1   /* 0 -none
           				  1 - current ceil
                                          2 - current line
                                          3 - current line include separators
           				*/
	   obj:refreshBlock	:= {|| NIL }
	   if db!=NIL .and. db
		  obj:goBottomBlock	:= {||dbgobottom() }
		  obj:goTopBlock	:= {|| dbgoTop() }
		  obj:bofBlock		:= {||bof() }
		  obj:eofBlock		:= {||eof() }
	   	  obj:skipBlock		:= {|x,y,z| __tdbskip(x,y,z) }
	   else
	  	obj:bofBlock		:= NIL
	  	obj:eofBlock		:= NIL
	  	obj:goBottomBlock	:= NIL
	  	obj:goTopBlock	:= NIL
	  	obj:SkipBlock		:= NIL
	   endif
	   obj:hitBottom	:=.f.
	   obj:hitTop	:=.f.
	   obj:hitEmpty	:=.f.
	   obj:stable	:=.f.

	  *************************************
	  obj:_stableRowPos	:=NIL
	  obj:_stableColPos	:=NIL
	  obj:_stablefreeze	:=NIL

	  obj:__firstStab	:=.f.  // был ли первый stabilize
	  obj:__rect	:={0,0,0,0}

	  obj:__colorCells	:={}  // items for colorRect()
	  obj:__columns	:={}

	  obj:__columnsLen	:={} // длины колонок
	  obj:__colVisible	:={} // видимые колонки
	  obj:__colpos	:=1  // текущая колонка из числа видимых
	  obj:__whereVisible:={} // row для каждой видимой колонки
	  obj:__headStrings	:={} // надписи заголовков по строкам
	  obj:__footStrings	:={} // надписи подвалов по строкам

	  obj:__colors	:={} // палитры цветов
	  obj:__keys	:=map() // array for ::setkey()

	  obj:__headRows	:=0  // строк в заголовке
	  obj:__footRows	:=0  // строк в подвале
	  obj:__dummyRows	:=0

	  obj:__stablePos	:=0  // скока записей уже отрисовалось во время стабилизации
	  obj:__stableSkips	:=0  // скока надо сделать skip чтобы вернуться на текущую
				 // запись после стабилизации
	  obj:__rightAll	:=.f. // больше справа никого нет

	  obj:winbuffer		:= nil

	  _recover_tbrowse(obj)

return obj
**********************************************************
function _recover_tbrowse(obj)
	   obj:setKey	:=@tb_setKey()
	   obj:applyKey	:=@__applykey()
	   obj:down	:=@down()
	   obj:up	:=@up()
	   obj:left	:=@cleft()
	   obj:right	:=@cright()
	   obj:goBottom	:=@goBottom()
	   obj:goTop	:=@goTop()
	   obj:home	:=@home()
	   obj:end	:=@end()
	   obj:pageDown	:=@pageDown()
	   obj:pageUp	:=@pageUp()
	   obj:panHome	:=@panHome()
	   obj:panEnd	:=@panEnd()
	   obj:panLeft	:=@panLeft()
	   obj:panRight	:=@panRight()

	   obj:addColumn	:=@addColumn()
	   obj:insColumn	:=@insColumn()
	   obj:setColumn	:=@setColumn()
	   obj:delColumn	:=@delColumn()
	   obj:getColumn	:=@getColumn()
	   obj:__delAllColumns	:=@__delAllColumns()

	   obj:deHilite 	:=@deHilite()
	   obj:hilite   	:=@hilite()

	   obj:hitTest   	:=@tb_hitTest()

	   obj:colorRect	:= @colorRect()
	   obj:colWidth 	:= @colWidth()
	   obj:configure	:= @configure()
	   obj:invalidate	:= @invalidate()
	   obj:refreshAll	:= @refreshAll()
	   obj:refreshCurrent	:= @refreshCurrent()
	   obj:refreshCurent	:= @refreshCurrent()
	   obj:refreshCur	:= @refreshCurrent()
	   obj:_outCurrent  	:= @_outCurrent()
	   obj:stabilize	:= @stabilize()
	   obj:forceStable	:= @forceStable()

	   obj:__whoVisible	:= @__whoVisible() // вычислить кто видимый
	   obj:__reMakeColumns	:= @__remakeColumns()
	   obj:__dummyRow	:= @__dummyRow()
	   obj:__sayTable	:= @__sayTable() // рисовать обрамление, заголовки, подвалы
	   obj:__setColor	:= @__setcolor()
	   obj:__checkRow	:= @__checkRow()

	tb_set_default_keys(obj)

return obj

**********************************************************
static func __whoVisible(num)
	   local i,leftcol,lensep,scol,oldcol,col,mincol,maxcol
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"whoVisible")
#endif
	   num=iif(num==NIL,0,num)
	   lenSep:=len(::colsep)
	   //lenSep:=min(iif(lensep==3,3,1),lensep)
	   ::freeze:=max(::freeze,0)
	   ::freeze:=min(::freeze,::colCount)
	   if (empty(::__colVisible))
	  	col    := 1  // ::colpos
	  	oldcol := ::colpos
	   else
	  	col:=min(max(::__colPos,::freeze+1),::colCount)
		if col <= len(::__colVisible)
			col:=::__colVisible[col]
		endif
		oldcol:=max(1,min(::colCount,::colPos))
	   endif
	   scol:=::__rect[2]
	   leftcol:=scol
	   for i=1 to ::freeze
	   	leftcol+=::__columnsLen[i]+lensep
	   	next
	   while i<=::colCount .and. leftcol>::nRight-10 .and. ::freeze>0
	   	leftcol-=::__columnsLen[i]+lensep
	   	::freeze--
	   enddo
	   ::__colVisible:={}
	   ::__whereVisible:={}
	   for i=1 to ::freeze
	   	aadd(::__colVisible,i)
	   	aadd(::__whereVisible,scol)
	   	scol+=::__columnsLen[i]+lensep
	   next
	   *
	   col+=num
	   col=min(max(min(col,::colCount),::freeze+1),::colCount)
	   if num>=0
			scol:=::__rect[4]-(::__columnsLen[col]+lenSep)
			while scol>leftcol .and. col > ::freeze+1
   				col--
				scol-=::__columnsLen[col]+lenSep
			enddo
			if scol<leftcol .and. (col<=oldcol .or. num >= ::colCount)
				col++
			endif
	   endif
	   mincol:=col
	   scol:=leftcol
	   while scol<::__rect[4] .and. col<=::colCount
	   	scol+=::__columnsLen[col]+lenSep
	   	col++
	   enddo
	   scol--
	   col--
	   col=min(col,::colCount)
	   col=max(1,col)
	   maxcol:=col
	   if col>1 .and. !::chop .and. ::colCount>1 .and. scol-lensep>::__rect[4] .and. mincol!=maxcol
			col--
			maxcol:=col
			scol:=::__rect[4]-(::__columnsLen[col]+lenSep)
			while scol>leftcol .and. col>1
				col--
				scol-=::__columnsLen[col]+lenSep
			enddo
			if scol<leftcol
				col++
			endif
			col:=max(1,col)
			mincol:=col
			if mincol >maxcol
				mincol := maxcol
			endif
	   endif
	   mincol := max(::freeze+1,min(mincol,len(::__columns)))
	   maxcol := min(maxcol,len(::__columns))
	   * add to list of columns
	   scol:=leftcol
	   for col=mincol to maxcol
		::leftVisible := col
	   	aadd(::__colVisible,col)
	   	aadd(::__whereVisible,scol)
	   	scol+=::__columnsLen[col]+lensep
	   next
	   if empty(::__colVisible)
		aadd(::__colVisible,col)
		aadd(::__whereVisible,scol)
	   endif
	   for i=1 to len(::__colVisible)
		if ::__colVisible[i]==oldcol+num
			col:=::__colVisible[i]
			::__colPos=i
		endif
	   next
	   ::__rightAll := (maxcol==::colcount)
	   ::__colPos:=min(::__colPos,len(::__colVisible))
	   ::__colPos:=max(::__colPos,1)
	   ::colpos:=::__colVisible[::__colpos]
	   ::_stableColPos:=::colpos
return NIL

*********************************
static func __sayTable
   local visLen,col,colSep,lensep,lenhsep
   local strsep1,strsep2,strseph,scol,len,strings
   local i,j,s,ccc,headsep,strhsep1, x,y
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"sayTable")
#endif
   if ::winbuffer==nil; dispBegin(); endif

   visLen= len(::__colVisible)
   for i=1 to visLen
	  col=::__colVisible[i]
	  len=::__columnsLen[col]
	  colSep:=::__columns[col]:colSep
	  colsep:=iif(colSep==NIL,::colSep,colSep)
	  lenSep:=len(colSep)
	  strsep1:=iif(lenSep>2,substr(colsep,3,1),"")
	  lenSep:=iif(lenSep==3,3,1)
	  strsep1:=space(len(strsep1))
	  strsep2:=substr(colsep,1,2)
	  strsep2:=space(len(strsep2))
	  scol=::__whereVisible[i]
	  len=min(len,::nright-scol-lenSep+len(strSep2))
	  strings:=::__HeadStrings[col]
	  ccc:=::__colors[1]
	  if ::__columns[col]:defColor!=NIL
		ccc:=::__colors[::__columns[col]:defColor[1]]
	  endif
	  if ::__columns[col]:colorHeading!=NIL
		ccc:=::__colors[::__columns[col]:colorHeading]
	  endif
	  for j=1 to len(strings )
	 	s=padr(strings[j],len)
		y := ::nTop+j-1
		x := scol
		if ::__columns[col]:colSepH != nil
		 	strseph:=substr(::__columns[col]:colSepH,j,1)
	   		if ::winbuffer == nil
	   			dispOutAt(::nTop+j-1, scol-1,strseph,::__colors[1])
		 	else
				winbuf_out_at(::winbuffer,::nTop+j-1, scol-1,strseph,::__colors[1])
		 	endif
	 		x := scol-1 + len(strseph)
		else
	   		if ::winbuffer == nil
	   			dispOutAt(::nTop+j-1, scol,strsep1,::__colors[1])
		 	else
	   			winbuf_out_at(::winbuffer,::nTop+j-1, scol,strsep1,::__colors[1])
		 	endif
	 		x := scol + len(strsep1)
		endif
		if ::winbuffer == nil
			dispOut(s,ccc)
			dispOut(iif(i<visLen,strSep2,""),::__colors[1])
		else
			winbuf_out_at(::winbuffer,y,x,s,ccc)
			x += len(s)
			winbuf_out_at(::winbuffer,y,x,iif(i<visLen,strSep2,""),::__colors[1])
			x += len(iif(i<visLen,strSep2,""))
		endif
	 	if i==visLen
			if ::winbuffer == nil
				dispout(space(::nRight-col()+1),::__colors[1])
	 		else
				winbuf_out_at(::winbuffer,y,x,space(::nRight-col()+1),::__colors[1])
			endif
		endif
	next
	headSep:=::__columns[col]:headSep
	headSep:=iif(headSep==NIL,::headSep,headSep)
	lenHSep=len(headSep)
	strhsep1=right(headsep,1)
	j:=len(strings)
	if (j>0 .and. lenHSep>0 ) .or. !empty(::headSep)
		if ::__columns[col]:colSepH != nil .and. len(::__columns[col]:colSepH)>j
			strseph:=substr(::__columns[col]:colSepH,j+1,1)
			if ::winbuffer == nil
	   			dispOutAt(::nTop+j, scol-1, strseph,::__colors[1])
	 		else
				winbuf_out_at(::winbuffer,::nTop+j, scol-1, strseph,::__colors[1])
			endif
	 	endif
		s := replicate(strHsep1,len)+iif(i<visLen,headsep,"")
		if ::winbuffer == nil
			dispOutAt(::nTop+j, scol,s, ::__colors[1])
	 	else
			winbuf_out_at(::winbuffer,::nTop+j, scol, s, ::__colors[1])
		endif
	 	y := ::nTop+j; x := scol + len(s)
	 	if i==vislen
			if ::winbuffer == nil
				dispout(replicate(strHsep1,::nright-col()+1),::__colors[1])
	 		else
				winbuf_out_at(::winbuffer,y,x, replicate(strHsep1,::nright-col()+1),::__colors[1])
			endif
	 	endif
		j++
	endif
	::__rect[1]=::nTop+j
	strings:=::__footStrings[col]
	ccc:=::__colors[1]
	if ::__columns[col]:defColor!=NIL
		ccc:=::__colors[::__columns[col]:defColor[1]]
	endif
	if ::__columns[col]:colorFooting!=NIL
		ccc:=::__colors[::__columns[col]:colorFooting]
	endif
	for j=1 to len(strings)
		s=padr(strings[j],len)
		if ::winbuffer == nil
			dispOutAt(::nBottom-j+1, scol, strsep1, ::__colors[1])
			dispOut(s, ccc)
			dispOut(iif(i<visLen,strSep2,"") , ::__colors[1])
			if i==visLen
				dispout(space(::nRight-col()+1),::__colors[1])
			endif
	 	else
			winbuf_out_at(::winbuffer,::nBottom-j+1, scol, strsep1, ::__colors[1])
			y := ::nBottom-j+1
			x := scol + len(strsep1)
			winbuf_out_at(::winbuffer,y,x,s,ccc)
			x += len(s)
			winbuf_out_at(::winbuffer,y,x,iif(i<visLen,strSep2,"") , ::__colors[1])
			x += len(iif(i<visLen,strSep2,""))
			if i==visLen
				winbuf_out_at(::winbuffer,y,x,space(::nRight-col()+1),::__colors[1])
			endif
		endif
	next
	//if !empty(::footSep)
	headSep:=::__columns[col]:footSep
	headsep:=iif(headSep==NIL,::footSep,headSep)
	lenHSep=len(headSep)
	strhsep1=right(headsep,1)
	//endif
	j:=len(strings)
	//if ( j>0 .and. lenHSep>0 ) .or. !empty(::footSep)
	if lenHSep>0  .and. !empty(headSep)
		if ::winbuffer == nil
			dispOutAt(::nBottom-j, scol, replicate(strHsep1,len)+iif(i<visLen,headsep,"") , ::__colors[1])
			if i==vislen
				dispOut(replicate(strHsep1,::nright-col()+1),::__colors[1])
			endif
	 	else
			s := replicate(strHsep1,len)+iif(i<visLen,headsep,"")
			winbuf_out_at(::winbuffer,::nBottom-j, scol, s, ::__colors[1])
			y := ::nBottom-j+1
			x := scol + len(s)
			if i==vislen
				winbuf_out_at(::winbuffer,y,x,replicate(strHsep1,::nright-col()+1),::__colors[1])
			endif
		endif
		j++
	endif
	::__rect[3]=::nBottom-j
   next
   ::rowCount:=::__rect[3]-::__rect[1]+1
   if ::winbuffer==nil; dispEnd(); endif

return NIL

*********************************
static func __remakeColumns
   local a,s,i,j,h,f,hr,hf,max_hr,max_hf,clen
   local data
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"remakeColumns")
#endif
   if !::__firstStab
   //   return NIL
   endif
   ::__headStrings:={}
   ::__footStrings:={}
   max_hr:=0; max_hf:=0
   for i=1 to len(::__columns)
	  h:=::__columns[i]:heading
	  hr:=iif(empty(h),0,occurs(";",h)+1)
	  max_hr:=max(max_hr,hr)
	  f:=::__columns[i]:footing
	  hf:=iif(empty(f),0,occurs(";",f)+1)
	  max_hf:=max(max_hf,hf)
   next
   ::__columnsLen:={}
   for i=1 to len(::__columns)
	  clen:=0
	  aadd(::__headStrings,{})
	  h:=::__columns[i]:heading
	  hr:=iif(empty(h),0,occurs(";",h)+1)
	  for j=1 to hr
	 	a=at(";",h)
	 	a=iif(a==0,len(h)+1,a)
	 	s=substr(h,1,a-1)
	 	clen:=max(clen,len(s))
	 	aadd(::__headStrings[i], s )
	 	h:=substr(h,a+1)
	  next
	  for j=hr+1 to max_hr
	  	aadd(::__headStrings[i],"")
	  next

	  aadd(::__footStrings,{})
	  f:=::__columns[i]:footing
	  hf:=iif(empty(f),0,occurs(";",f)+1)
	  for j=1 to hf
	 	a=at(";",f)
	 	a=iif(a==0,len(f)+1,a)
	 	s=substr(f,1,a-1)
	 	clen=max(clen,len(s))
	 	aadd(::__footStrings[i],s)
	 	f:=substr(f,a+1)
	  next
	  for j=hf+1 to max_hf
	  	aadd(::__footStrings[i],"")
	  next
          if ::__columns[i]:fieldname == NIL
	  	data=eval(::__columns[i]:block)
          else
	  	data=eval(::__columns[i]:block,::__columns[i]:fieldname)
          endif
	  if valtype(::__columns[i]:picture)=="C"
		data:=transform(data,::__columns[i]:picture)
	  else
		data:=toString(data)
	  endif
	  clen=max(clen,len(data))
	  if !empty(::__columns[i]:width) .and. valtype(::__columns[i]:width)=="N"
	 	clen:=::__columns[i]:width
	  endif
	  aadd(::__columnsLen,clen)
   next
   ::__headRows:=max_hr-iif(empty(::headSep),1,0)
   ::__footRows:=max_hf
   ::__rect:={::ntop+::__headRows,::nleft,::nbottom-::__footRows,::nright}
   ::rowCount:=::__rect[3]-::__rect[1]+1
   //::__colorCells:={}
   asize(::__colorCells,::rowCount)
   for i=1 to len(::__colorCells)
	::__colorCells[i]={}
	asize(::__colorCells[i],len(::__columns))
	//afill(::__colorCells[i],{1,2})
	for j=1 to len(::__colorCells[i])
		::__colorCells[i][j]:=::__columns[j]:defColor
	next
   next
   ::refreshAll()
return NIL

*********************************
static func __setcolor()
	local i,s
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"setColor")
#endif
	   ::__colors:={}
	   s:=::colorSpec
	   while len(s)>0
	   i:=at(",",s)
	   i=iif(i==0,len(s)+1,i)
	   aadd(::__colors,substr(s,1,i-1) )
	   s:=substr(s,i+1)
	   enddo
return NIL

*********************************
static func addColumn(self,col)
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"addColumn")
#endif
	aadd(self:__columns,col)
	self:colCount++
	if self:__firstStab
	   self:__remakeColumns()
	endif
return self

*********************************
static func insColumn(pos,col)
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"insColumn")
#endif
	aadd(::__columns,"")
	ains(::__columns,pos)
	::__columns[pos]:=col
	::colcount++
	if ::__firstStab
	   ::__remakeColumns()
	endif
return col

*********************************
static func setColumn(pos,col)
	local oldcol:=::__columns[pos]
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"setColumn")
#endif
	::__columns[pos]=col
	if ::__firstStab
	   ::__remakeColumns()
	endif
return oldcol

*********************************
static func delColumn(pos)
	local oldcol:=::__columns[pos]
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"delColumn")
#endif
	adel(::__columns,pos)
	::colCount--
	asize(::__columns,::colCount)
	if ::__firstStab
	   ::__remakeColumns()
	endif
return oldcol
*********************************
static func __delAllColumns()
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"delAllColumns")
#endif
	::colCount := 0
	asize(::__columns,0)
return .t.

*********************************
static func getColumn(pos)
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"getColumn")
#endif
return ::__columns[pos]


*********************************
static func down(self)
   local nskip
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"down",self:stable,self:__stablePos)
#endif
   /*
   if !self:stable
	  return self
   endif
   */
   self:__checkRow()
   self:hitTop:=self:hitBottom:=.f.
   if self:rowpos >= self:rowCount
   	nskip:=eval(self:skipBlock,1)
        /*
        dispbegin()
        scroll(self:__rect[1],self:__rect[2],self:__rect[3],self:__rect[4],1)
        dispend()
        */
        self:refreshAll()
        return self
   else
   	if self:winbuffer==nil; dispBegin(); endif
        self:refreshCurrent()
        self:forceStable()
   	self:_outCurrent(0)
        if self:winbuffer==nil; dispEnd(); endif
	self:rowpos++
   	nskip:=eval(self:skipBlock,1)
   	if nskip==0
          self:rowPos--
	  self:_outCurrent()
	  self:hitBottom=.t.
	  return self
   	endif
   endif
   if self:_stableRowPos!=NIL
	self:_stableRowPos:=self:rowPos
   endif
   //self:__stableSkips= eval(self:skipBlock,1)
   self:__stablePos:=-999
   self:stable:=.f.
return self

*********************************
static func up(self)
   local oldrow,nskip
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"up")
#endif
   /*
   if !self:stable
	  return self
   endif
   */
   self:__checkRow()
   self:hitTop:=self:hitBottom:=.f.
   if self:rowpos<2
   	nskip:=eval(self:skipBlock,-1)
        /*
	dispbegin()
	scroll(self:__rect[1],self:__rect[2],self:__rect[3],self:__rect[4],-1)
	dispend()
        */
	self:refreshAll()
   else
	if self:winbuffer==nil; dispBegin(); endif
        self:refreshCurrent()
        self:forcestable()
        self:_outcurrent(0)
	if self:winbuffer==nil; dispEnd(); endif

	self:rowpos--
   	nskip:=eval(self:skipBlock,-1)

   	if nskip==0
           self:rowPos++
	   self:hitTop:=.t.
	   self:_outCurrent()
	   return self
   	endif

   endif
   if self:_stableRowPos!=NIL
	self:_stableRowPos:=self:rowPos
   endif
   self:__stablePos==-1
   self:stable:=.f.
return self

*********************************
static func refreshCurrent(self)
	local j,i
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"refreshCurrent")
#endif
	if !self:__firstStab
		return self
	endif
	self:__checkRow()
	//afill(self:__colorCells[self:rowPos],{1,2})
	i:=self:rowpos
	for j=1 to len(self:__colorCells[i])
		self:__colorCells[i][j]:=self:__columns[j]:defColor
	next
	if self:__stablePos!=-1
		self:__stablePos=-999
	endif
	self:stable:=.f.
return self

*********************************
static func refreshAll(self)
	   local i,j
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"refreshAll")
#endif
	   if !self:__firstStab
			return self
	   endif
	   eval(self:refreshBlock)
	   self:__checkRow()
	   if !self:stable
		  eval(self:skipBlock,0-self:__stableSkips)
		  self:__stableSkips:=0
		  self:__stablePos:=0
	   endif
	   for i=1 to len(self:__colorCells)
			//afill(self:__colorCells[i],{1,2})
		for j=1 to len(self:__colorCells[i])
			self:__colorCells[i][j]:=self:__columns[j]:defColor
		next
	   next
	   self:stable:=.f.
	   i=eval(self:skipBlock,-1)
	   i+=eval(self:skipBlock,1)
	   if i!=0
   		i+=eval(self:skipBlock,0-i)
   		self:rowPos+=i
   		self:rowpos:=max(1,self:rowpos)
		if self:_stableRowPos!=NIL
			self:_stableRowPos:=self:rowPos
		endif
	   endif
	   i:=1-self:rowPos
	   self:__stableSkips=eval(self:skipBlock,i)
	   self:rowPos=0-self:__stableSkips+1
	   self:_stableRowPos:=self:rowPos
	   self:__stablePos:=-1
return self

*********************************
static func goBottom(self)
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"goBottom")
#endif
	   self:__checkRow()

	   if self:gobottomBlock!=NIL
		  self:hitTop:=self:hitBottom:=.f.
		  self:rowPos=self:rowCount
		  eval(self:gobottomBlock)
		  self:refreshAll()
	   endif
return self

*********************************
static func goTop(self)
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"goTop")
#endif
	   self:__checkRow()
	   if self:gotopBlock!=NIL
		  self:hitTop:=self:hitBottom:=.f.
		  self:rowPos=1
		  eval(self:gotopBlock)
		  self:refreshAll()
	   endif
return self

*********************************
static func pageDown(self)
	local xskip,nskip
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"pageDown")
#endif
	   if !self:stable
	  	eval(self:skipBlock,0-self:__stableSkips)
	  	self:__stableSkips:=0
	  	self:__stablePos:=0
	   endif
	   self:__checkRow()
	   self:hitTop:=self:hitBottom:=.f.
	   xskip=self:rowCount
	   nskip=eval(self:skipBlock,xskip)
	   if nskip<xskip
	  	self:rowPos+=nskip
		self:rowPos=max(min(self:rowPos,self:__rect[3]-self:__rect[1]+1),1)
	  	if self:_stableRowPos!=NIL
			self:_stableRowPos:=self:rowPos
	  	endif
	   endif
	   self:refreshAll()
return self

*********************************
static func pageUp(self)
	local xskip,nskip
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"pageUp")
#endif
	   if !self:stable
	  	eval(self:skipBlock,0-self:__stableSkips)
	  	self:__stableSkips:=0
	  	self:__stablePos:=0
	   endif
	   self:__checkRow()
	   self:hitTop:=self:hitBottom:=.f.
	   //xskip=0-(self:rowcount+self:rowPos)
	   xskip=0-self:rowcount
	   nskip=eval(self:skipBlock,xskip)
	   if nskip>xskip
	  	//self:rowPos:=self:rowCount-nskip+xskip+1
	  	self:rowPos:=self:rowpos-nskip+xskip
	  	self:rowpos:=max(1,self:rowpos)
	  	if self:_stableRowPos!=NIL
			self:_stableRowPos:=self:rowPos
	  	endif
	  	//nskip=eval(self:skipBlock,self:rowPos-1)
	   else
	  	//nskip=eval(self:skipBlock,self:rowPos)
	   endif
	   self:refreshAll()
return self

*********************************
static func home(self)
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"Home")
#endif
	   self:__checkRow()
	   self:__colPos:=1
	   self:colpos:=self:__colVisible[self:__colpos]
	   self:_stableColPos:=self:colpos
	   self:_outCurrent()
return self

*********************************
static func end(self)
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"End")
#endif
	   self:__checkRow()
	   self:__colPos:=len(self:__colVisible)
	   self:colpos:=self:__colVisible[self:__colpos]
	   self:_stableColPos:=self:colpos
	   self:_outCurrent()
return self

*********************************
static func cleft(self)
	local fl:=.f.
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"Left")
#endif
	self:__checkRow()
	if self:__colpos==1
	   if self:__colVisible[1]==1
           	if ! self:stable
                	self:refreshall()
                endif
	  	return self
	   endif
	   fl:=.t.
	else
	   self:__colPos--
	   if self:__colPos > self:freeze
		  self:colpos:=self:__colVisible[self:__colpos]
		  self:_stableColPos:=self:colpos
	  	  self:_outCurrent()
		  return self
	   else
		  if len(self:__colVisible) > self:freeze .and. ;
			 self:__colVisible[self:freeze+1] > self:freeze+1
			self:__colPos++
		  endif
	   endif
	   fl:=.t.
	endif
	if !self:stable
	   eval(self:skipBlock,0-self:__stableSkips)
	   self:__stableSkips:=0
	   self:__stablePos:=0
	endif
	if fl
		self:__whoVisible(-1)
		self:__sayTable()
		self:refreshAll()
	endif
return self

*********************************
static func cright(self)
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"Right")
#endif
	self:__checkRow()
	if self:__colpos==len(self:__colVisible)
	   if self:__rightAll
           	if ! self:stable
                	self:refreshall()
                endif
	   	return self
	   endif
	   if !self:stable
	  	eval(self:skipBlock,0-self:__stableSkips)
	  	self:__stableSkips:=0
	  	self:__stablePos:=0
	   endif
	   self:__whoVisible(1)
	   self:__sayTable()
	   self:refreshAll()
	else
	   self:__colPos++
	   self:colpos:=self:__colVisible[self:__colpos]
	   self:_stableColPos:=self:colpos
           if !self:stable
           	self:refreshall()
           else
	   	self:_outCurrent()
           endif
	endif
return self

*********************************
static func panHome(self)
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"panHome")
#endif
	self:__checkRow()
	if self:__colpos==1
	   if self:__colVisible[1]==1
	  return self
	   endif
	endif
	if !self:stable
	  eval(self:skipBlock,0-self:__stableSkips)
	  self:__stableSkips:=0
	  self:__stablePos:=0
	endif
	self:__colpos:=1
	self:__whoVisible(0-self:colCount)
	self:__sayTable()
	self:refreshAll()
return self

*********************************
static func panEnd(self)
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"panEnd")
#endif
	self:__checkRow()
	if self:__colpos==len(self:__colVisible)
	   if self:__rightAll
	   	return self
	   endif
	endif
	if !self:stable
	  eval(self:skipBlock,0-self:__stableSkips)
	  self:__stableSkips:=0
	  self:__stablePos:=0
	endif
	self:__colpos:=self:colcount+1 //len(self:__colVisible)
	self:__whoVisible(self:colCount+1)
	self:__sayTable()
	self:refreshAll()
return self

*********************************
static func panLeft(self)
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"panLeft")
#endif
	self:__checkRow()
	if self:__colVisible[1]==1
	  return self
	endif
	if !self:stable
	  eval(self:skipBlock,0-self:__stableSkips)
	  self:__stableSkips:=0
	  self:__stablePos:=0
	endif
	self:__whoVisible(-1)
	self:__sayTable()
	self:refreshAll()
return self

*********************************
static func panRight(self)
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"panRight")
#endif
	self:__checkRow()
	if self:__rightAll
	   return self
	endif
	if !self:stable
	  eval(self:skipBlock,0-self:__stableSkips)
	  self:__stableSkips:=0
	  self:__stablePos:=0
	endif
	self:__whoVisible(1)
	self:__sayTable()
	self:refreshAll()
return self


*********************************
static func deHilite(self)
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"dehilite")
#endif
	self:_outCurrent(NIL,.f.)
	self:__checkRow()
return self

*********************************
static func hilite(self)
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"hilite")
#endif
	self:_outCurrent(NIL,.t.)
	self:__checkRow()
return self


*********************************
static func colorRect(self,rect,block)
	local i,j,m1,m2,m3,m4
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"colorRect",block,rect)
#endif
		self:__checkRow()
		if !(valtype(rect)=="A" .and. len(rect)==4)
			return self
		endif
		if empty(block)
			block:={1,2}
		endif
		m1:=min(max(1,rect[1]),len(self:__colorCells))
		m2:=min(max(1,rect[3]),len(self:__colorCells))
		for i=m1 to m2
			m3:=min(max(1,rect[2]),len(self:__colorCells[i]))
			m4:=min(max(1,rect[4]),len(self:__colorCells[i]))
			for j=m3 to m4
				self:__colorCells[i][j]:=block
			next
			self:_outCurrent(i,.t.)
		next
return self

*********************************
static func colWidth(self,col)
	   local ret:=0,x
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"colWidth")
#endif
	   x=ascan(self:__colVisible,col)
	   if x>0
	  ret=self:__columnsLen[col]
	   endif
return ret

*********************************
static func invalidate(self)
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"invalidate")
#endif
	 self:__setColor()
	 self:__remakeColumns()
	 self:__whoVisible()
	 self:__sayTable()
	 self:refreshAll()
return self

*********************************
static func configure(self)
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"configure")
#endif
	 self:__setColor()
	 self:__remakeColumns()
	 self:__whoVisible()
/*
	 self:__sayTable()
	 self:refreshAll()
	 self:forcestable()
*/
return self


*********************************
static func _outCurrent ( row, hilite, fSay )
   local i,col,vislen,data,datat,srow,cblock
   local colsep,lensep,scol,ecol,len,lenc
   local xcur:=NIL,ycur:=::nLeft,xcolor,ccolors:="",x,y
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"_outCurrent",row)
#endif
   fSay:=iif(fSay==NIL,.t.,fSay)
   row=iif(row==NIL,::rowPos,row)
   hilite=iif(hilite==NIL,::autoLite,hilite)
   srow=iif(row<1,::rowPos,row)
   if srow<1
	return
   endif
   xcur:=::__rect[1]-1+srow
   if ::winbuffer==nil; dispBegin(); endif
   visLen= len(::__colVisible)
   if fSay .and. hilite .and. ::winbuffer == nil //.or. row==0
	draw_rect(xcur,::nLeft,xcur,::nright,colorToN(::__colors[1]))
   endif
   for i=1 to visLen
	  col=::__colVisible[i]
	  colSep:=::__columns[col]:colSep
	  colsep:=iif(colSep==NIL,::colSep,colSep)
	  lenSep:=len(colSep)
	  scol=::__whereVisible[i]
          if ::__columns[col]:fieldName == NIL
	  	data:=eval(::__columns[col]:block)
          else
	  	data:=eval(::__columns[col]:block,::__columns[col]:fieldName)
          endif
	  datat:=valtype(data)
	  cblock=::__columns[col]:colorBlock
	  ccolors:=::__colorCells[srow][col]
	  if valtype(cblock)=="B" .and. ccolors[1]==1 .and. ccolors[2]==2
		ccolors:=eval(cblock,data)
	  endif

	  if valtype(::__columns[col]:picture)=="C"
		data:=transform(data,::__columns[col]:picture)
	  else
		data:=toString(data)
	  endif
	  len=min(::__columnsLen[col],len(data))
	  lenc=max(::__columnsLen[col],len)
	  len=min(len,::nright-scol)
	  lenc=min(lenc,::nright-scol)
	  ecol=min(scol+::__columnsLen[col],::nright)
	  if vislen==1
		len++; lenc++
	  endif
	  //data:=padr(data,len)
	  data:=left(data,len)
	  xcolor:=::__colors[ccolors[1]]
	  if hilite .and. row >0
          	switch ( ::hiliteType )
                case 0
                case 1
	  		if srow==::rowPos .and. i==::__colPos .and. row>0
	  			xcolor:=::__colors[ccolors[2]]
                        endif
                case 2
	  		if srow==::rowPos
	  			xcolor:=::__colors[ccolors[2]]
                        endif
                endswitch
	  endif
	  if srow==::rowPos .and. i==::__colPos .and. row>0
	 	xcur:=::__rect[1]-1+srow
	 	ycur:=scol
	 	if datat $ 'N'
			ycur += lenc-len
	 	endif
	 	if datat $ 'L'
			ycur += (lenc-len)/2
	 	endif
	  endif
	  if fSay
		  if ::winbuffer == nil
		  	dispOutAt(::__rect[1]-1+srow ,scol,"")
		  endif
		  y := ::__rect[1]-1+srow; x := scol
		  if datat $ "N"
			if ::winbuffer == nil
				dispout(space(lenc-len),::__colors[1])
		  	else
		  		winbuf_out_at(::winbuffer,y,x,space(lenc-len),::__colors[1])
		  		x += lenc-len
		  	endif
		  endif
		  if datat $ "L"
			if ::winbuffer == nil
				dispout(space((lenc-len)/2),::__colors[1])
		  	else
		  		winbuf_out_at(::winbuffer,y,x,space((lenc-len)/2),::__colors[1])
		  		x += (lenc-len)/2
		  	endif
		  endif
		  if ::winbuffer == nil
		  	dispOut(data, xcolor)
		  	//dispOut(space(ecol-col()), xcolor)
		  	dispOut(space(ecol-col()), ::__colors[1])
		  	if i==vislen //.and. fSay
				dispOut(space(::nRight-col()+1),::__colors[1])
		  	else
				dispOut(colsep,::__colors[1])
		  	endif
		  else
		  	winbuf_out_at(::winbuffer,y,x,data, xcolor)
		  	x += len(data)
		  	//dispOut(space(ecol-col()), xcolor)
		  	winbuf_out_at(::winbuffer,y,x,space(ecol-x), ::__colors[1])
		  	x := ecol
		  	if i==vislen //.and. fSay
				winbuf_out_at(::winbuffer,y,x,space(::nRight-col()+1),::__colors[1])
		  	else
				winbuf_out_at(::winbuffer,y,x,colsep,::__colors[1])
		  	endif
		  endif
	  endif
   next
   if hilite .and. ::hiliteType==3 .and. srow==::rowPos .and. row!=0
   	xcolor:=colorToN(::__colors[ccolors[2]])
   	if ::winbuffer == nil
   		draw_rect(xcur,::nLeft,xcur,::nright,xColor)
   	else
   	endif
   endif
   //setpos(xcur,ycur)
   if ::winbuffer==nil; dispOutAt(xcur,ycur,""); endif
   if ::winbuffer==nil; dispEnd(); endif
return NIL

*********************************
static func __dummyRow( row )
   local i,col,vislen,colBlock,data,colsep
   local srow,lensep,scol,len,x,y
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"__dummyRow")
#endif
   row=iif(row==NIL,::rowPos,row)
   srow=iif(row<1,::rowPos,row)
   if ::winbuffer==nil; dispBegin(); endif
   visLen= len(::__colVisible)
   for i=1 to visLen
	  col=::__colVisible[i]
	  colBlock:=::__columns[col]:block
	  colSep:=::__columns[col]:colSep
	  colsep:=iif(colSep==NIL,::colSep,colSep)
	  lenSep:=len(colSep)
	  scol=::__whereVisible[i]
	  len=::__columnsLen[col]
	  len=min(len,::nright-scol)
	  if ::winbuffer == nil
	  	dispOutAt(::__rect[1]-1+srow ,scol,space(len), ::__colors[1])
	  	if i==vislen
	 		dispOut(space(::nRight-col()+1),::__colors[1])
	  	else
			dispOut(colsep,::__colors[1])
	  	endif
   	  else
	  	winbuf_out_at(::winbuffer,::__rect[1]-1+srow ,scol,space(len), ::__colors[1])
	  	y := ::__rect[1]-1+srow; x := scol + len
	  	if i==vislen
	 		winbuf_out_at(::winbuffer,y,x,space(::nRight-col()+1),::__colors[1])
	  	else
			winbuf_out_at(::winbuffer,y,x,colsep,::__colors[1])
	  	endif
   	  endif
   next
   if ::winbuffer==nil; dispEnd(); endif
return NIL

*********************************
static func stabilize(self)
  local i,nskip,row,col
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"stabilize")
#endif
  if !self:__firstStab
	 self:stable:=.f.
	 self:__setcolor()
	 self:__remakeColumns()
	 self:__whoVisible()
	 self:__sayTable()
	 self:rowPos=min(self:rowPos,self:rowCount)
	 self:__stableSkips=eval(self:skipBlock,1-self:rowPos)
	 self:rowPos=0-self:__stableSkips+1
	 self:__stablePos:=-1
#ifdef DEBUG_CALL
	 outlog(__FILE__,__LINE__,"stabilize return 1")
#endif
	 self:__firstStab:=.t.
	 return self:stable
  endif
  if self:stable
		self:_outCurrent(,,.f.)
		self:_stableRowPos:=self:rowPos
		self:_stableColPos:=self:colPos
		self:_stablefreeze:=self:freeze
#ifdef DEBUG_CALL
	 outlog(__FILE__,__LINE__,"stabilize return 2")
#endif
	return self:stable
  endif
  self:__checkRow()
	// нуль-стабилизация
  if self:__stablePos==-1
	eval(self:skipBlock,0)
		self:__stablePos:=0
#ifdef DEBUG_CALL
	 outlog(__FILE__,__LINE__,"stabilize return 3")
#endif
		return self:stable
  endif
  //if self:__stablePos==(0-self:rowcount)
  if self:__stablePos==-999
	eval(self:skipBlock,0)
		self:__stablePos:=self:rowcount
#ifdef DEBUG_CALL
	 outlog(__FILE__,__LINE__,"stabilize return 4")
#endif
		return self:stable
  endif
	// конец стабилизации
  if self:__stablePos >= self:rowcount
		// возврат на текущую запись
		if self:__stableSkips<0
			self:rowPos+=self:__stableSkips
			self:__stableSkips=0
		endif
		i:=eval(self:skipBlock,0-self:__stableSkips)
		self:__stableSkips:=0
		self:stable:=.t.
		if self:bofBlock!=NIL .and. self:eofBlock!=NIL
			i:=eval(self:skipBlock,-1)
			self:hitEmpty:= ( eval(self:bofBlock) .and. eval(self:eofBlock) )
				//self:hitTop:=eval(self:bofBlock)
				self:hitBottom:=eval(self:eofBlock)
				if i==0 .and. !self:hitEmpty
				i:=eval(self:skipBlock,1)
				eval(self:skipBlock,0-i)
				else
				i=eval(self:skipBlock,0-i)
				endif
		endif
		self:_outCurrent()
		self:_stableRowPos:=self:rowPos
		self:_stableColPos:=self:colPos
		self:_stablefreeze:=self:freeze
#ifdef DEBUG_CALL
	 outlog(__FILE__,__LINE__,"stabilize return 5")
#endif
		return self:stable
  endif
  if self:__stablePos==0
	eval(self:skipBlock,0)
	nskip=0
  else
	nskip:=eval(self:skipBlock,1)
	self:__stableSkips+=nskip
  endif
  self:__stablePos++
  self:_outCurrent(self:__stablepos)
  if nskip==0 .and. self:__stablePos>1
	 // дорисовать остаток экрана
	 row:=row()-1; col:=col()
	 self:dummyRows:=0
	 for i=self:__stablePos to self:rowcount
	self:__dummyRow(i)
		self:dummyRows++
	 next
	 devpos(row,col)
	 self:__stablePos:=i
  endif
#ifdef DEBUG_CALL
	 outlog(__FILE__,__LINE__,"stabilize return 6")
#endif
return self:stable
*********************************
static function __checkRow()
	   local nskip,xskip
	   if funcname("__CHECKROW") // recursive call
			return
	   endif
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"_checkRow")
#endif
	if ::_stablefreeze!=NIL .and. ::_stablefreeze!=::freeze
		::invalidate()
			::_stablefreeze:=NIL
		endif
	if ::_stableColPos!=NIL .and. ::_stableColPos!=::colPos
			::__colpos:=ascan(::__colVisible,::colpos)
			::_stableColPos:=NIL
				if ::__colpos==0
					::invalidate()
				else
				::__whoVisible(0)
				::__sayTable()
				::refreshAll()
				endif
		endif
	if ::_stableRowPos!=NIL .and. ::_stableRowPos!=::rowPos
		// user program run "::rowPos:=newValue"
				xskip:=::rowPos-::_stableRowPos
				nskip:=xskip
				if !::stable
					if xskip<0
						nskip-=::__stableSkips
						::__stableSkips-=xskip
						else
						nskip=0-::__stableSkips
						::__stableSkips-=xskip
						endif
				endif
		eval(::skipBlock,nskip)
			::_stableRowPos:=NIL
				if ::stable
					::refreshAll()
				endif
	endif
return
*********************************
static function  forceStable
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"forceStable")
#endif
	   do while !::stabilize()
	   enddo
return NIL

*********************************
static func __tdbskip(n)
	LOCAL i:=0
	IF n==NIL .or. n == 0 .OR. RECCOUNT() == 0
		SKIP 0
	ELSEIF n > 0 //.and. RECNO() != RECCOUNT() + 1
		DO WHILE i < n .and. ! EOF()
			SKIP 1
			IF ( EOF() )
				SKIP -1
				EXIT
			ENDIF
			i++
		ENDDO
	ELSEIF n < 0
		DO WHILE i > n
			SKIP -1
			IF ( BOF() )
				EXIT
			ENDIF
			i--
		ENDDO
	ENDIF
RETURN i
*********************************
static function tb_hitTest(mrow,mcol)
	local i
		::mRowPos := ::rowPos
		::mColPos := ::colPos
		if mRow< ::__rect[1] .or. mRow > ::__rect[3]
		return HTNOWHERE
		endif
		if mCol < ::__rect[2] .or. mCol > ::__rect[4]
		return HTNOWHERE
		endif
		::mRowPos := mRow - ::__rect[1]+1
		for i = 1 to len(::__whereVisible)
			if ::__whereVisible[i] > mcol
						exit
				endif
		next
		::mColpos := ::__colVisible[i-1]
return HTCELL

*********************************
static function	tb_set_default_keys()
	local m
	::__keys := map()
		m:=::__keys
		m[K_DOWN] 	:= { |oTb,nKey| oTb:down(), 	TBR_CONTINUE }
		m[K_UP] 	:= { |oTb,nKey| oTb:up(), 	TBR_CONTINUE }
		m[K_END]  	:= { |oTb,nKey| oTb:end(), 	TBR_CONTINUE }
		m[K_HOME]  	:= { |oTb,nKey| oTb:home(), 	TBR_CONTINUE }
		m[K_LEFT]  	:= { |oTb,nKey| oTb:left(), 	TBR_CONTINUE }
		m[K_RIGHT]  	:= { |oTb,nKey| oTb:right(), 	TBR_CONTINUE }
		m[K_PGDN]  	:= { |oTb,nKey| oTb:pageDown(), TBR_CONTINUE }
		m[K_PGUP]  	:= { |oTb,nKey| oTb:pageUp(), 	TBR_CONTINUE }
		m[K_CTRL_PGDN]  := { |oTb,nKey| oTb:goBottom(), TBR_CONTINUE }
		m[K_CTRL_PGUP]  := { |oTb,nKey| oTb:goTop(), 	TBR_CONTINUE }
		m[K_CTRL_END]  	:= { |oTb,nKey| oTb:panEnd(), 	TBR_CONTINUE }
		m[K_CTRL_HOME]  := { |oTb,nKey| oTb:panHome(), 	TBR_CONTINUE }
		m[K_CTRL_LEFT]  := { |oTb,nKey| oTb:panLeft(), 	TBR_CONTINUE }
		m[K_CTRL_RIGHT] := { |oTb,nKey| oTb:panRight(),	TBR_CONTINUE }

		m[K_ESC]  	:= { |oTb,nKey| TBR_EXIT }
//        m[K_ENTER]  	:= { |oTb,nKey| TBR_EXIT }
		m[K_LBUTTONDOWN]:= { |oTb,nKey| tbMouse(oTb,mrow(),mcol()) }
return
*********************************
static function tb_setkey(nKey,value)
	local ret,m := ::__keys

	if nkey $ m
			ret := m[nKey]
		endif
		if pcount() > 2   /* self as first parameter */
			m[nKey] := value
		endif
		if nKey $ m .and. m[nKey] == NIL
			adel(m ,nKey)
		endif
return ret

*********************************
static func __applykey(browse,nkey)
	local b, ret:=TBR_CONTINUE
		b := browse:setkey(nKey)
		if b != NIL
			ret := eval(b,browse,nkey)
		else
			b := browse:setkey(0)
			if b != NIL
				ret := eval(b,browse,nkey)
			else
			ret:=TBR_EXCEPTION
			endif
	endif
return ret

