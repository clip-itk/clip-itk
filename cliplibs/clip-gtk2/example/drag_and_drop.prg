#include <clip-gtk2.ch>

#define TARGET_STRING	0
#define TARGET_ROOTWIN	1
#define TRUE		.T.
#define FALSE		.F.

static have_drag := FALSE


static target_table := { ;
  { "STRING", 0, 1 }, ;
  { "text/plain", 0, TARGET_STRING },  ;
  { "application/x-rootwin-drop", 0, TARGET_ROOTWIN }}

static n_targets := len(target_table)

function main ()

local  window, table, label, button, layout, frame, f1
local drag_icon, drag_mask


  gtk_init ()

  window = gtk_WindowNew (, " Test drag and drop functions ",GTK_WINDOW_TOPLEVEL)
  gtk_SignalConnect (window, "delete-event", {|| gtk_Quit()})

  ebox := gtk_EventBoxNew()
  layout := gtk_LayoutNew()
  //gtk_WIdgetSetSizeRequest(layout, 800, 600)
  gtk_WIdgetSetSizeRequest(layout, 400, 400)
  //gtk_ContainerAdd (window, layout)
  gtk_ContainerAdd (window, ebox)
  gtk_ContainerAdd (ebox, layout)

  frame := gtk_FrameNew(, " Frame 1")
  gtk_WidgetSetEvents(frame, GDK_BUTTON_PRESS_MASK)
  //gtk_WidgetSetState(frame, GTK_STATE_PRELIGHT)
  gtk_LayoutPut(layout, frame, 10, 10)
  f1 := gtk_FixedNew()
  gtk_WidgetSetSizeRequest(f1, 300, 100)
  gtk_ContainerAdd(frame, f1)

  label := gtk_LabelNew(, "Enter Your Name ")
  gtk_FixedPut(f1, label, 10, 10)
  entry := gtk_EntryNew()
  gtk_FixedPut(f1, entry, 10, 40)
  button := gtk_ButtonNewWithMnemonic(,"_Press me!" )
  gtk_FixedPut(f1, button, 10, 70)

  gtk_DragSourceSet (frame, numor(GDK_BUTTON1_MASK , GDK_BUTTON3_MASK), ;
  		       target_table, n_targets, ;
  		       numor(GDK_ACTION_COPY, GDK_ACTION_MOVE))
  gtk_DragSourceSet (label, numor(GDK_BUTTON1_MASK , GDK_BUTTON3_MASK), ;
  		       target_table, n_targets, ;
  		       numor(GDK_ACTION_COPY, GDK_ACTION_MOVE))
  drag_icon = gdk_PixmapColormapCreateFromXpm(NIL, ;
					      gtk_WidgetGetColormap (window), ;
					      @drag_mask, ;
					      NIL, "drag_icon.xpm")
  gtk_DragSourceSetIcon (frame, gtk_WidgetGetColormap (window), ;
			    drag_icon, drag_mask)

  gtk_SignalConnect (frame, "drag-data-get", {|w, e|  source_drag_data_get(w, e)})
