#ifndef _CTDISK_DEFINED
#define _CTDISK_DEFINED

#define NO_DISK_ERR	 0

/************** FILEATTR(), SETFATTR(), FILESEEK() **************/

#define FA_NORMAL	 0
#define FA_READONLY	 1
#define FA_HIDDEN	 2
#define FA_SYSTEM	 4
#define FA_VOLUME	 8
#define FA_DIRECTORY	16
#define FA_ARCHIVE	32


/******************* DISKSTAT() *******************/

#define DST_INVALID	 1	 // R/O or invalid command
#define DST_READONLY	 2	 // R/O or adress marker not found
#define DST_SECTOR	 4	 // sektor not found
#define DST_DMA 	 8	 // DMA overflow
#define DST_CRC 	16	 // CRC error
#define DST_CONTROLLER	32	 // controller error
#define DST_SEEK	64	 // seek operation failed
#define DST_TIMEOUT    128	 // timeout error


/******************* SETSHARE() *******************/

#define SHARE_COMPAT	 0	 // compatibilty mode (default)
#define SHARE_EXCLUSIVE  1	 // exclusive
#define SHARE_DENYWRITE  2	 // other process NOT permitted to write
#define SHARE_DENYREAD	 3	 // other process NOT permitted to read
#define SHARE_DENYNONE	 4	 // other process permitted to read/write


/******************* SETFATTR(), DELETEFILE() *******************/

#define ER_FILE_NOT_FOUND  -2	 // file not found
#define ER_PATH_NOT_FOUND  -3	 // path not found
*define ER_ACCESS_DENIED   -5	 // access denied


/******************* RENAMEFILE(), FILEMOVE() *******************/

*define ER_FILE_NOT_FOUND    -2  // file not found
*define ER_PATH_NOT_FOUND    -3  // path not found
*define ER_ACCESS_DENIED     -5  // access denied
#define ER_DIFFERENT_DEVICE -17  // not an identical device


/******************* DIRMAKE() *******************/

*define ER_PATH_NOT_FOUND   -3	 // path not found
*define ER_ACCESS_DENIED    -5	 // access denied


/******************* DIRREMOVE() *******************/

*define ER_PATH_NOT_FOUND   -3	 // path not found
*define ER_ACCESS_DENIED    -5	 // access denied
#define ER_REMOVE_PATH	   -16	 // invalid attempt to remove path


/******************* DIRCHANGE() *******************/

*define ER_PATH_NOT_FOUND   -3	 // path not found
*define ER_ACCESS_DENIED    -5	 // access denied

/******************* DISKFORMAT() *******************/

#define DF_WRONG_DRIVE	    -1	 // required drive not available
#define DF_WRONG_DISK_SIZE  -2	 // required drive size not available
#define DF_INTERRUPTED	    -3	 // cancelled by UDF
#define DF_WRITE	    -4	 // write error

/******************* DISKTYPE() *********************/

#define DT_NO_DISK	     0	 // no drive available
#define DT_DS_SEC_8	   255	 // double sided 8 sectors
#define DT_SS_SEC_8	   254	 // single sided 8 sectors
#define DT_DS_SEC_9	   253	 // double sided 9 sectors
#define DT_SS_SEC_9	   252	 // single sided 9 sectors
#define DT_DS_SEC_15	   249	 // double sided 15 sectors (HD disk)
#define DT_35_SEC_9	   249	 // double sided 3,5" 9 sectors (= 5,25 HD)
#define DT_35_SEC_18	   240	 // double sided 3,5" 18 sectors
#define DT_HARDDISK	   248	 // hard disk

/******************* DRIVETYPE() *********************/

#define RAMDISK 	     0	 // RAM disk or no drive available
#define FLOPPY_ND	     1	 // floppy (disk exchange can NOT be fixed)
#define FLOPPY		     2	 // floppy (disk exchange can be fixed)
#define HARDDISK	     3	 // hard disk

/******************* FLOPPYTYPE() *********************/

#define FLOPPY_NONE	     0	 // no floppy disk drive
#define FLOPPY_360k	     1	 // 360kB drive
#define FLOPPY_1200k	     2	 // 1,2MB drive
#define FLOPPY_760k	     3	 // 720kB drive
#define FLOPPY_1440k	     4	 // 1,44MB drive

#endif
