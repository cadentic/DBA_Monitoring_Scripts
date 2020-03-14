#!/bin/bash
id=`id -un`

. $HOME/.bash_profile
mailbody=$HOME/alert/daily_mail
export DT=`date +%d%m%y_%H%M%S`

sqlplus -S   "/ as sysdba" <<EOF

set Heading off
set feedback off
set verify off
set echo off
set linesize 500
set pagesize 75
set colsep ','
COLUMN USER_CONCURRENT_PROGRAM_NAME FORMAT A40
spool $HOME/alert/logs/ebs_$DT.txt

 SELECT DISTINCT c.USER_CONCURRENT_PROGRAM_NAME,round(((sysdate-a.actual_start_date)*24*60*60/60),2) AS Process_time
FROM   apps.fnd_concurrent_requests a,apps.fnd_concurrent_programs b,apps.FND_CONCURRENT_PROGRAMS_TL c,apps.fnd_user d
WHERE  a.concurrent_program_id=b.concurrent_program_id AND b.concurrent_program_id=c.concurrent_program_id AND
a.requested_by=d.user_id AND status_code='R' order by Process_time desc;

spool off;

exit;

EOF
echo "outside"
cat $HOME/alert/logs/ebs_$DT.txt|awk -F ',' '{printf "%.0f\n", $2}'|while read output;
do

  if [ $output -gt 300 ]
    then
      
    #   mutt -s "Critical concurrent_request alert $ORACLE_SID" -a $HOME/alert/logs/ebs_$DT.txt -b l1.dbsupport@srei.com  < $HOME/alert/daily_mail 
     mutt -s "Critical concurrent_request alert $ORACLE_SID"  l1.dbsupport@srei.com  < $HOME/alert/logs/ebs_$DT.txt
	
	 echo $output
       echo "Inside"
  fi

done
echo "Endside"
exit 0

