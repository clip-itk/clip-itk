/*
    Copyright (C) 2002  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

/*
  demonstration TRIGGERs in CODB from plugins
*/

static members := {;
	{"BEFORE_DELETE_OBJECT",	{|p1,p2,p3,p4,p5| trigger01(p1,p2,p3,p4,p5)} },;
	{"AFTER_DELETE_OBJECT",		{|p1,p2,p3,p4,p5| trigger02(p1,p2,p3,p4,p5)} },;
	{"BEFORE_APPEND_OBJECT",	{|p1,p2,p3,p4,p5| trigger03(p1,p2,p3,p4,p5)} },;
	{"AFTER_APPEND_OBJECT",		{|p1,p2,p3,p4,p5| trigger04(p1,p2,p3,p4,p5)} },;
	{"BEFORE_UPDATE_OBJECT",	{|p1,p2,p3,p4,p5| trigger05(p1,p2,p3,p4,p5)} },;
	{"AFTER_UPDATE_OBJECT",		{|p1,p2,p3,p4,p5| trigger06(p1,p2,p3,p4,p5)} },;
	{"AFTER_GETVALUE_OBJECT",	{|p1,p2,p3,p4,p5| trigger07(p1,p2,p3,p4,p5)} },;
	{"BEFORE_SELECT_OBJECT",	{|p1,p2,p3,p4,p5| trigger08(p1,p2,p3,p4,p5)} },;
	{"AFTER_SELECT_OBJECT",		{|p1,p2,p3,p4,p5| trigger09(p1,p2,p3,p4,p5)} },;
	{"BEFORE_CLOSE_DEPOSITORY",	{|p1,p2,p3,p4,p5| trigger10(p1,p2,p3,p4,p5)} },;
	{"AFTER_CLOSE_DEPOSITORY",	{|p1,p2,p3,p4,p5| trigger11(p1,p2,p3,p4,p5)} },;
	{"BEFORE_CLOSE_DICTIONARY",	{|p1,p2,p3,p4,p5| trigger12(p1,p2,p3,p4,p5)} },;
	{"AFTER_CLOSE_DICTIONARY",	{|p1,p2,p3,p4,p5| trigger13(p1,p2,p3,p4,p5)} },;
	{"AFTER_OPEN_DICTIONARY",	{|p1,p2,p3,p4,p5| trigger14(p1,p2,p3,p4,p5)} },;
	{"BEFORE_SELECT_DICTIONARY",	{|p1,p2,p3,p4,p5| trigger15(p1,p2,p3,p4,p5)} },;
	{"AFTER_SELECT_DICTIONARY",	{|p1,p2,p3,p4,p5| trigger16(p1,p2,p3,p4,p5)} },;
	{"AFTER_GETVALUE_CLASS",	{|p1,p2,p3,p4,p5| trigger17(p1,p2,p3,p4,p5)} },;
	{"BEFORE_DELETE_CLASS",		{|p1,p2,p3,p4,p5| trigger18(p1,p2,p3,p4,p5)} },;
	{"AFTER_DELETE_CLASS",		{|p1,p2,p3,p4,p5| trigger19(p1,p2,p3,p4,p5)} },;
	{"BEFORE_APPEND_CLASS",		{|p1,p2,p3,p4,p5| trigger20(p1,p2,p3,p4,p5)} },;
	{"AFTER_APPEND_CLASS",		{|p1,p2,p3,p4,p5| trigger21(p1,p2,p3,p4,p5)} },;
	{"BEFORE_UPDATE_CLASS",		{|p1,p2,p3,p4,p5| trigger22(p1,p2,p3,p4,p5)} },;
	{"AFTER_UPDATE_CLASS",		{|p1,p2,p3,p4,p5| trigger23(p1,p2,p3,p4,p5)} };
}

local i,ret := NIL, nmember
parameters query_key
	query_key := alltrim(upper(query_key))
	if query_key=="MEMBERS"
		ret:={}
		for i=1 to len(members)
			aadd(ret,members[i][1])
		next
	endif
	nmember := ascan(members,{|x|x[1]==query_key})
	if nmember !=0
		ret := members[nMember][2]
	endif
	if ret == NIL
		ret:= "Error query key in sample plugins."
	endif

return ret

****************************************
static function trigger_outlog(nTrigger)
	outlog("Called trigger: sample:",members[nTrigger])
return .t.
****************************************
static function trigger01(p1,p2,p3,p4,p5)
	trigger_outlog(01)
return .t.
****************************************
static function trigger02(p1,p2,p3,p4,p5)
	trigger_outlog(02)
return .t.
****************************************
static function trigger03(p1,p2,p3,p4,p5)
	trigger_outlog(03)
return .t.
****************************************
static function trigger04(p1,p2,p3,p4,p5)
	trigger_outlog(04)
return .t.
****************************************
static function trigger05(p1,p2,p3,p4,p5)
	trigger_outlog(05)
return .t.
****************************************
static function trigger06(p1,p2,p3,p4,p5)
	trigger_outlog(06)
return .t.
****************************************
static function trigger07(p1,p2,p3,p4,p5)
	trigger_outlog(07)
return .t.
****************************************
static function trigger08(p1,p2,p3,p4,p5)
	trigger_outlog(08)
return .t.
****************************************
static function trigger09(p1,p2,p3,p4,p5)
	trigger_outlog(09)
return .t.
****************************************
static function trigger10(p1,p2,p3,p4,p5)
	trigger_outlog(10)
return .t.
****************************************
static function trigger11(p1,p2,p3,p4,p5)
	trigger_outlog(11)
return .t.
****************************************
static function trigger12(p1,p2,p3,p4,p5)
	trigger_outlog(12)
return .t.
****************************************
static function trigger13(p1,p2,p3,p4,p5)
	trigger_outlog(13)
return .t.
****************************************
static function trigger14(p1,p2,p3,p4,p5)
	trigger_outlog(14)
return .t.
****************************************
static function trigger15(p1,p2,p3,p4,p5)
	trigger_outlog(15)
return .t.
****************************************
static function trigger16(p1,p2,p3,p4,p5)
	trigger_outlog(16)
return .t.
****************************************
static function trigger17(p1,p2,p3,p4,p5)
	trigger_outlog(17)
return .t.
****************************************
static function trigger18(p1,p2,p3,p4,p5)
	trigger_outlog(18)
return .t.
****************************************
static function trigger19(p1,p2,p3,p4,p5)
	trigger_outlog(19)
return .t.
****************************************
static function trigger20(p1,p2,p3,p4,p5)
	trigger_outlog(20)
return .t.
****************************************
static function trigger21(p1,p2,p3,p4,p5)
	trigger_outlog(21)
return .t.
****************************************
static function trigger22(p1,p2,p3,p4,p5)
	trigger_outlog(22)
return .t.
****************************************
static function trigger23(p1,p2,p3,p4,p5)
	trigger_outlog(23)
return .t.

