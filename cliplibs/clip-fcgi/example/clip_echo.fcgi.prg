#include "fcgi.ch"
local count:=0

while FCGI_ACCEPT()

?? "Content-type: text/html"
?
? '<html><head>'
? '<title>Clip FastCGI</title>'
? '</head><body>'

? "<h1>Clip FastCGI echo</h1>"
? "Request number ", count
? '<p>'
? getenv('USER')
? getenv('QUERY_STRING')
? getenv('HOME')
//? getenv()
? '</body></html>'
?
count++

end

? 'asdf'
?
