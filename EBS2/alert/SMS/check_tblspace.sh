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

if [ $found -gt 80 ]
then
      wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message= CRITICAL tablespace found in database $HOSTNAME.Thank You&from=SreiBP&to=9830415775"
 wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message= CRITICAL tablespace found in database $HOSTNAME.Thank You&from=SreiBP&to=08983600103"
 wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message= CRITICAL tablespace found in database $HOSTNAME.Thank You&from=SreiBP&to=09021127754"

fi


if [ $found -gt 90 ]
then
       wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message= CRITICAL tablespace found in database $HOSTNAME.Thank You&from=SreiBP&to=9830888063"
fi

if [ $found -gt 95 ]
then
    wget --no-check-certificate "http://mobiprom.com/smsclient/pushsms.jsp?user=CL20640&password=XGFz5Hw&message= CRITICAL tablespace found in database $HOSTNAME.Thank You&from=SreiBP&to=9674067272"

fi

done

exit 0

