#include <clip-gtk.ch>
#include <inkey.ch>

static hb, uTmp1 := 'no1', uTmp2 := 'no2', st, nEntry_ := {0,0}, bEntry_ := {.F.,.F.}, sEntry_ := {"Enter a access code","Enter a parol"}

function main()
	local w,  ;	// указатель на виджет ОКНО (главное окно программы)
	f,  ;	//
	vb,  ;	//
	sw,  ;	//
	qbtn, en

	/* Initialize GTK+ system */
	gtk_init()

	/* Create main window */
	/***************************************************/
	w:= gtk_WindowNew(,"main application window")
	gtk_SignalConnect(w,"delete-event",{|wid,e|gtk_Quit()})

	/* Create vertical box container */
	vb:= gtk_VBoxNew()
	gtk_ContainerAdd (w, vb)

	/* Create horizontal box containers and fill it */
	hb0 := gtk_HBoxNew()
	gtk_BoxPackStart(vb,hb0,.T.,.T.,2)

	nEntry_[1] :=gtk_EntryNew()
	gtk_EntrySetMaxLength(nEntry_[1],10)
	gtk_BoxPackStart(hb0,gtk_LabelNew(,"your code"),.F.,.F.,2)
	gtk_BoxPackStart(hb0,nEntry_[1],.F.,.F.,2)
	gtk_WidgetSetFocus(nEntry_[1])

	gtk_SignalConnect(nEntry_[1],GTK_EVENT, @KEY_HANDLER())
//при таком
//подключении поля ввода вообще не проявляются
// на экране. честно говоря, вообще не помню, где я выкопал такой пример.
//так что вопрос скорее теоретический - почему не работает ?

//Re: все дело в том, что GTK_EVENT включает в себя вообще ВСЕ события,
// каждое движение мышкой, нажатие клавиши, перерисовка и прочее.
// Это не совсем верно отслеживать это событие. Правильнее Ваш второй
// вариант. И еще KEY_HANDLER() должен вернуть .t. || .f.. Если return NIL,
// то считается, что возвращено значение .t. и обработка сигнала останавливалась
// .f. - значит, что сигнал возможно обработан, но еще должна выполнится стандартная
// обработка сигнала. В Вашем случае, когда отлавливался сигнал GTK_EVENT
// функция KEY_HANDLER() должна возвращать .f.. Те виджет создался, ему послался
// каккой-нибудь сигнал прорисовки, а он у вас не обрабатывается ни по одной
// ветке и все - приехали, вернули NIL и обработка сигнала прекратилась.
// Виджет как таковой существует, но не может нарисоваться.


// при таком включении ОК, но первое нажатие сьрелки вних вызывает сигнал,
//но не выхывает перемещения фокуса. второе нажатие и все последующие проходят
//нормально
//	gtk_SignalConnect(nEntry_[1],"key-press-event", @KEY_HANDLER())
//	gtk_SignalConnect(nEntry_[1],"focus-out-event", @KEY_HANDLER())

//RE:Тут функция работает потому, что вызывается только когда виджет получает
//сигнал key-press-event или focus-out-event. Они в KEY_HANDLER обрабатываются.


// и ликбез - такое включение аналогично указанию на блок кода типа:
// 	gtk_SignalConnect(w,"delete-event",{|wid,e|gtk_Quit()})
// где в нее параметрами передаются те же значения, что и в блок кода
//( в данном случае wid,e) ?

// RE: да, конечно! Только конкретно в этой строчке
// gtk_SignalConnect(w,"delete-event",{|wid,e|gtk_Quit()})
// ни к какому конкретному виджету функция не применяется. Просто говорится -
// quit и все.

// есть ли где в исходниках список сигналов, их применимость к объектам
//и список передаваемых параметров ?

