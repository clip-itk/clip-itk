parameters command,oConnect,aParams,postdata

//outlog(__FILE__,__LINE__,command,oParams)
if command == "CACHE-ENABLED?"
	return .t. //.f.
elseif command == "LAST-UPDATED?"
	return dt_create(date()-1,time())
endif
//if command == "RUN"
	?? "Content-Type: text/plain"
	?
	? "mod-clip called:",command
	? "parameters:",aParams
	?
	//oConnect:sendAnswer("200 OK","","mod-clip called:"+command)
return .t. //"mod-clip called:"+command//.t.

