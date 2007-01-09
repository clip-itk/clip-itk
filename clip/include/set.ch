#ifndef _SET_DEFINED
#define _SET_DEFINED

#define _SET_EXACT                  1
#define _SET_FIXED                  2
#define _SET_DECIMALS               3
#define _SET_DATEFORMAT             4
#define _SET_EPOCH                  5
#define _SET_PATH                   6
#define _SET_DEFAULT                7
#define _SET_EXCLUSIVE              8
#define _SET_SOFTSEEK               9
#define _SET_UNIQUE                10
#define _SET_DELETED               11
#define _SET_CANCEL                12
#define _SET_DEBUG                 13
#define _SET_TYPEAHEAD             14
#define _SET_COLOR                 15
#define _SET_CURSOR                16
#define _SET_CONSOLE               17
#define _SET_ALTERNATE             18
#define _SET_ALTFILE               19
#define _SET_DEVICE                20
#define _SET_EXTRA                 21
#define _SET_EXTRAFILE             22
#define _SET_PRINTER               23
#define _SET_PRINTFILE             24
#define _SET_MARGIN                25
#define _SET_BELL                  26
#define _SET_CONFIRM               27
#define _SET_ESCAPE                28
#define _SET_INSERT                29
#define _SET_EXIT                  30
#define _SET_INTENSITY             31
#define _SET_SCOREBOARD            32
#define _SET_DELIMITERS            33
#define _SET_DELIMCHARS            34
#define _SET_WRAP                  35
#define _SET_MESSAGE               36
#define _SET_MCENTER               37
#define _SET_SCROLLBREAK           38
#define _SET_EVENTMASK             39
#define _SET_VIDEOMODE             40
#define _SET_MBLOCKSIZE            41
#define _SET_MFILEEXT              42

/* SIX extensions */
#define _SET_STRICTREAD            43
#define _SET_OPTIMIZE              44
#define _SET_AUTOPEN               45
#define _SET_AUTOOPEN              _SET_AUTOPEN
#define _SET_AUTORDER              46
#define _SET_AUTOORDER             _SET_AUTORDER
#define _SET_AUTOSHARE             47

#define _SET_COUNT                 48



/* CLIP extensions */
#define _SET_RATIONAL             100
#define _SET_TRANSLATE_PATH       101
#define _SET_TRANSLATE            _SET_TRANSLATE_PATH
#define _SET_FILECREATEMODE       102
#define _SET_DIRCREATEMODE        103
#define _SET_OPTIMIZELEVEL        104
#define _SET_LOCKSTYLE            105
#define _SET_MAPERR               106
#define _SET_DISPBOX              107 /* say box over terminfo or over dispout */

/* Visual FoxPro */
#define _SET_HOURS                108
#define _SET_SECONDS              109
/* FoxPro compatibility */
#define _SET_NEAR                _SET_SOFTSEEK

#define _SET_MACRO_IN_STRING      110
#define _SET_FOPENMODE            111
#define _SET_BUFFERING            112

#define _SET_INDEX_BUFFER_LIMIT   113
#define _SET_MAP_FILE             114

#define _SET_ESC_DELAY            115

#define _SET_MULTILOCKS           116
#define _SET_FLUSHOUT             117
#define _SET_ROOTPATH             118
#define _SET_UTF8TERM             119 /* terminal support UTF-8 */

#define _SET_IDLE_INKEY           120 /* use _inkey() without call terminal*/

#define _SET_LOGLEVEL            1000
#define _SET_LOGFILE             1001



#endif
