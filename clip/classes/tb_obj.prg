/*
	Copyright (C) 2001  ITK
	Author   : Uri (uri@itk.ru)
	License : (GPL) http://www.itk.ru/clipper/license.html

	Изменения в функциях
	    refreshCurrent
	    refreshAll
	    cleft
	    cright
	    stabilize
	    функция  panRight работает не совсем правильно

	20.07.2004 john (sneshka@online.bryansk.ru)

*/

#include "tbrowse.ch"
#include "inkey.ch"
#include "button.ch"

//#define TBR_CACHED
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
	   lRow := iif(lRow == NIL, 0, lRow)
	   lCol := iif(lCol == NIL, 0, lCol)
	   rRow := iif(rRow == NIL, MaxRow(), rRow)
	   rCol := iif(rCol == NIL, MaxCol(), rCol)
	   obj		:= map()
	   obj:nTop	:=Lrow
	   obj:nLeft	:=Lcol
	   obj:nBottom	:=Rrow
	   obj:nRight	:=Rcol
	   obj:classname:= "TBROWSE"
	   obj:autoLite	:= .t.
	   obj:cargo	:= NIL
	   obj:colCount	:= 0
	   obj:colorSpec:= setcolor()
	   obj:colPos	:= 1
	   obj:rowPos	:= 1
	   obj:mColPos	:= 0
	   obj:mRowPos	:= 0
	   obj:rowcount	:= rRow-lrow+1
	   obj:colSep	:= " "
	   obj:headSep	:= ""
	   obj:footSep	:= ""
	   obj:freeze	:= 0
	   obj:leftVisible	:= 1
	   obj:rightVisible	:= 1
	   obj:message	:= ""
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
	   obj:cursorCol:=0
	   obj:cursorRow:=0
	   obj:cursorLen:=0

	  *************************************
	  obj:__firstStab	:=.f.  // был ли первый stabilize
	  obj:__rect	:={0,0,0,0}

	  obj:__colorCells	:={}  // items for colorRect()
#ifdef TBR_CACHED
	  obj:__dataCache	:={}  // cache for output data
#endif
	  obj:__columns	:={}

	  obj:__lRedrawTable    := .t. // need redraw headers & footers
	  obj:__columnsLen	:={} // длины колонок
	  obj:__colVisible	:={} // видимые колонки
	  obj:__colpos		:=1  // текущая колонка из числа видимых
	  obj:__whereVisible	:={} // row для каждой видимой колонки
	  obj:__headStrings	:={} // надписи заголовков по строкам
	  obj:__footStrings	:={} // надписи подвалов по строкам

	  obj:__colors	:={} // палитры цветов
	  obj:__keys	:=map() // array for ::setkey()

	  obj:__refreshLine     :={}
	  obj:__headRows	:=0  // строк в заголовке
	  obj:__footRows	:=0  // строк в подвале

	  obj:__rightAll	:=.f. // больше справа никого нет

	  obj:winbuffer		:= NIL

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
	obj:__getColor	:= @__getcolor()
//	obj:__checkRow	:= @__checkRow()
	obj:__lenColSep := @__lenColSep()


	tb_set_default_keys(obj)

return obj

**********************************************************
static func __lenColSep(num)
	local colSep
	colSep:=::__columns[num]:colSep
	colsep:=iif(colSep==NIL,::colSep,colSep)
