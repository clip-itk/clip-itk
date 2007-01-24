/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library                                     */
/*                                                                         */
/*   Copyright (C) 2003-2006 by E/AS Software Foundation                   */
/*   Author: Andrey Cherepanov <skull@eas.lrn.ru>                          */
/*                                                                         */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/
#ifndef CLIP_UI_CH
#define CLIP_UI_CH

/* Header file for common CLIP-UI definition */
#define lib_version 	"0.1.4"

/* Default driver name */
#define DEFAULT_DRIVER	"gtk2"

/* SPLITTER DIRECTION */
#define SPLITTER_HORIZONTAL	0
#define SPLITTER_VERTICAL	1

/* IMAGES */
#define IMG_EMPTY	1	// Empty transparent pixmap
#define IMG_OK		2	// i
#define IMG_ERROR	3	// Error (cross on red field)
#define IMG_WARNING	4	// Exclamation mark
#define IMG_QUESTION	5	// ?

/* FRAME TYPES */
#define FRAME_PLAIN	0
#define FRAME_SUNKEN	1
#define FRAME_RAISED	2
#define FRAME_IN	3
#define FRAME_OUT	4

/* TABLE COLUMN TYPES */
#define TABLE_COLUMN_TEXT		0
#define TABLE_COLUMN_CHOICE		1
#define TABLE_COLUMN_COMBO		2
#define TABLE_COLUMN_NUMBER		3
#define TABLE_COLUMN_DATE		4
#define TABLE_COLUMN_CHECK		5
#define TABLE_COLUMN_COUNTER	6

/* Alignment */
#define ALIGN_LEFT	0
#define ALIGN_CENTER	1
#define ALIGN_RIGHT	2
#define ALIGN_JUSTIFY	3
#define ALIGN_TOP	0
#define ALIGN_MIDDLE	1
#define ALIGN_BOTTOM	2

#endif