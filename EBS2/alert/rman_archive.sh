#! /bin/bash
usr=`id -un`
ORAHOME=/home/`echo $usr`
. $ORAHOME/.bash_profile

LOGFILE=$ORAHOME/logs/Archivelog_Backup_`date +%d-%m-%y-%H_%M_%S`.log

rman target / trace $LOGFILE << EOF
run {
allocate channel t1 device type disk ;
allocate channel t2 device type disk ;
delete noprompt obsolete device type disk;
crosscheck archivelog all;
backup archivelog all format '/newdump/rmanbackup/EBS/ArchivelogBackup__%d_%p_%s.arc' delete all input;
crosscheck backup;
release channel t1;
release channel t2;
}
exit
EOF


chk=`echo $?`
if [ ! $chk ]  then
mutt -s "ARCHIVELOG backup Failure of EBS" -a $LOGFILE l1.dbsupport@srei.com < $LOGFILE
else
mutt -s "ARCHIVELOG backup of EBS completed successfully" -a $LOGFILE l1.dbsupport@srei.com

fi

exit 0


