#include <clip-gtk.ch>
#include <inkey.ch>
	#define D_MSG(t)        qout(t)

static hb, uTmp1 := 'no1', uTmp2 := 'no2', st, nEntry_ := {0,0}, uEntry_ := {0,0}, bEntry_ := {.F.,.F.}, sEntry_ := {"Enter a access code","Enter a parol"}, ;
coun := 3

function main()
	local aTmp := {}, ;
	w,  ;	// указатель на виджет ОКНО (главное окно программы)
	f,  ;	//
	vb,  ;	//
	sw,  ;	//
	qbtn, en

DO WHILE .T.
	/* Initialize GTK+ system */
	gtk_init()

	/* Create main window */
	/***************************************************/
	w:= gtk_WindowNew(,"main application window")
	gtk_SignalConnect(w,"delete-event",{|wid,e|gtk_Quit()})

	/* Create vertical box container */
	vb:= gtk_VBoxNew()
	gtk_ContainerAdd (w, vb)

	// CList
	/***************************************************/
	D_MSG("Create frame for CList")
	CLFrame:=gtk_FrameNew(,"CList")
*	gtk_BoxPackStart(vb,CLFrame,.T.,.T.,2)
*	CLFx:=gtk_FixedNew()

	D_MSG("Scrolled window for clist")
	clscr:=gtk_ScrolledWindowNew()
	gtk_WidgetSetSize(clscr, 300, 400)
*	gtk_FixedPut(CLFx,clscr)
	gtk_ContainerAdd(CLFrame,clscr)
		gtk_BoxPackStart(vb,CLFrame,.T.,.T.,2)
// собственно, когда спрашивал об иерархии, то имел в виду необходимость
// тех или иных "промежуточных слоев" для вывода графической информации.
// в данном примере, взятом из clipgtktest, выкинул все отмеченное выше
// звездочкой и прога не рухнула. я на глаз не заметил изменений в ее
// поведении.

//RE: Слои - отдаются ра рассмотрение программера. Все зависит от того, в каком
//виде или порядке хотите увидеть те или иные виджеты. вертикально, горизонтально
//строго в указанной точке ... Вот исходя из конечного вида и надо пользоваться
//разными контейнерами.

// второй вопрос в том, что при таком построении не срабатывает автоматическое
// определенние размера окна, содержащего Clist. без выкидывания закоментареных
// фрагментов окно для clist было вообще маленьким. в таком варианте прога
// определила горизонтальный размер, как мне кажется, по размеру кнопок. а
// по вертикали выделила место только на одну строку. толи я еще не все лишнее
// удалил:), толи прога дура-программер молодец, толи есть еще неизвестный мне
// метод или свойство ?

//RE: Тут, как мне кажется, программа определила ширину по одному единственному
//виджету, имеющему конкретный размер. Это statusBar Все остальные виджеты -
//контейнеры, размер которых плавает и зависит от того, что у них внутри. И так как
//размер окна не задан, то и прога установила минимальный с ее точки зрения. Для
//каждого виджета выделив высоты столько, сколько необходимо для минимальной
//информативности. Если хотите, чтобы этот пример показывал весь list, то можно или
//убрать промежуточное окно scrolledwindow или задать размер основному окну w или
//скроллируемому окну clscr.

	D_MSG("Create clist widget")
	clist:= gtk_CListNew(,3,{"Column1","Column2","Column3"})
	gtk_ContainerAdd (clscr, clist)
	//gtk_BoxPackStart(vb, clist, .t., .t.,2)
	gtk_CListColumnTitlesShow(clist)
	gtk_CListSetReorderable(clist, .t.)
	gtk_CListSetUseDragIcons(clist, .t.)
	gtk_CListSetSelectionMode(clist, GTK_SELECTION_EXTENDED)

	gtk_CListSetColumnTitle(clist,1,"Column1")
	gtk_CListSetColumnTitle(clist,2,"Column2")
	gtk_CListSetColumnTitle(clist,3,"Column3")

	gtk_CListSetColumnAutoResize(clist,2,.t.)
  FOR nTmp = 1 TO 10
	gtk_ClistAppend(clist,{'field 1 string '+ntoc(nTmp),'field 2 string '+ntoc(nTmp),'field 3 string '+ntoc(nTmp)})
  NEXT

	hb2 := gtk_HBoxNew()
	gtk_BoxPackStart(vb,hb2,.T.,.T.,2)

	bn2 :=gtk_ButtonNew(,"Cancel")
	gtk_SignalConnect(bn2,GTK_CLICKED_SIGNAL,{||gtk_Quit()})
	gtk_BoxPackStart(hb2,bn2,.T.,.T.,2)

	st := gtk_StatusBarNew()
	gtk_BoxPackEnd(vb,st,.F.,.F.)
	gtk_StatusBarSetText(st,"Enter a access code and parol")

	/* Show main window */
	/***************************************************/
	gtk_WidgetShowAll( w )

	/* Do GTK+ events */
	gtk_main()
  EXIT
ENDDO
return
