/*
   Copyright (C) 2007  ITK
   Author   : Uri <uri@itk.ru>
   License : (GPL) http://www.itk.ru/clipper/license.html
 */
/*
 $Log$
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

TASK_DLLEXPORT int 
Task_version(void)
{
	return pth_version();
}

TASK_DLLEXPORT Task *
Task_new(const char *name, long stacksize, void *data
	 ,int (*run) (void *data), void (*destroy) (void *data))
{
	Task *task = NEW(Task);

	if ( pth_inited == 0)
	{
		pth_init();
		pth_inited = 1;
	}

	++seqNo;
/*
	task->id = seqNo;
	task->name = strdup(name);
	task->data = data;
	task->run = run;
	task->destroy = destroy;
*/

	if (stacksize < TASK_STACK_MIN)
		stacksize = TASK_STACK_MIN;



	task->stacklen = stacksize;
	/*task->state = Task_initial;*/

	return task;
}
