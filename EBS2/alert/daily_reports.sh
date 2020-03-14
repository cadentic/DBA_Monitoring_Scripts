#!/bin/bash
id=`id -un`

. $HOME/.bash_profile
mailbody=$HOME/alert/daily_mail
export DT=`date +%d%m%y_%H%M%S`

sqlplus -S   "/ as sysdba" <<EOF

set linesize 300
set colsep ','
spool /home/oraep01/alert/ep01_$DT.csv
select name,TOTAL_MB,FREE_MB from V\$ASM_DISKGROUP;
select a.tablespace_name,
       a.bytes_alloc/(1024*1024*1024) "TOTAL ALLOC (GB)",
       a.physical_bytes/(1024*1024*1024) "TOTAL PHYS ALLOC (GB)",
       nvl(b.tot_used,0)/(1024*1024*1024) "USED (GB)",
       (nvl(b.tot_used,0)/a.bytes_alloc)*100 "% USED"
from ( select tablespace_name,
       sum(bytes) physical_bytes,
       sum(decode(autoextensible,'NO',bytes,'YES',maxbytes)) bytes_alloc
       from dba_data_files
       group by tablespace_name ) a,
     ( select tablespace_name, sum(bytes) tot_used
       from dba_segments
       group by tablespace_name ) b
where a.tablespace_name = b.tablespace_name (+)
and   a.tablespace_name not in (select distinct tablespace_name from dba_temp_files)
order by 1;

SELECT	'Time now is '  METRIC_NAME,	
	To_char(sysdate, 'dd/mm/yyyy hh24:mi:ss') VALUE
FROM	DUAL
UNION
SELECT	to_char(inst_id) || '_' || METRIC_NAME  METRIC_NAME,
	to_char(VALUE) value
FROM	gV\$SYSMETRIC
WHERE	METRIC_NAME IN ('Database CPU Time Ratio','Database Wait Time Ratio')
AND INTSIZE_CSEC = (SELECT MAX(INTSIZE_CSEC) FROM gV\$SYSMETRIC where inst_id=1)
and inst_id=1
UNION
SELECT	to_char(inst_id) || '_' || METRIC_NAME  METRIC_NAME,
	to_char(VALUE) value
FROM	gV\$SYSMETRIC
WHERE	METRIC_NAME IN ('Database CPU Time Ratio','Database Wait Time Ratio')
AND INTSIZE_CSEC = (SELECT MAX(INTSIZE_CSEC) FROM gV\$SYSMETRIC where inst_id=2)
and inst_id=2;


spool off

exit

EOF
echo  "Listner process at node 2 is:" >>  /home/oraep01/alert/ep01_$DT.csv
ps -aef | grep "tnslsnr" | grep -v "grep" |wc -l >> /home/oraep01/alert/ep01_$DT.csv

echo "Listner process at node 1 is:" >> /home/oraep01/alert/ep01_$DT.csv
ssh sreikolvpledb1 ps  -aef | grep "tnslsnr" | grep -v "grep" |wc -l >> /home/oraep01/alert/ep01_$DT.csv
echo  "the mount point status for APPS database node2 is:" >> /home/oraep01/alert/ep01_$DT.csv
df -hPl|awk '{print $2","$4","$6}' >>  /home/oraep01/alert/ep01_$DT.csv
echo  "the mount point status for APPS database node1 is:" >> /home/oraep01/alert/ep01_$DT.csv
echo "-------------------------------------:">> /home/oraep01/alert/ep01_$DT.csv
ssh sreikolvpledb2 df -hPl|awk '{print $2","$4","$6}' >>  /home/oraep01/alert/ep01_$DT.csv

cd $HOME/alert/
cat ep01_$DT.csv|/bin/mailx -s "The production eport precedes" l1.dbsupport@srei.com
mutt -s "The production eport precedes" -a /home/oraep01/alert/ep01_$DT.csv l1.infrasupport@srei.com,l1.dbsupport@srei.com < $HOME/alert/$mailbody
cp -rf /home/oraep01/alert/ep01_$DT.csv /newdump/filesystems/mail/
