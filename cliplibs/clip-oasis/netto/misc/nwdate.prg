/*
 * File......: NWDATE.PRG
 * Author....: Glenn Scott / David Peterson
 * CIS ID....: 76370,1532
 * Date......: $Date$
 * Revision..: $Revision$
 * Log file..: $Logfile$
 *
 * This is an original work by Glenn Scott and David Peterson
 * and is placed in the public domain.
 *
 * Notes: David Peterson reworked all the date code for 
 * internationalization.
 *
 * Modification history:
 * ---------------------
 *
 * $Log$
 * Revision 1.1  2006/06/22 20:12:13  itk
 * uri: init sf.net
 *
 * Revision 1.1  2002/03/09 13:58:12  clip
 * uri: start :) "netto" library
 *
 *
 */

#include "netto.ch"

function _fndt2Str( dDate, cTime )
  local cDt := "", aDate

  default dDate to ctod(""), ;
          cTime to "99:99:99"


  if dDate == ctod("") .or. cTime == "99:99:99"
     cDt := repl( chr( -1 ), 6 )      // FFFFFFFFFFFFh
  else
     // Convert to international date format
     cDt := _fndtonc(dDate) + _fnttonc(cTime)
  endif
     
  return cDt

/* ------------------------------------------------------------------ */

function _fnStr2dt( cStr )
  local dDate, cTime

  default cStr to repl( chr( - 1 ), 6 )     // FFFFFFFFFFFFh

  if cStr == repl( chr( -1 ), 6 )
     dDate := ctod( "  /  /  ")
     cTime := "99:99:99"
  else
     dDate := _fnnctod( subs( cStr, 1, 3 ) )
     cTime := _fnnctot( subs( cStr, 4, 3 ) )
  endif

  return { dDate, cTime }

/* ------------------------------------------------------------------ */
  
/*
 * _fnnctod() - Convert Novell 3 byte date string to a Clipper date
 *
 */

function _fnnctod(cDate)
   LOCAL dDate, cDateFormat := SET(_SET_DATEFORMAT)
   SET(_SET_DATEFORMAT, "yy/mm/dd")
   dDate  := ctod( str( BYTE2I( substr( cDate, 1, 1 ) ), 2 ) + "/" + ;
                   str( BYTE2I( substr( cDate, 2, 1 ) ), 2 ) + "/" + ;
                   str( BYTE2I( substr( cDate, 3, 1 ) ), 2 ) )
   SET(_SET_DATEFORMAT, cDateFormat)
   return dDate
  
/*
 * _fndtonc() - Convert Clipper date into the Novell 3-byte date string
 *
 */

function _fndtonc(dDate)
   LOCAL cNDate

   cNDate  := I2BYTE( year  (dDate) % 100 ) + ;
              I2BYTE( month (dDate)       ) + ;
              I2BYTE( day   (dDate)       )

   return cNDate
  
/*
 * _fnttonc() - Convert a Clipper time to the Novell 3 byte time string
 *
 */

function _fnttonc(cTime)
   LOCAL cNTime

   cNTime  := I2BYTE( val( subs( cTime, 1, 2 ) ) ) + ;
              I2BYTE( val( subs( cTime, 4, 2 ) ) ) + ;
              I2BYTE( val( subs( cTime, 7, 2 ) ) )

   return cNTime

/*
 * _fnnctot() - Convert a Novell 3 byte time string to a Clipper time
 *
 */

function _fnnctot(cNTime)
   LOCAL cTime

   cTime  := _fnstrz( BYTE2I( substr( cNTime, 1, 1 ) ), 2 ) + ":" + ;
             _fnstrz( BYTE2I( substr( cNTime, 2, 1 ) ), 2 ) + ":" + ;
             _fnstrz( BYTE2I( substr( cNTime, 3, 1 ) ), 2 ) 

   return cTime

/*
 * _fnintod() - Convert Year, Month and Day values to a date
 *
 */

function _fnintod(nYear, nMonth, nDay)
   LOCAL dDate, cDateFormat := SET(_SET_DATEFORMAT)
   SET(_SET_DATEFORMAT, "yy/mm/dd")
   dDate  := ctod( str( nYear,  2 ) + "/" + ;
                   str( nMonth, 2 ) + "/" + ;
                   str( nDay,   2 ) )
   SET(_SET_DATEFORMAT, cDateFormat)
   return dDate
  
/*
 * _fndtoin() - Convert date to Year, Month and Day values.
 * The values are returned as an array {Year, Month, Day}
 *
 */

function _fndtoin(dDate)
   LOCAL nYear, nMonth, nDay

   nYear  := year  (dDate) % 100
   nMonth := month (dDate)
   nDay   := day   (dDate)

   return { nYear, nMonth, nDay }
  

/*
 * _fndtoic() - Convert Clipper Date to an international date
 * in the form "yy/mm/dd"
 *
 */

function _fndtoic(dDate)
   LOCAL cDate, cDateFormat := SET(_SET_DATEFORMAT)

   SET(_SET_DATEFORMAT, "yy/mm/dd")
   cDate := dtoc(dDate)
   SET(_SET_DATEFORMAT, cDateFormat)

   return cDate
  

/*
 * _fnictod() - Convert an international date in the form "yy/mm/dd"
 * to a Clipper date
 *
 */

function _fnictod(cDate)
   LOCAL dDate, cDateFormat := SET(_SET_DATEFORMAT)

   SET(_SET_DATEFORMAT, "yy/mm/dd")
   dDate := ctod(cDate)
   SET(_SET_DATEFORMAT, cDateFormat)

   return dDate

static function _fnstrz( n, w )
  return padl( alltrim( str( n ) ), w, "0" )
  

