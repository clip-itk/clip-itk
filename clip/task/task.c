/*
   Copyright (C) 2001  ITK
   Author   : Paul Lasarev <paul@itk.ru>
   License : (GPL) http://www.itk.ru/clipper/license.html
 */
/*
 $Log: task.c,v $
 Revision 1.19  2003/09/18 10:52:04  clip
 uri: small fix

 Revision 1.18  2003/09/17 07:54:50  clip
 uri: some fixes for Solaris and Ukraina cp1251

 Revision 1.17  2003/09/05 12:11:53  clip
 uri: initial fixes for mingw+win32 from uri

 Revision 1.14  2003/07/03 07:39:06  clip
 new release
 paul

 Revision 1.13  2003/07/02 07:05:04  clip
 fix some memleaks
 paul

 Revision 1.12  2003/04/29 11:09:39  clip
 memleak on start()
 possibly closes #140
 paul

 Revision 1.11  2003/03/17 08:24:59  clip
 Solaris 8 patches
 paul

 Revision 1.10  2002/12/25 13:26:10  clip
 fixes for Solaris tasks
 paul

 Revision 1.9  2001/12/24 13:26:25  clip
 add TASK_DLLEXPORT modifier for task library
 paul

 Revision 1.8  2001/12/20 12:10:53  clip
 fix for OpenBSD
 paul

 Revision 1.7  2001/11/16 13:06:26  clip
 CYGWIN w32_hStdIn initialsation
 paul

 Revision 1.6  2001/11/16 11:36:01  clip
 dirty hack for w32 happiness..
 paul

 Revision 1.5  2001/11/16 08:14:34  clip
 fix for CYGWIN
 paul

 Revision 1.4  2001/11/14 06:38:02  clip
 fix crash on exit after START
 paul

 Revision 1.3  2001/11/13 11:22:12  clip
 TASKSTOP() stop task switching
 TASKSTART() start task switching
 TASKSTOP()/TASKSTART() pairs may be nested
 paul

 Revision 1.2  2001/11/13 09:31:37  clip
 START('funcname'[, arg1 ... argN])
 can now put arg1-argN to call of funcname
 paul

 Revision 1.1  2001/11/12 14:13:46  clip
 START(cFuncname) now work :)
 paul
 */

#include <stdio.h>
#include <unistd.h>
#include <setjmp.h>
#include <time.h>
#include <string.h>
#include <stdlib.h>
#include <sys/time.h>
#include <sys/types.h>

#include "list.h"
#include "coll.h"
#include "hash.h"

#include "taskcfg.h"
#ifdef OS_MINGW
#include "../_win32.h"
#else
#include <sys/times.h>
#endif
#include "task.h"

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

typedef enum
{
	Task_initial,		/*  создана, но не стартовала */
	Task_ready,		/*  готова к выполнению */
	Task_wait,		/*  ждет готовности файла или таймаут */
	Task_msg,		/*  ждет сообщения */
	Task_resp,		/*  ждет ответа */
	Task_zombie		/*  уже умерла, но еще не похоронена */
}
TaskState;

struct Task
{
	ListEl listel;

	List recvlist;		/*  входная очередь сообщений */
	List proclist;		/*  обрабатываемые сообщения */

	int isMain:1;
	int isInited:1;		/*  инициализирована и готова к выполнению */
	int isTimed:1;		/*  ждет таймаут */
	int isRead:1;		/*  ждет чтение из файла */
	int isWrite:1;		/*  ждет запись в файл */
	int isExcept:1;		/*  ждет sigexcept */

	char *name;		/*  имя задачи */
	long id;		/*  идентификатор задачи (pid) */
	long wakeUp;		/*  срок побудки задачи */

	Task *parent;		/*  родитель задачи, выполняющейся через spawn */
	int result;		/*  результат выполнения run() */

	TaskState state;	/*  состояние задачи */

	long stacklen;		/*  length of task's stack */

	jmp_buf taskEnv;	/* environment for context switching */
	char *stack;		/* this task's stack space */
	fd_set rfileset;	/* read-wait fileset */
	fd_set wfileset;	/* write-wait fileset */
	fd_set efileset;	/* except fileset */

	/*
	   #note russian
	   # Стартовая точка задачи. Этот метод должен быть переопределен
	   # в производном классе для выполнения реальной работы.
	   # Выход из метода run означает окончание задачи.
	 */
	int (*run) (void *data);
	void (*destroy) (void *data);
	void *data;
};

#ifdef OS_LINUX
#ifdef ARCH_S390
#define TASK_STACK_MIN        65536
#else
#define TASK_STACK_MIN        16384
#endif
#endif

#ifdef OS_AIX
#define TASK_STACK_MIN     49152
#endif

#ifdef OS_SUNOS
#define TASK_STACK_MIN        16384
#endif

#ifdef OS_SOLARIS_9
#define OS_SOLARIS_8
#endif

#ifdef OS_SOLARIS_8
#define TASK_STACK_MIN        16384*2
#endif

#ifndef TASK_STACK_MIN
#define TASK_STACK_MIN 4096
#endif

