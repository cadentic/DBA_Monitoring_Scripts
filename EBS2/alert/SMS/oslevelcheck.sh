
#oslevelcheck.sh  run every 30 minutes separate cronjob
----------------------------------------------------------

## disk space check 95% full and SMS
lst1=`df -Ph | awk '{print $5 $6}'`
for i in $lst1
do
    usg=`echo $i | cut -f1 -d'%'`
    mnt=`echo $i | cut -f2 -d'%'`
    echo "Usage =" $usg
    echo "Mount = " $mnt

      if [ $usg -ge 85 ]
      then
          str=`echo "$mnt is 100 persent full"`
          echo $str
          echo $HOSTNAME
          ##mutt -s "<<Your Subject>>" db.support@srei.com
          wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message= CRITICAL Mount point $mnt in instance $HOSTNAME is 95% full. Thank You&from=SreiBP&to=9830415775"
 wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message= CRITICAL Mount point $mnt in instance $HOSTNAME is 95% full. Thank You&from=SreiBP&to=08983600103"
 wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message= CRITICAL Mount point $mnt in instance $HOSTNAME is 95% full. Thank You&from=SreiBP&to=09021127754"
 wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message= CRITICAL Mount point $mnt in instance $HOSTNAME is 95% full. Thank You&from=SreiBP&to=8336813848"
 wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message= CRITICAL Mount point $mnt in instance $HOSTNAME is 95% full. Thank You&from=SreiBP&to=9331219454"
      fi



      if [ $usg -ge 90 ]
      then
          wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message= CRITICAL Mount point $mnt in instance $HOSTNAME is 95% full. Thank You&from=SreiBP&to=9830888063"
     fi

      if [ $usg -ge 95 ]
      then
          wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message= CRITICAL Mount point $mnt in instance $HOSTNAME is 95% full. Thank You&from=SreiBP&to=9674067272"
       fi



done


