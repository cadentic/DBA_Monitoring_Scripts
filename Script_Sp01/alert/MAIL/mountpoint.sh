#cat /dev/null > /home/orasd01/alert/logs/error.txt
export DT=`date +%d%m%y_%H%M%S`
df -h |grep G | tr -s " "  | cut -d " " -f4,5,6|grep -v dev|grep -v tmp | grep -v dump | while read output;
do
  echo $output
    usep=$(echo $output | awk '{ print $2}' | cut -d "%" -f1  )
  partition=$(echo $output | awk '{ print $3 }' )
  if [ $usep -ge 70 ]; then

   echo "Available space and Used percentage on mountpoint  \"$output \" on $(hostname) as on $(date)" >>  $HOME/alert/logs/mountpoint_error_$DT
   /bin/mailx -s "Mount point status of SERVER :FOR $ORACLE_UNQNAME" l1.dbsupport@srei.com,infrasupport@srei.com  < $HOME/alert/logs/mountpoint_error_$DT

for ((i=0;i<1;i++))
  do
( echo open 192.168.22.110 25
sleep 8
echo helo sreikolvpwspic.srei.com
echo mail from: $HOSTNAME
sleep 2
echo rcpt to: l1.dbsupport@srei.com
sleep 2
echo rcpt to: infrasupport@srei.com
sleep 2

echo data
sleep 2
echo subject: OS MOUNTPOINT SPACE USAGE ALERT FOR $ORACLE_SID
echo
echo
echo
echo  Disk usage out of space used space  $usep percentage 
echo  Mount point details of AVAILABLE PERCENTAGEUSED MOUNTPOINT
echo  $output
echo
sleep 5
echo .
sleep 5
echo quit )| telnet

done


  fi

  if [ $usep -ge 85 ]; then

   echo "Available space and Used percentage on mountpoint  \"$output \" on $(hostname) as on $(date)" >>  $HOME/alert/logs/mountpoint_error_$DT
   /bin/mailx -s "Mount point status of SERVER :FOR $ORACLE_UNQNAME" caesar.dutta@in.pwc.com  < $HOME/alert/logs/mountpoint_error_$DT

  fi

  if [ $usep -ge 90 ]; then

   echo "Available space and Used percentage on mountpoint  \"$output \" on $(hostname) as on $(date)" >>  $HOME/alert/logs/mountpoint_error_$DT
   /bin/mailx -s "Mount point status of SERVER :FOR $ORACLE_UNQNAME" ritayan.banerjee@srei.com  < $HOME/alert/logs/mountpoint_error_$DT

  fi

  if [ $usep -ge 95 ]; then

   echo "Available space and Used percentage on mountpoint  \"$output \" on $(hostname) as on $(date)" >>  $HOME/alert/logs/mountpoint_error_$DT
   /bin/mailx -s "Mount point status of SERVER :FOR $ORACLE_UNQNAME" yogeshk@srei.com,abhijit.chakraborty@in.pwc.com  < $HOME/alert/logs/mountpoint_error_$DT

  fi
done
