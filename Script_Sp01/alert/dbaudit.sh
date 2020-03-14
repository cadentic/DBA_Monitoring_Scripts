#!/bin/bash
. ~/.bash_profile

sqlplus -s "/ as sysdba"<<-EOF
DELETE FROM AUD$ WHERE NTIMESTAMP# < SYSDATE - 16;
delete from dba_recyclebin where to_date(droptime, 'YYYY-MM-DD:HH24:MI:SS') < sysdate - 16 order by droptime desc;
EOF
ff=unix                    
