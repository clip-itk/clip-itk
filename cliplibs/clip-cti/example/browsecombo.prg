#include "inkey.ch"
#include "cti.ch"

static bcmb

procedure main()
	local app, win, l, qbut
	local br, col

	app:=cti_init()

	win := cti_window_new(" CTI TBrowseCombo test ",5,5,6,20)
	win:set_position(5,5)
	win:set_size(12,40)

	cti_event_connect("CTI_KEYBOARD_EVENT",@KeybHandler())

	l := cti_layout_new()
	win:add(l)

	app:add(win)

	bcmb := cti_browse_combo_new()
	bcmb:set_size(1,15)
	l:add(bcmb,2,2)

	qbut := cti_pushbutton_new("Quit")
	l:add(qbut,4,2)
	qbut:signal_connect("CTI_CLICKED_SIGNAL",{||cti_quit()})

	br := bcmb:get_tbrowse()
//	br := cti_tbrowse_new()
//	br:set_size(10,30)

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
	br:set_skip_block(@Skipper())

	bcmb:follow_tbrowse()
	bcmb:set_select_block({||test->First})

	bcmb:follow_entry()
	bcmb:set_change_block(@Search())

	bcmb:set_value_in_list()
	bcmb:set_value_block({||test->First})

	win:show_all()

	cti_main()
	close


return

static function Search(bcmb,val)
	if empty(val); return FALSE; endif

	LOCATE FOR upper(alltrim(val)) $ upper(test->First)
	if !found()
		GO TOP
		return FALSE
	endif
return TRUE

static function KeybHandler(win,event)
	switch (event:keycode)
		case K_ALT_X
			cti_quit()

		case K_F1
			bcmb:open()

		case K_F2
			bcmb:close()
	end
return

static function Skipper(n, browse)
    LOCAL lAppend:=.f.
    LOCAL i:=0

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


