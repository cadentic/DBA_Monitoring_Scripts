#!/bin/bash
. ~/.bash_profile

export DT=`date +%d%m%y_%H%M%S`

SPOOLFILE=$HOME/alert/db_audit_SP01_$DT.csv
SUBJECT="Daily database audit log for $ORACLE_SID `date '+%m/%d/%y %X %A '`"
BODY=$HOME/alert/db_audit_report_email_body.txt
MAILTO='l1.dbsupport@srei.com' 
MAILTO1='Ritayan.Banerjee@srei.com' 
MAILTO2='indrajyoti.mukherjee@xenolithtechnologies.com' 

## Obtain audit data in spool file
#sqlplus -s "/ as sysdba">$SPOOLFILE<<-EOF
sqlplus -s "/ as sysdba"<<-EOF
SET ECHO OFF
SET LINESIZE 700
set feedback off
SET VERIFY OFF
SET HEA OFF
SELECT 'DBASE AUDIT REPORT FOR ' || TO_CHAR(SYSDATE, 'DD-Mon-YY') FROM DUAL;
SELECT '===================================================================================' from dual;
SET HEA ON
set colsep ','
spool audit.csv;
SET PAGESIZE 1000
COLUMN USERNAME 	FORMAT a20
COLUMN OS_USERNAME 	FORMAT a20
COLUMN USERHOST		FORMAT a40
COLUMN OBJ_NAME		FORMAT a30
COLUMN OWNER_OF_OBJECT	FORMAT a20
COLUMN EXTENDED_TIMESTAMP	FORMAT A22
COLUMN ACTION_NAME	FORMAT a50
        SELECT 	username,
		os_username,
		USERHOST,
		OBJ_NAME,
		OWNER OWNER_OF_OBJECT,
		to_char(extended_timestamp,'DD-MON-YYYY HH24:MI:SS') extended_timestamp,
		decode(to_char(returncode),'1017','FAILED LOGON','0', decode(to_char(action ),'100', 'LOGON','101','LOGOFF'),  substr(sql_text,1,50)) action_name
	FROM   dba_audit_trail
        WHERE   trunc(extended_timestamp)=trunc(sysdate -1)
        --AND     ACTION_NAME <> 'LOGON' 
        and os_username not in ('root','Administrator','SYSTEM','ASP.NET v4.0','saidadmin','wcfAMBITU','NEW_GEN_REPORTs','orasp01') 
        ORDER BY timestamp;
spool off;
SET ECHO ON
SET FEEDBACK ON
SET VERIFY ON
SET LINESIZE 80   

DELETE FROM AUD$ WHERE TIMESTAMP# < SYSDATE -16;
EOF
cat audit.csv >> $SPOOLFILE
rm -f audit.csv
gzip $SPOOLFILE
mutt -s "$SUBJECT" -a $SPOOLFILE.gz $MAILTO < $BODY
#mutt -s "$SUBJECT" -a $SPOOLFILE $MAILTO  < $BODY
mutt -s "$SUBJECT" -a $SPOOLFILE.gz $MAILTO1  < $BODY
mutt -s "$SUBJECT" -a $SPOOLFILE.gz $MAILTO2  < $BODY
#cp $SPOOLFILE /newdump/filesystems/mail/

exit
ff=unix
