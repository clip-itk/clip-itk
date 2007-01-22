/*
   Copyright (C) 2001  ITK
   Author   : Paul Lasarev <paul@itk.ru>
   License : (GPL) http://www.itk.ru/clipper/license.html
 */
/*
 $Log$
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

void Task_init(void); /* init task internals */

TaskMessage *TaskMessage_new(long id
	, void *data, void (*destroy)(void *data));

void TaskMessage_delete(TaskMessage *msg);

long TaskMessage_get_sender(TaskMessage *msg);
long TaskMessage_get_id(TaskMessage *msg);
void *TaskMessage_get_data(TaskMessage *msg);

/*
	#note russian
	# Кооперативный переключатель задач.
	#
	# Каждая задача выполняется в своем стеке, кроме главной.
	# Главная задача выполняется в системном стеке.
	# Планировщик задач выполняется как отдельная (служебная) задача.
	# Планировщик начинает выполняться после вызова метода
	# start_sheduler.
	#
	# Задачи переключаются в момент вызова методов
	# yield, sleep, wait_read, wait_write, sendMessage, sendRespMessage,
	# sendAll, peekMessage, getMessage, respond, forward
	#
	# Основное средство обмена/синхронизации между задачами -
	# обмен сообщениями.
	#
	# Модуль включает C-функцию task_select, которая может использоваться
	# вместо стандартной select C-библиотеками (такими как Sun rpc)
	#
	# int task_select(int nfds, fd_set *readfds, fd_set *writefds, fd_set *exceptfds,
	#     struct timeval *timeout)
*/


Task *Task_new(const char *name, long stacksize, void *data
	, int (* run)(void *data), void (* destroy)(void *data));

void Task_delete(Task *task);

long Task_get_id(Task *task);

const char *Task_get_name(Task* task);

int Task_get_count(void);
/*
	#note russian
	# возвращает общее число активных задач (без sheduler и zombie)
*/

int Task_spawn(Task *task, Task *chield);
/*
	#note russian
	# запускает chield в отдельном стеке и ждет его завершения
*/

int Task_wakeup(Task *task);
/*
	#note russian
	# принудительный обрыв ожидания sleep/wait_read/wait_write
*/


Task *Task_findTask(long taskid);
/*
	 ищет задачу по идентификатору
*/

Task *Task_get_currTask();
/*
	#note russian
	# возвращает ссылку на текущую задачу
*/


  /* //////// управление задачами ///////////// */

int Task_start_sheduler(void);
/*
	#note russian
	# запускает планировщик и разрешает переключение задач
*/

int Task_stop_sheduler(void);
/*
	#note russian
	# останавливает планировщик (и переключение задач)
*/

int Task_start(Task *tp);
/*
	#note russian
	# стартует задачу в отдельном стеке, т.е. создает стек для
	# задачи и помещает ее в список готовых к выполнению
*/

int Task_kill(long taskid);
/*
	#note russian
	# Безусловно уничтожает задачу; для этого ожидающий метод
	# задачи генерирует исключение TaskKillException
	# Не может уничтожать текущую и главную задачу.
*/

int Task_killAll(void);
/*
	#note russian
	# Уничтожает все задачи, кроме главной, посылая им TaskKillException.
	# Должен вызываться только из стека главной задачи.
	# Возвращает true если все задачи, кроме главной, корректно уничтожены.
	# Если какая-то задача перехватывает TaskKillException и при этом
	# не завершается, исключение для нее будет генерироваться снова и
	# снова, пока задача не завершится (или не выпустит исключение из
	# метода  run ), или бесконечно.
	# Вызов Task::killAll() должен в общем случае стоять в статическом
	# деструкторе головного класса программы для того, чтобы корректно
	# завершить все оставшиеся задачи. К сожалению, его нельзя вставить
	# в статический деструктор класса Task, т.к. к моменту вызова
	# статического деструктора класа Task уже будут вызваны статические
	# деструкторы классов, производных от Task, а именно объектами этих
	# классов и манипулирует killAll().
*/

int Task_yield(void);
/*
	#note russian
	# Явная передача управления планировщику задач.
*/

long Task_sleep(long millisec);
/*
	#note russian
	# Ожидание таймаута.
*/

int Task_wait_read(int fd, long msec);
/*
	#note russian
	# ожидание готовности файла на чтение с таймаутом
*/

int Task_wait_write(int fd, long msec);
/*
	#note russian
	# ожидание готовности файла на запись с таймаутом
*/

int task_select(int nfds, fd_set *readfds, fd_set *writefds, fd_set *exceptfds,
		struct timeval *timeout);

int clip_task_select_if(int fd, void *rp, void *wp, void *ep, void *to);

/* ////////// обмен сообщениями /////////////// */

int Task_sendMessage(long receiver, /* new */ TaskMessage *msg);
/*
	#note russian
	# посылка сообщения без ожидания ответа
	# если receiver==0, то сообщение посылается главной задаче
	msg разрушается автоматом
*/

int Task_sendMessageWait(int receiver, TaskMessage *msg);
/*
	#note russian
	# посылка сообщения с блокировкой до получения ответа
	msg разрушается автоматом
*/

int Task_sendAll(TaskMessage *msg);
/*
	#note russian
	# посылка сообщения всем задачам, которые ждут сообщения
	# посылающая задача блокируется
*/

TaskMessage *Task_peekMessage(void);
/*
	#note russian
	# неблокирующая проверка очереди сообщений
	# если нет сообщений, возвращает null
	# если есть, сообщение извлекается из очереди
*/

TaskMessage *Task_getMessage(void);
/*
	#note russian
	# если нет сообщений, блокируется
*/

int Task_respond(TaskMessage *msg);
/*
	#note russian
	# Заканчивает обработку сообщения и разблокирует,
	# если требуется, посылающую задачу.
	# Обработка любого сообщения должна заканчиваться либо этим
	# вызовом, либо вызовом forward, иначе сообщение навсегда
	# останется в списке обрабатываемых.
*/

int Task_forward(long receiver, TaskMessage *msg);
/*
	#note russian
	# пересылает сообщение другой задаче
*/

#endif
