. $HOME/.bash_profile

export DT=`date +%d%m%y_%H%M%S`

rm -f $HOME/alert/logs/tablespace_used_*.log

> $HOME/alert/logs/do_not_remove_tablespace_used.lst

sqlplus -s  "/ as sysdba" > $HOME/alert/logs/do_not_remove_tablespace_used.lst  << EOS
set Heading off
set feedback off
set verify off
set echo off
set linesize 500
set pagesize 75

select 
           tablespace_name, 
           round(used_space/(1024*1024),2), 
           round(tablespace_size/(1024*1024),2), 
           round(used_percent, 2) 
from 
           dba_tablespace_usage_metrics
where 
           round(used_percent,2) > 90;
EOS

found=`cat $HOME/alert/logs/do_not_remove_tablespace_used.lst|wc -l`

if [ $found -gt 0 ]
then
      cat $HOME/alert/logs/do_not_remove_tablespace_used.lst > $HOME/alert/logs/tablespace_used_$DT.log


     cat $HOME/alert/logs/tablespace_used_$DT.log | /bin/mail -s "Critical tablespace alert" l1.dbsupport@srei.com,l1.infrasupport@srei.com
fi



exit 0

