/*
    Copyright (C) 2003  ITK
    Author   : Alexey M. Tkachenko (alexey@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include <clip-gtk.ch>
#include <inkey.ch>
#include "abx.ch"

function abx_msgbox(MsgText,MsgHeader,aButtons,Window)
	local dlg, btn, i, label, pos, str

	MsgHeader := iif(valtype(MsgHeader) == "C", MsgHeader, [Message])

	dlg := gtk_DialogNew(,MsgHeader)
	gtk_WindowSetModal(dlg, TRUE)
//	gtk_WidgetSetSize(dlg,400,100)

	pos := at(';',MsgText)

	if pos==0; pos := len(MsgText)+1; endif
	do while len(MsgText) > 0
		str := left(MsgText,pos-1)
		label := gtk_LabelNew(, str)
		gtk_LabelSetLineWrap(Label, .T.)
		gtk_BoxPackStart(dlg:VBox, Label)
		MsgText := substr(MsgText,pos + 1)
		pos := at(';',MsgText)
		if pos==0; pos := len(MsgText)+1; endif
	enddo

	if gtk_IsWidget(Window)
		gtk_WindowSetTransientFor(dlg,Window)
		gtk_WindowSetPosition(dlg, GTK_WIN_POS_CENTER_ON_PARENT)
	else
		gtk_WindowSetPosition(dlg, GTK_WIN_POS_CENTER)
	endif
	gtk_SignalConnect(dlg,"delete-event",{||msgbox_dlg_close(dlg)})

	if valtype(aButtons) != "A"
		aButtons := {[Ok]}
	endif

	if valtype(aButtons[1]) != "C"
		aButtons[1] := [Ok]
	endif

	for i := 1 to len(aButtons)
		btn := gtk_ButtonNew(,aButtons[i])
		btn:index := i
		gtk_SignalConnect(btn,"clicked",{|wid|msgbox_dlg_close(dlg,wid:index)})
		gtk_ContainerAdd(dlg:ActionArea,btn)

		if i==1
			gtk_WindowSetDefault(dlg,btn)
			gtk_WindowSetFocus(dlg,btn)
		endif
	next
	gtk_SignalConnect(dlg,GTK_KEY_PRESS,{|wid,ev|iif(ev:keyval==K_ESC,msgbox_dlg_close(dlg),nil)})

	gtk_WidgetShowAll(dlg)
	gtk_WindowSetDefaultSize(dlg,400,100)
//	gdk_WindowSetHints(dlg,,,400,100)

	dlg:selected := 0
	gtk_Main()
return dlg:selected

static function msgbox_dlg_close(dlg,index)
	gtk_WidgetDestroy(dlg)
	if !empty(index)
		dlg:selected := index
	endif
	gtk_Quit()
return

/*******************************************************************/
#include <inkey.ch>

function abx_achoice(m,Header,width,height)
	local i
	local dlg, hbox, lst, btn_Ok, btn_Cancel, vscr, adj

	dlg := gtk_DialogNew(,Header)
	dlg:selected := 0

	gtk_WindowSetModal(dlg,TRUE)
	gtk_WindowSetPosition(dlg, GTK_WIN_POS_CENTER)

	gtk_WidgetSetSize(dlg,width,height)

	hbox := gtk_HBoxNew()

	if len(m) > 0 .and. valtype(m[1]) == "A"
		lst := gtk_ClistNew(,len(m[1]))
		for i := 1 to len(m[1])
			gtk_CListSetColumnAutoResize(lst,i)
		next
	else
		lst := gtk_ClistNew(,1)
		gtk_CListSetColumnAutoResize(lst,1)
	endif
