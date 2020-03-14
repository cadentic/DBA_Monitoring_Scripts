
VARIABLE ExtractScriptVersion VARCHAR2(10)
VARIABLE delim VARCHAR2(10)
VARIABLE StartDate VARCHAR2(30)
VARIABLE EndDate VARCHAR2(30)
VARIABLE ScriptStartTime VARCHAR2(30)
VARIABLE ScriptEndTime VARCHAR2(30)
EXEC :StartDate := '&1'
EXEC :EndDate := '&2'
EXEC :ScriptStartTime := TO_CHAR(SYSDATE,'DD-MON-YYYY  HH:MI AM')
EXEC :ExtractScriptVersion := '10.0';
EXEC :delim := '|';

ALTER SESSION SET NLS_TERRITORY = AMERICA NLS_LANGUAGE = AMERICAN;
SET TERMOUT OFF PAGES 0 HEADING OFF FEEDBACK OFF
SET SHOW OFF VER OFF
SET LINE 10000
SET TRIMSPOOL ON
SET ECHO OFF



SPOOL actt_config_TableRecordCount.actt
SELECT 
  'TableName VARCHAR(300)',
  'RecordCount INT'
FROM DUAL;
SELECT 'GL_JE_HEADERS.JE'||:delim||COUNT(*)FROM GL.GL_JE_HEADERS WHERE DEFAULT_EFFECTIVE_DATE >= :StartDate AND DEFAULT_EFFECTIVE_DATE <= :EndDate;
SELECT 'GL_JE_LINES.JE'||:delim||COUNT(*)FROM GL.GL_JE_LINES WHERE EFFECTIVE_DATE >= :StartDate AND EFFECTIVE_DATE <= :EndDate;
SELECT 'GL_CODE_COMBINATIONS.JE'||:delim||COUNT(*)FROM GL.GL_CODE_COMBINATIONS;
SPOOL OFF



SPOOL je_GL_JE_HEADERS.actt
SELECT 
  'JE_HEADER_ID INT'				||:delim||
  'JE_BATCH_ID'						||:delim||
  'PERIOD_NAME NVARCHAR(30)'		||:delim||
  'DEFAULT_EFFECTIVE_DATE DATETIME'	||:delim||
  'CREATION_DATE DATETIME'			||:delim||	
  'CREATED_BY'			            ||:delim||
  'LAST_UPDATE_LOGIN'				||:delim||
  'LAST_UPDATE_DATE'				||:delim||
  'LAST_UPDATED_BY'					||:delim||
  'CURRENCY_CONVERSION_RATE'		||:delim||
  'JE_CATEGORY NVARCHAR(50)'		||:delim||
  'CURRENCY_CODE NVARCHAR(30)'  	||:delim||
  'JE_SOURCE NVARCHAR(50)'  		||:delim||
  'STATUS'  						||:delim||
  'DOC_SEQUENCE_VALUE'				||:delim||
  'ACTUAL_FLAG'						||:delim||
  'LEDGER_ID'				||:delim||
  'DESCRIPTION NVARCHAR(1000)' FROM DUAL;
SELECT 
  JE_HEADER_ID 				||:delim||
  JE_BATCH_ID				||:delim||
  PERIOD_NAME  				||:delim||
  DEFAULT_EFFECTIVE_DATE	||:delim||
  CREATION_DATE				||:delim||
  CREATED_BY	            ||:delim||
  LAST_UPDATE_LOGIN			||:delim||
  LAST_UPDATE_DATE			||:delim||
  LAST_UPDATED_BY			||:delim||
  CURRENCY_CONVERSION_RATE	||:delim||
  JE_CATEGORY  				||:delim||
  CURRENCY_CODE				||:delim||
  JE_SOURCE					||:delim||
  STATUS					||:delim||
  DOC_SEQUENCE_VALUE		||:delim||
  ACTUAL_FLAG				||:delim||
  LEDGER_ID				||:delim||
  REPLACE(DESCRIPTION,'|',' ')  				
FROM GL.GL_JE_HEADERS
WHERE DEFAULT_EFFECTIVE_DATE >= :StartDate
AND DEFAULT_EFFECTIVE_DATE <= :EndDate;

SPOOL OFF



SPOOL je_GL_JE_LINES.actt
SELECT 
  'JE_HEADER_ID INT'				||:delim||	
  'JE_LINE_NUM INT'					||:delim||
  'CODE_COMBINATION_ID INT'			||:delim|| 
  'ACCOUNTED_DR NUMERIC(30,4)'		||:delim||		
  'ACCOUNTED_CR NUMERIC(30,4)'		||:delim||		
  'ENTERED_DR NUMERIC(30,4)' 		||:delim|| 		         
  'ENTERED_CR NUMERIC(30,4)'		||:delim|| 
  'CREATED_BY INT'					||:delim||
  'STATUS'				||:delim||
  'DESCRIPTION NVARCHAR(1000)' FROM DUAL;  
SELECT 
  JE_HEADER_ID			||:delim||
  JE_LINE_NUM			||:delim||
  CODE_COMBINATION_ID	||:delim||  
  ACCOUNTED_DR			||:delim||
  ACCOUNTED_CR			||:delim||
  ENTERED_DR 			||:delim||           
  ENTERED_CR 			||:delim|| 
  CREATED_BY			||:delim||
  STATUS			||:delim||
  REPLACE(DESCRIPTION,'|',' ')  				
