/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

#ifndef __CTI_WIDGET_CH__
#define __CTI_WIDGET_CH__

#define		CTI_IS_WIDGET(obj)	(cti_check_cast(obj,"CTI_WIDGET"))

#define		CTI_WIDGET_IS_FOCUSED(obj)	(CTI_IS_WIDGET(obj) .and. obj:__is_focused)

#define		CTI_SHOW_SIGNAL		HASH_CTI_SHOW_SIGNAL
#define		CTI_HIDE_SIGNAL		HASH_CTI_HIDE_SIGNAL
#define		CTI_DRAW_SIGNAL		HASH_CTI_DRAW_SIGNAL
#define		CTI_DRAW_QUEUE_SIGNAL	HASH_CTI_DRAW_QUEUE_SIGNAL
#define		CTI_SET_SIZE_SIGNAL	HASH_CTI_SET_SIZE_SIGNAL
#define		CTI_SET_POSITION_SIGNAL	HASH_CTI_SET_POSITION_SIGNAL

#endif
