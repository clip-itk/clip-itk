#include <inkey.ch>
static app
local btn, fn, calendar, statb
app := cti_init()
app:show()

app:signal_connect(HASH_CTI_DELETE_SIGNAL, {|w| w:hide()})
app:signal_connect(HASH_CTI_HIDE_SIGNAL, {|w| cti_quit()})
app:set_key(K_ALT_X, @__ex())

statb := cti_statusbar_new()
statb:show()
statb:set_size(1,app:width)
statb:set_position(app:height-1,0)
statb:set_message("Alt+X-exit Ctrl+T-take message Ctrl+L-list message PgUp/PgDn-month Ctrl+Y/U-year")

app:add(statb)

btn :=cti_pushbutton_new("Browse")
btn:show()
btn:set_position(5,5)
fn := ""
btn:signal_connect(HASH_CTI_CLICKED_SIGNAL, {|w, e, _app| fn:=cGetFile(_app), cti_quit()}, app)
app:add(btn)
//app:set_focus(btn)

calendar := cti_calendar_new()
calendar:show()
calendar:set_reminder_list(.t.)
calendar:center()
app:add(calendar)
calendar:set_focus_child()
calendar:signal_connect(HASH_DAY_SELECTED_SIGNAL, {|w| outlog('run signal day_selected'),local(d), d:=w:get_date(), outlog('day=', d), cti_quit(), qout(d)})
//fn:=cGetFile(app)


cti_main()
? "filename=", fn
?
return

static function __ex()
	app:signal_emit(HASH_CTI_DELETE_SIGNAL)
return

function cGetFile(app)
local filename, fd

fileName := ""
fd := cti_filedialog_new(,"*", "File Dialog")
fd:show()
fd:signal_connect(HASH_CTI_HIDE_SIGNAL, {|w, e| w:destroy(), cti_quit()})
//fd:signal_connect(HASH_CTI_HIDE_SIGNAL, {|w, e|})
fd:okButton:signal_connect(HASH_CTI_CLICKED_SIGNAL, {|w, ev, fd| fileName := fd:retFile, fd:hide()}, fd)
fd:cancelButton:signal_connect(HASH_CTI_CLICKED_SIGNAL, {|w, ev, fd| fd:hide()}, fd)

app:add(fd)
cti_main()
return filename
