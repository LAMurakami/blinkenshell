#!/bin/bash

<<PROGRAM_TEXT

This script will rebuild an archive of /var/www/blinkenshell resources
 if any of the resources have been changed or added.

The archive is extracted on a new instance with:

tar -xvzf /mnt/efs/aws-lam1-ubuntu/blinkenshell.tgz --directory /var/www

Implement in efs/aws-lam1-ubuntu Daily cron runs with:

ln -s /var/www/blinkenshell/public_html/blinkenshell_archive_rebuild.bash \
/mnt/efs/aws-lam1-ubuntu/blinkenshell

The following will list files changed since the archive was last rebuilt:

if [ $(find /var/www/blinkenshell -newer /mnt/efs/aws-lam1-ubuntu/blinkenshell.tgz -print \
 | sed 's|^/var/www/blinkenshell/||' | grep -v '.git/' | grep -v '.git$' | wc -l) \
 -gt 0 ]
then
  find /var/www/blinkenshell -newer /mnt/efs/aws-lam1-ubuntu/blinkenshell.tgz \
  | grep -v '.git/' | grep -v '.git$' \
  | xargs ls -ld --time-style=long-iso  | sed 's|/var/www/blinkenshell/||' 
fi

PROGRAM_TEXT

if [ $(find /var/www/blinkenshell -newer /mnt/efs/aws-lam1-ubuntu/blinkenshell.tgz -print \
| sed 's|^/var/www/blinkenshell/||' | grep -v '.git/' \
| grep -v '.git$' | wc -l) -gt 0 ]; then

  echo Recreating the aws-lam1-ubuntu/blinkenshell.tgz archive

  rm -f /mnt/efs/aws-lam1-ubuntu/blinkenshell.t{gz,xt}

  tar -cvzf /mnt/efs/aws-lam1-ubuntu/blinkenshell.tgz \
  --exclude='blinkenshell/public_html/.git' \
  --exclude='RCS' \
  --directory /var/www blinkenshell 2>&1 \
  | tee /mnt/efs/aws-lam1-ubuntu/blinkenshell.txt

fi
