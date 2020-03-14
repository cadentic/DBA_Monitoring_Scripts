#cat /dev/null  >  /home/orasp02/alert/logs/abc.txt 
. $HOME/.bash_profile

export DT=`date +%d%m%y_%H%M%S`


sqlplus -S "sys/ebsmanager123 as sysdba" << EOS
--set Heading off
set feedback off
set verify off
set echo off
set linesize 100
set pagesize 0
col DiskName for a10
col DiskGroup for a10
spool asm_disk.lst

select b.name DiskGroup, b.total_mb, b.free_mb
from  v\$asm_diskgroup b; 
spool off
clear screen
exit
EOS

export count=0

cat asm_disk.lst | tr -s " " | cut -d " " -f1,3,4 | while read output;
do
size=$( echo $output | awk '{print $2}' | cut -d " " -f2 )
disk=$( echo $output | awk '{print $1}' | cut -d " " -f1 )
name=$( echo $output | awk '{print $3}' | cut -d " " -f3 )
if [ $size -lt 5000 ]; then

echo "ASM Disk Group " $disk "Member" $name "out of size "  $size "MB"  >>  $HOME/alert/logs/asmdisk_alert_$DT
#/bin/mailx -s "ASM DISK SPACE USAGE by PWC :FOR $ORACLE_UNQNAME" l1.dbsupport@srei.com,l1.infrasupport@srei.com  < $HOME/alert/logs/asmdisk_alert_$DT
#size=$(echo $output | awk '{print $1}' | cut -d  " " -f1 )


for ((i=0;i<1;i++))
  do 
( echo open 192.168.22.110 25
sleep 8
echo helo sreikolvpwspic.srei.com
echo mail from: $HOSTNAME
sleep 2
echo rcpt to: l1.dbsupport@srei.com
sleep 2
echo rcpt to: l1.infrasupport@srei.com
sleep 2
echo data
sleep 2
echo subject: ASM DISK SPACE USAGE ALERT FOR $ORACLE_SID
echo
echo
echo
echo ASM Disk Group  $disk Member $name out of size   $size MB  
echo  
sleep 5
echo .
sleep 5
echo quit )| telnet

done
fi

done
exit 0

#mailx -s "ASM DISK SPACE USAGE:FOR $ORACLE_UNQNAME" suvendu.roy@in.pwc.com < asm_disk_space_$DT.lst


