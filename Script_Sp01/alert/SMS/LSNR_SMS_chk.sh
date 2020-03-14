#!/bin/bash
# check to see if lsnr is up , if not email and SMS#
export DT=`date +%d%m%y_%H%M%S`
numproc=`ps -aef | grep "tnslsnr" | grep -v "grep" |wc -l` 
echo $numproc
if  [ $numproc -lt 2 ]
then
     echo "here i am"
     echo "Date        : "`date '+%m/%d/%y %X %A '` >> $pmonflie 
     echo "Hostname    : "`hostname` >> $pmonflie 
     echo "  Databases is down on $HOSTNAME please check " >> $pmonflie 
    ##mutt -s "Warning: LISENTER down in $HOSTNAME" db.support@srei.com 
    ## SMS code here
echo 'wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message=LSNR process not found in $HOSTNAME. Thank You&from=SreiBP&to=9830415775"' >> LSNR_$ORACLE_SID
echo 'wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message=LSNR process not found in $HOSTNAME. Thank You&from=SreiBP&to=08983600103"' >>  LSNR_$ORACLE_SID
echo 'wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message=LSNR process not found in $HOSTNAME. Thank You&from=SreiBP&to=09021127754"' >>  LSNR_$ORACLE_SID
echo 'wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message=LSNR process not found in $HOSTNAME. Thank You&from=SreiBP&to=8420149273"' >>  LSNR_$ORACLE_SID
fi


if  [ $numproc -lt 1 ]
then

echo 'wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message=LSNR process not found in $HOSTNAME. Thank You&from=SreiBP&to=9830888063"' >>  LSNR_$ORACLE_SID
echo 'wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message=LSNR process not found in $HOSTNAME. Thank You&from=SreiBP&to=9674067272"' >> LSNR_$ORACLE_SID
fi
cp LSNR_$ORACLE_SID /newdump/filesystems/sms/
cd /newdump/filesystems/sms/
mv * *.sh
chmod 777 *.sh




exit


