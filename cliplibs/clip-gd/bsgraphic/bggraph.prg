/*   Business graphics - total business graphic 	     */
/*   Copyright (C) 2001  ITK                                 */
/*   Author  : Elena Kornilova (alena@itk.ru)                */
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html  */

#include "gdinfo.ch"
#include "bggraph.ch"

function BgNew(bgType, width, high)
local obj
	if bgType==NIL
		return .f.
	endif
	switch (bgType)
	case BG_TYPE_HIST
		obj := BgHistNew(width, high)
	case BG_TYPE_HIST_CUMUL
		obj := BgHistCumulNew(width, high)
	case BG_TYPE_HIST_NORM
		obj := BgHistNormNew(width, high)
	case BG_TYPE_HIST_3D
		obj := BgHist3DNew(width, high)
	case BG_TYPE_LINE
		obj := BgLineNew(width, high)
	case BG_TYPE_LINE_CUMUL
		obj := BgLineCumulNew(width, high)
	case BG_TYPE_LINE_NORM
		obj := BgLineNormNew(width, high)
	case BG_TYPE_CIRCLE
		obj := BgCircleNew(width, high)
	case BG_TYPE_RING
		obj := BgRingNew(width, high)
	otherwise
		return .f.
	end

return obj