static List readyTasks =
{0, 0};				/*  активные задачи */
static List waitTasks =
{0, 0};				/*  ожидают ввода-вывода */
static List msgTasks =
{0, 0};				/*  ожидают сообщения */
static List respTasks =
{0, 0};				/*  ожидают ответа на сообщение */
static List zombieTasks =
{0, 0};				/*  законченные */

static HashTable *hashs;	/*  для поиска по номеру */
static Coll allTasks =
{0, 0, 0, 0, 0, 0};		/*  мешок для всех задач */

static Task *currTask = 0;	/*  текущая задача */
static Task *mainTask = 0;	/*  главная задача */
static Task *sheduler = 0;	/*  задача-планировщик */

static int seqNo = 0;		/*  постоянно-нарастающий номер */
static int activeCount = 0;	/*  количество активных задач (без zombie и без sheduler) */

/* флаги */
static int canSwitch = 0;	/*  переключение задач разрешено */

static fd_set readFiles;
static fd_set writeFiles;
static fd_set exceptFiles;
static jmp_buf shedEnv, mainEnv;

static void runSheduler(Task * task);	/*  выполняет sheduler */
static void initTask(Task * task);	/*  инициализирует taskEnv */
static int initStack(Task * task);	/*  инициализирует стек задачи */
static void initMainTask(Task * task);	/*  инициализирует главную задачу */
static void resumeTask(Task * task, int code);	/*  возвращает в точку taskEnv */

static void suicide(Task * task);

/* statics */
static void callTaskRun(Task * t);
static void deathMatch(void);

static void waitEvent(int block);
static long calcWakeup(long msec);

static void addToReady(Task * task);	/*  вставляет в список и устанавливает состояние */
static void addToWait(Task * task);
static void addToMsg(Task * task);
static void addToResp(Task * task);
static void addToZombie(Task * task);

static void removeFromList(Task * task);	/*  удаляет из списка, соответствующего состоянию */

#ifdef _WIN32
static int t_select(int nfds, fd_set * readfds, fd_set * writefds, fd_set * exceptfds,
	    struct timeval *timeout);
#else
#define t_select select
#endif


#define NEW(typ) ((typ*) calloc(sizeof(typ),1))

/*  ][ Message */

TASK_DLLEXPORT TaskMessage *
TaskMessage_new(long id, void *data, void (*destroy) (void *data))
{
	TaskMessage *msg = NEW(TaskMessage);

	msg->id = id;
	msg->data = data;
	msg->destroy = destroy;

	return msg;
}

TASK_DLLEXPORT void
TaskMessage_delete(TaskMessage * msg)
{
	if (!msg)
		return;

	if (msg->destroy)
		msg->destroy(msg->data);
}

TASK_DLLEXPORT long
TaskMessage_get_sender(TaskMessage * msg)
{
	return msg->sender;
}

TASK_DLLEXPORT long
TaskMessage_get_id(TaskMessage * msg)
{
	return msg->id;
}

TASK_DLLEXPORT void *
TaskMessage_get_data(TaskMessage * msg)
{
	return msg->data;
}

/*   Message ][ public Task */

static void
FD_CLR_BY(fd_set * fds, fd_set * mask)
{
	int i;

	for (i = 0;
	     i < sizeof(fd_set) / sizeof(unsigned);

	     i++, ((unsigned *) fds)++, ((unsigned *) mask)++
		)
		*((unsigned *) fds) &= ~(*((unsigned *) mask));
}

static void
FD_AND_BY(fd_set * fds, fd_set * mask)
{
	int i;

	for (i = 0;
	     i < sizeof(fd_set) / sizeof(unsigned);

	     i++, ((unsigned *) fds)++, ((unsigned *) mask)++
		)
		*((unsigned *) fds) &= *((unsigned *) mask);
}

static void
FD_SET_BY(fd_set * fds, fd_set * mask)
{
	int i;

	for (i = 0;
	     i < sizeof(fd_set) / sizeof(unsigned);

	     i++, ((unsigned *) fds)++, ((unsigned *) mask)++
		)
		*((unsigned *) fds) |= *((unsigned *) mask);
}

static int
FD_ISSET_BY(fd_set * fds, fd_set * mask)
{
	int i;

	for (i = 0;
	     i < sizeof(fd_set) / sizeof(unsigned);

	     i++, ((unsigned *) fds)++, ((unsigned *) mask)++
		)
		if (*((unsigned *) fds) & *((unsigned *) mask))
			return 1;
	return 0;
}

static void
calcTv(struct timeval *tv, long msec)
{
	if (msec == 0)
		msec = 1;
	tv->tv_sec = msec / 1000;
	tv->tv_usec = (msec % 1000) * 1000;
}

static struct tms tms_buf;

