
# need package libpam0g-dev

LIBS = -lpam
CC = gcc
CFLAGS = -O

all: pam-auth

pam-auth: pam-auth.c
	$(CC) $(CFLAGS) -o pam-auth pam-auth.c $(LIBS)
	sudo chgrp root pam-auth
	sudo chmod g+s pam-auth
	sudo chown root pam-auth
	sudo chmod u+s pam-auth

clean:
	rm -f pam-auth *.bak *.o

