// Copyright (c) 2004 by Igor Satsyuk
// Author: Igor Satsyuk <satsyuk@tut.by>
// License : (GPL) http://www.itk.ru/clipper/license.html
// Last change: 30 July 2004

//====================================================================
// Left shift the bits of a byte by n bits
// Parameters:	<ExpC1>	- byte to left shift
//		<ExpN1>	- number of bits by which to move byte left
// Returns:	<ExpC>	- The left-shifted byte
//====================================================================
function ft_byteshl(cByte, nPos)
	local nVal

	nVal := mod((asc(cByte) * (2^nPos)), 256)

return(chr(nVal))

//====================================================================
// Right shift the bits of a byte by n bits
// Parameters:	<ExpC1>	- byte to right shift
//		<ExpN1>	- number of bits by which to move byte right
// Returns:	<ExpC>	- The right-shifted byte
//====================================================================
function ft_byteshr(cByte, nPos)
	local nVal

	nVal := int((asc(cByte) / (2^nPos)))

return(chr(nVal))