//	gtk_CListColumnsAutosize(lst)
	gtk_CListSetSelectionMode(lst,GTK_SELECTION_BROWSE)
	gtk_SignalConnect(lst,"select-row",{|wid,e|dlg:selected := e:row})

	vscr := gtk_VScrollbarNew()
	gtk_CListSetVAdjustment(lst,gtk_RangeGetAdjustment(vscr))

	for i:=1 to len(m)
		gtk_CListAppend(lst,m[i])
	next

	gtk_BoxPackStart(dlg:VBox,hbox,TRUE,TRUE)
	gtk_BoxPackStart(hbox,lst,TRUE,TRUE)
	gtk_BoxPackStart(hbox,vscr,FALSE)

	gtk_WindowSetFocus(dlg,lst)

	if isMemvar("MainWindow")
		gtk_WindowSetTransientFor(dlg,m->MainWindow)
		gtk_WindowSetPosition(dlg, GTK_WIN_POS_CENTER_ON_PARENT)
	endif
	gtk_SignalConnect(dlg,"delete-event",{||abx_achoice_cancel_clicked(dlg)})
	gtk_SignalConnect(lst,"key-press-event",{|wid,ev|iif(ev:keyval==K_ESC,abx_achoice_cancel_clicked(dlg),nil)})
	gtk_SignalConnect(lst,"2button-press-event",{|wid,ev|abx_achoice_ok_clicked(dlg)})

	btn_Ok := gtk_ButtonNew(,[Ok])
	gtk_SignalConnect(btn_Ok,"clicked",{||abx_achoice_ok_clicked(dlg)})
	gtk_ContainerAdd(dlg:ActionArea,btn_Ok)

	btn_Cancel := gtk_ButtonNew(,[Cancel])
	gtk_SignalConnect(btn_Cancel,"clicked",{||abx_achoice_cancel_clicked(dlg)})
	gtk_ContainerAdd(dlg:ActionArea,btn_Cancel)

	gtk_WindowSetDefault(dlg,btn_Ok)
	gtk_WidgetAddAccelerator(btn_Cancel, "clicked", dlg, GDK_Escape)

	gtk_WidgetShowAll(dlg)

	gtk_Main()
return dlg:selected

static function abx_achoice_ok_clicked(dlg)
	gtk_WidgetDestroy(dlg)
	gtk_Quit()
return TRUE

static function abx_achoice_cancel_clicked(dlg)
	gtk_WidgetDestroy(dlg)
	dlg:selected := 0
	gtk_Quit()
return TRUE
/*******************************************************************/

function abx_load_plugin(metaName)
	static pi_cache := map()
	static pi_Path := nil
	static endpos
	local ret,mKey,sFile

	if pi_Path == nil
		pi_Path := StartPath()
		endpos := rat(PATH_DELIM,pi_Path)
		if endpos > 0
			pi_Path := left(pi_Path,endpos)
		endif
		if right(pi_Path,1) != PATH_DELIM
			pi_Path += PATH_DELIM
		endif
		pi_Path += "plugins" + PATH_DELIM
	endif
	sFile := pi_Path+lower(alltrim(metaname))

	if !file(sFile) .and. !file(sFile+".prg")
		sFile :=  cliproot()+PATH_DELIM+"codb_abx"+PATH_DELIM+"plugins"+PATH_DELIM+lower(alltrim(metaname))
	endif
	mkey:=alltrim(upper(sFile))
	if mKey $ pi_cache
		ret := pi_cache[mKey]
	else
		ret := loadPlugIns(sFile)
		if valtype(ret) =="B"
			pi_cache[mKey] := ret
		endif
	endif

return ret


/********************************************************************/
function abx_tbl_new_label(tbl,Row,Col,LblText,Alignment)
	local label

	label := gtk_LabelNew(,"  "+LblText+"  ")
	gtk_TableAttach(tbl,label,Col,Col+1,Row,Row+1, GTK_FILL)
	gtk_MiscSetAlignment(label,iif(!empty(Alignment),Alignment,1),0)
return label

function abx_tbl_new_entry(tbl,Row,Col)
	local entry

	entry := gtk_EntryNew()
	gtk_TableAttachDefaults(tbl,entry,Col,Col+1,Row,Row+1)
return entry

function abx_tbl_new_getobj(tbl,Type,Picture,Row,Col,OnChgBlock)
	local getobj

	getobj := abx_getobj_new(Type,Picture,OnChgBlock)
	gtk_TableAttachDefaults(tbl,getobj:widget,Col,Col+1,Row,Row+1)
return getobj

function abx_tbl_put_widget(tbl,wid,Row,Col)
	gtk_TableAttachDefaults(tbl,wid,Col,Col+1,Row,Row+1)
return wid

/********************************************************************/
function abx_attr_choice(dict)
	local ret, lst, tmp, s, m, i

	m := {}
	lst := dict:select("ATTR")
	for i := 1 to len(lst)
		tmp := dict:GetValue(lst[i])
		aadd(m,{tmp:name,tmp:id,tmp:type,str(tmp:len),str(tmp:dec)})
	next

	if empty(m)
		abx_msgbox([Attributes list is empty!],[Error])
		i := 0
	else
		i := abx_achoice(m,[Choose attribute])
	endif

	if i != 0
		ret := dict:GetValue(lst[i])
	endif
