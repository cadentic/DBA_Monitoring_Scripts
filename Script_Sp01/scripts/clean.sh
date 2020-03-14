#!/bin/bash
export DT=`date +%d%m%y_%H%M%S`
#find /newdump/filesystems/SP01/SEFPLLIVE_DAILY_BACKUP -iname "*.DMP" -mtime +1 -exec rm -f {} \;
#find /newdump/filesystems/SP01/SEFPLLIVE_DAILY_BACKUP -iname "*.log" -mtime +1 -exec rm -f {} \;
find /home/orasp01/alert -iname "*.csv" -mtime +1 -exec rm -f {} \;
find /u01/rac/admin/SP01/adump -iname "*.aud" -mtime +3 -exec rm -f {} \;
find /u01/rac/diag/rdbms/sp01/SP012/trace -iname "*.tr*" -mtime +3 -exec rm -f {} \;

#find /newdump/filesystems/SP01/SEFPLLIVE_DAILY_BACKUP -iname "SEFPL*" -mtime +1 -exec rm -f {} \;
