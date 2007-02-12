/*
   Copyright (C) 2001  ITK
   Author   : Paul Lasarev <paul@itk.ru>
   License : (GPL) http://www.itk.ru/clipper/license.html
 */
/*
 $Log$
 Revision 1.6  2007/02/12 16:13:08  itk
 uri: some fix about task_select and some fix for amd64

 Revision 1.5  2007/01/23 14:12:12  itk
 uri: some new code for new tasks

 Revision 1.4  2007/01/23 10:46:23  itk
 uri: some redisign for new task model

 Revision 1.3  2007/01/22 12:38:02  itk
 uri: initial pth support

 Revision 1.1  2006/06/22 19:35:35  itk
 uri: init sf.net repository

 Revision 1.4  2005/11/26 16:25:48  clip
 uri: rename task_select_if -> clip_task_select_if
      It is openBsd pheatures.

 Revision 1.3  2001/11/14 06:38:02  clip
 fix crash on exit after START
 paul

 Revision 1.2  2001/11/13 09:31:37  clip
 START('funcname'[, arg1 ... argN])
 can now put arg1-argN to call of funcname
 paul

 Revision 1.1  2001/11/12 14:13:46  clip
 START(cFuncname) now work :)
 paul
 */

#ifndef TASK_H
#define TASK_H

#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>


typedef struct TaskMessage TaskMessage;
typedef struct Task Task;

void Task_INIT(void); /* return version of library */
long Task_version(); /* return version of library */
void Task_init(); /* init task internals */
void Task_START();
void Task_STOP();
long Task_ID();

TaskMessage *TaskMessage_new(long id
	, void *data, void (*destroy)(void *data));

void TaskMessage_delete(TaskMessage *msg);

long TaskMessage_get_sender(TaskMessage *msg);
long TaskMessage_get_id(TaskMessage *msg);
void *TaskMessage_get_data(TaskMessage *msg);

/*
	#note russian
	# �����������������
	#
	# ��� ��� ������������� �������
	# ������� ���������������
	# ����������������������(����� ���.
	# ���������� ������������ ���
	# start_sheduler.
	#
	# �������������� ��� ����	# yield, sleep, wait_read, wait_write, sendMessage, sendRespMessage,
	# sendAll, peekMessage, getMessage, respond, forward
	#
	# ���� ���� ���/�������������� -
	# ���������
	#
	# ��� ���� C-����task_select, ��������������
	# ��� ������select C-������ (��� ��Sun rpc)
	#
	# int task_select(int nfds, fd_set *readfds, fd_set *writefds, fd_set *exceptfds,
	#     struct timeval *timeout)
*/


Task *Task_new(const char *name, long stacksize, void *data
	, void * (* run)(void *data), void (* destroy)(void *data));

void Task_delete(Task *task);

long Task_get_id(Task *task);

const char *Task_get_name(Task* task);

int Task_get_count(void);
/*
	#note russian
	# ����� ���������� ���(��sheduler �zombie)
*/

void * Task_spawn(Task *task, Task *chield);
/*
	#note russian
	# �����chield ������������ �������
*/

int Task_wakeup(Task *task);
/*
	#note russian
	# ������� ������� sleep/wait_read/wait_write
*/


Task *Task_findTask(long taskid);
/*
	 �� ��� � �������
*/

Task *Task_get_currTask();
/*
	#note russian
	# ����� ��� � �������
*/


  /* //////// ����� ���� ///////////// */

int Task_start_sheduler(void);
/*
	#note russian
	# ����������������������� ���*/

int Task_stop_sheduler(void);
/*
	#note russian
	# �������������(������� ���
*/

int Task_start(Task *tp);
/*
	#note russian
	# ���� ��� ��������� �� ������ ��	# ��� ����� � ���� ����������
*/

int Task_kill(long taskid);
/*
	#note russian
	# ����� ����� ���; �������������	# ��� ����� ����� TaskKillException
	# � �������� ������������.
*/

int Task_killAll(void);
/*
	#note russian
	# ����� �����, ������� ����� TaskKillException.
	# ��� ����� ��� � ����������.
	# ����� true �� �����, ������� ����������.
	# �� ���� ��� �������TaskKillException �����
	# � ������ ����� �������������� ����	# ��� �� ��� � ����� (��� ���� ����� �
	# ���  run ), �������.
	# ���Task::killAll() ��� ������� ��� �������	# �������������� ���������, ��������	# ������������ ���. ������ ����� ����
	# ������������ ��� Task, �� ��������
	# ������ ���������Task ���������������	# ���������� ������� Task, ���� �������
	# ����������� killAll().
*/

int Task_yield(void);
/*
	#note russian
	# ������� ����� ������ ���
*/

long Task_sleep(long millisec);
/*
	#note russian
	# ���� ����.
*/

int Task_wait_read(int fd, long msec);
/*
	#note russian
	# ���� ����� ���� ��� ������*/

int Task_wait_write(int fd, long msec);
/*
	#note russian
	# ���� ����� ���� ��� ������*/

int task_select(int nfds, fd_set *readfds, fd_set *writefds, fd_set *exceptfds,
		struct timeval *timeout);

int clip_task_select_if(int fd, void *rp, void *wp, void *ep, void *to);

/* ////////// ���������/////////////// */

int Task_sendMessage(long receiver, /* new */ TaskMessage *msg);
/*
	#note russian
	# ��������������� ���
	# �� receiver==0, � ���������� �������
	msg �����������*/

int Task_sendMessageWait(int receiver, TaskMessage *msg);
/*
	#note russian
	# ����������������� ��������
	msg �����������*/

int Task_sendAll(TaskMessage *msg);
/*
	#note russian
	# ����������� ���� ������ �����	# ����� ��� ������*/

TaskMessage *Task_peekMessage(void);
/*
	#note russian
	# ����������� ���������	# �� ������� ����� null
	# �� ��, ������������ ����*/

TaskMessage *Task_getMessage(void);
/*
	#note russian
	# �� ������� ������*/

int Task_respond(TaskMessage *msg);
/*
	#note russian
	# ����� �����������������,
	# �� ����� ����� ���.
	# �������� �������� ��������� ��
	# ���� �� ����forward, ������������
	# ��������� �������.
*/

int Task_forward(long receiver, TaskMessage *msg);
/*
	#note russian
	# ����� �������� ���
*/

#endif
