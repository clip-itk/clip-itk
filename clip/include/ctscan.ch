/****
*
*    CTSCAN.CH
*
*    Symbolic key code constants for the KEYSEND(), KEYREAD() and
*    SCANKEY() functions.
*
*    Lothar Bongartz
*    Copyright (c) 1991-93 Computer Associates International.
*    All Rights Reserved.
*
*    Version 5.2
*
**********************************************************************

**************************** Scan codes ******************************
*
* The symbolic constants described below contain the ASCII code for
* a key (when present) as well as its scan code, in the following
* format:
*
*		CHR(<ASCII-Code>) + CHR(<Scancode>)
*
*
* GENERAL EXPLANATION
* The byte containing the scan code can be helpful in handling keys
* that otherwise can not be differentiated.
*
* For example, the decimal point key on the numeric key pad of an
* extended keyboard has an ASCII value of 46 and the scan code 83,
* while the dot key in the letter field also has an ASCII value of
* 46, but returns a scan code of 52. Using for example the function
* SCANKEY(), you could differentiate those two keys.
*
* All the combinations listed below relate to a US keyboard.  As the
* need arises please take note of all combinations of X or Y, as
* well as special characters like the previously mentioned comma key
* on the numeric key pad.  Particular attention should be paid to
* special key codes when using a keyboard driver.
*
* If defined BIOS scan codes are used in the file, you may not use
* the CT.CH include file, or you must remove the _S87KEYS
* EXTERNAL declaration.
*
*****************************************************************
*
*	   KS - (K)eyboard (S)cancode	   ASCII    Scancode
*/

#define 	KS_DISABLE		  CHR(255) + CHR(255)


/* Letters and Numbers
*/
#define 	KS_A			  CHR(65)  + CHR(30)
#define 	KS_B			  CHR(66)  + CHR(48)
#define 	KS_C			  CHR(67)  + CHR(46)
#define 	KS_D			  CHR(68)  + CHR(32)
#define 	KS_E			  CHR(69)  + CHR(18)
#define 	KS_F			  CHR(70)  + CHR(33)
#define 	KS_G			  CHR(71)  + CHR(34)
#define 	KS_H			  CHR(72)  + CHR(35)
#define 	KS_I			  CHR(73)  + CHR(23)
#define 	KS_J			  CHR(74)  + CHR(36)
#define 	KS_K			  CHR(75)  + CHR(37)
#define 	KS_L			  CHR(76)  + CHR(38)
#define 	KS_M			  CHR(77)  + CHR(50)
#define 	KS_N			  CHR(78)  + CHR(49)
#define 	KS_O			  CHR(79)  + CHR(24)
#define 	KS_P			  CHR(80)  + CHR(25)
#define 	KS_Q			  CHR(81)  + CHR(16)
#define 	KS_R			  CHR(82)  + CHR(19)
#define 	KS_S			  CHR(83)  + CHR(31)
#define 	KS_T			  CHR(84)  + CHR(20)
#define 	KS_U			  CHR(85)  + CHR(22)
#define 	KS_V			  CHR(86)  + CHR(47)
#define 	KS_W			  CHR(87)  + CHR(17)
#define 	KS_X			  CHR(88)  + CHR(45)
#define 	KS_Y			  CHR(89)  + CHR(21)
#define 	KS_Z			  CHR(90)  + CHR(44)

#define 	KS_a			  CHR(97)  + CHR(30)
#define 	KS_b			  CHR(98)  + CHR(48)
#define 	KS_c			  CHR(99)  + CHR(46)
#define 	KS_d			  CHR(100) + CHR(32)
#define 	KS_e			  CHR(101) + CHR(18)
#define 	KS_f			  CHR(102) + CHR(33)
#define 	KS_g			  CHR(103) + CHR(34)
#define 	KS_h			  CHR(104) + CHR(35)
#define 	KS_i			  CHR(105) + CHR(23)
#define 	KS_j			  CHR(106) + CHR(36)
#define 	KS_k			  CHR(107) + CHR(37)
#define 	KS_l			  CHR(108) + CHR(38)
#define 	KS_m			  CHR(109) + CHR(50)
#define 	KS_n			  CHR(110) + CHR(49)
#define 	KS_o			  CHR(111) + CHR(24)
#define 	KS_p			  CHR(112) + CHR(25)
#define 	KS_q			  CHR(113) + CHR(16)
#define 	KS_r			  CHR(114) + CHR(19)
#define 	KS_s			  CHR(115) + CHR(31)
#define 	KS_t			  CHR(116) + CHR(20)
#define 	KS_u			  CHR(117) + CHR(22)
#define 	KS_v			  CHR(118) + CHR(47)
#define 	KS_w			  CHR(119) + CHR(17)
#define 	KS_x			  CHR(120) + CHR(45)
#define 	KS_y			  CHR(121) + CHR(21)
#define 	KS_z			  CHR(122) + CHR(44)

