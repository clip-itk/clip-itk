/*
    Copyright (C) 2001  ITK
    Authors : Uri (uri@itk.ru), Alena (alena@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "config.ch"

*************************************************
function HtmlNew( File, Title)

	local obj:=map()

	obj:className		:= "HTML"
	obj:fileName		:= file
        obj:Title		:= Title
        obj:tags		:= {}

	obj:loadUrl	 	:= @loadUrl()
	obj:WriteToFile 	:= @WriteToFile()
        obj:WriteToHttp		:= @WriteToHttp()
        obj:__write		:= @writeDocument()
        obj:addTag		:= @html_addTag()
        obj:closeTag		:= @html_closeTag()
        obj:setPageColor	:= @html_pageColor()
        obj:setTextColor	:= @html_textColor()
        obj:setBgImage		:= @html_bgImage()
        obj:setCenter		:= @html_Center()
        obj:startFont		:= @html_startFont()
        obj:endFont		:= @html_endFont()
        obj:endFontAll		:= @html_endFontAll()
        obj:__setFont		:= @html_setFont()
        obj:setFontType		:= @html_setFontType()
        obj:say			:= @html_say()
        obj:sayColor		:= @html_sayColor()
        obj:space		:= @html_space()
        obj:putImage		:= @html_putImage()
        obj:text		:= @html_text()
        obj:multiCol		:= @html_multiCol()
        obj:putHeading		:= @html_putHeading()
        obj:hLine		:= @html_hLine()
        obj:paragraph		:= @html_paragraph()
        obj:putBreak		:= @html_putBreak()

        obj:startMarquee	:= @html_startMarquee()
        obj:endMarquee		:= @html_endMarquee()
        obj:__marquee		:= @html_marquee()

        obj:url			:= @html_url()
        obj:imageUrl		:= @html_imageUrl()
        obj:imgUrl		:= @html_imageUrl()

        obj:startTable		:= @html_startTable()
        obj:endTable		:= @html_endTable()
        obj:__table		:= @html_Table()
        obj:THcell		:= @html_THcell()
        obj:startTrow		:= @html_startTrow()
        obj:endTrow		:= @html_endTrow()
        obj:__Trow		:= @html_Trow()
        obj:startTcell		:= @html_startTcell()
        obj:endTcell		:= @html_endTcell()
        obj:__Tcell		:= @html_Tcell()

        obj:startList		:= @html_startList()
        obj:listItem		:= @html_listItem()
        obj:endList		:= @html_endList()
        obj:__List		:= @html_list()

        obj:startSelect		:= @html_startSelect()
        obj:addOption		:= @html_addOption()
        obj:endSelect		:= @html_endSelect()
        obj:__select		:= @html_select()

        obj:startForm		:= @html_startForm()
        obj:endForm		:= @html_endForm()
        obj:__form		:= @html_form()
        obj:inputImage		:= @html_inputImage()
        obj:checkBox		:= @html_checkBox()
        obj:radioBox		:= @html_radioBox()
        obj:formFile		:= @html_formFile()
        obj:formHidden		:= @html_formHidden()
        obj:formPasswd		:= @html_formPasswd()
        obj:formText		:= @html_formText()
        obj:formPassword	:= @html_formPasswd()
        obj:formGet		:= @html_formGet()
        obj:formReset		:= @html_formReset()
        obj:formSubmit		:= @html_formSubmit()

        obj:startFrameSet	:= @html_startFrameSet()
        obj:frame		:= @html_frame()
        obj:endFrameSet		:= @html_endFrameSet()
        obj:__frameSet		:= @html_frameSet()

        obj:addData  		:= @html_addData()
        obj:put	    		:= @html_addData()
        obj:QQout   		:= @html_qqout()
        obj:Qout      		:= @html_qout()
        obj:NewLine  		:= @html_newLine()

	/* Create header for document */
	obj:addTag(html_tagNew("HTML"))
	obj:__head := obj:addTag(html_tagNew("HEAD"))
	obj:__title:= obj:addTag(html_tagNew("TITLE"))
        obj:addData(title)
        obj:closeTag(obj:__title)
        obj:closeTag(obj:__head)
        obj:newLine()
	obj:__body:=obj:addTag(html_tagNew("BODY"))
        obj:newLine()

