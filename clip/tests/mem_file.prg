set("DBF_CHARSET", "ALT")
private my_firma:=""
public my_bank:=""
restore from my.mem additive
? 'my_firma=', my_firma
? 'my_bank=', my_bank
?
? 'save to my2.mem'
save all like my_* to my2.mem
? 'now:'
my_firma:="XXXXXXXXXXXXXXX"
my_bank:="YYYYYYYYYYYYYYY"
? 'my_firma=',my_firma
? 'my_bank=',my_bank
restore from my2.mem additive
? 'restored from my2.mem:'
? 'my_firma=',my_firma
? 'my_bank=',my_bank
?
return
