/*
    Copyright (C) 2001  ITK
    Author   : Paul Lasarev <paul@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
/*
   $Log: _thread.c,v $
   Revision 1.12  2001/11/26 07:51:09  clip
   start() now can take reference to (possible static) function or codeblock
   as first parameter
   paul

   Revision 1.11  2001/11/14 13:07:21  clip
   add TASKSENDMSG, TASKPEEKMSG, TASKGETMSG functions
   paul

   Revision 1.10  2001/11/14 12:01:51  clip
   seq_no
   paul

   Revision 1.9  2001/11/14 06:38:02  clip
   fix crash on exit after START
   paul

   Revision 1.8  2001/11/13 13:43:24  clip
   uri: __file__ -> __FILE__

   Revision 1.7  2001/11/13 12:31:01  clip
   share functions between tasks
   TASKID() function
   paul

   Revision 1.6  2001/11/13 11:22:12  clip
   TASKSTOP() stop task switching
   TASKSTART() start task switching
   TASKSTOP()/TASKSTART() pairs may be nested
   paul

   Revision 1.5  2001/11/13 09:31:37  clip
   START('funcname'[, arg1 ... argN])
   can now put arg1-argN to call of funcname
   paul

   Revision 1.4  2001/11/12 14:13:46  clip
   START(cFuncname) now work :)
   paul

   Revision 1.3  2001/04/03 09:17:00  clip
   license errors
   paul

   Revision 1.2  2001/03/30 11:51:02  clip
   add copyright

   Revision 1.1  2000/08/01 12:05:37  clip
   append _thread.c
   Paul Lasarev <paul@itk.ru>

*/

#include <string.h>

#include "clip.h"
#include "error.ch"
#include "hashcode.h"

#ifdef USE_TASKS

#include "task/task.h"

typedef struct
{
	ClipMachine *mp;
	char *name;
	ClipVar block;
	ClipVar *stack;
	int argc;
}
start_data;

static int
task_run(void *data)
{
	start_data *sp = (start_data*) data;
	ClipMachine *mp = sp->mp;
	int r;

	sp->mp = new_ClipMachine(mp->screen);

	if (sp->name)
		r = _clip_clip(sp->mp, sp->name, sp->argc, sp->stack, 0);
	else
		r = _clip_eval(sp->mp, &sp->block, sp->argc, sp->stack, 0);

	if (r)
		_clip_logg(0, "task_run: cannot start function '%s'", sp->name);

	return r;
}

static void
task_destroy(void *data)
{
	start_data *sp = (start_data*) data;
	int i;

	for(i=0; i<sp->argc+1; i++)
		_clip_destroy(sp->mp, sp->stack+i);

	if (sp->name)
		free(sp->name);
	else
		_clip_destroy(sp->mp, &sp->block);


	delete_ClipMachine(sp->mp);
	free(sp);
}


/*
 *    taskid := start(main_func)
 */
int
clip_START(ClipMachine * mp)
{
	Task *tp;
	char *name, *tname="block";
	start_data *sp;
	int argc = mp->argc-1;
	int i;
	ClipVar *stack;
	static int first = 1;
	int type;


	type = _clip_parinfo(mp, 1);
	if (type != CHARACTER_t && type != CCODE_t && type != PCODE_t)
		return EG_ARG;

	name = _clip_parc(mp, 1);

	stack = (ClipVar *) malloc(sizeof(ClipVar) * (argc + 1));
	memset(stack, 0, sizeof(ClipVar) * (argc + 1));

	for (i = 0; i < argc; ++i)
		_clip_clone(mp, stack + i, ARGPTR(mp, i + 2));

	sp = (start_data*) calloc(sizeof(start_data), 1);
	sp->stack = stack;
	sp->argc = argc;
	if (name)
		tname = sp->name = strdup(name);
	else
		_clip_clone(mp, &sp->block, _clip_spar(mp, 1));
	sp->mp = mp;

	tp = Task_new(tname, 4096*32, sp, task_run, task_destroy);

	_clip_retnl(mp, Task_get_id(tp));

	Task_start(tp);
	if (first)
	{
		Task_start_sheduler();
		first = 0;
	}
	Task_yield();

	return 0;
}


