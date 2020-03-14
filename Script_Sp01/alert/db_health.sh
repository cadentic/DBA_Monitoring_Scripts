#!/bin/bash
## DAILY DATABASE HEALTH CHECK REPORT
cd $HOME/alert
 
sqlplus -s  "/ as sysdba"  << EOS
@db_health_scr.sql;
EOS

cd $HOME
cp ${ORACLE_SID}_&today_var.txt /newdump/filesystems/mail

exit