TASK_DLLEXPORT Task *
Task_new(const char *name, long stacksize, void *data
	 ,int (*run) (void *data), void (*destroy) (void *data))
{
	Task *task = NEW(Task);
	int psize;

	Task_init();

	++seqNo;
	task->id = seqNo;
	task->name = strdup(name);
	task->data = data;
	task->run = run;
	task->destroy = destroy;

	if (stacksize < TASK_STACK_MIN)
		stacksize = TASK_STACK_MIN;

	psize = getpagesize();
	if (stacksize >= psize)
	{
		int n = stacksize / psize;
		int rest = stacksize % psize;

		stacksize = n * psize + (rest ? psize : 0);
	}

	task->stacklen = stacksize;
	task->state = Task_initial;

	return task;
}

static void
initMainTask(Task * task)
{
	task->isMain = 1;
	task->isInited = 1;
	if (task->state == Task_initial)
		addToReady(task);
}

static int
initStack(Task * task)
{
	if (!task->isMain && task->state == Task_initial)
	{
		if (!task->stack)
		{
			task->stack = (char *) malloc(task->stacklen);
			return 1;
		}
	}
	return 0;
}

TASK_DLLEXPORT void
Task_delete(Task * task)
{
	if (task->destroy)
		task->destroy(task->data);

	free(task->name);

	if (!task->isMain)
	{
		free(task->stack);
		free(task);
	}
}

TASK_DLLEXPORT long
Task_get_id(Task * task)
{
	return task->id;
}

TASK_DLLEXPORT const char *
Task_get_name(Task * task)
{
	return task->name;
}

TASK_DLLEXPORT int
Task_get_count(void)
{
	return activeCount;
}

TASK_DLLEXPORT int
Task_spawn(Task * task, Task * chield)
{
	chield->parent = task;
	removeIt_List(&readyTasks, task);
	Task_start(chield);
	Task_yield();
	return task->result;
}

TASK_DLLEXPORT int
Task_wakeup(Task * task)
{
	if (task->state == Task_wait)
	{
		/*  разблокировать задачу */
		removeFromList(task);
		task->isTimed = 1;
		addToReady(task);
		if (task->isRead)
		{
			FD_CLR_BY(&readFiles, &task->rfileset);
			task->isRead = 0;
		}
		if (task->isWrite)
		{
			FD_CLR_BY(&writeFiles, &task->wfileset);
			task->isWrite = 0;
		}
		if (task->isExcept)
		{
			FD_CLR_BY(&exceptFiles, &task->efileset);
			task->isExcept = 0;
		}

		return 1;
	}

	return 0;
}

/*  ][ static Task */

static int task_inited = 0;

TASK_DLLEXPORT void
Task_init(void)
{
	Task *tp;

	if (task_inited)
		return;
	task_inited = 1;

	canSwitch = 0;
	seqNo = 0;
	activeCount = 0;

	FD_ZERO(&readFiles);
	FD_ZERO(&writeFiles);
	FD_ZERO(&exceptFiles);

	tp = Task_new("sheduler", 1024, 0, 0, 0);
	sheduler = tp;
	initStack(sheduler);

	hashs = new_HashTable();
	HashTable_insert(hashs, tp, tp->id);

	append_Coll(&allTasks, tp);

	currTask = sheduler;
	if (!setjmp(mainEnv))
	{
		initTask(sheduler);
	}

	tp = Task_new("main", 0, 0, 0, 0);
	mainTask = tp;
	initMainTask(mainTask);
	HashTable_insert(hashs, tp, tp->id);
	append_Coll(&allTasks, tp);

	currTask = mainTask;
}

TASK_DLLEXPORT Task *
Task_findTask(long taskid)
{
	Task_init();
	return HashTable_fetch(hashs, taskid);
}

TASK_DLLEXPORT Task *
Task_get_currTask()
{
	return currTask;
}

TASK_DLLEXPORT int
Task_start_sheduler(void)
{
	int ret = canSwitch;

	canSwitch = 1;
	return ret;
}

TASK_DLLEXPORT int
Task_stop_sheduler(void)
{
	int ret = canSwitch;

	canSwitch = 0;
	return ret;
}

TASK_DLLEXPORT int
Task_start(Task * tp)
{
	if (initStack(tp))
	{
		if (tp != sheduler)
			addToReady(tp);
		HashTable_insert(hashs, tp, tp->id);
		append_Coll(&allTasks, tp);
		return 1;
	}
	else
		return 0;
}

TASK_DLLEXPORT int
Task_kill(long taskid)
{
	Task *tp = Task_findTask(taskid);
	Task *ct = currTask;

	if (!tp)
		return 0;
	if (tp == ct || tp == mainTask || tp == sheduler)
		return 0;
	removeFromList(tp);
	addToReady(tp);

	if (!setjmp(ct->taskEnv))
		resumeTask(tp, 2);

	tp = Task_findTask(taskid);
	if (!tp)
		return 1;

	return 0;
}

