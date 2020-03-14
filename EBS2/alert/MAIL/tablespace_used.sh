. $HOME/.bash_profile

export DT=`date +%d%m%y_%H%M%S`

rm -f $HOME/alert/logs/tablespace_used_*.log

> $HOME/alert/logs/do_not_remove_tablespace_used.lst

sqlplus -s  "/ as sysdba" > $HOME/alert/logs/do_not_remove_tablespace_used.lst  << EOS
set Heading off
set feedback off
set verify off
set echo off
set linesize 500
set pagesize 75

select 
           tablespace_name, 
           round(used_space/(1024*1024),2), 
           round(tablespace_size/(1024*1024),2), 
           round(used_percent, 2) 
from 
           dba_tablespace_usage_metrics
where 
           round(used_percent,2) > 70;
EOS


cat $HOME/alert/logs/do_not_remove_tablespace_used.lst|awk '{printf "%.0f\n", $4}'|while read output;
do

if [ $found -gt 70 ]
then
      cat $HOME/alert/logs/do_not_remove_tablespace_used.lst > $HOME/alert/logs/tablespace_used_$DT.log

     cat $HOME/alert/logs/tablespace_used_$DT.log | /bin/mail -s "Critical tablespace alert" l1.dbsupport@srei.com,l1.infrasupport@srei.com

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
echo subject: TABLESPACE USAGE ALERT FOR $ORACLE_SID
echo
echo
echo
echo TABLESPACE  Member  used   $found percentage
echo $HOME/alert/logs/tablespace_used_$DT.log
sleep 5
echo .
sleep 5
echo quit )| telnet

done

fi
 

if [ $found -gt 85 ]
then
      cat $HOME/alert/logs/do_not_remove_tablespace_used.lst > $HOME/alert/logs/tablespace_used_$DT.log

     cat $HOME/alert/logs/tablespace_used_$DT.log | /bin/mail -s "Critical tablespace alert" caesar.dutta@in.pwc.com 
fi

if [ $found -gt 90 ]
then
      cat $HOME/alert/logs/do_not_remove_tablespace_used.lst > $HOME/alert/logs/tablespace_used_$DT.log

     cat $HOME/alert/logs/tablespace_used_$DT.log | /bin/mail -s "Critical tablespace alert" ritayan.banerjee@srei.com
fi

if [ $found -gt 95 ]
then
      cat $HOME/alert/logs/do_not_remove_tablespace_used.lst > $HOME/alert/logs/tablespace_used_$DT.log

     cat $HOME/alert/logs/tablespace_used_$DT.log | /bin/mail -s "Critical tablespace alert" yogeshk@srei.com,abhijit.chakraborty@in.pwc.com
fi

done

exit 0

