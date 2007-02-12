/*
   Copyright (C) 2007  ITK
   Author   : Uri <uri@itk.ru>
   License : (GPL) http://www.itk.ru/clipper/license.html
 */
/*
 $Log$
 Revision 1.7  2007/02/12 16:13:08  itk
 uri: some fix about task_select and some fix for amd64

 Revision 1.6  2007/02/08 11:50:00  itk
 uri: new task model based on PTH .... finished (may be finished :))



 Revision 1.5  2007/01/31 13:48:21  itk
 uri:some new code for pth

 Revision 1.4  2007/01/30 13:43:06  itk
 *** empty log message ***

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
//#define _MDEBUG
struct TaskMessage
{

	long sender;
	long receiver;
	long id;
	int needResp:1;
	int needDel:1;

	void *data;
	void (*destroy) (void *data);

};

struct Task
{
	ListEl listel;

	List recvlist;		/*  �������������*/
	List proclist;		/*  ������� �����*/

	char *name;		/*  ����� */
	long id;		/*  ���������� (pid) */
	long stacklen;		/*  length of task's stack */
	
	void * (*run) (void *data);
	void (*destroy) (void *data);
	void *data;
	void *ref;  /*other reference to any data*/
	
};

static int seqNo = 2;		/*  ��������������*/

static int pth_inited = 0;
static int stopcount = 0;
static int canSwitch = 0;	/*  task switch disabled flag */

static List Tasks = {NULL, NULL};

static void
calcTv(struct timeval *tv, long msec)
{
	if (msec == 0)
		msec = 1;
	tv->tv_sec = msec / 1000;
	tv->tv_usec = (msec % 1000) * 1000;
}

TASK_DLLEXPORT void
Task_INIT(void)
{
	if ( pth_inited != 0)
		return;
	pth_init();
	pth_inited = 1;
}

TASK_DLLEXPORT long
Task_version(void)
{
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	if (pth_inited)
		return pth_version();
	return 0;
}

TASK_DLLEXPORT int
Task_yield(void)
{
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	
	if (!canSwitch)
		return 0;
	if (pth_inited)
		pth_yield(NULL);
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	return 0;	
}

static Task *
seach_task_in_list(List *list, pth_t ref)
{
	int r;
	Task * ret = NULL;
	Task * tp;
	pth_t ptask;

	for (r = first_List(list); r; r = next_List(list))
	{
		tp = (Task*)list->current;
		ptask = tp->ref;
		if ( ptask == ref)
		{
			ret = (Task *) tp;
			break;
		}
	}
	return ret;
}


TASK_DLLEXPORT long 
Task_ID()
{
	long id;
	pth_t ptask;
	Task * task;
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	if (!pth_inited)
		return -1;
	ptask = pth_self();
	task = seach_task_in_list(&Tasks,ptask);
	if (task == NULL)
		return -1L;
	id = task->id;
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	return id;
}

TASK_DLLEXPORT long
Task_get_id(Task * task)
{
#ifdef _LDEBUG
	printf("F=%s,L=%d,name=%s,%p\n",__FILE__,__LINE__,task->name,task->name);
#endif
	if (!pth_inited)
		return -1;
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
	if (!pth_inited)
		return 0;
	if (!canSwitch)
	{
		struct timeval tv;

		calcTv(&tv, msec);
		select(0, 0, 0, 0, &tv);
		return 1;
	}
	pth_usleep(msec*1000);
	return 0;
}

TASK_DLLEXPORT int
Task_start_sheduler(void)
{
	int ret = canSwitch;
    /* not need under PTH*/
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	canSwitch = 1;
	return ret;
}

TASK_DLLEXPORT int
Task_stop_sheduler(void)
{
	int ret = canSwitch;
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	canSwitch = 0;
	return ret;
}


static void local_print_List(List * list)
{
	int r;
	Task *tp;

	for (r = first_List(list); r; r = next_List(list))
	{
		tp = (Task *) list->current;
#if defined(_LDEBUG) || defined(_MDEBUG)
		printf("list-print,task=%p,task->id=%ld,namename=%s,%p,data=%s#\n",(void *)tp,tp->id,tp->name,tp->name,(char *) tp->data);
#endif
	}

}

