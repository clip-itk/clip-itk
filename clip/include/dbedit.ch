#ifndef _DBEDIT_DEFINED
#define _DBEDIT_DEFINED

#define DE_HEADSEP      translate_charset(__CHARSET__,host_charset(),"═╤═")
#define DE_COLSEP       translate_charset(__CHARSET__,host_charset()," │ ")
#define DE_FOOTSEP      translate_charset(__CHARSET__,host_charset(),"═╧═")

#define DE_COLOR        "N/W, N/BG, B/W, B/BG, B/W, B/BG, R/W, B/R"

#define DE_IDLE             0          // Ожидание нажатия клавиши
#define DE_HITTOP           1          // Попытка выйти за границу вверх
#define DE_HITBOTTOM        2          // Попытка выйти за границу вниз
#define DE_EMPTY            3          // Нет записей в рабочей области
#define DE_EXCEPT           4          // Клавиша не обрабатывается DBEDIT()

#define DE_ABORT            0           // Завершить DBEDIT()
#define DE_CONT             1           // Продолжить DBEDIT()
#define DE_REFRESH          2           // Прочитать/вывести все записи на экране
#define DE_APPEND           3           // undocumented return value,
					// EOF as new record

#endif

