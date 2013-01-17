#!/bin/bash
# abort as soon as an error occurs:
set -e

DBUSER=user
DBPASSWD=passwd
DATABASES="db1 db2"

DATE=$(date +"%Y%m%d-%H%M")

#folder where the backup file will be stored
BASE=$HOME/archives/
# e.g. you could set a script here which emails/archives the file somewhere remote
POSTPROCESSCRIPT=/bin/false

cd $BASE

# backup filename
BACKUPFILE=${BASE}dbbackup_$DATE.zip

mysqldump -h localhost -u $DBUSER --password=$DBPASSWD --databases $DATABASES | zip > $BACKUPFILE

$POSTPROCESSCRIPT $BACKUPFILE

echo done