#define 	KS_1			  CHR(49)  + CHR(2)
#define 	KS_2			  CHR(50)  + CHR(3)
#define 	KS_3			  CHR(51)  + CHR(4)
#define 	KS_4			  CHR(52)  + CHR(5)
#define 	KS_5			  CHR(53)  + CHR(6)
#define 	KS_6			  CHR(54)  + CHR(7)
#define 	KS_7			  CHR(55)  + CHR(8)
#define 	KS_8			  CHR(56)  + CHR(9)
#define 	KS_9			  CHR(57)  + CHR(10)
#define 	KS_0			  CHR(48)  + CHR(11)


/* Letters and Numbers with Ctrl and Alt
*/
#define 	KS_CTRL_A		  CHR(1)   + CHR(30)
#define 	KS_CTRL_B		  CHR(2)   + CHR(48)
#define 	KS_CTRL_C		  CHR(3)   + CHR(46)
#define 	KS_CTRL_D		  CHR(4)   + CHR(32)
#define 	KS_CTRL_E		  CHR(5)   + CHR(18)
#define 	KS_CTRL_F		  CHR(6)   + CHR(33)
#define 	KS_CTRL_G		  CHR(7)   + CHR(34)
#define 	KS_CTRL_H		  CHR(8)   + CHR(35)
#define 	KS_CTRL_I		  CHR(9)   + CHR(23)
#define 	KS_CTRL_M		  CHR(13)  + CHR(50)
#define 	KS_CTRL_N		  CHR(14)  + CHR(49)
#define 	KS_CTRL_R		  CHR(18)  + CHR(19)
#define 	KS_CTRL_S		  CHR(19)  + CHR(31)
#define 	KS_CTRL_T		  CHR(20)  + CHR(20)
#define 	KS_CTRL_U		  CHR(21)  + CHR(22)
#define 	KS_CTRL_V		  CHR(22)  + CHR(47)
#define 	KS_CTRL_W		  CHR(23)  + CHR(17)
#define 	KS_CTRL_X		  CHR(24)  + CHR(45)
#define 	KS_CTRL_Y		  CHR(25)  + CHR(21)
#define 	KS_CTRL_Z		  CHR(26)  + CHR(44)

#define 	KS_ALT_A		  CHR(0)   + CHR(30)
#define 	KS_ALT_B		  CHR(0)   + CHR(48)
#define 	KS_ALT_C		  CHR(0)   + CHR(46)
#define 	KS_ALT_D		  CHR(0)   + CHR(32)
#define 	KS_ALT_E		  CHR(0)   + CHR(18)
#define 	KS_ALT_F		  CHR(0)   + CHR(33)
#define 	KS_ALT_G		  CHR(0)   + CHR(34)
#define 	KS_ALT_H		  CHR(0)   + CHR(35)
#define 	KS_ALT_I		  CHR(0)   + CHR(23)
#define 	KS_ALT_J		  CHR(0)   + CHR(36)
#define 	KS_ALT_K		  CHR(0)   + CHR(37)
#define 	KS_ALT_L		  CHR(0)   + CHR(38)
#define 	KS_ALT_M		  CHR(0)   + CHR(50)
#define 	KS_ALT_N		  CHR(0)   + CHR(49)
#define 	KS_ALT_O		  CHR(0)   + CHR(24)
#define 	KS_ALT_P		  CHR(0)   + CHR(25)
#define 	KS_ALT_Q		  CHR(0)   + CHR(16)
#define 	KS_ALT_R		  CHR(0)   + CHR(19)
#define 	KS_ALT_S		  CHR(0)   + CHR(31)
#define 	KS_ALT_T		  CHR(0)   + CHR(20)
#define 	KS_ALT_U		  CHR(0)   + CHR(22)
#define 	KS_ALT_V		  CHR(0)   + CHR(47)
#define 	KS_ALT_W		  CHR(0)   + CHR(17)
#define 	KS_ALT_X		  CHR(0)   + CHR(45)
#define 	KS_ALT_Y		  CHR(0)   + CHR(21)
#define 	KS_ALT_Z		  CHR(0)   + CHR(44)

