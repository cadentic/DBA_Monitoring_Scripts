
#!/bin/bash

cd /u01/grid/11.2.0/bin

chk=`./crsctl check crs | grep -i "online" | wc -l`


if [ $chk -ne 4 ] 
then
   ##mutt -s "Warning Cluster Down $HOSTNAME" db.support@srei.com 
   ## SMS code here
 echo wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message=CRSD process not found in $HOSTNAME. Thank You&from=SreiBP&to=9830415775" >> cluster_$ORACLE_SID
echo wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message=CRSD process not found in $HOSTNAME. Thank You&from=SreiBP&to=08983600103" >> cluster_$ORACLE_SID
echo wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message=CRSD process not found in $HOSTNAME. Thank You&from=SreiBP&to=09021127754" >> cluster_$ORACLE_SID
echo wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message=CRSD process not found in $HOSTNAME. Thank You&from=SreiBP&to=9830888063" >> cluster_$ORACLE_SID
echo wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message=CRSD process not found in $HOSTNAME. Thank You&from=SreiBP&to=9674067272" >> cluster_$ORACLE_SID

fi

cp  cluster_$ORACLE_SID /newdump/filesystems/sms/
cd /newdump/filesystems/sms/
mv * *.sh
chmod 777 *.sh

exit