TASK_DLLEXPORT int
Task_killAll(void)
{
	Task *tp, *ct;
	int r;

	if (currTask != mainTask)
		return 0;

	ct = currTask;
	if (!ct)
		return 0;

	/*  first, move all tasks into `ready` state */

	while (!empty_List(&waitTasks))
	{
		first_List(&waitTasks);
		tp = (Task *) waitTasks.current;
		removeIt_List(&waitTasks, tp);
		prepend_List(&readyTasks, tp);
		tp->state = Task_ready;
	}

	while (!empty_List(&msgTasks))
	{
		first_List(&msgTasks);
		tp = (Task *) msgTasks.current;
		removeIt_List(&msgTasks, tp);
		prepend_List(&readyTasks, tp);
		tp->state = Task_ready;
	}

	while (!empty_List(&respTasks))
	{
		first_List(&respTasks);
		tp = (Task *) respTasks.current;
		removeIt_List(&respTasks, tp);
		prepend_List(&readyTasks, tp);
		tp->state = Task_ready;
	}

	/*  spawned parents will be activated incrementally by them's chields */

	/*  now, activate all ready tasks with TaskKillException generation */

	setjmp(ct->taskEnv);

	for (r = first_List(&readyTasks); r; r = next_List(&readyTasks))
	{
		tp = (Task *) readyTasks.current;
		if (tp == mainTask)
			continue;
		resumeTask(tp, 2);
	}

	return 1;
}

TASK_DLLEXPORT long
Task_sleep(long msec)
{
	Task *tp;

	if (!canSwitch)
	{
		struct timeval tv;

		calcTv(&tv, msec);
		select(0, 0, 0, 0, &tv);
		return 1;
	}
	tp = currTask;
	tp->wakeUp = calcWakeup(msec);
	removeFromList(tp);
	addToWait(tp);
	tp->isTimed = 1;
	Task_yield();
	return !tp->isTimed;
}

TASK_DLLEXPORT int
Task_wait_read(int fd, long msec)
{
	Task *tp;
	struct timeval tv;
	fd_set set;
	int r;

	if (!canSwitch)
	{

		FD_ZERO(&set);
		FD_SET(fd, &set);
		calcTv(&tv, msec);
		r = t_select(FD_SETSIZE, &set, 0, 0, &tv);
		if (r > 0)
			return 0;
		else if (r == 0)
			return 1;
		else
			return r;
	}

	tp = currTask;

	FD_ZERO(&set);
	FD_SET(fd, &set);
	tv.tv_sec = tv.tv_usec = 0;
	r = t_select(FD_SETSIZE, &set, 0, 0, &tv);

	if (r != 0)
	{
		Task_yield();
		if (r > 0)
			return 0;
		else
			return r;
	}

	FD_ZERO(&tp->rfileset);
	FD_SET(fd, &tp->rfileset);

	tp->wakeUp = calcWakeup(msec);
	removeFromList(tp);
	tp->isRead = 1;
	addToWait(tp);
	tp->isTimed = 0;

	Task_yield();

	tp->isRead = 0;
	return tp->isTimed;
}

TASK_DLLEXPORT int
Task_wait_write(int fd, long msec)
{
	Task *tp;
	struct timeval tv;
	int r;

	if (!canSwitch)
	{
		fd_set set;

		FD_ZERO(&set);
		FD_SET(fd, &set);
		calcTv(&tv, msec);
		r = t_select(FD_SETSIZE, 0, &set, 0, &tv);
		if (r > 0)
			return 0;
		else if (r == 0)
			return 1;
		else
			return r;
	}

	tp = currTask;

	FD_ZERO(&tp->wfileset);
	FD_SET(fd, &tp->wfileset);
	tv.tv_sec = tv.tv_usec = 0;
	r = t_select(FD_SETSIZE, 0, &tp->wfileset, 0, &tv);

	if (r != 0)
	{
		Task_yield();
		if (r > 0)
			return 0;
		else
			return r;
	}

	FD_SET(fd, &tp->wfileset);

	tp->wakeUp = calcWakeup(msec);
	removeFromList(tp);
	tp->isWrite = 1;
	addToWait(tp);
	tp->isTimed = 0;

	Task_yield();

	tp->isWrite = 0;
	return tp->isTimed;
}

static long
calc_wakeup(struct timeval *tv)
{
	long n;

	if (!tv)
		return times(&tms_buf) + 60 * 60 * 24 * CLK_TCK;
	n = tv->tv_sec * CLK_TCK + tv->tv_usec / (1000000 / CLK_TCK);
	if (!n)
		n = 1;
	return times(&tms_buf) + n;
}

TASK_DLLEXPORT int
task_select(int nfds, fd_set * readfds, fd_set * writefds, fd_set * exceptfds,
	    struct timeval *timeout)
{
	struct timeval tv;
	int ret, r;
	Task *tp;

	if (!canSwitch)
	{
		ret = t_select(nfds, readfds, writefds, exceptfds, timeout);
		return ret;
	}

	tp = currTask;

	if (readfds)
	{
		tp->isRead = 1;
		tp->rfileset = *readfds;
	}
	else
		FD_ZERO(&tp->rfileset);

	if (writefds)
	{
		tp->isWrite = 1;
		tp->wfileset = *writefds;
	}
	else
		FD_ZERO(&tp->wfileset);

	if (exceptfds)
	{
		tp->isExcept = 1;
		tp->efileset = *exceptfds;
	}
	else
		FD_ZERO(&tp->efileset);

	tv.tv_sec = tv.tv_usec = 0;

