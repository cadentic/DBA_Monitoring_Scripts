SET ECHO OFF
REM   =========================================================================
REM   Copyright © 2005 Oracle Corporation Redwood Shores, California, USA
REM   Oracle Support Services.  All rights reserved.
REM   =========================================================================
REM
DEFINE          v_fileName = 'HRMS122'
DEFINE        v_lastUpdate = '06-MAY-2016'
DEFINE          v_testDesc = 'Display HRMS R12 Details'
DEFINE    v_testNoteNumber = '453632.1'
DEFINE           v_product = 'Oracle HRMS'
DEFINE       v_legislation = 'All'
DEFINE          v_platform = 'Generic'
DEFINE v_validAppsVersions = '12.2'
DEFINE   v_inputParameters = 'None'
REM
REM   =========================================================================
REM   USAGE:   sqlplus apps/apps @HRMS122.sql
REM   =========================================================================
REM
REM   CHANGE HISTORY:
REM
REM    03-MAY-2013  jbressle  created HRMS122.sql script
REM
REM    14-FEB-2014  jbressle  added R12.HR_PF.C.delta.3 patch 17001123
REM                 jbressle  added delta 3 patches for all additional applications captured with this script
REM
REM    01-JUL-2014  jbressle  added R12.HR_PF.C.delta.4 patch 17050005  
REM                           added delta 4 released patches for additional available applications AD,AME,HZ,TXK,OTA,IRC,PSP
REM                           added profile 'External ADF Application URL' to PROFILE settings section
REM                           added Q1 2014 SQWL and JIT STATUTORY UPDATE FOR 121 patch 18285981
REM                           added Q2 2014 SQWL and JIT STATUTORY UPDATE FOR 121 patch 19132199
REM                           added 12.2 Oracle Payroll US CA MX Year End patching for 2014 section
REM
REM    11-SEP-2014  jbressle  added R12.HR_PF.C.delta.5 patch 17909898
REM
REM    09-JAN-2015  jbressle  added Q3 2014 SQWL and JIT STATUTORY UPDATE FOR 121 patch 19507770
REM                           added US and CANADA END OF YEAR 2014 STATUTORY UPDATE I   FOR 121 patch 19701971
REM                           added US and CANADA END OF YEAR 2014 STATUTORY UPDATE II  FOR 121 patch 20212223
REM                           added US and Canadian Payroll Customers 2015 Year Begin FOR 120 patch 20212122
REM                           added Canadian HR Only Customers 2015 Year Begin FOR 120 patch 20212120
REM                           added 2014 Annual Geocode patch 19139617
REM
REM    27-JAN-2015  jbressle  added US and CANADA END OF YEAR 2014 STATUTORY UPDATE III FOR 122 patch 20365000
REM                           added profile 'HR:Defer Update After Approval' to PROFILE settings section 
REM  
REM                           MODIFIED the following sections
REM                           
REM                           Application Install Status
REM                           Legislation Details
REM                           Employee Numbering Details
REM                           Geocode Upgrade Manager processes
REM                           HR SECURITY PROFILE settings
REM                           Business Group Info.
REM                           NEXT_VALUE for EMP / APL / CWK 
REM                           Legislation Details
REM                           hrglobal.drv details
REM                           JIT/GEOCODE details
REM                           Database Parameters
REM                           Gather Schema Statistics
REM                           Invalid Objects and Disabled Triggers
REM                           v$parameter settings
REM                           Business Group Details
REM                           Business Group sub-Organizations and Classification Details
REM
REM    03-FEB-2015  jbressle  added MEXICO YEAR END 2014 PHASE I patch 20259629
REM                           added MEXICO YEAR BEGIN 2015 patch 20280156
REM
REM    10-JUN-2015  jbressle  added R12.HR_PF.C.delta.6 patch 19193000
REM                           added Shared HR installed customers ONLY section
REM                           added R12.OTA.C.delta.5 18121278
REM                           added R12.OTA.C.delta.6 19675599
REM                           added R12.IRC.C.delta.5 18121273
REM                           added R12.IRC.C.delta.6 19675587
REM                           added R12.PSP.C.delta.5 18121276
REM                           added R12.PSP.C.delta.6 19675596
REM                           added R12.ATG_PF.C.delta.4 patch 17909318
REM                           added R12.TXK.C.delta.5 patch 18288881 
REM                           added R12.TXK.C.Delta.6 patch 19330775
REM                           added R12.AD.C.delta.5 patch 18283295
REM                           added R12.AD.C.delta.6 patch 19197270
REM
REM    30-OCT-2015  jbressle  created 12.1 Oracle Payroll US CA MX Year End patching for 2015 section
REM                           added Q3 2015 SQWL & JIT STATUTORY UPDATE FOR 121 patch 21664392
REM                           added YE15P1: US & CANADA END OF YEAR 2015 STATUTORY UPDATE I FOR R12.1 patch 21911111
REM                           added 2015 Annual Geocode patch 21276246
REM                           added International Payroll Details section
REM
REM    05-FEB-2016  jbressle  added R12.ALR.C.delta.5  19244904
REM                                 R12.XDO.B.delta.5  19245198
REM                                 R12.UMX.C.delta.5  19245158
REM                                 R12.AK.C.delta.5   19244847
REM                                 R12.CAC.C.delta.5  19683559
REM                                 R12.JTA.C.delta.5  19245048
REM                                 R12.EC.C.delta.5   19244998
REM                                 R12.FND.C.delta.5  19244801
REM                                 R12.FRM.C.delta.5  19245079
REM                                 R12.HZ.C.delta.5   19676694
REM                                 R12.FIN_PF.C.delta.5  19060002
REM                                 R12.BNE.C.delta.5  19244972
REM                                 R12.AME.C.delta.5  18121271
REM                                 R12.AME.C.delta.6  19675586
REM                                 R12.AME.C.delta.7  20030495
REM
REM    06-MAY-2016  jbressle  added R12.HR_PF.C.Delta.8 patch 21507777
REM
REM
REM
REM
REM
REM
REM
REM
REM
REM
REM
REM



REM
REM   =========================================================================

REM   =========================================================================
REM   Set SQL PLUS Environment Variables
REM   =========================================================================

      SET FEEDBACK OFF
      SET HEADING ON
      SET LINESIZE 100
      SET LONG 2000000000
      SET LONGCHUNKSIZE 32767
      SET PAGESIZE 50
      SET SERVEROUTPUT ON SIZE 1000000 FORMAT WRAP
      SET TERMOUT ON
      SET TIMING OFF
      SET TRIMOUT ON
      SET TRIMSPOOL ON
      SET VERIFY OFF

      ALTER SESSION SET NLS_DATE_FORMAT = 'DD-Mon-YYYY';      
    
REM   =========================================================================
REM   Define SQL Variables
REM   =========================================================================

      COLUMN userName new_value v_userName noprint
      select user userName from dual;

      COLUMN testDate new_value v_testDate noprint
      select substr('&v_testDesc',INSTR('&v_testDesc','(',1,1)+1,11) testDate from dual;
                 
      COLUMN sqlplusVersion new_value v_sqlplusVersion noprint
      SELECT NVL('&_SQLPLUS_RELEASE','Unknown') sqlplusVersion from dual;
      
      COLUMN server NEW_VALUE v_server NOPRINT
      SELECT HOST_NAME server FROM V$INSTANCE;
      
      COLUMN platform NEW_VALUE v_platform NOPRINT
      SELECT SUBSTR( REPLACE( REPLACE( pcv1.product,'TNS for '),':' )||pcv2.status,1,40 ) platform
      FROM product_component_version pcv1, product_component_version pcv2
      WHERE UPPER( pcv1.product ) LIKE '%TNS%' AND UPPER( pcv2.product ) LIKE '%ORACLE%' AND ROWNUM = 1;
      

      COLUMN ssdt NEW_VALUE v_ssdt NOPRINT
      SELECT SYSDATE ssdt FROM DUAL;

      COLUMN sid NEW_VALUE v_sid NOPRINT
      SELECT NAME sid FROM V$DATABASE;

      COLUMN crtddt NEW_VALUE v_crtddt NOPRINT
      SELECT CREATED crtddt FROM V$DATABASE;
      
      COLUMN dbVersion NEW_VALUE v_dbVer NOPRINT
      SELECT BANNER dbVersion FROM V$VERSION WHERE ROWNUM = 1;
      
      COLUMN dbComp NEW_VALUE v_dbComp NOPRINT      
      SELECT 'compatible = ' || p.value dbComp FROM v$parameter p WHERE p.name = 'compatible';
      
      COLUMN dbLang NEW_VALUE v_lang NOPRINT
      SELECT VALUE dbLang FROM V$NLS_PARAMETERS WHERE parameter = 'NLS_LANGUAGE';
      
      COLUMN dbCharSet NEW_VALUE v_char NOPRINT
      SELECT VALUE dbCharSet FROM V$NLS_PARAMETERS WHERE parameter = 'NLS_CHARACTERSET';
      
      COLUMN appVer NEW_VALUE v_appVer NOPRINT
      SELECT RELEASE_NAME appVer FROM FND_PRODUCT_GROUPS;
       







REM   =========================================================================
REM   R12.2+ HRMS family packs - 12.2 through 12.2.8
REM   =========================================================================




      COLUMN PFbugDate1228 NEW_VALUE v_PFbugDate1228 NOPRINT                    
      SELECT * FROM (
      SELECT 'Patch:' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '21507777', 'R12.HR_PF.C.delta.8')
          || ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate1228
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('21507777')
      ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1; 





      COLUMN PFbugDate1226 NEW_VALUE v_PFbugDate1226 NOPRINT                    
      SELECT * FROM (
      SELECT 'Patch:' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '19193000', 'R12.HR_PF.C.delta.6')
          || ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate1226
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('19193000')
      ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1; 




      COLUMN PFbugDate1225 NEW_VALUE v_PFbugDate1225 NOPRINT                    
      SELECT * FROM (
      SELECT 'Patch:' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '17909898', 'R12.HR_PF.C.delta.5')
          || ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate1225
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('17909898')
      ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1; 




      COLUMN PFbugDate1224 NEW_VALUE v_PFbugDate1224 NOPRINT                    
      SELECT * FROM (
      SELECT 'Patch:' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '17050005', 'R12.HR_PF.C.delta.4')
          || ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate1224
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('17050005')
      ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1; 




      COLUMN PFbugDate1223 NEW_VALUE v_PFbugDate1223 NOPRINT                    
      SELECT * FROM (
      SELECT 'Patch:' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '17001123', 'R12.HR_PF.C.delta.3')
          || ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate1223
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('17001123')
      ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1; 




      COLUMN PFbugDate1222 NEW_VALUE v_PFbugDate1222 NOPRINT                    
      SELECT * FROM (
      SELECT 'Patch:' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '16169935', 'R12.HR_PF.C.delta.2')
          || ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate1222
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('16169935')
      ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1; 




      COLUMN PFbugDate1221 NEW_VALUE v_PFbugDate1221 NOPRINT                    
      SELECT * FROM (
      SELECT 'Patch:' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '14040707', 'R12.HR_PF.C.delta.1')
          || ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate1221
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('14040707')
      ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1; 




      COLUMN PFbugDate122 NEW_VALUE v_PFbugDate122 NOPRINT                    
      SELECT * FROM (
      SELECT 'Patch:' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '10124646', 'R12.HR_PF.C')
          || ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate122
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('10124646')
      ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1; 






REM   =========================================================================
REM   12.2 Oracle Payroll US CA MX Year End patching for 2014
REM   =========================================================================



REM   
REM   Q1 2014: SQWL & JIT STATUTORY UPDATE FOR 122 patch 18285981
REM   

      COLUMN PFbugDate18285981 NEW_VALUE v_PFbugDate18285981 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate18285981
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('18285981')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 




REM  
REM   Q2 2014: SQWL & JIT STATUTORY UPDATE FOR 122 patch 19132199
REM   

      COLUMN PFbugDate19132199 NEW_VALUE v_PFbugDate19132199 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate19132199
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('19132199')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 





REM   
REM   Q3 2014: SQWL & JIT STATUTORY UPDATE FOR 122 patch 19507770
REM   

      COLUMN PFbugDate19507770 NEW_VALUE v_PFbugDate19507770 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate19507770
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('19507770')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 





REM   
REM   US & CANADA END OF YEAR 2014 STATUTORY UPDATE I FOR R122 patch 19701971
REM   

      COLUMN PFbugDate19701971 NEW_VALUE v_PFbugDate19701971 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate19701971
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('19701971')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 





REM   
REM   US & CANADA END OF YEAR 2014 STATUTORY UPDATE II FOR R122 patch 20212223
REM   

      COLUMN PFbugDate20212223 NEW_VALUE v_PFbugDate20212223 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate20212223
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('20212223')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 






REM   
REM   US & CANADA END OF YEAR 2014 STATUTORY UPDATE III FOR R122 patch 20365000
REM   

      COLUMN PFbugDate20365000 NEW_VALUE v_PFbugDate20365000 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate20365000
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('20365000')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 







REM   
REM   US and Canadian Payroll Customers 2015 Year Begin patch 20212122
REM   

      COLUMN PFbugDate20212122 NEW_VALUE v_PFbugDate20212122 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate20212122
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('20212122')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 




REM   
REM   Canadian HR Only Customers 2015 Year Begin patch 20212120
REM   

      COLUMN PFbugDate20212120 NEW_VALUE v_PFbugDate20212120 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate20212120
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('20212120')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 





REM   
REM   MEXICO YEAR END 2014 PHASE I FOR R12.2 patch 20259629
REM   

      COLUMN PFbugDate20259629 NEW_VALUE v_PFbugDate20259629 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate20259629
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('20259629')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 





REM   
REM   122 MEXICO YEAR BEGIN - 2015 patch 20280156
REM   

      COLUMN PFbugDate20280156 NEW_VALUE v_PFbugDate20280156 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate20280156
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('20280156')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 