FROM GL.GL_JE_LINES
WHERE EFFECTIVE_DATE >= :StartDate
AND EFFECTIVE_DATE <= :EndDate;

SPOOL OFF



SPOOL je_GL_CODE_COMBINATIONS.actt
SELECT 
	'CODE_COMBINATION_ID INT'	||:delim||
	'CHART_OF_ACCOUNTS_ID INT'	||:delim||
	'DESCRIPTION NVARCHAR(500)'	||:delim||
	'ACCOUNT_TYPE NVARCHAR(50)'	||:delim||
	'SEGMENT1 NVARCHAR(50)'		||:delim||
	'SEGMENT2 NVARCHAR(50)'		||:delim||
	'SEGMENT3 NVARCHAR(50)'		||:delim||
	'SEGMENT4 NVARCHAR(50)'		||:delim||
	'SEGMENT5 NVARCHAR(50)'		||:delim||
	'SEGMENT6 NVARCHAR(50)'		||:delim||
	'SEGMENT7 NVARCHAR(50)'		||:delim||
	'SEGMENT8 NVARCHAR(50)'		||:delim||
	'SEGMENT9 NVARCHAR(50)'		||:delim||
	'SEGMENT10 NVARCHAR(50)'	||:delim||
	'SEGMENT11 NVARCHAR(50)'	||:delim||
	'SEGMENT12 NVARCHAR(50)'	||:delim||
	'SEGMENT13 NVARCHAR(50)'	||:delim||
	'SEGMENT14 NVARCHAR(50)'	||:delim||
	'SEGMENT15 NVARCHAR(50)'	||:delim||
	'SEGMENT16 NVARCHAR(50)'	||:delim||
	'SEGMENT17 NVARCHAR(50)'	||:delim||
	'SEGMENT18 NVARCHAR(50)'	||:delim||
	'SEGMENT19 NVARCHAR(50)'	||:delim||
	'SEGMENT20 NVARCHAR(50)'	||:delim||
	'SEGMENT21 NVARCHAR(50)'	||:delim||
	'SEGMENT22 NVARCHAR(50)'	||:delim||
	'SEGMENT23 NVARCHAR(50)'	||:delim||
	'SEGMENT24 NVARCHAR(50)'	||:delim||
	'SEGMENT25 NVARCHAR(50)'	||:delim||
	'SEGMENT26 NVARCHAR(50)'	||:delim||
	'SEGMENT27 NVARCHAR(50)'	||:delim||
	'SEGMENT28 NVARCHAR(50)'	||:delim||
	'SEGMENT29 NVARCHAR(50)'	||:delim||
	'SEGMENT30 NVARCHAR(50)' FROM DUAL;
SELECT 
	CODE_COMBINATION_ID		||:delim||
	CHART_OF_ACCOUNTS_ID	||:delim||
	DESCRIPTION				||:delim||
	ACCOUNT_TYPE				||:delim||			
	SEGMENT1				||:delim||
	SEGMENT2				||:delim||
	SEGMENT3				||:delim||
	SEGMENT4				||:delim||
	SEGMENT5				||:delim||
	SEGMENT6				||:delim||
	SEGMENT7				||:delim||
	SEGMENT8				||:delim||
	SEGMENT9				||:delim||
	SEGMENT10				||:delim||
	SEGMENT11				||:delim||
	SEGMENT12				||:delim||
	SEGMENT13				||:delim||
	SEGMENT14				||:delim||
	SEGMENT15				||:delim||
	SEGMENT16				||:delim||
	SEGMENT17				||:delim||
	SEGMENT18				||:delim||
	SEGMENT19				||:delim||
	SEGMENT20				||:delim||
	SEGMENT21				||:delim||
	SEGMENT22				||:delim||
	SEGMENT23				||:delim||
	SEGMENT24				||:delim||
	SEGMENT25				||:delim||
	SEGMENT26				||:delim||
	SEGMENT27				||:delim||
	SEGMENT28				||:delim||
	SEGMENT29				||:delim||
	SEGMENT30
FROM GL.GL_CODE_COMBINATIONS;

SPOOL OFF



SPOOL actt_config_FieldTerminator.actt
SELECT :delim FROM DUAL;
SPOOL OFF



EXEC :ScriptEndTime := TO_CHAR(SYSDATE,'DD-MON-YYYY  HH:MI AM')



SPOOL actt_config_Settings.actt
SELECT 
	'SettingName VARCHAR(100)' ||:delim||
	'SettingValue NVARCHAR(1000)' FROM DUAL;
SELECT 
	'Extract Script Version' ||:delim||
	:ExtractScriptVersion FROM DUAL;
SELECT 
	'Database Version' ||:delim||
	BANNER 
FROM v$version WHERE BANNER LIKE 'Oracle%';
SELECT 
	'Application Version' ||:delim||
	RELEASE_NAME
 FROM APPS.FND_PRODUCT_GROUPS;
SELECT 
	'Extract Script Start Time' ||:delim||
	:ScriptStartTime FROM DUAL;
SELECT 
	'Extract Script End Time' ||:delim||
	:ScriptEndTime FROM DUAL;
SELECT 
	'Data Extraction Date' ||:delim||
	TO_CHAR(SYSDATE,'DD-MON-YYYY  HH:MI AM') FROM DUAL;
SELECT 
	'JE Effective Date - Start' ||:delim||
	:StartDate FROM DUAL;
SELECT 
	'JE Effective Date - End' ||:delim||
	:EndDate FROM DUAL;


SPOOL OFF


EXIT