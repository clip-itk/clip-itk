#!/bin/sh

 set -e

 echo "Set mode for pam-auth need root or sudo access"

 chmod -x pam-auth
 chgrp root pam-auth
 chown root pam-auth
 chmod u+s pam-auth
 chmod g+s pam-auth
 chmod +x pam-auth

