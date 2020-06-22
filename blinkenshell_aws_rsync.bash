#!/bin/bash

host=`uname -n`              # Use host name as ssh-agent environment file name
. ~/.ssh/agent/${host} >/dev/null           # source ssh-agent environment file

rsync --archive --delete --rsh="ssh -q" \
triton:/home/lam/public_html/ \
/var/www/blinkenshell
