
? 'bzip2ped file write/read test: file asdf.bz2'
? h:=bzip2Open("asdf.bz2", "wb")

msg:='Hello, World!'
? bzip2Write(h, msg)
? bzip2Close(h)

? h:=bzip2Open("asdf.bz2", "rb")
msg1:=space(100)
? bzip2Read(h, @msg1)
? bzip2Close(h)

? 'before:', msg
? 'after:', msg1
?
? 'bzip2/bunzip2 string test'
? 'msg:', msg
? 'msg1:=bzip2(msg):', msg1:=bzip2(msg)
? 'bunzip2(msg1):', bunzip2(msg1)
?
