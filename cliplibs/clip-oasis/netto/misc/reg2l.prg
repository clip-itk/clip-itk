/*
 * File......: REG2L.PRG
 * Author....: Glenn Scott
 * CIS ID....: 71620,1521
 * Date......: $Date: 2002/03/09 13:58:12 $
 * Revision..: $Revision: 1.1 $
 * Log file..: $Logfile$
 * 
 * This is an original work by Glenn Scott and is placed in the
 * public domain.
 *
 * Modification history:
 * ---------------------
 *
 * $Log: reg2l.prg,v $
 * Revision 1.1  2002/03/09 13:58:12  clip
 * uri: start :) "netto" library
 *
 *
 */

// _fnReg2L takes two numerics and converts them to one long; 
// useful for when you're told a return value is in CX, DX

function _fnReg2L( n1, n2 )
  return bin2l( i2bin( n1 ) + i2bin( n2 ) )

// _fnL2Reg splits a long into two 16-bit halves; useful
// for loading a number into two registers, e.g., CX, DX

function _fnL2Reg( n )
  local cTmp := l2bin( n )
  return { bin2i( subs( cTmp, 1, 2 ) ), bin2i( subs( cTmp, 3, 2 ) ) }
