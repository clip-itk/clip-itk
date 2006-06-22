/*
    Copyright (C) 2003  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
**************************************************
function codb_error(num)
	static last_error:=""
	if num == NIL
		return last_error
	endif
	do switch (num)
		case 1001
			last_error := [Invalid dictionary identification]
		case 1002
			last_error := [Dictionary not inizialized]
		case 1003
			last_error := [Already exist dictionary with ID]
		case 1004
			last_error := [Not found dictionary with ID]
		case 1005
			last_error := [Error locking record]
		case 1006
			last_error := [Error find dictionary ID]
		case 1007
			last_error := [Invalid arguments]
		case 1008
			last_error := [System error]
/*
		case 1009
			last_error := [Can`t switch access mode to readwrite]
*/
		case 1010
			last_error := [Bad type of dictionary]
/* dictionary errors */
		case 1020
			last_error := [Dictionary path not inizialized]
		case 1021
			last_error := [Dictionary already exist]
		case 1022
			last_error := [Can`t create file]
		case 1023
			last_error := [Error SEEK metaIdx identification]
		case 1024
			last_error := [Can~t read CODB version]
		case 1025
			last_error := [CODB version is not compatible! Please run program codb_make for convertation data]
		case 1026
			last_error := [Dictionary counters open error]
		case 1027
			last_error := [Error open meta data table]
		case 1028
			last_error := [Error open meta index table]
		case 1029
			last_error := [Can~t make directory]
		case 1030
			last_error := [Can`t open counters database]
		case 1031
			last_error := [Not defined filename in plugins]
		case 1032
			last_error := [Not defined main function in plugins]
		case 1033
			last_error := [Plugins file not found]
		case 1034
			last_error := [Error loading plugins]
		case 1035
			last_error := [Module file not found]
		case 1036
			last_error := [Error loading module]
		case 1037
			last_error := [Error loading shared library]
		case 1038
			last_error := [Plugins main function not found]
		case 1039
			last_error := [Plugins main function not found in linked modules]
		case 1040
			last_error := [Main function not has method "MEMBERS" in plugins]
		case 1041
			last_error := [Non unique name of new class]
		case 1042
			last_error := [Can`t check class ID for data]
		case 1043
			last_error := [Meta name not defined]
		case 1044
			last_error := [Bad attribute name]
		case 1045
			last_error := [Bad method/attribute name]
/* depository errors */
		case 1100
			last_error := [Depository identification not found]
		case 1101
			last_error := [Depository already exist]
		case 1102
			last_error := [Error create file]
		case 1104
			last_error := [Can`t open counters database]
		case 1108
			last_error := [Can~t create directory]
		case 1120
			last_error := [Can~t read CODB version !]
		case 1121
			last_error := [Error open extent]
		case 1122
			last_error := [Can`t check class ID for data]
		case 1123
			last_error := [Can`t seek in refTable object ID]
		case 1124
			last_error := [Can`t seek in idxTable object ID]
		case 1125
			last_error := [Depository counters open error]
		case 1126
			last_error := [CODB version is not compatible! Please run program codb_make for convertation data]
		case 1127
			last_error := [Error open ref table]
		case 1128
			last_error := [Error open data index table]
		case 1129
			last_error := [Extent ID not defined]
		case 1130
			last_error := [Extent already exist]
		case 1139
			last_error := [Empty object ID]
		case 1140
			last_error := [Eval expression error]
		case 1141
			last_error := [Bad depository number or identification]
		case 1142
			last_error := [Can`t open extent with empty ID]
		case 1143
			last_error := [Non unique object attribute]
		case 1199
			last_error := [Unknown internal depository error]
/* counters errors */
		case 1200
			last_error := [ Counter`s not activated]
		case 1201
			last_error := [Counter ID not found]
		case 1202
			last_error := [Error locking counter ID]
		case 1203
			last_error := [Counter unknown error in Add value]
		case 1204
			last_error := [Count ID not defined]
		case 1205
			last_error := [Counter ID already exist]
		case 1206
			last_error := [Counter file already exist]
/* extent errors */
		case 1251
			last_error := [Error open extent table]
		case 1252
			last_error := [Can`t seek in extent Table object ID]
		case 1253
			last_error := [Can`t lock object with ID]
/* OQL errors */
		case 1300
			last_error := [Can`t found class name in query expression]
		otherwise
			last_error := [Unknown error code]
	endswitch
	last_error:=str(num,4,0)+":"+last_error+" [ called from "+procname(1)+"("+alltrim(str(procline(1)))+")]"

return last_error