return	len(colSep)
**********************************************************
static func __whoVisible(num)
	   local i,cnum,leftcol,scol,oldcol,col,mincol,maxcol
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"whoVisible",num)
#endif
	   if empty(::__columns)
		return
	   endif
	   cnum=iif(num==NIL,0,num)

	   ::freeze:=max(::freeze,0)
	   ::freeze:=min(::freeze,::colCount)
	   if (empty(::__colVisible))
		col    := 1  // ::colpos
		oldcol := ::colpos
	   else
		if num == NIL
			col := ::__colVisible[1]
		else
			col:=min(max(::__colPos,::freeze+1),::colCount)
			if col <= len(::__colVisible)
				col:=::__colVisible[col]
			endif
		endif
		oldcol:=max(1,min(::colCount,::colPos))
	   endif
	   scol:=::__rect[2]
	   leftcol:=scol
	   for i=1 to ::freeze
		leftcol+=::__columnsLen[i]+::__lenColSep(i)
	   next
	   while i<=::colCount .and. leftcol>::nRight-3 .and. ::freeze>0
		leftcol-=::__columnsLen[i]+::__lenColSep(i)
		::freeze--
	   enddo
	   leftcol:=max(leftcol,::__rect[2])
	   ::__colVisible:={}
	   ::__whereVisible:={}
	   for i=1 to ::freeze
		aadd(::__colVisible,i)
		aadd(::__whereVisible,scol)
		scol+=::__columnsLen[i]+::__lenColSep(i)
	   next
	   *
	   col+=cnum
	   col=min(max(min(col,::colCount),::freeze+1),::colCount)
	   if cnum>=0 .and. num != NIL
			scol:=::__rect[4]-(::__columnsLen[col]+::__lenColSep(col))
			while scol>leftcol .and. col > ::freeze+1
				col--
				scol-=::__columnsLen[col]+::__lenColSep(col)
			enddo
			if scol<leftcol .and. (col<=oldcol .or. cnum >= ::colCount) .and. cnum>0
				col++
			endif
	   endif
	   mincol:=col
	   scol:=leftcol
	   while scol<::__rect[4] .and. col<=::colCount
		scol+=::__columnsLen[col]+::__lenColSep(col)
		col++
	   enddo
	   scol--
	   col--
	   col=min(col,::colCount)
	   col=max(1,col)
	   maxcol:=col
	   if (col>1 .and. !::chop .and. ::colCount>1 .and. scol-::__lenColSep(col)>::__rect[4] .and. mincol!=maxcol) .or. cnum>::colCount
			if cnum < ::colCount
				col--
				maxcol:=col
			endif
			scol:=::__rect[4]-(::__columnsLen[col]+::__lenColSep(col))
			while scol>leftcol .and. col>1
				col--
				scol-=::__columnsLen[col]+::__lenColSep(col)
			enddo
			if scol+::__lenColSep(col)<leftcol
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
	   ::leftVisible := mincol
	   for col=mincol to maxcol
		aadd(::__colVisible,col)
		aadd(::__whereVisible,scol)
		scol+=::__columnsLen[col]+::__lenColSep(col)
	   next
	   if empty(::__colVisible)
		aadd(::__colVisible,col)
		aadd(::__whereVisible,scol)
	   endif
	   ::rightVisible := atail(::__colVisible)
	   for i=1 to len(::__colVisible)
		if ::__colVisible[i]==oldcol+cnum
			col:=::__colVisible[i]
			::__colPos=i
		endif
	   next
	   ::__rightAll := (maxcol==::colcount)
	   ::__colPos:=min(::__colPos,len(::__colVisible))
	   ::__colPos:=max(::__colPos,1)
	   ::colpos:=::__colVisible[::__colpos]
	   ::__lRedrawTable := .t.
return NIL

