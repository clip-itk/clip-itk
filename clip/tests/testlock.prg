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
        ? "1: i`m use EXCLUSIVE and wait second process"
        do while !file(SHARE_FILE)
        	sleep(1)
        enddo
        use
        ferase(EXCL_FILE)
        //sleep(1)
	err:=.f.
        ? "1: second procees open share, i try open:"
	begin sequence
        	use SHARE_FILE exclusive
        recover using err
        	err:=.t.
	end sequence
        ? "1: Check for exclusive open:",iif(err,"OK","Not worked") //,neterr(),ferror(),ferrorstr()
	err:=.f.
	begin sequence
        	use SHARE_FILE shared
        recover using err
        	err:=.t.
	end sequence
        ? "1: Check for share open:",iif(!err,"OK","Not worked")
        use

        err:=fcreate(LOCK1_FILE)
        fclose(err)
        do while !file(LOCK2_FILE)
        	sleep(1)
        enddo
        err:=.f.
	begin sequence
        	use SHARE_FILE shared
        recover using err
        	err:=.t.
	end sequence
        ? "1: share reopen:",iif(!err,"OK","Not worked")
        ? "1: first record locking",iif(used() .and. !rlock(),"Ok","NotWorked")

else
	err:=.f.
	begin sequence
        	use EXCL_FILE exclusive
        recover using err
        	err:=.t.
	end sequence
        ? "2: first process open exclusive, i try open:"
        ? "2: Check for exclusive open:",iif(err,"OK","Not worked") //,neterr(),ferror(),ferrorstr()
	err:=.f.
	begin sequence
        	use EXCL_FILE shared
        recover using err
        	err:=.t.
	end sequence
        ? "2: Check for share open:",iif(err,"OK","Not worked")//,neterr(),ferror(),ferrorstr()
        use
        dbcreate(SHARE_FILE,{{"name","c",10,0}})
        use
        use SHARE_FILE shared
        append blank
        ? "2: i`m use SHARE and wait first process"
        do while !file(LOCK1_FILE)
        	sleep(1)
        enddo
        //sleep(1)
        use
        err:=.f.
	begin sequence
        	use SHARE_FILE shared
        recover using err
        	err:=.t.
	end sequence
        ? "2: share reopen:",iif(!err,"OK","Not worked")
        ? "2: first record locking",iif(used() .and. rlock(),"Ok","NotWorked")
        ? err:=fcreate(LOCK2_FILE)
        ? 'fcreate error', err, ferror(), ferrorstr()
	fclose(err)
        sleep(5)
endif
use
? ferase(EXCL_FILE),ferase(SHARE_FILE),ferase(LOCK1_FILE),ferase(LOCK2_FILE)
?