return obj

*************************************************
static function html_frame(name,url,other,borderColor, frameBorder,;
			marginHeight,marginWidth,noResize,scrolling)
        local n,m
        m:=html_tagNew("FRAME",other)
        m:addField("NAME",name)
        m:addField("SRC",url)
        if borderColor!=NIL
        	m:addField("BORDERCOLOR",borderColor)
        endif
        if frameBorder!=NIL
        	m:addField("FRAMEBORDER",frameBorder)
        endif
        if marginHeight!=NIL
        	m:addField("MARGINHEIGHT",marginHeight)
        endif
        if marginWidth!=NIL
        	m:addField("MARGINWIDTH",marginWidth)
        endif
        if scrolling!=NIL
        	m:addField("SCROLLING",scrolling)
        endif
        if noResize!=NIL .and. noResize
        	m:addField("NORESIZE",noResize)
        endif
	n:=::addTag(m)
        ::newLine()
return n

*************************************************
static function html_startFrameSet(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11)
return ::__frameSet(.t.,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11)
*************************************************
static function html_endFrameSet()
return ::__frameSet(.f.)
*************************************************
static function html_frameSet(lOn,other,cols,rows,border,borderColor,;
				frameBorder,frameSpacing)
	static fStack
        local n,m
	if fStack==NIL
		fStack:=stackNew()
        endif
	if lOn==NIL .or. lOn
        	m:=html_tagNew("FRAMESET",other)
                if cols!=NIL
                	m:addField("COLS",cols)
                endif
                if rows!=NIL
                	m:addField("ROWS",rows)
                endif
                if border!=NIL
                	m:addField("BORDER",border)
                endif
                if borderColor!=NIL
                	m:addField("BORDERCOLOR",borderColor)
                endif
                if frameBorder!=NIL
                	m:addField("FRAMEBORDER",frameBorder)
                endif
                if frameSpacing!=NIL
                	m:addField("FRAMESPACING",frameSpacing)
                endif
		n:=::addTag(m)
                fStack:push(n)
                ::newLine()
        else
        	n:=fStack:pop()
                if n!=NIL
                	n:=::closeTag(n)
                	::newLine()
                endif
        endif
return n

*************************************************
static function html_addOption(value,text,other,selected)
	local ret,m
        m=html_tagNew("OPTION",other)
        m:addField("VALUE",value)
 	if selected!=NIL .and. selected
        	m:addField("","SELECTED")
        endif
        ret:=::addTag(m)
        ::addData(text)
        ::closeTag(ret)
        ::newLine()
return ret

*************************************************
static function html_startSelect(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11)
return ::__select(.t.,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11)
*************************************************
static function html_endSelect()
return ::__select(.f.)
*************************************************
static function html_select(lOn,name,other,size,multiple)
	static sStack
        local n,m
	if sStack==NIL
		sStack:=stackNew()
        endif
	if lOn==NIL .or. lOn
        	m:=html_tagNew("SELECT",other)
                if name!=NIL
                	m:addField("NAME",name)
                endif
                if size!=NIL
                	m:addField("SIZE",size)
                endif
                if multiple!=NIL .and. multiple
                	m:addField("","MULTIPLE")
                endif
		n:=::addTag(m)
                sStack:push(n)
                ::newLine()
        else
        	n:=sStack:pop()
                if n!=NIL
                	n:=::closeTag(n)
                	::newLine()
                endif
        endif
return n
return n

*************************************************
static function html_formText(name,value,size,maxLength,other)
return  ::formGet("TEXT",name,value,size,maxlength,other)

*************************************************
static function html_formPasswd(name,value,size,maxLength,other)
return  ::formGet("PASSWORD",name,value,size,maxlength,other)

*************************************************
static function html_formHidden(name,value,size,maxLength,other)
return  ::formGet("HIDDEN",name,value,size,maxlength,other)

*************************************************
static function html_formFile(name,value,size,maxLength,other)
return  ::formGet("FILE",name,value,size,maxlength,other)