return ret

function abx_class_choice(dict)
	local ret, lst, tmp, m, i

	m := {}
	lst := dict:select("CLASS")
	for i := 1 to len(lst)
		tmp := dict:GetValue(lst[i])
		aadd(m,{tmp:name,tmp:id})
	next

	if empty(m)
		abx_msgbox([Classes list is empty!],[Error])
		i := 0
	else
		i := abx_achoice(m,[Choose class])
	endif

	if i != 0
		ret := dict:GetValue(lst[i])
	endif
return ret

function abx_object_choice(dict,dep,class_id)
	local ret := 0, sRef, vRef, aRef, tmp, i
	local class_desc, class_name

	if empty(class_id)
		class_desc := abx_class_choice(dict)
		if empty(class_desc)
			return ret
		endif
		class_id := class_desc:id
	endif

	if empty(class_id)
		return ret
	endif

	class_desc := dict:GetValue(class_id)

	aRef := dep:Select(class_id)
	sRef := {}
	for i := 1 to len(aRef)
		tmp := codb_GetValue(aRef[i])
		if valtype(tmp) == "O"
			if !empty(class_desc)
				aadd(sRef,{class_desc:essence(tmp),aRef[i]})
			elseif HASH_NAME $ tmp
				aadd(sRef,{tmp:name,aRef[i]})
			else
				aadd(sRef,{"",aRef[i]})
			endif
		else
			aadd(sRef,{"",aRef[i]})
		endif
	next

	class_name := iif(!empty(class_desc),class_desc:name+" ("+class_id+")",class_id)

	if empty(sRef)
		abx_msgbox([No objects of class]+" "+class_name,[Error])
		i := 0
	else
		i := abx_achoice(sRef,[Choose object]+" "+class_name)
	endif

	if i != 0
		ret := codb_GetValue(aRef[i])
	endif
return ret

function abx_index_choice(dict)
	local ret, lst, tmp, m, i

	m := {}
	lst := dict:select("INDEX")
	for i := 1 to len(lst)
		tmp := dict:GetValue(lst[i])
		aadd(m,{tmp:name,tmp:expr})
	next

	if empty(m)
		abx_msgbox([Indices list is empty!],[Error])
		i := 0
	else
		i := abx_achoice(m,[Choose index])
	endif

	if i != 0
		ret := dict:GetValue(lst[i])
	endif
return ret

function abx_column_choice(dict)
	local ret, lst, tmp, m, i

	m := {}
	lst := dict:select("TCOLUMN")
	for i := 1 to len(lst)
		tmp := dict:GetValue(lst[i])
		aadd(m,{tmp:name,tmp:header})
	next

	if empty(m)
		abx_msgbox([Columns list is empty!],[Error])
		i := 0
	else
		i := abx_achoice(m,[Choose column])
	endif

	if i != 0
		ret := dict:GetValue(lst[i])
	endif
return ret

**********************************************************

