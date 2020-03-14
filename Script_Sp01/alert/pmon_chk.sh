#!/bin/bash
export DT=`date +%d%m%y_%H%M%S`
pmonflie=$HOME/alert/logs/pmon_alert$DT

# check to see if Pmon is up , if not email#
if  [ `ps -ef|grep pmon|grep -v grep|wc -l` -lt 2 ]; then
     echo "Date        : "`date '+%m/%d/%y %X %A '` >> $pmonflie
     echo "Hostname    : "`hostname` >> $pmonflie
     echo "Pmon is down on $hostname please check " >>  $pmonflie

     /bin/mailx -s "DB might be down  on $hostname please check " l1.dbsupport@srei.com,l1.infrasupport@srei.com,ritayan.banerjee@srei.com,caesar.dutta@in.pwc.com,yogeshk@srei.com,abhijit.chakraborty@in.pwc.com < $pmonflie


fi
