/* Example loaddable module for COBrA server*/

function myDirectory(oConnect,oIni,oAnswer,p1,p2,p3,p4)
	outlog(__FILE__,__LINE__,oConnect)
	outlog(__FILE__,__LINE__,oIni)
	outlog(__FILE__,__LINE__,oAnswer)
	outlog(__FILE__,__LINE__,p1,p2,p3,p4)
	oAnswer:return := directory(p1,p2,p3,p4)
return