function abx_meta_to_xml(oDict,fname)
	local hFile,str:="",len,name
	local i,j,k,list,obj
	local aMeta:={;
	{"COUNTER",,"NAME","TYPE","DEPOSIT"},;
	{"ATTR","ATTRIBUTE","NAME","TYPE","LEN","DEC","LENTYPE","MASK","REF_TO",;
			"DEFVALUE","COUNTER","NOT_NULL","NOT_EMPTY",;
			"SOURCE","CODE","HELP"},;
	{"INDEX",,"NAME","EXPR"},;
	{"EXTENT",,"NAME","HELP"},;
	{"DEPOSIT","DEPOSITORY","NAME","MEMOSIZE"},;
	{"CLASS",,"NAME","SUPER_ID","EXTENT_ID","EXPR_ESSENCE","UNIQUE_KEY","LOG_NEED",;
			"ATTR_LIST","IDX_LIST","ATTR_FIND"},;
	{"TCOLUMN",,"NAME","HEADER","FOOTER","WIDTH","EXPR","DEPEND_OF","REFS"},;
	{"TVIEW",,"NAME","CLASS_ID","EXTENT_ID","GROUP_ID","USER_ID","COL_LIST"},;
	{"REPORT",,"NAME","TYPE","FILENAME","CLASS_ID","EXTENT_ID",;
			"GROUP_ID","USER_ID"},;
	{"PLUGINS",,"NAME","TYPE","FILENAME","MAINFUNC","CLASS_ID"};
	}

	hFile := fcreate(fname)
	if hFile < 0
		return [Error creating file:]+fname+";"+ferrorstr()
	endif

	str+='<-- description of dictionary '+oDict:id+' ("'+oDict:name+'") -->'+CRLF+CRLF
	for i=1 to len(ameta)
		str+=CRLF
		str+="<!-- begin metadata "+ameta[i][1]+" -->"+CRLF
		list := oDict:select(aMeta[i][1])
		for j=1 to len(list)
			obj := oDict:getValue(list[j])
			if empty(obj)
				str+='<!-- Error loading object:'+list[j]+' -->'+CRLF
				loop
			endif
			name := iif(empty(aMeta[i][2]),aMeta[i][1],aMeta[i][2])
			str+='<'+lower(name)+'&\t'
			str+=iif(len(name)>6,'','&\t')
			str+=lower(aMeta[i][3])+'&\t= '+metaToString(obj,aMeta[i][3],aMeta[i][1])+CRLF
			for k=4 to len(aMeta[i])
				if aMeta[i][k] $ obj
					str+='&\t&\t'+lower(aMeta[i][k])
					str+=iif(len(aMeta[i][k])>7,'','&\t')
					str+='= '+metaToString(obj,aMeta[i][k],aMeta[i][1])+CRLF
				endif
			next
			str+='/>'+CRLF
		next
		str+="<!-- end metadata "+ameta[i][1]+" -->"+CRLF
		str+=CRLF
	next

	len := fWrite(hFile,str)
	if len !=len(str)
		fclose(hFile)
		return [Error writing to file:]+fname+";"+ferrorstr()
	endif

	fclose(hFile)
return ""

****************
static function metaToString(obj,name, meta)
	local ret, data, type, mname:=obj:name
	local i,s,j,tmp1,tmp2
	if name $ obj
		data := obj[name]
	else
		return '"........"'
	endif
	type := valtype(data)
	do case
	case name $ "EXTENT_ID SUPER_ID CLASS_ID GROUP_ID USER_ID"
		if empty(data)
			ret := '""'
		else
			tmp1 := metagetValue(data)
			if empty(tmp1)
				ret := '"'+data+'"'
			else
				ret := '"'+tmp1:name+'"'
			endif
		endif
	case name $ "ATTR_LIST IDX_LIST ATTR_FIND COL_LIST REFS"
		//"&({'code','unit','name','smallname'})"
		s:=""
		for i=1 to len(data)
			if name $ "ATTR_FIND REFS"
				s+="'"+data[i]+"',"
			else
				tmp1 := metagetValue(data[i])
				if empty(tmp1)
					loop
				endif
				s+="'"+tmp1:name+"',"
			 endif
		next
		s:=substr(s,1,len(s)-1)
		ret := '"&({'+s+'})"'
	case name =="LEN" .and. meta == "ATTR" .and. (obj:type $ "SR")
		ret := '"'+"&(codb_info('CODB_ID_LEN'))"+'"'
	case name == "REF_TO"
		if empty(data)
			ret := '""'
		else
			ret := '"'+left(data,codb_info('DICT_ID_LEN'))+':'
			tmp1 := metagetValue(data)
			if empty(tmp1)
				ret+=data
			else
				ret+=tmp1:name
			endif
			ret+='"'
		endif
	case type =="L"
		ret := iif(data,".t.",".f.")
	case type =="N"
		ret := alltrim(str(data))
	case type =="C"
		ret := '"'+data+'"'
	otherwise
		ret := '"'+toString(data)+'"'
	endcase
return ret
************************
static function metaGetValue(cID)
	local oDict, dict_id:=left(cID,codb_info('DICT_ID_LEN'))
	oDict := codb_dict_reference(dict_id)
	if valtype(oDict) != "O"
		oDict := coDictionary():new(dict_id)
		if empty(oDict:error)
			oDict:open()
			if !empty(oDict:error)
				oDict:close()
				oDict := NIL
			endif
		else
			oDict := NIL
		endif
	endif
	if valtype(oDict) != "O"
		return  cId
	endif
return  oDict:getValue(cId)


