#! /bin/bash
usr=`id -un`
ORAHOME=/home/`echo $usr`
. $ORAHOME/.bash_profile

find /home/oraep01/maintenance/log  -name "Backup_*.log" -mtime +1 -type f -exec rm {} \; 2>&1 > /dev/null

LOGFILE=/home/oraep01/maintenance/log/Backup_`date +%d-%m-%y-%H_%M_%S`.log

rman target / trace $LOGFILE << EOF
run {
allocate channel t1 device type disk connect 'sys/keltu6400@ep011';
allocate channel t2 device type disk connect 'sys/keltu6400@ep012';
crosscheck backup;
delete noprompt obsolete device type disk;
release channel t1;
release channel t2;
allocate channel t1 type disk connect 'sys/keltu6400@ep011';
allocate channel t2 type disk connect 'sys/keltu6400@ep012';
##backup archivelog all delete input;
##backup database plus archivelog;
backup database plus archivelog FORMAT   '/dump/rmanbackup/Backup%d_DB_%u_%s_%p_%T';
crosscheck backup;
release channel t1;
release channel t2;
}
exit
EOF

#if [echo $? -eq 0 ]  then
#mutt -s "RMAN backup Failure of EP01" -a $LOGFILE virtual.infra@srei.com < rmanmailfailure
#cat rmanmailfailure | /bin/mail -s "RMAN backup Failure of EP01" virtual.infra@srei.com
#cat $ORAHOME/rmanmailsuccess | /bin/mail -s "RMAN backup Completed successfully - EP01" virtual.infra@srei.com
#else 
#mutt -s "RMAN backup completed successfully" -a $LOGFILE virtual.infra@srei.com < rmanmailsuccess
#fi

exit 0