// RE: Есть. Для ЛЮБОГО виджета применимы сигналы и события описаные в
// widget.c В начале файла есть массив widget_signals вот в нем и описаны
// все доступные сигналы. Например,
//static SignalTable widget_signals[] =
//{
//       /* signals */
//       {"map",                 GSF( widget_signal_handler ),   ESF( object_emit
//       {"unmap",               GSF( widget_signal_handler ),   ESF( object_emit
//	.....
// то, что в кавычках - имя сигнала.
// Для каждого конкретного виджета может быть, а может и не быть в дополнение
// к сигналам, описаным в widget_signals свои сигналы. Если они есть, то они
// описаны подобным образом в соответствующем файле. Например, для виджета
// button, а файле button.c есть массив button_signals.
// Со списками параметров сложнее. После названия сигнала, стоит имя обработчика.
// По большей части это функция widget_signal_handler() в этом случае обработчик
// получает виджет, событие и какой-нибудь еще один параметр(если надо), Этот
// параметр должен быть только один, но любого типа. При желании  можно передать
// несколько параметров поместив их в массив или map
// Если имя функции обработчика другое, то уже нужно смотреть исходники. Потому
// как набор параметров может быть различен, или еще что-нибудь.
// вот например, для сигнала "size-allocate"  будет вызван обработчик
// handle_size_allocate_signal() в котором будет автоматически сформирован
// третий параметр для пользовательской функции - map . Он  будет содержать
// 4 атрибута: X, Y, WIDTH, HEIGHT. Те пользовательская функция получит
// виджет, сигнал и этот третий - map.	  См widget.c
// Понимаю, что немного сложновато, но оно так и есть. Приходится постоянно
// пользоваться стандартой документацией на gtk , Кстати в ней есть и
// дерево наследования или может его лучше назвать иерархией наследования конкретным
// виджетом свойств родителей?


	hb1 := gtk_HBoxNew()
	gtk_BoxPackStart(vb,hb1,.T.,.T.,2)

	nEntry_[2] :=gtk_EntryNew()
	gtk_EntrySetMaxLength(nEntry_[2],40)
	gtk_BoxPackStart(hb1,gtk_LabelNew(,"your parol"),.T.,.F.,2)
	gtk_BoxPackStart(hb1,nEntry_[2],.T.,.F.,2)
	gtk_SignalConnect(nEntry_[2],"key-press-event", @KEY_HANDLER())
	gtk_SignalConnect(nEntry_[2],"focus-out-event", @KEY_HANDLER())

	hb2 := gtk_HBoxNew()
	gtk_BoxPackStart(vb,hb2,.T.,.T.,2)

	bn1 :=gtk_ButtonNew(,"OK")
	gtk_SignalConnect(bn1,GTK_CLICKED_SIGNAL,{||Check_Entry_()})
	gtk_BoxPackStart(hb2,bn1,.T.,.T.,2)

	bn2 :=gtk_ButtonNew(,"Cancel")
	gtk_SignalConnect(bn2,GTK_CLICKED_SIGNAL,{||gtk_Quit()})
	gtk_BoxPackStart(hb2,bn2,.T.,.T.,2)
	gtk_SignalConnect(bn2,"deactivate", @CHECK_OK_())

	st := gtk_StatusBarNew()
	gtk_BoxPackEnd(vb,st,.F.,.F.)
	gtk_StatusBarSetText(st,"Enter a access code and parol")

	/* Show main window */
	/***************************************************/
	gtk_WidgetShowAll( w )

	/* Do GTK+ events */
	gtk_main()
return

STATIC FUNCTION Check_Entry_()
FOR nTmp = 1 TO LEN(nEntry_)
    IF .NOT. bEntry_[nTmp]
	      gtk_StatusBarSetText(st,sEntry_[nTmp])
	      gtk_WidgetSetFocus(nEntry_[nTmp])
	RETURN .T.
    ENDIF
NEXT
gtk_Quit()
RETURN .T.

STATIC FUNCTION Check_OK_(nWidg_, Event)
// можно ли пользоваться таким циклом для проверки возникновения сигнала на виджете ????????
// RE: не поняла, Какого сигнала и что значит проверить возникновение сигнала?


