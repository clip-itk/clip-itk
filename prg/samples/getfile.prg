local driver:={}, c[2], ret:="", curdrv:=1, curdir:=""

clear screen
@ 0,0 say  "Please choice file name"
ret = filedialog()
? "You choice:",ret,"?"
inkey(0)

ret = DiskFileDialog(driver, curdrv, curdir, "*")
? "You choice:",ret,"?"
?
inkey(0)