static int stopcount = 0;



#else

int
clip_START(ClipMachine * mp)
{
	_clip_trap_printf(mp, __FILE__, __LINE__, "TASK sheduler not implemented for OS %s", OSNAME);
	return _clip_call_errblock(mp, 1);
}

#endif

int
clip_TASKSTOP(ClipMachine * mp)
{
#ifdef USE_TASKS
	if (!stopcount)
	{
		if (Task_get_currTask())
			Task_stop_sheduler();
	}

	++stopcount;
#endif
	return 0;
}

int
clip_TASKSTART(ClipMachine * mp)
{
#ifdef USE_TASKS
	--stopcount;
	if (stopcount <= 0)
	{
		if (Task_get_currTask())
		{
			Task_start_sheduler();
			Task_yield();
		}
		stopcount = 0;
	}
#endif
	return 0;
}

/*
	TASKID() -> nID (-1 if no active tasks)
*/
int
clip_TASKID(ClipMachine *mp)
{
#ifdef USE_TASKS
	Task *tp = Task_get_currTask();

	if (!tp)
		_clip_retni(mp, -1);

	_clip_retnl(mp, Task_get_id(tp));
#endif
	return 0;
}

#ifdef USE_TASKS

typedef struct
{
	ClipMachine *mp;
	ClipVar var;
}
msg_data;

static void
msg_data_destroy(void *data)
{
	msg_data *m = (msg_data *) data;
	_clip_destroy(m->mp, &m->var);
	free(m);
}

static msg_data *
msg_data_new(ClipMachine *mp, ClipVar *vp)
{
	msg_data *rp;

	rp = (msg_data *) calloc(sizeof(msg_data), 1);
	rp->mp = mp;
	_clip_clone(mp, &rp->var, vp);

	return rp;
}

#endif

/*
	TaskSendMsg( nReceiverID, vMsg [, lWaitProcessed] ) --> lResult
	send var vMsg to task with id nReceiverID
*/
int
clip_TASKSENDMSG(ClipMachine * mp)
{
#ifdef USE_TASKS
	long receiver;
	ClipVar *vp;
	int wait = 0, r;
	TaskMessage *tp;

	if (mp->argc<2)
		return EG_ARG;

	receiver = _clip_parnl(mp, 1);
	vp = _clip_par(mp, 2);
	wait = _clip_parl(mp,3);
	tp = TaskMessage_new(HASH_VarMessage, msg_data_new(mp, vp), msg_data_destroy);

	if (wait)
		r = Task_sendMessageWait(receiver, tp);
	else
		r = Task_sendMessage(receiver, tp);

	_clip_retl(mp, r);

#endif
	return 0;
}

/*
	TaskPeekMsg() -> vMsg|NIL
	try peek message from task input queue
	If no messages available, immediate return NIL
*/
int
clip_TASKPEEKMSG(ClipMachine * mp)
{
#ifdef USE_TASKS
	TaskMessage *tp;

	tp = Task_peekMessage();
	if (tp)
	{
		msg_data *m;
		m = (msg_data*) TaskMessage_get_data(tp);
		_clip_clone(mp, RETPTR(mp), &m->var);
		Task_respond(tp);
	}

#endif
	return 0;
}

/*
	TaskGetMsg() -> vMsg
	get message from task input queue
	If no messages available, wait forever
*/
int
clip_TASKGETMSG(ClipMachine * mp)
{
#ifdef USE_TASKS
	TaskMessage *tp;

	tp = Task_getMessage();
	if (tp)
	{
		msg_data *m;
		m = (msg_data*) TaskMessage_get_data(tp);
		_clip_clone(mp, RETPTR(mp), &m->var);
		Task_respond(tp);
	}

#endif
	return 0;
}




