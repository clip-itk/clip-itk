#ifndef _NTPS

// Job modes
#define PSJ_HOLD		0
#define PSJ_RET2Q		1
#define PSJ_THROWAWAY		2


// Subarray structure NNETPSARP()
#define ARP_NAME		1
#define ARP_NUM 		2
#define ARP_TYPE		3


// subarray structure NNETPSNOTL()
#define NL_SERVER		1
#define NL_NAME 		2
#define NL_TYPE 		3
#define NL_FIRST		4
#define NL_NEXT 		5


// subarray structure NNETPSQL()
#define QL_SERVER		1
#define QL_NAME 		2
#define QL_PRIOR		3


// Array structure for NNETPSRRP()
#define RRP_TYPE		1
#define RRP_INT 		2
#define RRP_IRQ 		3
#define RRP_BUF 		4
#define RRP_XON 		5
#define RRP_BAUD		6
#define RRP_DATA		7
#define RRP_STOP		8
#define RRP_PARITY		9
#define RRP_SOCKET		10

// Print server printer types
#define PSP_LPT1		0
#define PSP_LPT2		1
#define PSP_LPT3		2
#define PSP_COM1		3
#define PSP_COM2		4
#define PSP_COM3		5
#define PSP_COM4		6
#define PSP_REMLPT1		7
#define PSP_REMLPT2		8
#define PSP_REMLPT3		9
#define PSP_REMCOM1		10
#define PSP_REMCOM2		11
#define PSP_REMCOM3		12
#define PSP_REMCOM4		13
#define PSP_UNKOWN		14
#define PSP_ELSEWHERE		15

// Q service modes
#define QSM_NEED		1
#define QSM_MINQ		2
#define QSM_NEVER		4
#define QSM_MINACROSS		8


// Return values of NNETPSPROB()
#define PPROB_NONE		0
#define PPROB_OFFLINE		1
#define PPROB_NOPAPER		2


// Return values of NNETPSPSTA()
#define PST_WAIT_JOB		0
#define PST_WAIT_FORM		1
#define PST_PRINT		2
#define PST_PAUSED		3
#define PST_STOPPED		4
#define PST_MARK		5
#define PST_GO_DOWN		6
#define PST_NOT_CON		7
#define PST_PRIVATE		8



// Return values of NNETPSSTAT()
#define PSTAT_RUNNING		0
#define PSTAT_GO_DOWN		1
#define PSTAT_DOWN		2


// Return values of NNETPSTYPE()
#define PSTYP_DOS		1
#define PSTYP_NLM		2
#define PSTYP_FSVAP		3
#define PSTYP_BRGVAP		4


#define _NTPS

#endif