#define 	KS_ALT_1		  CHR(0)   + CHR(120)
#define 	KS_ALT_2		  CHR(0)   + CHR(121)
#define 	KS_ALT_3		  CHR(0)   + CHR(122)
#define 	KS_ALT_4		  CHR(0)   + CHR(123)
#define 	KS_ALT_5		  CHR(0)   + CHR(124)
#define 	KS_ALT_6		  CHR(0)   + CHR(125)
#define 	KS_ALT_7		  CHR(0)   + CHR(126)
#define 	KS_ALT_8		  CHR(0)   + CHR(127)
#define 	KS_ALT_9		  CHR(0)   + CHR(128)
#define 	KS_ALT_0		  CHR(0)   + CHR(129)


/* Twelve function keys in all combinations
*/
#define 	KS_F1			  CHR(0)   + CHR(59)
#define 	KS_F2			  CHR(0)   + CHR(60)
#define 	KS_F3			  CHR(0)   + CHR(61)
#define 	KS_F4			  CHR(0)   + CHR(62)
#define 	KS_F5			  CHR(0)   + CHR(63)
#define 	KS_F6			  CHR(0)   + CHR(64)
#define 	KS_F7			  CHR(0)   + CHR(65)
#define 	KS_F8			  CHR(0)   + CHR(66)
#define 	KS_F9			  CHR(0)   + CHR(67)
#define 	KS_F10			  CHR(0)   + CHR(68)
#define 	KS_F11			  CHR(0)   + CHR(133)
#define 	KS_F12			  CHR(0)   + CHR(134)

#define 	KS_SH_F1		  CHR(0)   + CHR(84)
#define 	KS_SH_F2		  CHR(0)   + CHR(85)
#define 	KS_SH_F3		  CHR(0)   + CHR(86)
#define 	KS_SH_F4		  CHR(0)   + CHR(87)
#define 	KS_SH_F5		  CHR(0)   + CHR(88)
#define 	KS_SH_F6		  CHR(0)   + CHR(89)
#define 	KS_SH_F7		  CHR(0)   + CHR(90)
#define 	KS_SH_F8		  CHR(0)   + CHR(91)
#define 	KS_SH_F9		  CHR(0)   + CHR(92)
#define 	KS_SH_F10		  CHR(0)   + CHR(93)
#define 	KS_SH_F11		  CHR(0)   + CHR(135)
#define 	KS_SH_F12		  CHR(0)   + CHR(136)

#define 	KS_CTRL_F1		  CHR(0)   + CHR(94)
#define 	KS_CTRL_F2		  CHR(0)   + CHR(95)
#define 	KS_CTRL_F3		  CHR(0)   + CHR(96)
#define 	KS_CTRL_F4		  CHR(0)   + CHR(97)
#define 	KS_CTRL_F5		  CHR(0)   + CHR(98)
#define 	KS_CTRL_F6		  CHR(0)   + CHR(99)
#define 	KS_CTRL_F7		  CHR(0)   + CHR(100)
#define 	KS_CTRL_F8		  CHR(0)   + CHR(101)
#define 	KS_CTRL_F9		  CHR(0)   + CHR(102)
#define 	KS_CTRL_F10		  CHR(0)   + CHR(103)
#define 	KS_CTRL_F11		  CHR(0)   + CHR(137)
#define 	KS_CTRL_F12		  CHR(0)   + CHR(138)

