export DT=`date +%d%m%y_%H%M%S`

sqlplus -S "sys/ebsmanager123 as sysdba" << EOS


set Heading off
set feedback off
set verify off
set echo off
set linesize 300
break on dt
Set pagesize 0
set colsep ','


spool /home/orasp01/alert/logs/CPU_RATIO_$DT.csv



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
EOS
