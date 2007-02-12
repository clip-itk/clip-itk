/*-------------------------------------------------------------------------*/
/*   This is a part of library clip-postscript							   */
/*													                 	   */
/*   Copyright (C) 2007 by E/AS Software Foundation 					   */
/*   Author: Andrey Cherepanov <skull@eas.lrn.ru>						   */
/*  								 									   */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/

/* Header file for common CLIP-POSTSCRIPT definition */

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

/* Block types */
#define O_TEXT			1
#define O_TABLE			2
#define O_ROW			3
#define O_CELL			4
#define O_HEADER		5
#define O_FOOTER		6
#define O_PAGE_HEADER	7
#define O_PAGE_FOOTER	8
#define O_SECTION		9
#define O_VARIABLE		10
#define O_PAGE 			11

/* Cell align */
#define C_ALIGN_LEFT	0
#define C_ALIGN_CENTER	1
#define C_ALIGN_RIGHT	2
#define C_ALIGN_JUSTIFY	3
#define C_ALIGN_TOP		0
#define C_ALIGN_MIDDLE	1
#define C_ALIGN_BOTTOM	2

/* Points in mm  */
/* Note: if you use ps2pdf command for covert to PDF PT_IN_MM is equal 2.946 */
/* PT_MARGIN is 12 */
#define PT_IN_MM	2.83465
#define PT_MARGIN	0

/* COLOR */
#define ALT_TABLE_ROW_COLOR	"#eef6ff"

/* Preview programs */
#define WINDOWS_PRINT_PREVIEW	"start"
#define UNIX_PRINT_PREVIEW		"evince"

