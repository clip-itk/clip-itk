/*
    Copyright (C) 1998-2004 Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#define _MSG_F1 [Help]
#define _MSG_AF10 [Os Exit]
#define Brow_M_Keys {[],[Print],[Append],[Set Dbf],[Set IDX],[Go To],[Locate],;
		     [Pack],[Seek],[Menu],[S/Locat],[UsrMenu]}
#define Brow_A_Keys {[Info],[Struct.],[Copy],[Repl /C],[Reindex],;
		{||IF(IsShift(),[Total],[Sum])},;
		[Contin.],[Zap],[MakeInd],[],[Filter],[Filer]}
#define Brow_C_Keys {{||IF(IsShift(),[SaveAop],[Macro])},;
		{||IF(m->_replay,[RstFlds],[SetFlds])},;
		[Copy To],[Repl /V],[Set var],[Count],;
		{||IF(IsShift(),[LocBack],[Recall])},;
		{||IF(IsShift(),[Invert],[Delete])},;
		[Ap/from],[Ch.Dir],;
		{||IF(IsShift(),[Cur.Loc],[Sort])},[ReadIni]}
#define Brow_S_Keys  {[SaveVue],[Modify],[Insert],[MakeEmp],[RestVue],;
		[Compute],[TagNumb],[TagName],[MakeTag],[DelTag],[Set CDX],[Set Tag]}

#define Modi_M_Keys  {[],[],[Append],[],[Insert],;
		[],[],[Delete],[MakeOpt],[Q/Save],[],[]}

#define Setf_M_Keys {[],[],[New],[],[Restore],;
		[],[Rec.Rst],[Del.Rst],[],[Set],[],[]}
#define Get_M_Keys {[],[],{||IF(Select()=1,[Append],[])},[EntMode],[],;
		[],[],[],[],[],[],[]}

#define _MSG_GET_CF10 [ASCII]

#define _MSG_GN_F4 [History]
#define _MSG_GN_AF4 [Glb.Hst]
#define _MSG_GN_F7 [InsFunc]
#define _MSG_GN_F9 [Select]
#define _MSG_GN_AF2 [Fields]
#define Val_M_Keys {[],[FdName],[Head],[History],[FdValue],;
		    [DbfName],[],[],[],[InsMenu],[],[]}
#define Val_C_Keys {[],[FdsName],[FdsHead],[Res.Hst],[Quoted],[],[],[],[],[],[],[]}

#define Print_M_Keys {[],[],[],[],[],[],[],[],[Config],[],[],[]}

#define _MSG_DEL_F8 [Delete]

#define Str_M_Keys {[],[Print],[],[File],[Ext.Str],[Struct],[],[],[Config],[],[],[]}

#define Reslt_M_Keys {[],[To Calc],[],[],[ToField],[],[],[],[],[InsMenu],[],[]}

#define Base_M_Keys {[],[],[],[],[],[],[],[],[],[],[],[]}
#define SaveF10Key [Save]

#define Memo_M_Keys {[],[Print],[Write],[Load],{||IF(_lWrap,[UnWrap],[Wrap])},;
		     [SysClpb],[],[],[Config],[Save],[],[]}

#define FB_M_Keys {[],[Print],[],[],[],[],;
		  [Find],{||IF(lWasF8,[Win],[Dos])},[],[Exit],[],[]}
#define FB_A_Key [FindNxt]
#define FB_C_Key [Sel.CP]

#define EMAIL 'elb@lg.bank.gov.ua'
#define EMAIL2 'Bondar_Eugen@yahoo.com'
#define BDBF_VERSION [Bdbf-C,1.27a]

#define _MSG_A_DS_F2 [Print]
#define _MSG_A_DS_F3 [AddTag]
#define _MSG_A_DS_F4 [File]
#define _MSG_A_DS_F5 [Ext.Str]
#define _MSG_A_DS_F6 [Struct]
#define _MSG_A_DS_F8 [DelTag]
#define _MSG_A_DS_F9 [Config]
#define _MSG_A_DS_F10 [MakePrg]
	
#define _MSG_A_ST_F2 [Print]
#define _MSG_A_ST_F3 [AddTag]
#define _MSG_A_ST_F4 [MakePrg]
#define _MSG_A_ST_F5 [Reindex]
#define _MSG_A_ST_F6 [Rebuild]
#define _MSG_A_ST_F8 [DelTag]
#define _MSG_A_ST_F9 [Config]

#IFNDEF ENGLISH

#define ANY [Нажмите любую клавишу для пpодолжения]
#define ATTACHING [присоединения]
#define APPEND_SELF [Присоединяем из себя же?]
#define A_COPY {[Текущую],[Последнюю],[Отказ]}
#define A_SETF_BROW {Padc([Поле],nScroll),Padc([Название поля],nScroll),[Шаблон],[Ширина]}
#define BADNAME [Неверное имя или запрет записи]
#define BADWRITE [Запрет записи]
#define BAD_EXPR [Неверное выражение ]
#define BAD_EXT [Неверное расширение(BAK)]
#define BASE_STRUC [Структура базы ]
#define BYTE [ б]
#define CALC_EXPR [, которое надо вычислить]
#define CALC_FIELD [Это вычисляемое поле. Замена невозможна.]
#define CHECK_DBF_FORCED {[Модифицированный Visual FoxPro],;
			  [dBase IV  и выше],;
			  [FlagShip],;
			  [FlexMemo],;
			  [dBase II  или Foxbase 1.0],;
			  [Неизвестен]}
#define CHECK_DBF_TRY { [Открытие этой базы в стандартном режиме невозможно],;
			[Предположительный формат: ]+NeedForced,;
			[],;
			[Попытаться открыть в форсированном режиме?],;
			[(См. также объяснения в п.34 bdbfs.txt)]}
#define CLIPBOARD  [Буфер обмена]
#define COLOR_COND [Условие подсветки]
#define CONDITION [Условие:]
#define COPYING [копирования]
#define _CopyRight 'Запуск: Bdbfs <File>[.DBF|.MEM|.INI] [/bw] [/i=index] [Автодействия (см. п.33 bdbfs.txt)]'+;
		   _CRLF+'Поддержка: '+EMAIL
#define CORRUPT_OR_LOCKED _corrupted+[ или блокирован]
#define COUNTING [подсчета]
#define DATEFORMAT [dd/mm/yyyy]
#define DELETING [удаления]
#define DISK_KAT _give+[диск и каталог]
#define DOS_RET [Введите EXIT для возврата !]
#define DRV_DEFAULT [Задайте драйвер по умолчанию]
#define DRV_FOR_COPY [драйвер для новой базы]
#define DRV_NTX [Операция не поддерживается для драйвера NTX]
#define EMPTY_BASE [ База пуста  ]
#define EMPTY_IS_ALL [(Пусто - все записи)]
#define ENVIR_F [сохраненной среды]
#define EXPR_TOTAL [Выражение ключа]
#define FIELD_ED [Редакция поля ]
#define FIELD_ERR [Ошибочно задано: ]
#define FLDS_COPYING [Поля ( Пусто - все )]
#define FLDS_SELECT [Выбирайте поля]
#define FLDS_TOTAL [Поля, которые надо суммировать]
#define FORCE_PROHIBITED [Это запрещено в "форсированном" режиме]
#define FULL_ED [Up Down PgUp PgDn - для передвижения, Esc - для выхода в полный экран]
#define FUNC_FIND [поиска]
#define F_ATTACHING [для присоединения]
#define F_COPYING [для копирования]
#define F_CREATE [Создан файл ]
#define F_ENVIR [для сохранения среды]
#define F_FLTRING [отбора]
#define F_INDEXING [для индексирования]
#define F_SEARCH [для поиска:]
#define F_SHOW {[Посмотреть],[Отказ]}
#define F_SORTING [для сортировки]
#define GET_PSW [Пароль:]
#define GIVE_VAR _give+[переменную и выражение (xVar:=xVal)]
#define GLOB_FIND [контекстного поиска]
#define IND_FILE [Индексный файл ]
#define INDEXING [индексация]
#define INDEX_CHOICE [Выбирайте индекс]
#define INDEX_CORRUPT [Индекс]+_corrupted
#define INDEX_NO L_A_SIGN+[ Без индекса]
#define INDEX_NOT_MATCH [Индекс не соответствует базе. Реиндексировать?]
#define INI_F [инициализации]
#define INSERTING [вставка]
#define INVERTING [инвертирования]
#define IS_UNIQ [Уникальный индекс]
#define IT_RECS [Всего ]+SpaceString(m->__Count)+ [ записей]
#define I_SEARCH [Поиск по индексу.]
#define KBYTE [ Кб]
#define LONGEST [Максимальная длина: ]
#define L_YES_SET [YyTtДд1]
#define L_NO_SET [NnFfНн0]
#define MEMOFIELD [Просмотр мемо-поля ]
#define MEMO_NO_MATCH {[Есть поле типа MEMO, а заголовок-обычный.],;
		       [Исправить заголовок?]}
#define MENU_MAX() Menu2({[Максимум],[Минимум]},1,WHAT_FIND+_ABORT)
#translate MENU_RECS(<txt>) => Menu2({ALL_RECS,\[Оставшиеся]},;
			   _scope,\[Выбирайте область ]+<txt>)
#define MENU_SCOPE {[1-Да],[2-Все],[3-Пропустить],[4-Отказ]}
#define MSG_MNU_YESNO Menu2({[1-ДА],[0-НЕТ]},_choice,_mess,[Правильно?])
#define NEED_DEL_FILE [. Стереть его?]
#define NEED_FINISH [Заканчиваем работу]
#define NEED_OEM2ANSI [Преобразовывать текст в WIN-кодировку?]
#define NEED_PACK [Уничтожаем отмеченные записи]
#define NEED_REBUILD [Создадим все тэги заново]
#define NEED_REINDEX [Переиндексируем базу]
#define NEED_REPLACE [Заменить: ]
#define NEED_ZAP [Уничтожаем все записи]
#define NODIGITAL [Текущее поле не числовое]
#define NOCHARACTER [Текущее поле не символьное]
#define NOOP_IND [Операция запрещена при индексе]
#define NO_FIND_EXPR [Не задано условие поиска]
#define NO_FLTR [Запись вне фильтра]
#define NO_FLTRING [Не выполнено условие отбора]
#define NO_DPZ [Нет такой записи]
#define NO_KAT [ - Каталога нет или закрыт]
#define NO_ORDER [Нет открытых индексных файлов]
#define NO_SPACE [Нет места на диске]
#define N_RECORD [Запись]
#define N_RECORD_COL [Запись: ]
#define PACKING [упаковка]
#define PROCESSED [Обработано: ]
#define READY [ГОТОВО !]
#define RECALLING [восстановления]
#define REC_GO [Встанем на запись номер:]
#define REC_FIND [Найдем запись по:]
#define REC_FIND_C {[Номеру],[Смещению],[Номеру в индексе(тэге)]}
#define REC_SM [Смещение от текущей записи (+ -):]
#define REMOVING [удаление]
#define REMOVED [ Удалено ]+NTRIM(_tally)+ [ записей]
#define REPLACING [замещения]
#define REPL_EXPR [,которое будет помещено в поле ]
#define RESULT_IS [Результат выражения: ]
#define SEC_M [ с.]
#define SELECT_BASE [Выбирайте базу]
#define SELECT_CP [Выбирайте кодировку базы]
#define SET_FIELDS [Установка полей]
#define SET_OF_OEM  [АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюяЁёЄєЇїЎў°∙]
#define SET_OF_ANSI [└┴┬├─┼╞╟╚╔╩╦╠═╬╧╨╤╥╙╘╒╓╫╪┘┌█▄▌▐▀рстуфхцчшщъыьэюяЁёЄєЇїЎў°∙·√№¤* и╕е┤к║▓│п┐]
#define SET_OF_USA  [QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>qwertyuiop]+"[]"+[asdfghjkl;'zxcvbnm,.]
//#define SET_OF_USA  [QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>qwertyuiop]
//+"[]"+[asdfghjkl;'zxcvbnm,.]
#define SET_OF_MYKB [ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮйцукенгшщзхъфывапролджэячсмитьбю]
#define SET_OF_M_NO [123456789АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪ]
#define SORTING [сортировки]
#define SUMMING [суммирования]
#define SUM_IS [Сумма = ]
#define TAG_HEAD PAD([ НАЗВАНИЕ],14)+PAD([ВЫРАЖЕНИЕ],45)+PAD([УСЛОВИЕ],18)
#define TAG_NAME [имя тэга]
#define TAG_NAME_DEL [имя удаляемого тэга]
#define TAG_NO L_A_SIGN+[ Без тэга]
#define TAG_NUMBER [номер тэга]
#define TimerOff() [Затрачено времени:]+LTRIM(STR(Seconds()-m->_told,9,2))+ ;
		   [ с. Обработано: ]+NTRIM(m->_tally) + [ записей]
#define TOO_SHORT {[Исходная строка слишком коротка.],;
		   [Сжатие может не дать эффекта.],[Всё же сжимаем?]}
#define TXT_NAME _give+[имя текстового файла]
#define UNSUPPORT [ - неверный формат]
#define USE_HISTORY [Используем историю]
#define MSG_USERMENU_NO [Пользовательское меню не определено]
#define WAIT_WIND [Подождите,идет ]
#define WHAT_COPY [Копируем запись: ]
#define WHAT_FIND [Что ищем ?]
#define YESNO [Да ],[Нет]
#define _NEEDOVER [ уже существует.Переписать ?]

// Private
	#define PRV_ZU [Задайте условие ]
	#define PRV_ZIF [Введите имя файла ]
	#define PRV_ZIFN [Введите имя нового файла ]
	#define PRV_IV [Индексный ключ ]
	#define PRV_NOFILE [Файл не найден ]
	#define PRV_NOMEMO [Ошибка открытия ]
	#define PRV_ABORT [ (Esc - отказ)]

// Static
	#define _STAT_CORRUPTED [ поврежден]
	#define _STAT_ELSEUse [Кто-то еще открыл эту базу!]
	#define _STAT_END_EDIT [Выход с записью: F10, без записи: Esc]
	#define _STAT_ERTIP [Несоответствие типов ]
	#define _STAT_GIVE [Задайте ]
	#define _STAT_GIVE_NAME L_A_SIGN+[ Задать имя]
	#define _STAT_NFD [Выражение не найдено]
	#define _STAT_NOINDEX [Индекс не установлен]
	#define _STAT_ZE [Задайте выражение ]

// InsKeys
	#define MSG_ClpVal [Значение из буфера обмена]
	#define MSG_cTitleIns [Вставим в позицию курсора: ]
	#define MSG_aIns {[Название базы],[Значение из поля],[Имя поля],;
		[Заголовок поля],MSG_ClpVal,;
		'Имя любого поля','Заголовок любого поля',;
		'Значение из поля в кавычках','Символ'}
	#define MSG_PUTTITLE [Полученный результат: ]
	#define MSG_PUTWHERE {[Запишем в текущее поле],;
			      [Запишем в буфер обмена],;
			      [Запишем в системный буфер обмена],;
			      [Преобразуем в "денежный" формат]}
	#define MSG_FLDHEAD_INS [Заголовок поля]
	#define MSG_FLDNAME_INS [Имя поля]

// PRINT
	#define ABORT_PRINT [Esc-для прекращения]
	#define ALL_RECS [Все записи]
	#define BASE_STAT [ по состоянию на ]
	#define CENTR_NEED [Центровка полей при выводе]
	#define COUNTER_NAME [П/П]
	#define DEF_HBORDER [Разделитель полей: в заголовке]
	#define DEF_BORDER [в теле отчета]
	#define DGT_HEAD_1ST [Номера колонок на: первом листе]
	#define DGT_HEAD_ALL [последующих листах]
	#define END_CHAR [Конечная]+_prn_seq
	#define F_OUT_AP [Дописывать файл вывода]
	#define F_OUT_PRINT [вывод в файл ]
	#define FOROTBOR [для отбора записей]
	#define GROUP_HEAD [Код ]
	#define IS_PRINT [печать]
	#define LASTUPDATED [Создан ]
	#define LEFT_BORD [Левая граница]
	#define MEM_NUM_LINE [Строк в мемо-полях]
	#define MEM_WIDE_PRT [Ширина мемо-полей]
	#define NEED_FF [Прогон между листами]
	#define NEED_HEAD [Заголовки колонок на каждом листе]
	#define NEED_SUM [Суммировать числовые]
	#define NUM_LF [Переводов строки после каждой строки]
	#define NUM_PAGE [Печать номеров листов]
	#define OUT_DEV [Устройство вывода]
	#define ON_PAGE_TOTAL [На листе]
	#define PAGE_LEN [Длина листа(0-лента)]
	#define PLIST [Лист ]
	#define PRNT_TOTAL [Итого ]
	#define PRNT_TOTAL_ALL [Всего ]
	#define PRN_SEQ [ последовательность принтера]
	#define REC_NEED [Печать номеров записей]
	#define REC_RIGHT [Номера справа?]
	#define SELECT_PRINT [Выбираем настройки печати]
	#define STAND_HEAD [Стандартная шапка]
	#define START_CHAR [Стартовая]+_prn_seq
	#define TITLE_ALL [Шапка на каждом листе]
	#define WHERE_DEV [В файл],[В HTML-файл],[На принтер]
	#define WHERE_OUT [Куда выводить? (ESC-отказ, F9 - настройка)]
	#define ZERO_NEED [Печать нулевых значений]
	#define _MSG_PR_F9 [Config]

// ModiStru
	#define BAD_NAME [Неверное имя поля]
	#define BAD_LEN [Неверная длина]
	#define BE_CANCEL [Оставим все как было]
	#define DEL_FIELD [Удаляем поле]
	#define EXIST_NAME [Такое имя уже есть]
	#define FLD_TYPE [Выбирайте тип поля]
	#define HEAD_BROW [Меняем структуру]
	#define MAKE_CHANGE [Сделаем изменения в структуре]
	#define MODIFICATION [изменение структуры]
	#define NEED_OPTIM [Оптимизируем структуру]
	#define FIELDS_OPTIM [ полей оптимизировано]

// MainMenu
	#define _MM_MAINMENU {[Система],[Файл],[База],[Поле],[Запись],[Поис~к],[Информация],[Про~чее]}

	#define _MM_SYSMENU  {	[Драйвер баз по умолчанию ]+'',;
				[Кодировка таблицы],;
				[Установки ]+'',;
				[Сохранить установки],;
				[Вычислить выражение],;
				[Задать переменную],;
				[Помощь],;
				[О программе],;
				[Выход]}

	#define _MM_SETMENU {	[Установки печати],;
				[Цвета],;
				[Установки SET],;
				[Прочие установки-1],;
				[Прочие установки-2]}

	#define _MM_FILEMENU {	[Открыть базу],;
				[Открыть предыдущую],;
				[Изменить структуру],;
				[Создать новую],;
				[Проверить заголовок],;
				[Сохранить окружение],;
				[Восстановить окружение],;
				[Прочитать ini-файл],;
				[Создать файл авто-открытия],;
				[Выход в DOS],;
				[Сменить диск/каталог],;
				[Работа с файлами],;
				[Редактировать текст],;
				[Экспортировать в HTML],;
				[Экспортировать в XML],;
				[Экспортировать в XLS];
				}

	#define _MM_BASEMENU {	[Добавить из другой],;
				[Скопировать в другую],;
				[Скопировать с преобразованием MEMO],;
				[Пометить на удаление],;
				[Снять пометки на удаление],;
				[Инвертировать пометки],;
				[Упаковать],;
				[Сортировать],;
				[Сделать TOTAL],;
				[Индексировать],;
				[Реиндексировать],;
				[Установить индекс],;
				[Работа с тэгами ]+'',;
				[Обратный индекс],;
				[Установить фильтр ]+'',;
				[Посчитать количество],;
				[Напечатать],;
				[Считать файл-отчет];
				}

	#define _MM_RECORDMENU {[Добавить пустую],;
				[Вставить пустую],;
				[Копировать ]+'',;
				[Очистить],;
				[Запись в буфер],;
				[В запись из буфера],;
				[Обменять с верхней],;
				[Обменять с нижней],;
				[Перейти по номеру],;
				[Редактировать],;
				[Вывести в файл];
				}

	#define _MM_FIELDMENU  {[Суммировать],;
				[Заменить все записи константой ]+'',;
				[Заменить все записи выражением ]+'',;
				[Заменить только в текущей записи ]+'',;
				[Очистить],;
				[Отменить исправление],;
				[Преобразовать ]+'',;
				[Выровнять ]+'',;
				[Зашифровать],;
				[Расшифровать],;
				[Занести контрольную сумму строки],;
				[Убрать жир],;
				[Сжать],;
				[Разжать],;
				[Копировать ]+'',;
				IF(m->_ptr<=m->_bdbfBrow:Freeze,[Раз],[За])+[морозить],;
				[Установить условие подсветки в поле],;
				[Снять условие подсветки];
				}
	#define _MM_FIELDMENU_HK [П]

	#define _MM_REPLMENU {[С подтверждением],[Без подтверждения]}

	#define _MM_TRANSMENU { [В ПРОПИСНЫЕ],;
				[в строчные],;
				[С Заглавной],;
				[С Заглавной Во Всех Словах],;
				[в кодировку Windows(1251)],;
				[в кодировку DOS(866)],;
				[QWERTY->ЙЦУКЕН],;
				[ЙЦУКЕН->QWERTY];
				}

	#define _MM_FINDMENU   {[Перейти к записи],;
				[По индексу],;
				[По условию],;
				[Продолжить по условию],;
				[По условию назад],;
				[Продолжить назад],;
				[По контексту],;
				[По контексту (выражение)],;
				[В текущем поле ]+'',;
				[Максимум в поле],;
				[Минимум в поле],;
				[Самое длинное в поле],;
				[Дубль в индексе],;
				[Поиск по маске в индексе],;
				[Продолжить по маске];
	}

	#define _MM_INFOMENU  {[Окружение,база,индексы],;
				[Структура базы],;
				[Таблица ASCII]}

	#define _MM_OTHERMENU  {[Проиграть макро],;
				IF(m->_replay,[Восстановить все поля],[Установить нужные поля]),;
				[Операции с буфером ]+'',;
				[Меню пользователя ]+'',;
				[Банковские операции ]+''}

	#define _MM_TAGMENU    {[Установить тэг],;
				[Удалить тэг],;
				[Добавить тэг],;
				[Установить другой CDX],;
				[Создать все тэги заново];
				}

	#define _MM_COPYMENU   {[Сверху],;
				[Снизу],;
				[Слева],;
				[Справа],;
				[Из буфера],;
				[В буфер],;
				[Из буфера системы],;
				[В буфер системы]}

	#define _MM_CLIPBDMENU {[Из поля в буфер],;
				[Показать буфер],;
				[Буфер в поле],;
				[Буфер + поле],;
				[Буфер - поле],;
				[Буфер * поле],;
				[Буфер / поле],;
				[Запись в буфер],;
				[В запись из буфера]}


//VIEWEDIT
	#define _MSG_VF_PRWAIT [печать]
	#define _MSG_VF_CORRUPTED [ поврежден]
	#define _MSG_VF_PRINTED   [ строк напечатано]
	#define FB_PRINT1 [БУДЕМ ПЕЧАТАТЬ:]
	#define FB_PRINT2 [Весь файл]
	#define FB_PRINT3 [Оставшуюся часть]
	#define FB_PRINT4 [Отказ]
	#define FB_SRCH  [Что искать будем (ESC-отказ)]
	#define FB_ALSO  [ раз найдено и больше нет (Нажмите любую клавишу) ]
	#define SAVE_AND_EXIT [Изменения не сохранены! Действительно выйти?]
	#define SAVE_AND_EXIT_ALT {[Нет], [Да], [Сохранить и выйти]}

//ACTIONS
	#define _MSG_A_AREINDEX [реиндексация (индекс устарел)]
	#define _MSG_A_CASE_SENSITIVE [УЧЕТ РЕГИСТРА БУКВ]
	#define _MSG_A_CHARONLY [Поддерживается только для символьных индексов]
	#define _MSG_A_FLOCK [Ошибка блокировки файла. Повторить?]
	#define _MSG_A_RLOCK [Ошибка блокировки записи. Повторить?]
	#define _MSG_A_UMENU [Меню пользователя]

	#define _MSG_A_F10 [ (F10 - запись)]
	#define _MSG_A_SETS [Установки программы]

	#define _MSG_A_C_TOP	[Установки цветов]
	#define _MSG_A_C_ED	[Основной цвет редакции    ]
	#define _MSG_A_C_HLP	[Помощь,диалоги,результаты ]
	#define _MSG_A_C_MARK	[Маркеры и спецсимволы     ]
	#define _MSG_A_C_MM	[Главное меню              ]
	#define _MSG_A_C_HIDE	[Невыбираемые элементы меню]
	#define _MSG_A_C_HD	[Заголовки панелей         ]
	#define _MSG_A_C_INT	[Интенсивность]
	#define _MSG_A_C_BLINK	[Мигание фона]

	#define _MSG_A_O_TOP	[Различные системные переменные]
	#define _MSG_A_O_FORCED	[Форсированный режим]
	#define _MSG_A_O_IND	[Показывать индикатор]
	#define _MSG_A_O_FRQ	[Частота обновления индикатора(в записях)]
	#define _MSG_A_O_MSK	[Маска баз по умолчанию]
	#define _MSG_A_O_MAC	[Макро по Ctrl+F1]
	#define _MSG_A_O_TIME	[Показывать время исполнения команд]
	#define _MSG_A_O_ED	[Редактор мемо и широких полей (пусто-встроенный)]
	#define _MSG_A_O_VF	[Просмотрщик файлов печати (пусто-встроенный)    ]
	#define _MSG_A_O_TAB	[Ширина табуляции при редакции мемо]
	#define _MSG_A_O_WRAP	[Длина строк при редакции мемо]
	#define _MSG_A_O_NAME	[Ширина имен при просмотре файлов]
	#define _MSG_A_O_ASAVE	[Авто-сохранение]
	#define _MSG_A_O_AREST	[Авто-восстановление]
	#define _MSG_A_O_UNDO	[Размер буфера UNDO]
	#define _MSG_A_O_PG	[Путь поиска плагинов]
	#define _MSG_A_O_MAXF	[Максимальное число полей]
	#define _MSG_A_O_PCKASK [Подтверждать упаковку]
	#define _MSG_A_O_PCKFND [Искать удалённые перед упаковкой]
*
	#define _MSG_A_O_CLCH	[Выбор из внутреннего буфера]
	#define _MSG_A_O_WCLCH	[Выбор из системного буфера]
	#define _MSG_A_O_WCLCNV	[OEM/ANSI при системным с WIN-буфером]
	#define _MSG_A_O_EXOEM	[OEM->ANSI при экспорте по умолчанию]
	#define _MSG_A_O_EXOEMQ	[Запрашивать OEM->ANSI при экспорте]
	#define _MSG_A_O_GSEXP	[Раскрывать выражение контекстного поиска]
	#define _MSG_A_O_GSCOND	[Дополнительное условие контекстного поиска]
	#define _MSG_A_O_FASS	[Реакция на <Enter> в файлере]

	#define _MSG_C_INI_H1	[Data Driver]
	#define _MSG_C_INI_H2	[Системные переменные]
	#define _MSG_C_INI_H3	[Цвета]
	#define _MSG_C_INI_H4	[Принтер]
	#define _MSG_C_INI_H5	[Стандартные Clipper SETs]
	#define _MSG_C_INI_H6	[Пользовательское меню - заголовки]
	#define _MSG_C_INI_H7	[Пользовательское меню - команды]
	#define _MSG_C_INI_HAOP	[Поля, индексы, условия]

	#define _MSG_A_MF_F3	[Зри!]
	#define _MSG_A_MF_F4	[Правь!]

	#define _MSG_A_IF_TITLE [Выберите подходящую функцию: ]
	#define _MSG_A_IF_TRANS [Преобразовать ]
	#define _MSG_A_IF_AINS {;
			[Заменить символы(StrTran)],;
			[Транслировать символы(ChrTran)],;
			cTrans+[В ВЕРХНИЙ РЕГИСТР],;
			cTrans+[в нижний регистр],;
			cTrans+[C Заглавной],;
			cTrans+[С Заглавной Во Всех Словах],;
			cTrans+[в кодировку Windows(1251)],;
			cTrans+[в кодировку DOS(866)],;
			cTrans+[QWERTY->ЙЦУКЕН],;
			cTrans+[ЙЦУКЕН->QWERTY],;
			[Выровнять],;
			[Зашифровать],;
			[Расшифровать],;
			[Занести контрольную сумму строки],;
			[Инвертировать],;
			[Убрать жир],;
			[Сжать],;
			[Разжать],;
			[Фонетический эквивалент];
		}

	#define _MSG_A_JUSTH {[Выравниваем:]}
	#define _MSG_A_JUSTA {[Влево],[По центру],[Вправо],;
				[По ширине],[Разрядка],[Сжатие]}

	#define _MSG_A_FILTH {[Установим фильтр:]}
	#define _MSG_A_FILTA {[По условию],;
				[Равным текущей ячейке],;
				[Неравным текущей ячейке],;
				[Большим текущей ячейки],;
				[Меньшим текущей ячейки],;
				[Большим или равным текущей ячейке],;
				[Меньшим или равным текущей ячейке],;
				[Без фильтра]}

	#define _MSG_A_SIMPH {[Ищем выражение в текущем поле:]}
	#define _MSG_A_SIMPA {	[Равное текущей ячейке],;
				[Неравное текущей ячейке],;
				[Большее текущей ячейки],;
				[Меньшее текущей ячейки],;
				[Большее или равное текущей ячейке],;
				[Меньшее или равное текущей ячейке],;
				[Другое]}



	#define _MSG_A_SDF_FILE_TYPE [Тип файла:]
	#define _MSG_A_SDF_F_DELIM [Разделитель текстовых полей:]
	#define _MSG_A_SDF_A_FILETYPE {[SDF],[DELIMITED],[DELIMITED WITH BLANK],[DBF]}

	#define _MSG_A_CSIZE_NOERR [Ошибок не обнаружено]
	#define _MSG_A_CSIZE	{[Обнаружены расхождения в определении размера базы!],;
				 [Размер логический:     ]+NTRIM(dbSize),;
				 [Размер по заголовку:   ]+NTRIM(xSize),;
				 [Размер файла на диске: ]+NTRIM(fSize),;
				[],[Что взять за основу?];
				}
	#define _MSG_A_CSIZE_MENU1 {[Логический],[(рекомендую)]}
	#define _MSG_A_CSIZE_MENU2 [Заголовок]
	#define _MSG_A_CSIZE_MENU3 [Дисковый]
	#define _MSG_A_CSIZE_MENU4 [Отказ]

	#define _MSG_A_NOPACK [Нет записей для удаления]

	#define _MSG_A_GFCOND [Дополнительное условие поиска]

//HELP
	#define _MSG_H_NO	[Пока нет помощи для этого раздела...]
	#define _MSG_H_TITLE	[Информация об индексах (RDD: ]
	#define _MSG_H_TAGS	[Тэг     из ]
	#define _MSG_H_TAGN	[Имя тэга]
	#define _MSG_H_FE	[Выражение фильтра]
	#define _MSG_H_ISU	[Уникальный ?]
	#define _MSG_H_ISD	[Убывающий ?]
	#define _MSG_H_RYO	[Типа RYO ?]
	#define _MSG_H_KEYS	[Ключей в тэге]
	#define _MSG_H_CK	[Номер ключа]

	#define _MSG_H_OKEY	{[Редактор баз данных формата DBF],;
				BDBF_VERSION,[],;
				[Автор: Евгений Бондарь],;
				[Луганск, Ленинградская 8, (0642) 58-08-19(p)],;
				[E-MAIL: ]+EMAIL,;
				EMAIL2;
				}

	#define CODEPAGE	[Кодовая страница:]+CHR(0)
	#define CURR_DIR	[Текущий каталог:]+CHR(0)
	#define DATE_UPDATE	[Дата обновления базы:]+CHR(0)
	#define DRV_CURRENT	[Драйвер (тип):]+CHR(0)
	#define FILE_SIZE	[Размер файла на диске:]+CHR(0)
	#define FREE_MEM	[Свободно памяти:]+CHR(0)
	#define FREE_SPACE	[Свободно места на диске:]+CHR(0)
	#define HEAD_SIZE	[Размер заголовка:]+CHR(0)
	#define REC_SIZE	[Размер записи:]+CHR(0)
	#define N_USER		[Пользователь:]+CHR(0)
	#define ON_SERVER	[ на сервере ]+CHR(0)
	#define MEMO_BLOCK_SIZE [Размер блока MEMO:]+CHR(0)
	#define MEMO_FILE_SIZE  [Размер MEMO-файла:]+CHR(0)
	#define MEMO_B_SIZE_C   [Размер блока в нем:]+CHR(0)
	#define OS_VER		[Версия ОС:]+CHR(0)
	#define TOTAL_FIELDS	[Всего полей в базе:]+CHR(0)


// GetSys
	#define _MSG_INSOVR	[Вставка],[Замена ]
	#define _MSG_EMODE	{[Usual Enter],[Lock Enter ],[Enter /skip],[Enter /stop]}
	#define _MSG_ASCII	'Таблица ASCII'
	#define _MSG_ASC_SLCT	'Выбрано: '

// ErrorSys
	#define NOT_READY [Принтер не готов.Повторить]
	#define NET_ERR [Ошибка сети]

//Filer
	#define _MSG_FI_TOP	[Выбирайте файл: ]
	#define _MSG_FI_F2	[Диск]
	#define _MSG_FI_F5	[Домой]
	#define _MSG_FI_F9	[Маска]
	#define _MSG_FI_F10	[Инфо]
	#define _MSG_FI_MASK	[Вводите маску отбора]
	#define _MSG_FI_DSCR	[Нет описания для этого файла]

	#define _MSG_FI_FILE	"Файл:"+CHR(0)
	#define _MSG_FI_DIR	"Каталог:"+CHR(0)
	#define _MSG_FI_SIZE	"Размер:"+CHR(0)
	#define _MSG_FI_UPD	"Создан:"+CHR(0)
	#define _MSG_FI_ATTR	"Атрибуты:"+CHR(0)
	#define _MSG_FI_IND	"Индекс:"+CHR(0)
	#define _MSG_FI_KEY	"<KEY>"+CHR(0)

//ClipLib
	#define _MSG_CL_NOF	[Внимание! При обработке были ошибки переполнения]
	#define _MSG_CL_NOONE	[Не задано ни одного правильного поля или выражения]

#ELSE

#define ANY [Press any key for continue]
#define ATTACHING [appending]
#define APPEND_SELF [Append from itself?]
#define A_COPY {[Current],[Last],[Abort]}
#define A_SETF_BROW {Padc([Field],nScroll),Padc([Field name],nScroll),[Picture],[Wide]}
#define BADNAME [Bad name or writing is prohibited]
#define BADWRITE [Writing is prohibited]
#define BAD_EXPR [Wrong expression ]
#define BAD_EXT [Bad extension(BAK)]
#define BASE_STRUC [Base structure ]
#define BYTE [ b]
#define CALC_EXPR [for calculating ]
#define CALC_FIELD [Can not replace calculated field]
#define CHECK_DBF_FORCED {[Модифицированный Visual FoxPro],;
			  [dBase IV  and above],;
			  [FlagShip],;
			  [FlexMemo],;
			  [dBase II  or Foxbase 1.0],;
			  [Unknown]}
#define CHECK_DBF_TRY  {[The opening of this base is unsupported in standard mode],;
			[Possible format: ]+NeedForced,;
			[],;
			[Should we try open it in forced mode ?],;
			[(See also ch.34 bdbfs.txt for explaining)]}
#define CLIPBOARD  [Clipboard]
#define COLOR_COND [Color separation condition]
#define CONDITION [Condition:]
#define COPYING [copying]
#define _CopyRight 'Usage: Bdbfs <File>[.DBF|.MEM|.INI] [/bw] [/i=index] [Auto-actions (see ch.33 bdbfs.txt)]'+;
	_CRLF+'Support: '+EMAIL
#define CORRUPT_OR_LOCKED _corrupted+[ or locked]
#define COUNTING [counting]
#define DATEFORMAT [mm/dd/yyyy]
#define DELETING [deleting]
#define DISK_KAT _Give +[the disk and dir]
#define DOS_RET [Type EXIT for return !]
#define DRV_DEFAULT [Select default RDD]
#define DRV_FOR_COPY [RDD for new base]
#define DRV_NTX [Not supported for RDD NTX]
#define EMPTY_BASE [ EMPTY BASE  ]
#define EMPTY_IS_ALL [ ( Empty means "ALL" )]
#define ENVIR_F [of environment]
#define EXPR_TOTAL [Key expression]
#define FIELD_ED [Field redaction ]
#define FIELD_ERR [Error field: ]
#define FLDS_COPYING [Fields ( Empty means "ALL" )]
#define FLDS_SELECT [Select the fields]
#define FLDS_TOTAL [Fields to TOTAL]
#define FORCE_PROHIBITED [It is prohibited in "forced" mode]
#define FULL_ED [Up Down PgUp PgDn, Esc - browse]
#define FUNC_FIND [searching]
#define F_ATTACHING [for appending]
#define F_COPYING [for copying]
#define F_CREATE [File created: ]
#define F_ENVIR [for environment saving]
#define F_FLTRING [filter]
#define F_INDEXING [for indexing]
#define F_SEARCH [for searching:]
#define F_SHOW {[Show it?],[Abort]}
#define F_SORTING [for sorting]
#define GET_PSW [Password:]
#define GIVE_VAR _Give +[the variable and expression (f.e. xVar:=xVal)]
#define GLOB_FIND [context searching]
#define IND_FILE [Index file ]
#define INDEXING [indexing]
#define INDEX_CHOICE [Select index]
#define INDEX_CORRUPT [index ]+_corrupted
#define INDEX_NO L_A_SIGN+[ No Index]
#define INDEX_NOT_MATCH [Index does not match the base. Reindex?]
#define INI_F [of initialization]
#define INSERTING [inserting]
#define INVERTING [inverting]
#define IS_COMPUT [Can not replace computable field]
#define IS_UNIQ [Unique index]
#define IT_RECS [Total ]+SpaceString(m->__Count)+ [ records]
#define I_SEARCH [searching through index.]
#define KBYTE [ Kb]
#define L_YES_SET [YyTt1]
#define L_NO_SET [NnFf0]
#define LONGEST [Longest is: ]
#define MEMOFIELD [Memo-field view ]
#define MEMO_NO_MATCH {[MEMO-field exists, but it[s no signed in header],;
		       [Correct header?]}
#define MENU_MAX() Menu2({[Maximum],[Minimum]},1,WHAT_FIND+_ABORT)
#translate MENU_RECS(<txt>) => Menu2({ALL_RECS,\[Rest]}, _scope,;
			 \[Select the scope of ]+<txt>)
#define MENU_SCOPE {[1-Yes],[2-No],[3-Skip],[0-Abort]}
#define MSG_MNU_YESNO Menu2({[1-YES],[0-NO]},_choice,_mess,[ARE YOU SURE?])
#define NEED_DEL_FILE [. Erase it?]
#define NEED_FINISH [Finish working]
#define NEED_OEM2ANSI [Convert OEM to ANSI?]
#define NEED_PACK [Delete marked records]
#define NEED_REBUILD [Create all tags anew]
#define NEED_REINDEX [Reindex the base]
#define NEED_REPLACE [Replace: ]
#define NEED_ZAP [ZAP the base]
#define NODIGITAL [Current field is not numeric]
#define NOCHARACTER [Current field is not character]
#define NOOP_IND [The operation is prohibited when index is open]
#define NO_FIND_EXPR [There is not of searching condition]
#define NO_FLTR [Record is out of filter]
#define NO_FLTRING [No such records]
#define NO_DPZ [No such record]
#define NO_KAT [ - directory does not exist or locked]
#define NO_ORDER [No opened index files]
#define NO_SPACE [No free disk space]
#define N_RECORD [Record]
#define N_RECORD_COL [Record: ]
#define PACKING [packing]
#define PROCESSED [Processed: ]
#define READY [READY !]
#define RECALLING [recalling]
#define REC_GO [Go to the record:]
#define REC_FIND [Find record based on: ]
#define REC_FIND_C {[Record number],[Shift from current],[Key number]}
#define REC_SM [Position from current record (+ -): ]
#define REMOVED NTRIM(_tally)+ [ records was killed]
#define REMOVING [removing]
#define REPLACING [replacing]
#define REPL_EXPR [ for replacing ]
#define RESULT_IS [The result of: ]
#define SEC_M [ s.]
#define SELECT_BASE [Select the base]
#define SELECT_CP [Select default codepage]
#define SET_FIELDS [Set fields:]
#define SET_OF_OEM  "АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюяЁёЄєЇїЎў°∙"
#define SET_OF_ANSI "└┴┬├─┼╞╟╚╔╩╦╠═╬╧╨╤╥╙╘╒╓╫╪┘┌█▄▌▐▀рстуфхцчшщъыьэюяЁёЄєЇїЎў°∙·√№¤* и╕е┤к║▓│п┐"
#define SET_OF_USA  [QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>qwertyuiop] + "[]" + [asdfghjkl;'zxcvbnm,.]
//#define SET_OF_USA  [QWERTYUIOP{}ASDFGHJKL: ZXCVBNM<>qwertyuiop]
//+ "[]" + [asdfghjkl;'zxcvbnm,.]
#define SET_OF_MYKB "ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮйцукенгшщзхъфывапролджэячсмитьбю"
#define SET_OF_M_NO [123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ#]
#define SORTING [sorting]
#define SUMMING [summarizing]
#define SUM_IS [The sum  = ]
#define TAG_HEAD PAD([NAME],14)+PAD([EXPRESSION],45)+PAD([CONDITION],18)
#define TAG_NAME [tag name]
#define TAG_NAME_DEL [tag name for removing]
#define TAG_NO L_A_SIGN+[ No Order]
#define TAG_NUMBER [tag number]
#define TimerOff()  [Time:]+LTRIM(STR(Seconds()-m->_told,9,2))+ ;
	[ Processed: ]+NTRIM(m->_tally)
#define TOO_SHORT {[String is too short.],;
		   [Probably It will not be effective.],[Compress it ?]}
#define TXT_NAME _give+[filename]
#define UNSUPPORT [ - unsupported format]
#define USE_HISTORY [Use history]
#define MSG_USERMENU_NO [User-menu not defined]
#define WAIT_WIND [Waiting, ]
#define WHAT_COPY [What record: ]
#define WHAT_FIND [What do we need ?]
#define YESNO [Yes],[No ]
#define _NEEDOVER [ already exists. Overwrite ?]

// Private
	#define PRV_ZU       [Input the condition of ]
	#define PRV_ZIF      [File name ]
	#define PRV_ZIFN     [New file name: ]
	#define PRV_IV       [Index key ]
	#define PRV_NOFILE   [File not found ]
	#define PRV_NOMEMO   [Can not open file ]
	#define PRV_ABORT    [ (Esc - abort)]

// Static
	#define _STAT_CORRUPTED [ is corrupted]
	#define _STAT_ELSEUse [Base is in use by another.]
	#define _STAT_END_EDIT [F10 - Exit and save, Esc - Abort]
	#define _STAT_ERTIP [Wrong type ]
	#define _STAT_GIVE [Enter ]
	#define _STAT_GIVE_NAME L_A_SIGN+[ Other name]
	#define _STAT_NFD [Not found]
	#define _STAT_NOINDEX [No index set]
	#define _STAT_ZE [Input the expression ]

// InsKeys
	#define MSG_ClpVal [Clipboard value]
	#define MSG_cTitleIns [Insert at the cursor: ]
	#define MSG_aIns {[Base name],[Field value],[Field name],;
		[Field header],MSG_ClpVal,[Any field name],;
		[Any field header],[Quoted field value],[Symbol]}
	#define MSG_PUTTITLE [Put this result into: ]
	#define MSG_PUTWHERE {[Current field],[Clipboard],[System clipboard]}
	#define MSG_FLDHEAD_INS [Insert header of field]
	#define MSG_FLDNAME_INS [Insert name of field]

// PRINT
	#define ABORT_PRINT [ESC-for aborting]
	#define ALL_RECS [All records]
	#define BASE_STAT [ : situation by ]
	#define CENTR_NEED [Center justifying]
	#define COUNTER_NAME [NN]
	#define DEF_HBORDER [Field's delimiter: in header]
	#define DEF_BORDER [in body]
	#define DGT_HEAD_1ST [Head's numbers: on 1st page]
	#define DGT_HEAD_ALL [on next pages]
	#define END_CHAR [Ending]+_prn_seq
	#define F_OUT_AP [Append to output file?]
	#define F_OUT_PRINT [printing to ]
	#define FOROTBOR [printing]
	#define GROUP_HEAD [Code ]
	#define IS_PRINT [printing]
	#define LASTUPDATED [Last update: ]
	#define LEFT_BORD [ Left margin]
	#define MEM_NUM_LINE [Lines in memo-fields]
	#define MEM_WIDE_PRT [Memo-fields width]
	#define NEED_FF [Page eject]
	#define NEED_HEAD [Head's names on each page]
	#define NEED_SUM [Summing of Numeric]
	#define NUM_LF [Line feed number after each line]
	#define NUM_PAGE [Page numbers]
	#define ON_PAGE_TOTAL [On page]
	#define OUT_DEV [Print device]
	#define PAGE_LEN [Lines per page(0-no paging)]
	#define PLIST [Page ]
	#define PRNT_TOTAL [Total in group]
	#define PRNT_TOTAL_ALL [Total ]
	#define PRN_SEQ [ print codes]
	#define REC_NEED [Record numbers print]
	#define REC_RIGHT [At right side?]
	#define SELECT_PRINT [Print tuning]
	#define STAND_HEAD [Standard title]
	#define START_CHAR [Starting]+_prn_seq
	#define TITLE_ALL [Title on each page]
	#define WHERE_DEV [To file],[To HTML],[To printer]
	#define WHERE_OUT [Device of output? (ESC-abort, F9-tune)]
	#define ZERO_NEED [Print of zero values]
	#define _MSG_PR_F9 [Config]

// ModiStru
	#define BAD_NAME [Bad field name]
	#define BAD_LEN [Wrong field length]
	#define BE_CANCEL [Cancel modification]
	#define DEL_FIELD [Delete the field]
	#define FLD_TYPE [Select field type]
	#define EXIST_NAME [The name already exists]
	#define HEAD_BROW [Modify Structure]
	#define MAKE_CHANGE [Make permanent changes]
	#define MODIFICATION [modification]
	#define NEED_OPTIM [Make optimization]
	#define FIELDS_OPTIM [ fields are optimized]

// MainMenu
	#define _MM_MAINMENU {[System],[File],[Base],[Fiel~d],[Record],[Fi~nd],[Info],[Other]}
	#define _MM_SYSMENU  {  [Default RDD ]+'',;
				[Default codepage],;
				[Settings ]+'',;
				[Save settings],;
				[Calculate],;
				[Set variable],;
				[Help],;
				[About],;
				[Quit]}

	#define _MM_SETMENU {	[Print],;
				[Colors],;
				[SET-s],;
				[Other-1],;
				[Other-2]}

	#define _MM_FILEMENU {	[Open base],;
				[Reopen last],;
				[Change structure],;
				[Create new],;
				[Check header],;
				[Save environment],;
				[Restore environment],;
				[Read ini-file],;
				[Create Auto-Open file],;
				[Shell to DOS],;
				[Change disk/directory],;
				[Filer],;
				[Modify text],;
				[Export to HTML],;
				[Export to XML],;
				[Export to XLS];
				}

	#define _MM_BASEMENU {	[Append from],;
				[Copy To],;
				[Copy with MEMO converting],;
				[Delete],;
				[Restore],;
				[Invert deleted],;
				[Pack],;
				[Sort],;
				[Total],;
				[Index],;
				[Reindex],;
				[Set index],;
				[TAGS ]+'',;
				[Descend index],;
				[Set filter ]+'',;
				[Count],;
				[Print],;
				[Read report template];
				}

	#define _MM_RECORDMENU {[Add new],;
				[Insert before],;
				[Copy ]+'',;
				[Clear],;
				[Write to clipboard],;
				[Read from clipboard],;
				[Change with upper record],;
				[Change with lower record],;
				[Go To],;
				[Edit],;
				[Print To File];
				}

	#define _MM_FIELDMENU  {[Sum],;
				[Replace all by constant ]+'',;
				[Replace all by expression ]+'',;
				[Replace only current ]+'',;
				[Clear],;
				[Undo replace],;
				[Translate ]+'',;
				[Align ]+'',;
				[Crypt],;
				[DeCrypt],;
				[Check sum of record],;
				[Delete slim],;
				[Compress],;
				[DeCompress],;
				[Copy ]+'',;
				IF(m->_ptr<=m->_bdbfBrow:Freeze,[Unf],[F])+[reese],;
				[Set color condition for current field],;
				[Reset normal color];
				}
	#define _MM_FIELDMENU_HK [D]

	#define _MM_REPLMENU {[With confirming],[Without confirming]}

	#define _MM_TRANSMENU { [UPPER CASE],;
				[lower case],;
				[Proper],;
				[All Words Proper],;
				[OemToAnsi],;
				[AnsiToOem],;
				[To National keyboard],;
				[To USA keyboard];
			       }

	#define _MM_FINDMENU   {[Go to],;
				[Seek],;
				[Locate],;
				[Continue],;
				[Locate backwards],;
				[Continue backwards],;
				[Context (all fields)],;
				[Context with expression],;
				[In current field only ]+'',;
				[Maximum in field],;
				[Minimum in field],;
				[Longest in field],;
				[Double in index],;
				[WildSeek in index],;
				[Continue WildSeek];
	}

	#define _MM_INFOMENU  {[Environment,base,indexes],;
				[Base structure],;
				[ASCII-Table]}

	#define _MM_OTHERMENU  {[Play macro],;
				IF(m->_replay,[Restore fields],[Set fields]),;
				[Clipboard operations ]+'',;
				[User menu ]+''}

	#define _MM_TAGMENU    {[Set tag],;
				[Delete tag],;
				[Add tag],;
				[Set another CDX],;
				[Create all tags anew];
				}

	#define _MM_COPYMENU   {[Upper field ],;
				[Lower field],;
				[Left field],;
				[Right field],;
				[From clipboard],;
				[To clipboard],;
				[From System clipboard],;
				[To System clipboard]}

	#define _MM_CLIPBDMENU {[Read field to clipboard],;
				[Show clipboard],;
				[Write clipboard to field],;
				[Clipboard + field],;
				[Clipboard - field],;
				[Clipboard * field],;
				[Clipboard / field],;
				[Write current record to clipboard],;
				[Write to current record from clipboard]}


//VIEWEDIT
	#define _MSG_VF_PRWAIT [it is printing]
	#define _MSG_VF_CORRUPTED [ is corrupted]
	#define _MSG_VF_PRINTED   [ lines printed]
	#define FB_PRINT1 [PRINT:]
	#define FB_PRINT2 [Whole file]
	#define FB_PRINT3 [Rest of file]
	#define FB_PRINT4 [Abort]
	#define FB_SRCH  [Enter Search Phrase: ]
	#define FB_ALSO  [ Occurrences Found - No More Finds (Press Any Key) ]
	#define SAVE_AND_EXIT [File not saved! Are you sure you want to exit?]
	#define SAVE_AND_EXIT_ALT {[No], [Yes], [Save and quit]}

//ACTIONS
	#define _MSG_A_AREINDEX [reindexing (index does not match)]
	#define _MSG_A_CASE_SENSITIVE [CASE SENSITIVE]
	#define _MSG_A_CHARONLY [Current index is not character!]
	#define _MSG_A_FLOCK [Can not lock file. Repeat?]
	#define _MSG_A_RLOCK [Can not lock record. Repeat?]

	#define _MSG_A_UMENU [User menu]

	#define _MSG_A_F10 [ (F10 - saving)]
	#define _MSG_A_SETS [Program settings]

	#define _MSG_A_C_TOP	[Color settings]
	#define _MSG_A_C_ED	[Main edition color         ]
	#define _MSG_A_C_HLP	[Help, dialogues, results   ]
	#define _MSG_A_C_MARK	[Markers & special symbols  ]
	#define _MSG_A_C_MM	[Main menu                  ]
	#define _MSG_A_C_HIDE	[Unselectable menu elements ]
	#define _MSG_A_C_HD	[Panels headers             ]
	#define _MSG_A_C_INT	[Intensity]
	#define _MSG_A_C_BLINK	[Blinking]

	#define _MSG_A_O_TOP	[Different system variables]
	#define _MSG_A_O_FORCED [Forced mode]
	#define _MSG_A_O_IND	[Indicator]
	#define _MSG_A_O_FRQ	[Indicator refreshing frequency (in records)]
	#define _MSG_A_O_MSK	[Default database mask]
	#define _MSG_A_O_MAC	[Macro (called on Ctrl+F1)]
	#define _MSG_A_O_TIME	[Command timing]
	#define _MSG_A_O_ED	[Memo and wide fields editor (empty-embedded)]
	#define _MSG_A_O_VF	[Print files viewer (empty-embedded)         ]
	#define _MSG_A_O_TAB	[Tab width in memo fields]
	#define _MSG_A_O_WRAP	[Wrap position in memo fields]
	#define _MSG_A_O_NAME	[File names width in FILER]
	#define _MSG_A_O_ASAVE	[Auto-Save]
	#define _MSG_A_O_AREST	[Auto-Restore]
	#define _MSG_A_O_UNDO	[Max UNDO count]
	#define _MSG_A_O_PG	[Plugins search path]
	#define _MSG_A_O_MAXF	[Max number of shown fields]
	#define _MSG_A_O_PCKASK [PACK confirm]
	#define _MSG_A_O_PCKFND [Locate for Deleted before PACK]
*
	#define _MSG_A_O_CLCH	[Choice from internal clipboard]
	#define _MSG_A_O_WCLH	[Choice fron Sys clipboard]
	#define _MSG_A_O_WCLCNV	[OEM/ANSI with Sys clipboard]
	#define _MSG_A_O_EXOEM	[OEM->ANSI during the exports]
	#define _MSG_A_O_EXOEMQ	[Ask for OEM->ANSI before the exports]
	#define _MSG_A_O_GSEXP	[Expand the context search expression]
	#define _MSG_A_O_GSCOND	[Additional condition of context search]
	#define _MSG_A_O_FASS	[File associations in FILER]

	#define _MSG_C_INI_H1	[Data Driver]
	#define _MSG_C_INI_H2	[System variables]
	#define _MSG_C_INI_H3	[Colors]
	#define _MSG_C_INI_H4	[Printer]
	#define _MSG_C_INI_H5	[Clipper standard SETs]
	#define _MSG_C_INI_H6	[User menu prompts]
	#define _MSG_C_INI_H7	[User menu actions]
	#define _MSG_C_INI_HAOP	[Fields, orders, conditions]

	#define _MSG_A_MF_F3	[View]
	#define _MSG_A_MF_F4	[Edit]

	#define _MSG_A_IF_TITLE [Select function: ]
	#define _MSG_A_IF_TRANS []
	#define _MSG_A_IF_AINS {;
			[Change symbols(StrTran)],;
			[Translate symbols(ChrTran)],;
			[UPPER CASE],;
			[lower case],;
			[Proper],;
			[All Words Proper],;
			[OemToAnsi],;
			[AnsiToOem],;
			[To national keyboard],;
			[To USA keyboard],;
			[Align],;
			[Crypt],;
			[DeCrypt],;
			[Check sum of record],;
			[Descend],;
			[Delete slim],;
			[Compress],;
			[DeCompress],;
			[Soundex];
		}

	#define _MSG_A_JUSTH {[Align:]}
	#define _MSG_A_JUSTA {[Left],[Center],[Right],[Justify],[Spread],[Reduce]}

	#define _MSG_A_FILTH {[SET FILTER TO:]}
	#define _MSG_A_FILTA {[Condition],;
				[Equal to Current Cell],;
				[Not Equal to Current Cell],;
				[Greater Than Current Cell],;
				[Less Than Current Cell],;
				[Greater or Equal Than Current Cell],;
				[Less or Equal Than Current Cell],;
				[No Filter]}

	#define _MSG_A_SIMPH {[Find Expression in Current Field:]}
	#define _MSG_A_SIMPA {	[Equal to Current Cell],;
				[Not Equal to Current Cell],;
				[Greater Than Current Cell],;
				[Less Than Current Cell],;
				[Greater or Equal Than Current Cell],;
				[Less or Equal Than Current Cell],;
				[Another]}


	#define _MSG_A_SDF_FILE_TYPE [File type]
	#define _MSG_A_SDF_F_DELIM [Text fields delimiter:]
	#define _MSG_A_SDF_A_FILETYPE {[SDF],[DELIMITED],[DELIMITED WITH BLANK],[DBF]}

	#define _MSG_A_CSIZE_NOERR [No errors found]
	#define _MSG_A_CSIZE	{[The divergences in definition of the database size were found out],;
				 [Logical size:      ]+NTRIM(dbSize),;
				 [Header-based size: ]+NTRIM(xSize),;
				 [Disk file size:    ]+NTRIM(fSize),;
				[],[What is right?];
				}
	#define _MSG_A_CSIZE_MENU1 {[Logical],[(recommended)]}
	#define _MSG_A_CSIZE_MENU2 [Header]
	#define _MSG_A_CSIZE_MENU3 [Disk]
	#define _MSG_A_CSIZE_MENU4 [Abort]

	#define _MSG_A_NOPACK [Deleted records are not found]

	#define _MSG_A_GFCOND [Additional condition]
//HELP
	#define _MSG_H_NO	[Sorry, no help here]
	#define _MSG_H_TITLE	[TAGS INFORMATION (RDD : ]
	#define _MSG_H_TAGS	[TAG      /  ]
	#define _MSG_H_TAGN	[Tag Name]
	#define _MSG_H_FE	[Filter expression]
	#define _MSG_H_ISU	[Is unique ?]
	#define _MSG_H_ISD	[Is descent ?]
	#define _MSG_H_RYO	[RYO-type ?]
	#define _MSG_H_KEYS	[Keys total]
	#define _MSG_H_CK	[Current key]

	#define _MSG_H_OKEY	{[DBF - editor],;
				BDBF_VERSION,[],;
				[Author: Eugen Bondar],;
				[Lugansk, Ukraine],;
				[E-MAIL: ]+EMAIL,;
				EMAIL2;
				}

	#define CODEPAGE	[Code page:]+CHR(0)
	#define CURR_DIR	[Current dir:]+CHR(0)
	#define DATE_UPDATE	[Last update:]+CHR(0)
	#define DRV_CURRENT	[Driver (type):]+CHR(0)
	#define FILE_SIZE	[Disk size:]+CHR(0)
	#define FREE_MEM	[Free memory:]+CHR(0)
	#define FREE_SPACE	[Free disk space:]+CHR(0)
	#define HEAD_SIZE	[Header size:]+CHR(0)
	#define REC_SIZE	[Record size:]+CHR(0)
	#define N_USER		[User:]+CHR(0)
	#define ON_SERVER	[ on server]+CHR(0)
	#define MEMO_BLOCK_SIZE [Memo block size:]+CHR(0)
	#define MEMO_FILE_SIZE  [Memo-file size:]+CHR(0)
	#define MEMO_B_SIZE_C   [Block size in it:]+CHR(0)
	#define OS_VER		[OS version:]+CHR(0)
	#define TOTAL_FIELDS	[Total fields:]+CHR(0)

// GetSys
	#define _MSG_INSOVR	[Ins],[Ovr]
	#define _MSG_EMODE	{[Usual Enter],[Lock Enter ],[Enter /skip],[Enter /stop]}
	#define _MSG_ASCII	[ASCII-Table]
	#define _MSG_ASC_SLCT	[Selected: ]

// ErrorSys
	#define NOT_READY [Printer is not ready.Repeat]
	#define NET_ERR [Network error]

// FILER
	#define _MSG_FI_TOP	[Select file: ]
	#define _MSG_FI_F2	[Disk]
	#define _MSG_FI_F5	[Go Home]
	#define _MSG_FI_F9	[Mask]
	#define _MSG_FI_F10	[Info]
	#define _MSG_FI_DSCR	[There is no description for this file]
	#define _MSG_FI_MASK	[Input file mask]

	#define _MSG_FI_FILE	[File:]+CHR(0)
	#define _MSG_FI_DIR	[Directory:]+CHR(0)
	#define _MSG_FI_SIZE	[Size:]+CHR(0)
	#define _MSG_FI_UPD	[Last updated:]+CHR(0)
	#define _MSG_FI_ATTR	[Attributes:]+CHR(0)
	#define _MSG_FI_IND	[Index information:]+CHR(0)
	#define _MSG_FI_KEY	[<KEY>]+CHR(0)

//ClipLib
	#define _MSG_CL_NOF	[Warning! It was fixed a numeric overflow.]
	#define _MSG_CL_NOONE	[Any correct field or expression is not given]

#ENDIF
