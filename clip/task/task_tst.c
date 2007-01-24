/* $Log$
/* Revision 1.5  2007/01/24 13:05:45  itk
/* uri: new task model under PTH minimal works !
/*

 Revision 1.4  2007/01/23 14:12:14  itk
 uri: some new code for new tasks


 Revision 1.3  2007/01/23 10:46:23  itk
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
	void *ret = NULL;

	for (i = 0; i < 5; i++)
	{
		printf("task %ld cycle %d\n", Task_ID(), i);
		Task_sleep(50);
	}
	return ret;
}

int
main(int argc, char **argv)
{
	int i;
	Task *tp;
	
	printf("\nbegin. version=%ld\n",Task_version());
	printf("\nAAAA\n");
	for (i = 0; i < 3; i++)
	{
		tp = Task_new("task_test", 8192, 0, run, 0);
//    		printf("\nBBBB=%d,%p\n",i,tp);
		Task_start(tp);
		Task_sleep(50);
//		printf("\nCCCCC=%d\n",i);
	}

	printf("\nDDDDD\n");
	Task_start_sheduler();

	for (i = 0; i < 7; i++)
	{
		printf("main task: cycle %d\n", i);
		Task_sleep(100);
	}

	/*Task_killAll(); */
	return 0;

}
