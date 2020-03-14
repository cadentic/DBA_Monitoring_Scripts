set feedback off

set serverout on

set wrap off

set pages 300

set lines 150

col file_name for a50

col name for a50

col member for a50

col file_id for a5

col "Percent Used" for a20

col segment_name for a30

col tablespace_name for a30

col STATUS for a16

col owner for a20

col table_name for a35

col index_name for a35

col owner for a20

col object_type for a20

col object_name for a30



column date_column new_value today_var

/

select to_char(sysdate,'yyyy-mm-dd-hh-mi-ss')date_column from dual

/

spool $HOME/${ORACLE_SID}_&today_var.txt



PROMPT =============================================================

PROMPT DATABASE HEALTH CHECK REPORT

PROMPT =============================================================







PROMPT 

PROMPT

PROMPT CURRENT DATE and TIME

PROMPT ======================



Select to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') "Current Date/Time" from dual;



PROMPT 

PROMPT

PROMPT Last Startup Time 

PROMPT ========================



select to_char(STARTUP_TIME,'DD-Mon-YYYY  HH:MI AM') as last_start_time from gv$instance;





PROMPT 

PROMPT

PROMPT Users logged information

PROMPT ===============================



select status,count(*) from gv$session where username not in ('SYS','SYSTEM') group by status;




PROMPT 

PROMPT

PROMPT Previous Day New Object Created count information

PROMPT ===============================



select owner,object_type,count(*) from dba_objects where  to_char(created,'DD-Mon-YY') = to_char(sysdate-1,'DD-Mon-YY') group by owner,object_type order by owner;



PROMPT 

PROMPT

PROMPT Previous Day  New Object Created details

PROMPT ===============================

select owner,object_name,object_type,created from dba_objects where  to_char(created,'DD-Mon-YY') = to_char(sysdate-1,'DD-Mon-YY') order by owner;



PROMPT 

PROMPT

PROMPT Previous Day COmpiled objects count information

PROMPT ===============================



select owner,object_type,count(*) from dba_objects where  to_char(last_ddl_time,'DD-Mon-YY') = to_char(sysdate-1,'DD-Mon-YY') group by owner,object_type order by owner;



PROMPT 

PROMPT

PROMPT  Previous Day COmpiled objects detailed information

PROMPT ======================================================

select owner,object_name,object_type,last_ddl_time from dba_objects where  to_char(last_ddl_time,'DD-Mon-YY') = to_char(sysdate-1,'DD-Mon-YY') order by owner;





PROMPT 

PROMPT

PROMPT Previous day archive logs generation

PROMPT ======================================



select count(*) from v$archived_log where to_char(COMPLETION_TIME,'DD-Mon-YY')=to_char(sysdate-1,'DD-Mon-YY');



PROMPT 

PROMPT

PROMPT latest Archive No.

PROMPT ======================================



archive log list







PROMPT 

PROMPT

PROMPT Instance Pools and memory companents detail

PROMPT =============================================



Show parameter pool

show parameter pga

sho parameter sort

sho parameter cache






PROMPT 

PROMPT

PROMPT TABLESPACES AND DATAFILES

PROMPT ============================



select TABLESPACE_NAME, to_char(file_id, '999') "File_id", FILE_NAME, BYTES/1024/1024 "Size in MB" , STATUS from dba_data_files order by TABLESPACE_NAME, file_name;



PROMPT 

PROMPT

PROMPT UTILIZATION OF TABLESPACES

PROMPT ============================

COLUMN TABLESPACE FORMAT A15



select t.tablespace,  t.totalspace as " Totalspace(MB)",
round((t.totalspace-nvl(fs.freespace,0)),2) as "Used Space(MB)",
nvl(fs.freespace,0) as "Freespace(MB)",
round(((t.totalspace-nvl(fs.freespace,0))/t.totalspace)*100,2) as "%Used",
round((nvl(fs.freespace,0)/t.totalspace)*100,2) as "% Free"
from
(select round(sum(d.bytes)/(1024*1024)) as totalspace,d.tablespace_name tablespace
from dba_data_files d
group by d.tablespace_name) t,
(select round(sum(f.bytes)/(1024*1024)) as freespace,f.tablespace_name tablespace
from dba_free_space f
group by f.tablespace_name) fs
where t.tablespace=fs.tablespace (+)
order by t.tablespace;