FOR nTmp = 1 TO LEN(nEntry_)
    IF nWidg_ == nEntry_[nTmp]
	    sTmp := gtk_EntryGetText(nEntry_[nTmp])
	    IF LEN(TRIM(sTmp)) = 0				// не ввели данные
		bEntry_[nTmp] = .F.                         // данные не введены
		  qout('fak '+ntoc(nTmp))      // выводим в статус бар подсказку о необходимости ввода
	    ELSE
		bEntry_[nTmp] = .T.                         // данные введены
		  qout('OK '+ntoc(nTmp))      // выводим в статус бар подсказку о необходимости ввода
	    ENDIF
    ENDIF
NEXT
qout(';;;;OK ')      // выводим в статус бар подсказку о необходимости ввода
RETURN .T.

STATIC FUNCTION KEY_HANDLER(nWidg_, Event)
LOCAL sTmp, sTmp1 := 'Enter ', nTmp, ;
bReady_ := .T.		// готовность всех полей ввода
// где посмотреть список свойств каждого события ??????
// RE: вообще-то каждое событие/сигнал имеет железно свойство EVENT код события
// или сигнала, а остальные можно посмотреть в файле object.c функция handle_events()
// и object_emit_event()
// список кодов см в clip-gtk.ch
nTmp1 = Event:event

IF nTmp1 = GTK_KEY_PRESS
    FOR nTmp = 1 TO LEN(nEntry_)
       IF nWidg_ == nEntry_[nTmp]
	   EXIT
       ENDIF
    NEXT
    qout('GTK_KEY_PRESS'+STR(nTmp1)+'/'+STR(nTmp))      // выводим в статус бар подсказку о необходимости ввода
    IF Event:keyval == K_ENTER
	FOR nTmp = 1 TO LEN(nEntry_)
	    IF nWidg_ == nEntry_[nTmp]
		sTmp := gtk_EntryGetText(nEntry_[nTmp])
		IF LEN(TRIM(sTmp)) = 0				// не ввели данные
			  gtk_StatusBarSetText(st,sEntry_[nTmp])      // выводим в статус бар подсказку о необходимости ввода
			  gtk_WidgetSetFocus(nEntry_[nTmp])           // устанавливаем фокус
		    bEntry_[nTmp] = .F.                         // данные не введены
		    bReady_ := .F.                              // значит, не все данные готовы
			  qout(sEntry_[nTmp])      // выводим в статус бар подсказку о необходимости ввода
		ELSE
		    bEntry_[nTmp] = .T.                         // данные введены
		    IF nTmp = LEN(nEntry_)           // Enter на последнем поле ввода
			Check_Entry_()
		    ENDIF
		ENDIF
		EXIT
	    ENDIF
	 NEXT
*        IF .NOT. bReady_          // если не все данные готовы
*    	       qout('Check_Entry_')      // выводим в статус бар подсказку о необходимости ввода
	    Check_Entry_()
*        ENDIF
    ENDIF
ELSE
    FOR nTmp = 1 TO LEN(nEntry_)
       IF nWidg_ == nEntry_[nTmp]
	   EXIT
       ENDIF
    NEXT
    IF nTmp1 = GTK_LEAVE_NOTIFY
	qout('GTK_LEAVE_NOTIFY'+STR(nTmp1)+'/'+STR(nTmp))      // выводим в статус бар подсказку о необходимости ввода
    ELSEIF nTmp1 = GTK_ENTER_NOTIFY
	qout('GTK_ENTER_NOTIFY'+STR(nTmp1)+'/'+STR(nTmp))      // выводим в статус бар подсказку о необходимости ввода
    ELSEIF nTmp1 = GTK_FOCUS_OUT_EVENT
	qout('GTK_FOCUS_OUT_EVENT'+STR(nTmp1)+'/'+STR(nTmp))      // выводим в статус бар подсказку о необходимости ввода
    ELSEIF nTmp1 = GTK_FOCUS_CHANGE
	qout('GTK_FOCUS_CHANGE'+STR(nTmp1)+'/'+STR(nTmp))      // выводим в статус бар подсказку о необходимости ввода
    ELSE
	qout('Event'+STR(nTmp1)+'/'+STR(nTmp))      // выводим в статус бар подсказку о необходимости ввода
    ENDIF
ENDIF
RETURN .f.
