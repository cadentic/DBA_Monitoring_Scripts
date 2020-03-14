#! /bin/bash

. $HOME/.bash_profile

export DT=`date +%d%m%y_%H%M%S`

cd $HOME/savior_outputs

sqlplus -S savior/`cat PSD_savior` << EOS
set Heading off
set feedback off
set verify off
set echo off
spool savior_72locsrpt_$DT.csv
select cardno||','||to_char(officepunch,'DD-MON-RR HH24:MM:SS')||','||reasoncode||','||p_day||','||inout||','||ismanual||','||error_code||','||id_no||','||process||','||door_time||','||snrno from tempdata where trunc(officepunch)=trunc(sysdate) and id_no in ('129',
'109',
'166',
'170',
'140',
'155',
'161',
'160',
'142',
'156',
'102',
'164',
'122',
'119',
'159',
'141',
'125',
'127',
'171',
'123',
'138',
'162',
'116',
'154',
'152',
'103',
'130',
'126',
'111',
'133',
'101',
'135',
'114',
'153',
'151',
'117',
'169',
'158',
'165',
'149',
'136',
'172',
'132',
'166',
'121',
'108',
'105',
'142',
'118',
'150',
'143',
'124',
'168',
'113',
'107',
'173',
'147',
'120',
'112',
'128',
'131',
'163',
'157',
'139',
'110',
'137',
'134',
'104',
'167',
'115') ;
spool off
exit
EOS

#cat savior_cardno3_$DT.csv | /bin/mail -s "Savior records of Cardno starting with 3 for yesterday"  virtual.infra@srei.com
#mail -s "Savior records of Cardno starting with 3 for yesterday"  virtual.infra@srei.com < savior_cardno3_$DT.csv

mutt -s "Savior records of 72 Locations for today " -a  savior_72locsrpt_$DT.csv ritayan.banerjee@xenolithtechnologies.com < mailbody1
#mutt -s "Savior records of 72 Locations for today " -a  savior_72locsrpt_$DT.csv virtual.infra@srei.com < mailbody1

#mutt -s "Savior records of Cardno starting with 3 for yesterday " -a savior_cardno3_$DT.csv virtual.infra@srei.com < mailbody

exit 0
