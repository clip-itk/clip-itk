/*
   Copyright (C) 2007  ITK
   Author   : Uri <uri@itk.ru>
   License : (GPL) http://www.itk.ru/clipper/license.html
 */
/*
 $Log$
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

static int pth_inited = 0;
static int stopcount = 0;

TASK_DLLEXPORT long
Task_version(void)
{
	return pth_version();
}

TASK_DLLEXPORT int
Task_yield(void)
{
	pth_t task;

	if (pth_inited)
	{
		task = pth_self();
		pth_yield(task);
	}

	return 0;
}

TASK_DLLEXPORT long 
Task_ID()
{
	long id;
	pth_t ptask;
	ptask = pth_self();
	id = (long) ptask;
	return id;
}

TASK_DLLEXPORT long
Task_sleep(long msec)
{
	pth_usleep(msec*1000);
	return 0;
}

TASK_DLLEXPORT int
Task_start_sheduler(void)
{
	return 0;
}

TASK_DLLEXPORT Task *
Task_new(const char *name, long stacksize, void *data
	 ,void *(*run) (void *data), void (*destroy) (void *data))
{
	Task *task = NEW(Task);
	pth_t ptask;
	pth_attr_t attr;

        attr = pth_attr_new();
        pth_attr_set(attr, PTH_ATTR_NAME, name);

	if ( pth_inited == 0)
	{
		pth_init();
		pth_inited = 1;
	}

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


	if (stacksize < TASK_STACK_MIN)
		stacksize = TASK_STACK_MIN;

	task->stacklen = stacksize;
	/*task->state = Task_initial;*/

	return task;
}

TASK_DLLEXPORT int
Task_start(Task *tp)
{
	int rc;
	void *val;
	rc = pth_join((pth_t)tp->ref, &val);
        if (rc == FALSE)
		return 0;
	return 1;
}