*********************************
static func __sayTable
   local visLen,col,colSep,lensep,lenhsep
   //local strsep1,strsep2
   local strseph,scol,len,strings
   local i,j,k,s,ccc,headsep,strhsep1, x,y
   local heading:=.t., footing:=.t.
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"sayTable")
#endif
   if ::winbuffer==nil; dispBegin(); endif

   visLen= len(::__colVisible)
   j=0;k=0
   for i=1 to visLen
	col=::__colVisible[i]
	headSep:=::__columns[col]:headSep
	if headSep!=NIL .and. headSep==""
	   j++
	endif
	headSep:=::__columns[col]:footSep
	if headSep!=NIL .and. headSep==""
	   k++
	endif
   next
   heading := !(j==visLen)
   footing := !(k==vislen)
   for i=1 to visLen
	col=::__colVisible[i]
	len=::__columnsLen[col]
	colSep:=::__columns[col]:colSep
	colsep:=iif(colSep==NIL,::colSep,colSep)
	lenSep:=len(colSep)
	//strsep1:=iif(lenSep>2,substr(colsep,3,1),"")
	//lenSep:=iif(lenSep==3,3,1)
	//strsep1:=space(len(strsep1))
	//strsep2:=substr(colsep,1,2)
	//strsep2:=space(len(strsep2))
	scol=::__whereVisible[i]
	//len=min(len,::nright-scol-lenSep+len(strSep2))
	if vislen !=1
		len=min(len,::nright-scol-lenSep)
	endif
	strings:=::__HeadStrings[col]
	ccc:=::__getcolor(1)
	if ::__columns[col]:defColor!=NIL
		ccc:=::__getcolor(::__columns[col]:defColor[1])
	endif
	if ::__columns[col]:colorHeading!=NIL
		ccc:=::__getcolor(::__columns[col]:colorHeading)
	endif
	for j=1 to len(strings )
		dispOutAt(::nTop+j-1, scol,space(::nRight-scol),::__getcolor(1))
		s=padr(strings[j],len)
		y := ::nTop+j-1
		x := scol
		dispOutAt(::nTop+j-1, scol,"")
		if ::__columns[col]:colSepH != nil
			strseph:=substr(::__columns[col]:colSepH,j,1)
			if ::winbuffer == nil
				dispOutAt(::nTop+j-1, scol,strseph,::__getcolor(1))
			else
				winbuf_out_at(::winbuffer,::nTop+j-1, scol,strseph,::__getcolor(1))
			endif
			x := scol + len(strseph)
		else
			if ::winbuffer == nil
				//dispOutAt(::nTop+j-1, scol,colsep,::__getcolor(1))
			else
				//winbuf_out_at(::winbuffer,::nTop+j-1, scol,strsep1,::__getcolor(1))
			endif
			//x := scol + len(strsep1)
			x := scol + len(colsep)
		endif
		if ::winbuffer == nil
			dispOut(s,ccc)
			//dispOut(iif(i<visLen,colSep,""),::__getcolor(1))
			//dispOut(iif(i<visLen,strSep2,""),::__getcolor(1))
		else
			winbuf_out_at(::winbuffer,y,x,s,ccc)
			x += len(s)
			//winbuf_out_at(::winbuffer,y,x,iif(i<visLen,strSep2,""),::__getcolor(1))
			//x += len(iif(i<visLen,strSep2,""))
		endif
		if i==visLen
			if ::winbuffer == nil
				dispout(space(::nRight-col()+1),::__getcolor(1))
			else
				winbuf_out_at(::winbuffer,y,x,space(::nRight-col()+1),::__getcolor(1))
			endif
		endif
	next
	headSep:=::__columns[col]:headSep
	headSep:=iif(headSep==NIL,::headSep,headSep)
	lenHSep=len(headSep)
	strhsep1=right(headsep,1)
	j:=len(strings)
	if heading .and. ((j>0 .and. lenHSep>0 ) .or. !empty(::headSep))
		if ::__columns[col]:colSepH != nil .and. len(::__columns[col]:colSepH)>j
			strseph:=substr(::__columns[col]:colSepH,j+1,1)
			if ::winbuffer == nil
				dispOutAt(::nTop+j, scol-1, strseph,::__getcolor(1))
			else
				winbuf_out_at(::winbuffer,::nTop+j, scol-1, strseph,::__getcolor(1))
			endif
		endif
		//s := replicate(strHsep1,len+lenSep-lenHsep)+iif(i<visLen,headsep,"")
		if i==1
			s := replicate(strHsep1,len)
			x := scol
		else
			s := headsep+replicate(strHsep1,len+lenSep-lenHsep)
			x := scol-lenSep
		endif
		if ::winbuffer == nil
			dispOutAt(::nTop+j, x,s, ::__getcolor(1))
		else
			winbuf_out_at(::winbuffer,::nTop+j, x, s, ::__getcolor(1))
		endif
		y := ::nTop+j; x := scol + len(s)
		if i==vislen
			if ::winbuffer == nil
				dispout(replicate(strHsep1,::nright-col()+1),::__getcolor(1))
			else
				winbuf_out_at(::winbuffer,y,x, replicate(strHsep1,::nright-col()+1),::__getcolor(1))
			endif
		endif
		j++
	endif
	::__rect[1]=::nTop+j
	strings:=::__footStrings[col]
	ccc:=::__getcolor(1)
	if ::__columns[col]:defColor!=NIL
		ccc:=::__getcolor(::__columns[col]:defColor[1])
	endif
	if ::__columns[col]:colorFooting!=NIL
		ccc:=::__getcolor(::__columns[col]:colorFooting)
	endif
	for j=1 to len(strings)
		s=padr(strings[j],len+lenSep)
		//outlog(__FILE__,__LINE__,strings[j],s,len,ccc)
		if ::winbuffer == nil
			//dispOutAt(::nBottom-j+1, scol, strsep1, ::__getcolor(1))
			dispOutAt(::nBottom-j+1, scol, s, ccc)
			//dispOut(s, ccc)
			//dispOut(iif(i<visLen,strSep2,"") , ::__getcolor(1))
			if i==visLen
				dispout(space(::nRight-col()+1),::__getcolor(1))
			endif
		else
			//winbuf_out_at(::winbuffer,::nBottom-j+1, scol, strsep1, ::__getcolor(1))
			y := ::nBottom-j+1
			//x := scol + len(strsep1)
			winbuf_out_at(::winbuffer,y,x,s,ccc)
			x += len(s)
			//winbuf_out_at(::winbuffer,y,x,iif(i<visLen,strSep2,"") , ::__getcolor(1))
			//x += len(iif(i<visLen,strSep2,""))
			if i==visLen
				winbuf_out_at(::winbuffer,y,x,space(::nRight-col()+1),::__getcolor(1))
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
	if footing .and. lenHSep>0  .and. !empty(headSep)
		//s := replicate(strHsep1,len)+iif(i<visLen,headsep,"")
		if i==1
			s := replicate(strHsep1,len)
			x := scol
		else
			s := headsep+replicate(strHsep1,len+lenSep-lenHsep)
			x := scol-lenSep
		endif
		if ::winbuffer == nil
			dispOutAt(::nBottom-j, x, s , ::__getcolor(1))
			if i==vislen
				dispOut(replicate(strHsep1,::nright-col()+1),::__getcolor(1))
			endif
		else
			winbuf_out_at(::winbuffer,::nBottom-j, x, s, ::__getcolor(1))
			y := ::nBottom-j+1
			x := scol + len(s)
			if i==vislen
				winbuf_out_at(::winbuffer,y,x,replicate(strHsep1,::nright-col()+1),::__getcolor(1))
			endif
		endif
		j++
	endif
	::__rect[3]=::nBottom-j
   next
   ::rowCount:=::__rect[3]-::__rect[1]+1
   if ::winbuffer==nil
	dispEnd()
   endif
   ::__lRedrawTable := .f.

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
	  //hr:=iif(empty(h),0,occurs(";",h)+1)
	  hr:=iif(h==NIL .or. h=="",0,occurs(";",h)+1)
	  max_hr:=max(max_hr,hr)
	  f:=::__columns[i]:footing
	  hf:=iif(f==NIL .or. f=="",0,occurs(";",f)+1)
	  max_hf:=max(max_hf,hf)
   next
   ::__columnsLen:={}
   for i=1 to len(::__columns)
	  clen:=0
	  aadd(::__headStrings,{})
	  h:=::__columns[i]:heading
	  //hr:=iif(empty(h),0,occurs(";",h)+1)
	  hr:=iif(h==NIL .or. h=="",0,occurs(";",h)+1)
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
	  hf:=iif(f==NIL .or. f=="",0,occurs(";",f)+1)
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
	  if !empty(::__columns[i]:width) .and. valtype(::__columns[i]:width)=="N"
		clen:=::__columns[i]:width
	  elseif valtype(::__columns[i]:picture)=="C" .or. valtype(::__columns[i]:len)!="N"
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
		clen:=max(clen,len(data))
	  else
		clen:=max(clen,::__columns[i]:len)
	  endif

	  aadd(::__columnsLen,clen)
   next
   ::__headRows:=max_hr-iif(empty(::headSep),1,0)
   ::__footRows:=max_hf
   ::__rect:={::ntop+::__headRows,::nleft,::nbottom-::__footRows,::nright}
   //outlog(__FILE__,__LINE__,::__rect)
   ::rowCount:=::__rect[3]-::__rect[1]+1
   //::__colorCells:={}
   asize(::__colorCells,::rowCount)
   for i=1 to len(::__colorCells)
	::__colorCells[i]={}
	asize(::__colorCells[i],len(::__columns))
	afill(::__colorCells[i],NIL)
	//afill(::__colorCells[i],{1,2})
	/*
	for j=1 to len(::__colorCells[i])
		::__colorCells[i][j]:= ::__columns[j]:defColor
	next
	*/
   next
