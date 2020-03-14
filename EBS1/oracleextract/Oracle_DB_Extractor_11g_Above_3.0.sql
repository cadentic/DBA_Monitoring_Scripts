--*  ACT TOOL EXTRACTION SCRIPT FOR ORACLE DATABASE 11g AND ABOVE
 
--* REVISION HISTORY:
--* --------------------------------------------------------------------------------
--*   VERSION        DATE          AUTHOR                 ACTIVITY                                                    
--*   1.0            2/27/2013     SUCHITRA PRABHALA      SCRIPT CREATED                                       
--*   2.0            11/05/2013    SUCHITRA PRABHALA      SCRIPT MODIFIED
--*   3.0            10/06/2014    SUCHITRA PRABHALA      SCRIPT MODIFIED
--*  NOTICE:
--*  -------------------------------------------------------------------------------
--*  THIS SCRIPT IS PROVIDED 'AS IS'. THE ENTITY IS RESPONSIBLE FOR TESTING
--*  AND EVALUATING THE EFFECTIVENESS OF THIS SCRIPT. ANY EXPRESSED OR
--*  IMPLIED WARRANTIES ARE DISCLAIMED. IN NO EVENT SHALL DELOITTE & 
--*  TOUCHE LLP BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
--*  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
--* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
--*  CAUSED AND ON ANY THEORY OF LIABILITY.
--* 
--*  COPYRIGHT © 2014 DELOITTE DEVELOPMENT LLC. ALL RIGHTS RESERVED.
--*  -------------------------------------------------------------------------------


--*  --------------------- ACTUAL SCRIPT BEGINS FROM HERE --------------------------
set echo off
set ver off
set heading off

clear screen
CLEAR BUFFER

prompt
prompt
prompt
prompt
prompt Note: DBA privileges on "SYS" schema are required 
prompt since the script extracts data from this schema.
prompt Please confirm if the USERID that you used to login to 
prompt Oracle DB has the required privileges by opening 
prompt another window and running the following query:
prompt SELECT * FROM SYS.LINK$;
prompt 
prompt If you were successful in executing the query above
prompt then select ENTER to proceed with extraction.
prompt 
prompt If you were not successful in executing the query above 
prompt then kill the script by pressing < ctrl + c > to EXIT.
prompt After you have obtained the required access, 
prompt you can login again to run the script.
prompt 
prompt 

pause

ALTER SESSION SET NLS_TERRITORY = AMERICA NLS_LANGUAGE = AMERICAN;
SET TERMOUT OFF PAGES 0 HEADING OFF ECHO OFF FEEDBACK OFF
SET SHOW OFF VER OFF
SET LINE 4000

DEFINE C_SEP   = '|^|';
DEFINE V_COUNT = 0;
DEFINE C_MAX_PRECISION = 38;
DEFINE C_MAX_SCALE = 127;

SET TRIMSPOOL ON

/******************************************** writing the control data into the file ****************************************/

Spool ACTT_CONFIG_SETTINGS.ACTT

SELECT 'SettingName VARCHAR(100)'||'&C_SEP'||'SettingValue VARCHAR(1000)' FROM DUAL;
SELECT 'Extract Script Version'||'&C_SEP'||'3.0' FROM DUAL;
SELECT 'Database Version'||'&C_SEP'||BANNER FROM V$VERSION WHERE BANNER LIKE '%Oracle%';
SELECT 'Extract Script Start Time'||'&C_SEP'||TO_CHAR(SYSDATE, 'DD-MON-YYYY HH:MI PM')  FROM DUAL;

SPOOL OFF

/******************************************* stop writing into the file after metadata ***************************************/

/**************************** writing the seperator i.e., feild terminator or delimiter data into the file ********************/

SPOOL ACTT_CONFIG_FIELDTERMINATOR.ACTT

SELECT '&C_SEP' FROM DUAL;

SPOOL OFF

/******************************************* stop writing into the file after metadata ***************************************/

/************************* writing the header line of this file ************/

SPOOL ACTT_CONFIG_TABLERECORDCOUNT.ACTT 

SELECT 'TableName VARCHAR(300)'||'&C_SEP'||'RecordCount VARCHAR(MAX)' FROM DUAL;

SPOOL OFF

/******************************************* stop writing into the file after metadata ***************************************/


/**************************************** WRITING EACH QUERY OUTPUT DATA INTO AN INPUT FILE ***********************************************/



SET TERM ON

SPOOL ACTT_EXTRACTION_LOG.TXT
PROMPT TRYING TO EXTRACT DATA FROM DBA_SYS_PRIVS;
SPOOL OFF

SET TERMOUT OFF PAGES 0 HEADING OFF ECHO OFF FEEDBACK OFF
/*1==============START OF QUERY FROM DBA_SYS_PRIVS TABLE ==============*/

SET TRIMSPOOL ON

SPOOL DBA_SYS_PRIVS.ACTT

SELECT RTRIM (XMLAGG (XMLELEMENT (E,COLUMN_NAME || ' ' || DATA_TYPE || '('|| CASE  WHEN DATA_type = 'NUMBER' THEN  CASE  WHEN DATA_PRECISION IS NULL THEN '&C_MAX_PRECISION,&C_MAX_SCALE'  ELSE DATA_PRECISION || ','|| DATA_SCALE  END ELSE  ''||DATA_LENGTH  END || ')'|| '&C_SEP') ORDER BY COLUMN_NAME).EXTRACT ('//text()'),'&C_SEP')
FROM  ALL_TAB_COLUMNS 
WHERE UPPER(TABLE_NAME)= 'DBA_SYS_PRIVS' 
AND UPPER(OWNER) ='SYS'
AND COLUMN_NAME IN ('GRANTEE','PRIVILEGE','ADMIN_OPTION');

