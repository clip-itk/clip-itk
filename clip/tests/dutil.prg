parameters arg1, arg2, arg3, arg4, arg5

/*
DELETEFILE()
	0      NO_DISK_ERR         No error occurs
       -2      ER_FILE_NOT_FOUND   File not found
       -3      ER_PATH_NOT_FOUND   Path not found
       -5      ER_ACCESS_DENIED    Access denied (e.g., file is read-only)
*/
/*
do case
	case (ret:=deletefile( arg1 )) == 0
		? "success"
	case ret == -2
		? "file not found"
	case ret == -3
		? "path not found"
	case ret == -5
		? "access denied"
endcase
*/

/*
Change current dir. If argiment have disk letter, then
change current disk too
DIRCHANGE()
	0      NO_DISK_ERR         No error occurred
       -2      ER_FILE_NOT_FOUND   File not found
       -3      ER_PATH_NOT_FOUND   Path not found
       -5      ER_ACCESS_DENIED    Access denied (e.g., in network)
*/

/*
? currdrive() + "\" + curdir()
? dirchange( arg1 )
? currdrive() + "\" + curdir()
*/

/*
Change current disk, (A, B, C, D, ...),
letters can be followed by a colon
DISKCHANGE( ClipMachine *cm )
*/
/*
? currdrive() + "\" + curdir()
? diskchange(arg1)
? currdrive() + "\" + curdir()
*/

/*
Create directory
DIRMAKE( ClipMachine *cm )
*/
/*
do case
	case (ret:=dirmake( arg1 )) == 0
		? "success"
	case ret == -2
		? "file not found"
	case ret == -3
		? "path not found"
	case ret == -5
		? "access denied"
endcase
*/

/*
Name of current directory, possible one parameter -- disk name,
if absent, current disk is taken
DIRNAME( ClipMachine *cm )

change current work directory
if argument contain disk letter, then current disk changed too
int DIRCHANGE( ClipMachine *cm )
*/

/*
? currdrive() + "\" + dirname()
? dirchange( arg1 )
? currdrive() + "\" + dirname()
*/

/*
Detele directory. checking for current directory - 
current dir can't be deleted because of the DOS limitations
DIRREMOVE( ClipMachine *cm )
	0      Directory has been successfully removed.
       -3      Access path not found or directory not empty.
       -5      Access denied (e.g., in a network)
       -16     Current directory (cannot be removed)
*/
/*
do case
	case (ret:=dirremove( arg1 )) == 0
		? "success"
	case ret == -3
		? "Access path not found or directory not empty."
	case ret == -5
		? "Access denied (e.g., in a network)"
	case ret == -16
		? "Current directory (cannot be removed)"
endcase
*/

/*
? "Free disk space on '" + arg1 + "'", diskfree( arg1 ), "bytes"
*/

/*
? diskname()
diskchange( arg1 )
? diskname()
*/

/*
? "diskready", diskready( arg1 )
? "diskreadyw", diskreadyw( arg1 )
? "disktotal", disktotal( arg1 )
*/

/*
? "fileappend", fileappend( arg1, arg2 )
*/

/*
__copyfile( arg1, arg2 )
*/

/*
name = fileseek( arg1, val(arg2) )
do while( !empty(name) )
	? name + "&\t" +;
	  str(filesize()) + "&\t" +;
	  filetime() + " " + dtoc(filedate()) + "&\t" +;
	  str(fileattr()) + "&\t" + fileattrs()
	name = fileseek()
enddo
*/

/*
do while( .t. )
	name = fileseek( arg1 )
	do while( !empty(name) )
		? name
		? filesize()
		? filetime()
		? dtoc(filedate())
		? fileattr()
		? fileattrs()
		name = fileseek()
	enddo
enddo
*/

/*
do case
	case (ret:=setfattr( arg1, val(arg2) )) == 0
		? "success"
	case ret == -2
		? "File not found"
	case ret == -3
		? "Access path not found"
	case ret == -5
		? "Access denied (e.g., in a network)"
endcase
*/

/*
str = filestr( arg1, val(arg2), val(arg3), iif("t"$arg4,.t.,.f.) )
? str
*/

/*
? setfcreate( val(arg1) )
? setfcreate( val(arg2) )
? setfcreate( val(arg3) )
? setfcreate( val(arg4) )
? setfcreate( val(arg4) )
*/

/*
? strfile( arg1, arg2, iif("t"$arg3,.t.,.f.), val(arg4), iif("t"$arg5,.t.,.f.) )
*/

/*
? tempfile( arg1 )
*/

/*
? numdiskh()
*/

/*
? dospath( arg1 )
*/

/*
? filemove( arg1, arg2 )
*/

/*
? " in:", arg1
? "out:", truename( arg1 )
*/

/*
? "checksum:", filecheck( arg1 )
*/

/*
? setfdati( arg1, ctod(arg2), arg3 )
*/

/*
? filedelete( arg1/*, val(arg2)*/ )
*/

/*
? "getshare:", getshare()
? "setshare:", setshare( val(arg1) )
? "getshare:", getshare()
*/

/*
fd1 = fopen( arg1, 0 )
fd2 = fopen( arg2, 1 )
if ( fd1 < 0 .or. fd2 < 0 )
    ? ferrorstr()
endif

//fd3 = fopen( arg3, 0 )
//fd4 = fopen( arg4, 0 )
//fd5 = fopen( arg5, 0 )

buf=space(10)
n=0
do while( (n:=fread( fd1, @buf, 10 )) > 0 )
	fwrite( fd2, buf, n )
enddo

fwriteln( fd2, "asdf", 4 )
fwriteln( fd2, "asdf", 4 )
fwriteln( fd2, "asdf", 4 )
*/

/*
? "len: ", flength( fd1 )
do while( !fileeof( fd1 ) )
	? filegetstr( fd1 )
	? "pos: ", ftell( fd1 )
	? "fflush: ", fflush( fd1 ), fflush( 100 )
enddo
*/

//? "fseek", fseek( fd1, 5, 2 )

//? fd1, fclose( fd1 )
//? fd2, fclose( fd2 )
//? fd3, fclose( fd3 )
//? fd4, fclose( fd4 )
//? fd5, fclose( fd5 )

/*? faccess( arg1, arg2 ), arg2, arg1*/

/*
fd1 = fopen( arg1, 0 )
fd2 = fopen( arg2, 1 )
buf=space(1)

do while( !fileeof( fd1 ) )
	n:=fread( fd1, @buf, 1 )
	fwrite( fd2, buf, n )
enddo

fclose( fd1 )
fclose( fd2 )
*/


clear screen
? fopen( arg1, val(arg2) )
inkey(0)


init procedure init_disk
   SET( "C:", "/usr/home/serg/clip/hd1" )
   SET( "D:", "/usr/home/serg/clip/hd2" )
   SET( "E:", "/usr/home/serg/clip" )
   SET( "F:", "/usr/home/alena/clipper" )
