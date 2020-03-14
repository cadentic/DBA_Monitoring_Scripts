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
             
             if [ $cpu -gt 5 | $cpu -lt 20 ]
             then
                 
               #mutt -s "Warning Database running slow $ORACLE_SID" l1.dbsupport@srei.com
               /bin/mailx -s "Warning Database running slow $ORACLE_SID" l1.dbsupport@srei.com,l1.infrasupport@srei.com
                for ((i=0;i<1;i++))
                 do
                   ( echo open 192.168.22.110 25
                   sleep 8
                   echo helo sreikolvpwspic.srei.com
                   echo mail from: $HOSTNAME
                   sleep 2
                   echo rcpt to: l1.dbsupport@srei.com
                   sleep 2
                   echo data
                   sleep 2
                   echo subject: DATABASE CPU USAGE ALERT FOR $ORACLE_SID
                   echo
                   echo
                   echo
                   echo DATABSE CPU USAGE $cpu FOR $ORACLE_SID
                   echo
                   sleep 5
                   echo .
                   sleep 5
                   echo quit )| telnet

                   done
     
             
            
	     fi
             
             if [ $cpu -gt 10 | $cpu -lt 15 ]
             then
                 
               #mutt -s "Warning Database running slow $ORACLE_SID" l1.dbsupport@srei.com
               /bin/mailx -s "Warning Database running slow $ORACLE_SID" caesar.dutta@in.pwc.com
                 
             fi
             
             if [ $cpu -gt 5 | $cpu -lt 10 ]
             then
                 
               #mutt -s "Warning Database running slow $ORACLE_SID" l1.dbsupport@srei.com
               /bin/mailx -s "Warning Database running slow $ORACLE_SID" ritayan.banerjee@srei.com
                 
             fi
             
             if [ $cpu -gt 2 | $cpu -lt 5 ]
             then
                 
               #mutt -s "Warning Database running slow $ORACLE_SID" l1.dbsupport@srei.com
               /bin/mailx -s "Warning Database running slow $ORACLE_SID" yogeshk@srei.com,abhijit.chakraborty@in.pwc.com 
                 
             fi
         fi
      fi
 done

rm a.out



exit



