/* defines  for debug windows*/
#ifndef _DEBUG_DEFINED
#define _DEBUG_DEFINED

#define COMMAND_SIZE 6

#define VALUES_SIZE 6
/*
#define DBG_HEADSEP      "†∂†"
#define DBG_COLSEP       " Å "
*/

#define DBG_HEADSEP      translate_charset(__CHARSET__,host_charset(),"∂†")
#define DBG_COLSEP       translate_charset(__CHARSET__,host_charset(),"Å ")

#define DBG_BORDER_CLR   "15/7"
#define DBG_DELIM       ";"

#endif