*************************************************
static function html_radioBox(name,value,checked,other)
	local ret,m
        m=html_tagNew("INPUT",other)
        m:addField("TYPE","RADIO")
 	if name!=NIL
        	m:addField("NAME",name)
        endif
 	if value!=NIL
        	m:addField("VALUE",value)
        endif
 	if checked!=NIL .and. checked
        	m:addField("","CHECKED")
        endif
        ret:=::addTag(m)
        ::newLine()
return ret


*************************************************
static function html_checkBox(name,value,checked,other)
	local ret,m
        m=html_tagNew("INPUT",other)
        m:addField("TYPE","CHECKBOX")
 	if name!=NIL
        	m:addField("NAME",name)
        endif
 	if value!=NIL
        	m:addField("VALUE",value)
        endif
 	if checked!=NIL .and. checked
        	m:addField("","CHECKED")
        endif
        ret:=::addTag(m)
        //::closeTag(ret)
        ::newLine()
return ret

*************************************************
static function html_formSubmit(text,name,other)
	local ret,m
        m=html_tagNew("INPUT",other)
        m:addField("TYPE","SUBMIT")
        if name!=NIL
        	m:addField("NAME",name)
        endif
        m:addField("VALUE",text)
        ret:=::addTag(m)
        //::closeTag(ret)
        ::newLine()
return ret

*************************************************
static function html_formReset(text,name,other)
	local ret,m
        m=html_tagNew("INPUT",other)
        m:addField("TYPE","RESET")
        if name!=NIL
        	m:addField("NAME",name)
        endif
        m:addField("VALUE",text)
        ret:=::addTag(m)
        //::closeTag(ret)
        ::newLine()
return ret

*************************************************
static function html_formGet(type,name,value,size,maxlength,other)
	local ret,m
        m=html_tagNew("INPUT",other)
        m:addField("TYPE",type)
        m:addField("NAME",name)
        m:addField("VALUE",value)
        m:addField("SIZE",size)
        if maxlength!=NIL
        	m:addField("MAXLENGTH",maxLength)
        endif
        ret:=::addTag(m)
        //::closeTag(ret)
        ::newLine()
return ret

*************************************************
static function html_inputImage(src,other,align,name)
	local ret,m
        m=html_tagNew("INPUT",other)
        m:addField("TYPE","IMAGE")
 	if src!=NIL
        	m:addField("SRC",src)
        endif
 	if align!=NIL
        	m:addField("ALIGN",align)
        endif
 	if name!=NIL
        	m:addField("NAME",name)
        endif
        ret:=::addTag(m)
        //::closeTag(ret)
        ::newLine()
return ret

*************************************************
static function html_startForm(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11)
return ::__Form(.t.,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11)
*************************************************
static function html_endForm()
return ::__Form(.f.)
*************************************************
static function html_Form(lOn,other,action,enctype,method,target)
	static fStack
        local n,m
	if fStack==NIL
		fStack:=stackNew()
        endif
	if lOn==NIL .or. lOn
        	m:=html_tagNew("FORM",other)
                if action!=NIL
                	m:addField("ACTION",action)
                endif
                if encType!=NIL
                	m:addField("ENCTYPE",enctype)
                endif
                if method!=NIL
                	m:addField("METHOD",method)
                else
                	m:addField("METHOD","POST")
                endif
                if target!=NIL
                	m:addField("TARGET",target)
                endif
		n:=::addTag(m)
                fStack:push(n)
                ::newLine()
        else
        	n:=fStack:pop()
                if n!=NIL
                	n:=::closeTag(n)
                	::newLine()
                endif
        endif
return n


*************************************************
static function html_listItem(text,other,type,value)
	local ret,m
        m=html_tagNew("LI",other)
 	if type!=NIL
        	m:addField("TYPE",type)
        endif
 	if value!=NIL
        	m:addField("VALUE",value)
        endif
        ret:=::addTag(m)
        ::addData(text)
        ::closeTag(ret)
        ::newLine()
return ret

