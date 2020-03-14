#cat /dev/null > /home/orasd01/alert/logs/error.txt
export DT=`date +%d%m%y_%H%M%S`
df -h |grep G | tr -s " "  | cut -d " " -f4,5,6|grep -v dev|grep -v tmp | grep -v dump | while read output;
do
  echo $output
    usep=$(echo $output | awk '{ print $2}' | cut -d "%" -f1  )
  partition=$(echo $output | awk '{ print $3 }' )
  if [ $usep -ge 20 ]; then

   echo "Available space and Used percentage on mountpoint  \"$output \" on $(hostname) as on $(date)" >>  $HOME/alert/logs/mountpoint_error_$DT
   /bin/mailx -s "Mount point status of SERVER :FOR $ORACLE_UNQNAME" caesar.dutta@in.pwc.com  < $HOME/alert/logs/mountpoint_error_$DT
   /bin/mailx -s "Mount point status of SERVER :FOR $ORACLE_UNQNAME" caesardutta@gmail.com  < $HOME/alert/logs/mountpoint_error_$DT
   /bin/mailx -s "Mount point status of SERVER :FOR $ORACLE_UNQNAME"  caesardutta@yahoo.com  < $HOME/alert/logs/mountpoint_error_$DT
   /bin/mailx -s "Mount point status of SERVER :FOR $ORACLE_UNQNAME" subrata.pramanik@in.pwc.com  < $HOME/alert/logs/mountpoint_error_$DT
   /bin/mailx -s "Mount point status of SERVER :FOR $ORACLE_UNQNAME" l1.dbsupport@srei.com,infrasupport@srei.com  < $HOME/alert/logs/mountpoint_error_$DT
  fi
done