	if (readfds||writefds||exceptfds)
	{
		ret = t_select(FD_SETSIZE, readfds, writefds, exceptfds, &tv);

		r = (ret != 0 || (timeout && !timeout->tv_sec && !timeout->tv_usec));
		if (r)
		{
			Task_yield();
			tp->isRead = 0;
			tp->isWrite = 0;
			tp->isExcept = 0;
			return ret;
		}
	}

	tp->wakeUp = calc_wakeup(timeout);
	removeFromList(tp);
	addToWait(tp);
	tp->isTimed = 0;

	Task_yield();

	tp->isRead = 0;
	tp->isWrite = 0;
	tp->isExcept = 0;

	if (readfds)
		*readfds = tp->rfileset;
	if (writefds)
		*writefds = tp->wfileset;
	if (exceptfds)
		*exceptfds = tp->efileset;
	ret = !tp->isTimed;

	return ret;
}

TASK_DLLEXPORT int
task_select_if(int fd, void *rp, void *wp, void *ep, void *to)
{
	return task_select(fd, (fd_set *) rp, (fd_set *) wp, (fd_set *) ep, (struct timeval *) to);
}

TASK_DLLEXPORT int
Task_sendMessage(long receiver, /* new */ TaskMessage * msg)
{
	Task *tp = Task_findTask(receiver);

	if (!tp)
		return 0;

	if (tp->state == Task_zombie)
		return 0;

	msg->needResp = 0;
	msg->needDel = 1;
	msg->receiver = tp->id;
	msg->sender = currTask->id;

	/*  добавляем сообщение во входную очередь задачи */
	append_List(&tp->recvlist, msg);

	/*  если задача ждет сообщения, активизируем ее */
	if (tp->state == Task_msg)
	{
		removeFromList(tp);
		addToReady(tp);
	}

	Task_yield();

	return 1;
}

TASK_DLLEXPORT int
Task_sendMessageWait(int receiver, TaskMessage * msg)
{
	Task *tp = Task_findTask(receiver);
	Task *ct;

	if (!tp)
		return 0;

	if (tp->state == Task_zombie)
		return 0;

	ct = currTask;

	msg->needResp = 1;
	msg->needDel = 1;
	msg->receiver = tp->id;
	msg->sender = ct->id;

	/*  добавляем сообщение во входную очередь задачи */
	append_List(&tp->recvlist, msg);

	/*  если задача ждет сообщения, активизируем ее */
	if (tp->state == Task_msg)
	{
		removeFromList(tp);
		addToReady(tp);
	}

	/*  ждем ответа */
	removeFromList(ct);
	addToResp(ct);

	Task_yield();

	return 1;
}

TASK_DLLEXPORT int
Task_sendAll(TaskMessage * msg)
{
	Task *ct = currTask;
	Task *tp;
	int sent = 0;

	msg->needResp = 1;
	msg->needDel = 0;
	msg->sender = ct->id;

	while (!empty_List(&msgTasks))
	{
		first_List(&msgTasks);
		tp = (Task *) msgTasks.current;
		msg->receiver = tp->id;

		/*  добавляем сообщение во входную очередь задачи */
		append_List(&tp->recvlist, msg);
		removeFromList(tp);
		addToReady(tp);

		/*  ждем ответа */
		removeFromList(ct);
		addToResp(ct);

		Task_yield();
		sent++;
	}

	TaskMessage_delete(msg);

	return sent;
}

TASK_DLLEXPORT TaskMessage *
Task_peekMessage(void)
{
	Task *ct;
	TaskMessage *mp;

	Task_yield();
	ct = currTask;
	if (empty_List(&ct->recvlist))
		return 0;
	first_List(&ct->recvlist);
	mp = (TaskMessage *) ct->recvlist.current;
	remove_List(&ct->recvlist);
	append_List(&ct->proclist, mp);
	return mp;
}

