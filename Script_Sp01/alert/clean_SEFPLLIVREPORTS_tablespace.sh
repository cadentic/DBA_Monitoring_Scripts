#!/bin/bash
id=`id -un`

. $HOME/.bash_profile

export DT=`date +%d%m%y_%H%M%S`

SPOOLF=$HOME/alert/logs/do_not_remove_dbspace_$DT.out
## alert for tablespace check
sqlplus -s  "/ as sysdba" >> $SPOOLF << EOS
set Heading off;
set feedback off;
set verify off;
set echo off;
set linesize 500;
set pagesize 75;

      spool $HOME/alert/logs/cleanSEFPLLIVEREPORTS.sql;
      select 'DROP TABLE '||owner||'.' || table_name || ' purge ;' FROM DBA_TABLES WHERE  TABLESPACE_NAME='SEFPLLIVEREPORTS' AND TABLE_NAME LIKE 'TMP_%';
      spool off;
      exit;
EOS
## select 'DROP TABLE SEFPLLIVE.' || table_name || ' purge ;' FROM DBA_TABLES WHERE OWNER='SEFPLLIVE' AND TABLESPACE_NAME='SEFPLLIVEREPORTS' AND TABLE_NAME LIKE 'TMP_%';

sqlplus -s  "/ as sysdba" >> $SPOOLF << EOD
      @$HOME/alert/logs/cleanSEFPLLIVEREPORTS.sql
      --purge dba_recyclebin;
     exit;
EOD
cat $HOME/alert/logs/cleanSEFPLLIVEREPORTS.sql >  $HOME/alert/logs/clean_TBS_$DT.txt
rm $HOME/alert/logs/cleanSEFPLLIVEREPORTS.sql
ff=unix
