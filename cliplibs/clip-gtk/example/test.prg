#include <clip-gtk.ch>
#include <inkey.ch>

static hb, uTmp1 := 'no1', uTmp2 := 'no2', st, nEntry_ := {0,0}, bEntry_ := {.F.,.F.}, sEntry_ := {"Enter a access code","Enter a parol"}

function main()
	local w,  ;	// pointer to widget WINDOW (main application window)
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
// with this connection type input fields do not appear on the screen.
// Honestly I don't remember where I dug up an example.
// so the question is more theoretical - why not working?
// Re: the thing is that GTK_EVENT includes generally all events,
// every move the mouse, keystroke, repaint and other stuff.
// It's not entirely true to track this event. Your second choice is correct.
// And KEY_HANDLER () should return. t. || .f.. If returns NIL, it is
// believed that the return value is .t. and signal processing stopped,
// .f. - it means that the signal may processed, but has yet to execute
// a standard signal processing. Function KEY_HANDLER() should returns .f..
// Ie widget is created, he sent some signal to draw, but this signal
// not processed for any of the branch and this all - returns NIL and signal
// processing is stopped.  Widget as it exists, but can not draw.

// when such inclusion is OK but the first press of the arrow vnih causes a
// signal, but does not cause displacement of focus. Second pressing and all
// subsequent proceed normally
//	gtk_SignalConnect(nEntry_[1],"key-press-event", @KEY_HANDLER())
//	gtk_SignalConnect(nEntry_[1],"focus-out-event", @KEY_HANDLER())

// RE: Here the function works because only called when the widget receives a
// signal key-press-event or focus-out-event. These signals not processed
// in KEY_HANDLER.

// such inclusion is similar to the instructions on the unit type code:
// 	gtk_SignalConnect(w,"delete-event",{|wid,e|gtk_Quit()})
// where the parameters are passed to it the same meaning as in the block of
// code (in this case, wid, e)?

// RE: Yes, of course! Only specifically in this line
// gtk_SignalConnect(w,"delete-event",{|wid,e|gtk_Quit()})
// function doesn't apply to any particular widget.
// Simply stated - 'quit' and this all.

// is there any where in the source list of signals, their applicability to the
// objects and the list of parameters passed?"

// RE: Present. For any widget applicable signals and events described in
// widget.c At the beginning of the file is an array widget_signals here it is
// given and all available signals. For example,
//static SignalTable widget_signals[] =
//{
//       /* signals */
//       {"map",                 GSF( widget_signal_handler ),   ESF( object_emit
//       {"unmap",               GSF( widget_signal_handler ),   ESF( object_emit
//	.....
// that in quotes - the signal name.
// For each particular widget may or may not be in addition to the signals,
// described in widget_signals. If they are, they are described like this in
// the appropriate file.  For example, for the widget button, in file button.c
// is an array button_signals. With lists of parameters is more complicated.
// After the signal name, is the name of the handler. For the most part this
// is a widget_signal_handler() function, in this case the handler receives a
// widget, event, and any another option (if necessary). This option should
// only be one, but any type. If desired, you can pass a few parameters
// putting them into an array or map. If the name of the handler function is
// different then need to watch the source (because the set of parameters can
// be different, or something else).
// For example, for signal "size-allocate" will called handle_size_allocate_signal()
// handler which will be automatically generated third parameter for user
// defined function - map. It will contain 4 attributes: X, Y, WIDTH, HEIGHT.
// Ie user-defined function receives a widget, signal, and this third - map.
// See widget.c
// I understand that a little difficult, but it's true. Have to continually
// use the standard documentation for gtk.
// By the way, is documentation have a tree of inheritance or can it best be
// called widget inheritance properties hierarchy of their parents?

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
// Can I use this cycle to verify the occurrence of a signal on a widget ????????
// RE: don't understand: what signal and what it means to check the appearance 
// of the signal?

FOR nTmp = 1 TO LEN(nEntry_)
    IF nWidg_ == nEntry_[nTmp]
	    sTmp := gtk_EntryGetText(nEntry_[nTmp])
	    IF LEN(TRIM(sTmp)) = 0              // didn't enter data
		bEntry_[nTmp] = .F.             // didn't enter data
		  qout('fak '+ntoc(nTmp))       // show tooltip in the status bar about the need of input data
	    ELSE
		bEntry_[nTmp] = .T.             // data is entered
		  qout('OK '+ntoc(nTmp))        // show tooltip in the status bar about the need of input data
	    ENDIF
    ENDIF
NEXT
qout(';;;;OK ')      // show tooltip in the status bar about the need of input data
RETURN .T.

STATIC FUNCTION KEY_HANDLER(nWidg_, Event)
LOCAL sTmp, sTmp1 := 'Enter ', nTmp, ;
bReady_ := .T.		// the willingness of all input fields
// where to see a list of properties of each event ??????
// RE: In general, each event/signal always has an EVENT property - event/signal code,
// and the rest can be found in the file object.c in functions handle_events()
// and object_emit_event()
// see clip-gtk.ch for getting list of codes

nTmp1 = Event:event

IF nTmp1 = GTK_KEY_PRESS
    FOR nTmp = 1 TO LEN(nEntry_)
       IF nWidg_ == nEntry_[nTmp]
	   EXIT
       ENDIF
    NEXT
    qout('GTK_KEY_PRESS'+STR(nTmp1)+'/'+STR(nTmp))      // show tooltip in the status bar about the need of input data
    IF Event:keyval == K_ENTER
	FOR nTmp = 1 TO LEN(nEntry_)
	    IF nWidg_ == nEntry_[nTmp]
		sTmp := gtk_EntryGetText(nEntry_[nTmp])
		IF LEN(TRIM(sTmp)) = 0				// didn't enter data
			  gtk_StatusBarSetText(st,sEntry_[nTmp])      // show tooltip in the status bar about the need of input data
			  gtk_WidgetSetFocus(nEntry_[nTmp])           // set focus
		    bEntry_[nTmp] = .F.                         // didn't enter data
		    bReady_ := .F.                              // not all data is ready
			  qout(sEntry_[nTmp])      // show tooltip in the status bar about the need of input data
		ELSE
		    bEntry_[nTmp] = .T.                         // data was entered
		    IF nTmp = LEN(nEntry_)           // 'Enter' key was pressed on the last input field
			Check_Entry_()
		    ENDIF
		ENDIF
		EXIT
	    ENDIF
	 NEXT
*        IF .NOT. bReady_          // if not all data is ready
*    	       qout('Check_Entry_')      // show tooltip in the status bar about the need of input data
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
	qout('GTK_LEAVE_NOTIFY'+STR(nTmp1)+'/'+STR(nTmp))      // show tooltip in the status bar about the need of input data
    ELSEIF nTmp1 = GTK_ENTER_NOTIFY
	qout('GTK_ENTER_NOTIFY'+STR(nTmp1)+'/'+STR(nTmp))      // show tooltip in the status bar about the need of input data
    ELSEIF nTmp1 = GTK_FOCUS_OUT_EVENT
	qout('GTK_FOCUS_OUT_EVENT'+STR(nTmp1)+'/'+STR(nTmp))      // show tooltip in the status bar about the need of input data
    ELSEIF nTmp1 = GTK_FOCUS_CHANGE
	qout('GTK_FOCUS_CHANGE'+STR(nTmp1)+'/'+STR(nTmp))      // show tooltip in the status bar about the need of input data
    ELSE
	qout('Event'+STR(nTmp1)+'/'+STR(nTmp))      // show tooltip in the status bar about the need of input data
    ENDIF
ENDIF
RETURN .f.
