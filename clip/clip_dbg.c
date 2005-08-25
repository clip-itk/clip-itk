/*
	Copyright (C) 2001  ITK
	Author   : Paul Lasarev <paul@itk.ru>
	License : (GPL) http://www.itk.ru/clipper/license.html
*/
/*
   $Log: clip_dbg.c,v $
   Revision 1.24  2005/08/08 09:00:30  clip
   alena: fix for gcc 4

   Revision 1.23  2004/10/09 12:38:53  clip
   rust: minor fix for configure -m=...

   Revision 1.22  2004/09/03 07:04:00  clip
   uri: small fixes from John Smyth <js@w-e.ru>

   Revision 1.21  2004/05/19 08:32:18  clip
   rust: fix for ./configure -m

   Revision 1.20  2003/09/09 14:36:14  clip
   uri: fixes for mingw from Mauricio and Uri

   Revision 1.19  2001/11/02 08:21:53  clip
   dbg again work
   paul

   Revision 1.18  2001/10/15 07:25:19  clip
   solaris fix

   Revision 1.17  2001/09/05 12:16:39  clip
   uri:add empty function "mkfifo"

   Revision 1.16  2001/04/03 10:13:49  clip
   append check/define HAVE_READLINE_ALREADY_PROMPTED into configure
   paul

   Revision 1.15  2001/04/03 09:17:00  clip
   license errors
   paul

   Revision 1.14  2001/03/31 12:57:07  clip
   al_.. in freeBsd

   Revision 1.13  2001/03/31 12:05:31  clip
   ASPLInux don`t have library readline, fixed configure and clip_dbg
   uri:

   Revision 1.12  2001/03/31 09:10:06  clip
   al_already_promted not in .h files, add key -c to command "install -m clip.h ...."

   Revision 1.11  2001/03/30 11:51:03  clip
   add copyright

   Revision 1.10  2001/03/05 10:01:43  clip
   append step command
   append option command
   paul

   Revision 1.9  2001/03/02 12:57:27  clip
   DBG functions
   paul

   Revision 1.8  2001/02/22 08:29:31  clip
   add next and until commands
   paul

   Revision 1.7  2001/02/16 12:48:50  clip
   breakpoints
   paul

   Revision 1.6  2001/02/13 13:33:57  clip
   dbg bpoints
   paul

   Revision 1.5  2001/02/08 14:08:28  clip
   Readline usage imrpoved
   paul

   Revision 1.4  2001/02/08 07:44:44  clip
   readline usage in clip_dbg
   paul

   Revision 1.3  2001/02/07 11:47:15  clip
   localdefs
   paul

   Revision 1.2  2001/02/06 13:07:25  clip
   hash in .po, dbg
   paul

   Revision 1.1  2001/02/01 13:05:06  clip
   debug links
   paul
*/
#include <string.h>

#include "clip.h"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <ctype.h>
#include <errno.h>
#include <signal.h>
#include <stdarg.h>
#include <fcntl.h>


#ifndef OS_MINGW
#include <termios.h>
#include <sys/wait.h>
#endif

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>

#ifdef HAVE_READLINE_H
/* libreadline */
#include <readline/readline.h>
#include <readline/history.h>

#undef select


extern char *optarg;
extern int optind, opterr, optopt;
static char in_path[256] =
{0};
static char out_path[256] =
{0};
static FILE *fin = 0;
static int fout = -1;
static pid_t tpid = 0, mpid = 0;
static pid_t pid = 0;
static int log_level = 0;
static char *progname = "";

static const char usage_str[] = "clip_dbg local commands:\n\
\t! cmd -- execute system cmd\n\
\tIn any command part after | or > used as local pipe or redirection.\n\
\tAll readline command-editing keys are active.\n\
\tDebugged program MUST be started with --debug or --stop option.\n\
";

#ifdef _WIN32
int mkfifo(const char * path, mode_t mode)
{
	return -1;
}
#endif

static int
is_dig(char *str)
{
	int c;

	while ((c = *str++))
	{
		if (!isdigit(c))
			return 0;
	}
	return 1;
}

struct termios term, oterm;

static void
cleanup(int code)
{
	if (fin)
		fclose(fin);
	if (fout >= 0)
		close(fout);
	if (in_path[0])
		remove(in_path);
	if (out_path[0])
		remove(out_path);
#ifndef OS_MINGW
	if (tpid != 0)
	{
		int status;

		kill(tpid, SIGTERM);
		waitpid(tpid, &status, 0);
	}
#endif

	tcsetattr(0, TCSANOW, &oterm);
	write(1, "\n", 1);

	exit(code);
}

static void
logg(int level, const char *fmt,...)
{
	va_list ap;

	if (level > log_level)
		return;

	va_start(ap, fmt);
	vfprintf(stderr, fmt, ap);
	va_end(ap);
	fputc('\n', stderr);
	fflush(stderr);
}

