s:=memoread("attoken.txt")
s1:="\"+chr(126)+chr(13)
s1:=chr(10)
s1:=chr(13)+chr(10)
s1:=chr(126)
s1:=chr(126)+chr(13)+chr(10)
s1:=chr(126)+chr(13)
/*
num:=attoken(s,s1)
? "n ", num
?
return
*/
num:=attoken(s,s1)
num0:=attoken(s,s1,0)
num01:=attoken(s,s1,-1)
num1:=attoken(s,s1,1)
num2:=attoken(s,s1,2)
num3:=attoken(s,s1,3)
num4:=attoken(s,s1,4)
num5:=attoken(s,s1,5)
num6:=attoken(s,s1,6)
num7:=attoken(s,s1,7)
num8:=attoken(s,s1,8)
num9:=attoken(s,s1,9)
num10:=attoken(s,s1,10)
? "n-1", num01
? "n ", num
? "n0", num0
? "n1",num1, substr(s,1,num1)
? "n2",num2, substr(s,num1,num2-num1)
? "n3",num3, substr(s,num2,num3-num2)
? "n4",num4, substr(s,num3,num4-num3)
? "n5",num5, substr(s,num4,num5-num4)
? "n6",num6, substr(s,num5,num6-num5)
? "n7",num7, substr(s,num6,num7-num6)
? "n8",num8, substr(s,num7,num8-num7)
? "n9",num9, substr(s,num8,num9-num8)

?
return
