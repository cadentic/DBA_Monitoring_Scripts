#! /bin/bash
usr=`id -un`
ORAHOME=/home/`echo $usr`
. $ORAHOME/.bash_profile

find /home/oraep01/maintenance/log  -name "ArchiveBackup_*.log" -mtime +1 -type f -exec rm {} \; 2>&1 > /dev/null

LOGFILE=/home/oraep01/maintenance/log/ArchiveBackup_`date +%d-%m-%y-%H_%M_%S`.log

rman target / trace $LOGFILE << EOF
run {
allocate channel t1 device type disk connect 'sys/keltu6400@ep011';
allocate channel t2 device type disk connect 'sys/keltu6400@ep012';
crosscheck archivelog all;
#delete noprompt obsolete device type disk;
delete noprompt expired archivelog all;
backup archivelog all format '/newdump/rmanbackup/ArchivelogBackup__%d_%p_%s' delete all input;
release channel t1;
release channel t2;
}
exit
EOF

#if [echo $? -eq 0 ]  then
#mutt -s "RMAN backup Failure of EP01" -a $LOGFILE virtual.infra@srei.com < rmanmailfailure
#cat rmanmailfailure | /bin/mail -s "RMAN backup Failure of EP01" virtual.infra@srei.com
#cat $ORAHOME/rmanmailsuccess | /bin/mail -s "Archivelog backup Completed successfully - EP01" virtual.infra@srei.com
#else 
#mutt -s "RMAN backup completed successfully" -a $LOGFILE virtual.infra@srei.com < rmanmailsuccess
#fi

exit 0
