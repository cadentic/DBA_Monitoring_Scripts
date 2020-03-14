sqlplus -s '/as sysdba' << EOF

--alter user SREI_PMS account lock;
!cat /dev/null > kill_session.sql
spool kill_session.sql;
set heading off;
select 'alter system kill session ' || '''' || sid || ',' || serial# || '''' ||' immediate;' from v\$session where username in('SIFLLIVE_PRODTEST');


spool off;

@kill_session.sql;
--alter user SREI_PMS account unlock;


EOF