PROMPT 

PROMPT

PROMPT TABLESPACES utl >85

PROMPT ============================

COLUMN TABLESPACE FORMAT A15



select t.tablespace,t.totalspace as " Totalspace(MB)",
round((t.totalspace-nvl(fs.freespace,0)),2) as "Used Space(MB)",
nvl(fs.freespace,0) as "Freespace(MB)",
round(((t.totalspace-nvl(fs.freespace,0))/t.totalspace)*100,2) as "%Used",
round((nvl(fs.freespace,0)/t.totalspace)*100,2) as "% Free"
from
(select round(sum(d.bytes)/(1024*1024)) as totalspace,d.tablespace_name tablespace
from dba_data_files d
group by d.tablespace_name) t,
(select round(sum(f.bytes)/(1024*1024)) as freespace,f.tablespace_name tablespace
from dba_free_space f
group by f.tablespace_name) fs
where t.tablespace=fs.tablespace (+)
and round(((t.totalspace-nvl(fs.freespace,0))/t.totalspace)*100,2) >=85
order by t.tablespace
/





PROMPT

PROMPT TABLES THAT CANNOT GET NEXT EXTENT DUE TO EXCEEDING MAXEXTENTS IN TABLE STORAGE PARAMETER

PROMPT =========================================================================================

rem Check whether next extent size excede maxextents value in table storage parameter



select dt.owner,dt.table_name, ds.next_extent, dt.max_extents
from dba_segments ds, dba_tables dt
where ds.segment_name = dt.table_name and
ds.next_extent > dt.max_extents * (select value from v$parameter 
where name = 'db_block_size'); 





PROMPT 

PROMPT

PROMPT INDEXES THAT CANNOT GET NEXT EXTENT DUE TO EXCEEDING MAXEXTENTS IN INDEX STORAGE PARAMETER

PROMPT ==========================================================================================

rem Check whether next extent size excede maxextents value in index storage parameter



select di.owner,di.index_name, ds.next_extent, di.max_extents
from dba_segments ds, dba_indexes di
where ds.segment_name = di.index_name and
ds.next_extent > di.max_extents * (select value from v$parameter 
where name = 'db_block_size'); 







PROMPT 

PROMPT

PROMPT OBJECTS WHOSE STATUS ARE INVALID

PROMPT ===================================

Rem Check object status



select OBJECT_NAME, owner, object_type, STATUS from all_objects where
object_type in
('FUNCTION','INDEX', 'LIBRARY','PACKAGE','PACKAGE BODY',
'PROCEDURE', 'SEQUENCE','SYNONYM','TABLE','TRIGGER',
'TYPE','UNDEFINED','VIEW')
and status = 'INVALID'
and OWNER not in ('SYS','SYSTEM')
and status is not null ;







PROMPT 

PROMPT

PROMPT FILES THAT NEEDS RECOVERY

PROMPT =============================

Rem Check wether there is any data file that needs media recovery



select * from v$recover_file;







PROMPT 

PROMPT

PROMPT LIBRARY CACHE HIT RATIO. THIS VALUE SHOULD BE GREATER 95%

PROMPT ===========================================================

rem get library cache hit ratio

select sum(pins)/(sum(pins)+sum(reloads))*100 "Hit Ratio"
from gv$librarycache;







PROMPT 

PROMPT

PROMPT DICTIONARY HIT RATIO. THIS VALUE SHOULD BE GREATER 85%

PROMPT ==========================================================

rem get dictionary hit ratio. Keep sum(gets)/sum(getmisses) 

