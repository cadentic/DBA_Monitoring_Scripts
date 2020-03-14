#! /bin/bash
usr=`id -un`
ORAHOME=/home/`echo $usr`
. $ORAHOME/.bash_profile

#find /home/oraep01/maintenance/log  -name "Backup_*.log" -mtime +1 -type f -exec rm {} \; 2>&1 > /dev/null

LOGFILE=/home/oraep01/maintenance/log/Backup_`date +%d-%m-%y-%H_%M_%S`.log

rman target / trace $LOGFILE << EOF

run {

#allocate channel t1 type disk connect 'sys/keltu6400@ep011';
allocate channel t2 type disk connect 'sys/keltu6400@ep012';
#allocate channel f1 disk1 device type disk format '/newdump/rmanbackup/Backup%U';
#allocate channel f2 disk1 device type disk format '/newdump/rmanbackup/Backup%U';
#backup database plus archivelog;
backup as copy current controlfile format '/newdump/rmanbackup/clone-rac/backup_controlfile.ctl'; 
release channel t1;
release channel t2;
}
exit
EOF
