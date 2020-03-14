LOGFILE=/home/oraep01/scripts/backup_`date +%d-%m-%y-%H-%M-%S`.log
rman target / trace $LOGFILE << EOF

run
{
allocate channel e1 device type DISK format '/newdump/rmanbackup/EBS/Backup%d_DB_%u_%s_%p_%T.bkp';
allocate channel e2 device type DISK format '/newdump/rmanbackup/EBS/Backup%d_DB_%u_%s_%p_%T.bkp';
allocate channel e3 device type DISK format '/newdump/rmanbackup/EBS/Backup%d_DB_%u_%s_%p_%T.bkp';
allocate channel e4 device type DISK format '/newdump/rmanbackup/EBS/Backup%d_DB_%u_%s_%p_%T.bkp';
delete noprompt obsolete;
delete noprompt expired archivelog all;
delete noprompt archivelog all completed before 'sysdate-2';
crosscheck archivelog all;
backup as compressed backupset tag 'full_EBS_backup' database plus archivelog delete input;
backup current controlfile format '/newdump/rmanbackup/EBS/controlfile_%U_%D.bkp';
backup spfile format '/newdump/rmanbackup/EBS/spfile_%U_%D.bkp';
delete noprompt archivelog all completed before 'sysdate-2';
}
exit;
EOF