/*

  label = gtk_LabelNew (, "Drop Here&\n")


  gtk_DragDestSet (label, ;
		     GTK_DEST_DEFAULT_ALL, ;
		     target_table, n_targets - 1, /* no rootwin */ ;
		     numor(GDK_ACTION_COPY , GDK_ACTION_MOVE))

  gtk_SignalConnect( label, "drag-data-received", {|w, e| label_drag_data_received(w, e)})

  gtk_TableAttach (table, label, 1, 2, 1, 2, ;
		    numor(GTK_EXPAND , GTK_FILL), numor(GTK_EXPAND , GTK_FILL), ;
		    1, 1)

  label = gtk_LabelNew (, "Popup&\n")

  gtk_DragDestSet (label, ;
		     GTK_DEST_DEFAULT_ALL, ;
		     target_table, n_targets - 1, /* no rootwin */ ;
		     numor(GDK_ACTION_COPY , GDK_ACTION_MOVE))

  gtk_TableAttach (table, label, 2, 3, 2, 3, ;
		    numor(GTK_EXPAND , GTK_FILL), numor(GTK_EXPAND , GTK_FILL), ;
		    1, 1)

  ? "drag-motion to label", gtk_SignalConnect (label, "drag-motion",{|w, e| popsite_motion(w, e)})
  ? "drag-leave to label", gtk_SignalConnect (label, "drag-leave", {|w, e| popsite_leave(w, e)})

  pixmap = gtk_PixmapNew (,trashcan_closed, trashcan_closed_mask)
  gtk_DragDestSet (pixmap, 0, NIL, 0, 0)
  gtk_TableAttach (table, pixmap, 2, 3, 1, 2, ;
		    numor(GTK_EXPAND , GTK_FILL), numor(GTK_EXPAND , GTK_FILL), ;
		    1, 1)

  ? "drag-leave to pixmap", gtk_SignalConnect (pixmap, "drag-leave", {|w, e| target_drag_leave(w, e)})

  ? "drag-motion to pixmap", gtk_SignalConnect (pixmap, "drag-motion", {|w, e| target_drag_motion(w,e)})

  ? "drag-drop to pixmap", gtk_SignalConnect (pixmap, "drag-drop", {|w, e| target_drag_drop(w, e)})

  ? "drag-data-received to pixmap", gtk_SignalConnect (pixmap, "drag-data-received", {|w, e|  target_drag_data_received(w, e)})

  /* Drag site */

  button = gtk_ButtonNew (, "Drag Here&\n")

  gtk_DragSourceSet (button, numor(GDK_BUTTON1_MASK , GDK_BUTTON3_MASK), ;
		       target_table, n_targets, ;
		       numor(GDK_ACTION_COPY, GDK_ACTION_MOVE))

  gtk_DragSourceSetIcon (button, gtk_WidgetGetColormap (window), ;
			    drag_icon, drag_mask)

  gtk_TableAttach (table, button, 1, 2, 2, 3, ;
		    numor(GTK_EXPAND , GTK_FILL), numor(GTK_EXPAND , GTK_FILL), ;
		    1, 1)

  gtk_SignalConnect (button, "drag-data-get", {|w, e|  source_drag_data_get(w, e)})
  gtk_SignalConnect (button, "drag-data-delete", {|w,e |  source_drag_data_delete(w,e)})
*/
  gtk_WidgetShowAll (window)

  gtk_main ()

return 0



static function target_drag_leave(widget, event)
  qout("leave&\n")
  have_drag = FALSE
  gtk_PixmapSet (widget, trashcan_closed, trashcan_closed_mask)
return FALSE

static function target_drag_motion(widget, event)//context, x, y, time)

local source_widget
local tmp_list

	qout("target_drag_motion")
  	if !have_drag
      		have_drag = TRUE
      		gtk_PixmapSet (widget, trashcan_open, trashcan_open_mask)
  	endif

  	source_widget = gtk_DragGetSourceWidget (event:DRAGCONTEXT)
  	qout ("motion, source ",  GTK_WIDGETGETTYPENAME (source_widget) )

  /*	tmp_list = context->targets;
  while (tmp_list)
    {
      char *name = gdk_atom_name (GDK_POINTER_TO_ATOM (tmp_list->data));
      g_print ("%s\n", name);
      g_free (name);

      tmp_list = tmp_list->next;
    }
    */
	gdk_DragStatus (event:DRAGCONTEXT, event:DRAGCONTEXT:SUGGESTED_ACTION, ;
		event:TIME)

return TRUE

static function target_drag_drop(widget, event)//context, x, y, time)
  	qout("drop")
  	have_drag = FALSE

  	gtk_PixmapSet (widget, trashcan_closed, trashcan_closed_mask)

  	if (event:DRAGCONTEXT:TARGETS != NIL)
      		gtk_DragGetData (widget, event:DRAGCONTEXT, ;
			 event:DRAGCONTEXT:TARGETS, ;
			 event:TIME)
      		return TRUE
  	endif

  return FALSE

static function target_drag_data_received(widget, event)//context, x, y, data, info, time)
local data
	data := event:SELECTIONDATA

	qout("target_drag_data_received")

  	if data:length >= 0 .and.  data:format == 8
      		qout("Received "+data:data+" in trashcan")
      		gtk_DragFinish(event:DRAGCONTEXT, TRUE, FALSE, event:TIME)
      		return
    	endif

  	gtk_DragFinish (event:DRAGCONTEXT, FALSE, FALSE, time)