TASK_DLLEXPORT TaskMessage *
Task_getMessage(void)
{
	TaskMessage *mp;
	Task *ct = currTask;

	if (empty_List(&ct->recvlist))
	{
		/*  блокировка */
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
	return mp;
}

TASK_DLLEXPORT int
Task_forward(long receiver, TaskMessage * msg)
{
	Task *tp = Task_findTask(receiver);

	if (!tp)
		return Task_respond(msg);

	removeIt_List(&currTask->proclist, msg);

	/*  добавляем сообщение во входную очередь задачи */
	append_List(&tp->recvlist, msg);

	/*  если задача ждет сообщения, активизируем ее */
	if (tp->state == Task_msg)
	{
		removeFromList(tp);
		addToReady(tp);
	}

	return 1;
}

TASK_DLLEXPORT int
Task_respond(TaskMessage * msg)
{
	int ret = 1;

	if (msg->needResp)
	{
		Task *sender = Task_findTask(msg->sender);

		if (!sender)
			ret = 0;
		else if (sender->state != Task_resp)
			ret = 0;
		else
		{
			removeFromList(sender);
			addToReady(sender);
		}
	}

	removeIt_List(&currTask->proclist, msg);

	if (msg->needDel)
		TaskMessage_delete(msg);

	return ret;
}

/*   ][ private Task */

static void
callTaskRun(Task * t)
{
	if (t != sheduler)
	{
		t->result = t->run(t->data);	/*   call the main function ... */
		suicide(t);	/*   if it returns, the task wants to die */
	}
	else
		runSheduler(sheduler);	/*  or sheduler */
}

/*
 * SPARC's features
 * Constants defining a stack frame.
 */
#define WINDOWSIZE	(16*4)	/* size of window save area */
#define ARGPUSHSIZE	(6*4)	/* size of arg dump area */
#define ARGPUSH		(WINDOWSIZE+4)	/* arg dump area offset */
#define MINFRAME	(WINDOWSIZE+ARGPUSHSIZE+4)	/* min frame */

/*
 * Stack alignment macros.
 */
#define STACK_ALIGN	8
#define SA(X)	(((X)+(STACK_ALIGN-1)) & ~(STACK_ALIGN-1))

#ifdef OS_SOLARIS_8

static void
call_curr_task(void)
{
	callTaskRun(currTask);
}

#endif

static void
initTask(Task * task)
{
	static jmp_buf stkswitch;

	if (task->isInited)
		return;

	task->isInited = 1;	/*   we are initialized */

	/*   switch to private stack now */

	if (!setjmp(stkswitch))
	{
		unsigned char *sp = ((unsigned char *) task->stack) + task->stacklen;

		sp -= WINDOWSIZE + SA(MINFRAME);
		sp = (unsigned char *) ((unsigned long) (sp) & 0xfffffff8);
#undef UNKNOWN_SYSTEM
#define UNKNOWN_SYSTEM
#ifdef __TURBOC__
		uchar far *farstk = (uchar far *) sp;

		stkswitch[0].j_ss = FP_SEG(farstk);
		stkswitch[0].j_sp = FP_OFF(farstk);
#undef UNKNOWN_SYSTEM
#endif
#ifdef OS_LINUX
#ifdef ARCH_S390
		stkswitch[0].__jmpbuf[0].gregs[9] = (unsigned int) (stack + stklen - sizeof(jmp_buf));
#else
		stkswitch[0].__jmpbuf[4] = (int) sp;
#endif
#undef UNKNOWN_SYSTEM
#endif
#ifdef OS_BSDI
		stkswitch[2] = (unsigned) (sp);
#undef UNKNOWN_SYSTEM
#endif
#ifdef OS_FREEBSD
		stkswitch[0]._jb[2] = (unsigned) (sp);
#undef UNKNOWN_SYSTEM
#endif
#ifdef OS_NETBSD
		((unsigned *) &stkswitch)[2] = (unsigned) (sp);
#undef UNKNOWN_SYSTEM
#endif
#ifdef OS_OPENBSD
		((unsigned *) &stkswitch)[2] = (unsigned) (sp);
#undef UNKNOWN_SYSTEM
#endif
#ifdef OS_SUNOS
		stkswitch[0].__fp = task->stack + task->stacklen - sizeof(jmp_buf);
#undef UNKNOWN_SYSTEM
#endif
#ifdef OS_SOLARIS_8
#if defined(sparc) || defined(__sparc)
		stkswitch[1] = (long) sp;
		stkswitch[2] = (long) &call_curr_task;
		#undef UNKNOWN_SYSTEM
#elif defined(i386) || defined(__i386)
		stkswitch[4] = (long) sp;
		stkswitch[5] = (long) &call_curr_task;
		#undef UNKNOWN_SYSTEM
#endif
#endif
#ifdef _WIN32
		stkswitch[7] = (unsigned) (sp);
#undef UNKNOWN_SYSTEM
#endif
#ifdef DJGPP
		stkswitch[0].__esp = (unsigned) (sp);
#undef UNKNOWN_SYSTEM
#endif

		/*  ((unsigned*)&stkswitch)[ SP_IN_JMPBUF_NO ] = (unsigned int)stack + stklen - sizeof(jmp_buf); */
#ifdef UNKNOWN_SYSTEM
#error Unknown System!
#endif

		longjmp(stkswitch, 1);
	}

	/*  now is in private stack, start task running ... */
	callTaskRun(currTask);
	/*   ... and never return */
}

static void
resumeTask(Task * task, int code)
{
	if (task->state == Task_zombie)
		return;

	if (!task->isInited)
		initTask(task);
	else
	{
		longjmp(task->taskEnv, code);
	}
}

static void
suicide(Task * task)
{
	if (task->state == Task_zombie)
		return;

	removeFromList(task);

	if (task->parent)
	{
		task->parent->result = task->result;
		prepend_List(&readyTasks, task->parent);
		task->parent = 0;
	}

	/*  main task never must go into zombie state */
	if (!task->isMain)
		addToZombie(task);
	/*  jmp to sheduler */
	longjmp(shedEnv, 1);
}

TASK_DLLEXPORT int
Task_yield(void)
{
	Task *ct;
	int r;

	if (!canSwitch)
		return 0;

	ct = currTask;
	if (!ct)
		return 0;

	if ((r = setjmp(ct->taskEnv)) == 0)
		longjmp(shedEnv, 1);

	if (r == 2)
		return -1;

	return 0;
}

static void
waitEvent(int block)
{
	struct timeval tv;
	fd_set rfds, wfds, efds;
	int r, r1, n;
	long tim, dt;

	Task *tp;

	if (empty_List(&waitTasks))
		return;

	/*  check timeouts */
	tim = times(&tms_buf);

	n = 0;
	for (first_List(&waitTasks); (tp = (Task *) waitTasks.current);)
	{
		if (tp->wakeUp <= tim)
		{
			remove_List(&waitTasks);
			prepend_List(&readyTasks, tp);
			tp->state = Task_ready;
			tp->isTimed = 1;
			if (tp->isRead)
			{
				FD_CLR_BY(&readFiles, &tp->rfileset);
				tp->isRead = 0;
			}
			if (tp->isWrite)
			{
				FD_CLR_BY(&writeFiles, &tp->wfileset);
				tp->isWrite = 0;
			}
			if (tp->isExcept)
			{
				FD_CLR_BY(&exceptFiles, &tp->efileset);
				tp->isExcept = 0;
			}
			n = 1;
		}
		else
			break;
	}

	if (empty_List(&waitTasks))
		return;

	if (n)
		block = 0;

	/*  check files */

	if (block)
	{
		dt = ((Task *) waitTasks.current)->wakeUp - tim + 1;
		tv.tv_sec = dt / CLK_TCK;
		tv.tv_usec = (dt % CLK_TCK) * (1000000 / CLK_TCK);
	}
	else
	{
		tv.tv_sec = 0;
		tv.tv_usec = 0;
	}

	rfds = readFiles;
	wfds = writeFiles;
	efds = exceptFiles;

	/*  main program waitpoint */
	r = t_select(FD_SETSIZE, &rfds, &wfds, &efds, &tv);
	if (r > 0)
	{
		for (n = first_List(&waitTasks); n && (tp = (Task *) waitTasks.current);)
		{
			r1 = tp->isRead;
			if (r1)
				r1 = FD_ISSET_BY(&rfds, &(tp->rfileset));
			if (!r1 && tp->isWrite)
				r1 = FD_ISSET_BY(&wfds, &(tp->wfileset));
			if (!r1 && tp->isExcept)
				r1 = FD_ISSET_BY(&efds, &(tp->efileset));
			if (r1)
			{
				remove_List(&waitTasks);
				prepend_List(&readyTasks, tp);
				tp->state = Task_ready;
				n = !empty_List(&waitTasks);
				FD_AND_BY(&(tp->rfileset), &rfds);
				FD_AND_BY(&(tp->wfileset), &wfds);
				FD_AND_BY(&(tp->efileset), &efds);
				tp->isRead = 0;
				tp->isWrite = 0;
				tp->isExcept = 0;
				continue;
			}
			n = next_List(&waitTasks);
		}
		FD_CLR_BY(&readFiles, &rfds);
		FD_CLR_BY(&writeFiles, &wfds);
		FD_CLR_BY(&exceptFiles, &efds);
	}

	if (block)
	{
		/*  again check timeouts */
		tim = times(&tms_buf);

		for (first_List(&waitTasks); (tp = (Task *) waitTasks.current);)
		{
			if (tp->wakeUp <= tim)
			{
				remove_List(&waitTasks);
				prepend_List(&readyTasks, tp);
				tp->state = Task_ready;
				tp->isTimed = 1;
				if (tp->isRead)
				{
					FD_CLR_BY(&readFiles, &tp->rfileset);
					tp->isRead = 0;
				}
				if (tp->isWrite)
				{
					FD_CLR_BY(&writeFiles, &tp->wfileset);
					tp->isWrite = 0;
				}
				if (tp->isExcept)
				{
					FD_CLR_BY(&exceptFiles, &tp->efileset);
					tp->isExcept = 0;
				}
			}
			else
				break;
		}

	}

}

static long
calcWakeup(long msec)
{
	long n, ret;

	if (msec < 0)
	{			/*  one day will enought? */
		ret = (long) times(&tms_buf) + 60 * 60 * 24 * CLK_TCK;
		return ret;
	}
	n = msec / (1000 / CLK_TCK);
	if (n < 1)
		n = 1;
	ret = times(&tms_buf) + n;
	return ret;
}

static void
addToReady(Task * task)
{
	activeCount++;
	prepend_List(&readyTasks, task);
	task->state = Task_ready;
}

static void
addToWait(Task * task)
{
	int n;

	activeCount++;
	if (task->isRead)
	{
		FD_SET_BY(&readFiles, &task->rfileset);
	}
	if (task->isWrite)
	{
		FD_SET_BY(&writeFiles, &task->wfileset);
	}
	if (task->isExcept)
	{
		FD_SET_BY(&exceptFiles, &task->efileset);
	}

	task->state = Task_wait;

	for (n = first_List(&waitTasks); n; n = next_List(&waitTasks))
	{
		Task *tp = (Task *) waitTasks.current;

		if (task->wakeUp <= tp->wakeUp)
		{
			insertBefore_List(&waitTasks, task);
			return;
		}
	}

	append_List(&waitTasks, task);
}

static void
addToMsg(Task * task)
{
	activeCount++;
	prepend_List(&msgTasks, task);
	task->state = Task_msg;
}

static void
addToResp(Task * task)
{
	activeCount++;
	prepend_List(&respTasks, task);
	task->state = Task_resp;
}

static void
addToZombie(Task * task)
{
	prepend_List(&zombieTasks, task);
	task->state = Task_zombie;
}

static void
removeFromList(Task * task)
{
	activeCount--;
	switch (task->state)
	{
	case Task_ready:
		removeIt_List(&readyTasks, task);
		break;
	case Task_wait:
		removeIt_List(&waitTasks, task);
		break;
	case Task_msg:
		removeIt_List(&msgTasks, task);
		break;
	case Task_resp:
		removeIt_List(&respTasks, task);
		break;
	case Task_zombie:
		removeIt_List(&zombieTasks, task);
		break;
	case Task_initial:
		break;
	}
}

static
void
runSheduler(Task * task)
{
	int code;

#if 0
	signal(SIGPIPE, SIG_IGN);
#ifdef DJGPP
	signal(SIGINT, SIG_IGN);
#endif
#endif
	/* first time all what we need is set shedEnv for future */
	if (!(code = setjmp(shedEnv)))
		longjmp(mainEnv, 1);

	/*  destroy all zombie tasks */
#if 1
	while ( first_List(&zombieTasks) )
	{
		Task *tp = (Task *) zombieTasks.current;
		removeFromList(tp);
		Task_delete(tp);
	}
#if 0
	while (!zombieTasks.empty())
	{
		zombieTasks.first();
		ref Task tp = zombieTasks.get_current();

		zombieTasks.remove();
		hashs.remove(tp.hash());
		allTasks.get(tp);
	}
#endif
#endif

	while (code > 0)
	{
		if (Next_List(&readyTasks))
			waitEvent(0);
		else if (empty_List(&waitTasks))
		{
			/*  deathmatch? - no active and no wait tasks; */
			/*  message-queued tasks cannot be self-activated */
			deathMatch();
			continue;
		}
		else
		{
			waitEvent(1);
			continue;
		}
		/*  take task from ready queue... */
		currTask = (Task *) readyTasks.current;
		/*  ... and switch to one's context */
		resumeTask(currTask, 1);
	}

	/*  never reached point! */
	currTask = 0;
	longjmp(mainEnv, 1);
}

static void
deathMatch(void)
{
	fprintf(stderr, "abnormal Task sheduler state, abort\n");
	fflush(stderr);
	abort();
}


#ifdef _WIN32

	#ifdef OS_CYGWIN
		#include <w32api/windows.h>
	#else
		#include <windows.h>
	#endif

extern HANDLE w32_hStdIn;
static int
zero_fds(fd_set *fds)
{
	int i;
	for (i = 0; i < sizeof(fd_set) / sizeof(unsigned);
		     i++, ((unsigned *) fds)++)
		if (*((unsigned *) fds) )
			return 0;
	return 1;
}

static int
t_select(int nfds, fd_set * readfds, fd_set * writefds, fd_set * exceptfds,
	    struct timeval *timeout)
{
	int r = 0;
	long ms_timeout = 0;

	if (!readfds || ! FD_ISSET(0, readfds))
		return select(nfds, readfds, writefds, exceptfds, timeout);

	if (w32_hStdIn == INVALID_HANDLE_VALUE)
		w32_hStdIn = GetStdHandle(STD_INPUT_HANDLE);

	if (w32_hStdIn == INVALID_HANDLE_VALUE)
		return select(nfds, readfds, writefds, exceptfds, timeout);

	if (timeout)
		ms_timeout = timeout->tv_sec * 1000 + timeout->tv_usec/1000;
	else
		ms_timeout = 1000 * 60 * 60 * 24;

	FD_CLR(0, readfds);

	if (zero_fds(readfds) && !writefds && !exceptfds)
	{
		r = WaitForMultipleObjects(1, &w32_hStdIn, 1, ms_timeout);
		if (r == WAIT_OBJECT_0)
		{
			FD_SET(0, readfds);
			return 1;
		}
		else
			return 0;
	}

	while (ms_timeout>0)
	{
		struct timeval tv;
		long wait;

		r = WaitForMultipleObjects(1, &w32_hStdIn, 1, 0);
		if (r == WAIT_OBJECT_0)
		{
			tv.tv_sec = 0;
			tv.tv_usec = 0;
			r = select(nfds, readfds, writefds, exceptfds, &tv);
			FD_SET(0, readfds);
			if (r>=0)
				return r+1;
			return r;
		}

		if (ms_timeout>100)
			wait = 100;
		else
			wait = ms_timeout;
		ms_timeout -= wait;

		tv.tv_sec = wait/1000;
		tv.tv_usec = (wait%1000) * 1000;

		r = select(nfds, readfds, writefds, exceptfds, &tv);

		if (r)
			return r;
	}

	return 0;
}

#endif

/*  ][ */
