parameters prog

? 'prog=', prog
? 'dbgconnect', dbgconnect(prog)
?

while .t.
	accept "dbg "+prog+" > " to cmd
	? dbgcommand(cmd)
	/*sleep(0.1)*/
	? 'frame:', dbgcommand("f")
	?
end
