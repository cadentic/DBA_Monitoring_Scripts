#! /bin/bash

find /home/oraep01/monitoring/log  -name "check_wf_mailer*.log" -mtime +1 -type f -exec rm {} \; 2>&1 > /dev/null

. $HOME/.bash_profile

export DT=`date +%d%m%y_%H%M%S`


sqlplus -s " / as sysdba"  << EOS
spool /home/oraep01/monitoring/log/check_wf_mailer_$DT.log
set lines 1000
set head off
select COMPONENT_STATUS
from apps.FND_SVC_COMPONENTS
where component_type='WF_MAILER' and rownum = 1
/
spool off
exit

EOS

mailx -s "Workflow Mailer Status : FOR $ORACLE_UNQNAME" db.support@srei.com < $HOME/log/check_wf_mailer_$DT.log 

exit 0

