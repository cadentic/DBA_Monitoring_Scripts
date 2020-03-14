
# check to see if Pmon is up , if not email and SMS# here too separate for SMS after 30 minutes
umproc=`ps -aef | grep "pmon" | grep -v "grep" |wc -l` 
echo $numproc
if  [ $numproc -lt 2 ]
then
     echo "here i am"
     echo "Date        : "`date '+%m/%d/%y %X %A '` >> $pmonflie 
     echo "Hostname    : "`hostname` >> $pmonflie 
     echo "  Databases is down on $HOSTNAME please check " >> $pmonflie 
    ##mutt -s "Warning: PMON down in $HOSTNAME" db.support@srei.com 
    ## SMS code here
echo wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message=PMON process not found in $HOSTNAME. Thank You&from=SreiBP&to=9830415775" >> PMON_$ORACLE_SID
echo wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message=PMON process not found in $HOSTNAME. Thank You&from=SreiBP&to=08983600103"  >> PMON_$ORACLE_SID
echo wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message=PMON process not found in $HOSTNAME. Thank You&from=SreiBP&to=09021127754"  >> PMON_$ORACLE_SID
echo wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message=PMON process not found in $HOSTNAME. Thank You&from=SreiBP&to=8420149273"  >> PMON_$ORACLE_SID
echo wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message=PMON process not found in $HOSTNAME. Thank You&from=SreiBP&to=9830888063" >> PMON_$ORACLE_SID
 wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message=PMON process not found in $HOSTNAME. Thank You&from=SreiBP&to=9674067272"
fi
cp PMON_$ORACLE_SID /newdump/filesystems/sms/
cd /newdump/filesystems/sms/
mv * *.sh
chmod 777 *.sh

exit


