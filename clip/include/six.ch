#ifndef  INFO_EXPR
	#define INFO_EXPR		1
	#define INFO_NONEXPR		2
	#define INFO_OPTLVL		3
	#define INFO_COUNT		4
	#define INFO_SIZE		5
	#define INFO_OWNER		6
	#define INFO_POS		7
#endif

#ifndef  EVENT_PREUSE
	#define EVENT_PREUSE		1
	#define EVENT_POSTUSE		2
	#define EVENT_UPDATE		3
	#define EVENT_APPEND		4
	#define EVENT_DELETE		5
	#define EVENT_RECALL		6
	#define EVENT_PACK   		7
	#define EVENT_ZAP    		8
	#define EVENT_PUT    		9
	#define EVENT_GET    		10
	#define EVENT_PRECLOSE		11
	#define EVENT_POSTCLOSE		12
	#define EVENT_PREMEMOPACK	13
	#define EVENT_POSTMEMOPACK	14
#endif

#ifndef TRIGGER_PREUSE
	#define TRIGGER_ENABLE		1
	#define TRIGGER_DISABLE		2
	#define TRIGGER_REMOVE		3
	#define TRIGGER_INSTALL		4
#endif