static void
sigfunc(int sig)
{
	cleanup(100 + sig);
}

static void
sigpipe(int sig)
{
	fprintf(stderr, "\ndebugged program '%s' died.\n", progname);
	cleanup(100 + sig);
}

static void
usage(void)
{
	fprintf(stderr, "CLIP debugger commandline frontend\n");
	fprintf(stderr, "usage: clip_dbg [-hv] progname|pid\n");
	fprintf(stderr, "\t-h\tthis help\n");
	fprintf(stderr, "\t-v\tverbose output\n");
	exit(0);
}

static void
sigusr(int sig)
{
}

static void
split_vector(char *str, char ***vpp, int *lenp)
{
	int l;
	char *tok;

	while ((tok = strtok(str, " \t\n")))
	{
		str = 0;
		if (!*tok)
			continue;
		l = (*lenp)++;
		*vpp = (char **) realloc(*vpp, (l + 1) * sizeof(char *));

		(*vpp)[l] = tok;
	}
}

static int pipe_flag = 0;
enum
{
	P_Norm,
	P_Nl,
	P_NlDot,
}
pipe_state = P_Norm;

static FILE *pipe_tmp = 0;
static char pipe_name[L_tmpnam];
static char *pipe_command = 0;

static void
start_pipe(char *op, char *cmd)
{
	char buf[4096];

	if (pipe_flag)
		return;

	//if (!tmpnam(pipe_name))
	if (!mkstemp(pipe_name))
		return;

	pipe_tmp = fopen(pipe_name, "w");

	if (!pipe_tmp)
		return;

	pipe_flag = 1;

	snprintf(buf, sizeof(buf), "cat %s %s %s", pipe_name, op, cmd);

	free(pipe_command);
	pipe_command = strdup(buf);
}

static void
char_pipe(int ch)
{
	switch (pipe_state)
	{
	case P_Norm:
		if (ch == '\n')
			pipe_state = P_Nl;
		fputc(ch, pipe_tmp);
		break;
	case P_Nl:
		if (ch == '.')
			pipe_state = P_NlDot;
		else
		{
			if (ch != '\n')
				pipe_state = P_Norm;
			fputc(ch, pipe_tmp);
		}
		break;
	case P_NlDot:
		pipe_state = P_Norm;
		if (ch == '\n')
		{
			fclose(pipe_tmp);
			system(pipe_command);
			remove(pipe_name);
			pipe_flag = 0;
			write(1, "\n", 1);
			rl_forced_update_display();
		}
		else
		{
			fputc('.', pipe_tmp);
			fputc(ch, pipe_tmp);
		}
		break;
	}

}

static void
process_line(char *bp)
{
	char obuf[1024];
	char **argv = 0;
	int argc = 0;
	int i, l;
	char *s;

	if (*bp)
		add_history(bp);
	else
	{
		HIST_ENTRY *p = previous_history();
		if (p)
			bp = p->line;
	}

	if (bp[0] == '!')
	{
		system(bp + 1);
		return;
	}

	s = strchr(bp, '|');
	if (s && s[1])
	{
		start_pipe("|", s + 1);
		*s = 0;
	}
	else
	{
		s = strchr(bp, '>');
		if (s && s[1])
		{
			start_pipe(">", s + 1);
			*s = 0;
		}
	}

	split_vector(bp, &argv, &argc);

#if 0
	if (argc && !strcasecmp(argv[0], "quit"))
		cleanup(0);
#endif

	obuf[0] = 0;
	for (i = 0; i < argc; i++)
	{
		l = strlen(obuf);
		snprintf(obuf + l, sizeof(obuf) - l, "%s ", argv[i]);
	}

	l = strlen(obuf);

	snprintf(obuf + l, sizeof(obuf) - l, "\n");
	l = strlen(obuf);

	if (fwrite(obuf, l, 1, fin) != 1)
	{
		fprintf(stderr, "cannot write to PID %lu\n",
			(unsigned long) pid);
		cleanup(1);
	}
	fflush(fin);
#ifndef OS_MINGW
	if (kill(pid, SIGUSR1))
	{
		fprintf(stderr, "cannot send signal to PID %lu\n",
			(unsigned long) pid);
		cleanup(1);
	}
#endif

	free(argv);
#ifdef HAVE_READLINE_ALREADY_PROMPTED
	rl_already_prompted = 1;
#endif
}

