#! /bin/bash

. $HOME/.bash_profile

export DT=`date +%d%m%y_%H%M%S`

find /home/oraep01/monitoring/log  -name "asm_disk_space_*.lst" -mtime +1 -type f -exec rm {} \; 2>&1 > /dev/null

sqlplus -s " / as sysdba" << EOS
--set Heading off
set feedback off
set verify off
set echo off
set linesize 800
col DiskName for a10
col DiskGroup for a10
spool /home/oraep01/monitoring/log/asm_disk_space_$DT.lst
select a.name DiskGroup, b.disk_number Disk#, b.name DiskName, b.total_mb, b.free_mb,round((b.total_mb - b.free_mb)/b.total_mb*100,2) "Percentage Full", b.header_status from v\$asm_disk b, v\$asm_diskgroup a where a.group_number (+) =b.group_number order by b.group_number, b.disk_number, b.name;
spool off
exit
EOS

mailx -s "ASM DISK SPACE USAGE:FOR $ORACLE_UNQNAME" virtual.infra@srei.com < asm_disk_space_$DT.lst 

exit 0
