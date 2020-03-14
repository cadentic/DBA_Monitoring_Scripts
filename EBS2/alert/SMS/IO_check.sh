---------------------------------------------------------------------------------------------------------------

#IO_check.sh run every 10 minutes
-------------------------------------

#!/bin/bash

## alert for high I/O wait
sqlplus -s "  / as sysdba " > a.out << EOS
        SELECT
        to_char(VALUE) value
        FROM    V\$SYSMETRIC
        WHERE   METRIC_NAME ='Database CPU Time Ratio'
        AND INTSIZE_CSEC = (SELECT MAX(INTSIZE_CSEC) FROM V\$SYSMETRIC);

EOS

llist=`cat a.out | awk '{print $1}'`
echo $llist


for cpu in $llist
do
     if [ $cpu != 'VALUE' ]
     then
         if [ $cpu != '----------------------------------------' ]
         then
             cpu=`echo $cpu | cut -f1 -d'.'`
             if [ $cpu -lt 5 ]
             then
                 ##SMS   database not responding
             fi

  if [ $cpu -lt 20 ]
             then
                 ##email  database running slow
               ##mutt -s "Warning Database running slow $ORACLE_SID" db.support@srei.com
                 wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message=I/O WAIT is above 90% in instance $HOSTNAME. Thank You&from=SreiBP&to=9830415775"
		wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message=I/O WAIT is above 90% in instance $HOSTNAME. Thank You&from=SreiBP&to=08983600103"
		wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message=I/O WAIT is above 90% in instance $HOSTNAME. Thank You&from=SreiBP&to=09021127754"
             fi


  if [ $cpu -lt 10 ]
             then
                 ##email  database running slow
               ##mutt -s "Warning Database running slow $ORACLE_SID" db.support@srei.com
                 wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message=I/O WAIT is above 90% in instance $HOSTNAME. Thank You&from=SreiBP&to=9830888063"
             fi
  if [ $cpu -lt 5 ]
             then
                 ##email  database running slow
               ##mutt -s "Warning Database running slow $ORACLE_SID" db.support@srei.com
                 wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message=I/O WAIT is above 90% in instance $HOSTNAME. Thank You&from=SreiBP&to=9674067272"
             fi
             

         fi
      fi
 done

rm a.out



exit

-------------------------------------------------------------------------------------------------------------- 
