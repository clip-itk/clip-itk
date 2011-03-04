#ifndef _DBEDIT_DEFINED
#define _DBEDIT_DEFINED

#define DE_HEADSEP      translate_charset(__CHARSET__,host_charset(),"†∂†") // utf-8: "‚ïê‚ï§‚ïê"
#define DE_COLSEP       translate_charset(__CHARSET__,host_charset()," Å ") // utf-8: " ‚îÇ "
#define DE_FOOTSEP      translate_charset(__CHARSET__,host_charset(),"†π†") // utf-8: "‚ïê‚ïß‚ïê"

#define DE_COLOR        "N/W, N/BG, B/W, B/BG, B/W, B/BG, R/W, B/R"

#define DE_IDLE             0          // Waiting for keystroke
#define DE_HITTOP           1          // attempt to move up beyond the list
#define DE_HITBOTTOM        2          // attempt to move down beyond the list
#define DE_EMPTY            3          // No records in the workspace
#define DE_EXCEPT           4          // Key don't handled in DBEDIT()

#define DE_ABORT            0           // Abort DBEDIT()
#define DE_CONT             1           // Continue DBEDIT()
#define DE_REFRESH          2           // Read/output all records in screen
#define DE_APPEND           3           // undocumented return value,
					// EOF as new record

#endif