return

static function label_drag_data_received  (widget, event)
local data
	data := event:SELECTIONDATA
	qout("label_drag_data_received")

  	if data:LENGTH >= 0 .and. data:FORMAT == 8
      		qout("Received "+data:DATA+" in label")
      		gtk_DragFinish (event:DRAGCONTEXT, TRUE, FALSE, event:TIME)
      		return
    	endif

  	gtk_DragFinish (event:DRAGCONTEXT, FALSE, FALSE, time)
return

static function source_drag_data_get  (widget, event)
	qout("source_drag_data_get")

  	if event:INFO == TARGET_ROOTWIN
    		qout("I was dropped on the rootwin")
  	else
    		gtk_SelectionDataSet (event:SELECTIONDATA, ;
			    event:SELECTIONDATA:TARGET, ;
			    8, "I'm Data!", 9)
	endif
return

/* The following is a rather elaborate example demonstrating/testing
 * changing of the window heirarchy during a drag - in this case,
 * via a "spring-loaded" popup window.
 */

static function popdown_cb (data)
qout("popdown_cb")

  popdown_timer = 0

  gtk_WidgetHide (popup_window)
  popped_up = FALSE


return FALSE


static function popup_motion(widget, event)//context, x, y, time)
qout("popup_motion")

  	if !in_popup
      		in_popup = TRUE
      		if (popdown_timer > 0)
	  		qout ("removed popdown")
	  		gtk_TimeoutRemove (popdown_timer)
	  		popdown_timer = 0
		endif
    	endif
return TRUE

static function popup_leave(widget,context,time)
qout("popup_leave")
  	if in_popup
      		in_popup = FALSE
      		if popdown_timer < 1
	  		qout ("added popdown")
	  		popdown_timer = gtk_TimeoutAdd (500, {|| popdown_cb()})
		endif
    	endif
return

static function popup_cb (data)
local button, table, i, j, buffer
	qout("popup_cb")
  	if !popped_up
      		if popup_window == NIL

	  		popup_window = gtk_WindowNew (,NIL,GTK_WINDOW_POPUP)
	  		gtk_WindowSetPosition (popup_window, GTK_WIN_POS_MOUSE)

	  		table = gtk_TableNew (,3,3, FALSE)

	  		for i=1 to 3
	    			for j=1 to 3
					buffer := str(i,1,0)+","+str(j,1,0)
					button = gtk_ButtonNew(,buffer)

					gtk_TableAttach (table, button, i, i+1, j, j+1, ;
				  	numor(GTK_EXPAND, GTK_FILL), numor(GTK_EXPAND, GTK_FILL), ;
				  	1, 1)

					gtk_DragDestSet (button, ;
				   		GTK_DEST_DEFAULT_ALL, ;
				   		target_table, n_targets - 1, ;/* no rootwin */
				   		numor(GDK_ACTION_COPY, GDK_ACTION_MOVE))
					gtk_SignalConnect (button, "drag-motion", ;
				    		{|w, e| popup_motion(w,e)})
					gtk_SignalConnect (button, "drag-leave", ;
				    		{|w, e| popup_leave(w,e)})

	      			next
              		next

	  		gtk_WidgetShowAll (table)
	  		gtk_ContainerAdd (popup_window, table)

		endif
      		gtk_WidgetShow (popup_window)
      		popped_up = TRUE
    	endif

  	popdown_timer = gtk_TimeoutAdd (500, {|| popdown_cb()})
  	qout ("added popdown")

  	popup_timer = 0

return FALSE

static function popsite_motion(widget,context,x,y,time)
qout("popsite_motion")
  	if popup_timer < 1
    		popup_timer = gtk_TimeoutAdd (500, {|| popup_cb()})
    	endif
return TRUE

static function popsite_leave(widget,context,time)
qout("popsite_leave")
  	if popup_timer > 0
      		gtk_TimeoutRemove (popup_timer)
      		popup_timer = 0
    	endif
return


static function source_drag_data_delete  (widget,context,data)

  qout("Delete the data!")
return