void *
task_pth_run(void * data)
{
	Task *task;
	task = (Task *) data;
	char msgPortName[10];

	pth_msgport_t mp;
	pth_event_t ev;

#ifdef _LDEBUG
	printf("F=%s,L=%d,data_pth_run=%p,%p,name=%s,%p\n",__FILE__,__LINE__,data,task,task->name,task->name);
#endif
	if (task == NULL)
		return NULL;
	append_List(&Tasks, (void *)task);
	local_print_List(&Tasks);

	snprintf(msgPortName,10,"%ld",task->id);
#ifdef _MDEBUG
	printf("F=%s,L=%d,task->id=%ld,msgPortName=%s\n",__FILE__,__LINE__,task->id,msgPortName);
#endif
	mp = pth_msgport_create(msgPortName);
	ev = pth_event(PTH_EVENT_MSG, mp);

	if ( task->run )
		task->run(task->data);

    	pth_event_free(ev, PTH_FREE_THIS);
    	pth_msgport_destroy(mp);

	if ( task->destroy )
		task->destroy(task->data);
	stopcount = 0;
	Task_START();
	removeIt_List(&Tasks, task);
//	local_print_List(&Tasks);
	free(task->name);
	free(task);
#ifdef _LDEBUG
	printf("	task end run=%p\n",task);
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	return NULL;
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
	if ( pth_inited == 0)
	{
		if (pth_init() == 0)
			return NULL;
		pth_inited = 1;
	}
	
	if (stacksize < TASK_STACK_MIN)
		stacksize = TASK_STACK_MIN;

	++seqNo;
	task->id = seqNo;	
	task->stacklen = stacksize;
	task->name = strdup(name);
	task->data = data;
	task->run = run;
	task->destroy = destroy;
	
        attr = pth_attr_new();
        pth_attr_set(attr, PTH_ATTR_NAME, name);
	pth_attr_set(attr, PTH_ATTR_STACK_SIZE, (unsigned int)stacksize);
	ptask = pth_spawn(attr, task_pth_run, task);
	pth_attr_destroy(attr);
	if (ptask == NULL)
	{
		free(task);
		return NULL;
	}
	task->ref = (void *)ptask;

#ifdef _LDEBUG
	printf("	open ptask=%p,task=%p,name=%s,%p\n",(void*)ptask,(void*)task,task->name,task->name);
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	return task;
}

TASK_DLLEXPORT int
Task_start(Task *tp)
{
/* not need under PTH*/
#ifdef _LDEBUG
	printf("F=%s,L=%d,name=%s,%p\n",__FILE__,__LINE__,tp->name,tp->name);
#endif
	return 1;
}

static void
task_pth_stop(List *list, pth_t _ptask)
{
	int r;
	Task *tp;
	pth_t ptask;
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	for (r = first_List(list); r; r = next_List(list))
	{
		tp = (Task*)list->current;
		ptask = tp->ref;
		if ( _ptask == ptask)
			continue;
		pth_suspend(ptask);
	}
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	return;
}

TASK_DLLEXPORT void
Task_STOP()
{
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	if (!stopcount)
	{
		if (pth_inited)
		{
			pth_t ptask;
			ptask = pth_self();
			task_pth_stop(&Tasks,ptask);
		}
		Task_stop_sheduler();
	}

	++stopcount;
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
}
static void
task_pth_start(List *list)
{
	int r;
	Task *tp;
	pth_t ptask;
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	for (r = first_List(list); r; r = next_List(list))
	{
		tp = (Task*)list->current;
		ptask = tp->ref;
		pth_resume(ptask);
	}
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	return;
}

