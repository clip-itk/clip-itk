/*
	defined constants for function ulimit()
*/

#ifndef _ULIMIT_DEFINED

#define _ULIMIT_DEFINED


#define ULIMIT_CPU	"CPU"      /* CPU time in seconds */
#define ULIMIT_FSIZE	"FSIZE"    /* Maximum filesize */
#define ULIMIT_DATA	"DATA"     /* max data size */
#define ULIMIT_STACK	"STACK"    /* max stack size */
#define ULIMIT_CORE	"CORE"     /* max core file size */
#define ULIMIT_RSS	"RSS"      /* max resident set size */
#define ULIMIT_NPROC	"NPROC"    /* max number of processes */
#define ULIMIT_NOFILE	"NOFILE"   /* max number of open files */
#define ULIMIT_MEMLOCK	"MEMLOCK"  /* max locked-in-memory address space */
#define ULIMIT_AS	"AS"       /* address space (virtual memory) limit */
#define ULIMIT_VM	ULIMIT_AS

#define ULIMIT_UNLIMITED -1        /* unlimited value for ulimit() */

#endif