*************************************************
static function html_startList(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11)
return ::__List(.t.,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11)
*************************************************
static function html_endList()
return ::__List(.f.)
*************************************************
static function html_List(lOn,ordering,other,compact,type)
	static lStack
        local n,m
	if lStack==NIL
		lStack:=stackNew()
        endif
	if lOn==NIL .or. lOn
        	if ordering!=NIL .and. ordering
        		m:=html_tagNew("OL",other)
                else
        		m:=html_tagNew("UL",other)
                endif
                if type!=NIL
                	m:addField("TYPE",type)
                endif
                if compact!=NIL .and. compact
                	m:addField("","COMPACT")
                endif
		n:=::addTag(m)
                lStack:push(n)
                ::newLine()
        else
        	n:=lStack:pop()
                if n!=NIL
                	n:=::closeTag(n)
                	::newLine()
                endif
        endif
return n

*************************************************
static function html_startTcell(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11)
return ::__Tcell(.t.,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11)
*************************************************
static function html_endTcell()
return ::__Tcell(.f.)
*************************************************
static function html_Tcell(lOn,other,align,backGround,bgColor,;
				borderColor,borderColorDark,borderColorLight,;
                                colSpan,rowSpan,noWrap,vAlign,width)
	static cStack
        local n,m
	if cStack==NIL
		cStack:=stackNew()
        endif
	if lOn==NIL .or. lOn
        	m:=html_tagNew("TD",other)
                if align!=NIL
                	m:addField("ALIGN",align)
                endif
                if backGround!=NIL
                	m:addField("BACKGROUND",backGround)
                endif
                if bgcolor!=NIL
                	m:addField("BGCOLOR",bgcolor)
                endif
                if borderColor!=NIL
                	m:addField("BORDERCOLOR",borderColor)
                endif
                if borderColorDark!=NIL
                	m:addField("BORDERCOLORDARK",borderColorDark)
                endif
                if borderColorLight!=NIL
                	m:addField("BORDERCOLORLIGHT",borderColorLight)
                endif
                if colSpan!=NIL
                	m:addField("COLSPAN",colSpan)
                endif
                if rowSpan!=NIL
                	m:addField("ROWSPAN",rowSpan)
                endif
                if noWrap!=NIL .and. nowrap
                	m:addField("","NOWRAP")
                endif
                if vAlign!=NIL
                	m:addField("VALIGN",vAlign)
                endif
                if width!=NIL
                	m:addField("WIDTH",width)
                endif
		n:=::addTag(m)
                cStack:push(n)
                //::newLine()
        else
        	n:=cStack:pop()
                if n!=NIL
                	n:=::closeTag(n)
                	::newLine()
                endif
        endif
return n

*************************************************
static function html_startTrow(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10)
return ::__Trow(.t.,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10)
*************************************************
static function html_endTrow()
return ::__Trow(.f.)
*************************************************
static function html_Trow(lOn,other,align,border,backGround,bgColor,;
				borderColor,borderColorDark,borderColorLight,;
                                vAlign,width)
	static rStack
        local n,m
	if rStack==NIL
		rStack:=stackNew()
        endif
	if lOn==NIL .or. lOn
        	m:=html_tagNew("TR",other)
                if align!=NIL
                	m:addField("ALIGN",align)
                endif
                if border!=NIL
                	m:addField("BORDER",border)
                endif
                if backGround!=NIL
                	m:addField("BACKGROUND",backGround)
                endif
                if bgcolor!=NIL
                	m:addField("BGCOLOR",bgcolor)
                endif
                if borderColor!=NIL
                	m:addField("BORDERCOLOR",borderColor)
                endif
                if borderColorDark!=NIL
                	m:addField("BORDERCOLORDARK",borderColorDark)
                endif
                if borderColorLight!=NIL
                	m:addField("BORDERCOLORLIGHT",borderColorLight)
                endif
                if vAlign!=NIL
                	m:addField("VALIGN",vAlign)
                endif
                if width!=NIL
                	m:addField("WIDTH",width)
                endif
		n:=::addTag(m)
                rStack:push(n)
                ::newLine()
        else
        	n:=rStack:pop()
                if n!=NIL
                	n:=::closeTag(n)
                	::newLine()
                endif
        endif
return n