#ifdef TBR_CACHED
   asize(::__dataCache,::rowCount)
   for i=1 to len(::__dataCache)
	::__dataCache[i]={}
	asize(::__dataCache[i],len(::__columns))
	for j=1 to len(::__dataCache[i])
		::__dataCache[i][j]={}
		asize(::__dataCache[i][j],3)
		afill(::__dataCache[i][j],NIL)
	next
   next
#endif

    ::__refreshLine:=array(::rowCount)
    afill(::__refreshLine,0)

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
	   /*
	   if len(::__colors) < 1
		aadd(::__colors,"W/N")
	   endif
	   if len(::__colors) < 2
		aadd(::__colors,nToColor(invertAttr(::__colors[1])))
	   endif
	   */
	   //outlog(__FILE__,__LINE__,::__colors)

	   /*
	   for i=len(::__colors) to 10
		aadd(::__colors,"n/w" /*"W/N" */)
	   next
	   */
return NIL
*********************************
static func __getcolor(self,num)
	local len,ret := "W/N"
	len := Len(self:__colors)
	if len>1
		ret := atail(self:__colors)
	endif
	if num>0 .and. num<=len
		ret := self:__colors[num]
	elseif num>1
		ret := nToColor(invertAttr(ret))
	endif
return ret

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
	::stable := .f.
	::__firstStab := .f.
	::__columns[pos]=col
	/*
	if ::__firstStab
	   ::__remakeColumns()
	endif
	*/
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
static func refreshCurrent(self)
	local i,j
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"refreshCurrent")
#endif
	i:=self:rowpos
	self:hitTop:=self:hitBottom:=.f.
	if !self:__firstStab .or. i < 1
		return self
	endif
	self:__refreshLine[i] := 0
	//afill(self:__colorCells[self:rowPos],{1,2})
	afill(self:__colorCells[i],NIL)
	/*
	for j=1 to len(self:__colorCells[i])
		self:__colorCells[i][j]:=self:__columns[j]:defColor
	next
	*/
	self:stable:=.f.
