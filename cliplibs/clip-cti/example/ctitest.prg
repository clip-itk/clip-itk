#include "inkey.ch"

#include "../include/ctiwindow.ch"

procedure main()
	public app
	public menu

	local win, win2, win3
	local en, en2, en3, en4, en5
	local but, but2, qbut
	local statb
	local lbl1, lbl2
	local sigid, evid
	local check1
	local grp,rb1,rb2,rb3,rb4
	local lst //list
	local opm, opm_menu, item

	public br
        local col


	app:=cti_init()

	win := cti_window_new(" CTI Test window 1 ")
	win:set_position(5,5)
	win:set_size(12,40)
	win:show()

	cti_event_connect("CTI_KEYBOARD_EVENT",@KeybHandler())

	win2:=cti_window_new(" CTI Test window 2 ")
	win2:set_position(7,20)
	win2:set_size(17,50)
	win2:show()

	win3:=cti_window_new(" CTI Test window 3 ")
	win3:set_position(3,15)
	win3:set_size(10,50)
	win3:show()

	app:put(win)
	app:put(win2)
	app:put(win3)

	app:set_focus(win)

	en := cti_entry_new("N","999.999")
	en:set_size(1,7)
	en:show()
	win:put(en,2,20)
	en:set_value(10.05)
	lbl1 := cti_label_new("Input number:")
	lbl1:set_size(1,13)
	lbl1:show()
	win:put(lbl1,2,5)

	en2 := cti_entry_new("C","@S10")
	win:put(en2,4,5)
	en2:show()
	en2:set_value("Text entry Text entry Text entry Text entry ")

	en3 := cti_entry_new("L")
	win:put(en3,6,5)
	en3:show()
	en3:set_value(.T.)

	but := cti_pushbutton_new("Button 1")
	win:put(but,8,8)
	but:show()
	but:signal_connect("CTI_CLICKED_SIGNAL",{|_but,_sig,_ar|_ar[1]:set_focus(_ar[2])},{win,en2})

	but2 := cti_pushbutton_new("Button 2")
	win:put(but2,8,20)
	but2:show()
	but2:signal_connect("CTI_CLICKED_SIGNAL",{|_but,_sig,_app|_app:focus_next_window()},app)

	qbut := cti_pushbutton_new("Quit")
	win:put(qbut,8,32)
	qbut:show()
	qbut:signal_connect("CTI_CLICKED_SIGNAL",{||cti_quit()})

	check1 := cti_checkbox_new(" checkbox")
	check1:show()
	win:put(check1,4,20)

	menu := CreateMenu()
	menu:set_size(1,50)

	menu:show()
	app:put(menu)
//	win:put(menu)

	en4 := cti_entry_new("C","@S20")
	win2:put(en4,1,2)
	en4:show()
	en4:set_value("Input text")

	en5 := cti_entry_new("C","@S20")
	win:put(en5,6,10)
	en5:set_enabled(.F.)
	en5:set_size(1,16)
	en5:show()
	en5:set_value("Disabled control")

	br := cti_tbrowse_new()
	br:set_size(8,45)
	br:set_position(3,2)
	br:show()
	br:set_shadow(.F.)
	br:set_skip_block(@Skipper())
	win2:put(br)

	use test
	col := TBColumnNew("First",{||test->first})
	col:width := 10
	br:add_column(col)
	br:add_column("Last",{||test->last})
	br:add_column("Street",{||test->street})
	br:add_column("City",{||test->city})
	br:add_column("State",{||test->state})
	br:add_column("Zip",{||test->Zip})
	br:add_column("Hiredate",{||test->Hiredate})
	br:add_column("Married",{||test->Married})
	br:add_column("Age",{||test->Age})
	br:add_column("Salary",{||test->Salary})
	br:add_column("Notes",{||test->Notes})

	statb := cti_statusbar_new()
	statb:show()
	statb:set_size(1,app:width)
	statb:set_position(app:height-1,0)
	statb:set_message("Alt+X-exit   F6-switch window   Esc-menu Tab-next control")
	app:put(statb)

	grp := cti_radiogroup_new()
	rb1 := cti_radiobutton_new(" Radio button 1",grp); rb1:show()
	rb2 := cti_radiobutton_new(" Radio button 2",grp); rb2:show()
	rb3 := cti_radiobutton_new(" Radio button 3",grp); rb3:show()
	rb4 := cti_radiobutton_new(" Radio button 4",grp); rb4:show()

	win2:put(rb1,12,2)
	win2:put(rb2,13,2)
	win2:put(rb3,14,2)
	win2:put(rb4,15,2)

	lst := cti_list_new(3)
	lst:show()
	lst:set_size(7,40)
	win3:put(lst,2,3)

	lst:column_titles_show(.T.)
	lst:set_column_title(1,"Column1")
	lst:set_column_width(1,10)

	lst:set_column_title(2,"Column2")
	lst:set_column_width(2,20)

	lst:set_column_title(3,"Column3")
	lst:set_column_width(3,15)

	lst:append({"1","2","3"})
	lst:prepend({"4","5","6"})
	lst:insert({"7","8","9"},2)
	lst:append({"11","12","13"})
	lst:append({"21","22","23"})
	lst:append({"31","32","33"})
	lst:append({"41","42","43"})
	lst:append({"51","52","53"})
	lst:append({"61","62","63"})
	lst:append({"71","72","73"})
	lst:append({"81","82","83"})

