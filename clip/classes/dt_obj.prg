/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html

    class DATETIME
*/

*****************************************
function dateTimeNew(p1,p2,p3,p4,p5,p6,p7)
	local obj:=map()

	obj:classname	:= "DATETIME"
	obj:data	:= dt_create(p1,p2,p3,p4,p5,p6,p7)

	_recover_datetime(obj)

return obj

*****************************************
function _recover_datetime(obj)
	obj:date	:= @odt_date()
	obj:time	:= @odt_time()
	obj:year	:= @odt_year()
	obj:month	:= @odt_month()
	obj:day		:= @odt_day()
	obj:hour	:= @odt_hour()
	obj:min		:= @odt_min()
	obj:sec		:= @odt_sec()
	obj:msec	:= @odt_msec()

	obj:normalize	:= @odt_normalize()
	obj:add		:= @odt_add()
	obj:sub		:= @odt_sub()
return obj

*****************************************
static function odt_date()
return dt_date(::data)

*****************************************
static function odt_time()
return dt_time(::data)

*****************************************
static function odt_year()
return dt_year(::data)

*****************************************
static function odt_month()
return dt_month(::data)

*****************************************
static function odt_day()
return dt_day(::data)

*****************************************
static function odt_hour()
return dt_hour(::data)

*****************************************
static function odt_min()
return dt_min(::data)

*****************************************
static function odt_sec()
return dt_sec(::data)

*****************************************
static function odt_msec()
return dt_msec(::data)

*****************************************
static function odt_normalize(self)
	dt_normalize(@self:data)
return self

*****************************************
static function odt_add(self,dt)
	dt_add(::data,dt:data)
return self

*****************************************
static function odt_sub(self,dt)
	dt_sub(::data,dt:data)
return self