#define 	KS_ALT_F1		  CHR(0)   + CHR(104)
#define 	KS_ALT_F2		  CHR(0)   + CHR(105)
#define 	KS_ALT_F3		  CHR(0)   + CHR(106)
#define 	KS_ALT_F4		  CHR(0)   + CHR(107)
#define 	KS_ALT_F5		  CHR(0)   + CHR(108)
#define 	KS_ALT_F6		  CHR(0)   + CHR(109)
#define 	KS_ALT_F7		  CHR(0)   + CHR(110)
#define 	KS_ALT_F8		  CHR(0)   + CHR(111)
#define 	KS_ALT_F9		  CHR(0)   + CHR(112)
#define 	KS_ALT_F10		  CHR(0)   + CHR(113)
#define 	KS_ALT_F11		  CHR(0)   + CHR(139)
#define 	KS_ALT_F12		  CHR(0)   + CHR(140)


/* Backspace, ESC, and TAB
*/
#define 	KS_BS			  CHR(8)   + CHR(14)
#define 	KS_ESC			  CHR(27)  + CHR(1)
#define 	KS_TAB			  CHR(9)   + CHR(15)
#define 	KS_SH_TAB		  CHR(0)   + CHR(15)

#define 	KS_ALT_BS		  CHR(0)   + CHR(14)
#define 	KS_ALT_ESC		  CHR(0)   + CHR(1)
#define 	KS_ALT_TAB		  CHR(0)   + CHR(165)


/* The various combinations for ENTER
*/
#define 	KS_ENTER		  CHR(13)  + CHR(28)
#define 	KS_CTRL_ENTER		  CHR(10)  + CHR(28)
#define 	KS_ALT_ENTER		  CHR(0)   + CHR(28)
#define 	KS_PAD_ENTER		  CHR(13)  + CHR(224)
#define 	KS_PAD_CTRL_ENTER	  CHR(10)  + CHR(224)
#define 	KS_PAD_ALT_ENTER	  CHR(0)   + CHR(166)


/* Separate cursor block (gray cursor keys)
*/
#define 	KS_INS			  CHR(224) + CHR(82)
#define 	KS_DEL			  CHR(224) + CHR(83)
#define 	KS_HOME 		  CHR(224) + CHR(71)
#define 	KS_END			  CHR(224) + CHR(79)
#define 	KS_PGUP 		  CHR(224) + CHR(73)
#define 	KS_PGDN 		  CHR(224) + CHR(81)
#define 	KS_UP			  CHR(224) + CHR(72)
#define 	KS_LEFT 		  CHR(224) + CHR(75)
#define 	KS_DOWN 		  CHR(224) + CHR(80)
#define 	KS_RIGHT		  CHR(224) + CHR(77)

#define 	KS_CTRL_INS		  CHR(224) + CHR(146)
#define 	KS_CTRL_DEL		  CHR(224) + CHR(147)
#define 	KS_CTRL_HOME		  CHR(224) + CHR(119)
#define 	KS_CTRL_END		  CHR(224) + CHR(117)
#define 	KS_CTRL_PGUP		  CHR(224) + CHR(132)
#define 	KS_CTRL_PGDN		  CHR(224) + CHR(118)
#define 	KS_CTRL_UP		  CHR(224) + CHR(141)
#define 	KS_CTRL_LEFT		  CHR(224) + CHR(115)
#define 	KS_CTRL_DOWN		  CHR(224) + CHR(145)
#define 	KS_CTRL_RIGHT		  CHR(224) + CHR(116)

#define 	KS_ALT_INS		  CHR(0)   + CHR(162)
#define 	KS_ALT_DEL		  CHR(0)   + CHR(163)
#define 	KS_ALT_HOME		  CHR(0)   + CHR(151)
#define 	KS_ALT_END		  CHR(0)   + CHR(159)
#define 	KS_ALT_PGUP		  CHR(0)   + CHR(153)
#define 	KS_ALT_PGDN		  CHR(0)   + CHR(161)
#define 	KS_ALT_UP		  CHR(0)   + CHR(152)
#define 	KS_ALT_LEFT		  CHR(0)   + CHR(155)
#define 	KS_ALT_DOWN		  CHR(0)   + CHR(160)
#define 	KS_ALT_RIGHT		  CHR(0)   + CHR(157)