//	lst:set_row_selectable(4,.F.)
//	lst:set_row_selectable(1,.F.)

	opm := cti_option_menu_new()
	opm:show()
	opm:set_size(1,20)
	win2:put(opm,12,23)

	opm_menu := opm:get_menu()
	item := cti_menuitem_new("Option 1")
	item:show()
	opm_menu:add_item(item)
	item := cti_menuitem_new("Option 2")
	item:show()
	opm_menu:add_item(item)
	item := cti_menuitem_new("Option 3")
	item:show()
	opm_menu:add_item(item)
	opm_menu:show()

	cti_main()
	close

//outlog(__FILE__,__LINE__,procname(),en:get_value())

return

static function CreateMenu()
	local menubar
	local item1,item2,item3
	local submenu1,submenu2, submenu3
	local item11, item12, item13, item14
	local item21, item22, item23, item24
	local item31, item32, item33

	menubar := cti_menubar_new()
	menubar:set_position(0,0)

	item1 := cti_menuitem_new(" Item 1 ")
	item1:show()
	item2 := cti_menuitem_new(" Item 2 ")
	item2:show()
	item3 := cti_menuitem_new(" Item 3 ")
        item3:show()

	submenu1 := cti_menu_new()
	submenu1:show()
	submenu1:set_name("submenu1")
	item11 := cti_menuitem_new("Item 11")
	item11:show()
	item12 := cti_menuitem_new("Item 12")
	item12:show()
	item13 := cti_menuitem_new()
        item13:show()
	item14 := cti_menuitem_new("Quit")
        item14:show()
	item14:signal_connect("CTI_ACTIVATE_SIGNAL",{|_item,_sig|cti_quit()})
	submenu1:add_item(item11)
	submenu1:add_item(item12)
	submenu1:add_item(item13)
	submenu1:add_item(item14)
	item1:set_submenu(submenu1)

	submenu2 := cti_menu_new()
	submenu2:show()
	submenu2:set_name("submenu2")
	item21 := cti_menuitem_new("Item 21")
	item21:show()
	item22 := cti_menuitem_new("Item 22")
	item22:show()
	item23 := cti_menuitem_new()
        item23:show()
	item24 := cti_menuitem_new("Item 24")
        item24:show()
	submenu2:add_item(item21)
	submenu2:add_item(item22)
	submenu2:add_item(item23)
	submenu2:add_item(item24)
	item2:set_submenu(submenu2)

	submenu3 := cti_menu_new()
	submenu3:show()
	submenu3:set_name("submenu3")
	item31 := cti_menuitem_new("Item 31")
	item31:show()
	item32 := cti_menuitem_new("Item 32")
	item32:show()
	item33 := cti_menuitem_new("Item 33")
        item33:show()
	item33:set_checked(.T.)
	item33:signal_connect("CTI_ACTIVATE_SIGNAL",{|_item,_sig|_item:set_checked(.not. _item:is_checked())})
	submenu3:add_item(item31)
	submenu3:add_item(item32)
	submenu3:add_item(item33)
	item22:set_submenu(submenu3)

	menubar:add_item(item1)
	menubar:add_item(item2)
	menubar:add_item(item3)
return menubar

static function KeybHandler(win,event)
	memvar app, menu, br
	static focus, lMenuFocused

	switch (event:keycode)

/*
		case K_UP
			if CTI_IS_WINDOW(win)
				win:set_position(win:top-1,win:left)
			endif
		case K_DOWN
			if CTI_IS_WINDOW(win)
				win:set_position(win:top+1,win:left)
			endif
		case K_LEFT
			if CTI_IS_WINDOW(win)
				win:set_position(win:top,win:left-1)
			endif
		case K_RIGHT
			if CTI_IS_WINDOW(win)
				win:set_position(win:top,win:left+1)
			endif
*/
		case K_ESC
			if menu:__is_focused
				app:set_focus(focus)
			else
				focus := app:__FocusedObj
				app:set_focus(menu)
			endif
//		case 113
		case K_ALT_D
			br:set_enabled(.not. br:is_enabled())
                case K_ALT_X
			cti_quit()
		case K_F6
			app:focus_next_window()
		case K_CTRL_F4, K_F4
			if win!=nil
				win:hide()
				win:destroy()
			endif
	end
return

static function MoveWindow(win,sigtype,keycode)
	switch (keycode)
		case K_UP
			win:set_position(win:top-1,win:left)
		case K_DOWN
			win:set_position(win:top+1,win:left)
		case K_LEFT
			win:set_position(win:top,win:left-1)
		case K_RIGHT
			win:set_position(win:top,win:left+1)
	end
return


static function Skipper(n, browse)
    LOCAL lAppend:=.f.
    LOCAL i:=0
//    lAppend := IS_APPEND_MODE(browse)           // see #defines at top

//	sleep(0.05)

    IF n == 0 .OR. RECCOUNT() == 0
	SKIP 0
    ELSEIF n > 0 .and. RECNO() != RECCOUNT() + 1
	DO WHILE i < n
	    SKIP 1
	    IF ( EOF() )
		IF ( lAppend )
		    i++
		ELSE
		    SKIP -1
		ENDIF
		EXIT
	    ENDIF
	    i++
	ENDDO
    ELSEIF n < 0
	DO WHILE i > n
	    SKIP -1
	    IF ( BOF() )
		EXIT
	    ENDIF
	    i--
	ENDDO
    ENDIF
RETURN i


