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
    /bin/mailx -s "Warning: LISENTER down in $HOSTNAME" l1.dbsupport@srei.com,l1.infrasupport@srei.com

for ((i=0;i<1;i++))
  do
( echo open 192.168.22.110 25
sleep 8
echo helo sreikolvpwspic.srei.com
echo mail from: $HOSTNAME
sleep 2
echo rcpt to: l1.dbsupport@srei.com
sleep 2
echo rcpt to: l1.infrasupport@srei.com
sleep 2
echo data
sleep 2
echo subject: LISENTER PROCESS USAGE ALERT FOR $ORACLE_SID
echo
echo
echo
echo LISENTER PROCESS MAY BE DOWN
echo $pmonfile
sleep 5
echo .
sleep 5
echo quit )| telnet

done
   
fi

if  [ $numproc -lt 1 ]
then
     echo "here i am"
     echo "Date        : "`date '+%m/%d/%y %X %A '` >> $pmonflie
     echo "Hostname    : "`hostname` >> $pmonflie
     echo "  Databases is down on $HOSTNAME please check " >> $pmonflie
    /bin/mailx -s "Warning: LISENTER down in $HOSTNAME" ritayan.banerjee@srei.com,caesar.dutta@in.pwc.com,yogeshk@srei.com,abhijit.chakraborty@in.pwc.com
   
fi

exit