*************************************************
static function html_THcell(text,other,align,backGround,bgColor,;
				borderColor,borderColorDark,borderColorLight,;
                                colspan,rowspan,nowrap,vAlign,width)

		local ret,m
        	m:=html_tagNew("TH",other)
                if align!=NIL
                	m:addField("ALIGN",align)
                endif
                if backGround!=NIL
                	m:addField("BACKGROUND",backGround)
                endif
                if bgcolor!=NIL
                	m:addField("BGCOLOR",bgcolor)
                endif
                if borderColor!=NIL
                	m:addField("BORDERCOLOR",borderColor)
                endif
                if borderColorDark!=NIL
                	m:addField("BORDERCOLORDARK",borderColorDark)
                endif
                if borderColorLight!=NIL
                	m:addField("BORDERCOLORLIGHT",borderColorLight)
                endif
                if colSpan!=NIL
                	m:addField("COLSPAN",colSpan)
                endif
                if rowSpan!=NIL
                	m:addField("ROWSPAN",rowSpan)
                endif
                if nowrap!=NIL .and. nowrap
                	m:addField("","NOWRAP")
                endif
                if vAlign!=NIL
                	m:addField("VALIGN",valign)
                endif
                if width!=NIL
                	m:addField("WIDTH",width)
                endif
		ret:=::addTag(m)
                ::adddata(text)
                ::closeTag(ret)
                ::newLine()
return ret

*************************************************
static function html_startTable(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15)
return	::__table(.t.,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15)
*************************************************
static function html_endTable()
return	::__table(.f.)
*************************************************
static function html_Table(lOn,other,align,border,backGround,bgColor,;
				borderColor,borderColorDark,borderColorLight,;
                                cellPadding,cellSpacing,frame,;
				hspace,rules,vSpace,width)
	static tStack
        local n,m
	if tStack==NIL
		tStack:=stackNew()
        endif
	if lOn==NIL .or. lOn
        	::newLine()
        	m:=html_tagNew("TABLE",other)
                if align!=NIL
                	m:addField("ALIGN",align)
                endif
                if border!=NIL
                	m:addField("BORDER",border)
                endif
                if backGround!=NIL
                	m:addField("BACKGROUND",backGround)
                endif
                if bgcolor!=NIL
                	m:addField("BGCOLOR",bgcolor)
                endif
                if borderColor!=NIL
                	m:addField("BORDERCOLOR",borderColor)
                endif
                if borderColorDark!=NIL
                	m:addField("BORDERCOLORDARK",borderColorDark)
                endif
                if borderColorLight!=NIL
                	m:addField("BORDERCOLORLIGHT",borderColorLight)
                endif
                if cellPadding!=NIL
                	m:addField("CELLPADDING",cellPadding)
                endif
                if cellSpacing!=NIL
                	m:addField("CELLSPACING",cellSpacing)
                endif
                if frame!=NIL
                	m:addField("FRAME",frame)
                endif
                if hspace!=NIL
                	m:addField("HSPACE",hspace)
                endif
                if rules!=NIL
                	m:addField("RULES",rules)
                endif
                if vspace!=NIL
                	m:addField("VSPACE",vspace)
                endif
                if width!=NIL
                	m:addField("WIDTH",width)
                endif
		n:=::addTag(m)
                tStack:push(n)
                ::newLine()
        else
        	n:=tStack:pop()
                if n!=NIL
                	n:=::closeTag(n)
                        ::newLine()
                endif
        endif
return n

*************************************************
static function html_imageUrl(url,target,file,alt,border,height,name,other)
	local i,ret,t

	if url==NIL
        	return 0
        endif

        t:=html_tagNew("A")
        t:addField("HREF",url)
        if target!=NIL
        	t:addField("TARGET",target)
        endif
        ret:=::addTag(t)

	t:=html_tagNew("IMG",other)
        t:addField("SRC",file)
        if border!=NIL
        	t:addField("BORDER",border)
        endif
        if height!=NIL
        	t:addField("HEIGHT",height)
        endif
        if name!=NIL
        	t:addField("NAME",name)
        endif
        if alt!=NIL
        	t:addField("ALT",alt)
        endif
        i:=::addTag(t)
        ::closeTag(i)
        ::closeTag(ret)
return ret

*************************************************
static function html_url( text, url, target, other )
        local ret,t
        if empty(url)
        	return 0
        endif
        t:=html_tagNew("A",other)
        t:addField("HREF",url)
        if target!=NIL
        	t:addField("TARGET",target)
        endif
        ret:=::addTag(t)
        ::addData(text)
        ::closeTag(ret)
