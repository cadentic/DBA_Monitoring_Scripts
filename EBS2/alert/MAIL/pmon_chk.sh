#!/bin/bash
export DT=`date +%d%m%y_%H%M%S`
pmonflie=$HOME/alert/logs/pmon_alert$DT

# check to see if Pmon is up , if not email#
if  [ `ps -ef|grep pmon|grep -v grep|wc -l` -lt 2 ]; then
     echo "Date        : "`date '+%m/%d/%y %X %A '` >> $pmonflie
     echo "Hostname    : "`hostname` >> $pmonflie
     echo "Pmon is down on $hostname please check " >>  $pmonflie

     /bin/mailx -s "DB might be down  on $hostname please check " l1.dbsupport@srei.com,l1.infrasupport@srei.com,ritayan.banerjee@srei.com,caesar.dutta@in.pwc.com,yogeshk@srei.com,abhijit.chakraborty@in.pwc.com < $pmonflie
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
echo subject: PMON USAGE ALERT FOR $ORACLE_SID
echo
echo
echo
echo PMON SERVER PROCESS MAY BE DOWN 
echo $pmonflie
echo
sleep 5
echo .
sleep 5
echo quit )| telnet

done

fi
