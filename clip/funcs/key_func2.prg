#include "inkey.ch"
function keycodeByName(sKey)
local hKey
do switch (sKey)
	case "K_HOME", "K_CTRL_A"
		hKey := K_HOME
	case "K_CTRL_RIGHT", "K_CTRL_B"
		hKey := K_CTRL_RIGHT
	case "K_PGDN", "K_CTRL_C"
		hKey := K_PGDN
	case "K_RIGHT", "K_CTRL_D"
		hKey := K_RIGHT
	case "K_UP", "K_CTRL_E"
		hKey := K_UP
	case "K_END", "K_CTRL_F"
		hKey := K_END
	case "K_PGUP", "K_CTRL_R"
		hKey := K_PGUP
	case "K_LEFT", "K_CTRL_S"
		hKey := K_LEFT
	case "K_CTRL_END", "K_CTRL_W"
		hKey := K_CTRL_END
	case "K_DOWN", "K_CTRL_X"
		hKey := K_DOWN
	case "K_CTRL_LEFT", "K_CTRL_Z"
		hKey := K_CTRL_LEFT
	case "K_CTRL_HOME"// Ctrl-]
		hKey := K_CTRL_HOME
	case "K_CTRL_PGDN"// Ctrl-^
		hKey := K_CTRL_PGDN
	case "K_CTRL_PGUP"        // Ctrl-Hyphen
		hKey := K_CTRL_PGUP
	case "K_CTRL_UP"
		hKey := K_CTRL_UP
	case "K_CTRL_DOWN"
		hKey := K_CTRL_DOWN
	case "K_ALT_HOME"
		hKey := K_ALT_HOME
	case "K_ALT_UP"
		hKey :=  K_ALT_UP
	case "K_ALT_PGUP"
		hKey :=  K_ALT_PGUP
	case "K_ALT_LEFT"
		hKey :=  K_ALT_LEFT
	case "K_ALT_RIGHT"
		hKey :=  K_ALT_RIGHT
	case "K_ALT_END"
		hKey :=  K_ALT_END
	case "K_ALT_DOWN"
		hKey :=  K_ALT_DOWN
	case "K_ALT_PGDN"
		hKey :=  K_ALT_PGDN
	case "K_CTRL_ENTER", "K_CTRL_RETURN", "K_CTRL_RET", "K_CTRL_J"
		hKey :=  K_CTRL_ENTER
	case "K_ENTER", "K_RETURN", "K_CTRL_M"
		hKey :=  K_ENTER
	case "K_ESC"              // Ctrl-[
		hKey :=  K_ESC
	case "K_SPACE"
		hKey :=  K_SPACE
	case "K_ALT_ESC"
		hKey :=  K_ALT_ESC
	case "K_ALT_ENTER", "K_ALT_RETURN"
		hKey :=  K_ALT_ENTER
	case "K_ALT_QUESTION", "K_CTRL_QUESTION"
		hKey :=  K_ALT_QUESTION
	case "K_ALT_EQUALS"
		hKey :=  K_ALT_EQUALS
	case "K_CTRL_PRTSCR", "K_ALT_4"
		hKey :=  K_CTRL_PRTSCR
	case "KP_ALT_5"
		hKey :=  KP_ALT_5
	case "KP_ALT_ASTERISK"
		hKey :=  KP_ALT_ASTERISK
	case "KP_ALT_MINUS"
		hKey :=  KP_ALT_MINUS
	case "KP_ALT_PLUS"
		hKey :=  KP_ALT_PLUS
	case "KP_CTRL_MINUS"
		hKey :=  KP_CTRL_MINUS
	case "KP_CTRL_5"
		hKey :=  KP_CTRL_5
	case "KP_CTRL_PLUS"
		hKey :=  KP_CTRL_PLUS
	case "KP_CTRL_SLASH"
		hKey :=  KP_CTRL_SLASH
	case "KP_CTRL_ASTERISK"
		hKey :=  KP_CTRL_ASTERISK
	case "KP_ALT_SLASH"
		hKey :=  KP_ALT_SLASH
	case "KP_ALT_ENTER"
		hKey :=  KP_ALT_ENTER
	case "K_DEL", "K CTRL_G"
		hKey :=  K_DEL
	case "K_BS", "K_CTRL_H"
		hKey :=  K_BS
	case "K_TAB", "K_CTRL_I"
		hKey :=  K_TAB
	case "K_INS", "K_CTRL_V"
		hKey :=  K_INS
	case "K_CTRL_BS"
		hKey :=  K_CTRL_BS
	case "K_ALT_BS"
		hKey :=  K_ALT_BS
	case "K_SH_TAB"
		hKey :=  K_SH_TAB
	case "K_CTRL_INS"
		hKey :=  K_CTRL_INS
	case "K_CTRL_DEL"
		hKey :=  K_CTRL_DEL
	case "K_CTRL_TAB"
		hKey :=  K_CTRL_TAB
	case "K_ALT_INS"
		hKey :=  K_ALT_INS
	case "K_ALT_DEL"
		hKey :=  K_ALT_DEL
	case "K_ALT_TAB"
		hKey :=  K_ALT_TAB
	case "K_CTRL_K"
		hKey :=  K_CTRL_K
	case "K_CTRL_L"
		hKey :=  K_CTRL_L
	case "K_CTRL_N"
		hKey :=  K_CTRL_N
	case "K_CTRL_O"
		hKey :=  K_CTRL_O
	case "K_CTRL_P"
		hKey :=  K_CTRL_P
	case "K_CTRL_Q"
		hKey :=  K_CTRL_Q
	case "K_CTRL_T"
		hKey :=  K_CTRL_T
	case "K_CTRL_U"
		hKey :=  K_CTRL_U
	case "K_CTRL_Y"
		hKey :=  K_CTRL_Y
	case "KP_ASTERICK"
		hKey :=  KP_ASTERICK
	case "KP_PLUS"
		hKey :=  KP_PLUS
	case "KP_MINUS"
		hKey :=  KP_MINUS
	case "KP_SLASH"
		hKey :=  KP_SLASH
	case "K_ALT_A"
		hKey :=  K_ALT_A
	case "K_ALT_B"
		hKey :=  K_ALT_B
	case "K_ALT_C"
		hKey :=  K_ALT_C
	case "K_ALT_D"
		hKey :=  K_ALT_D
	case "K_ALT_E"
		hKey :=  K_ALT_E
	case "K_ALT_F"
		hKey :=  K_ALT_F
	case "K_ALT_G"
		hKey :=  K_ALT_G
	case "K_ALT_H"
		hKey :=  K_ALT_H
	case "K_ALT_I"
		hKey :=  K_ALT_I
	case "K_ALT_J"
		hKey :=  K_ALT_J
	case "K_ALT_K"
		hKey :=  K_ALT_K
	case "K_ALT_L"
		hKey :=  K_ALT_L
	case "K_ALT_M"
		hKey :=  K_ALT_M
	case "K_ALT_N"
		hKey :=  K_ALT_N
	case "K_ALT_O"
		hKey :=  K_ALT_O
	case "K_ALT_P"
		hKey :=  K_ALT_P
	case "K_ALT_Q"
		hKey :=  K_ALT_Q
	case "K_ALT_R"
		hKey :=  K_ALT_R
	case "K_ALT_S"
		hKey :=  K_ALT_S
	case "K_ALT_T"
		hKey :=  K_ALT_T
	case "K_ALT_U"
		hKey :=  K_ALT_U
	case "K_ALT_V"
		hKey :=  K_ALT_V
	case "K_ALT_W"
		hKey :=  K_ALT_W
	case "K_ALT_X"
		hKey :=  K_ALT_X
	case "K_ALT_Y"
		hKey :=  K_ALT_Y
	case "K_ALT_Z"
		hKey :=  K_ALT_Z
	case "K_ALT_1"
		hKey :=  K_ALT_1
	case "K_ALT_2"
		hKey :=  K_ALT_2
	case "K_ALT_3"
		hKey :=  K_ALT_3
	case "K_ALT_5"
		hKey :=  K_ALT_5
	case "K_ALT_6"
		hKey :=  K_ALT_6
	case "K_ALT_7"
		hKey :=  K_ALT_7
	case "K_ALT_8"
		hKey :=  K_ALT_8
	case "K_ALT_9"
		hKey :=  K_ALT_9
	case "K_ALT_0"
		hKey :=  K_ALT_0
	case "K_ALT_TILDA"
		hKey :=  K_ALT_TILDA
	case "K_A"
		hKey := K_A
	case "K_B"
		hKey := K_B
	case "K_C"
		hKey := K_C
	case "K_D"
		hKey := K_D
	case "K_E"
		hKey := K_E
	case "K_F"
		hKey := K_F
	case "K_G"
		hKey := K_G
	case "K_H"
		hKey := K_H
	case "K_I"
		hKey := K_I
	case "K_J"
		hKey := K_J
	case "K_K"
		hKey := K_K
	case "K_L"
		hKey := K_L
	case "K_M"
		hKey := K_M
	case "K_N"
		hKey := K_N
	case "K_O"
		hKey := K_O
	case "K_P"
		hKey := K_P
	case "K_Q"
		hKey := K_Q
	case "K_R"
		hKey := K_R
	case "K_S"
		hKey := K_S
	case "K_T"
		hKey := K_T
	case "K_U"
		hKey := K_U
	case "K_V"
		hKey := K_V
	case "K_W"
		hKey := K_W
	case "K_X"
		hKey := K_X
	case "K_Y"
		hKey := K_Y
	case "K_Z"
		hKey := K_Z
	case "K_F1"
		hKey :=  K_F1
	case "K_F2"
		hKey :=  K_F2
	case "K_F3"
		hKey :=  K_F3
	case "K_F4"
		hKey :=  K_F4
	case "K_F5"
		hKey :=  K_F5
	case "K_F6"
		hKey :=  K_F6
	case "K_F7"
		hKey :=  K_F7
	case "K_F8"
		hKey :=  K_F8
	case "K_F9"
		hKey :=  K_F9
	case "K_F10"
		hKey :=  K_F10
	case "K_F11"
		hKey :=  K_F11
	case "K_F12"
		hKey :=  K_F12
	case "K_SH_F1"
		hKey :=  K_SH_F1
	case "K_SH_F2"
		hKey :=  K_SH_F2
	case "K_SH_F3"
		hKey :=  K_SH_F3
	case "K_SH_F4"
		hKey :=  K_SH_F4
	case "K_SH_F5"
		hKey :=  K_SH_F5
	case "K_SH_F6"
		hKey :=  K_SH_F6
	case "K_SH_F7"
		hKey :=  K_SH_F7
	case "K_SH_F8"
		hKey :=  K_SH_F8
	case "K_SH_F9"
		hKey :=  K_SH_F9
	case "K_SH_F10"
		hKey :=  K_SH_F10
	case "K_SH_F11"
		hKey :=  K_SH_F11
	case "K_SH_F12"
		hKey :=  K_SH_F12
	case "K_CTRL_F1"
		hKey :=  K_CTRL_F1
	case "K_CTRL_F2"
		hKey :=  K_CTRL_F2
	case "K_CTRL_F3"
		hKey :=  K_CTRL_F3
	case "K_CTRL_F4"
		hKey :=  K_CTRL_F4
	case "K_CTRL_F5"
		hKey :=  K_CTRL_F5
	case "K_CTRL_F6"
		hKey :=  K_CTRL_F6
	case "K_CTRL_F7"
		hKey :=  K_CTRL_F7
	case "K_CTRL_F8"
		hKey :=  K_CTRL_F8
	case "K_CTRL_F9"
		hKey :=  K_CTRL_F9
	case "K_CTRL_F10"
		hKey :=  K_CTRL_F10
	case "K_CTRL_F11"
		hKey :=  K_CTRL_F11
	case "K_CTRL_F12"
		hKey :=  K_CTRL_F12
	case "K_ALT_F1"
		hKey :=  K_ALT_F1
	case "K_ALT_F2"
		hKey :=  K_ALT_F2
	case "K_ALT_F3"
		hKey :=  K_ALT_F3
	case "K_ALT_F4"
		hKey :=  K_ALT_F4
	case "K_ALT_F5"
		hKey :=  K_ALT_F5
	case "K_ALT_F6"
		hKey :=  K_ALT_F6
	case "K_ALT_F7"
		hKey :=  K_ALT_F7
	case "K_ALT_F8"
		hKey :=  K_ALT_F8
	case "K_ALT_F9"
		hKey :=  K_ALT_F9
	case "K_ALT_F10"
		hKey :=  K_ALT_F10
	case "K_ALT_F11"
		hKey :=  K_ALT_F11
	case "K_ALT_F12"
		hKey :=  K_ALT_F12
	case "K_MOUSEMOVE"
		hKey :=  K_MOUSEMOVE
	case "K_LBUTTONDOWN"
		hKey :=  K_LBUTTONDOWN
	case "K_LBUTTONUP"
		hKey :=  K_LBUTTONUP
	case "K_RBUTTONDOWN"
		hKey :=  K_RBUTTONDOWN
	case "K_RBUTTONUP"
		hKey :=  K_RBUTTONUP
	case "K_LDBLCLK"
		hKey :=  K_LDBLCLK
	case "K_RDBLCLK"
		hKey :=  K_RDBLCLK
	case "K_MBUTTONDOWN"
		hKey :=  K_MBUTTONDOWN
	case "K_MBUTTONUP"
		hKey :=  K_MBUTTONUP
	case "K_MDBLCLK"
		hKey :=  K_MDBLCLK
	case "INKEY_MOVE"
		hKey :=  INKEY_MOVE
	case "INKEY_LDOWN"
		hKey :=  INKEY_LDOWN
	case "INKEY_LUP"
		hKey :=  INKEY_LUP
	case "INKEY_RDOWN"
		hKey :=  INKEY_RDOWN
	case "INKEY_RUP"
		hKey :=  INKEY_RUP
	case "INKEY_MDOWN"
		hKey :=  INKEY_MDOWN
	case "INKEY_MUP"
		hKey :=  INKEY_MUP
	case "INKEY_KEYBOARD"
		hKey :=  INKEY_KEYBOARD
	case "INKEY_ALL"
		hKey :=  INKEY_ALL

endswitch
return hKey
