/* $Log$
/* Revision 1.1  2007/01/22 12:38:02  itk
/* uri: initial pth support
/*
 Revision 1.1  2006/06/22 19:35:35  itk
 uri: init sf.net repository

 Revision 1.2  2005/11/26 16:25:48  clip
 uri: rename task_select_if -> clip_task_select_if
      It is openBsd pheatures.

 Revision 1.1  2001/11/12 14:13:46  clip
 START(cFuncname) now work :)
 paul
 */

#include <stdio.h>
#include "task.h"

int
run(void *data)
{
	int i;

	for (i = 0; i < 5; i++)
	{
		printf("task %ld cycle %d\n", Task_get_id(Task_get_currTask()), i);
		Task_sleep(100);
	}
	return 0;
}

int
main(int argc, char **argv)
{
	int i;
	Task *tp;

	for (i = 0; i < 3; i++)
	{
		tp = Task_new("task_test", 8192, 0, run, 0);
		Task_start(tp);
	}

	Task_start_sheduler();

	for (i = 0; i < 15; i++)
	{
		printf("main task: cycle %d\n", i);
		Task_sleep(50);
	}

	/*Task_killAll(); */
	return 0;

}