return ret

*************************************************
static function html_startMarquee(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13)
return	::__marquee(.t.,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13)
*************************************************
static function html_endMarquee()
return	::__marquee(.f.)
*************************************************
static function html_marquee(lOn,other,align,behavior,bgcolor,direct,height,;
				hspace,loop,scrollAmount,scrollDelay,;
				vSpace,width)
	static mStack
        local n,m
	if mStack==NIL
		mStack:=stackNew()
        endif
	if lOn==NIL .or. lOn
        	::newLine()
        	m:=html_tagNew("MARQUEE",other)
                if align!=NIL
                	m:addField("ALIGN",align)
                endif
                if behavior!=NIL
                	m:addField("BEHAVIOR",behavior)
                endif
                if bgcolor!=NIL
                	m:addField("BGCOLOR",bgcolor)
                endif
                if direct!=NIL
                	m:addField("DIRECT",direct)
                endif
                if height!=NIL
                	m:addField("HEIGHT",height)
                endif
                if hspace!=NIL
                	m:addField("HSPACE",hspace)
                endif
                if loop!=NIL
                	m:addField("LOOP",loop)
                endif
                if scrollAmount!=NIL
                	m:addField("SCROLLAMOUNT",scrollAmount)
                endif
                if scrollDelay!=NIL
                	m:addField("SCROLLDELAY",scrollDelay)
                endif
                if vspace!=NIL
                	m:addField("VSPACE",vspace)
                endif
                if width!=NIL
                	m:addField("WIDTH",width)
                endif
		n:=::addTag(m)
                mStack:push(n)
                ::newLine()
        else
        	n:=mStack:pop()
                if n!=NIL
                	::newLine()
                	n:=::closeTag(n)
                        ::newLine()
                endif
        endif
return n

*************************************************
static function html_putBreak()
return ::newLine(.t.)
*************************************************
static function html_Paragraph(lOn,align,style)
	static pStack
        local n,p
	if pStack==NIL
		pStack:=stackNew()
        endif
	if lOn==NIL .or. lOn
        	if align!=NIL .or. style!=NIL
        		p:=html_tagNew("P")
                	if align!=NIL
                		p:addField("ALIGN",align)
                	endif
                	if style!=NIL
                		p:addField("STYLE",style)
                	endif
                        ::newLine()
			n:=::addTag(p)
                	pStack:push(n)
                endif
        else
        	n:=pStack:pop()
                if n!=NIL
                	::newLine()
                	n:=::closeTag(n)
                        ::newLine()
                endif
        endif
return n

*************************************************
static function html_hLine(size,width)
	local ret,t
        t:=html_tagNew("HR")
        if size!=NIL
        	t:addField("SIZE",size)
        endif
        if width!=NIL
        	t:addField("WIDTH",width)
        endif
        ::newLine()
        ret:=::addTag(t)
        ::newLine()
return ret
*************************************************
static function html_putHeading(text,Weight,align,lCenter)
	local ret,c,t
        lCenter:=iif(lCenter==NIL,.f.,lCenter)
        weight:=iif(weight==NIL,3,weight)
        if lCenter
        	c:=::addTag("CENTER")
        endif
        t:="H"+alltrim(str(weight),1,0)
        t:=html_tagNew(t)
        if align!=NIL
        	t:addField("ALIGN",align)
        endif
        ret:=::addTag(t)
        ::addData(text)
        ::closeTag(ret)
        if lCenter
        	::closeTag(c)
        endif
return ret

*************************************************
static function html_multiCol(text,cols,gutter,width)
	local ret,t
	t:=html_tagNew("MULTICOL")
        if cols!=NIL
        	t:addField("COLS",cols)
        endif
        if gutter!=NIL
        	t:addField("GUTTER",gutter)
        endif
        if width!=NIL
        	t:addField("WIDTH",width)
        endif
        ret:=::addTag(t)
        ::addData(text)
        ::closeTag(ret)
return ret
*************************************************
static function html_text(text,width,lWrap)
	local ret,t
	t:=html_tagNew("PRE")
        if width!=NIL
        	t:addField("WIDTH",width)
        endif
        if lWrap!=NIL
        	t:addField("",iif(lWrap,"WRAP","NOWRAP"))
        endif
        ret:=::addTag(t)
        ::newLine()
        ::addData(text)
        ::newLine()
        ::closeTag(ret)
        ::newLine()
