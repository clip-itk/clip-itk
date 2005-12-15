/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library					   */
/*						                 	   */
/*   Copyright (C) 2003-2005 by E/AS Software Foundation	           */
/*   Author: Andrey Cherepanov <skull@eas.lrn.ru>			   */
/*   									   */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/

/* Header file for common CLIP-UI definition */
#define lib_version 	"0.1.2.3"

/* Default driver name */
#define DEFAULT_DRIVER	"gtk"

/* Page settings for UIPrinter. TODO: need to move in client sources */
/* Measurement units */
#define PRINT_PT	0
#define PRINT_CM	1
#define PRINT_MM	2
#define PRINT_INCH	3

/* Page orientation */
#define PAGE_PORTRAIT	0
#define PAGE_LANDSCAPE	1

/* Page size */
#define PAGE_A4		0    

/* Cell anchoring */
#define CELL_ABOVE	0
#define CELL_BELOW	1
#define CELL_LEFT	2
#define CELL_RIGHT	3

/* Cell align */
#define ALIGN_LEFT	0
#define ALIGN_CENTER	1
#define ALIGN_RIGHT	2
#define ALIGN_JUSTIFY	3
#define ALIGN_TOP	0
#define ALIGN_MIDDLE	1
#define ALIGN_BOTTOM	2

/* Cell side anchoring */
#define CELL_SIDE_BOTTOM	0
#define CELL_SIDE_LEFT		1

/* Points in mm  */
/* Note: if you use ps2pdf command for covert to PDF PT_IN_MM is equal 2.946 */
/* PT_MARGIN is 12 */
#define PT_IN_MM	2.83465
#define PT_MARGIN	0


/* COLOR */
#define ALT_TABLE_ROW_COLOR	"#eef6ff"

/* Preview programs */
#define WINDOWS_PRINT_PREVIEW	"start"
#define UNIX_PRINT_PREVIEW	"ggv"

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