REM   =========================================================================
REM   12.2 Oracle Payroll Year End US CA MX patching for 2015
REM   =========================================================================



REM   
REM   Q3 2015: SQWL & JIT STATUTORY UPDATE FOR 122 patch 21664392
REM   

      COLUMN PFbugDate21664392 NEW_VALUE v_PFbugDate21664392 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate21664392
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('21664392')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 




REM   
REM   US & CANADA END OF YEAR 2015 STATUTORY UPDATE I FOR R12.2 patch 21911111
REM   

      COLUMN PFbugDate21911111 NEW_VALUE v_PFbugDate21911111 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate21911111
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('21911111')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 





REM   
REM   US & CANADA END OF YEAR 2015 STATUTORY UPDATE II FOR R12.2 patch 
REM   






REM   
REM   US & CANADA END OF YEAR 2015 STATUTORY UPDATE III FOR R12.2 patch 
REM   






REM   
REM   YE15P1 122 MEXICO YEAREND - 2015 PHASE 1 patch 
REM   














REM   =========================================================================
REM   R12 GEOCODE patches
REM   =========================================================================

      COLUMN GeocodeDate NEW_VALUE v_GeocodeDate NOPRINT                    
      SELECT * FROM (
      SELECT 'patch ' || bug_number || ' ' ||
             DECODE(BUG_NUMBER
             , '8977291', 'GEOCODE_ANNUAL_2009'
             , '9879190', 'GEOCODE_ANNUAL_2010')  
          || ' applied ' || LAST_UPDATE_DATE || ' '   GeocodeDate
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('8977291','9879190')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 





REM   =========================================================================
REM   All Geocodes Patches Installed 
REM   =========================================================================



      COLUMN GeocodeDate2015 NEW_VALUE v_GeocodeDate2015 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   GeocodeDate2015
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('21276246')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 





      COLUMN GeocodeDate2014 NEW_VALUE v_GeocodeDate2014 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   GeocodeDate2014
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('19139617')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 




      COLUMN GeocodeDate2013 NEW_VALUE v_GeocodeDate2013 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   GeocodeDate2013
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('17029535')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 



      COLUMN GeocodeDate2012 NEW_VALUE v_GeocodeDate2012 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   GeocodeDate2012
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('14281883')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 




      COLUMN GeocodeDate2011 NEW_VALUE v_GeocodeDate2011 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   GeocodeDate2011
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('12729901')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 




      COLUMN GeocodeDate2010 NEW_VALUE v_GeocodeDate2010 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   GeocodeDate2010
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('9879190')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 




      COLUMN GeocodeDate2009 NEW_VALUE v_GeocodeDate2009 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   GeocodeDate2009
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('8977291')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 








REM   =========================================================================
REM   R12 PER and PAY installed
REM   =========================================================================


      COLUMN HRStatus NEW_VALUE v_HRStatus NOPRINT
      SELECT L.MEANING  HRStatus
      FROM FND_APPLICATION_ALL_VIEW V, FND_PRODUCT_INSTALLATIONS I, FND_LOOKUPS L
      WHERE (V.APPLICATION_ID = I.APPLICATION_ID)
        AND (V.APPLICATION_ID = '800')
        AND (L.LOOKUP_TYPE = 'FND_PRODUCT_STATUS')
        AND (L.LOOKUP_CODE = I.Status);
        



      COLUMN PayStatus NEW_VALUE v_PayStatus NOPRINT
      SELECT L.MEANING  PayStatus
      FROM FND_APPLICATION_ALL_VIEW V, FND_PRODUCT_INSTALLATIONS I, FND_LOOKUPS L
      WHERE (V.APPLICATION_ID = I.APPLICATION_ID)
        AND (V.APPLICATION_ID = '801')
        AND (L.LOOKUP_TYPE = 'FND_PRODUCT_STATUS')
        AND (L.LOOKUP_CODE = I.Status);       
        




REM   =========================================================================
REM   R12 Workflow WF version
REM   =========================================================================


      COLUMN wfVer NEW_VALUE v_wfVersion NOPRINT
      SELECT 'WorkFlow' || ' ' || TEXT wfVer
      FROM WF_RESOURCES
      WHERE TYPE = 'WFTKN' 
        AND NAME = 'WF_VERSION'
        AND LANGUAGE = 'US';






REM   =========================================================================
REM   R12 iRec patches
REM   =========================================================================


      COLUMN IRCbugDate NEW_VALUE v_IRCbugDate NOPRINT    
      SELECT * FROM (
             SELECT 'iRecruitment patch: ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '10192273', 'R12.IRC.C'
             , '14237522', 'R12.IRC.C.delta.1'
             , '16169917', 'R12.IRC.C.delta.2'
             , '17028739', 'R12.IRC.C.delta.3'
             , '17940202', 'R12.IRC.C.delta.4'
             , '18121273', 'R12.IRC.C.delta.5'
             , '19675587', 'R12.IRC.C.delta.6')
             || ' applied ' || LAST_UPDATE_DATE || ' ' IRCbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('10192273','14237522','16169917','17028739','17940202','18121273','19675587')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;





REM   =========================================================================
REM   R12 Learning Management patches (ota)
REM   =========================================================================



      COLUMN OLMbugDate NEW_VALUE v_OLMbugDate NOPRINT    
      SELECT * FROM (
             SELECT 'Learning Management:' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '10192277', 'R12.OTA.C'
             , '14237526', 'R12.OTA.C.delta.1'
             , '16169924', 'R12.OTA.C.delta.2'
             , '17028741', 'R12.OTA.C.delta.3'
             , '17940603', 'R12.OTA.C.delta.4'
             , '18121278', 'R12.OTA.C.delta.5'
             , '19675599', 'R12.OTA.C.delta.6')
             || ' applied ' || LAST_UPDATE_DATE || ' ' OLMbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('10192277','14237526','16169924','17028741','17940603','18121278','19675599')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;





REM   =========================================================================
REM   R12 Labor Distribution psp patches
REM   =========================================================================


      COLUMN LDbugDate NEW_VALUE v_LDbugDate NOPRINT    
      SELECT * FROM (
             SELECT 'Labor Distribution: ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '10192276', 'R12.PSP.C'
             , '14237524', 'R12.PSP.C.delta.1'
             , '16169922', 'R12.PSP.C.delta.2'
             , '17028740', 'R12.PSP.C.delta.3'
             , '17940214', 'R12.PSP.C.delta.4'
             , '18121276', 'R12.PSP.C.delta.5'
             , '19675596', 'R12.PSP.C.delta.6')
             || ' applied ' || LAST_UPDATE_DATE || ' ' LDbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('10192276','14237524','16169922','17028740','17940214','18121276','19675596')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;





REM   =========================================================================
REM   R12 MultiOrg flag
REM   =========================================================================


      COLUMN MultiORGflag NEW_VALUE v_MultiORGflag NOPRINT                    
      SELECT * FROM (
             SELECT 'Multi Org flag = ' || ' ' || MULTI_ORG_FLAG || '  - ' ||
             ' flag set ' || LAST_UPDATE_DATE || ' ' MultiORGflag
             FROM FND_PRODUCT_GROUPS)
      WHERE ROWNUM = 1;




REM   =========================================================================
REM   R12 ATG patching
REM   =========================================================================


      COLUMN ATGbugDate NEW_VALUE v_ATGbugDate NOPRINT                    
      SELECT * FROM (
             SELECT 'Applications Technology patch:     ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '10110982', 'R12.ATG_PF.C'
             , '14222219', 'R12.ATG_PF.C.delta.1'
             , '15890638', 'R12.ATG_PF.C.delta.2'
             , '17007206', 'R12.ATG_PF.C.delta.3'
             , '17909318', 'R12.ATG_PF.C.delta.4'
             , '19245366', 'R12.ATG_PF.C.delta.5'
             , '21900895', 'R12.ATG_PF.C.delta.6') 
             || ' applied ' || LAST_UPDATE_DATE || ' 'ATGbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
         ('10110982','14222219','15890638','17007206','17909318','19245366','21900895')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;


R12.ATG_PF.C.delta.4 patch 17909318




REM   =========================================================================
REM   R12 Oracle Applications Technology Stack (TXK) patches
REM   =========================================================================


      COLUMN TXKbugDate NEW_VALUE v_TXKbugDate NOPRINT                    
      SELECT * FROM (
             SELECT 'Techstack patch:                   ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '10110941', 'R12.TXK.C'
             , '14231141', 'R12.TXK.C.delta.1'
             , '15946788', 'R12.TXK.C.delta.2'
             , '17021789', 'R12.TXK.C.delta.3'
             , '17893964', 'R12.TXK.C.delta.4'
             , '18288881', 'R12.TXK.C.delta.5'
             , '19330775', 'R12.TXK.C.delta.6')
             || ' applied ' || LAST_UPDATE_DATE || ' ' TXKbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('10110941','14231141','15946788','17021789','17893964','18288881','19330775')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;






REM   =========================================================================
REM   R12 Oracle Alert alr patches
REM   =========================================================================


      COLUMN ALRbugDate NEW_VALUE v_ALRbugDate NOPRINT    
      SELECT * FROM (
             SELECT 'Alerts patch:                      ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '10110925', 'R12.ALR.C'
             , '14230885', 'R12.ALR.C.delta.1'
             , '15946366', 'R12.ALR.C.delta.2'
             , '17021248', 'R12.ALR.C.delta.3'
             , '17908863', 'R12.ALR.C.delta.4'
             , '19244904', 'R12.ALR.C.delta.5')
             || ' applied ' || LAST_UPDATE_DATE || ' ' ALRbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('10110925','14230885','15946366','17021248','17908863','19244904')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;






REM   =========================================================================
REM   R12 BI Publisher (formerly XML Publisher) xdo patches
REM   =========================================================================



      COLUMN XDObugDate NEW_VALUE v_XDObugDate NOPRINT                    
      SELECT * FROM (
             SELECT 'BI Publisher patch:               ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '6430103', 'R12.XDO.B'
             , '7310274', 'R12.XDO.B.delta.1'
             , '7651160', 'R12.XDO.B.delta.2'
             , '8919488', 'R12.XDO.B.delta.3'
             , '17909172', 'R12.XDO.B.delta.4'
             , '19245198', 'R12.XDO.B.delta.5')
             || ' applied ' || LAST_UPDATE_DATE || ' ' XDObugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('6430103','7310274','7651160','8919488','17909172','19245198')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;






REM   =========================================================================
REM   R12 User Management umx patches
REM   =========================================================================


      COLUMN UMXbugDate NEW_VALUE v_UMXbugDate NOPRINT                    
      SELECT * FROM (
             SELECT 'User Management patch:             ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '10110944', 'R12.UMX.C'
             , '14231178', 'R12.UMX.C.delta.1'
             , '15946804', 'R12.UMX.C.delta.2'
             , '17021814', 'R12.UMX.C.delta.3'
             , '17909122', 'R12.UMX.C.delta.4'
             , '19245158', 'R12.UMX.C.delta.5')
             || ' applied ' || LAST_UPDATE_DATE || ' ' UMXbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('10110944','14231178','15946804','17021814','17909122','19245158')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;





REM   =========================================================================
REM   R12 Oracle Common Application Components ak patches
REM   =========================================================================


      COLUMN AKbugDate NEW_VALUE v_AKbugDate NOPRINT    
      SELECT * FROM (
             SELECT 'AK Common Modules patch:           ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '10110923', 'R12.AK.C'
             , '14230807', 'R12.AK.C.delta.1'
             , '15946331', 'R12.AK.C.delta.2'
             , '17008252', 'R12.AK.C.delta.3'
             , '17908810', 'R12.AK.C.delta.4'
             , '19244847', 'R12.AK.C.delta.5') 
             || ' applied ' || LAST_UPDATE_DATE || ' ' AKbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('10110923','14230807','15946331','17008252','17908810','19244847')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;







REM   =========================================================================
REM   R12 Oracle Common Applications Calendar (cac) patching
REM   =========================================================================


      COLUMN CACbugDate NEW_VALUE v_CACbugDate NOPRINT                    
      SELECT * FROM (
             SELECT 'Common Application Calendar patch: ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '10193478', 'R12.CAC.C'
             , '14229765', 'R12.CAC.C.delta.1'
             , '16170025', 'R12.CAC.C.delta.2'
             , '17021515', 'R12.CAC.C.delta.3'
             , '17939738', 'R12.CAC.C.delta.4'
             , '19683559', 'R12.CAC.C.delta.5') 
             || ' applied ' || LAST_UPDATE_DATE || ' ' CACbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('10193478','14229765','16170025','17021515','17939738','19683559')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;






REM   =========================================================================
REM   R12 Oracle Common Applications jta (formerly CRM applications Foundation)
REM   =========================================================================


      COLUMN JTAbugDate NEW_VALUE v_JTAbugDate NOPRINT    
      SELECT * FROM (
             SELECT 'CRM Applications Foundation patch: ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '10110934', 'R12.JTA.C'
             , '14231041', 'R12.JTA.C.delta.1'
             , '15946726', 'R12.JTA.C.delta.2'
             , '17021722', 'R12.JTA.C.delta.3'
             , '17909008', 'R12.JTA.C.delta.4'
             , '19245048', 'R12.JTA.C.delta.5') 
             || ' applied ' || LAST_UPDATE_DATE || ' ' JTAbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('10110934','14231041','15946726','17021722','17909008','19245048')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;






REM   =========================================================================
REM   R12 Oracle EDI Gateway ec (formerly Oracle E-Commerce Gateway)
REM   =========================================================================


      COLUMN ECbugDate NEW_VALUE v_ECbugDate NOPRINT    
      SELECT * FROM (
             SELECT 'EDI Gateway patch:                 ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '10110930', 'R12.EC.C'
             , '14230981', 'R12.EC.C.delta.1'
             , '15946511', 'R12.EC.C.delta.2'
             , '17021373', 'R12.EC.C.delta.3'
             , '17908951', 'R12.EC.C.delta.4'
             , '19244998', 'R12.EC.C.delta.5')
             || ' applied ' || LAST_UPDATE_DATE || ' ' ECbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN  
             ('10110930','14230981','15946511','17021373','17908951','19244998')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;





REM   =========================================================================
REM   R12 Application Object Library fnd patches
REM   =========================================================================


      COLUMN FNDbugDate NEW_VALUE v_FNDbugDate NOPRINT    
      SELECT * FROM (
             SELECT 'Application Object Library patch:  ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '10110954', 'R12.FND.C'
             , '14231287', 'R12.FND.C.delta.1'
             , '15946874', 'R12.FND.C.delta.2'
             , '17021962', 'R12.FND.C.delta.3'
             , '17908376', 'R12.FND.C.delta.4'
             , '19244801', 'R12.FND.C.delta.5')
             || ' applied ' || LAST_UPDATE_DATE || ' ' FNDbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('10110954','14231287','15946874','17021962','17908376','19244801')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;





REM   =========================================================================
REM   R12 Oracle Applications DBA (AD) patches
REM   =========================================================================


      COLUMN ADbugDate NEW_VALUE v_ADbugDate NOPRINT    
      SELECT * FROM (
             SELECT 'Applications DBA patch:            ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '10117518', 'R12.AD.C'
             , '14222207', 'R12.AD.C.1'
             , '15955263', 'R12.AD.C.2'
             , '17023760', 'R12.AD.C.3'
             , '17766337', 'R12.AD.C.4'
             , '18283295', 'R12.AD.C.5'
             , '19197270', 'R12.AD.C.6')
             || ' applied ' || LAST_UPDATE_DATE || ' ' ADbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('10117518','14222207','15955263','17023760','17766337','18283295','19197270')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;






REM   =========================================================================
REM   R12 Oracle Report Manager frm patches
REM   =========================================================================


      COLUMN FRMbugDate NEW_VALUE v_FRMbugDate NOPRINT    
      SELECT * FROM (
             SELECT 'Report Manager patch:              ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '10110936', 'R12.FRM.C'
             , '14231075', 'R12.FRM.C.delta.1'
             , '15946742', 'R12.FRM.C.delta.2'
             , '17021744', 'R12.FRM.C.delta.3'
             , '17909042', 'R12.FRM.C.delta.4'
             , '19245079', 'R12.FRM.C.delta.5')
             || ' applied ' || LAST_UPDATE_DATE || ' ' FRMbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('10110936','14231075','15946742','17021744','17909042','19245079')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;





REM   =========================================================================
REM   R12 Oracle Trading Community hz patches
REM   =========================================================================


      COLUMN HZbugDate NEW_VALUE v_HZbugDate NOPRINT    
      SELECT * FROM (
             SELECT 'Trading Community patch:           ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '10197042', 'R12.HZ.C'
             , '14247600', 'R12.HZ.C.delta.1'
             , '16181773', 'R12.HZ.C.delta.2'
             , '17028334', 'R12.HZ.C.delta.3'
             , '18045300', 'R12.HZ.C.delta.4'
             , '19676694', 'R12.HZ.C.delta.5')
             || ' applied ' || LAST_UPDATE_DATE || ' ' HZbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('10197042','14247600','16181773','17028334','18045300','19676694')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;





REM   =========================================================================
REM   R12 Oracle Financials Family fin_pf patches
REM   =========================================================================


      COLUMN FINbugDate NEW_VALUE v_FINbugDate NOPRINT    
      SELECT * FROM (
             SELECT 'Financials patch:                  ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '10197302', 'R12.FIN_PF.C'
             , '14227186', 'R12.FIN_PF.C.delta.1'
             , '15969696', 'R12.FIN_PF.C.delta.2'
             , '17026955', 'R12.FIN_PF.C.delta.3'
             , '17940003', 'R12.FIN_PF.C.delta.4'
             , '19060002', 'R12.FIN_PF.C.delta.5')
             || ' applied ' || LAST_UPDATE_DATE || ' ' FINbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('10197302','14227186','15969696','17026955','17940003','19060002')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;






REM   =========================================================================
REM   R12 Oracle Web Applications Desktop Integrator bne patches
REM   =========================================================================


      COLUMN ADIbugDate NEW_VALUE v_ADIbugDate NOPRINT    
      SELECT * FROM (
             SELECT 'Web Application Desktop Integrator:' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '10110929', 'R12.BNE.C'
             , '14230960', 'R12.BNE.C.delta.1'
             , '15946430', 'R12.BNE.C.delta.2'
             , '17021345', 'R12.BNE.C.delta.3'
             , '17908911', 'R12.BNE.C.delta.4'
             , '19244972', 'R12.BNE.C.delta.5')
             || ' applied ' || LAST_UPDATE_DATE || ' ' ADIbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('10110929','14230960','15946430','17021345','17908911','19244972')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;





REM   =========================================================================
REM   R12 Oracle Approval Management Engine ame patches
REM   =========================================================================


      COLUMN AMEbugDate NEW_VALUE v_AMEbugDate NOPRINT    
      SELECT * FROM (
             SELECT 'Approval Management Engine:        ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '10192272', 'R12.AME.C'
             , '14237507', 'R12.AME.C.delta.1'
             , '16169916', 'R12.AME.C.delta.2'
             , '17028726', 'R12.AME.C.delta.3'
             , '17940182', 'R12.AME.C.delta.4'
             , '18121271', 'R12.AME.C.delta.5'
             , '19675586', 'R12.AME.C.delta.6'
             , '20030495', 'R12.AME.C.delta.7')
             || ' applied ' || LAST_UPDATE_DATE || ' ' AMEbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('10192272','14237507','16169916','17028726','17940182','18121271','19675586','20030495')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;






REM   =========================================================================
REM   START SPOOLING 
REM   =========================================================================

REM   COLUMN fileExt new_value v_fileExtension noprint

      select decode(substr('&v_sqlplusVersion',1,3),'800','txt','html') fileExt from dual; 


REM   COLUMN spoolfile new_value v_spoolFile noprint
REM   select '&v_fileName._&v_sid._diag.&v_fileExtension' spoolFile from dual;
      
REM   COLUMN setMarkupOff new_value v_setMarkupOff noprint
REM   select decode('&v_fileExtension','html','MARKUP html OFF SPOOL OFF','ECHO OFF') setMarkupOff from dual;   
      
REM      COLUMN setMarkupOn new_value v_setMarkupOn noprint
REM      select decode(lower('&v_fileExtension'),'html','MARKUP html ON SPOOL ON HEAD ''<TITLE>&v_spoolFile</TITLE> -
REM             <STYLE type="text/css"> - 
REM             BODY {font:10pt Arial,Helvetica,sans-serif; color:black; background:White;} 
REM             p {font:10pt Arial,Helvetica,sans-serif; color:black; background:White;} 
REM             table,tr,td {font:10pt Arial,Helvetica,sans-serif; color:Black; background:#f7f7e7; padding:0px 0px 0px 0px; 
REM             margin:0px 0px 0px 0px;} 
REM             th {font:bold 10pt Arial,Helvetica,sans-serif; color:#336699; background:#cccc99; padding:0px 0px 0px 0px;} 
REM             h1 {font:16pt Arial,Helvetica,Geneva,sans-serif; color:#336699; background-color:White; border-bottom:1px solid #cccc99; 
REM             margin-top:0pt; margin-bottom:0pt; padding:0px 0px 0px 0px;} 
REM             h2 {font:bold 10pt Arial,Helvetica,Geneva,sans-serif; color:#336699; background-color:White; margin-top:4pt; 
REM             margin-bottom:0pt;} 
REM             a {font:9pt Arial,Helvetica,sans-serif; color:#663300; background:#ffffff; margin-top:0pt; margin-bottom:0pt; 
REM             vertical-align:top;}</STYLE>''','ECHO OFF') setMarkupOn from dual; 

REM   select decode(lower('&v_fileExtension'),'html','ECHO OFF','ECHO OFF') setMarkupOn from dual; 


      COLUMN spoolfile new_value v_spoolFile noprint
      select '&v_fileName._&v_sid._&v_ssdt..txt' spoolFile from dual;



REM   =========================================================================
REM   END SPOOLING
REM   =========================================================================





REM   =========================================================================
REM   Prompt for Input Parameter(s)
REM   =========================================================================

      PROMPT
      PROMPT &v_fileName..sql - 'Last HRMS121.sql Update Date ' &v_lastUpdate
      PROMPT ================================================================
      PROMPT &v_testDesc
      PROMPT
      PROMPT SQL*Plus User/Version = &v_userName / &v_sqlplusVersion      
      PROMPT NOTE: This Script must be run from SQL*Plus as user apps.
      PROMPT
      PROMPT

      COLUMN startTime new_value v_start noprint
      SELECT to_number(TO_CHAR(SYSDATE,'SSSSS')) startTime FROM DUAL;
      
REM   =========================================================================
REM   Start Spooling and Display Running Message
REM   =========================================================================

      PROMPT ======================================================================
      PROMPT Generating Details for &v_fileName.  This may take several minutes.
      PROMPT ======================================================================
      PROMPT
      PROMPT  Running.....
      PROMPT 
      
      SET TERMOUT OFF;
REM   SET &v_setMarkupOn
REM   SPOOL &v_spoolFile


REM   SPOOL HRMS121_output_file.txt


      SPOOL &v_spoolFile


      PROMPT SQL*Plus User/Version = &v_userName / &v_sqlplusVersion
      PROMPT NOTE: This Script must be run from SQL*Plus as user apps.  
      PROMPT
          

REM   =========================================================================
REM   Display Test Header Details
REM   =========================================================================



      PROMPT
      PROMPT
      PROMPT DATE HRMS122 was run: &v_ssdt
      PROMPT
      PROMPT
      PROMPT &v_fileName..sql - Last Update Date: &v_lastUpdate
      PROMPT =========================================================
      PROMPT &v_testDesc
      PROMPT 
      PROMPT
      PROMPT Review the following notes on www.MyOracleSupport.com
      PROMPT The following notes are for Oracle Applications release 11i and 12
      PROMPT =========================================================
      PROMPT Note: 135266.1 - Oracle HRMS Product Family - Release 11i and 12 Information
      PROMPT Note: 145837.1 - Latest HRMS (HR Global) Legislative Data Patch available
      PROMPT Note: 174605.1 - bde_chk_cbo.sql - current, required and rec. init.ora params  
      PROMPT Note: 226987.1 - Oracle HRMS and Benefits Tuning and System Health Check 
      PROMPT
      PROMPT
      PROMPT Most current downloadable version of file HRMS121.sql
      PROMPT =========================================================
      PROMPT Note: &v_testNoteNumber - Latest version of &v_fileName..sql
      PROMPT
      PROMPT
      PROMPT Instance details
      PROMPT ================
      PROMPT            Instance Name = &v_sid
      PROMPT   Instance Creation Date = &v_crtddt
      PROMPT          Server/Platform = &v_server - &v_platform
      PROMPT    Language/Characterset = &v_lang - &v_char
      PROMPT                 Database = &v_dbVer - &v_dbComp
      PROMPT             Applications = &v_appVer
      PROMPT  &v_wfVersion
      PROMPT  PER &v_HRStatus | PAY &v_PayStatus
      PROMPT
      PROMPT
      PROMPT
      PROMPT


      PROMPT  released HRMS family packs -- 12.2 through 12.2.6
      PROMPT =========================================================
      PROMPT  R12.HR_PF.C.delta.8  21507777 --  &v_PFbugDate1228
      PROMPT  R12.HR_PF.C.delta.6  19193000 --  &v_PFbugDate1226
      PROMPT  R12.HR_PF.C.delta.5  17909898 --  &v_PFbugDate1225
      PROMPT  R12.HR_PF.C.delta.4  17050005 --  &v_PFbugDate1224
      PROMPT  R12.HR_PF.C.delta.3  17001123 --  &v_PFbugDate1223
      PROMPT  R12.HR_PF.C.delta.2  16169935 --  &v_PFbugDate1222
      PROMPT  R12.HR_PF.C.delta.1  14040707 --  &v_PFbugDate1221
      PROMPT  R12.HR_PF.C          10124646 --  &v_PFbugDate122
      PROMPT  
      PROMPT  
      PROMPT Oracle HRMS Mandatory Patch List
      PROMPT ===================================
      PROMPT Oracle E-Business Suite HCM Information Center - Consolidated HRMS Mandatory Patch List (Doc ID 1160507.1)
      PROMPT
      PROMPT

      PROMPT
      PROMPT
      PROMPT
      PROMPT LAD Add-on Localizations
      PROMPT ===========================
      PROMPT LAD Add-on Localizations - How to Get Latest Patches Release 12  (Doc ID 1299200.1)
      PROMPT
      PROMPT




      PROMPT
      PROMPT ==========================
      PROMPT Total Invalid Objects = 
      PROMPT ==========================

      select count(*) "COUNT"
      from dba_objects
      WHERE status != 'VALID'
      AND object_type != 'UNDEFINED';

      PROMPT
      PROMPT
      PROMPT
      PROMPT
      PROMPT



PROMPT   =========================================================================
PROMPT   Shared HR installed customers ONLY
PROMPT   =========================================================================
PROMPT   
PROMPT   

PROMPT   Profiles Enabled in shared HR that are not allowed Enabled in shared HR environments
PROMPT   -------------------------------------------------------------------------------------


COLUMN upon        format a40          heading 'User Profile Option Name'
COLUMN lid         format 999999999    heading 'Level ID'
COLUMN appid       format 99999        heading 'App ID'
COLUMN pov         format a18          heading 'Value'
COLUMN lv          format 99999        heading 'Level|Value'


select fpotl.USER_PROFILE_OPTION_NAME upon, 
       fpov.LEVEL_ID lid, 
       fpo.APPLICATION_ID appid, 
       DECODE(fpov.PROFILE_OPTION_VALUE,'Y','Yes',
       DECODE(fpov.PROFILE_OPTION_VALUE,'N','No',
       fpov.PROFILE_OPTION_VALUE)) pov, 
       fpov.LEVEL_VALUE lv 
from FND_PROFILE_OPTIONS fpo, 
     FND_PROFILE_OPTIONS_TL fpotl, 
     FND_PROFILE_OPTION_VALUES fpov
where fpotl.PROFILE_OPTION_NAME = fpo.PROFILE_OPTION_NAME 
and   fpo.PROFILE_OPTION_NAME = 'DATETRACK:ENABLED' 
and   fpotl.PROFILE_OPTION_NAME = 'DATETRACK:ENABLED' 
and   fpo.PROFILE_OPTION_ID = fpov.PROFILE_OPTION_ID 
and   fpotl.LANGUAGE = 'US' 
and   fpov.PROFILE_OPTION_ID = 1208
and   fpov.LEVEL_ID IN (10001,10002) 
and   fpov.LEVEL_VALUE != '804'
order by 1,2,3,5;


PROMPT
PROMPT


select fpotl.USER_PROFILE_OPTION_NAME upon, 
             fpov.LEVEL_ID lid, 
DECODE(fpov.PROFILE_OPTION_VALUE,'Y','Yes',
DECODE(fpov.PROFILE_OPTION_VALUE,'N','No',
             fpov.PROFILE_OPTION_VALUE)) pov
from FND_PROFILE_OPTIONS fpo, 
           FND_PROFILE_OPTIONS_TL fpotl, 
           FND_PROFILE_OPTION_VALUES fpov
where fpotl.PROFILE_OPTION_NAME = fpo.PROFILE_OPTION_NAME 
and   fpotl.PROFILE_OPTION_NAME = 'PER_ENABLE_DTW4' 
and   fpo.PROFILE_OPTION_ID = fpov.PROFILE_OPTION_ID
and   fpov.LEVEL_ID IN (10001,10002) 
and   fpotl.LANGUAGE = 'US' 
and   fpo.APPLICATION_ID = 800;


PROMPT
PROMPT
PROMPT

      PROMPT  Profiles 'DateTrack:Enabled' and 'HR: Enable DTW4 defaulting' are not allowed to be active in a shared HR installed environment. 
      PROMPT  These profiles are only allowed to be active and used within fully installed Oracle Human Resources environments.
      PROMPT
      PROMPT  Leaving these profiles Enabled can cause datetrack records to be created, which is data corruption in shared HR.
      PROMPT  
      PROMPT  Please see the following note and correct the settings for these profiles. 
      PROMPT  Within 'Shared HR' Environments What Types of Records Would You Expect to See in HR tables ? [ID 1075831.1]
      PROMPT  
      PROMPT  

      PROMPT  To correct profile 'DateTrack:Enabled'  run the following against each of your instances.
      PROMPT  
      PROMPT  UPDATE FND_PROFILE_OPTION_VALUES
      PROMPT  SET PROFILE_OPTION_VALUE = NULL
      PROMPT  where APPLICATION_ID = 803
      PROMPT  and PROFILE_OPTION_ID = 1208
      PROMPT  and LEVEL_ID IN (10001,10002)
      PROMPT  and LEVEL_VALUE IN (0,800,801,802,803,805,808,809,810,833,8301,8302,8303)
      PROMPT  
      PROMPT  commit

      PROMPT  
      PROMPT  
      PROMPT 
      PROMPT  To correct profile 'HR: Enable DTW4 defaulting' perform the following against each of your instances.
      PROMPT  
      PROMPT  navigate to 
      PROMPT  System Administrator responsibility >
      PROMPT  Profile >
      PROMPT  System >
      PROMPT  query for the profile and set it to  'No'  at Site  level > 
      PROMPT  Save


      PROMPT  
      PROMPT  
      PROMPT  
      PROMPT  

PROMPT   =========================================================================
PROMPT   END - Shared HR installed customers ONLY
PROMPT   =========================================================================



      PROMPT  
      PROMPT  
      PROMPT  
      PROMPT  



      PROMPT
      PROMPT ================================
      PROMPT Language Details(FND_LANGUAGES)
      PROMPT ================================
      PROMPT
      PROMPT Installed Languages

      column "Language Code"   format A13
      column "Installed Flag"  format A14
      column "NLS Language"    format A35

      SELECT LANGUAGE_CODE  "Language Code",  
             INSTALLED_FLAG "Installed Flag",
             NLS_LANGUAGE   "NLS Language"
      FROM FND_LANGUAGES 
      where INSTALLED_FLAG in ('B','I')
      order by LANGUAGE_CODE;



SET PAGESIZE 200



      PROMPT
      PROMPT
      PROMPT
      PROMPT ==================================================
      PROMPT Legislation Details(HR_LEGISLATION_INSTALLATIONS)
      PROMPT ==================================================
      
      COLUMN legCode  format a29 heading 'Installed Legislation Codes'
      COLUMN appName  format a25 heading 'Application'
      
      SELECT DECODE(legislation_code
                   ,null,'Global'
                   ,legislation_code)                legCode
           , DECODE(application_short_name
                   , 'PER', 'Human Resources'
                   , 'PAY', 'Payroll'
                   , 'GHR', 'Federal Human Resources'
                   , 'CM',  'College Data'
                   , application_short_name)          appName
      FROM hr_legislation_installations
      WHERE status = 'I'
      ORDER BY legislation_code;





      PROMPT
      PROMPT
      PROMPT
      PROMPT
      PROMPT =====================================================
      PROMPT International Payroll Details(PAY_LEGISLATION_RULES)
      PROMPT =====================================================


      COLUMN LEGISLATION_CODE      format a11    heading 'LEGISLATION|CODE       '

      SELECT LEGISLATION_CODE, RULE_TYPE, RULE_MODE
      FROM PAY_LEGISLATION_RULES 
      where LEGISLATION_CODE = 'ZZ' 
      order by LEGISLATION_CODE, RULE_TYPE;


      PROMPT
      PROMPT
      PROMPT
      PROMPT




SET PAGESIZE 50



      PROMPT
      PROMPT
      PROMPT
      PROMPT
      PROMPT
      PROMPT
      PROMPT
      PROMPT
      PROMPT =======================================================
      PROMPT 12.2 Oracle Payroll US CA MX Year End patching for 2014 
      PROMPT =======================================================
      PROMPT
      PROMPT US and Canadian
      PROMPT ================
      PROMPT
      PROMPT Q1 2014 SQWL and JIT STATUTORY UPDATE FOR 122 patch 18285981 -- &v_PFbugDate18285981
      PROMPT Q2 2014 SQWL and JIT STATUTORY UPDATE FOR 122 patch 19132199 -- &v_PFbugDate19132199
      PROMPT Q3 2014 SQWL and JIT STATUTORY UPDATE FOR 122 patch 19507770 -- &v_PFbugDate19507770
      PROMPT

      PROMPT US and CANADA END OF YEAR 2014 STATUTORY UPDATE I   FOR 122 patch 19701971 -- &v_PFbugDate19701971
      PROMPT US and CANADA END OF YEAR 2014 STATUTORY UPDATE II  FOR 122 patch 20212223 -- &v_PFbugDate20212223
      PROMPT US and CANADA END OF YEAR 2014 STATUTORY UPDATE III FOR 122 patch 20365000 -- &v_PFbugDate20365000

      PROMPT
      PROMPT US and Canadian Payroll Customers 2015 Year Begin FOR 122 patch 20212122 -- &v_PFbugDate20212122


      PROMPT
      PROMPT Canadian HR Only Customers 2015 Year Begin FOR 122 patch 20212120 -- &v_PFbugDate20212120

      PROMPT
      PROMPT MEXICO YEAR END 2014 PHASE I FOR R12.2 patch 20259629 -- &v_PFbugDate20259629

      PROMPT
      PROMPT MEXICO YEAR BEGIN 2015 FOR R12.2 patch 20280156 -- &v_PFbugDate20280156






      PROMPT
      PROMPT
      PROMPT
      PROMPT
      PROMPT ========================================================
      PROMPT 12.1 Oracle Payroll US CA MX Year End patching for 2015
      PROMPT ========================================================
      PROMPT
      PROMPT US and Canadian
      PROMPT ================
      PROMPT
      PROMPT Q3 2015 SQWL and JIT STATUTORY UPDATE FOR 121 patch 21664392 -- &v_PFbugDate21664392
      PROMPT US and CANADA END OF YEAR 2015 STATUTORY UPDATE I   FOR R12.1 patch 21911111 -- &v_PFbugDate21911111

REM      PROMPT US and CANADA END OF YEAR 2015 STATUTORY UPDATE II  FOR R12.1 patch 17955555 -- &v_PFbugDate17955555
REM      PROMPT US and CANADA END OF YEAR 2015 STATUTORY UPDATE III FOR R12.1 patch 18075556 -- &v_PFbugDate18075556

      PROMPT
      PROMPT
      PROMPT Third Quarter 2015 Statutory Patch Readme for Release 12.1.x (Doc ID 2060193.1)




      PROMPT
      PROMPT
      PROMPT Mexico
      PROMPT =======
      PROMPT

REM      PROMPT YE15P1 121 MEXICO YEAREND - 2013 PHASE 1 patch 17941884 -- &v_PFbugDate17941884





      PROMPT
      PROMPT
      PROMPT
      PROMPT




      PROMPT
      PROMPT
      PROMPT
      PROMPT
      PROMPT released GEOCODE patches 
      PROMPT ===========================
      PROMPT  GEOCODE_ANNUAL_2015    patch 21276246 &v_GeocodeDate2015
      PROMPT  GEOCODE_ANNUAL_2014    patch 19139617 &v_GeocodeDate2014
      PROMPT  GEOCODE_ANNUAL_2013    patch 17029535 &v_GeocodeDate2013
      PROMPT  GEOCODE_ANNUAL_2012    patch 14281883 &v_GeocodeDate2012
      PROMPT  GEOCODE_ANNUAL_2011    patch 12729901 &v_GeocodeDate2011
      PROMPT  GEOCODE_ANNUAL_2010    patch 9879190 &v_GeocodeDate2010
      PROMPT  GEOCODE_ANNUAL_2009    patch 8977291 &v_GeocodeDate2009



      PROMPT
      PROMPT
      PROMPT
      PROMPT
      PROMPT Geocode Upgrade Manager processes
      PROMPT ====================================
      PROMPT The Geocode Upgrade Manager process is an Oracle Payroll owned process. 
      PROMPT This process must be run after the customer has applied the GEOCODE patch 
      PROMPT IF the customer has Oracle Payroll fully installed. 
      PROMPT 
      PROMPT Customers who have Oracle Human Resources fully installed 
      PROMPT but do not have Oracle Payroll fully installed, 
      PROMPT are not to run the Geocode Upgrade Manager process. 
      PROMPT
      PROMPT
      PROMPT STATUS = 'C' = Complete
      PROMPT STATUS = 'P' = Processing
      PROMPT STATUS = 'E' = Error
      PROMPT


      SET LINESIZE 130

   
      COLUMN pprog          format a50     heading 'Concurrent Process'
      COLUMN preqid         format a10     heading 'Request ID'    
      COLUMN pStartDate     format a11     heading 'Start Date '       
      COLUMN pEndDate       format a11     heading 'End Date   '  
      COLUMN stat           format a12     heading 'Status'


      select PROGRAM pprog, 
             TO_CHAR(request_id) pReqId,
             ACTUAL_START_DATE pStartDate,
             ACTUAL_COMPLETION_DATE pEndDate,
             DECODE(STATUS_CODE,'C','Complete',
             DECODE(STATUS_CODE,'P','Processing',
             DECODE(STATUS_CODE,'E','Error',
             STATUS_CODE))) stat
      from FND_CONC_REQ_SUMMARY_V 
      where PROGRAM = 'Geocode Upgrade Manager' 
      order by REQUEST_ID;






      PROMPT
      PROMPT
      PROMPT
      PROMPT Learning Management details
      PROMPT ===========================
      PROMPT  &v_OLMbugDate
      PROMPT
      PROMPT
      PROMPT iRecruitment details
      PROMPT ===========================
      PROMPT  &v_IRCbugDate
      PROMPT
      PROMPT
      PROMPT Labor Distribution details
      PROMPT ===========================
      PROMPT  &v_LDbugDate
      PROMPT
      PROMPT
      PROMPT Is this instance Multi Org
      PROMPT ===========================
      PROMPT  &v_MultiORGflag
      PROMPT
      PROMPT
      PROMPT Pay Action Parameter detail
      PROMPT ============================
      col PARAMETER_NAME     format a28
      col PARAMETER_VALUE    format a47
      select PARAMETER_NAME, PARAMETER_VALUE 
      from PAY_ACTION_PARAMETERS;

      PROMPT
      PROMPT
      PROMPT
      PROMPT
      PROMPT OTHER current patching levels
      PROMPT ==============================
      PROMPT  AD :  &v_ADbugDate
      PROMPT  AK :  &v_AKbugDate
      PROMPT  ALR:  &v_ALRbugDate
      PROMPT  AME:  &v_AMEbugDate
      PROMPT  ATG:  &v_ATGbugDate
      PROMPT  BNE:  &v_ADIbugDate
      PROMPT  CAC:  &v_CACbugDate
      PROMPT  EC :  &v_ECbugDate
      PROMPT  FIN:  &v_FINbugDate
      PROMPT  FND:  &v_FNDbugDate
      PROMPT  FRM:  &v_FRMbugDate
      PROMPT  HZ :  &v_HZbugDate
      PROMPT  JTA:  &v_JTAbugDate
      PROMPT  TXK:  &v_TXKbugDate
      PROMPT  UMX:  &v_UMXbugDate
      PROMPT
      PROMPT


      SET LINESIZE 100

       
      COLUMN app        format a49 heading 'Application Install Status'
      COLUMN appId      format a6  heading 'Id'
      COLUMN appStatus  format a15 heading 'Status' 
      COLUMN patch      format a20 heading 'Patch Level|(?=unknown)'   


      SELECT V.APPLICATION_NAME        app
           , to_char(V.APPLICATION_ID) appId
           , L.MEANING                 appStatus
           , DECODE(I.PATCH_LEVEL, NULL, 'R12.' || v.APPLICATION_SHORT_NAME || '.?', I.PATCH_LEVEL) patch
      FROM FND_APPLICATION_ALL_VIEW V, FND_PRODUCT_INSTALLATIONS I, FND_LOOKUPS L
      WHERE (V.APPLICATION_ID = I.APPLICATION_ID)
        AND (V.APPLICATION_ID IN 
            ('0','50','178','231','275','453','603','800','801','802','803','804','805','808','809','810'
             ,'821','8401','8301','8302','8303','8403','101','200'))
        AND (L.LOOKUP_TYPE = 'FND_PRODUCT_STATUS')
        AND (L.LOOKUP_CODE = I.Status )
      ORDER BY UPPER(APPLICATION_NAME); 
 



REM   =========================================================================
REM   Display Test Details
REM   =========================================================================






REM   =========================================================================
REM   PROFILE settings
REM   =========================================================================


PROMPT
PROMPT
PROMPT
PROMPT
PROMPT
PROMPT
PROMPT =======================================================================================
PROMPT PROFILE settings (FND_PROFILE_OPTIONS FND_PROFILE_OPTIONS_TL FND_PROFILE_OPTION_VALUES)
PROMPT =======================================================================================
PROMPT This section lists PROFILE settings 
PROMPT 
PROMPT 
PROMPT LEVEL_ID values   
PROMPT ============================
PROMPT  
PROMPT value 10001 = SITE
PROMPT value 10002 = APPLICATION
PROMPT value 10003 = RESPONSIBILITY
PROMPT  
PROMPT  
PROMPT  
PROMPT LEVEL_VALUE values   
PROMPT ============================
PROMPT  
PROMPT  800 = PER  (Human Resources)
PROMPT  801 = PAY  (Payroll)
PROMPT  805 = BEN  (Oracle Advanced Benefits)
PROMPT  808 = OTM  (Time and Labor)
PROMPT  809 = OTL  (Time and Labor engine)
PROMPT  810 = OTA  (Learning Management)
PROMPT  833 = OTL  (Time and Labor)
PROMPT 8301 = GHR  (US Federal Human Resources)
PROMPT 8302 = PQH  (Public Sector Human Resources)
PROMPT 8303 = PQP  (Public Sector Payroll)
PROMPT 8401 = PSB  (Public Sector Budgeting)
PROMPT  
PROMPT  




REM   =========================================================================
REM   DateTrack:Enabled
REM   =========================================================================


COLUMN upon        format a40          heading 'User Profile Option Name'
COLUMN lid         format 999999999    heading 'Level ID'
COLUMN appid       format 99999        heading 'App ID'
COLUMN pov         format a18          heading 'Value'
COLUMN lv          format 99999        heading 'Level|Value'



select fpotl.USER_PROFILE_OPTION_NAME upon, 
             fpov.LEVEL_ID lid, 
             fpo.APPLICATION_ID appid, 
DECODE(fpov.PROFILE_OPTION_VALUE,'Y','Yes',
DECODE(fpov.PROFILE_OPTION_VALUE,'N','No',
             fpov.PROFILE_OPTION_VALUE)) pov, 
             fpov.LEVEL_VALUE lv 
from FND_PROFILE_OPTIONS fpo, 
     FND_PROFILE_OPTIONS_TL fpotl, 
     FND_PROFILE_OPTION_VALUES fpov
where fpotl.PROFILE_OPTION_NAME = fpo.PROFILE_OPTION_NAME 
and   fpo.PROFILE_OPTION_NAME = 'DATETRACK:ENABLED' 
and   fpotl.PROFILE_OPTION_NAME = 'DATETRACK:ENABLED' 
and   fpo.PROFILE_OPTION_ID = fpov.PROFILE_OPTION_ID 
and   fpotl.LANGUAGE = 'US' 
and   fpov.PROFILE_OPTION_ID = 1208
and   fpov.LEVEL_ID IN (10001,10002) 
and   fpov.LEVEL_VALUE != '804'
order by 1,2,3,5;




PROMPT
PROMPT
PROMPT

REM   =========================================================================
REM   HR:Cross Business Group
REM   =========================================================================


COLUMN upon        format a45          heading 'User Profile Option Name' 
COLUMN lid         format 999999999    heading 'Level ID' 
COLUMN pov         format a27          heading 'Value'


select fpotl.USER_PROFILE_OPTION_NAME upon, 
             fpov.LEVEL_ID lid, 
DECODE(fpov.PROFILE_OPTION_VALUE,'Y','Yes',
DECODE(fpov.PROFILE_OPTION_VALUE,'N','No',
             fpov.PROFILE_OPTION_VALUE)) pov
from FND_PROFILE_OPTIONS fpo, 
           FND_PROFILE_OPTIONS_TL fpotl, 
           FND_PROFILE_OPTION_VALUES fpov
where fpotl.PROFILE_OPTION_NAME = fpo.PROFILE_OPTION_NAME 
and   fpotl.PROFILE_OPTION_NAME = 'HR_CROSS_BUSINESS_GROUP' 
and   fpo.PROFILE_OPTION_ID = fpov.PROFILE_OPTION_ID 
and   fpotl.LANGUAGE = 'US' 
and   fpov.LEVEL_ID IN (10001,10002);



SET PAGESIZE 0





REM   =========================================================================
REM   HR:Defer Update After Approval
REM   =========================================================================


select fpotl.USER_PROFILE_OPTION_NAME upon, 
             fpov.LEVEL_ID lid, 
DECODE(fpov.PROFILE_OPTION_VALUE,'Y','Yes',
DECODE(fpov.PROFILE_OPTION_VALUE,'N','No',
             fpov.PROFILE_OPTION_VALUE)) pov
from FND_PROFILE_OPTIONS fpo, 
           FND_PROFILE_OPTIONS_TL fpotl, 
           FND_PROFILE_OPTION_VALUES fpov
where fpotl.PROFILE_OPTION_NAME = fpo.PROFILE_OPTION_NAME 
and   fpotl.PROFILE_OPTION_NAME = 'HR_DEFER_UPDATE' 
and   fpo.PROFILE_OPTION_ID = fpov.PROFILE_OPTION_ID 
and   fpotl.LANGUAGE = 'US' 
and   fpov.LEVEL_ID IN (10001);





REM   =========================================================================
REM   HR: Enable DTW4 defaulting
REM   =========================================================================


select fpotl.USER_PROFILE_OPTION_NAME upon, 
             fpov.LEVEL_ID lid, 
DECODE(fpov.PROFILE_OPTION_VALUE,'Y','Yes',
DECODE(fpov.PROFILE_OPTION_VALUE,'N','No',
             fpov.PROFILE_OPTION_VALUE)) pov
from FND_PROFILE_OPTIONS fpo, 
           FND_PROFILE_OPTIONS_TL fpotl, 
           FND_PROFILE_OPTION_VALUES fpov
where fpotl.PROFILE_OPTION_NAME = fpo.PROFILE_OPTION_NAME 
and   fpotl.PROFILE_OPTION_NAME = 'PER_ENABLE_DTW4' 
and   fpo.PROFILE_OPTION_ID = fpov.PROFILE_OPTION_ID
and   fpov.LEVEL_ID IN (10001,10002) 
and   fpotl.LANGUAGE = 'US' 
and   fpo.APPLICATION_ID = 800;




REM   =========================================================================
REM   HR: Local or Global Name Format
REM   =========================================================================


select fpotl.USER_PROFILE_OPTION_NAME upon, 
       fpov.LEVEL_ID lid, 
DECODE(fpov.PROFILE_OPTION_VALUE,'G','Global Format',
DECODE(fpov.PROFILE_OPTION_VALUE,'L','Local Format',
       fpov.PROFILE_OPTION_VALUE)) pov
from FND_PROFILE_OPTIONS fpo, 
     FND_PROFILE_OPTIONS_TL fpotl, 
     FND_PROFILE_OPTION_VALUES fpov
where fpotl.PROFILE_OPTION_NAME = fpo.PROFILE_OPTION_NAME 
and   fpotl.PROFILE_OPTION_NAME = 'HR_LOCAL_OR_GLOBAL_NAME_FORMAT' 
and   fpo.PROFILE_OPTION_ID = fpov.PROFILE_OPTION_ID 
and   fpotl.LANGUAGE = 'US' 
and   fpov.LEVEL_ID IN (10001);



REM   =========================================================================
REM   HR: National Identifier Validation
REM   =========================================================================


select fpotl.USER_PROFILE_OPTION_NAME upon, 
       fpov.LEVEL_ID lid, 
DECODE(fpov.PROFILE_OPTION_VALUE,'ERROR','Error on Fail',
DECODE(fpov.PROFILE_OPTION_VALUE,'NONE','No Validation',
DECODE(fpov.PROFILE_OPTION_VALUE,'WARN','Warning on Fail',
       fpov.PROFILE_OPTION_VALUE))) pov
from FND_PROFILE_OPTIONS fpo, 
     FND_PROFILE_OPTIONS_TL fpotl, 
     FND_PROFILE_OPTION_VALUES fpov
where fpotl.PROFILE_OPTION_NAME = fpo.PROFILE_OPTION_NAME 
and   fpotl.PROFILE_OPTION_NAME = 'PER_NATIONAL_IDENTIFIER_VALIDATION' 
and   fpo.PROFILE_OPTION_ID = fpov.PROFILE_OPTION_ID 
and   fpotl.LANGUAGE = 'US' 
and   fpov.LEVEL_ID IN (10001);



REM   =========================================================================
REM   HR: Use Title in Person's Full Name
REM   =========================================================================


select fpotl.USER_PROFILE_OPTION_NAME upon, 
             fpov.LEVEL_ID lid, 
DECODE(fpov.PROFILE_OPTION_VALUE,'Y','Yes',
DECODE(fpov.PROFILE_OPTION_VALUE,'N','No',
             fpov.PROFILE_OPTION_VALUE)) pov
from FND_PROFILE_OPTIONS fpo, 
           FND_PROFILE_OPTIONS_TL fpotl, 
           FND_PROFILE_OPTION_VALUES fpov
where fpotl.PROFILE_OPTION_NAME = fpo.PROFILE_OPTION_NAME 
and   fpotl.PROFILE_OPTION_NAME = 'PER_USE_TITLE_IN_FULL_NAME' 
and   fpo.PROFILE_OPTION_ID = fpov.PROFILE_OPTION_ID 
and   fpotl.LANGUAGE = 'US' 
and   fpov.LEVEL_ID IN (10001,10002); 







REM   =========================================================================
REM   HR:User Type
REM   =========================================================================


select fpotl.USER_PROFILE_OPTION_NAME upon, 
       fpov.LEVEL_ID lid, 
DECODE(fpov.PROFILE_OPTION_VALUE,'INT','HR with Payroll User',
DECODE(fpov.PROFILE_OPTION_VALUE,'PAY','Payroll User',
DECODE(fpov.PROFILE_OPTION_VALUE,'PER','HR User',
       fpov.PROFILE_OPTION_VALUE))) pov
from FND_PROFILE_OPTIONS fpo, 
     FND_PROFILE_OPTIONS_TL fpotl, 
     FND_PROFILE_OPTION_VALUES fpov
where fpotl.PROFILE_OPTION_NAME = fpo.PROFILE_OPTION_NAME 
and   fpotl.PROFILE_OPTION_NAME = 'HR_USER_TYPE' 
and   fpo.PROFILE_OPTION_ID = fpov.PROFILE_OPTION_ID 
and   fpotl.LANGUAGE = 'US' 
and   fpov.LEVEL_ID IN (10001);





REM   =========================================================================
REM   MO: Operating Unit
REM   =========================================================================


select fpotl.USER_PROFILE_OPTION_NAME upon,
             fpov.LEVEL_ID lid, 
             haou.NAME pov
from FND_PROFILE_OPTIONS fpo, 
           FND_PROFILE_OPTIONS_TL fpotl, 
           FND_PROFILE_OPTION_VALUES fpov, 
           HR_ALL_ORGANIZATION_UNITS haou
where fpotl.PROFILE_OPTION_NAME = fpo.PROFILE_OPTION_NAME 
and   fpotl.PROFILE_OPTION_NAME = 'ORG_ID' 
and   fpo.PROFILE_OPTION_ID = fpov.PROFILE_OPTION_ID 
and   fpov.PROFILE_OPTION_VALUE = haou.ORGANIZATION_ID 
and   fpotl.LANGUAGE = 'US' 
and   fpov.LEVEL_ID IN (10001,10002); 







REM   =========================================================================
REM   External ADF Application URL
REM   =========================================================================


select fpotl.USER_PROFILE_OPTION_NAME upon, 
       fpov.LEVEL_ID lid, 
DECODE(fpov.PROFILE_OPTION_VALUE,'ERROR','Error on Fail',
DECODE(fpov.PROFILE_OPTION_VALUE,'NONE','No Validation',
DECODE(fpov.PROFILE_OPTION_VALUE,'WARN','Warning on Fail',
       fpov.PROFILE_OPTION_VALUE))) pov
from FND_PROFILE_OPTIONS fpo, 
     FND_PROFILE_OPTIONS_TL fpotl, 
     FND_PROFILE_OPTION_VALUES fpov
where fpotl.PROFILE_OPTION_NAME = fpo.PROFILE_OPTION_NAME 
and   fpotl.PROFILE_OPTION_NAME = 'FND_EXTERNAL_ADF_URL' 
and   fpo.PROFILE_OPTION_ID = fpov.PROFILE_OPTION_ID 
and   fpotl.LANGUAGE = 'US' 
and   fpov.LEVEL_ID IN (10001);





SET PAGESIZE 50




PROMPT
PROMPT
PROMPT
PROMPT
PROMPT
PROMPT
PROMPT =======================================================================================
PROMPT HR SECURITY PROFILE settings 
PROMPT (FND_PROFILE_OPTIONS FND_PROFILE_OPTIONS_TL FND_PROFILE_OPTION_VALUES PER_SECURITY_PROFILES)
PROMPT =======================================================================================
PROMPT This section lists SECURITY PROFILE settings 
PROMPT 
PROMPT 
PROMPT 
PROMPT HR Security Related NOTES 
PROMPT ==========================
PROMPT Understanding and Using HRMS Security in Oracle HRMS (Doc ID 394083.1)
PROMPT Troubleshooting eBusiness Suite HRMS Security Issues (Doc ID 1266051.1)
PROMPT MO/HR SECURITY PROFILES NOT WORKING TO VIEW ORGANIZATIONS (Doc ID 1066243.1)
PROMPT Need Custom Security Profile To Restrict Based On Employees Organization (Doc ID 445142.1)
PROMPT Why You Cannot Find The 'HR: Ex-Employee Security' profile Profile In R12.1.2 Instance? (Doc ID 1068014.1)
PROMPT Security, MultiOrg, and Multi Org Access Control(MOAC) support in relation to Oracle Human Resources applications (Doc ID 1385633.1)
PROMPT 
PROMPT 
PROMPT 
PROMPT LEVEL_ID values   
PROMPT ============================
PROMPT  
PROMPT value 10001 = SITE
PROMPT value 10002 = APPLICATION
PROMPT value 10003 = RESPONSIBILITY
PROMPT 
PROMPT 


REM   =========================================================================
REM   HR: Security Profile
REM   =========================================================================


COLUMN upon        format a40                  heading 'Profile'
COLUMN lid         format 99999999             heading 'Level ID'
COLUMN spname      format a29                  heading 'Profile Value'



select fpotl.USER_PROFILE_OPTION_NAME upon, 
             fpov.LEVEL_ID lid, 
             substr(psp.SECURITY_PROFILE_NAME,1,40) spname
from FND_PROFILE_OPTIONS fpo, 
     FND_PROFILE_OPTIONS_TL fpotl, 
     FND_PROFILE_OPTION_VALUES fpov,
     PER_SECURITY_PROFILES psp
where fpotl.PROFILE_OPTION_NAME = fpo.PROFILE_OPTION_NAME 
and   fpotl.PROFILE_OPTION_NAME = 'PER_SECURITY_PROFILE_ID' 
and   fpov.PROFILE_OPTION_VALUE = psp.SECURITY_PROFILE_ID
and   fpo.PROFILE_OPTION_ID = fpov.PROFILE_OPTION_ID
and   fpov.LEVEL_ID IN (10001) 
and   fpotl.LANGUAGE = 'US' 
and   fpo.APPLICATION_ID = 800; 




SET PAGESIZE 0




REM   =========================================================================
REM   HR: Include Terminated People in Search
REM   =========================================================================


select fpotl.USER_PROFILE_OPTION_NAME upon, 
             fpov.LEVEL_ID lid, 
             DECODE(fpov.PROFILE_OPTION_VALUE,'Y','Yes',
             DECODE(fpov.PROFILE_OPTION_VALUE,'N','No',
                    fpov.PROFILE_OPTION_VALUE)) spname
from FND_PROFILE_OPTIONS fpo, 
     FND_PROFILE_OPTIONS_TL fpotl, 
     FND_PROFILE_OPTION_VALUES fpov
where fpotl.PROFILE_OPTION_NAME = fpo.PROFILE_OPTION_NAME 
and   fpotl.PROFILE_OPTION_NAME = 'HR_VIEW_TERM_PEOPLE_INSRCH' 
and   fpo.PROFILE_OPTION_ID = fpov.PROFILE_OPTION_ID
and   fpov.LEVEL_ID IN (10001,10002) 
and   fpotl.LANGUAGE = 'US' 
and   fpo.APPLICATION_ID = 800;





REM   =========================================================================
REM   HR: Access Non-Current Employee Data
REM   =========================================================================


select fpotl.USER_PROFILE_OPTION_NAME upon, 
             fpov.LEVEL_ID lid, 
             DECODE(fpov.PROFILE_OPTION_VALUE,'Y','Yes',
             DECODE(fpov.PROFILE_OPTION_VALUE,'N','No',
                    fpov.PROFILE_OPTION_VALUE)) spname
from FND_PROFILE_OPTIONS fpo, 
     FND_PROFILE_OPTIONS_TL fpotl, 
     FND_PROFILE_OPTION_VALUES fpov
where fpotl.PROFILE_OPTION_NAME = fpo.PROFILE_OPTION_NAME 
and   fpotl.PROFILE_OPTION_NAME = 'PER_EX_SECURITY_PROFILE' 
and   fpo.PROFILE_OPTION_ID = fpov.PROFILE_OPTION_ID
and   fpov.LEVEL_ID IN (10001,10002) 
and   fpotl.LANGUAGE = 'US' 
and   fpo.APPLICATION_ID = 800;




SET PAGESIZE 8000


PROMPT 
PROMPT 
PROMPT 
PROMPT 


PROMPT Security > 
PROMPT Profile > 
PROMPT Security Profile screen > 
PROMPT Security Profiles > 
PROMPT 
PROMPT 



set pagesize 500
SET LINESIZE 130



COLUMN spid        format 9999999999999        heading 'Sec Profile ID'
COLUMN spname      format a100                 heading 'Security Profile Name'



select SECURITY_PROFILE_ID spid, 
       SECURITY_PROFILE_NAME spname
from PER_SECURITY_PROFILES 
order by UPPER(SECURITY_PROFILE_NAME);


set pagesize 50



PROMPT
PROMPT
PROMPT
PROMPT
PROMPT
PROMPT
PROMPT =========================================================================
PROMPT Employee Numbering Details 
PROMPT =========================================================================
PROMPT
PROMPT =======================================================
PROMPT Global Numbering Profile 
PROMPT (FND_PROFILE_OPTIONS_VL and FND_PROFILE_OPTION_VALUES)
PROMPT =======================================================
PROMPT 
PROMPT 
PROMPT for Global Numbering please see the following note 
PROMPT 
PROMPT 
PROMPT NOTE : 259160.1
PROMPT Title: Step By Step Instructions For Implementing Global Sequencing 
PROMPT 
PROMPT 
PROMPT 
PROMPT VERY IMPORTANT: 
PROMPT ================
PROMPT Once a customer implements Global Numbering, 
PROMPT they cannot go backwards and revert back to Automatic or Manual Numbering via Business Group Info.
PROMPT 
PROMPT They must continue to use Global Numbering. 
PROMPT 
PROMPT Global Numbering is a functionality which is supported by Oracle Human Resources support.


PROMPT
PROMPT
PROMPT

PROMPT LEVEL_ID values   
PROMPT ============================
PROMPT  
PROMPT value 10001 = SITE
PROMPT value 10002 = APPLICATION
PROMPT value 10003 = RESPONSIBILITY
PROMPT  
PROMPT 


COLUMN upon        format a45          heading 'Profile Name' 
COLUMN lid         format 999999999    heading 'Level ID' 
COLUMN pov         format a5           heading 'Value'


select fpotl.USER_PROFILE_OPTION_NAME upon, 
             fpov.LEVEL_ID lid, 
DECODE(fpov.PROFILE_OPTION_VALUE,'Y','Yes',
DECODE(fpov.PROFILE_OPTION_VALUE,'N','No',
             fpov.PROFILE_OPTION_VALUE)) pov
from FND_PROFILE_OPTIONS fpo, 
           FND_PROFILE_OPTIONS_TL fpotl, 
           FND_PROFILE_OPTION_VALUES fpov
where fpotl.PROFILE_OPTION_NAME = fpo.PROFILE_OPTION_NAME 
and   fpotl.PROFILE_OPTION_NAME = 'PER_GLOBAL_APL_NUM' 
and   fpo.PROFILE_OPTION_ID = fpov.PROFILE_OPTION_ID 
and   fpotl.LANGUAGE = 'US' 
and   fpov.LEVEL_ID IN (10001,10002);


set pagesize 0


select fpotl.USER_PROFILE_OPTION_NAME upon, 
             fpov.LEVEL_ID lid, 
DECODE(fpov.PROFILE_OPTION_VALUE,'Y','Yes',
DECODE(fpov.PROFILE_OPTION_VALUE,'N','No',
             fpov.PROFILE_OPTION_VALUE)) pov
from FND_PROFILE_OPTIONS fpo, 
           FND_PROFILE_OPTIONS_TL fpotl, 
           FND_PROFILE_OPTION_VALUES fpov
where fpotl.PROFILE_OPTION_NAME = fpo.PROFILE_OPTION_NAME 
and   fpotl.PROFILE_OPTION_NAME = 'PER_GLOBAL_CWK_NUM' 
and   fpo.PROFILE_OPTION_ID = fpov.PROFILE_OPTION_ID 
and   fpotl.LANGUAGE = 'US' 
and   fpov.LEVEL_ID IN (10001,10002);




select fpotl.USER_PROFILE_OPTION_NAME upon, 
             fpov.LEVEL_ID lid, 
DECODE(fpov.PROFILE_OPTION_VALUE,'Y','Yes',
DECODE(fpov.PROFILE_OPTION_VALUE,'N','No',
             fpov.PROFILE_OPTION_VALUE)) pov
from FND_PROFILE_OPTIONS fpo, 
           FND_PROFILE_OPTIONS_TL fpotl, 
           FND_PROFILE_OPTION_VALUES fpov
where fpotl.PROFILE_OPTION_NAME = fpo.PROFILE_OPTION_NAME 
and   fpotl.PROFILE_OPTION_NAME = 'PER_GLOBAL_EMP_NUM' 
and   fpo.PROFILE_OPTION_ID = fpov.PROFILE_OPTION_ID 
and   fpotl.LANGUAGE = 'US' 
and   fpov.LEVEL_ID IN (10001,10002);



set pagesize 50



PROMPT
PROMPT
PROMPT
PROMPT 
PROMPT ===========================================
PROMPT Custom Number Generation Using FastFormula 
PROMPT (ALL_SOURCE and FF_FUNCTIONS_V)
PROMPT ===========================================
PROMPT 
PROMPT for Custom Number Generation Using FastFormula please see 
PROMPT NOTE : 279458.1
PROMPT Title: How To Implement Custom Person Numbering Using FastFormula
PROMPT 
PROMPT DISCLAIMER: 
PROMPT While this functionality was released by Oracle HR Development with 11i.HR_PF.H patch 3233333 
PROMPT any implementation making use of this feature is purely a Customization. 
PROMPT 
PROMPT Oracle Support Services 'will not support' these FF Fast Formulas nor the associated Functions. 
PROMPT It is up to the customer to create and diagnose any code used to implement this functionality.
PROMPT 
PROMPT This section searches for Custom NUMBER_GENERATION Packages and FF Fast Formulas on customer 
PROMPT instances to determine their existance.
PROMPT 


PROMPT 
PROMPT 
PROMPT 
PROMPT DOES A CUSTOM NUMBER GENERATION PACKAGE EXIST? 
PROMPT 

       select OWNER, NAME, TEXT
       from   ALL_SOURCE
       where  UPPER(NAME) like UPPER('%NUMBER_GENERATION%')
       and    OWNER = 'APPS'
       and    TEXT like '%$Header%'
       order  by NAME;


PROMPT 
PROMPT
PROMPT
PROMPT DOES A CUSTOM NUMBER GENERATION FF FAST FORMULA EXIST?
PROMPT 

       select * from FF_FUNCTIONS_V 
       where UPPER(DATA_TYPE) = UPPER('number') 
       and UPPER(DEFINITION) like UPPER('%NUM%GEN%');



SET PAGESIZE 2000



PROMPT
PROMPT
PROMPT
PROMPT ====================================================================
PROMPT Business Group Info. ('Org Developer DF' descriptive flexfield)
PROMPT Employee / Applicant / Contingent Worker Number Generation segments
PROMPT (HR_ORGANIZATION_INFORMATION and HR_ALL_ORGANIZATION_UNITS)
PROMPT ====================================================================
PROMPT 
PROMPT Organization > Business Group > Business Group Info. > settings for 
PROMPT Employee Number Generation
PROMPT Applicant Number Generation
PROMPT Contingent Worker Number Generation
PROMPT
PROMPT Values found under columns Employee/Applicant/ContingentWorker Number Generation can be 
PROMPT
PROMPT   A = Automatic
PROMPT   M = Manual
PROMPT   N = National Identifier
PROMPT


       SET LINESIZE 130


       COLUMN nam          format a80         heading 'Organization Name'
       COLUMN orgid        format 999999999   heading 'ORG_ID    '
       COLUMN lcode        format a2          heading 'LG'
       COLUMN appnum       format a10         heading 'Applicant'
       COLUMN cwknum       format a10         heading 'Contingent'
       COLUMN empnum       format a10         heading 'Employee'


       SELECT haou.NAME              nam
            , hoi.ORGANIZATION_ID    orgid
            , pbg.LEGISLATION_CODE   lcode
            , hoi.ORG_INFORMATION3   appnum
            , hoi.ORG_INFORMATION16  cwknum
            , hoi.ORG_INFORMATION2   empnum
       FROM HR_ORGANIZATION_INFORMATION hoi, 
            HR_ALL_ORGANIZATION_UNITS haou, 
            PER_BUSINESS_GROUPS pbg
       WHERE hoi.ORGANIZATION_ID = haou.ORGANIZATION_ID 
       and   pbg.ORGANIZATION_ID  = haou.ORGANIZATION_ID
       and hoi.ORG_INFORMATION_CONTEXT  = 'Business Group Information' 
       order by 1;



SET PAGESIZE 50

SET PAGESIZE 2000



PROMPT
PROMPT
PROMPT 
PROMPT ===========================================================
PROMPT NEXT_VALUE for EMP / APL / CWK sorted by BUSINESS_GROUP_ID 
PROMPT (PER_NUMBER_GENERATION_CONTROLS)
PROMPT ===========================================================
PROMPT



       COLUMN bgid2    format 999999999   heading 'BG ID'
       COLUMN typ      format a10         heading 'TYPE'

       BREAK ON bgid2

       SELECT BUSINESS_GROUP_ID bgid2, 
              TYPE typ, 
              NEXT_VALUE 
       FROM PER_NUMBER_GENERATION_CONTROLS
       WHERE TYPE IN ('EMP','APL', 'CWK')
       order by 1,2;



SET PAGESIZE 50



PROMPT
PROMPT
PROMPT 
PROMPT =======================================
PROMPT MAX values for EMP / APL / NPW numbers
PROMPT =======================================
PROMPT


       COLUMN empnum    format a20    heading 'MAX EMP Number    '
       COLUMN appnum    format a20    heading 'MAX APL Number    '
       COLUMN npwnum    format a20    heading 'MAX NPW Number    '

       SELECT 
       MAX(TO_CHAR(employee_number))  empnum,
       MAX(TO_CHAR(applicant_number)) appnum,
       MAX(TO_CHAR(npw_number))       npwnum
       FROM PER_ALL_PEOPLE_F;



PROMPT
PROMPT
PROMPT
PROMPT
PROMPT =========================================================================
PROMPT end Employee Numbering Details 
PROMPT =========================================================================
PROMPT
PROMPT




PROMPT
PROMPT
PROMPT
PROMPT Language Details
PROMPT ================
PROMPT
PROMPT Installed Languages
REM PROMPT

      column "Language Code"   format A13
      column "Installed Flag"  format A14
      column "NLS Language"    format A35

      SELECT LANGUAGE_CODE  "Language Code",  
             INSTALLED_FLAG "Installed Flag",
             NLS_LANGUAGE   "NLS Language"
      FROM FND_LANGUAGES 
      where INSTALLED_FLAG in ('B','I')
      order by LANGUAGE_CODE;



SET PAGESIZE 200



      PROMPT
      PROMPT
      PROMPT
      PROMPT ====================
      PROMPT Legislation Details
      PROMPT ====================
      
      COLUMN legCode  format a29 heading 'Installed Legislation Codes'
      COLUMN appName  format a25 heading 'Application'
      
      SELECT DECODE(legislation_code
                   ,null,'Global'
                   ,legislation_code)                legCode
           , DECODE(application_short_name
                   , 'PER', 'Human Resources'
                   , 'PAY', 'Payroll'
                   , 'GHR', 'Federal Human Resources'
                   , 'CM',  'College Data'
                   , application_short_name)          appName
      FROM hr_legislation_installations
      WHERE status = 'I'
      ORDER BY legislation_code;



PROMPT
PROMPT
PROMPT


PROMPT ==========================================
PROMPT New Legislation Installed During Past Year
PROMPT ==========================================
PROMPT

REM  New Legislation data installed during the last year - not all hrglobal patches deliver seed data.

      column date_of_import format a15 heading 'Date Imported'
      column PACKAGE_NAME   format a30 heading 'Package/Export Date'
      column legCode        format a15 heading 'Legislation'
      column status         format a10 heading 'Status'
 
      SELECT date_of_import
           , PACKAGE_NAME 
           , decode(legislation_code, NULL, 'Core', 'ZZ', 'Intl. Payroll',legislation_code) legCode
           , status
      FROM HR_STU_HISTORY
      WHERE TO_NUMBER(TO_CHAR(date_of_import, 'yyyy')) >= TO_NUMBER(TO_CHAR(SYSDATE, 'yyyy')) - 1
      ORDER BY 1 DESC;  
 


SET PAGESIZE 50



PROMPT
PROMPT
PROMPT
PROMPT ========================================================
PROMPT hrglobal.drv details - Review Metalink Note 145837.1 for latest hrglobal patch.
PROMPT ========================================================
PROMPT

REM    COLUMN patchName      format a80 heading 'Version of current hrglobal.drv'
          
REM    SELECT * FROM ( 
REM            SELECT  adv.VERSION || ' installed by patch:' || ap.patch_name  || ' on ' || ap.CREATION_DATE patchName
REM            FROM AD_FILES af
REM               , AD_FILE_VERSIONS adv
REM             , ad_applied_patches ap
REM             , ad_patch_drivers pd
REM             , ad_patch_runs pr
REM             , ad_patch_run_bugs prb
REM             , ad_patch_run_bug_actions prba   
REM          WHERE af.FILE_ID = adv.FILE_ID
REM            AND af.file_id                 = prba.file_id
REM            AND prba.PATCH_FILE_VERSION_ID = adv.FILE_VERSION_ID
REM            AND prba.patch_run_bug_id      = prb.patch_run_bug_id  
REM            AND prb.patch_run_id           = pr.patch_run_id
REM            AND pr.patch_driver_id         = pd.patch_driver_id
REM            AND pd.applied_patch_id        = ap.applied_patch_id
REM            AND af.FILENAME = 'hrglobal.drv'
REM          ORDER BY VERSION desc	
REM      ) WHERE ROWNUM = 1;




PROMPT
PROMPT If you need to see a customer's version of their hrglobal.drv file then have them run the following command 
PROMPT from within their database, anywhere within their database.
PROMPT
PROMPT strings -a $PER_TOP/patch/115/driver/hrglobal.drv | grep Header
PROMPT
PROMPT




      COLUMN LastSuccessfulRun   format a29 heading 'Last Succesfull Run hrglobal'
      COLUMN PatchOptions        format a50 heading 'adpatch Options'

      SELECT pr.end_date             LastSuccessfulRun
           , pr.PATCH_ACTION_OPTIONS PatchOptions
      FROM ad_patch_runs pr
      WHERE pr.PATCH_TOP LIKE '%/per/12.0.0/patch/115/driver'
        AND pr.SUCCESS_FLAG = 'Y'
        AND pr.end_date =(
         SELECT MAX(pr.end_date)
         FROM ad_patch_runs pr
         WHERE pr.PATCH_TOP LIKE '%/per/12.0.0/patch/115/driver'
           AND pr.SUCCESS_FLAG = 'Y');
                      


REM      PROMPT
REM DataInstaller - Legislations selected for Install

      COLUMN legCode  format a20 heading 'DataInstaller|Legisilations|Selected for Install'
      COLUMN asn      format a5  heading 'App'
      COLUMN action   format a10 heading 'Action'

      SELECT DECODE(hli.legislation_code
                   ,null,'Global'
                   ,hli.legislation_code)                legCode
           , hli.application_short_name                  asn
           , hli.action                                  action
      FROM user_views uv
         , hr_legislation_installations hli
      WHERE uv.view_name IN (SELECT view_name FROM hr_legislation_installations)
      AND uv.view_name = hli.view_name
      ORDER by legislation_code desc, application_short_name asc;
      


REM      PROMPT
REM Statutory Exceptions - To address rows listed here review Metalink Note:101351.1
     
      COLUMN table_name     format a25 heading 'Statutory Exceptions|on Table'
      COLUMN surrogate_id   format a10 heading 'Surrogate|ID'
      COLUMN true_key       format a10 heading 'True Key'
      COLUMN exception_text format a33 heading 'Exception Text|Review Note:101351.1'
      
      SELECT table_name
           , to_char(surrogate_id) surrogate_id
           , true_key
           , exception_text
      FROM hr_stu_exceptions;

PROMPT
PROMPT
PROMPT
PROMPT ===================
PROMPT JIT/GEOCODE details
PROMPT ===================
REM Last JIT Installed
      
      COLUMN patchName   format A40 heading 'Last JIT Installed'
      COLUMN appliedDate format A12 heading 'Date Applied' 
      
      SELECT 'Patch:' || to_char(patch_number)
             || ' - ' ||  patch_name            patchName
           , applied_date          appliedDate
      FROM pay_patch_status
      WHERE (patch_name LIKE '%JIT%')
        AND status = 'C'
        AND applied_date IN 
           (SELECT MAX(applied_date) 
            FROM pay_patch_status 
            WHERE (patch_name LIKE '%JIT%')
              AND status = 'C');




PROMPT
PROMPT
PROMPT
PROMPT All released Geocode Patches and Installed Geocode Patches
PROMPT ===================
PROMPT  ANNUAL GEOCODE UPDATE - 2014  patch 19139617 &v_GeocodeDate2014
PROMPT  ANNUAL GEOCODE UPDATE - 2013  patch 17029535 &v_GeocodeDate2013
PROMPT  ANNUAL GEOCODE UPDATE - 2012  patch 13929707 &v_GeocodeDate2012
PROMPT  ANNUAL GEOCODE UPDATE - 2011  patch 12729901 &v_GeocodeDate2011
PROMPT  ANNUAL GEOCODE UPDATE - 2010  patch  9879190 &v_GeocodeDate2010
PROMPT  ANNUAL GEOCODE UPDATE - 2009  patch  8977291 &v_GeocodeDate2009
PROMPT
PROMPT





REM All Geocodes Installed
      
REM      COLUMN patchName   format A50 heading 'All Geocodes Installed'
REM      COLUMN geoUpdates  format 99999999 heading 'Geocodes|Updated'
REM      COLUMN appliedDate format A12 heading 'Date Applied' 

      
REM      SELECT 'Patch:' || decode(stat.patch_number, 9999999, 'Seeded', stat.patch_number)  
REM             || ' - ' || stat.patch_name             patchName
REM           , stat.applied_date           appliedDate
REM           , ( select count(mods.patch_name) from pay_us_modified_geocodes mods where mods.patch_name = stat.patch_name) geoUpdates
REM      FROM pay_patch_status stat
REM      WHERE stat.patch_name LIKE '%GEO%'
REM        AND status = 'C'
REM      ORDER BY applied_date desc;




PROMPT
PROMPT
PROMPT
PROMPT ===================================================
PROMPT Database Parameters - Review Metalink Note 226987.1
PROMPT ===================================================
PROMPT If currently experiencing performance problems run bde_chk_cbo.sql from Metalink Note 174605.1
PROMPT to verify that all Mandatory Parameters (MP) are set correctly.
REM PROMPT
      

      SET LINESIZE 130


      COLUMN pName    format a20     heading 'Database Parameters'
      COLUMN pValue   format a109    heading 'Value'
      
      SELECT p.name pName, p.value pValue FROM v$parameter p
      WHERE p.name IN ('max_dump_file_size','timed_statistics'
	  ,'user_dump_dest','compatible','optimizer_mode'
	  ,'sql_trace','oracle_trace_enable','core_dump_dest'
	  ,'utl_file_dir','timed_os_statistics')
      ORDER BY p.name;



      PROMPT
      PROMPT
      PROMPT
      PROMPT Gather Schema Statistics
      PROMPT ========================
      

      SET LINESIZE 130


      COLUMN pReqId         format a10     heading 'Request ID'       
      COLUMN pProg          format a25     heading 'Concurrent Process'
      COLUMN pStatus        format a16     heading 'Status'   
      COLUMN pParms         format a50     heading 'Parameters'       
      COLUMN pStartDate     format a11     heading 'Start Date '       
      COLUMN pEndDate       format a11     heading 'End Date   '



      SELECT * FROM (
      SELECT TO_CHAR(request_id) pReqId
           , program pProg
           , PHAS.MEANING || ' ' || STAT.MEANING pStatus 
           , fcrs.ARGUMENT_TEXT pParms
           ,REQUESTED_START_DATE pStartDate 
           ,ACTUAL_COMPLETION_DATE pEndDate
      FROM FND_CONC_REQ_SUMMARY_V fcrs
         , FND_LOOKUPS STAT
         , FND_LOOKUPS PHAS
      WHERE STAT.LOOKUP_CODE = FCRS.STATUS_CODE
        AND STAT.LOOKUP_TYPE = 'CP_STATUS_CODE'
        AND PHAS.LOOKUP_CODE = FCRS.PHASE_CODE
        AND PHAS.LOOKUP_TYPE = 'CP_PHASE_CODE'
        AND UPPER(program) LIKE 'GATHER%'
        AND substr(UPPER(ARGUMENT_TEXT),1,3) in ('HR,','ALL')
      ORDER BY 1 desc)
      where rownum < 2;





PROMPT
PROMPT
PROMPT
PROMPT ==================================================================
PROMPT Spatial Indexes and indexes related to Spatial Index issues
PROMPT 
PROMPT ==================================================================
PROMPT



      COLUMN table_name format a26  heading 'Table Name'
      COLUMN index_name format a30  heading 'Index Name'

      select table_name, index_name, status, uniqueness
      from   dba_indexes
      where  index_name in 
      ('HR_LOCATIONS_N1','HR_LOCATIONS_SPT','PER_ADDRESSES_N1','PER_ADDRESSES_SPT','IRC_SEARCH_CRITERIA_CTX')
      order  by index_name;





PROMPT
PROMPT
PROMPT
PROMPT ==================================================================
PROMPT Invalid Objects and Disabled Triggers 
PROMPT Use adadmin to compile apps schema and to resolve invalid objects
PROMPT ==================================================================
PROMPT
REM PROMPT
      

PROMPT
PROMPT
PROMPT Total Invalid Objects = 
PROMPT

      select count(*) "COUNT"
      from dba_objects
      WHERE status != 'VALID'
      AND object_type != 'UNDEFINED';



SET PAGESIZE 8000



PROMPT
PROMPT
      
      COLUMN owner          format a10 heading 'Owner'
      COLUMN object_type    format a25 heading 'Type'
      COLUMN object_name    format a35 heading 'Invalid Object'
      BREAK ON owner ON object_type

      SELECT owner, object_type,  object_name
      FROM dba_objects
      WHERE status != 'VALID'
      AND object_type != 'UNDEFINED'
      ORDER BY 1, 2, 3;



SET PAGESIZE 50


      PROMPT
      PROMPT
      PROMPT

      COLUMN owner           format a10 heading 'Owner'
      COLUMN TABLE_NAME      format a30 heading 'Table'
      COLUMN trigger_name    format a35 heading 'Disabled Triggers'
      BREAK ON owner ON table_name

      SELECT OWNER, TABLE_NAME, TRIGGER_NAME 
      FROM dba_triggers
      WHERE status = 'DISABLED'
	  AND TABLE_OWNER IN ('HR','HXT','HXC','HRI','BEN')
      ORDER BY 1, 2, 3;



PROMPT
PROMPT
PROMPT
PROMPT  =========================================================================
PROMPT  CHECK FOR STATUS OF 'WHO' TRIGGERS for the following HR owned tables:
PROMPT  =========================================================================
PROMPT   'HR_ALL_ORGANIZATION_UNITS'
PROMPT   'HR_ALL_ORGANIZATION_UNITS_TL'
PROMPT   'HR_ALL_POSITIONS_F'
PROMPT   'HR_ALL_POSITIONS_F_TL'
PROMPT   'HR_LOCATIONS_ALL'
PROMPT   'HR_LOCATIONS_ALL_TL'
PROMPT   'PER_ADDRESSES'
PROMPT   'PER_ALL_ASSIGNMENTS_F'
PROMPT   'PER_ALL_PEOPLE_F'
PROMPT   'PER_ALL_POSITIONS'
PROMPT   'PER_JOBS'
PROMPT   'PER_JOBS_TL'
PROMPT   'PER_PERIODS_OF_SERVICE'
PROMPT

REM PROMPT
      COLUMN owner          format a8  heading 'Owner'
      COLUMN trigger_name   format a31 heading 'Trigger Name'
      COLUMN table_name     format a30 heading 'Table Name'
      COLUMN status         format a8  heading 'Status'
      BREAK ON owner ON table_name
      select OWNER, 
             TABLE_NAME,
             TRIGGER_NAME, 
             STATUS 
      from all_triggers 
      where UPPER(table_name) in 
         ( 'PER_ALL_PEOPLE_F'
         , 'PER_ALL_ASSIGNMENTS_F'
         , 'PER_PERIODS_OF_SERVICE'
         , 'PER_PERSON_TYPE_USAGES_F'
         , 'PER_ADDRESSES'
         , 'HR_LOCATIONS_ALL'
         , 'HR_LOCATIONS_ALL_TL'
         , 'HR_ALL_ORGANIZATION_UNITS'
         , 'HR_ALL_ORGANIZATION_UNITS_TL'
         , 'HR_ALL_POSITIONS_F'
         , 'HR_ALL_POSITIONS_F_TL'
         , 'PER_ALL_POSITIONS'
         , 'PER_JOBS'
         , 'PER_JOBS_TL')
      and TRIGGER_NAME like '%WHO%' 
      order by table_name, trigger_name;



PROMPT
PROMPT
PROMPT
PROMPT  =========================================================================
PROMPT  CHECK FOR STATUS OF 'OVN' TRIGGERS for all HR and PER owned tables:
PROMPT  =========================================================================
PROMPT  
PROMPT  
PROMPT  

REM PROMPT
      COLUMN owner          format a8  heading 'Owner'
      COLUMN trigger_name   format a31 heading 'Trigger Name'
      COLUMN table_name     format a30 heading 'Table Name'
      COLUMN status         format a8  heading 'Status'
      BREAK ON owner ON table_name
      select OWNER, 
             TABLE_NAME,
             TRIGGER_NAME, 
             STATUS 
      from all_triggers 
      where OWNER = 'APPS'
      and trigger_name like 'HR%OVN%' 
      or  trigger_name like 'PER%OVN%'
      order by owner, table_name;



SET PAGESIZE 8000



PROMPT
PROMPT
PROMPT
PROMPT  =========================================================================
PROMPT  v$parameter settings for Instance Name = &v_sid
PROMPT  =========================================================================
PROMPT  
PROMPT  
PROMPT  


        COLUMN NAME       format a37    heading 'Name'
        COLUMN VALUE      format a62    heading 'Value'

        select NAME, VALUE 
        from   v$parameter
        order  by name;



SET PAGESIZE 50
SET PAGESIZE 8000



REM   =========================================================================
REM   BUSINESS GROUP output
REM   =========================================================================

      PROMPT
      PROMPT
      PROMPT
      PROMPT
      PROMPT Business Group Details (HR_ALL_ORGANIZATION_UNITS)
      PROMPT ====================================================
      PROMPT This section lists the Business Group details for each owning Organization
      PROMPT


      SET LINESIZE 130


      COLUMN BUSINESS_GROUP_ID  format 999999      heading 'BG_ID  '
      COLUMN ORGANIZATION_ID    format 999999      heading 'ORG_ID '
      COLUMN NAME               format a70         heading 'Organization Name'
      COLUMN LEGISLATION_CODE   format a2          heading 'LG'
      COLUMN CURRENCY_CODE      format a3          heading 'Cur'
      COLUMN ENABLED_FLAG       format a7          heading 'Enabled'
      COLUMN DATE_FROM          format a11         heading 'Date From'
      COLUMN DATE_TO            format a11         heading 'Date To'



      select haou.BUSINESS_GROUP_ID, 
             haou.ORGANIZATION_ID, 
             haou.NAME, 
             pbg.LEGISLATION_CODE, 
             pbg.CURRENCY_CODE, 
             pbg.ENABLED_FLAG, 
             pbg.DATE_FROM, 
             pbg.DATE_TO
      from HR_ALL_ORGANIZATION_UNITS haou, 
           PER_BUSINESS_GROUPS pbg
      where haou.ORGANIZATION_ID = haou.BUSINESS_GROUP_ID 
      and   pbg.ORGANIZATION_ID  = haou.ORGANIZATION_ID 
      order by haou.BUSINESS_GROUP_ID;



SET PAGESIZE 50
SET PAGESIZE 8000



      PROMPT
      PROMPT
      PROMPT
      PROMPT
      PROMPT Business Group sub-Organizations and Classification Details 
      PROMPT      (HR_ALL_ORGANIZATION_UNITS and HR_ORGANIZATION_INFORMATION_V)
      PROMPT ===========================================================================
      PROMPT This section lists the Business Groups and the attached sub-Organizations 
      PROMPT and their Classifications and Statuses
      PROMPT


      SET LINESIZE 130


      COLUMN bgid         format 999999    heading 'BG_ID  '
      COLUMN orgid        format 999999    heading 'ORG_ID '
      COLUMN name1        format a58       heading 'Organization Name'
      COLUMN orginf1      format a40       heading 'Organization Classifications'
      COLUMN orginf2      format a07       heading 'Enabled'


      BREAK ON bgid ON orgid ON name1


      select hou.BUSINESS_GROUP_ID bgid,
             hou.ORGANIZATION_ID orgid,
             hou.NAME name1,
             hoiv.ORG_INFORMATION1_MEANING orginf1,
             hoiv.ORG_INFORMATION2_MEANING orginf2
      from HR_ALL_ORGANIZATION_UNITS hou, 
           HR_ORGANIZATION_INFORMATION_V hoiv
      where hou.ORGANIZATION_ID = hoiv.ORGANIZATION_ID 
      and hoiv.ORG_INFORMATION1_MEANING IS NOT NULL 
      order by hou.BUSINESS_GROUP_ID, hou.ORGANIZATION_ID, hoiv.ORG_INFORMATION1_MEANING; 



SET PAGESIZE 50



PROMPT
PROMPT
PROMPT
PROMPT
REM   =========================================================================
REM   Display Test Footer
REM   =========================================================================

      COLUMN dateRun NEW_VALUE v_date NOPRINT
      SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') dateRun FROM DUAL;
      
      COLUMN elapsedTime NEW_VALUE v_time NOPRINT
      SELECT LTRIM(TO_CHAR(TO_NUMBER(TO_CHAR(SYSDATE,'SSSSS')) - &v_start)) elapsedTime FROM DUAL;
      
      PROMPT Summary of &v_fileName
      PROMPT ======================================================================
      PROMPT Date         = &v_date
      PROMPT Elapsed Time = &v_time seconds
      PROMPT
      PROMPT
      PROMPT For support issues, please log an iTar (Service Request).
      PROMPT
      PROMPT ======================================================================
      PROMPT ======================================================================
      PROMPT
      PROMPT
      PROMPT
      PROMPT instance &v_sid FORMS VERSION
      PROMPT =================================
      PROMPT



REM   =========================================================================
REM   Stop Spooling and Display Review Spool file message
REM   =========================================================================

REM   SET &v_setMarkupOff

      SPOOL OFF
      SET TERMOUT ON;
      
      PROMPT
      PROMPT =============================================================================
      PROMPT Please review the output file: &v_spoolFile
      PROMPT 
REM   PROMPT Please review the output file: HRMS121_output_file.txt
      PROMPT
      PROMPT =============================================================================
      PROMPT

REM   =========================================================================
REM   UNDEFINE Generic Test Variables used in all tests
REM   =========================================================================

      UNDEFINE            v_appVer
      UNDEFINE              v_char
      UNDEFINE            v_dbComp
      UNDEFINE             v_dbVer
      UNDEFINE          v_fileName
      UNDEFINE          v_HRStatus
      UNDEFINE   v_inputParameters
      UNDEFINE        v_lastUpdate
      UNDEFINE              v_lang
      UNDEFINE       v_legislation
      UNDEFINE         v_PayStatus

      UNDEFINE         v_PFbugDate1228
      UNDEFINE         v_PFbugDate1226
      UNDEFINE         v_PFbugDate1225
      UNDEFINE         v_PFbugDate1224
      UNDEFINE         v_PFbugDate1223
      UNDEFINE         v_PFbugDate1222
      UNDEFINE         v_PFbugDate1221
      UNDEFINE         v_PFbugDate122

      UNDEFINE         v_PFbugDate13599901
      UNDEFINE         v_PFbugDate14136272
      UNDEFINE         v_PFbugDate13614067
      UNDEFINE         v_PFbugDate13086596
      UNDEFINE         v_PFbugDate13357651
      UNDEFINE         v_PFbugDate13840088
      UNDEFINE         v_PFbugDate13547295
      UNDEFINE         v_PFbugDate13998818

      UNDEFINE         v_PFbugDate13929707


      UNDEFINE         v_PFbugDate18285981
      UNDEFINE         v_PFbugDate19132199
      UNDEFINE         v_PFbugDate19507770



      UNDEFINE         v_PFbugDate21664392
      UNDEFINE         v_PFbugDate21911111
      UNDEFINE         v_GeocodeDate2015



      UNDEFINE         v_PFbugDate19701971
      UNDEFINE         v_PFbugDate20212223
      UNDEFINE         v_PFbugDate20365000


      UNDEFINE         v_PFbugDate20212122
      UNDEFINE         v_PFbugDate20212120

      UNDEFINE         v_PFbugDate20259629
      UNDEFINE         v_PFbugDate20280156

      UNDEFINE          v_platform
      UNDEFINE           v_product
      UNDEFINE            v_server
REM   UNDEFINE      v_setMarkupOff
REM   UNDEFINE       v_setMarkupOn
      UNDEFINE              v_ssdt
      UNDEFINE               v_sid
      UNDEFINE            v_crtddt
REM   UNDEFINE         v_spoolFile
      UNDEFINE    v_sqlplusVersion
      UNDEFINE          v_testDate      
      UNDEFINE          v_testDesc
      UNDEFINE    v_testNoteNumber
      UNDEFINE          v_userName
      UNDEFINE v_validAppsVersions
      UNDEFINE         v_wfVersion
      UNDEFINE        v_ATGbugDate
      UNDEFINE        v_TXKbugDate
      UNDEFINE        v_ALRbugDate
      UNDEFINE        v_XDObugDate
      UNDEFINE        v_CACbugDate
      UNDEFINE        v_UMXbugDate
      UNDEFINE         v_AKbugDate
      UNDEFINE        v_JTAbugDate
      UNDEFINE         v_ECbugDate
      UNDEFINE      v_MultiORGflag
      UNDEFINE        v_FNDbugDate
      UNDEFINE         v_ADbugDate
      UNDEFINE         v_HZbugDate
      UNDEFINE        v_FINbugDate
      UNDEFINE        v_ADIbugDate
      UNDEFINE        v_IRCbugDate
      UNDEFINE         v_LDbugDate
      UNDEFINE        v_OLMbugDate
      UNDEFINE        v_FRMbugDate
      UNDEFINE        v_AMEbugDate
      UNDEFINE       v_GeocodeDate


      UNDEFINE   v_GeocodeDate2009
      UNDEFINE   v_GeocodeDate2010
      UNDEFINE   v_GeocodeDate2011
      UNDEFINE   v_GeocodeDate2012
      UNDEFINE   v_GeocodeDate2013
      UNDEFINE   v_GeocodeDate2014


      UNDEFINE   v_PFbugDate14740001
      UNDEFINE   v_PFbugDate16000001
      UNDEFINE   v_PFbugDate16000012
      UNDEFINE   v_PFbugDate15920839
      UNDEFINE   v_PFbugDate16039243
      UNDEFINE   v_PFbugDate14738406
      UNDEFINE   v_PFbugDate14571370
      UNDEFINE   v_PFbugDate14738406

      UNDEFINE   v_PFbugDate14776824
      UNDEFINE   v_PFbugDate16090553
      UNDEFINE   v_PFbugDate16035660


      UNDEFINE   v_PFbugDate18592015
      UNDEFINE   v_PFbugDate18864755





REM   =========================================================================
REM   Reset SQL PLUS Environment Variables
REM   =========================================================================

      SET FEEDBACK ON
      SET VERIFY   ON
      SET TIMING   ON
      SET ECHO     ON


REM   =========================================================================
REM   append frmbld to display instance FORMS VERSION
REM   =========================================================================


!frmbld \? | grep Forms | grep Version | awk '{print $6}' >> &v_spoolFile


EXIT