return ret
*************************************************
static function html_putImage(file,alt,border,height,name,target,other)
	local t:=html_tagNew("IMG",other)

        t:addField("SRC",file)
        if border!=NIL
        	t:addField("BORDER",border)
        endif
        if height!=NIL
        	t:addField("HEIGHT",height)
        endif
        if name!=NIL
        	t:addField("NAME",name)
        endif
        if alt!=NIL
        	t:addField("ALT",alt)
        endif
        if target!=NIL
        	t:addField("TARGET",target)
        endif
return ::addTag(t)
*************************************************
static function html_space()
return	::addData("&nbsp")
*************************************************
static function html_qqout()
	local i,str:=""
        for i=2 to pcount()
        	str+=toString(param(i))+","
        next
        str:=substr(str,1,len(str)-1)
return  ::addData(str)
*************************************************
static function html_qout()
	local i,str:=""
        for i=2 to pcount()
        	str+=toString(param(i))+","
        next
        str:=substr(str,1,len(str)-1)
        ::newLine()
return  ::addData(str)
*************************************************
static function html_sayColor(str,color)
	local ret
        ::__setFont(.t.,,,color)

        ret:=::put(str)

        ::endFont()
return ret
*************************************************
static function html_say(str,font,size,type,color)
	local i,ss,ret
        ::__setFont(.t.,font,size,color)
        if type==NIL
        	type=""
        endif
        ss=html_tagSplit(type)
        for i=1 to len(ss)
                ::setFontType(ss[i],.t.)
        next

        ret:=::put(str)

        for i=len(ss) to 1 step -1
                ::setFontType(ss[i],.f.)
        next
        ::endFont()
return ret
*************************************************
static function html_setFontType(fType,lOn)
	static fStacks
        local n, hType, stack
        if fStacks==NIL
        	fStacks:=map()
        endif
	if ftype==NIL
        	return 0
        else
        	ftype=Upper(ftype)
                hType:=hashStr(ftype)
        	if ftype $ fStacks
                	stack:=fStacks[htype]
                else
			fStacks[hType]:=stackNew()
                	stack:=fStacks[htype]
                endif

        endif
	if lOn==NIL .or. lOn
		n:=::addTag(ftype)
                stack:push(n)
        else
        	n:=stack:pop()
                if n!=NIL
                	n:=::closeTag(n)
                endif
        endif
return n

*************************************************
static function html_startFont(p1,p2,p3,p4,p5,p6,p7,p8,p9)
return	::__setFont(.t.,p1,p2,p3,p4,p5,p6,p7,p8,p9)
*************************************************
static function html_endFont()
return	::__setFont(.f.)
*************************************************
static function html_endFontAll()
return	::__setFont(.f.,,,,.f.,.f.,.f.)
*************************************************
static function html_setFont(lOn,face,size,color,lBold,lItalic,lUline)
	static fStack
        local n,font
	if fStack==NIL
		fStack:=stackNew()
        endif
	if lOn==NIL .or. lOn
        	if face!=NIL .or. size!=NIL .or. color!=NIL
        		font:=html_tagNew("FONT")
                	if face!=NIL
                		font:addField("FACE",face)
                	endif
                	if size!=NIL
                		font:addField("SIZE",size)
                	endif
                	if color!=NIL
                		font:addField("COLOR",color)
                	endif
			n:=::addTag(font)
                	fStack:push(n)
                endif
                if lBold != NIL
                	::setFontType("B",lBold)
                endif
                if lItalic != NIL
                	::setFontType("I",lItalic)
                endif
                if lUline != NIL
                	::setFontType("U",lUline)
                endif
        else
        	n:=fStack:pop()
                if n!=NIL
                	n:=::closeTag(n)
                endif
        endif
return n

*************************************************
static function html_Center(lOn)
	static cStack
        local n
	if cStack==NIL
		cStack:=stackNew()
        endif
	if lOn==NIL .or. lOn
		n:=::addTag("CENTER")
                cStack:push(n)
        else
        	n:=cStack:pop()
                if n!=NIL
                	n:=::closeTag(n)
                endif
        endif
