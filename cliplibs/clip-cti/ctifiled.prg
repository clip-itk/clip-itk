/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	CTI_FILEDIALOG
	Author	: Elena Kornilova (alena@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/


#include "cti.ch"
#include "ctievents.ch"

#include "setcurs.ch"
#include "inkey.ch"

#define FA_NORMAL	0
#define FA_READONLY	1
#define FA_HIDDEN	2
#define FA_SYSTEM	4
#define FA_VOLUME	8
#define FA_DIRECTORY	16
#define FA_ARCHIVE	32

#define	SUPERCLASS	CTI_WINDOW
#define ADD_SPACE	replicate(" ", 1024)

function cti_filedialog_new(cPath, cMask, cTitle)
	local obj := cti_inherit(cti_window_new(cTitle),"CTI_FILEDIALOG")

	obj:cMask	:= iif(empty(cMask), FILE_MASK, cMask)
	obj:cPath	:= cPath
	obj:__curFile	:= ""
	obj:__curDriver	:= ""
	obj:__curDir	:= ""
	obj:retFile	:= ""

	obj:pathEntry	:= cti_entry_new("C", "@S30")
	obj:fileList	:= cti_list_new(5)
	obj:okButton	:= cti_pushbutton_new([&OK], "&")
	obj:cancelButton:= cti_pushbutton_new([&CANCEL], "&")
	obj:driverOption:= cti_option_menu_new()
	obj:findString	:= cti_label_new(">")

	obj:__initiation	:= @cti_filed_initiation()
	obj:__parse_path	:= @cti_filed_parse_path()
	obj:__stabilize		:= @cti_filed_stabilize()
	obj:__set_file_list	:= @cti_filed_set_file_list()
	obj:__handle_event	:= @cti_filed_handle_event()

	obj:set_size		:= @cti_filed_set_size()
	obj:set_position	:= @cti_filed_set_position()

	obj:get_file		:= @cti_filed_get_file()

	obj:destroy		:= @cti_filed_destroy()

	obj:__initiation()
return obj
*******************************************************************************
* Init fileDialog attributes
static function cti_filed_initiation(self)
local i, k, opm, item, s

	self:set_size(15, 60)
	self:center()

	opm := self:driverOption:get_menu()
	for i=67 to 90
		item := cti_menuitem_new(chr(i)+":")
		item:show()
		item:set_data(chr(i)+":")
		opm:add_item(item)
	next

	self:__parse_path()

	self:driverOption:show()
	self:put(self:driverOption, 1, 1)

	self:pathEntry:show()
	self:put(self:pathEntry, 1, 5)

	self:__set_file_list()
	self:fileList:show()
	self:put(self:fileList, 3, 1)

	self:okButton:show()

	self:cancelButton:show()

	self:findString:show()

return
*******************************************************************************
*
static function cti_filed_parse_path(self)
local i:=1, s, k
	self:__curDriver := currdrive()
	self:__curDir    := curdir()+"/"+self:cMask
	self:__curFile	 := ""
	if !empty(self:cPath)
		self:cPath := strtran(self:cPath, "//", "/")
		k := at(":", self:cPath)
		if k>0
			s:= upper(substr(self:cPath,1,k+1))
			i := ascan(self:driverOption:get_menu(), s)
			if i>0
				self:__curDriver := s
				self:driverOption:get_menu():select_item(i)
			endif
		endif
		self:__curDir := substr(self:cPath, k+1)
	endif
	k := atr("/", self:__curDir)
	s := ""
	if k>0
		s := substr(self:__curDir, k+1)
		self:__curDir := substr(self:__curDir, 1, k-1)
	endif
	if !empty(s)
		if "*"$s  // it is mask
			self:cMask := s
			self:__curFile := ""
		else
			self:__curFile := s
		endif
	endif
	self:pathEntry:set_value(self:__curDir+"/"+iif(empty(self:__curFile), self:cMask, self:__curFile)+ADD_SPACE)

return
********************************************************************************
*
static function cti_filed_set_size(self, nHeight, nWidth)
	CALL SUPER self:set_size(nHeight, nWidth)

	self:driverOption:set_size(1, 3)

	self:pathEntry:set_size(1, self:width - 6)

	self:fileList:set_size(self:height-6, self:width-2)

	self:fileList:set_column_auto_resize(1,.T.)
	self:fileList:set_column_auto_resize(2,.T.)
	self:fileList:set_column_auto_resize(3,.T.)
	self:fileList:set_column_auto_resize(4,.T.)
	self:fileList:set_column_auto_resize(5,.T.)
	self:fileList:column_titles_show(.t.)
	self:fileList:set_column_title(1, [Name])
	self:fileList:set_column_width(1, 15)
	self:fileList:set_column_title(2, [Attr])
	self:fileList:set_column_width(2, 3)
	self:fileList:set_column_title(3, [Size])
	self:fileList:set_column_width(3, 10)
	self:fileList:set_column_title(4, [Date])
	self:fileList:set_column_width(4, 10)
	self:fileList:set_column_title(5, [UTime])
	self:fileList:set_column_width(5, 10)

	self:findString:set_size(1, self:width-4)

return
********************************************************************************
*
static function cti_filed_set_position(self, nTop, nLeft)
	CALL SUPER self:set_position(nTop, nLeft)

	self:put(self:okButton, self:height-2 , 2)
	self:put(self:cancelButton, self:height-2, self:width-self:cancelButton:width-2)
	self:put(self:findString, self:height-3, 1)
return
********************************************************************************
*
static function cti_filed_set_file_list(self)
local current, a, b, i

	current := self:__curDriver+"/"+self:__curDir+"/"

	self:fileList:clear()

	a := fileseek(current, FA_DIRECTORY)
	b := {}
	while !empty(a)
		#ifdef OS_CYGWIN
		if a == ".."
			a := fileseek()
			loop
		endif
		if a == "."
			a := ".."
		endif
		#else
		if a == "."
			a := fileseek()
			loop
		endif
		#endif
		aadd(b, {a+"/", padr(fileattrs(), 5), alltrim(toString(filesize())), dtoc(filedate()), filetime()})
		a := fileseek()
	enddo
	b := asort(b,,,{|x, y| x[1] < y[1]})
	for i=1 to len(b)
		self:fileList:append(b[i])
	next

	b = {}
	a = fileseek(current+self:cMask, FA_ARCHIVE+FA_VOLUME+FA_SYSTEM+FA_HIDDEN+FA_READONLY)
	while !empty(a)
		aadd(b, {a, padr(fileattrs(), 5), alltrim(toString(filesize())), dtoc(filedate()), filetime()})
		a = fileseek()
	enddo
	b := asort(b,,,{|x, y| x[1] < y[1]})
	for i=1 to len(b)
		self:fileList:append(b[i])
	next
	self:fileList:move_to(1)
return
*******************************************************************************
*
static function cti_filed_get_file(self)
local cell
	cell := self:fileList:get_cell(1)
return strtran(self:__curDriver+"/"+self:__curDir+"/"+cell, "//", "/")
*******************************************************************************
*
static function cti_filed_handle_event(self, event)
static findStr := ""
local path, fattr, k
	if event:type != CTI_KEYBOARD_EVENT
		return .t.
	endif
	do case
	case event:keycode == K_ENTER .and. self:pathEntry:is_focus()
		event:type := CTI_NOTHING_EVENT
		findStr := ""
		self:findString:set_text(">"+findStr)
		path := alltrim(self:pathEntry:get_value())
		k := at("*", path)
		if k>0
			self:cPath := path
			self:__parse_path()
			self:__stabilize()
			self:__set_file_list()
			if !empty(self:__curFile)
				self:retFile := self:get_file()
				self:okButton:signal_emit(HASH_CTI_CLICKED_SIGNAL)
			endif
			return
		endif
		fattr := fileattr(path)
		if fattr >= FA_ARCHIVE //is file
			self:retFile := self:get_file()
			self:okButton:signal_emit(HASH_CTI_CLICKED_SIGNAL)
		elseif fattr > 0 .and. fattr < FA_ARCHIVE // is directory
			self:cPath := path+"/"+self:cMask
			self:__parse_path()
			self:__stabilize()
			self:__set_file_list()
		else
			self:retFile := self:pathEntry:get_value()
			self:okButton:signal_emit(HASH_CTI_CLICKED_SIGNAL)
		endif
	case event:keycode == K_ENTER .and. self:fileList:is_focus()
		event:type := CTI_NOTHING_EVENT
		findStr := ""
		self:findString:set_text(">"+findStr)
		path := self:get_file()
		k := at("*", path)
		if k>0
			self:cPath := self:pathEntry:get_value()
			self:__parse_path()
			self:__set_file_list()
			if !empty(self:__curFile)
				self:retFile := self:get_file()
				self:okButton:signal_emit(HASH_CTI_CLICKED_SIGNAL)
			endif
			return
		endif
		fattr := fileattr(path)
		if fattr >= FA_ARCHIVE //is file
		/*
			self:retFile := self:get_file()
			self:okButton:signal_emit(HASH_CTI_CLICKED_SIGNAL)
		*/
			self:cPath := self:get_file()
			self:__parse_path()
			self:set_focus(self:pathEntry)
		elseif fattr > 0 .and. fattr < FA_ARCHIVE // is directory
			k := at("..", path)
			if k>0
				path := substr(path, 1, k-2)
				k := atr("/", path)
				if k>0
					findStr := substr(path, k+1)
					path := substr(path, 1, k-1)
				endif
			endif

			self:cPath := path+"/"+self:cMask
			self:__parse_path()
			self:__stabilize()
			self:__set_file_list()
			if !empty(findStr)
				k := self:fileList:find({|list, row| left(row[1], len(findStr)) == findStr })
				if k>0 ; self:fileList:move_to(k); endif
			endif
			event:type := CTI_NOTHING_EVENT
		endif
	case self:driverOption:is_focus() .and. ;
	     (event:keycode == K_DOWN .or. event:keycode == K_UP .or. ;
	     event:keycode == K_PGUP .or. event:keycode == K_PGDN)

		findStr := ""
		self:findString:set_text(">"+findStr)
		self:driverOption:__handle_event(event)
		diskchange(self:driverOption:get_value())
		self:cPath := curdir()+"/"+self:cMask
		self:__parse_path()
		self:__set_file_list()
	case event:keycode == K_HOME .and. self:fileList:is_focus()
		event:type := CTI_NOTHING_EVENT
		findStr := ""
		self:findString:set_text(">"+findStr)
		self:fileList:home()
	case event:keycode == K_END .and. self:fileList:is_focus()
		event:type := CTI_NOTHING_EVENT
		findStr := ""
		self:findString:set_text(">"+findStr)
		self:fileList:end()
	case event:keycode >= 32 .and. event:keycode <= 256 .and. ;
		self:fileList:is_focus()
		event:type := CTI_NOTHING_EVENT
		findStr += chr(event:keycode)
		k := self:fileList:find({|list, row| left(row[1], len(findStr)) == findStr})
		if k>0
			self:fileList:move_to(k)
			self:findString:set_text(">"+findStr)
		else
			findStr := left(findStr,len(findStr)-1)
		endif
	case event:keycode == K_BS .and. ;
	     self:fileList:is_focus() .and. !empty(findStr)
		event:type := CTI_NOTHING_EVENT
		findStr := left(findStr,len(findStr)-1)
		k := self:fileList:find({|list, row| left(row[1], len(findStr)) == findStr})
		if k>0
			self:fileList:move_to(k)
			self:findString:set_text(">"+findStr)
		endif
	case event:keycode == K_ESC
		event:type := CTI_NOTHING_EVENT
		self:__curDriver := ""
		self:__curDir    := ""
		self:__curFile   := ""
		self:cancelButton:signal_emit(HASH_CTI_CLICKED_SIGNAL)
	otherwise
		CALL SUPER self:__handle_event(event)
	endcase
return
*******************************************************************************
*
static function cti_filed_stabilize(self)
local k
	diskchange(self:__curDriver)
	k := dirchange(self:__curDir)
	if k==-5
		alert("Permission denied!")
		self:cPath := curdir()
		self:__parse_path()
	endif
return
*******************************************************************************
*
static function cti_filed_destroy(self)
	/*self:driverOption:destroy()
	self:pathEntry:destroy()
	self:fileList:destroy()
	self:okButton:destroy()
	self:cancelButton:destroy()
	self:findString:destroy()*/

	CALL SUPER self:destroy()
return
