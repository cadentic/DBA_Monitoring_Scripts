
#!/bin/bash

cd /rac1/gridhome/bin 

chk=`./crsctl check crs | grep -i "online" | wc -l`


if [ $chk -ne 4 ] 
then
   ##mutt -s "Warning Cluster Down $HOSTNAME" db.support@srei.com 
   ## SMS code here
 wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message=CRSD process not found in $HOSTNAME. Thank You&from=SreiBP&to=9830415775"
 wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message=CRSD process not found in $HOSTNAME. Thank You&from=SreiBP&to=08983600103"
 wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message=CRSD process not found in $HOSTNAME. Thank You&from=SreiBP&to=09021127754"
 wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message=CRSD process not found in $HOSTNAME. Thank You&from=SreiBP&to=9830888063"
 wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message=CRSD process not found in $HOSTNAME. Thank You&from=SreiBP&to=9674067272"

fi
exit


