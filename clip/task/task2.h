/*
   Copyright (C) 2007  ITK
   Author   : Uri <uri@itk.ru>
   License : (GPL) http://www.itk.ru/clipper/license.html
 */
/*
 $Log$
 Revision 1.1  2007/01/23 10:46:23  itk
 uri: some redisign for new task model

 */


#define TASK_STACK_MIN        16384
#define NEW(typ) ((typ*) calloc(sizeof(typ),1))

#include "../list.h"
#include "../coll.h"
#include "../hash.h"

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


static int seqNo = 0;		/*  постоянно-нарастающий номер */
