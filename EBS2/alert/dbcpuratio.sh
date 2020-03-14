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
               /bin/mailx -s "Warning Database running slow $ORACLE_SID" l1.dbsupport@srei.com
                 
             fi



         fi
      fi
 done

rm a.out



exit



