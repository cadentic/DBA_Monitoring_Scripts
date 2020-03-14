#! /bin/bash

. $HOME/.bash_profile

export DT=`date +%d%m%y_%H%M%S`

cd $HOME/savior_outputs

sqlplus -S savior/`cat PSD_savior` << EOS

set Heading off
set feedback off
set verify off
set echo off
spool savior_cardno3_$DT.csv
select cardno||','||to_char(officepunch,'DD-MON-RR HH24:MM:SS')||','||reasoncode||','||p_day||','||inout||','||ismanual||','||error_code||','||id_no||','||process||','||door_time||','||snrno from tempdata where cardno like '3%' and trunc(officepunch) = trunc(sysdate - 1);
spool off
exit
EOS

#cat savior_cardno3_$DT.csv | /bin/mail -s "Savior records of Cardno starting with 3 for yesterday"  virtual.infra@srei.com
#mail -s "Savior records of Cardno starting with 3 for yesterday"  virtual.infra@srei.com < savior_cardno3_$DT.csv

mutt -s "Savior records of Cardno starting with 3 for yesterday " -a savior_cardno3_$DT.csv ritayan.banerjee@xenolithtechnologies.com < mailbody

#mutt -s "Savior records of Cardno starting with 3 for yesterday " -a savior_cardno3_$DT.csv virtual.infra@srei.com < mailbody

exit 0
