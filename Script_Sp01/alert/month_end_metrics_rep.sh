#!/bin/bash
. ~/.bash_profile

SPOOLFILE=monthly_dbase_metric_report-sp01_JUNE_2016.xls

rm $SPOOLFILE

sqlplus -s "/ as sysdba">$SPOOLFILE <<-EOF
set echo off
set veri off
set feed off
set linesize 600
set pagesize 1000
SET MARKUP HTML ON ENTMAP ON
PROMPT =======CPU_METRICS SP011======
select DAY, HOST_CPU_UTIL_PCT,ORA_CPU_UTIL_PCT, ORA_CPU_WAIT_PCT  from tbl_monthly_cpu_metrics where trim(month) = 'JUNE' AND INST_ID=1 AND TO_CHAR(TO_DAY,'YYYY') = '2016' order by DAY ASC;
PROMPT =======CPU_METRICS SP012======
select DAY, HOST_CPU_UTIL_PCT,ORA_CPU_UTIL_PCT, ORA_CPU_WAIT_PCT  from tbl_monthly_cpu_metrics where trim(month) = 'JUNE' AND INST_ID=2 AND TO_CHAR(TO_DAY,'YYYY') = '2016' order by DAY ASC;
PROMPT ======MEM_METRICS SP011=======
select  DAY,SGA_MAX_SIZE, SGA_VARIABLE_SIZE, SGA_TARGET, PGA_AGGREGATE_TARGET, PGA_ALLOCATED , PGA_USED from tbl_monthly_mem_metrics where trim(month) = 'JUNE' AND TO_CHAR(TO_DAY, 'YYYY') = '2016' AND INST_ID = 1 order by DAY ASC;
PROMPT ======MEM_METRICS SP012=======
select  DAY, SGA_MAX_SIZE, SGA_VARIABLE_SIZE, SGA_TARGET, PGA_AGGREGATE_TARGET, PGA_ALLOCATED , PGA_USED from tbl_monthly_mem_metrics where trim(month) = 'JUNE' AND TO_CHAR(TO_DAY,'YYYY') = '2016' AND INST_ID = 2 order by DAY ASC;
EOF


exit