SELECT
replace(replace(ADMIN_OPTION,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(GRANTEE,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(PRIVILEGE,CHR(13),''),CHR(10),' ') 
FROM SYS.DBA_SYS_PRIVS
/ 
SPOOL OFF

V_COUNT = V_COUNT+1;

/*1 ==============END OF QUERY FROM DBA_SYS_PRIVS TABLE ================*/

/************************* appending the record count of each table that is extracted based on the conditions used ************/

SPOOL ACTT_CONFIG_TABLERECORDCOUNT.ACTT APP

SELECT 'SYS.DBA_SYS_PRIVS'||'&C_SEP'||(SELECT  COUNT(*) FROM SYS.DBA_SYS_PRIVS ) FROM DUAL;

SPOOL OFF

/******************************************* stop writing into the file after metadata ***************************************/

SET TERM ON

SPOOL ACTT_EXTRACTION_LOG.TXT APP
PROMPT TRYING TO EXTRACT DATA FROM DBA_USERS;
SPOOL OFF

SET TERMOUT OFF PAGES 0 HEADING OFF ECHO OFF FEEDBACK OFF
/*2==============START OF QUERY FROM DBA_USERS TABLE ==============*/
SET TRIMSPOOL ON


SPOOL DBA_USERS.ACTT

SELECT RTRIM (XMLAGG (XMLELEMENT (E,COLUMN_NAME || ' ' || DATA_TYPE || '('|| CASE  WHEN DATA_type = 'NUMBER' THEN  CASE  WHEN DATA_PRECISION IS NULL THEN '&C_MAX_PRECISION,&C_MAX_SCALE'  ELSE DATA_PRECISION || ','|| DATA_SCALE  END ELSE  ''||DATA_LENGTH  END || ')'|| '&C_SEP') ORDER BY COLUMN_NAME).EXTRACT ('//text()'),'&C_SEP')
FROM  ALL_TAB_COLUMNS 
WHERE UPPER(TABLE_NAME)= 'DBA_USERS' 
AND UPPER(OWNER) ='SYS'
AND COLUMN_NAME IN ('ACCOUNT_STATUS','CREATED','DEFAULT_TABLESPACE','EDITIONS_ENABLED','EXPIRY_DATE','EXTERNAL_NAME','INITIAL_RSRC_CONSUMER_GROUP','LOCK_DATE','PASSWORD','PASSWORD_VERSIONS','PROFILE','TEMPORARY_TABLESPACE','USERNAME','USER_ID');

SELECT 
replace(replace(ACCOUNT_STATUS,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
CREATED ||'&C_SEP' ||
replace(replace(DEFAULT_TABLESPACE,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(EDITIONS_ENABLED,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
EXPIRY_DATE ||'&C_SEP' ||
replace(replace(EXTERNAL_NAME,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(INITIAL_RSRC_CONSUMER_GROUP,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
LOCK_DATE ||'&C_SEP' ||
length(replace(replace(PASSWORD,CHR(13),''),CHR(10),' ')) ||'&C_SEP' ||
replace(replace(PASSWORD_VERSIONS,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(PROFILE,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(TEMPORARY_TABLESPACE,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(USERNAME,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
USER_ID 
FROM  SYS.DBA_USERS
/ 
SPOOL OFF

V_COUNT = V_COUNT+1;

/*2 ==============END OF QUERY FROM DBA_USERS TABLE ================*/

/************************* appending the record count of each table that is extracted based on the conditions used ************/

SPOOL ACTT_CONFIG_TABLERECORDCOUNT.ACTT APP

SELECT 'SYS.DBA_USERS'||'&C_SEP'||(SELECT  COUNT(*) FROM SYS.DBA_USERS ) FROM DUAL;

SPOOL OFF

/******************************************* stop writing into the file after metadata ***************************************/

/************************* appending the record count of each table that is extracted based on the conditions used ************/

SPOOL ACTT_CONFIG_TABLERECORDCOUNT.ACTT APP

SELECT 'SYS.DBA_TAB_PRIVS'||'&C_SEP'||(SELECT  COUNT(*) FROM SYS.DBA_TAB_PRIVS ) FROM DUAL;

SPOOL OFF

/******************************************* stop writing into the file after metadata ***************************************/
SET TERM ON

SPOOL ACTT_EXTRACTION_LOG.TXT APP
PROMPT TRYING TO EXTRACT DATA FROM DBA_TAB_PRIVS;
SPOOL OFF

SET TERMOUT OFF PAGES 0 HEADING OFF ECHO OFF FEEDBACK OFF
/*3==============START OF QUERY FROM DBA_TAB_PRIVS TABLE ==============*/
SET TRIMSPOOL ON


SPOOL DBA_TAB_PRIVS.ACTT

SELECT RTRIM (XMLAGG (XMLELEMENT (E,COLUMN_NAME || ' ' || DATA_TYPE || '('|| CASE  WHEN DATA_type = 'NUMBER' THEN  CASE  WHEN DATA_PRECISION IS NULL THEN '&C_MAX_PRECISION,&C_MAX_SCALE'  ELSE DATA_PRECISION || ','|| DATA_SCALE  END ELSE  ''||DATA_LENGTH  END || ')'|| '&C_SEP') ORDER BY COLUMN_NAME).EXTRACT ('//text()'),'&C_SEP')
FROM  ALL_TAB_COLUMNS 
WHERE UPPER(TABLE_NAME)= 'DBA_TAB_PRIVS' 
AND UPPER(OWNER) ='SYS'
AND COLUMN_NAME IN ('GRANTABLE','GRANTEE','GRANTOR','HIERARCHY','OWNER','PRIVILEGE','TABLE_NAME');

SELECT 
replace(replace(GRANTABLE,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(GRANTEE,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(GRANTOR,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(HIERARCHY,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(OWNER,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(PRIVILEGE,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(TABLE_NAME,CHR(13),''),CHR(10),' ') 
FROM  SYS.DBA_TAB_PRIVS
/ 
SPOOL OFF

V_COUNT = V_COUNT+1;

/*3 ==============END OF QUERY FROM DBA_TAB_PRIVS TABLE ================*/

/************************* appending the record count of each table that is extracted based on the conditions used ************/

SPOOL ACTT_CONFIG_TABLERECORDCOUNT.ACTT APP

SELECT 'SYS.DBA_TAB_PRIVS'||'&C_SEP'||(SELECT  COUNT(*) FROM SYS.DBA_TAB_PRIVS ) FROM DUAL;

SPOOL OFF

/******************************************* stop writing into the file after metadata ***************************************/

SET TERM ON

SPOOL ACTT_EXTRACTION_LOG.TXT APP
PROMPT TRYING TO EXTRACT DATA FROM DBA_ROLE_PRIVS;
SPOOL OFF

SET TERMOUT OFF PAGES 0 HEADING OFF ECHO OFF FEEDBACK OFF
/*4==============START OF QUERY FROM DBA_ROLE_PRIVS TABLE ==============*/
SET TRIMSPOOL ON


SPOOL DBA_ROLE_PRIVS.ACTT

SELECT RTRIM (XMLAGG (XMLELEMENT (E,COLUMN_NAME || ' ' || DATA_TYPE || '('|| CASE  WHEN DATA_type = 'NUMBER' THEN  CASE  WHEN DATA_PRECISION IS NULL THEN '&C_MAX_PRECISION,&C_MAX_SCALE'  ELSE DATA_PRECISION || ','|| DATA_SCALE  END ELSE  ''||DATA_LENGTH  END || ')'|| '&C_SEP') ORDER BY COLUMN_NAME).EXTRACT ('//text()'),'&C_SEP')
FROM  ALL_TAB_COLUMNS 
WHERE UPPER(TABLE_NAME)= 'DBA_ROLE_PRIVS' 
AND UPPER(OWNER) ='SYS'
AND COLUMN_NAME IN ('ADMIN_OPTION','DEFAULT_ROLE','GRANTED_ROLE','GRANTEE');

SELECT 
replace(replace(ADMIN_OPTION,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(DEFAULT_ROLE,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(GRANTED_ROLE,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(GRANTEE,CHR(13),''),CHR(10),' ')
FROM  SYS.DBA_ROLE_PRIVS
/ 
SPOOL OFF

V_COUNT = V_COUNT+1;

/*4 ==============END OF QUERY FROM DBA_ROLE_PRIVS TABLE ================*/

/************************* appending the record count of each table that is extracted based on the conditions used ************/

SPOOL ACTT_CONFIG_TABLERECORDCOUNT.ACTT APP

SELECT 'SYS.DBA_ROLE_PRIVS'||'&C_SEP'||(SELECT  COUNT(*) FROM SYS.DBA_ROLE_PRIVS) FROM DUAL;

SPOOL OFF

/******************************************* stop writing into the file after metadata ***************************************/

SET TERM ON

SPOOL ACTT_EXTRACTION_LOG.TXT APP
PROMPT TRYING TO EXTRACT DATA FROM V$PWFILE_USERS;
SPOOL OFF

SET TERMOUT OFF PAGES 0 HEADING OFF ECHO OFF FEEDBACK OFF

/*5==============START OF QUERY FROM V$PWFILE_USERS TABLE ==============*/
SET TRIMSPOOL ON


SPOOL VPWFILE_USERS.ACTT

SELECT RTRIM (XMLAGG (XMLELEMENT (E,COLUMN_NAME || ' ' || DATA_TYPE || '('|| CASE  WHEN DATA_type = 'NUMBER' THEN  CASE  WHEN DATA_PRECISION IS NULL THEN '&C_MAX_PRECISION,&C_MAX_SCALE'  ELSE DATA_PRECISION || ','|| DATA_SCALE  END ELSE  ''||DATA_LENGTH  END || ')'|| '&C_SEP') ORDER BY COLUMN_NAME).EXTRACT ('//text()'),'&C_SEP')
FROM  ALL_TAB_COLUMNS 
WHERE UPPER(TABLE_NAME)= 'V_$PWFILE_USERS' 
AND UPPER(OWNER) ='SYS'
AND COLUMN_NAME IN ('SYSASM','SYSDBA','SYSOPER','USERNAME');

SELECT 
replace(replace(SYSASM,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(SYSDBA,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(SYSOPER,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
USERNAME 
FROM  SYS.V_$PWFILE_USERS
/ 
SPOOL OFF

V_COUNT = V_COUNT+1;

/*5 ==============END OF QUERY FROM V$PWFILE_USERS TABLE ================*/

/************************* appending the record count of each table that is extracted based on the conditions used ************/

SPOOL ACTT_CONFIG_TABLERECORDCOUNT.ACTT APP

SELECT 'SYS.V_$PWFILE_USERS'||'&C_SEP'||(SELECT  COUNT(*) FROM SYS.V_$PWFILE_USERS) FROM DUAL;

SPOOL OFF

/******************************************* stop writing into the file after metadata ***************************************/

SET TERM ON

SPOOL ACTT_EXTRACTION_LOG.TXT APP
PROMPT TRYING TO EXTRACT DATA FROM PRODUCT_USER_PROFILE;
SPOOL OFF


SET TERMOUT OFF PAGES 0 HEADING OFF ECHO OFF FEEDBACK OFF

/*6==============START OF QUERY FROM PRODUCT_USER_PROFILE TABLE ==============*/
SET TRIMSPOOL ON


SPOOL PRODUCT_USER_PROFILE.ACTT

SELECT RTRIM (XMLAGG (XMLELEMENT (E,COLUMN_NAME || ' ' || DATA_TYPE || '('|| CASE  WHEN DATA_type = 'NUMBER' THEN  CASE  WHEN DATA_PRECISION IS NULL THEN '&C_MAX_PRECISION,&C_MAX_SCALE'  ELSE DATA_PRECISION || ','|| DATA_SCALE  END ELSE  ''||DATA_LENGTH  END || ')'|| '&C_SEP') ORDER BY COLUMN_NAME).EXTRACT ('//text()'),'&C_SEP')
FROM  ALL_TAB_COLUMNS 
WHERE UPPER(TABLE_NAME)= 'PRODUCT_PRIVS' 
AND UPPER(OWNER) ='SYSTEM'
AND COLUMN_NAME IN ('ATTRIBUTE','CHAR_VALUE','DATE_VALUE','NUMERIC_VALUE','PRODUCT','SCOPE','USERID');

SELECT 
replace(replace(ATTRIBUTE,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(CHAR_VALUE,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
DATE_VALUE ||'&C_SEP' ||
NUMERIC_VALUE ||'&C_SEP' ||
replace(replace(PRODUCT,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(SCOPE,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(USERID,CHR(13),''),CHR(10),' ')  
FROM  PRODUCT_USER_PROFILE
/ 
SPOOL OFF

V_COUNT = V_COUNT+1;

/*6 ==============END OF QUERY FROM PRODUCT_USER_PROFILE TABLE ================*/

/************************* appending the record count of each table that is extracted based on the conditions used ************/

SPOOL ACTT_CONFIG_TABLERECORDCOUNT.ACTT APP

SELECT 'PRODUCT_USER_PROFILE'||'&C_SEP'||(SELECT  COUNT(*) FROM PRODUCT_USER_PROFILE) FROM DUAL;

SPOOL OFF

/******************************************* stop writing into the file after metadata ***************************************/

SET TERM ON

SPOOL ACTT_EXTRACTION_LOG.TXT APP
PROMPT TRYING TO EXTRACT DATA FROM DBA_PROFILES;
SPOOL OFF

SET TERMOUT OFF PAGES 0 HEADING OFF ECHO OFF FEEDBACK OFF

/*7==============START OF QUERY FROM  DBA_PROFILES TABLE ==============*/
SET TRIMSPOOL ON


SPOOL  DBA_PROFILES.ACTT

SELECT RTRIM (XMLAGG (XMLELEMENT (E,COLUMN_NAME || ' ' || DATA_TYPE || '('|| CASE  WHEN DATA_type = 'NUMBER' THEN  CASE  WHEN DATA_PRECISION IS NULL THEN '&C_MAX_PRECISION,&C_MAX_SCALE'  ELSE DATA_PRECISION || ','|| DATA_SCALE  END ELSE  ''||DATA_LENGTH  END || ')'|| '&C_SEP') ORDER BY COLUMN_NAME).EXTRACT ('//text()'),'&C_SEP')
FROM  ALL_TAB_COLUMNS 
WHERE UPPER(TABLE_NAME)= 'DBA_PROFILES' 
AND UPPER(OWNER) ='SYS'
AND COLUMN_NAME IN ('LIMIT','PROFILE','RESOURCE_NAME','RESOURCE_TYPE');

SELECT 
replace(replace(LIMIT,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(PROFILE,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(RESOURCE_NAME,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(RESOURCE_TYPE,CHR(13),''),CHR(10),' ') 
FROM   SYS.DBA_PROFILES
/ 
SPOOL OFF

V_COUNT = V_COUNT+1;

/*7 ==============END OF QUERY FROM  DBA_PROFILES TABLE ================*/

/************************* appending the record count of each table that is extracted based on the conditions used ************/

SPOOL ACTT_CONFIG_TABLERECORDCOUNT.ACTT APP

SELECT 'SYS.DBA_PROFILES'||'&C_SEP'||(SELECT  COUNT(*) FROM SYS.DBA_PROFILES) FROM DUAL;

SPOOL OFF

/******************************************* stop writing into the file after metadata ***************************************/

SET TERM ON

SPOOL ACTT_EXTRACTION_LOG.TXT APP
PROMPT TRYING TO EXTRACT DATA FROM SYS.USER$;
SPOOL OFF

SET TERMOUT OFF PAGES 0 HEADING OFF ECHO OFF FEEDBACK OFF

/*8==============START OF QUERY FROM SYS.USER$ TABLE ==============*/
SET TRIMSPOOL ON


SPOOL SYS.USER.ACTT

SELECT RTRIM (XMLAGG (XMLELEMENT (E,COLUMN_NAME || ' ' || DATA_TYPE || '('|| CASE  WHEN DATA_type = 'NUMBER' THEN  CASE  WHEN DATA_PRECISION IS NULL THEN '&C_MAX_PRECISION,&C_MAX_SCALE'  ELSE DATA_PRECISION || ','|| DATA_SCALE  END ELSE  ''||DATA_LENGTH  END || ')'|| '&C_SEP') ORDER BY COLUMN_NAME).EXTRACT ('//text()'),'&C_SEP')
FROM  ALL_TAB_COLUMNS 
WHERE UPPER(TABLE_NAME)= 'USER$' 
AND UPPER(OWNER) ='SYS'
AND COLUMN_NAME IN ('ASTATUS','AUDIT$','CTIME','DATATS#','DEFGRP#','DEFGRP_SEQ#','DEFROLE','DEFSCHCLASS','EXPTIME','EXT_USERNAME','LCOUNT','LTIME','NAME','PASSWORD','PTIME','RESOURCE$','SPARE1','SPARE2','SPARE3','SPARE4','SPARE5','SPARE6','TEMPTS#','TYPE#','USER#');

SELECT 
ASTATUS ||'&C_SEP' ||
replace(replace(AUDIT$,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
CTIME ||'&C_SEP' ||
DATATS# ||'&C_SEP' ||
DEFGRP# ||'&C_SEP' ||
DEFGRP_SEQ# ||'&C_SEP' ||
DEFROLE ||'&C_SEP' ||
replace(replace(DEFSCHCLASS,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
EXPTIME ||'&C_SEP' ||
replace(replace(EXT_USERNAME,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
LCOUNT ||'&C_SEP' ||
LTIME ||'&C_SEP' ||
replace(replace(NAME,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
length(PASSWORD) ||'&C_SEP' ||
PTIME ||'&C_SEP' ||
RESOURCE$ ||'&C_SEP' ||
SPARE1 ||'&C_SEP' ||
SPARE2 ||'&C_SEP' ||
SPARE3 ||'&C_SEP' ||
replace(replace(SPARE4,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(SPARE5,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
SPARE6 ||'&C_SEP' ||
TEMPTS# ||'&C_SEP' ||
TYPE# ||'&C_SEP' ||
USER# 
FROM  SYS.USER$
/ 
SPOOL OFF

V_COUNT = V_COUNT+1;

/*8 ==============END OF QUERY FROM SYS.USER$ TABLE ================*/

/************************* appending the record count of each table that is extracted based on the conditions used ************/

SPOOL ACTT_CONFIG_TABLERECORDCOUNT.ACTT APP

SELECT 'SYS.USER$'||'&C_SEP'||(SELECT  COUNT(*) FROM SYS.USER$) FROM DUAL;

SPOOL OFF

/******************************************* stop writing into the file after metadata ***************************************/

SET TERM ON

SPOOL ACTT_EXTRACTION_LOG.TXT APP
PROMPT TRYING TO EXTRACT DATA FROM V$PARAMETER;
SPOOL OFF

SET TERMOUT OFF PAGES 0 HEADING OFF ECHO OFF FEEDBACK OFF

/*9 ==============START OF QUERY FROM V$PARAMETER TABLE ==============*/

SET TRIMSPOOL ON
SPOOL VPARAMETER.ACTT

SELECT RTRIM (XMLAGG (XMLELEMENT (E,COLUMN_NAME || ' ' || DATA_TYPE || '('|| CASE  WHEN DATA_type = 'NUMBER' THEN  CASE  WHEN DATA_PRECISION IS NULL THEN '&C_MAX_PRECISION,&C_MAX_SCALE'  ELSE DATA_PRECISION || ','|| DATA_SCALE  END ELSE  ''||DATA_LENGTH  END || ')'|| '&C_SEP') ORDER BY COLUMN_NAME).EXTRACT ('//text()'),'&C_SEP')
FROM  ALL_TAB_COLUMNS 
WHERE UPPER(TABLE_NAME)= UPPER('V_$PARAMETER')
AND UPPER(OWNER) ='SYS'
AND COLUMN_NAME IN ('DESCRIPTION','DISPLAY_VALUE','HASH','ISADJUSTED','ISBASIC','ISDEFAULT','ISDEPRECATED','ISINSTANCE_MODIFIABLE','ISMODIFIED','ISSES_MODIFIABLE','ISSYS_MODIFIABLE','NAME','NUM','TYPE','UPDATE_COMMENT','VALUE');

SELECT 
replace(replace(description,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(DISPLAY_VALUE,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
HASH ||'&C_SEP' ||
replace(replace(ISADJUSTED,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(ISBASIC,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(ISDEFAULT,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(ISDEPRECATED,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(ISINSTANCE_MODIFIABLE,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(ISMODIFIED,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(ISSES_MODIFIABLE,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(ISSYS_MODIFIABLE,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(NAME,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
NUM ||'&C_SEP' ||
TYPE ||'&C_SEP' ||
replace(replace(UPDATE_COMMENT,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(VALUE,CHR(13),''),CHR(10),' ')  
FROM SYS.V_$PARAMETER
/ 
SPOOL OFF

V_COUNT = V_COUNT+1;

/*9 ==============END OF QUERY FROM V$PARAMETER TABLE ==============*/

/************************* appending the record count of each table that is extracted based on the conditions used ************/

SPOOL ACTT_CONFIG_TABLERECORDCOUNT.ACTT APP

SELECT 'SYS.V_$PARAMETER'||'&C_SEP'||(SELECT  COUNT(*) FROM SYS.V_$PARAMETER) FROM DUAL;

SPOOL OFF

/******************************************* stop writing into the file after metadata ***************************************/

SET TERM ON

SPOOL ACTT_EXTRACTION_LOG.TXT APP
PROMPT TRYING TO EXTRACT DATA FROM DBA_DB_LINKS;
SPOOL OFF

SET TERMOUT OFF PAGES 0 HEADING OFF ECHO OFF FEEDBACK OFF

/*10==============START OF QUERY FROM DBA_DB_LINKS TABLE ==============*/
SET TRIMSPOOL ON


SPOOL DBA_DB_LINKS.ACTT

SELECT RTRIM (XMLAGG (XMLELEMENT (E,COLUMN_NAME || ' ' || DATA_TYPE || '('|| CASE  WHEN DATA_type = 'NUMBER' THEN  CASE  WHEN DATA_PRECISION IS NULL THEN '&C_MAX_PRECISION,&C_MAX_SCALE'  ELSE DATA_PRECISION || ','|| DATA_SCALE  END ELSE  ''||DATA_LENGTH  END || ')'|| '&C_SEP') ORDER BY COLUMN_NAME).EXTRACT ('//text()'),'&C_SEP')
FROM  ALL_TAB_COLUMNS 
WHERE UPPER(TABLE_NAME)= 'DBA_DB_LINKS' 
AND UPPER(OWNER) ='SYS'
AND COLUMN_NAME IN ('CREATED','DB_LINK','HOST','OWNER','USERNAME');

SELECT 
CREATED ||'&C_SEP' ||
replace(replace(DB_LINK,CHR(13),''),CHR(10),' ')  ||'&C_SEP' ||
replace(replace(host,CHR(13),''),CHR(10),' ')  ||'&C_SEP' ||
replace(replace(OWNER,CHR(13),''),CHR(10),' ')  ||'&C_SEP' ||
replace(replace(USERNAME,CHR(13),''),CHR(10),' ')   
FROM  SYS.DBA_DB_LINKS
/ 
SPOOL OFF

V_COUNT = V_COUNT+1;

/*10 ==============END OF QUERY FROM DBA_DB_LINKS TABLE ================*/

/************************* appending the record count of each table that is extracted based on the conditions used ************/

SPOOL ACTT_CONFIG_TABLERECORDCOUNT.ACTT APP

SELECT 'SYS.DBA_DB_LINKS'||'&C_SEP'||(SELECT  COUNT(*) FROM SYS.DBA_DB_LINKS) FROM DUAL;

SPOOL OFF

/******************************************* stop writing into the file after metadata ***************************************/

SET TERM ON

SPOOL ACTT_EXTRACTION_LOG.TXT APP
PROMPT TRYING TO EXTRACT DATA FROM DBA_STMT_AUDIT_OPTS;
SPOOL OFF

SET TERMOUT OFF PAGES 0 HEADING OFF ECHO OFF FEEDBACK OFF

/*12==============START OF QUERY FROM DBA_STMT_AUDIT_OPTS TABLE ==============*/
SET TRIMSPOOL ON


SPOOL DBA_STMT_AUDIT_OPTS.ACTT

SELECT RTRIM (XMLAGG (XMLELEMENT (E,COLUMN_NAME || ' ' || DATA_TYPE || '('|| CASE  WHEN DATA_type = 'NUMBER' THEN  CASE  WHEN DATA_PRECISION IS NULL THEN '&C_MAX_PRECISION,&C_MAX_SCALE'  ELSE DATA_PRECISION || ','|| DATA_SCALE  END ELSE  ''||DATA_LENGTH  END || ')'|| '&C_SEP') ORDER BY COLUMN_NAME).EXTRACT ('//text()'),'&C_SEP')
FROM  ALL_TAB_COLUMNS 
WHERE UPPER(TABLE_NAME)= 'DBA_STMT_AUDIT_OPTS' 
AND UPPER(OWNER) ='SYS'
AND COLUMN_NAME IN ('AUDIT_OPTION','FAILURE','PROXY_NAME','SUCCESS','USER_NAME');

SELECT 
replace(replace(AUDIT_OPTION,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(FAILURE,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(PROXY_NAME,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(SUCCESS,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(USER_NAME,CHR(13),''),CHR(10),' ')  
FROM  SYS.DBA_STMT_AUDIT_OPTS
/ 
SPOOL OFF

V_COUNT = V_COUNT+1;

/*12 ==============END OF QUERY FROM DBA_STMT_AUDIT_OPTS TABLE ================*/

/************************* appending the record count of each table that is extracted based on the conditions used ************/

SPOOL ACTT_CONFIG_TABLERECORDCOUNT.ACTT APP

SELECT 'SYS.DBA_STMT_AUDIT_OPTS'||'&C_SEP'||(SELECT  COUNT(*) FROM SYS.DBA_STMT_AUDIT_OPTS) FROM DUAL;

SPOOL OFF

/******************************************* stop writing into the file after metadata ***************************************/

SET TERM ON

SPOOL ACTT_EXTRACTION_LOG.TXT APP
PROMPT TRYING TO EXTRACT DATA FROM DBA_PRIV_AUDIT_OPTS;
SPOOL OFF

SET TERMOUT OFF PAGES 0 HEADING OFF ECHO OFF FEEDBACK OFF

/*13==============START OF QUERY FROM DBA_PRIV_AUDIT_OPTS TABLE ==============*/
SET TRIMSPOOL ON


SPOOL DBA_PRIV_AUDIT_OPTS.ACTT

SELECT RTRIM (XMLAGG (XMLELEMENT (E,COLUMN_NAME || ' ' || DATA_TYPE || '('|| CASE  WHEN DATA_type = 'NUMBER' THEN  CASE  WHEN DATA_PRECISION IS NULL THEN '&C_MAX_PRECISION,&C_MAX_SCALE'  ELSE DATA_PRECISION || ','|| DATA_SCALE  END ELSE  ''||DATA_LENGTH  END || ')'|| '&C_SEP') ORDER BY COLUMN_NAME).EXTRACT ('//text()'),'&C_SEP')
FROM  ALL_TAB_COLUMNS 
WHERE UPPER(TABLE_NAME)= 'DBA_PRIV_AUDIT_OPTS' 
AND UPPER(OWNER) ='SYS'
AND COLUMN_NAME IN ('FAILURE','PRIVILEGE','PROXY_NAME','SUCCESS','USER_NAME');

SELECT 
replace(replace(FAILURE,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(PRIVILEGE,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(PROXY_NAME,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(SUCCESS,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(USER_NAME,CHR(13),''),CHR(10),' ')  
FROM  SYS.DBA_PRIV_AUDIT_OPTS
/ 
SPOOL OFF

V_COUNT = V_COUNT+1;

/*13 ==============END OF QUERY FROM DBA_PRIV_AUDIT_OPTS TABLE ================*/

/************************* appending the record count of each table that is extracted based on the conditions used ************/

SPOOL ACTT_CONFIG_TABLERECORDCOUNT.ACTT APP

SELECT 'SYS.DBA_PRIV_AUDIT_OPTS'||'&C_SEP'||(SELECT  COUNT(*) FROM SYS.DBA_PRIV_AUDIT_OPTS) FROM DUAL;

SPOOL OFF

/******************************************* stop writing into the file after metadata ***************************************/

SET TERM ON

SPOOL ACTT_EXTRACTION_LOG.TXT APP
PROMPT TRYING TO EXTRACT DATA FROM DBA_OBJ_AUDIT_OPTS;
SPOOL OFF

SET TERMOUT OFF PAGES 0 HEADING OFF ECHO OFF FEEDBACK OFF

/*14==============START OF QUERY FROM DBA_OBJ_AUDIT_OPTS TABLE ==============*/
SET TRIMSPOOL ON


SPOOL DBA_OBJ_AUDIT_OPTS.ACTT

SELECT RTRIM (XMLAGG (XMLELEMENT (E,COLUMN_NAME || ' ' || DATA_TYPE || '('|| CASE  WHEN DATA_type = 'NUMBER' THEN  CASE  WHEN DATA_PRECISION IS NULL THEN '&C_MAX_PRECISION,&C_MAX_SCALE'  ELSE DATA_PRECISION || ','|| DATA_SCALE  END ELSE  ''||DATA_LENGTH  END || ')'|| '&C_SEP') ORDER BY COLUMN_NAME).EXTRACT ('//text()'),'&C_SEP')
FROM  ALL_TAB_COLUMNS 
WHERE UPPER(TABLE_NAME)= 'DBA_OBJ_AUDIT_OPTS' 
AND UPPER(OWNER) ='SYS'
AND COLUMN_NAME IN ('ALT','AUD','COM','CRE','DEL','EXE','FBK','GRA','IND','INS','LOC','OBJECT_NAME','OBJECT_TYPE','OWNER','REA','REF','REN','SEL','UPD','WRI');

SELECT 
replace(replace(ALT,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(AUD,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(COM,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(CRE,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(DEL,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(EXE,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(FBK,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(GRA,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(IND,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(INS,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(LOC,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(OBJECT_NAME,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(OBJECT_TYPE,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(OWNER,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(REA,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(REF,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(REN,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(SEL,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(UPD,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(WRI,CHR(13),''),CHR(10),' ')  
FROM  SYS.DBA_OBJ_AUDIT_OPTS
/ 
SPOOL OFF

V_COUNT = V_COUNT+1;

/*14 ==============END OF QUERY FROM DBA_OBJ_AUDIT_OPTS TABLE ================*/

/************************* appending the record count of each table that is extracted based on the conditions used ************/

SPOOL ACTT_CONFIG_TABLERECORDCOUNT.ACTT APP

SELECT 'SYS.DBA_OBJ_AUDIT_OPTS'||'&C_SEP'||(SELECT  COUNT(*) FROM SYS.DBA_OBJ_AUDIT_OPTS) FROM DUAL;

SPOOL OFF

/******************************************* stop writing into the file after metadata ***************************************/

SET TERM ON

SPOOL ACTT_EXTRACTION_LOG.TXT APP
PROMPT TRYING TO EXTRACT DATA FROM ALL_DEF_AUDIT_OPTS;
SPOOL OFF

SET TERMOUT OFF PAGES 0 HEADING OFF ECHO OFF FEEDBACK OFF

/*15==============START OF QUERY FROM ALL_DEF_AUDIT_OPTS TABLE ==============*/
SET TRIMSPOOL ON


SPOOL ALL_DEF_AUDIT_OPTS.ACTT

SELECT RTRIM (XMLAGG (XMLELEMENT (E,COLUMN_NAME || ' ' || DATA_TYPE || '('|| CASE  WHEN DATA_type = 'NUMBER' THEN  CASE  WHEN DATA_PRECISION IS NULL THEN '&C_MAX_PRECISION,&C_MAX_SCALE'  ELSE DATA_PRECISION || ','|| DATA_SCALE  END ELSE  ''||DATA_LENGTH  END || ')'|| '&C_SEP') ORDER BY COLUMN_NAME).EXTRACT ('//text()'),'&C_SEP')
FROM  ALL_TAB_COLUMNS 
WHERE UPPER(TABLE_NAME)= 'ALL_DEF_AUDIT_OPTS' 
AND UPPER(OWNER) ='SYS'
AND COLUMN_NAME IN ('ALT','AUD','COM','DEL','EXE','FBK','GRA','IND','INS','LOC','REA','REF','REN','SEL','UPD');

SELECT 
replace(replace(ALT,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(AUD,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(COM,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(DEL,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(EXE,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(FBK,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(GRA,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(IND,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(INS,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(LOC,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(REA,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(REF,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(REN,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(SEL,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(UPD,CHR(13),''),CHR(10),' ') 
FROM  SYS.ALL_DEF_AUDIT_OPTS
/ 
SPOOL OFF

V_COUNT = V_COUNT+1;

/*15 ==============END OF QUERY FROM ALL_DEF_AUDIT_OPTSTABLE ================*/

/************************* appending the record count of each table that is extracted based on the conditions used ************/

SPOOL ACTT_CONFIG_TABLERECORDCOUNT.ACTT APP

SELECT 'SYS.ALL_DEF_AUDIT_OPTS'||'&C_SEP'||(SELECT  COUNT(*) FROM SYS.ALL_DEF_AUDIT_OPTS) FROM DUAL;

SPOOL OFF

/******************************************* stop writing into the file after metadata ***************************************/

SET TERM ON

SPOOL ACTT_EXTRACTION_LOG.TXT APP
PROMPT TRYING TO EXTRACT DATA FROM DBA_FGA_AUDIT_TRAIL;
SPOOL OFF

SET TERMOUT OFF PAGES 0 HEADING OFF ECHO OFF FEEDBACK OFF

/*16==============START OF QUERY FROM DBA_FGA_AUDIT_TRAIL TABLE ==============*/
SET TRIMSPOOL ON


SPOOL DBA_FGA_AUDIT_TRAIL.ACTT

SELECT RTRIM (XMLAGG (XMLELEMENT (E,COLUMN_NAME || ' ' || DATA_TYPE || '('|| CASE  WHEN DATA_type = 'NUMBER' THEN  CASE  WHEN DATA_PRECISION IS NULL THEN '&C_MAX_PRECISION,&C_MAX_SCALE'  ELSE DATA_PRECISION || ','|| DATA_SCALE  END ELSE  ''||DATA_LENGTH  END || ')'|| '&C_SEP') ORDER BY COLUMN_NAME).EXTRACT ('//text()'),'&C_SEP')
FROM  ALL_TAB_COLUMNS 
WHERE UPPER(TABLE_NAME)= 'DBA_FGA_AUDIT_TRAIL' 
AND UPPER(OWNER) ='SYS'
AND COLUMN_NAME IN ('CLIENT_ID','COMMENT$TEXT','DB_USER','ECONTEXT_ID','ENTRYID','EXTENDED_TIMESTAMP','EXT_NAME','GLOBAL_UID','INSTANCE_NUMBER','OBJECT_NAME','OBJECT_SCHEMA','OBJ_EDITION_NAME','OS_PROCESS','OS_USER','POLICY_NAME','PROXY_SESSIONID','SCN','SESSION_ID','SQL_BIND','SQL_TEXT','STATEMENTID','STATEMENT_TYPE','TIMESTAMP','TRANSACTIONID','USERHOST');

SELECT 
replace(replace(CLIENT_ID,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(COMMENT$TEXT,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(DB_USER,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(ECONTEXT_ID,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
ENTRYID ||'&C_SEP' ||
to_char(EXTENDED_TIMESTAMP,'yyyy-mm-dd hh24:mi:ss') ||'&C_SEP' ||
replace(replace(EXT_NAME,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(GLOBAL_UID,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
INSTANCE_NUMBER ||'&C_SEP' ||
replace(replace(OBJECT_NAME,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(OBJECT_SCHEMA,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(OBJ_EDITION_NAME,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(OS_PROCESS,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(OS_USER,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(POLICY_NAME,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
PROXY_SESSIONID ||'&C_SEP' ||
SCN ||'&C_SEP' ||
SESSION_ID ||'&C_SEP' ||
replace(replace(SQL_BIND,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(SQL_TEXT,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
STATEMENTID ||'&C_SEP' ||
replace(replace(STATEMENT_TYPE,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
TIMESTAMP ||'&C_SEP' ||
replace(replace(TRANSACTIONID,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(USERHOST,CHR(13),''),CHR(10),' ') 
FROM  SYS.DBA_FGA_AUDIT_TRAIL
/ 
SPOOL OFF

V_COUNT = V_COUNT+1;

/*16 ==============END OF QUERY FROM DBA_FGA_AUDIT_TRAIL TABLE ================*/

/************************* appending the record count of each table that is extracted based on the conditions used ************/

SPOOL ACTT_CONFIG_TABLERECORDCOUNT.ACTT APP

SELECT 'SYS.DBA_FGA_AUDIT_TRAIL'||'&C_SEP'||(SELECT  COUNT(*) FROM SYS.DBA_FGA_AUDIT_TRAIL) FROM DUAL;

SPOOL OFF

/******************************************* stop writing into the file after metadata ***************************************/

SET TERM ON

SPOOL ACTT_EXTRACTION_LOG.TXT APP
PROMPT TRYING TO EXTRACT DATA FROM V$VERSION ;
SPOOL OFF

SET TERMOUT OFF PAGES 0 HEADING OFF ECHO OFF FEEDBACK OFF

/*17==============START OF QUERY FROM V$VERSION TABLE ==============*/
SET TRIMSPOOL ON


SPOOL VVERSION.ACTT

SELECT RTRIM (XMLAGG (XMLELEMENT (E,COLUMN_NAME || ' ' || DATA_TYPE || '('|| CASE  WHEN DATA_type = 'NUMBER' THEN  CASE  WHEN DATA_PRECISION IS NULL THEN '&C_MAX_PRECISION,&C_MAX_SCALE'  ELSE DATA_PRECISION || ','|| DATA_SCALE  END ELSE  ''||DATA_LENGTH  END || ')'|| '&C_SEP') ORDER BY COLUMN_NAME).EXTRACT ('//text()'),'&C_SEP')
FROM  ALL_TAB_COLUMNS 
WHERE UPPER(TABLE_NAME)= 'V_$VERSION' 
AND UPPER(OWNER) ='SYS'
AND COLUMN_NAME IN ('BANNER');

SELECT 
BANNER
FROM  SYS.V_$VERSION
/ 
SPOOL OFF

V_COUNT = V_COUNT+1;

/*17 ==============END OF QUERY FROM V$VERSION TABLE ================*/

/************************* appending the record count of each table that is extracted based on the conditions used ************/

SPOOL ACTT_CONFIG_TABLERECORDCOUNT.ACTT APP

SELECT 'SYS.V_$VERSION'||'&C_SEP'||(SELECT  COUNT(*) FROM SYS.V_$VERSION) FROM DUAL;

SPOOL OFF

/******************************************* stop writing into the file after metadata ***************************************/

SET TERM ON

SPOOL ACTT_EXTRACTION_LOG.TXT APP
PROMPT TRYING TO EXTRACT DATA FROM DBA_JOBS;
SPOOL OFF

SET TERMOUT OFF PAGES 0 HEADING OFF ECHO OFF FEEDBACK OFF

/*18==============START OF QUERY FROM DBA_JOBS TABLE ==============*/
SET TRIMSPOOL ON


SPOOL DBA_JOBS.ACTT

SELECT RTRIM (XMLAGG (XMLELEMENT (E,COLUMN_NAME || ' ' || DATA_TYPE || '('|| CASE  WHEN DATA_type = 'NUMBER' THEN  CASE  WHEN DATA_PRECISION IS NULL THEN '&C_MAX_PRECISION,&C_MAX_SCALE'  ELSE DATA_PRECISION || ','|| DATA_SCALE  END ELSE  ''||DATA_LENGTH  END || ')'|| '&C_SEP') ORDER BY COLUMN_NAME).EXTRACT ('//text()'),'&C_SEP')
FROM  ALL_TAB_COLUMNS 
WHERE UPPER(TABLE_NAME)= 'DBA_JOBS' 
AND UPPER(OWNER) ='SYS'
AND COLUMN_NAME IN ('BROKEN','FAILURES','INSTANCE','INTERVAL','JOB','LAST_DATE','LAST_SEC','LOG_USER','MISC_ENV','NEXT_DATE','NEXT_SEC','NLS_ENV','PRIV_USER','SCHEMA_USER','THIS_DATE','THIS_SEC','TOTAL_TIME','WHAT');

SELECT 
replace(replace(BROKEN,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
FAILURES ||'&C_SEP' ||
INSTANCE ||'&C_SEP' ||
replace(replace(INTERVAL,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
JOB ||'&C_SEP' ||
LAST_DATE ||'&C_SEP' ||
replace(replace(LAST_SEC,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(LOG_USER,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(MISC_ENV,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
NEXT_DATE ||'&C_SEP' ||
replace(replace(NEXT_SEC,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(NLS_ENV,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(PRIV_USER,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(SCHEMA_USER,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
THIS_DATE ||'&C_SEP' ||
replace(replace(THIS_SEC,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
TOTAL_TIME ||'&C_SEP' ||
replace(replace(WHAT,CHR(13),''),CHR(10),' ')  
FROM  SYS.DBA_JOBS
/ 
SPOOL OFF

V_COUNT = V_COUNT+1;

/*18 ==============END OF QUERY FROM DBA_JOBS TABLE ================*/

/************************* appending the record count of each table that is extracted based on the conditions used ************/

SPOOL ACTT_CONFIG_TABLERECORDCOUNT.ACTT APP

SELECT 'SYS.DBA_JOBS'||'&C_SEP'||(SELECT  COUNT(*) FROM SYS.DBA_JOBS) FROM DUAL;

SPOOL OFF

/******************************************* stop writing into the file after metadata ***************************************/

SET TERM ON

SPOOL ACTT_EXTRACTION_LOG.TXT APP
PROMPT TRYING TO EXTRACT DATA FROM DBA_JOBS_RUNNING;
SPOOL OFF

SET TERMOUT OFF PAGES 0 HEADING OFF ECHO OFF FEEDBACK OFF

/*19==============START OF QUERY FROM DBA_JOBS_RUNNING TABLE ==============*/
SET TRIMSPOOL ON


SPOOL DBA_JOBS_RUNNING.ACTT

SELECT RTRIM (XMLAGG (XMLELEMENT (E,COLUMN_NAME || ' ' || DATA_TYPE || '('|| CASE  WHEN DATA_type = 'NUMBER' THEN  CASE  WHEN DATA_PRECISION IS NULL THEN '&C_MAX_PRECISION,&C_MAX_SCALE'  ELSE DATA_PRECISION || ','|| DATA_SCALE  END ELSE  ''||DATA_LENGTH  END || ')'|| '&C_SEP') ORDER BY COLUMN_NAME).EXTRACT ('//text()'),'&C_SEP')
FROM  ALL_TAB_COLUMNS 
WHERE UPPER(TABLE_NAME)= 'DBA_JOBS_RUNNING' 
AND UPPER(OWNER) ='SYS'
AND COLUMN_NAME IN ('FAILURES','INSTANCE','JOB','LAST_DATE','LAST_SEC','SID','THIS_DATE','THIS_SEC');

SELECT 
FAILURES ||'&C_SEP' ||
INSTANCE ||'&C_SEP' ||
JOB ||'&C_SEP' ||
LAST_DATE ||'&C_SEP' ||
replace(replace(LAST_SEC,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
SID ||'&C_SEP' ||
THIS_DATE ||'&C_SEP' ||
replace(replace(THIS_SEC,CHR(13),''),CHR(10),' ')  
FROM  SYS.DBA_JOBS_RUNNING
/ 
SPOOL OFF

V_COUNT = V_COUNT+1;

/*19 ==============END OF QUERY FROM DBA_JOBS_RUNNING TABLE ================*/

/************************* appending the record count of each table that is extracted based on the conditions used ************/

SPOOL ACTT_CONFIG_TABLERECORDCOUNT.ACTT APP

SELECT 'SYS.DBA_JOBS_RUNNING'||'&C_SEP'||(SELECT  COUNT(*) FROM SYS.DBA_JOBS_RUNNING) FROM DUAL;

SPOOL OFF

/******************************************* stop writing into the file after metadata ***************************************/

SET TERM ON

SPOOL ACTT_EXTRACTION_LOG.TXT APP
PROMPT TRYING TO EXTRACT DATA FROM ALL_SCHEDULER_RUNNING_JOBS;
SPOOL OFF

SET TERMOUT OFF PAGES 0 HEADING OFF ECHO OFF FEEDBACK OFF

/*20==============START OF QUERY FROM ALL_SCHEDULER_RUNNING_JOBS TABLE ==============*/
SET TRIMSPOOL ON


SPOOL ALL_SCHEDULER_RUNNING_JOBS.ACTT

SELECT RTRIM (XMLAGG (XMLELEMENT (E,COLUMN_NAME || ' ' || DATA_TYPE || '('|| CASE  WHEN DATA_type = 'NUMBER' THEN  CASE  WHEN DATA_PRECISION IS NULL THEN '&C_MAX_PRECISION,&C_MAX_SCALE'  ELSE DATA_PRECISION || ','|| DATA_SCALE  END ELSE  ''||DATA_LENGTH  END || ')'|| '&C_SEP') ORDER BY COLUMN_NAME).EXTRACT ('//text()'),'&C_SEP')
FROM  ALL_TAB_COLUMNS 
WHERE UPPER(TABLE_NAME)= 'ALL_SCHEDULER_RUNNING_JOBS' 
AND UPPER(OWNER) ='SYS'
AND COLUMN_NAME IN ('CPU_USED','DETACHED','ELAPSED_TIME','JOB_NAME','JOB_STYLE','JOB_SUBNAME','OWNER','RESOURCE_CONSUMER_GROUP','RUNNING_INSTANCE','SESSION_ID','SLAVE_OS_PROCESS_ID','SLAVE_PROCESS_ID');

SELECT 
CPU_USED ||'&C_SEP' ||
replace(replace(DETACHED,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
ELAPSED_TIME ||'&C_SEP' ||
replace(replace(JOB_NAME,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(JOB_STYLE,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(JOB_SUBNAME,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(OWNER,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(RESOURCE_CONSUMER_GROUP,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
RUNNING_INSTANCE ||'&C_SEP' ||
SESSION_ID ||'&C_SEP' ||
replace(replace(SLAVE_OS_PROCESS_ID,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
SLAVE_PROCESS_ID 
FROM  SYS.ALL_SCHEDULER_RUNNING_JOBS
/ 
SPOOL OFF

V_COUNT = V_COUNT+1;

/*20 ==============END OF QUERY FROM ALL_SCHEDULER_RUNNING_JOBS TABLE ================*/

/************************* appending the record count of each table that is extracted based on the conditions used ************/

SPOOL ACTT_CONFIG_TABLERECORDCOUNT.ACTT APP

SELECT 'SYS.ALL_SCHEDULER_RUNNING_JOBS'||'&C_SEP'||(SELECT  COUNT(*) FROM SYS.ALL_SCHEDULER_RUNNING_JOBS) FROM DUAL;

SPOOL OFF

/******************************************* stop writing into the file after metadata ***************************************/

SET TERM ON

SPOOL ACTT_EXTRACTION_LOG.TXT APP
PROMPT TRYING TO EXTRACT DATA FROM SCHUEDULER_JOB_LOG;
SPOOL OFF

SET TERMOUT OFF PAGES 0 HEADING OFF ECHO OFF FEEDBACK OFF

/*21==============START OF QUERY FROM DBA_SCHEDULER_JOB_LOG TABLE ==============*/
SET TRIMSPOOL ON


SPOOL DBA_SCHEDULER_JOB_LOG.ACTT

SELECT RTRIM (XMLAGG (XMLELEMENT (E,COLUMN_NAME || ' ' || DATA_TYPE || '('|| CASE  WHEN DATA_type = 'NUMBER' THEN  CASE  WHEN DATA_PRECISION IS NULL THEN '&C_MAX_PRECISION,&C_MAX_SCALE'  ELSE DATA_PRECISION || ','|| DATA_SCALE  END ELSE  ''||DATA_LENGTH  END || ')'|| '&C_SEP') ORDER BY COLUMN_NAME).EXTRACT ('//text()'),'&C_SEP')
FROM  ALL_TAB_COLUMNS 
WHERE UPPER(TABLE_NAME)= 'DBA_SCHEDULER_JOB_LOG' 
AND UPPER(OWNER) ='SYS'
AND COLUMN_NAME IN ('CLIENT_ID','DESTINATION','GLOBAL_UID','JOB_CLASS','JOB_NAME','JOB_SUBNAME','LOG_DATE','LOG_ID','OPERATION','OWNER','STATUS','USER_NAME');

SELECT 
replace(replace(CLIENT_ID,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(DESTINATION,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(GLOBAL_UID,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(JOB_CLASS,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(JOB_NAME,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(JOB_SUBNAME,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
to_char(log_date,'yyyy-mm-dd hh24:mi:ss') ||'&C_SEP' ||
LOG_ID ||'&C_SEP' ||
replace(replace(OPERATION,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(OWNER,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(STATUS,CHR(13),''),CHR(10),' ') ||'&C_SEP' ||
replace(replace(USER_NAME,CHR(13),''),CHR(10),' ')  
FROM  SYS.DBA_SCHEDULER_JOB_LOG
/ 
SPOOL OFF

V_COUNT = V_COUNT+1;

/*21 ==============END OF QUERY FROM DBA_SCHEDULER_JOB_LOG TABLE ================*/

/************************* appending the record count of each table that is extracted based on the conditions used ************/

SPOOL ACTT_CONFIG_TABLERECORDCOUNT.ACTT APP

SELECT 'SYS.DBA_SCHEDULER_JOB_LOG'||'&C_SEP'||(SELECT  COUNT(*) FROM SYS.DBA_SCHEDULER_JOB_LOG) FROM DUAL;

SPOOL OFF

/******************************************* stop writing into the file after metadata ***************************************/

SET TERM ON

SPOOL ACTT_EXTRACTION_LOG.TXT APP
PROMPT TRYING TO EXTRACT DATA FROM DBA_USERS_WITH_DEFPWD;
SPOOL OFF

SET TERMOUT OFF PAGES 0 HEADING OFF ECHO OFF FEEDBACK OFF

/*22==============START OF QUERY FROM DBA_USERS_WITH_DEFPWD TABLE ==============*/
SET TRIMSPOOL ON


SPOOL DBA_USERS_WITH_DEFPWD.ACTT

SELECT RTRIM (XMLAGG (XMLELEMENT (E,COLUMN_NAME || ' ' || DATA_TYPE || '('|| CASE  WHEN DATA_type = 'NUMBER' THEN  CASE  WHEN DATA_PRECISION IS NULL THEN '&C_MAX_PRECISION,&C_MAX_SCALE'  ELSE DATA_PRECISION || ','|| DATA_SCALE  END ELSE  ''||DATA_LENGTH  END || ')'|| '&C_SEP') ORDER BY COLUMN_NAME).EXTRACT ('//text()'),'&C_SEP')
FROM  ALL_TAB_COLUMNS 
WHERE UPPER(TABLE_NAME)= 'DBA_USERS_WITH_DEFPWD' 
AND UPPER(OWNER) ='SYS'
AND COLUMN_NAME IN ('USERNAME');

SELECT 
USERNAME 
FROM  SYS.DBA_USERS_WITH_DEFPWD
/ 
SPOOL OFF

V_COUNT = V_COUNT+1;

/*22 ==============END OF QUERY FROM DBA_USERS_WITH_DEFPWD TABLE ================*/

/************************* appending the record count of each table that is extracted based on the conditions used ************/

SPOOL ACTT_CONFIG_TABLERECORDCOUNT.ACTT APP

SELECT 'SYS.DBA_USERS_WITH_DEFPWD'||'&C_SEP'||(SELECT  COUNT(*) FROM SYS.DBA_USERS_WITH_DEFPWD) FROM DUAL;

SPOOL OFF

/******************************************* stop writing into the file after metadata ***************************************/


SET TERM ON

SPOOL ACTT_EXTRACTION_LOG.TXT APP
PROMPT TRYING TO EXTRACT DATA FROM SYS.LINK$;
SPOOL OFF

SET TERMOUT OFF PAGES 0 HEADING OFF ECHO OFF FEEDBACK OFF

/*11==============START OF QUERY FROM SYS.LINK$ TABLE ==============*/
SET TRIMSPOOL ON


SPOOL SYS.LINK.ACTT

SELECT RTRIM (XMLAGG (XMLELEMENT (E,COLUMN_NAME || ' ' || DATA_TYPE || '('|| CASE  WHEN DATA_type = 'NUMBER' THEN  CASE  WHEN DATA_PRECISION IS NULL THEN '&C_MAX_PRECISION,&C_MAX_SCALE'  ELSE DATA_PRECISION || ','|| DATA_SCALE  END ELSE  ''||DATA_LENGTH  END || ')'|| '&C_SEP') ORDER BY COLUMN_NAME).EXTRACT ('//text()'),'&C_SEP')
FROM  ALL_TAB_COLUMNS 
WHERE UPPER(TABLE_NAME)= 'LINK$' 
AND UPPER(OWNER) ='SYS'
AND COLUMN_NAME IN ('AUTHPWD','AUTHPWDX','AUTHUSR','CTIME','FLAG','HOST','NAME','OWNER#','PASSWORD','PASSWORDX','USERID');

SELECT 
replace(replace(AUTHPWD,CHR(13),''),CHR(10),' ')||'&C_SEP' ||
replace(replace(AUTHPWDX,CHR(13),''),CHR(10),' ')||'&C_SEP' ||
replace(replace(AUTHUSR,CHR(13),''),CHR(10),' ')||'&C_SEP' ||
CTIME ||'&C_SEP' ||
FLAG ||'&C_SEP' ||
replace(replace(host,CHR(13),''),CHR(10),' ')||'&C_SEP' ||
replace(replace(NAME,CHR(13),''),CHR(10),' ')||'&C_SEP' ||
OWNER# ||'&C_SEP' ||
length(replace(replace(PASSWORD,CHR(13),''),CHR(10),' '))||'&C_SEP' ||
length(replace(replace(PASSWORDX,CHR(13),''),CHR(10),' '))||'&C_SEP' ||
replace(replace(USERID,CHR(13),''),CHR(10),' ') 
FROM  SYS.LINK$
/ 
SPOOL OFF

V_COUNT = V_COUNT+1;

/*11 ==============END OF QUERY FROM SYS.LINK$ TABLE ================*/

/************************* appending the record count of each table that is extracted based on the conditions used ************/

SPOOL ACTT_CONFIG_TABLERECORDCOUNT.ACTT APP

SELECT 'SYS.LINK$'||'&C_SEP'||(SELECT  COUNT(*) FROM SYS.LINK$) FROM DUAL;

SPOOL OFF

/******************************************* stop writing into the file after metadata ***************************************/

/*************************************************** Script Ending details captured **************************************************/

/******************************************** appending the control data into the file ****************************************/

Spool ACTT_CONFIG_SETTINGS.ACTT APP

SELECT 'Extract Script End Time'||'&C_SEP'||TO_CHAR(SYSDATE, 'DD-MON-YYYY HH:MI PM') FROM DUAL;
SELECT 'Data Extraction Date'||'&C_SEP'||TO_CHAR(SYSDATE, 'DD-MON-YYYY HH:MI PM') FROM DUAL;

SPOOL OFF
/*SELECT 'Number of Tables Extracted'||'&C_SEP'||LTRIM('&V_COUNT') FROM DUAL;*/

/******************************************* stop writing into the file after metadata ***************************************/


/************************************************************* END *******************************************************************/

EXIT

/************************************************************* END *******************************************************************/