return self

*********************************
static func refreshAll(self)
	local i,j,tmp
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"refreshAll")
#endif

	self:hitTop:=self:hitBottom:=.f.
	if(  self:__firstStab )
		afill(self:__refreshLine,0)
	endif
	self:stable:=.f.
	   for i=1 to len(self:__colorCells)
		tmp := self:__colorCells[i]
		afill(tmp,NIL)
		/*
		for j=1 to len(tmp)
			tmp[j]:=self:__columns[j]:defColor
		next
		*/
	   next

return self

*********************************
static func down(self)
	local nskip

	self:hitTop:=self:hitBottom:=.f.
	nskip:=eval(self:skipBlock,1)
	if nskip=0
		self:hitBottom=.t.
	else
		if self:rowpos >= self:rowCount
			self:refreshAll()
		else
			self:refreshCurrent()
			self:rowpos++
			self:refreshCurrent()
		endif
	endif
return self

*********************************
static func up(self)
	local oldrow,nskip

	self:hitTop:=self:hitBottom:=.f.
	nskip:=eval(self:skipBlock,-1)
	if nskip==0
		self:hitTop:=.t.
	else
		if self:rowpos<2
			self:refreshAll()
		else
			self:refreshCurrent()
			self:rowpos--
			self:refreshCurrent()
		endif
	endif
return self

*********************************
static func cleft(self)

	self:hitTop:=self:hitBottom:=.f.
	if self:__colpos==1
		if self:__colVisible[1] > 1
			self:__whoVisible(-1)
			self:refreshAll()
		endif
	else
		self:__colPos--
		if len(self:__colVisible) > self:freeze .and. ;
		    self:__colVisible[self:freeze+1] > self:freeze+1 .and. ;
		    self:__colPos <= self:freeze
			self:__colPos++
			self:__whoVisible(-1)
			self:refreshAll()
		else
			self:colpos:=self:__colVisible[self:__colpos]
			self:_outCurrent()
		endif
	endif
return self

*********************************
static func cright(self)

	self:hitTop:=self:hitBottom:=.f.
	if self:__colpos==len(self:__colVisible)
		if ! self:__rightAll
			self:__whoVisible(1)
			self:refreshAll()
		endif
	else
		self:__colPos++
		self:colpos:=self:__colVisible[self:__colpos]
		self:_outCurrent()
	endif
return self

*********************************
static func goBottom(self)
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"goBottom")
#endif
	self:hitTop:=self:hitBottom:=.f.
	if self:gobottomBlock!=NIL
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
	self:hitTop:=self:hitBottom:=.f.
	if self:gotopBlock!=NIL
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
	self:hitTop:=self:hitBottom:=.f.
	xskip=self:rowCount
	nskip=eval(self:skipBlock,xskip)

	if nskip <> 0
		if nskip < xskip
			self:hitBottom := .t.
			self:rowPos+=nskip
			self:rowPos=max(min(self:rowPos,self:__rect[3]-self:__rect[1]+1),1)
		endif
		self:refreshAll()
	endif
return self

*********************************
static func pageUp(self)
	local xskip,nskip
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"pageUp")
#endif
	self:hitTop:=self:hitBottom:=.f.
	xskip=0-self:rowCount
	nskip=eval(self:skipBlock,xskip)
	if nskip<>0
		if nskip>xskip
			self:hitTop := .t.
			self:rowPos:=self:rowpos-nskip+xskip
			self:rowpos:=max(1,self:rowpos)
		endif
		self:refreshAll()
	endif
return self

*********************************
static func home(self)
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"Home")
#endif
	self:hitTop:=self:hitBottom:=.f.
	self:__colPos:=min(max(1,self:freeze+1),self:colCount)
	self:colpos:=self:__colVisible[self:__colpos]
	self:_outCurrent()

