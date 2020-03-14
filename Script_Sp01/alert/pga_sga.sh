#!/bin/bash
usr_id=`id -un`
. $HOME/.bash_profile

export DT=`date +%d%m%y_%H%M%S`
#export ORACLE_HOME=/u01/oracle/db
sqlplus -s  " / as sysdba " <<EOF
set linesize 500
set Heading off
set feedback off
set verify off
set echo off
set linesize 300
break on dt
Set pagesize 0
set colsep ','
spool /home/orasp01/alert/logs/Stat_SP01_$DT.csv
select to_char(dt,'DD-MON-YY') dt,inst, round(max(sga),2),round(min(sga),2),round(avg(sga),2),  round(max(pga),2),round(min(pga),2),round(avg(pga),2)
from (
select sn.INSTANCE_NUMBER inst, sga.allo sga, pga.allo pga,(sga.allo+pga.allo) tot,trunc(SN.END_INTERVAL_TIME,'mi') dt
  from
(select snap_id,INSTANCE_NUMBER,round(sum(bytes)/1024/1024/1024,3) allo
   from DBA_HIST_SGASTAT
  group by snap_id,INSTANCE_NUMBER) sga
,(select snap_id,INSTANCE_NUMBER,round(sum(value)/1024/1024/1024,3) allo
    from DBA_HIST_PGASTAT where name = 'total PGA allocated'
   group by snap_id,INSTANCE_NUMBER) pga
, dba_hist_snapshot sn
where sn.snap_id=sga.snap_id
  and sn.INSTANCE_NUMBER=sga.INSTANCE_NUMBER
  and sn.snap_id=pga.snap_id
  and sn.INSTANCE_NUMBER=pga.INSTANCE_NUMBER
order by sn.snap_id desc, sn.INSTANCE_NUMBER
)
group by to_char(dt,'DD-MON-YY'), inst order by 1, 2 ;
##@/home/orasd01/alert/pga_sga.sql
spool off
exit
EOF
cat /home/orasp01/alert/logs/Stat_SP01_$DT.csv >> memory_hlth_sp01.csv
rm -rf /home/orasp01/alert/logs/Stat_SP01_$DT.csv
