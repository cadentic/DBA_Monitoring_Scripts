#! /bin/bash
usr=`id -un`
ORAHOME=/home/`echo $usr`
. $ORAHOME/.bash_profile


LOGFILE=/home/oraep01/maintenance/log/Backup_`date +%d-%m-%y-%H_%M_%S`.log

rman target / trace $LOGFILE << EOF

run {
allocate channel t1 device type disk connect 'sys/keltu6400@ep011' FORMAT '/dump/rmanbackup/Backup%d_DB_%u_%s_%p_%T';
allocate channel t2 device type disk connect 'sys/keltu6400@ep012';
send 'NSR_ENV(NSR_SERVER=sreikolppwbkp,NSR_CLIENT=sreiscanipebs,NSR_DATA_VOLUME_POOL=SREIORACLE)';
backup archivelog from sequence 7610 until sequence 7620 thread 1 format '/dump/rmanbackup/ArchivelogBackup__%d_%p_%s';
backup archivelog from sequence 5580 until sequence 5585 thread 2 format '/dump/rmanbackup/ArchivelogBackup__%d_%p_%s';
release channel t2;
}
exit
EOF

exit 0
