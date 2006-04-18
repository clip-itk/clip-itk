#include <clip-expat.ch>

function main()
local parser, aa


if pcount() == 0
	? "Call test <filename.xml>"

	return
endif


filename = param(1)
if empty(filename)
	filename = "component.xml"
endif
tm := seconds()

parser = xml_ParserCreate()

? "parser:",parser

aa = 0
xml_SetUserData(parser, @aa)

xml_SetParamEntityParsing(parser, XML_PARAM_ENTITY_PARSING_NEVER)

xml_SetCharacterDataHandler(parser, @myfunc())
//xml_SetStartElementHandler(parser, @myStartElement())
//xml_SetEndElementHandler(parser, @myEndElement())
xml_SetElementHandler(parser, @myStartElement(), @myEndElement())
xml_SetCommentHandler(parser, @myComment())
xml_SetCdataSectionHandler(parser, @myStartCdata(), @myEndCdata())

file = fopen(filename)
do while !fileeof(file)
	buf = filegetstr(file, 1024)
    //? "buf=", buf
    xml_Parse(parser, buf, len(buf), fileeof(file))

    if xml_GetErrorCode(parser) <> 0
	? "Error in XML (" + alltrim(str(xml_GetErrorCode(parser))) + "): " + xml_ErrorString(parser)
	?? " at line "+alltrim(str(xml_GetCurrentLineNumber(parser)))
	?? ", column "+alltrim(str(xml_GetCurrentColumnNumber(parser)))
    endif
enddo
//? "end parse line",xml_GetCurrentLineNumber(parser)

fclose(file)


xml_ParserFree(parser)
? ""
? "free"
? "Processed time:", seconds()-tm, "sec"

?
return


function myfunc(aa, str, len)
	?  replicate("&\t", aa), '"'+str+'"'
return

function myStartElement(aa, name, arrAttr)
	? replicate("&\t", aa),"<"+name+">"
	for i=1 to len(arrAttr)
		? replicate("&\t", aa+1), arrAttr[i]
    next
	aa++
return

function myEndElement(aa, name)
    aa--
	? replicate("&\t", aa),"</"+ name+">"
return

function myComment(aa, data)
	? replicate("&\t", aa),"/* "+ data+ "*/"
return

function myStartCdata(aa)
	? replicate("&\t", aa),"<![CDATA["
    aa++
return

function myEndCdata(aa)
    aa--
	? replicate("&\t", aa),"]]>"
return


