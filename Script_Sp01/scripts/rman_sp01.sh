#!/bin/bash. $HOME/. bash_profile
id=`id -un`
. $HOME/.bash_profile

cd /newdump/filesystems/SEFLRMAN/
rm -rf *
cd $HOME
mkdir -p /newdump/filesystems/SEFLRMAN/$(date +%d%m%y)
mv /newdump/filesystems/SP01/rmanbackup/* /newdump/filesystems/SEFLRMAN/$(date +%d%m%y)

BODY=$HOME/scripts/rman_body
LOGFILE=/home/orasp01/scripts/backup_`date +%d-%m-%y-%H-%M-%S`.log
rman target / trace $LOGFILE << EOF

run
{
allocate channel e1 device type DISK format '/newdump/filesystems/SP01/rmanbackup/Backup%d_DB_%u_%s_%p_%T.bkp';
allocate channel e2 device type DISK format '/newdump/filesystems/SP01/rmanbackup/Backup%d_DB_%u_%s_%p_%T.bkp';
allocate channel e3 device type DISK format '/newdump/filesystems/SP01/rmanbackup/Backup%d_DB_%u_%s_%p_%T.bkp';
allocate channel e4 device type DISK format '/newdump/filesystems/SP01/rmanbackup/Backup%d_DB_%u_%s_%p_%T.bkp';
delete noprompt obsolete;
delete noprompt expired archivelog all;
delete noprompt archivelog all completed before 'sysdate-2';
crosscheck archivelog all;
backup as compressed backupset tag 'full_SP01_backup' database plus archivelog delete input;
backup current controlfile format '/newdump/filesystems/SP01/rmanbackup/controlfile_%U_%D.bkp';
backup spfile format '/newdump/filesystems/SP01/rmanbackup/spfile_%U_%D.bkp';
delete noprompt archivelog all completed before 'sysdate-1';
}
exit;
EOF

cp /etc/hosts  /newdump/filesystems/SP01/rmanbackup/
cp /etc/sysctl.conf /newdump/filesystems/SP01/rmanbackup/
cp /u01/app/network/admin/listener.ora  /newdump/filesystems/SP01/rmanbackup/
cp /u01/app/network/admin/sqlnet.ora  /newdump/filesystems/SP01/rmanbackup/
cp /u01/rac/product/11.2.0/dbhome_1/network/admin/tnsnames.ora  /newdump/filesystems/SP01/rmanbackup/
crontab -l > /newdump/filesystems/SP01/rmanbackup/$(date +%Y%m%d).crontab
#cat $LOGFILE|/bin/mail -s "Backup status of RMAN from SP01"  ankur.dayama@srei.com ritayan.banerjee@srei.com caesar.dutta@in.pwc.com l1.dbsupport@srei.com
#/bin/mailx -s "Backup status of RMAN from NGP011"  ankur.dayama@srei.com ritayan.banerjee@srei.com caesar.dutta@in.pwc.com l1.dbsupport@srei.com < $LOGFILE

mutt -s "Backup status of RMAN from SP01"  -a $LOGFILE -c  l1.dbsupport@srei.com -b ritayan.banerjee@srei.com caesar.dutta@in.pwc.com < $BODY
cp -rf $LOGFILE /newdump/filesystems/mail/
cd $HOME/scripts/
find . -name '*.log' -mtime +7 -exec rm -r {} \;
#cd /newdump/filesystems/SEFLRMAN/
#rm -rf *

exit 0