rem greater than 85% 

select (1-(sum(getmisses)/sum(gets)))*100 "Hit Ratio"
from gv$rowcache;







PROMPT 

PROMPT

PROMPT DICTIONARY CACHE PIN HIT RATIO STATISTICS 

PROMPT ===========================================



select parameter,gets,getmisses,scans,scanmisses from gv$rowcache;





PROMPT 

PROMPT

PROMPT DATABASE BUFFER HIT RATIO. THIS VALUE SHOULD BE GREATER 95%

PROMPT =============================================================



select name,value from gv$sysstat
where name in ('db block gets','consistent gets','physical reads');



PROMPT

DECLARE
phy_read INTEGER;
db_get INTEGER;
con_get INTEGER;
db_ratio NUMBER(7,4); 
BEGIN
SELECT VALUE INTO phy_read FROM GV$SYSSTAT WHERE name = 'physical reads';
SELECT VALUE INTO db_get FROM GV$SYSSTAT WHERE name = 'db block gets';
SELECT VALUE INTO con_get FROM GV$SYSSTAT WHERE name = 'consistent gets';
db_ratio := (1.0 - (phy_read / (db_get + con_get)))*100;
DBMS_OUTPUT.put_line('DB Buffer Get Ratio: '||TO_CHAR(db_ratio));
END;
/







PROMPT 

PROMPT

PROMPT Rollback HIT RATIO. THIS VALUE SHOULD BE GREATER 95%

PROMPT ===========================================================



select b.NAME,round(((GETS-WAITS)*100)/GETS,2) hit_ratio
from	gv$rollstat a,gv$rollname b
where	a.USN = b.USN;







PROMPT 

PROMPT

PROMPT STATISTICS OF SORTS

PROMPT =======================

rem get statistics of sorts

select name,value from gv$sysstat where name in
('sorts (memory)', 'sorts (disk)');





PROMPT 

PROMPT

PROMPT Database users detail

PROMPT =====================



select username,default_tablespace,temporary_tablespace from dba_users;





PROMPT 

PROMPT

PROMPT Tables Statistics detail

PROMPT =====================



select owner as "SCHEMA", min(last_analyzed) as "Last Analyzed Date" from dba_tables
where owner not like '%SYS%' group by owner;





PROMPT 

PROMPT

PROMPT Indexes Statistics detail

PROMPT =====================



select owner as "SCHEMA", min(last_analyzed) as "Last Analyzed Date" from dba_indexes
where owner not like '%SYS%' group by owner;









PROMPT 

PROMPT

PROMPT  Total Objects 

PROMPT =========================

select owner as "SCHEMA",count(*) from dba_objects
group by owner;





PROMPT 

PROMPT

PROMPT Invalid Objects detail

PROMPT =========================



select owner as "SCHEMA", object_type,count(*) from dba_objects
where status='INVALID' group by owner,object_type;



PROMPT 

PROMPT

PROMPT Invalid Objects detail

PROMPT =========================



select owner as "SCHEMA", object_type,object_name from dba_objects
where status='INVALID' group by owner,object_type;



select count(*)  "TOTAL INVALID OBJECTS" from dba_objects where status='INVALID';



PROMPT 

PROMPT

PROMPT  Session Detail

PROMPT ===========================



select count(*) "Total Session" from v$session;





select count(*) "Active Session" from v$session where status='ACTIVE';







PROMPT 

PROMPT

PROMPT SGA SUMMARY

PROMPT ==============

rem check sga

select * from gv$sga; 





PROMPT 

PROMPT

PROMPT SGA STATISTICS

PROMPT =================

rem get more detail of SGA

select * from gv$sgastat; 


PROMPT 

PROMPT

PROMPT ARCHIVE SUMMARY

PROMPT =================


select count(*) "Total Archive ", round((sum(blocks*block_size)/1024/1024),2)||' MB' "Size MB" 
from v$archived_log where  completion_time > sysdate-1;
 








Spool off

exit


