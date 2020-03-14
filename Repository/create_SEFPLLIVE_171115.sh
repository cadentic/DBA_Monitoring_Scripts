export DT=`date +%d%m%y_%H%M%S`


sqlplus '/ as sysdba' << EOS
--- command to spool file with date
create tablespace  SEFPLKSTLE102       datafile '/data/SANP03/SEFPLKASTLE102_01.dbf'     size 2gb  autoextend on next 128m maxsize 30G;
alter tablespace  SEFPLKASTLE102   add datafile '/data/SANP03/SEFPLKASTLE102_02.dbf' size 2gb  autoextend on next 128m  maxsize 30G;
--alter tablespace  SEFPLKASTLE101   add datafile '/data/SANP03/SEFPLKASTLE102_03.dbf' size 2g autoextend on next 128m maxsize 30G;
--alter tablespace SEFPLLIVE_SUNGARD add datafile '/data/SANP03/SEFPLLIVE_SUNGARD04.dbf' size 2g autoextend on next 128m maxsize 30G;
--alter tablespace SEFPLLIVE_SUNGARD add datafile '/data/SANP03/SEFPLLIVE_SUNGARD05.dbf' size 2g autoextend on next 128m maxsize 30G;
--alter tablespace SEFPLLIVE_SUNGARD add datafile '/data/SANP03/SEFPLLIVE_SUNGARD06.dbf' size 2g autoextend on next 128m maxsize 30G;
--alter tablespace SEFPLLIVE_SUNGARD add datafile '/data/SANP03/SEFPLLIVE_SUNGARD07.dbf' size 2g autoextend on next 128m maxsize 30G;
--alter tablespace SEFPLLIVE_SUNGARD add datafile '/data/SANP03/SEFPLLIVE_SUNGARD08.dbf' size 2g autoextend on next 128m maxsize 30G;


create user SEFPLKASTLE102  identified by pass1234  default tablespace SEFPLKASTLE102  quota unlimited on SEFPLKASTLE102;


grant connect,resource to SEFPLKASTLE102;
grant read,write on directory DATA_PUMP_DIR to SEFPLKASTLE102;
--grant read,write on directory DUMP_BACKUP to SEFPLKASTLE101;
grant read,write on directory DAILY_BACKUP to  SEFPLKASTL2102;
grant CREATE SEQUENCE,CREATE TABLE,CREATE TRIGGER,CREATE PROCEDURE,CREATE VIEW,CREATE TYPE to SEFPLKASTLE102;
exit

EOS

impdb system/oracle dumpfile=SEFPLKASTLE_171115.DMP logfile=SEFPLKASTLE_171115.log remap_schema=SEFPLKASTLE:SEFPLKASTLE102 remap_tablespace= SEFPLKASTLE:SEFPLKASTLE102 directory=DATA_PUMP_DIR

--impdp system/oracle dumpfile=SEFPLLIVE_131115_050001.DMP logfile=SEFPLLIVE_SUNGARD_$DT.log remap_schema=SEFPLLIVE:SEFPLLIVE_SUNGARD remap_tablespace=SEFPLLIVE:SEFPLLIVE_SUNGARD directory=SANP05

sqlplus '/ as sysdba' << EOF
@$ORACLE_HOME/rdbms/admin/utlrp.sql
--- command to spool file with date
column tm new_value file_time noprint
select to_char(sysdate,'dd-mm-RR-HH24_MI_SS') tm from dual ;
spool SEFPLLIVE_SUNGARD_invalids_&file_time
select count(1),object_type from dba_objects where owner='SEFPLKASTLE102' group by object_type order by 2 ;
select count(1),object_type from dba_objects where owner='SEFPLKASTLE102' and status<>'VALID' group by object_type order by 2 ;
alter user SEFPLKASTLE102 identified by pass1234;
alter user SEFPLKASTLE102  account unlock;
exit
EOF