return self

*********************************
static func end(self)
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"End")
#endif
	self:hitTop:=self:hitBottom:=.f.
	if self:__colPos <> len(self:__colVisible)
		self:__colPos:=len(self:__colVisible)
		self:colpos:=self:__colVisible[self:__colpos]
		self:_outCurrent()
	endif
return self

*********************************
static func panHome(self)

	self:hitTop:=self:hitBottom:=.f.
	if self:__colpos <> 1 .or.  self:__colVisible[1] <> 1
		self:__colpos:=1
		self:__whoVisible(0-self:colCount)
		self:refreshAll()
	endif

return self

*********************************
static func panEnd(self)

	if self:__colpos <> len(self:__colVisible) .or.	! self:__rightAll
		self:__colpos:=self:colcount+1
		self:__whoVisible(self:__colPos)
		self:__colpos:=len(self:__colVisible)
		self:colPos:=self:__colVisible[self:__colPos]
		self:refreshAll()
	endif

return self

/*
*********************************
static func panLeft(self)
	local i,j
	if self:__colPos > self:freeze
		i=self:colPos
		self:__colPos:=self:freeze+1
		self:__whoVisible(-1)

		for j=1 to len(self:__colVisible)
			if i = self:__colVisible[j]
				self:__colPos:=j
				exit
			endif
		next
		self:colPos:=self:__colVisible[self:__colPos]
		self:refreshAll()
	endif
return self
*/
*********************************
static func panLeft(self)
	local i,j,k
	if self:freeze >=len(self:__colVisible)
		return self
	endif
	if self:__colVisible[self:freeze+1] == self:freeze+1
		return self
	endif

	i=self:colPos
	k=self:__colPos
	self:__colPos=self:freeze+1
	self:colPos=self:__colVisible[self:__colPos]
	self:__whoVisible(-1)
	self:__colPos=k
	for j=1 to len(self:__colVisible)
		if i = self:__colVisible[j]
			self:__colPos=j
			exit
		endif
	next
	self:colPos=self:__colVisible[self:__colPos]
	self:refreshAll()
return self

/*
*********************************
static func panRight(self)
	local i,j
	if ! self:__rightAll
		i=self:colpos
		self:__colPos:=len(self:__colVisible)
		self:__whoVisible(1)
		for j=1 to len(self:__colVisible)
			if i = self:__colVisible[j]
				self:__colPos:=j
				exit
			endif
		next

		self:colPos:=self:__colVisible[self:__colPos]
		self:refreshAll()
	endif
return self
*/
*********************************
static func panRight(self)
	local i,j,k
	if self:__rightAll
		return self
	endif
	i=self:colpos
	k=self:__colPos
	self:__colPos=len(self:__colVisible)
	self:colPos=self:__colVisible[self:__colPos]
	self:__whoVisible(1)
	self:__colPos=k
	for j=1 to len(self:__colVisible)
		if i = self:__colVisible[j]
			self:__colPos=j
			exit
		endif
	next

	self:colPos=self:__colVisible[self:__colPos]
	self:refreshAll()

return self

*********************************
static func deHilite(self)
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"dehilite")
#endif
	self:_outCurrent(NIL,.f.)
return self

*********************************
static func hilite(self)
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"hilite")
#endif
	self:_outCurrent(NIL,.t.)
return self

*********************************
static func colorRect(self,rect,block)   /////  ?????????
	local i,j,m1,m2,m3,m4
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"colorRect",block,rect)
#endif
	if !(valtype(rect)=="A" .and. len(rect)==4)
		return self
	endif
	if empty(block)
		block:={1,2}
	endif
#ifdef __1
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
#else
	dispBegin()
	m1:=max(1,rect[1])
	m2:=max(1,rect[3])
	for i=m1 to m2
		if len(self:__colorCells) <i
			aadd(self:__colorCells,{})
		endif
		m3:=max(1,rect[2])
		m4:=max(1,rect[4])
		for j=m3 to m4
			if len(self:__colorCells[i]) <j
				aadd(self:__colorCells[i],{1,2})
			endif
			self:__colorCells[i][j]:=block
		next
		self:_outCurrent(i,.t.)
	next
	dispEnd()
#endif
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
	 self:refreshAll()
return self

*********************************
static func configure(self)
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"configure")
#endif
	 self:stable := .f.
	 self:__firstStab := .f.
	 self:__setColor()
