
? 'gzipped file write/read test: file asdf.gz'
? h:=gzipOpen("asdf.gz", "wb")

msg:='Hello, World!'
? gzipWrite(h, msg)
? gzipClose(h)

? h:=gzipOpen("asdf.gz", "rb")
msg1:=space(100)
? gzipRead(h, @msg1)
? gzipClose(h)

? 'before:', msg
? 'after:', msg1
?
? 'gzip/gunzip string test'
? 'msg:', msg
? 'msg1:=gzip(msg):', msg1:=gzip(msg)
? 'gunzip(msg1):', gunzip(msg1)
?
