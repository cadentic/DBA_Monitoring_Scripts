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

cat asm_disk.lst | tr -s " " | cut -d " " -f1,3,4 | while read output;
do
size=$( echo $output | awk '{print $2}' | cut -d " " -f2 )
disk=$( echo $output | awk '{print $1}' | cut -d " " -f1 )
name=$( echo $output | awk '{print $3}' | cut -d " " -f3 )
if [ $size -lt 2000 ]; then
echo "ASM Disk Group " $disk "Member" $name "out of size "  $size "MB"  >>  $HOME/alert/logs/asmdisk_alert_$DT
wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message=ASM space left is less tha 550MB in database $HOSTNAME. Thank You&from=SreiBP&to=9830415775"
wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message=ASM space left is less tha 550MB in database $HOSTNAME. Thank You&from=SreiBP&to=08983600103"
wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message=ASM space left is less tha 550MB in database $HOSTNAME. Thank You&from=SreiBP&to=09021127754"

#size=$(echo $output | awk '{print $1}' | cut -d  " " -f1 )
fi

if [ $size -lt 1500 ]; then
echo "ASM Disk Group " $disk "Member" $name "out of size "  $size "MB"  >>  $HOME/alert/logs/asmdisk_alert_$DT

wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message=ASM space left is less tha 550MB in database $HOSTNAME. Thank You&from=SreiBP&to=9830888063"
#size=$(echo $output | awk '{print $1}' | cut -d  " " -f1 )
fi

if [ $size -lt 1000 ]; then
echo "ASM Disk Group " $disk "Member" $name "out of size "  $size "MB"  >>  $HOME/alert/logs/asmdisk_alert_$DT

wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message=ASM space left is less tha 550MB in database $HOSTNAME. Thank You&from=SreiBP&to=9674067272"
#size=$(echo $output | awk '{print $1}' | cut -d  " " -f1 )
fi

done

exit 0