return self
*********************************
static func stabilize(self)
  local i,nskip,row,col,nstab,j,k
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"stabilize")
#endif
   if empty(self:__columns)
	return .t.
   endif

  if !self:__firstStab
	 self:__setcolor()
	 self:rowPos=min(self:rowPos,self:rowCount)
	 self:__remakeColumns()
	 self:__whoVisible()
	 self:__firstStab:=.t.
  endif

  if self:__lRedrawTable
	self:__sayTable()
  endif

  i:=ascan(self:__colVisible,self:colPos)
  if i>0
	self:__colPos := i
  else
	self:configure()
	return .f.
  endif

  if !self:stable
     nstab=0
     for j=1 to self:rowCount
       if self:__refreshLine[j]=0
	  nstab=1
	  self:__refreshLine[j]=1
	  nskip=j-self:rowPos
	  k:=eval(self:skipBlock,nskip)

	  if k == nskip
	     self:_outCurrent(j)
	  elseif nskip>0
	    row:=row()-1; col:=col()
	     for i=j to self:rowCount
		self:__dummyRow(i)
		self:__refreshLine[i]=1
	     next
	     //devpos(row,col)   // ?????

	  elseif nskip<0
	     self:rowPos=1
	     self:refreshAll()
	  endif

	  eval(self:skipBlock,-k)

	  exit
       endif
     next
   if nstab=0
	self:stable=.t.
   endif
  endif
  self:_outCurrent()
return self:stable
*********************************
static func _outCurrent ( row, hilite, fSay )
   local i,col,vislen,data,datat,srow,cblock
   local colsep,lensep,scol,ecol,len,lenc
   local xcur:=NIL,ycur:=::nLeft,lencur:=0,xcolor,ccolors:="",x,y
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"_outCurrent",row)
#endif
   if !::__firstStab
	return
   endif
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
	draw_rect(xcur,::nLeft,xcur,::nright,colorToN(::__getcolor(1)))
   endif
   for i=1 to visLen
	  col=::__colVisible[i]
	  colSep:=::__columns[col]:colSep
	  colsep:=iif(colSep==NIL,::colSep,colSep)
	  lenSep:=len(colSep)
	  scol=::__whereVisible[i]
	  ccolors:=::__columns[col]:defcolor
	  //ccolors:=::__colorCells[srow][col]
#ifdef TBR_CACHED
	  if ::__dataCache[sRow][col][1] == NIL
		if ::__columns[col]:fieldName == NIL
			data:=eval(::__columns[col]:block)
		else
			data:=eval(::__columns[col]:block,::__columns[col]:fieldName)
		endif
		::__dataCache[sRow][col][1] := data
		datat:=valtype(data)
		if datat == "U" .and. ::__columns[col]:type != NIL
			datat := ::__columns[col]:type
		endif
		cblock=::__columns[col]:colorBlock
		if valtype(cblock)=="B" //.and. ccolors[1]==1 .and. ccolors[2]==2
			ccolors:=eval(cblock,data)
		endif
		::__dataCache[sRow][col][2] := ccolors
		if valtype(::__columns[col]:picture)=="C"
			data:=transform(data,::__columns[col]:picture)
		elseif valtype(::__columns[col]:len)=="N"
			switch valtype(data)
				case "N"
					data := str(data, ::__columns[col]:len)
					//data := padl( toString(data), ::__columns[col]:len )
				case "U"
					data := space( ::__columns[col]:len )
				otherwise
					data := padr( toString(data), ::__columns[col]:len )
			endswitch
		else
			if valtype(data) == "N"
				data := str(data, ::__columnsLen[col])
			else
				data := toString(data)
			endif
		endif
		::__dataCache[sRow][col][3] := data
	  else
		datat:=valtype(::__dataCache[sRow][col][1])
		ccolors := ::__dataCache[sRow][col][2]
		data := ::__dataCache[sRow][col][3]
	  endif
#else
	  if ::__columns[col]:fieldName == NIL
		data:=eval(::__columns[col]:block)
	  else
		data:=eval(::__columns[col]:block,::__columns[col]:fieldName)
	  endif
	  datat:=valtype(data)
	  if datat == "U" .and. ::__columns[col]:type != NIL
		datat := ::__columns[col]:type
	  endif
	  cblock=::__columns[col]:colorBlock
	  if valtype(cblock)=="B" //.and. ccolors[1]==1 .and. ccolors[2]==2
		ccolors:=eval(cblock,data)
	  endif

	  if valtype(::__columns[col]:picture)=="C"
		data:=transform(data,::__columns[col]:picture)
	  elseif valtype(::__columns[col]:len)=="N"
		switch valtype(data)
			case "N"
				data := str(data, ::__columns[col]:len )
				//data := padl( toString(data), ::__columns[col]:len )
			case "U"
				data := space( ::__columns[col]:len )
			otherwise
				data := toString(data)
		endswitch
	  else
		if valtype(data) == "N"
			if left(str(data),1) == "*"
				data := str(data, ::__columnsLen[col])
			else
				data := str(data)
			endif
		else
			data:=toString(data)
		endif
	  endif
