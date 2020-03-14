#! /bin/bash

. $HOME/.bash_profile

export DT=`date +%d%m%y_%H%M%S`


sqlplus -S "sys/ebsmanager123 as sysdba" << EOS
--set Heading off
set feedback off
set verify off
set echo off
set linesize 800
col DiskName for a10
col DiskGroup for a10
spool asm_disk_space_$DT.lst
select a.name DiskGroup, b.disk_number Disk#, b.name DiskName, b.total_mb, b.free_mb,round((b.total_mb - b.free_mb)/b.total_mb*100,2) "Percentage Full", b.header_status from v\$asm_disk b, v\$asm_diskgroup a where a.group_number (+) =b.group_number order by b.group_number, b.disk_number, b.name;
spool off
exit
EOS

/bin/mailx -s "ASM DISK SPACE USAGE:FOR $ORACLE_UNQNAME" db.support@srei.com ankur.dayama@srei.com sunil.kapireddy@srei.com  < asm_disk_space_$DT.lst 

exit 0
