#!/bin/bash. $HOME/. bash_profile
id=`id -un`
. $HOME/.bash_profile

LOGFILE=/home/oraep01/scripts/Archivelog_Backup_`date +%d-%m-%y-%H_%M_%S`.log

rman target / trace $LOGFILE << EOF
run {
allocate channel t1 device type disk ;
allocate channel t2 device type disk ;
delete noprompt obsolete device type disk;
crosscheck archivelog all;
backup archivelog all format '/newdump/rmanbackup/EBS/Backup%d_DB_%u_%s_%p_%T.bkp' delete all input;
crosscheck backup;
release channel t1;
release channel t2;
}
exit
EOF


chk=`echo $?`
if [ ! $chk ]  then
mutt -s "ARCHIVELOG backup Failure of EBZ " -a $LOGFILE l1.dbsupport@srei.com < $LOGFILE
else
mutt -s "ARCHIVELOG backup of EBZ completed successfully" -a $LOGFILE l1.dbsupport@srei.com
fi

exit 0

