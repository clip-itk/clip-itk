#ifndef _CTSYS_DEFINED
#define _CTSYS_DEFINED

#define NO_ERROR	    0

/******************* ERRORBASE() *******************/

#define ERR_B_NOT_ENOUGH_MEMORY    1  // not enough memory
#define ERR_B_LOCKED		   2  // access denied temporarily
#define ERR_B_USER		   3  // no access to this user
#define ERR_B_INTERNAL_SYS_SOFT    4  // internal error in the system software
#define ERR_B_SYS_HARD		   5  // hardware error
#define ERR_B_SYS_SOFT		   6  // error in the system software
#define ERR_B_APPLICATION	   7  // error in the application software
#define ERR_B_FILE_NOT_FOUND	   8  // file not found
#define ERR_B_FILE_WRONG	   9  // file has wrong format or type
#define ERR_B_FILE_PROTECTED	  10  // file is protected
#define ERR_B_WRONG_MEDIUM	  11  // incorrect medium in the drive
#define ERR_B_ANOTHER		  12  // another error


/******************* ERRORACT() *******************/

#define ERR_A_TRY_ASK		   1  // try several times, then ask user
#define ERR_A_TRY_WAIT_ASK	   2  // try several times with pauses, then ask user
#define ERR_A_ASK_DATA		   3  // ask user for data
#define ERR_A_QUIT_NORMAL	   4  // exit program normally
#define ERR_A_QUIT_FAST 	   5  // exit program as soon as possible
#define ERR_A_IGNORE		   6  // ignore
#define ERR_A_ASK_TRY		   7  // call on user for removal, then try again


/******************* ERRORORG() *******************/

#define ERR_O_UNKNOWN		   1  // unknown
#define ERR_O_BLOCK_DEVICE	   2  // block device (floppy disk, hard disk etc.)
#define ERR_O_NETWORK		   3  // network
#define ERR_O_SERIAL_DEVICE	   4  // serial device
#define ERR_O_MEMORY		   5  // RAM


/******************* ERRORCODE(), DOSERROR() *******************/

#define ERR_UNKNOWN_FUNCTION	   1  // unknown function code
#define ERR_FILE_NOT_FOUND	   2  // file not found
#define ERR_PATH_NOT_FOUND	   3  // path not found
#define ERR_TO_MANY_FILES	   4  // too many files open
#define ERR_ACCESS_DENIED	   5  // access denied
#define ERR_UNKNOWN_HANDLE	   6  // unknown handle
#define ERR_MEMORY		   7  // memory control block destroyed
#define ERR_NOT_ENOUGH_MEMORY	   8  // not enough memory
#define ERR_WRONG_MEMORY	   9  // undefined memory segment
#define ERR_WRONG_ENVIRONMENT	  10  // undefined environment
#define ERR_WRONG_ACCESS	  11  // undefined access code
#define ERR_WRONG_DATA		  12  // defective data
#define ERR_UNKNOWN_DRIVE	  15  // unknown drive
#define ERR_REMOVE_PATH 	  16  // attempt to remove current path
#define ERR_DIFFERENT_DEVICE	  17  // not an identical device
#define ERR_NO_MORE_FILES	  18  // no further data
#define ERR_WRITE_PROTECTED	  19  // device is write protected
#define ERR_UNKNOWN_EQUIP	  20  // unknown equipment
#define ERR_EQUIP_NOT_READY	  21  // equipment not ready
#define ERR_UNKNOWN_INSTRUCTION   22  // unknown instruction
#define ERR_CRC 		  23  // CRC error
#define ERR_WRONG_DATA_SIZE	  24  // unknown data size
#define ERR_SEEK		  25  // seek error
#define ERR_UNKNOWN		  26  // unknown instruction type
#define ERR_SECTOR_NOT_FOUND	  27  // sektor not found
#define ERR_PAPER		  28  // paper out
#define ERR_WRITE		  29  // write error
#define ERR_READ		  30  // read error
#define ERR_GENERAL		  31  // general error
#define ERR_DISKCHANGE		  34  // disk exchange not allowed
#define ERR_FCB 		  35  // FCB not available
#define ERR_FILE_EXIST_ALREADY	  80  // file already exists
#define ERR_DIRMAKE		  82  // directory can not be created
#define ERR_INT_24		  83  // error in conn. with INT 24h


/******************** CPUTYPE() **********************/

#define CPU_8088		   0  //  8088
#define CPU_8086		   1  //  8086
#define CPU_V20 		   2  //  V20
#define CPU_V30 		   3  //  V30
#define CPU_80188		   4  //  80188
#define CPU_80186		   5  //  80186
#define CPU_80286		   6  //  80286
#define CPU_80386		   7  //  80386
#define CPU_80486		   8  //  80486

/******************** PCTYPE() **********************/

#define PC_NORMAL		 255  //  standard PC
#define PC_XT			 254  //  PC XT (with hard disk)
#define PC_JUNIOR		 253  //  PC junior
#define PC_MODEL30		 240  //  model 30
#define PC_XT_2 		 251  //  XT/2
#define PC_LAPTOP		 249  //  laptop
#define PC_AT			 252  //  AT / XT 286 / model 50 / model 80
#define PC_MODEL80		 248  //  model 80
#define PC_COMPAQP		  45  //  Compaq Portable
#define PC_COMPAQPP		 154  //  Compaq Portable plus

#endif
