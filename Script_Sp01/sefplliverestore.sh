sqlplus '/ as sysdba' << EOS
--- command to spool file with date
column tm new_value file_time noprint
select to_char(sysdate,'dd-mm-RR-HH24_MI_SS') tm from dual ;
spool SEFLCOLLATERAL__creation_&file_time
--create tablespace SEFPLLIVE_04052016 datafile '/data/app/oracle/sefldev/SEFPLLIVE_0405201601.dbf' size 2g autoextend on next 128m maxsize 30G;
--alter tablespace SEFPLLIVE_04052016 datafile '/data/app/oracle/sefldev/SEFPLLIVE_0405201602.dbf' size 2g autoextend on next 128m maxsize 30G;
--alter tablespace SEFPLLIVE_04052016 datafile '/data/app/oracle/sefldev/SEFPLLIVE_0405201603.dbf' size 2g autoextend on next 128m maxsize 30G;
--alter tablespace SEFPLLIVE_04052016 datafile '/data/app/oracle/sefldev/SEFPLLIVE_0405201604.dbf' size 2g autoextend on next 128m maxsize 30G;
--alter tablespace SEFPLLIVE_04052016 datafile '/data/app/oracle/sefldev/SEFPLLIVE_0405201605.dbf' size 2g autoextend on next 128m maxsize 30G;
--alter tablespace SEFPLLIVE_04052016 datafile '/data/app/oracle/sefldev/SEFPLLIVE_0405201606.dbf' size 2g autoextend on next 128m maxsize 30G;
--alter tablespace SEFPLLIVE_04052016 datafile '/data/app/oracle/sefldev/SEFPLLIVE_0405201607.dbf' size 2g autoextend on next 128m maxsize 30G;
--alter tablespace SEFPLLIVE_04052016 datafile '/data/app/oracle/sefldev/SEFPLLIVE_0405201608.dbf' size 2g autoextend on next 128m maxsize 30G;
--create user SEFPLLIVE_040616 identified by sreig00d default tablespace SEFPLLIVE_040616 quota unlimited on SEFPLLIVE_040616;
grant connect,resource to SEFPLLIVE;
grant read,write on directory DATA_PUMP_DIR to SEFPLLIVE;
grant read,write on directory DUMP_BACKUP to SEFPLLIVE;
grant read,write on directory SEFLCOLLATERAL to SEFPLLIVE;
grant read,write on directory SP01_DIR to SEFPLLIVE;
grant read,write on directory SANP05 to SEFPLLIVE;
grant read,write on directory SANP01 to SEFPLLIVE;
grant read,write on directory TCL_BKP to SEFPLLIVE;
grant create job to SEFPLLIVE;
grant execute any procedure to SEFPLLIVE;
grant create database link to SEFPLLIVE;
grant CREATE SEQUENCE,CREATE TABLE,CREATE TRIGGER,CREATE PROCEDURE,CREATE VIEW,CREATE TYPE to SEFPLLIVE;
select trigger_name,status from dba_triggers where trigger_name like 'LOGON%';
--create trigger logon_SEFLCOLLATERAL after logon on database
--begin
--if user = 'SEFLCOLLATERAL' then
--execute immediate 'alter session set optimizer_mode=first_rows_128';
--execute immediate 'alter session set cursor_sharing=FORCE';
--execute immediate 'alter session set session_cached_cursors = 200';
--end if;
--end;
--/
EOS
impdp system/lenovo123 dumpfile=SEFPLLIVE04-06-16.DMP logfile=SEFPLLIVE06-06-16_imp.log remap_schema=SEFPLLIVE:SEFPLLIVE remap_tablespace=SEFPLLIVE:SEFPLLIVE transform=oid:n directory=SANP05
exit

sqlplus '/ as sysdba' << EOF
@$ORACLE_HOME/rdbms/admin/utlrp.sql
--- command to spool file with date
column tm new_value file_time noprint
select to_char(sysdate,'dd-mm-RR-HH24_MI_SS') tm from dual ;
spool SEFLCOLLATERAL_invalids_&file_time
select count(1),object_type from dba_objects where owner='SEFPLLIVE' group by object_types ;
select count(1),object_type from dba_objects where owner='SEFPLLIVE' and status<>'VALID' group by object_type;
Alter user SEFPLLIVE identified by sreig00d;
Alter user SEFPLLIVE account unlock;
exit
EOF



cat nohup.out >> SEFPLLIVE_040616.txt

cat /home/orasp01/SEFPLLIVE_040616.txt|/bin/mail -s "Restore status of SEFPLLIVE schema" l1.dbsupport@srei.com
exit 0

