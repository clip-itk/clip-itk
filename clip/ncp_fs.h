/*
 *  ncp_fs.h
 *
 *  Copyright (C) 1995, 1996 by Volker Lendecke
 *
 */

/* TODO: These are all internal to ncpfs... Do something with them :-) */

/* NOTE: this is a standalone version of linux/ncp_fs.h */

#ifndef _KERNEL_NCP_FS_H
#define _KERNEL_NCP_FS_H

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>

struct ncp_sign_init
{
	char sign_root[8];
	char sign_last[16];
};

union ncp_sockaddr {
	struct sockaddr any;
#ifdef NCP_IPX_SUPPORT
	struct sockaddr_ipx ipx;
#endif
#ifdef NCP_IN_SUPPORT
	struct sockaddr_in inet;
#endif
};

/*
 * ioctl commands
 */

struct ncp_ioctl_request {
	unsigned int function;
	unsigned int size;
	char *data;
};

struct ncp_fs_info {
	int version;
	union ncp_sockaddr addr;
	/*__kerXX_uid_t mounted_uid;*/
	uid_t mounted_uid;
	int connection;		/* Connection number the server assigned us */
	int buffer_size;	/* The negotiated buffer size, to be
				   used for read/write requests! */

	int volume_number;
	u_int32_t directory_id;
};

struct ncp_lock_ioctl
{
#define NCP_LOCK_LOG	0
#define NCP_LOCK_SH	1
#define NCP_LOCK_EX	2
#define NCP_LOCK_CLEAR	256
	int		cmd;
	int		origin;
	unsigned int	offset;
	unsigned int	length;
#define NCP_LOCK_DEFAULT_TIMEOUT	18
#define NCP_LOCK_MAX_TIMEOUT		180
	int		timeout;
};

struct ncp_setroot_ioctl
{
	int		volNumber;
	int		name_space;
	u_int32_t	dirEntNum;
};

struct ncp_objectname_ioctl
{
#define NCP_AUTH_NONE	0x00
#define NCP_AUTH_BIND	0x31
#define NCP_AUTH_NDS	0x32
	int		auth_type;
	size_t		object_name_len;
	void*		object_name;
};

struct ncp_privatedata_ioctl
{
	size_t		len;
	void*		data;		/* ~1000 for NDS */
};

/* NLS charsets by ioctl */
#define NCP_IOCSNAME_LEN 20
struct ncp_nls_ioctl_old
{
	int codepage;
	unsigned char iocharset[NCP_IOCSNAME_LEN+1];
};

struct ncp_nls_ioctl
{
	unsigned char codepage[NCP_IOCSNAME_LEN+1];
	unsigned char iocharset[NCP_IOCSNAME_LEN+1];
};

#define	NCP_IOC_NCPREQUEST		_IOR('n', 1, struct ncp_ioctl_request)
#define	NCP_IOC_GETMOUNTUID		_IOW('n', 2, __kernel_uid_t)
#define NCP_IOC_CONN_LOGGED_IN          _IO('n', 3)

#define NCP_GET_FS_INFO_VERSION (1)
#define NCP_IOC_GET_FS_INFO             _IOWR('n', 4, struct ncp_fs_info)

#define NCP_IOC_SIGN_INIT		_IOR('n', 5, struct ncp_sign_init)
#define NCP_IOC_SIGN_WANTED		_IOR('n', 6, int)
#define NCP_IOC_SET_SIGN_WANTED		_IOW('n', 6, int)

#define NCP_IOC_LOCKUNLOCK		_IOR('n', 7, struct ncp_lock_ioctl)

#define NCP_IOC_GETROOT			_IOW('n', 8, struct ncp_setroot_ioctl)
#define NCP_IOC_SETROOT			_IOR('n', 8, struct ncp_setroot_ioctl)

#define NCP_IOC_GETOBJECTNAME		_IOWR('n', 9, struct ncp_objectname_ioctl)
#define NCP_IOC_SETOBJECTNAME		_IOR('n', 9, struct ncp_objectname_ioctl)
#define NCP_IOC_GETPRIVATEDATA		_IOWR('n', 10, struct ncp_privatedata_ioctl)
#define NCP_IOC_SETPRIVATEDATA		_IOR('n', 10, struct ncp_privatedata_ioctl)

#define NCP_IOC_GETCHARSETS		_IOWR('n', 11, struct ncp_nls_ioctl)
#define NCP_IOC_SETCHARSETS		_IOR('n', 11, struct ncp_nls_ioctl)
/* never released to Linus, will wanish shortly */
#define NCP_IOC_GETCHARSETS_OLD		_IOWR('n', 11, struct ncp_nls_ioctl_old)
#define NCP_IOC_SETCHARSETS_OLD		_IOR('n', 11, struct ncp_nls_ioctl_old)

#define NCP_IOC_GETDENTRYTTL		_IOW('n', 12, u_int32_t)
#define NCP_IOC_SETDENTRYTTL		_IOR('n', 12, u_int32_t)

/*
 * This ioctl allow work in dos-specific share/exclusive open mode
 * without using lockfiles and so on, and in compatible with dos
 * applications way.
 *
 * if ioctl *arg == 0, request for share open
 * else request for exclusive open
 * ioctl returns EINVAL if this feature is absent (invalid ioctl),
 * 0 on success, and other value on share errors.
 *
 * Paul Lasarev <paul@itk.ru>
 */
#define NCP_IOC_OPENMODE		_IOW('n', 21, int)

/*
#define N_AR_DENY_READ      (ntohs(0x0400))
#define N_AR_DENY_WRITE     (ntohs(0x0800))
int ncp_openmode(struct inode *inode, struct file *file, int exclusive);
*/


/*
 * The packet size to allocate. One page should be enough.
 */
#define NCP_PACKET_SIZE 4070

#define NCP_MAXPATHLEN 255
#define NCP_MAXNAMELEN 14

#endif				/* _LINUX_NCP_FS_H */
