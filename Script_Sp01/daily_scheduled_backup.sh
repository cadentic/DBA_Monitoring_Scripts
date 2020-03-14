#! /bin/sh
usr_id=`id -un`
. $HOME/.bash_profile
export DT=`date +%d%m%y_%H%M%S`

#cd /newdump/filesystems/SEFLRMAN/
#find  -type d -mtime 1 -exec rm -r {} \;
 


cd $HOME
LOGFILE=/newdump/filesystems/SP01/SEFPLLIVE_DAILY_BACKUP/SEFPLLIVE_$DT.log
BODY=$HOME/scripts/expdp_backup_body.txt
mkdir -p /newdump/filesystems/SEFLRMAN/$(date +%d%m%y)
mv /newdump/filesystems/SP01/rmanbackup/* /newdump/filesystems/SEFLRMAN/$(date +%d%m%y)/
mv /newdump/filesystems/SP01/SEFPLLIVE_DAILY_BACKUP/* /newdump/filesystems/SEFLRMAN/$(date +%d%m%y)/
### CHECK PREVIOUS BACKUPS OF MORE THAN 3 DAYS AND REMOVE THEN
find /newdump/filesystems/SP01/SEFPLLIVE_DAILY_BACKUP/deleted_bkup_log/ -name "*.log" -mtime +1 -exec rm "{}" ";"


### REMOVES OR DELETES THE BACKUP WHICH IS OLDER THAN 3 DAYS

#expdp system/sc1encec1ty dumpfile=SEFPLLIVE_$DT.DMP LOGFILE=SEFPLLIVE_$DT.log schemas=SEFPLLIVE consistent=y directory=SEFPLLIVE_DAILY_BACKUP

expdp system/lenovo123 dumpfile=SEFPLLIVE_$DT.DMP LOGFILE=SEFPLLIVE_$DT.log schemas=SEFPLLIVE consistent=y directory=DAILY_BACKUP

#find /dump/filesystems/SP01/SEFPLLIVE_DAILY_BACKUP/deleted_bkup_log/ -name "*.log" -mtime +1 -exec rm "{}" ";"

find /newdump/filesystems/SP01/SEFPLLIVE_DAILY_BACKUP/deleted_bkup_log/ -name "SEFPL*" -mtime +1 -exec rm "{}" ";"





#cat /newdump/filesystems/SP01/SEFPLLIVE_DAILY_BACKUP/SEFPLLIVE_$DT.log|/bin/mail -s "Backup status of SEFPLLIVE schema" l1.dbsupport@srei.com  ritayan.banerjee@srei.com tirtha.bagchi@xenolithtechnologies.com kalicharan.chatterjee@xenolithtechnologies.com  
#mutt -s "Backup status of RMAN from NGP011"  -a $LOGFILE -c  l1.dbsupport@srei.com -b ritayan.banerjee@srei.com caesar.dutta@in.pwc.com tirtha.bagchi@xenolithtechnologies.com kalicharan.chatterjee@xenolithtechnologies.com < $BODY
#cd /dump/filesystems/SP01/SEFPLLIVE_DAILY_BACKUP
#chmod 777 SEFPLLIVE_$DT.DMP


mutt -s "Backup status of logical backup of SP01"  -a $LOGFILE -c  l1.dbsupport@srei.com -b ritayan.banerjee@srei.com caesar.dutta@in.pwc.com tirtha.bagchi@xenolithtechnologies.com kalicharan.chatterjee@xenolithtechnologies.com < $BODY

cd /newdump/filesystems/SP01/SEFPLLIVE_DAILY_BACKUP
chmod 777 SEFPLLIVE_$DT.DMP
#cd /newdump/filesystems/SEFLRMAN/
#find  -type d -mtime 1 -exec rm -r {} \;

exit 0

