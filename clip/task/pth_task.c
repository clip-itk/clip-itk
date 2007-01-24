/*
   Copyright (C) 2007  ITK
   Author   : Uri <uri@itk.ru>
   License : (GPL) http://www.itk.ru/clipper/license.html
 */
/*
 $Log$
 Revision 1.3  2007/01/24 13:05:45  itk
 uri: new task model under PTH minimal works !

 Revision 1.2  2007/01/23 14:12:11  itk
 uri: some new code for new tasks

 Revision 1.1  2007/01/23 10:46:22  itk
 uri: some redisign for new task model


 */

#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <pth.h>
#include "cl_cfg.h"
#include "task.h"
#include "task2.h"

//#define _LDEBUG

static int pth_inited = 0;
static int stopcount = 0;

static int local_pth_init(void)
{
	int ret = FALSE;
	if ( pth_inited == 0 )
	{
		ret = pth_init();
		if (ret == TRUE)
			pth_inited = 1;
	}
	return ret;
}


TASK_DLLEXPORT long
Task_version(void)
{
	local_pth_init();
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	return pth_version();
}

TASK_DLLEXPORT int
Task_yield(void)
{
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	local_pth_init();
	pth_yield(NULL);
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	return 0;	
}

TASK_DLLEXPORT long 
Task_ID()
{
	long id;
	pth_t ptask;
	local_pth_init();
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	ptask = pth_self();
	id = (long) ptask;
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	return id;
}

TASK_DLLEXPORT long
Task_get_id(Task * task)
{
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	local_pth_init();
	if (task == NULL )
		return -1;
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	return task->id;
}

TASK_DLLEXPORT long
Task_sleep(long msec)
{
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	local_pth_init();
	pth_usleep(msec*1000);
	return 0;
}

TASK_DLLEXPORT int
Task_start_sheduler(void)
{
    /* not need under PTH*/
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	return 0;
}

TASK_DLLEXPORT Task *
Task_new(const char *name, long stacksize, void *data
	 ,void *(*run) (void *data), void (*destroy) (void *data))
{
	Task *task = NEW(Task);
	pth_t ptask;
	pth_attr_t attr;
	
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	local_pth_init();
	if ( pth_inited == 0)
	{
		if (pth_init() == 0)
		    return NULL;
		pth_inited = 1;
	}
	
	if (stacksize < TASK_STACK_MIN)
		stacksize = TASK_STACK_MIN;

	task->stacklen = stacksize;
	
        attr = pth_attr_new();
        pth_attr_set(attr, PTH_ATTR_NAME, name);
//	pth_attr_set(attr, PTH_ATTR_STACK_SIZE, (unsigned int)stacksize);

	ptask = pth_spawn(attr, run, data);
	pth_attr_destroy(attr);

	if (ptask == NULL)
		return NULL;

	++seqNo;
	task->id = seqNo;	
	task->ref = (void *)ptask;
	task->name = strdup(name);
	task->data = data;
	task->run = run;
	task->destroy = destroy;
	/*task->state = Task_initial;*/

#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	return task;
}

TASK_DLLEXPORT int
Task_start(Task *tp)
{
/* not need under PTH*/
#if 0
	int rc;
	void *val;
	rc = pth_join((pth_t)tp->ref, &val);
        if (rc == FALSE)
		return 0;
#endif			
	local_pth_init();
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	return 1;
}
TASK_DLLEXPORT void
Task_STOP()
{
	local_pth_init();
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	if (!stopcount)
	{
	}

	++stopcount;
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
}

TASK_DLLEXPORT void
Task_START()
{
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	local_pth_init();
	--stopcount;
	if (stopcount <= 0)
	{
		stopcount = 0;
	}
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
}

TASK_DLLEXPORT int
task_select(int nfds, fd_set * readfds, fd_set * writefds, fd_set * exceptfds,
		struct timeval *timeout)
{
	int ret=0;
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	local_pth_init();
	return ret;
}	

TASK_DLLEXPORT int
clip_task_select_if(int fd, void *rp, void *wp, void *ep, void *to)
{
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	local_pth_init();
	return task_select(fd, (fd_set *) rp, (fd_set *) wp, (fd_set *) ep, (struct timeval *) to);
}

TASK_DLLEXPORT int
Task_respond(TaskMessage * msg)
{
	int ret = 1;
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	local_pth_init();
	return ret;
}

TASK_DLLEXPORT int
Task_sendMessage(long receiver, /* new */ TaskMessage * msg)
{
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	local_pth_init();
	return 0;
}

TASK_DLLEXPORT int
Task_sendMessageWait(int receiver, TaskMessage * msg)
{
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	local_pth_init();
	return 0;
}

TASK_DLLEXPORT void *
TaskMessage_get_data(TaskMessage * msg)
{
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	local_pth_init();
	return msg->data;
}

TASK_DLLEXPORT TaskMessage *
TaskMessage_new(long id, void *data, void (*destroy) (void *data))
{
	TaskMessage *msg = NEW(TaskMessage);
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif

	msg->id = id;
	msg->data = data;
	msg->destroy = destroy;

#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	local_pth_init();
	return msg;
}

TASK_DLLEXPORT TaskMessage *
Task_peekMessage(void)
{
	Task *ct;
	TaskMessage *mp;

#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	local_pth_init();
	Task_yield();
/*
	ct = currTask;
	if (empty_List(&ct->recvlist))
		return 0;
	first_List(&ct->recvlist);
	mp = (TaskMessage *) ct->recvlist.current;
	remove_List(&ct->recvlist);
	append_List(&ct->proclist, mp);
*/
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	return mp;
}

TASK_DLLEXPORT TaskMessage *
Task_getMessage(void)
{
	TaskMessage *mp;
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	local_pth_init();
/*	Task *ct = currTask;

	if (empty_List(&ct->recvlist))
	{
		removeFromList(ct);
		addToMsg(ct);
		Task_yield();
		if (empty_List(&ct->recvlist))
			return 0;

	}
	else
		Task_yield();

	first_List(&ct->recvlist);
	mp = (TaskMessage *) ct->recvlist.current;
	remove_List(&ct->recvlist);
	append_List(&ct->proclist, mp);
*/
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	return mp;
}
