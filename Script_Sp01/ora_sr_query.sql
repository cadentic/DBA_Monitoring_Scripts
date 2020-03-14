set pages 1000 
set lines 120 
col owner format a30 
col object_name format a30 
col object_type format a30 
col comp_id format a20 
col comp_name format a40 
col version format a10 
col status format a15 
col dbname format a15 
spool INVALID_OBJECTS_AND_REGISTRY_INFO.lst 
PROMPT DATABASE NAME 
PROMPT ============= 
select sys_context('USERENV','DB_NAME') DBNAME from dual; 
PROMPT COUNT OF INVALID OBJECTS 
PROMPT ======================== 
select count(*) from dba_objects where status='INVALID'; 
PROMPT INVALID OBJECTS GROUPED BY OBJECT TYPE AND OWNER 
PROMPT ================================================ 
select owner,object_type,count(*) from dba_objects where status='INVALID' group by owner,object_type; 
PROMPT DBA_REGISTRY CONTENTS (VIEW DOES NOT EXISIT IN VERSIONS < 9.2.0) 
PROMPT ================================================================ 
select comp_id,comp_name,version,status from dba_registry; 
spool off 
spool INVALID_OBJECTS.lst 
PROMPT LIST OF INVALID OBJECTS 
PROMPT ======================= 
select owner,object_name,object_type from dba_objects where status='INVALID'; 
spool off
