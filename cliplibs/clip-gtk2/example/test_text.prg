#include <clip-gtk2.ch>

function main()
local window, buffer, view, vbox, sw
	gtk_init()
	window = gtk_WindowNew(, " Test Text ")

	gtk_WindowSetDefaultSize(window, 500, 700)
        vbox := gtk_VboxNew()
        sw := gtk_ScrolledWindowNew()
        gtk_BoxPackStart(vbox, sw, .t., .t.)
        gtk_ContainerAdd(window, vbox)

        buffer = create_buffer()
	view := gtk_TextViewNewWithBuffer( , buffer:buffer )
	gtk_TextViewSetWrapMode (view, GTK_WRAP_WORD)
        gtk_ContainerSetBorderWidth(view, 10)
  	gtk_TextViewSetBorderWindowSize (view, GTK_TEXT_WINDOW_TOP, 15)

  	gtk_TextViewSetBorderWindowSize (view, GTK_TEXT_WINDOW_BOTTOM, 15)

  	gtk_SignalConnect (view, "expose_event",{|w, e|tab_stops_expose(w, e)} )

  	gtk_SignalConnect (view, "mark_set",{|w, e| cursor_set_callback(w, e, view)})


	gtk_ContainerAdd(sw, view)
	gtk_SignalConnect(window, "delete-event", {|| gtk_Quit()})
        gtk_WidgetShowAll(window)
        gtk_main()

return .t.

***************************************
#define N_COLORS	16
static function create_buffer()
local buffer, tabs, i
local tag

	buffer := map()
	buffer:buffer = gtk_TextBufferNew ()

	buffer:refcount = 1
	buffer:filename = NIL
	buffer:untitled_serial = -1

	buffer:color_tags = NIL
	buffer:color_cycle_timeout = 0
	buffer:start_hue = 0.0

	i = 0
  	do while (i < N_COLORS)

      		tag = gtk_TextBufferCreateTag (buffer:buffer)

    		//  buffer->color_tags = g_slist_prepend (buffer->color_tags, tag);

      		i++
	enddo
  	buffer:invisible_tag = gtk_TextBufferCreateTag (buffer:buffer, NIL, ;
                                                      "invisible", .t., NIL)

  	buffer:not_editable_tag = ;
    		gtk_TextBufferCreateTag (buffer:buffer, NIL, ;
                                "editable", .f., ;
                                "foreground", "purple", NIL)

  	buffer:found_text_tag = gtk_TextBufferCreateTag (buffer:buffer, NIL, ;
                                "foreground", "red", NIL)

  	/*
  	tabs = pango_tab_array_new_with_positions (4,
                                             TRUE,
                                             PANGO_TAB_LEFT, 10,
                                             PANGO_TAB_LEFT, 30,
                                             PANGO_TAB_LEFT, 60,
                                             PANGO_TAB_LEFT, 120);

  buffer->custom_tabs_tag = gtk_text_buffer_create_tag (buffer->buffer, NULL,
                                                        "tabs", tabs,
                                                        "foreground", "green", NULL);
  pango_tab_array_free (tabs);
	*/


return buffer
*************************************
static function tab_stops_expose (text_view, event, user_data)
local first_x, last_x, i,top_win, bottom_win, type
local target, positions, size, attrs, insert, buffer, in_pixels


  /* See if this expose is on the tab stop window */
  top_win = gtk_TextViewGetWindow (text_view, GTK_TEXT_WINDOW_TOP)

  bottom_win = gtk_TextViewGetWindow (text_view, GTK_TEXT_WINDOW_BOTTOM)

  if event:window:handle == top_win:handle
      type = GTK_TEXT_WINDOW_TOP
      target = top_win
  elseif event:window:handle == bottom_win:handle
      type = GTK_TEXT_WINDOW_BOTTOM
      target = bottom_win
  else
    return .f.
  endif

  first_x = event:area:x
  last_x = first_x + event:area:width

  gtk_TextViewWindowToBufferCoords (text_view, ;
                                         type, ;
                                         first_x, ;
                                         0,       ;
                                         &first_x,;
                                         NIL)

  gtk_TextViewWindowToBufferCoords (text_view,   ;
                                         type,    ;
                                         last_x,  ;
                                         0,       ;
                                         &last_x, ;
                                         NIL)

  buffer = gtk_TextViewGetBuffer (text_view)

  gtk_TextBufferGetIterAtMark (buffer, ;
                                    @insert,;
                                    gtk_TextBufferGetMark (buffer, ;
                                                              "insert"))

  attrs = gtk_TextAttributesNew ()

  gtk_TextIterGetAttributes (insert, attrs)

  /*
  if (attrs->tabs)
    {
      size = pango_tab_array_get_size (attrs->tabs);

      pango_tab_array_get_tabs (attrs->tabs,
                                NULL,
                                &positions);

      in_pixels = pango_tab_array_get_positions_in_pixels (attrs->tabs);
    }
  else
    {
    */
      size = 0
      in_pixels = .f.

  gtk_TextAttributesUnref (attrs)

  i = 0
  do while (i < size)

      if !in_pixels
        //positions[i] = PANGO_PIXELS (positions[i])
      endif

      gtk_TextViewBufferToWindowCoords (text_view,;
                                             type, ;
                                             positions[i],;
                                             0,            ;
                                             @pos,         ;
                                             NIL)

      gdk_DrawLine (target,;
                     widget:style:fg_gc [widget:state], ;
                     pos, 0, ;
                     pos, 15)

      ++i
    enddo


return .t.