return n
*************************************************
static function html_bgImage(image)
	local ret
	if valtype(image)=="C" .and. !empty(image)
        	ret=::tags[::__body]:addField("BACKGROUND",image)
                if ret!=0
                	return .t.
                endif
        endif
return .f.
*************************************************
static function html_textColor(color)
	local ret
	if valtype(color)=="C" .and. !empty(color)
        	ret=::tags[::__body]:addField("TEXT",color)
                if ret!=0
                	return .t.
                endif
        endif
return .f.
*************************************************
static function html_pageColor(color)
	local ret
	if valtype(color)=="C" .and. !empty(color)
        	ret=::tags[::__body]:addField("BGCOLOR",color)
                if ret!=0
                	return .t.
                endif
        endif
return .f.
*************************************************
static function html_newLine(lBR)
        if lBR!=NIL .and. lBR
         	::addTag("BR")
        endif
	aadd(::tags,NIL)
return  len(::tags)
*************************************************
static function html_addData(str_data)
	if valtype(str_data)=="C"
		aadd(::tags,str_data)
		return  len(::tags)
        endif
return 0
*************************************************
static function html_addTag(tag_obj,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10)
	if valtype(tag_obj)=="C"
        	tag_obj:=html_tagNew(tag_obj,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10)
        endif
	if valtype(tag_obj)=="O"
		aadd(::tags,tag_obj)
		return  len(::tags)
        endif
return 0
*************************************************
static function html_closeTag(tag_index)
	if valtype(tag_index)=="N"
        	if tag_index>0 .and. tag_index<=len(::tags)
			aadd(::tags,tag_index)
			return  len(::tags)
                endif
        endif
return 0

*************************************************
static function WriteToFile(fileName)
	local ret,file,cons_old:=set(_SET_CONSOLE)

        file:=iif(fileName==NIL,::fileName,fileName)
        if file!=NIL .and. !empty(file)
        	set(_SET_CONSOLE,.f.)
        	set printer on
        	set printer to (file)
        endif
	ret=::__write()
        set printer off
        set printer to
        set(_SET_CONSOLE,cons_old)
return ret

*************************************************
static function WriteToHttp()
	local ret:=.t.,cons_old
        ?? 'Content-Type: text/html'
        ?
        ?
	ret=::__write()
return  ret

*************************************************
static function writeDocument()
	local i, t
        for i=1 to len(::tags)
                t=valtype(::tags[i])
                do case
                	case t=="O" // .and. "HTML_TAG"$::tags[i]:className
                        	?? ::tags[i]:toString()
                        case t=="C"
                        	?? ::tags[i]
                        case t=="N"
                        	if ::tags[i]>0 .and. ::tags[i]<=len(::tags)
                        		?? ::tags[::tags[i]]:closeString()
                                else
                                	? "Invalid index of closed TAG"
                                endif
                        case t=="U"
                        	?
                        otherwise
	                        ? "Invalid data",toString(::tags[i])
                endcase
        next
        ? "</BODY></HTML>"
return .f.
*************************************************
static function loadUrl(sUrl,timeout)
        local t,u:=urlNew(), pars:=htmlParserNew()
        timeout:=iif(valtype(timeout)!="N",60,timeout)
        u:parseUrl(sUrl)
        if !u:open()
        	::newLine()
        	::addData('Can~t open URL:"'+sUrl+'"')
        	::newLine()
        	::addData('Full URL/file is:"'+u:fileName+'"')
        	::newLine()
        endif
        do while !u:eof()
        	u:kick()
                if (seconds()-u:start) > timeout
                	exit
                endif
                if !u:eof()
                    sleep(1)
                endif
        enddo
        while !u:fileeof()
            t:=u:getstr()
            if len(t)==0
               exit
            endif
        enddo
        do while !u:fileeof()
        	pars:put( u:readstr(10000) )
        enddo
        pars:end(u:readstr(10000))
        u:close()
        ::tags:={}
        do while !pars:empty()
           t:=pars:get()
           if t==NIL
 		::newLine()
           else
           	if valtype(t)=="O"
                	::addTag(t)
                else
                	::addData(t)
                endif
           endif
        enddo
return .t.
