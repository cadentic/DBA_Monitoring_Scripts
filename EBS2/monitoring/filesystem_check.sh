find /home/oraep01/monitoring/log  -name "filesystem_mail_content_*.txt" -mtime +1 -type f -exec rm {} \; 2>&1 > /dev/null


ADMIN="virtual.infra@srei.com"
DT=`date +%d%m%y_%H%M%S`
# set alert level 90% is default
ALERT=95
 df -P | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $6 }'| while read output;
do 
 #echo $output 
 usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )  
partition=$(echo $output | awk '{ print $2 }' ) 
 if [ $usep -ge $ALERT ]; then    
echo "Running out of space \"$partition ($usep%)\" on $(hostname) as on $(date)"  > /home/oraep01/monitoring/log/filesystem_mail_content_$DT.txt
     mutt  -s "Alert: Almost out of disk space $usep"  $ADMIN < filesystem_mail_content_$DT.txt
fi
done