int
main(int argc, char **argv)
{
	int ch;
	char prompt[96];

	while ((ch = getopt(argc, argv, "hv")) != EOF)
	{
		switch (ch)
		{
		case 'v':
			log_level++;
			break;
		case 'h':
			usage();
		}
	}

	argc -= optind;
	argv += optind;

	if (argc < 1)
		usage();

	progname = argv[0];

	if (is_dig(progname))
	{
		pid = strtoul(progname, 0, 10);
	}
	else
	{
		char path[256];
		FILE *file;

		snprintf(path, sizeof(path), "%s.pid", progname);
		file = fopen(path, "r");
		if (file)
		{
			unsigned long ul;

			if (fscanf(file, "%lu", &ul) == 1)
				pid = ul;
			fclose(file);
		}

		if (pid == 0)
		{
			snprintf(path, sizeof(path), "pidof -s %s", progname);
			file = popen(path, "r");
			if (file)
			{
				unsigned long ul;

				if (fscanf(file, "%lu", &ul) == 1)
					pid = ul;
				pclose(file);
			}
		}
	}

	if (pid == 0)
	{
		fprintf(stderr, "cannot determine PID of target process '%s'\n", progname);
		exit(1);
	}

	tcgetattr(0, &term);
	oterm = term;
	term.c_lflag &= ~ICANON;
	term.c_cc[VTIME] = 1;
	tcsetattr(0, TCSANOW, &term);

	signal(SIGINT, sigfunc);
	signal(SIGTERM, sigfunc);
#ifndef OS_MINGW
	signal(SIGHUP, sigfunc);
	signal(SIGPIPE, sigpipe);
	signal(SIGUSR1, sigusr);
#endif
	signal(SIGILL, sigfunc);
	signal(SIGSEGV, sigfunc);

	snprintf(in_path, sizeof(in_path), "/tmp/clip_dbg.%lu.in", (unsigned long) pid);
	remove(in_path);
	if (mkfifo(in_path, 0600))
	{
		fprintf(stderr, "clip_dbg: cannot create FIFO '%s': %s\n",
			in_path, strerror(errno));
		cleanup(3);
	}

	logg(1, "fifo %s created successfully", in_path);

	snprintf(out_path, sizeof(out_path), "/tmp/clip_dbg.%lu.out", (unsigned long) pid);
	remove(out_path);
	if (mkfifo(out_path, 0600))
	{
		fprintf(stderr, "clip_dbg: cannot create FIFO '%s': %s\n",
			out_path, strerror(errno));
		cleanup(4);
	}
	logg(1, "fifo %s created successfully", out_path);

#ifndef OS_MINGW
	if (kill(pid, SIGUSR1))
	{
		fprintf(stderr, "clip_dbg: cannot send signal SIGUSR1 to pid %lu: %s\n",
			(unsigned long) pid, strerror(errno));
		cleanup(7);
	}
#endif

	fin = fopen(in_path, "w");
	if (!fin)
	{
		fprintf(stderr, "clip_dbg: cannot open FIFO '%s': %s\n",
			in_path, strerror(errno));
		cleanup(5);
	}
	setvbuf(fin, 0, _IOLBF, 0);
	/*setvbuf(stdin, 0, _IOLBF, 0); */
	/*setvbuf(stdout, 0, _IOLBF, 0); */
	logg(1, "fifo %s opened for writing", in_path);

	fwrite("\n", 1, 1, fin);
	logg(1, "signal SIGUSR1 sent to pid %lu", (unsigned long) pid);

	fout = open(out_path, O_RDONLY, 0);
	if (fout < 0)
	{
		fprintf(stderr, "clip_dbg: cannot open FIFO '%s': %s\n",
			out_path, strerror(errno));
		cleanup(6);
	}
#ifndef OS_MINGW
	fcntl(fout, F_SETFL, O_NONBLOCK);
#endif

	logg(1, "fifo %s opened for reading", out_path);
	mpid = getpid();

	write(1, usage_str, sizeof(usage_str)-1);

	snprintf(prompt, sizeof(prompt), "clip_dbg %s > ", progname);
	rl_callback_handler_install(prompt, process_line);
	write(1, "?\n", 2);

	while (1)
	{
		fd_set rfs;
		int r, l;
		char buf[1024];

		FD_ZERO(&rfs);
		FD_SET(fout, &rfs);
		FD_SET(fileno(stdin), &rfs);

		r = select(fout + 1, &rfs, 0, 0, 0);
		if (r < 0)
			break;

		if (FD_ISSET(fout, &rfs))
		{
			l = read(fout, buf, sizeof(buf));
			if (l <= 0)
				break;
			if (pipe_flag)
			{
				int i;

				for (i = 0; i < l; i++)
					char_pipe(buf[i]);
			}
			else
			{
				if (write(1, buf, l) < l)
					break;
				rl_forced_update_display();
				continue;
			}
		}
		if (FD_ISSET(fileno(stdin), &rfs))
		{
			if (!pipe_flag)
			{
				rl_callback_read_char();
			}
		}
	}

	cleanup(0);

	return 0;
}
#else
int
main(int argc, char **argv)
{
	printf("\nYour system don`t have readline library \n");
	printf("clip_dbg will not work for your system\n");
	return 1;
}
#endif
