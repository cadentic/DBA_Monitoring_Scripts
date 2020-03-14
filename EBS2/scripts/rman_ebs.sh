#!/bin/bash. $HOME/. bash_profile
id=`id -un`
. $HOME/.bash_profile

#find /newdump/filesystems/EBSRMAN/ -type d -mtime 1 -exec /bin/rm -f {} +
cd /newdump/filesystems/EBSRMAN/
rm -rf * 
cd $HOME
mkdir -p /newdump/filesystems/EBSRMAN/$(date +%d%m%y)
mv /newdump/rmanbackup/EBS/* /newdump/filesystems/EBSRMAN/$(date +%d%m%y)/
BODY=$HOME/scripts/rman_body

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
sql 'alter system archive log current';
backup as compressed backupset tag 'full_EBS_backup' database plus archivelog delete input;
backup current controlfile format '/newdump/rmanbackup/EBS/controlfile_%U_%D.bkp';
backup spfile format '/newdump/rmanbackup/EBS/spfile_%U_%D.bkp';
delete noprompt archivelog all completed before 'sysdate-2';
}
exit;
EOF


cp /etc/hosts  /newdump/filesystems/EBSRMAN/$(date +%d%m%y)
cp /etc/sysctl.conf /newdump/filesystems/EBSRMAN/$(date +%d%m%y)
cp /u01/grid/network/admin/listener.ora  /newdump/filesystems/EBSRMAN/$(date +%d%m%y)
cp /u01/grid/network/admin/sqlnet.ora  /newdump/filesystems/EBSRMAN/$(date +%d%m%y)
cp /u01/rac/product/11.2.0/dbhome_1/network/admin/tnsnames.ora  /newdump/filesystems/EBSRMAN/$(date +%d%m%y)
crontab -l > /newdump/filesystems/EBSRMAN/$(date +%d%m%y)/$(date +%Y%m%d).crontab

mutt -s "Backup status of RMAN from EBS"  -a $LOGFILE -c  l1.dbsupport@srei.com -b caesar.dutta@in.pwc.com < $BODY
cp -rf $LOGFILE /newdump/filesystems/mail/

cd $HOME/
find . -name '*.log' -mtime +7 -exec rm -r {} \;
cd $HOME/scripts/
find . -name '*.log' -mtime +7 -exec rm -r {} \;

cd /newdump/filesystems/EBSRMAN/
find  -type d -mtime +2 -exec rm -r {} \;

exit 0
                                             
