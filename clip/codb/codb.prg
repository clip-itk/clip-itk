/*
    Copyright (C) 2002  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "codbcfg.ch"


/******************************/
init procedure codb_init()
	set translate path off
	//rddSetDefault(CODB_RDD_DEFAULT)
	set autorder to 1
	set optimize on
	//set map file on
	set("C:","/")
	DiskChange("C")
	outlog(2,"add drive C: as /",__FILE__,__LINE__)
return

