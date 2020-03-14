#! /bin/bash
usr=`id -un`
ORAHOME=/home/`echo $usr`
. $ORAHOME/.bash_profile
 

LOGFILE=/home/oraep01/maintenance/log/Backup_`date +%d-%m-%y-%H_%M_%S`.log

rman target / trace $LOGFILE << EOF
run {
allocate channel t1 device type disk connect 'sys/keltu6400@ep011' FORMAT '/newdump/rmanbackup/Backup%d_DB_%u_%s_%p_%T'; 
allocate channel t2 device type disk connect 'sys/keltu6400@ep011' FORMAT '/newdump/rmanbackup/Backup%d_DB_%u_%s_%p_%T';
allocate channel t3 device type disk connect 'sys/keltu6400@ep012' FORMAT '/newdump/rmanbackup/Backup%d_DB_%u_%s_%p_%T';
allocate channel t4 device type disk connect 'sys/keltu6400@ep012' FORMAT '/newdump/rmanbackup/Backup%d_DB_%u_%s_%p_%T';
allocate channel t5 device type disk connect 'sys/keltu6400@ep011' FORMAT '/newdump/rmanbackup/Backup%d_DB_%u_%s_%p_%T';
allocate channel t6 device type disk connect 'sys/keltu6400@ep012' FORMAT '/newdump/rmanbackup/Backup%d_DB_%u_%s_%p_%T';
crosscheck archivelog all;
###crosscheck backup;
delete noprompt expired archivelog all;
##delete noprompt obsolete device type disk;
backup database plus archivelog;
crosscheck backup;
release channel t1;
release channel t2;
release channel t3;
release channel t4;
release channel t5;
release channel t6;
}
exit
EOF

exit 0
