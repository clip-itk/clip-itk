#if !defined(__GNUC__)

#define CLIP_VERSION	"X"
#define OSNAME		"WIN32"

typedef	char *	caddr_t;
typedef int pid_t;

int strcasecmp( char _FAR *__s1, char _FAR *__s2);
int strncasecmp( char _FAR *__s1, char _FAR *__s2, int n );

#endif