/* $Log$
/* Revision 1.8  2007/03/09 09:19:20  itk
/* uri:small fix
/*
 Revision 1.7  2007/02/21 12:56:20  itk
 uri: small fix, HZ.

 Revision 1.6  2007/01/31 13:48:21  itk
 uri:some new code for pth

 Revision 1.5  2007/01/30 13:43:06  itk
 *** empty log message ***

 Revision 1.4  2007/01/24 13:05:45  itk
 uri: new task model under PTH minimal works !

 Revision 1.3  2007/01/23 14:12:10  itk
 uri: some new code for new tasks

 Revision 1.2  2007/01/23 10:46:22  itk
 uri: some redisign for new task model

 Revision 1.1  2007/01/22 12:38:02  itk
 uri: initial pth support

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

void *
run(void *data)
{
	int i;
	void *ret=NULL;

	for (i = 0; i < 5; i++)
	{
		printf("task %ld cycle %d\n", Task_get_id(Task_get_currTask()), i);
		Task_sleep(100);
	}
	return ret;
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
