#!/bin/bash
# check to see if lsnr is up , if not email and SMS#
numproc=`ps -aef | grep "tnslsnr" | grep -v "grep" |wc -l`
echo $numproc
if  [ $numproc -lt 2 ]
then
     echo "here i am"
     echo "Date        : "`date '+%m/%d/%y %X %A '` >> $pmonflie
     echo "Hostname    : "`hostname` >> $pmonflie
     echo "  Databases is down on $HOSTNAME please check " >> $pmonflie
    /bin/mailx -s "Warning: LISENTER down in $HOSTNAME" l1.dbsupport@srei.com
   
fi


exit

