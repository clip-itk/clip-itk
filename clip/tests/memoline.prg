local i,j,x
local m:={;
	{"oneone    ","twotwo    ","three     "},;
	{"oneone     ","twotwo     ","three      "},;
	{"oneone      ","twotwo three","            "},;
	{"oneone twotwo","three        ","             "},;
	{"oneone twotwo ","three         ","              "},;
	{"oneone twotwo  ","three          ","               "};
	}
/*
? '"'+memoline("oneone twotwo three",11,1)+'"'
? '"'+memoline("oneone twotwo three",11,2)+'"'
? '"'+memoline("oneone twotwo three",11,3)+'"'
?
return
*/
//clear screen
for i=10 to 15
	for j=1 to 3
		x:= memoline("oneone twotwo three",i,j)
		? str(i,2,0),str(j,2,0)," CLIP:",'"'+x+'"',len(x)
		? "CLIPPER 5.x:",'"'+m[i-9][j]+'"'
	next
next
?
return
? mlcount("oneone twotwo three",10)
? '"'+memoline("oneone twotwo three",10,1)+'"'
? '"'+memoline("oneone twotwo three",10,2)+'"'
? '"'+memoline("oneone twotwo three",10,3)+'"'
?
? '"'+memoline("one two three four",10,1,,.t.)+'"'
? '"'+memoline("one two three four",10,2,,.t.)+'"'
? '"'+memoline("one two "+chr(10)+chr(13)+"three four",10,1,,.t.)+'"'
? '"'+memoline("one two "+chr(10)+chr(13)+"three four",10,2,,.t.)+'"'
? '"'+memoline("one two three four",10,1,,.f.)+'"'
? '"'+memoline("one two three four",10,2,,.f.)+'"'
? '"'+memoline("one two "+chr(10)+chr(13)+"three four",10,1,,.f.)+'"'
? '"'+memoline("one two "+chr(10)+chr(13)+"three four",10,2,,.f.)+'"'
?
return

