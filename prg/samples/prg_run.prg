#!../utils/clip_prg
/* This is a test of executable PRG-files */
/* Run this file as executable file  :)   */
parameters p1,p2
clear screen
m:={{"A","C",10,0},{"B","D",8,0}}
dbcreate('test',m)
use test
append blank
replace a with getenv("USER")
replace b with date()
browse()
return