TASK_DLLEXPORT void
Task_START()
{
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	--stopcount;
	if (stopcount <= 0)
	{
		if (pth_inited)
		{
			pth_t ptask;
			ptask = pth_self();
			task_pth_start(&Tasks);
		}
		Task_start_sheduler();
		Task_yield();
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
	if (!pth_inited)
		return -1;
	if (!canSwitch)
		ret = select(nfds, readfds, writefds, exceptfds, timeout);
	else
		ret = pth_select(nfds, readfds, writefds, exceptfds, timeout);
	return ret;
}

TASK_DLLEXPORT int
clip_task_select_if(int fd, void *rp, void *wp, void *ep, void *to)
{
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	if (!pth_inited)
		return -1;
	return task_select(fd, (fd_set *) rp, (fd_set *) wp, (fd_set *) ep, (struct timeval *) to);
}

TASK_DLLEXPORT int
Task_respond(TaskMessage * msg)
{
	int ret = 1;
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	if (!pth_inited)
		return -1;
/* not need for PTH */
	return ret;
}
int
__Task_sendMessage(long receiver, TaskMessage * msg, int wait)
{
	pth_t ptask;
	Task * task;
	pth_event_t ev = NULL;
	pth_msgport_t selfPort = NULL;
	pth_msgport_t recvPort = NULL;
	char msgPortName[10];
	int ret;

#ifdef _MDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	if (!pth_inited)
		return 0;
	snprintf(msgPortName,10,"%ld",receiver);
	recvPort = pth_msgport_find(msgPortName);
#ifdef _MDEBUG
	printf("F=%s,L=%d,msgPortName=%s,recvPort=%p\n",__FILE__,__LINE__,msgPortName,recvPort);
#endif
	if (recvPort == NULL)
		return 0;
	ptask = pth_self();
	task = seach_task_in_list(&Tasks,ptask);
//	printf("F=%s,L=%d,%p,%p\n",__FILE__,__LINE__,ptask,task);
//	local_print_List(&Tasks);
	msg->receiver = receiver;
	if (task != NULL )
		msg->sender = task->id;
	ret = pth_msgport_put(recvPort, (pth_message_t *)msg);
	if (!wait)
		return ret;
	if (task == NULL )
		return ret;
	snprintf(msgPortName,10,"%ld",task->id);
	selfPort = pth_msgport_find(msgPortName);
	ev = pth_event(PTH_EVENT_MSG, selfPort);
	pth_wait(ev);
		
	if (msg->destroy)
		msg->destroy((void *)msg->data);
#ifdef _MDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	return ret;
}

TASK_DLLEXPORT int
Task_sendMessage(long receiver, TaskMessage * msg)
{
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	return __Task_sendMessage(receiver,msg,0);
}

TASK_DLLEXPORT int
Task_sendMessageWait(int receiver, TaskMessage * msg)
{
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	return __Task_sendMessage(receiver,msg,1);
}

TASK_DLLEXPORT void *
TaskMessage_get_data(TaskMessage * msg)
{
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	if (msg == NULL)
		return NULL;
	if (!pth_inited)
		return NULL;
	return msg->data;
}

TASK_DLLEXPORT TaskMessage *
TaskMessage_new(long id, void *data, void (*destroy) (void *data))
{
	TaskMessage *msg = NEW(TaskMessage);
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	if (!pth_inited)
		return NULL;
	msg->id = id;
	msg->data = data;
	msg->destroy = destroy;

#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	return msg;
}

TASK_DLLEXPORT TaskMessage *
Task_peekMessage(void)
{
	pth_t ptask;
	Task * task;
	pth_msgport_t selfPort = NULL;
	char msgPortName[10];

#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	if (!pth_inited)
		return NULL;
	ptask = pth_self();
	task = seach_task_in_list(&Tasks,ptask);
	if (task == NULL)
		return NULL;
	snprintf(msgPortName,10,"%ld",task->id);
	selfPort = pth_msgport_find(msgPortName);
	if (selfPort == NULL)
		return NULL;
	if ( pth_msgport_pending(selfPort) )
		return Task_getMessage();

	Task_yield();
#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	return NULL;
}

TASK_DLLEXPORT TaskMessage *
Task_getMessage(void)
{
	pth_t ptask;
	Task * task;
	pth_msgport_t selfPort = NULL;
    	pth_event_t ev;
	char msgPortName[10];
	TaskMessage *msg = NULL;

#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	if (!pth_inited)
		return NULL;
	ptask = pth_self();
	task = seach_task_in_list(&Tasks,ptask);
	if (task == NULL)
		return NULL;
	snprintf(msgPortName,10,"%ld",task->id);
	selfPort = pth_msgport_find(msgPortName);
	if (selfPort == NULL)
		return NULL;
	ev = pth_event(PTH_EVENT_MSG, selfPort);
	if (pth_wait(ev) != 1)
		return NULL;
         msg = (TaskMessage *)pth_msgport_get(selfPort);

#ifdef _LDEBUG
	printf("F=%s,L=%d\n",__FILE__,__LINE__);
#endif
	return msg;
}