/* Cursor-Block / NumPad
*/
#define 	KS_PAD_INS		  CHR(0)   + CHR(82)
#define 	KS_PAD_DEL		  CHR(0)   + CHR(83)
#define 	KS_PAD_HOME		  CHR(0)   + CHR(71)
#define 	KS_PAD_END		  CHR(0)   + CHR(79)
#define 	KS_PAD_PGUP		  CHR(0)   + CHR(73)
#define 	KS_PAD_PGDN		  CHR(0)   + CHR(81)
#define 	KS_PAD_UP		  CHR(0)   + CHR(72)
#define 	KS_PAD_LEFT		  CHR(0)   + CHR(75)
#define 	KS_PAD_DOWN		  CHR(0)   + CHR(80)
#define 	KS_PAD_RIGHT		  CHR(0)   + CHR(77)

#define 	KS_CTRL_PAD_INS 	  CHR(0)   + CHR(146)
#define 	KS_CTRL_PAD_DEL 	  CHR(0)   + CHR(147)
#define 	KS_CTRL_PAD_HOME	  CHR(0)   + CHR(119)
#define 	KS_CTRL_PAD_END 	  CHR(0)   + CHR(117)
#define 	KS_CTRL_PAD_PGUP	  CHR(0)   + CHR(132)
#define 	KS_CTRL_PAD_PGDN	  CHR(0)   + CHR(118)
#define 	KS_CTRL_PAD_UP		  CHR(0)   + CHR(141)
#define 	KS_CTRL_PAD_LEFT	  CHR(0)   + CHR(115)
#define 	KS_CTRL_PAD_DOWN	  CHR(0)   + CHR(145)
#define 	KS_CTRL_PAD_RIGHT	  CHR(0)   + CHR(116)
/*
* There are no separate KS_ALT_PAD_<cursor key> codes! */


/* The gray keys in the numeric key pad.
*/
#define 	KS_PAD_DIV		  CHR(47)  + CHR(224)
#define 	KS_PAD_MUL		  CHR(42)  + CHR(55)
#define 	KS_PAD_MINUS		  CHR(45)  + CHR(74)
#define 	KS_PAD_PLUS		  CHR(43)  + CHR(78)

#define 	KS_CTRL_PAD_DIV 	  CHR(0)   + CHR(149)
#define 	KS_CTRL_PAD_MUL 	  CHR(0)   + CHR(150)
#define 	KS_CTRL_PAD_MINUS	  CHR(0)   + CHR(142)
#define 	KS_CTRL_PAD_PLUS	  CHR(0)   + CHR(144)

#define 	KS_ALT_PAD_DIV		  CHR(0)   + CHR(164)
#define 	KS_ALT_PAD_MUL		  CHR(0)   + CHR(55)
#define 	KS_ALT_PAD_MINUS	  CHR(0)   + CHR(74)
#define 	KS_ALT_PAD_PLUS 	  CHR(0)   + CHR(78)


/* Numeric block keys, like period and comma
*/
#define 	KS_PAD_1		  CHR(49)  + CHR(79)
#define 	KS_PAD_2		  CHR(50)  + CHR(80)
#define 	KS_PAD_3		  CHR(51)  + CHR(81)
#define 	KS_PAD_4		  CHR(52)  + CHR(75)
#define 	KS_PAD_5		  CHR(53)  + CHR(76)
#define 	KS_PAD_6		  CHR(54)  + CHR(77)
#define 	KS_PAD_7		  CHR(55)  + CHR(71)
#define 	KS_PAD_8		  CHR(56)  + CHR(72)
#define 	KS_PAD_9		  CHR(57)  + CHR(73)
#define 	KS_PAD_0		  CHR(48)  + CHR(82)

#define 	KS_PAD_DECIMAL		  CHR(46)  + CHR(83)

#define 	KS_DOT			  CHR(46)  + CHR(52)
#define 	KS_COMMA		  CHR(44)  + CHR(51)
/*
*** EOF ***/

