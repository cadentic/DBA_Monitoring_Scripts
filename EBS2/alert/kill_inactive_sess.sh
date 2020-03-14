sqlplus -s '/as sysdba' << EOF

cat /dev/null > kill_inactive_session.sql
spool kill_inactive_session.sql;
select 'alter system kill session ' || '''' || sid || ',' || serial# || '''' || ' immediate;' from gv\$session where username IN ('APPS', 'APPSREADONLY', 'APPLSYS', 'XXSREI') and status='INACTIVE'and last_call_et> 400;
spool off;

@kill_inactive_session.sql;


EOF

