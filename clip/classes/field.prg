
******************************************************************
function TField()

	local obj 	:= map()
        obj:classname	:= "TFIELD"
        obj:new		:= @tfield_new()

return obj

******************************************************************
static function tfield_new(self, name, type, len, dec )

	self:cName:=iif(name==NIL,"",upper(name))
	self:cType:=iif(type==NIL,"C",upper(type))
	self:nLen :=iif(len==NIL,0,len)
	self:nDec :=iif(dec==NIL,0,dec)

	do case
      		case self:cType == 'L'
           		self:nLen:= 1
           		self:nDec:= 0
      		case self:cType == 'D'
           		self:nLen:= 8
           		self:nDec:= 0
      		case self:cType == 'M'
           		self:nLen:= 10
           		self:nDec:= 0
      		case self:cType == 'C'
           		self:nDec:= 0
   	endcase
return self