#endif
	  if .t. //!(srow==::rowPos .and. i==::__colPos .and. row>0)
		if !empty(::__colorCells[srow][col])
			ccolors:=::__colorCells[srow][col]
		endif
	  endif
	  len=min(::__columnsLen[col],len(data))
	  lenc=max(::__columnsLen[col],len)
	  len=min(len,::nright-scol)
	  lenc=min(lenc,::nright-scol)
	  ecol=min(scol+::__columnsLen[col],::nright)
	  if vislen==1 .or. i==vislen //.or. vislen==len(::__columns)
		len++; lenc++
	  endif
	  //data:=padr(data,len)
	  data:=left(data,len)
	  xcolor:=::__getcolor(ccolors[1])
	  if hilite .and. row >0
		switch ( ::hiliteType )
		case 0
		case 1
			if srow==::rowPos .and. i==::__colPos .and. row>0
				xcolor:=::__getcolor(ccolors[2])
			endif
		case 2
			if srow==::rowPos
				xcolor:=::__getcolor(ccolors[2])
			endif
		endswitch
	  endif
	  if srow==::rowPos .and. i==::__colPos .and. row>0
		xcur:=::__rect[1]-1+srow
		ycur:=scol
		lencur := len
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
				dispout(space(lenc-len),::__getcolor(1))
			else
				winbuf_out_at(::winbuffer,y,x,space(lenc-len),::__getcolor(1))
				x += lenc-len
			endif
		  endif
		  if datat $ "L"
			if ::winbuffer == nil
				dispout(space((lenc-len)/2),::__getcolor(1))
			else
				winbuf_out_at(::winbuffer,y,x,space((lenc-len)/2),::__getcolor(1))
				x += (lenc-len)/2
			endif
		  endif
		  if ::winbuffer == nil
			dispOut(data, xcolor)
			//dispOut(space(ecol-col()), xcolor)
			dispOut(space(ecol-col()), ::__getcolor(1))
			if i==vislen //.and. fSay
				dispOut(space(::nRight-col()+1),::__getcolor(1))
			else
				dispOut(colsep,::__getcolor(1))
			endif
		  else
			winbuf_out_at(::winbuffer,y,x,data, xcolor)
			x += len(data)
			//dispOut(space(ecol-col()), xcolor)
			winbuf_out_at(::winbuffer,y,x,space(ecol-x), ::__getcolor(1))
			x := ecol
			if i==vislen //.and. fSay
				winbuf_out_at(::winbuffer,y,x,space(::nRight-col()+1),::__getcolor(1))
			else
				winbuf_out_at(::winbuffer,y,x,colsep,::__getcolor(1))
			endif
		  endif
	  endif
   next
   if hilite .and. ::hiliteType==3 .and. srow==::rowPos .and. row!=0
	xcolor:=colorToN(::__getcolor(ccolors[2]))
	if ::winbuffer == nil
		draw_rect(xcur,::nLeft,xcur,::nright,xColor)
	else
	endif
   endif
   //setpos(xcur,ycur)
   ::cursorCol:=ycur
   ::cursorRow:=xcur
   ::cursorLen:=lencur
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
		dispOutAt(::__rect[1]-1+srow ,scol,space(len), ::__getcolor(1))
		if i==vislen
			dispOut(space(::nRight-col()+1),::__getcolor(1))
		else
			dispOut(colsep,::__getcolor(1))
		endif
	  else
		winbuf_out_at(::winbuffer,::__rect[1]-1+srow ,scol,space(len), ::__getcolor(1))
		y := ::__rect[1]-1+srow; x := scol + len
		if i==vislen
			winbuf_out_at(::winbuffer,y,x,space(::nRight-col()+1),::__getcolor(1))
		else
			winbuf_out_at(::winbuffer,y,x,colsep,::__getcolor(1))
		endif
	  endif
   next
   if ::winbuffer==nil; dispEnd(); endif
return NIL

*********************************
static function  forceStable
#ifdef DEBUG_CALL
	outlog(__FILE__,__LINE__,"forceStable")
#endif
	dispbegin()
	   do while !::stabilize()
	   enddo
	dispend()
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
***********************************
