#define EXCL_FILE "_exclus.dbf"
#define SHARE_FILE "_shared.dbf"
#define LOCK1_FILE "_lock1.dbf"
#define LOCK2_FILE "_lock2.dbf"
local e,err,first:=!file(EXCL_FILE)

errorblock({|x|break(x)})
if first
        dbcreate(EXCL_FILE,{{"name","c",10,0}})
        use
        use EXCL_FILE exclusive
        ? "i`m use EXCLUSIVE and wait second process"
        do while !file(SHARE_FILE)
        	sleep(1)
        enddo
        use
        ferase(EXCL_FILE)
        sleep(1)
	err:=.f.
	begin sequence
        	use SHARE_FILE exclusive
        recover using err
        	err:=.t.
	end sequence
        ? "Check for exclusive open:",iif(err,"OK","Not worked") //,neterr(),ferror(),ferrorstr()
	err:=.f.
	begin sequence
        	use SHARE_FILE shared
        recover using err
        	err:=.t.
	end sequence
        ? "Check for share open:",iif(!err,"OK","Not worked")//,neterr(),ferror(),ferrorstr()
        use
        sleep(1)
        err:=fcreate(LOCK1_FILE)
        fclose(err)
        do while !file(LOCK2_FILE)
        	sleep(1)
        enddo
        use SHARE_FILE shared
        ? "Check second record locking",iif(!rlock(),"Ok","NotWorked")
else
	err:=.f.
	begin sequence
        	use EXCL_FILE exclusive
        recover using err
        	err:=.t.
	end sequence
        ? "Check for exclusive open:",iif(err,"OK","Not worked") //,neterr(),ferror(),ferrorstr()
	err:=.f.
	begin sequence
        	use EXCL_FILE shared
        recover using err
        	err:=.t.
	end sequence
        ? "Check for share open:",iif(err,"OK","Not worked")//,neterr(),ferror(),ferrorstr()
        use
        dbcreate(SHARE_FILE,{{"name","c",10,0}})
        use
        use SHARE_FILE shared
        append blank
        ? "i`m use SHARE and wait first process"
        do while !file(LOCK1_FILE)
        	sleep(1)
        enddo
        sleep(1)
        use
        use SHARE_FILE shared
        ? "Check first record locking",iif(rlock(),"Ok","NotWorked")
        err:=fcreate(LOCK2_FILE)
        fclose(err)
        sleep(2)
endif
ferase(EXCL_FILE)
ferase(SHARE_FILE)
ferase(LOCK1_FILE)
ferase(LOCK2_FILE)
?
