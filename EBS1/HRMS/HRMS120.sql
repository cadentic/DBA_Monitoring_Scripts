SET ECHO OFF
REM   =========================================================================
REM   Copyright © 2005 Oracle Corporation Redwood Shores, California, USA
REM   Oracle Support Services.  All rights reserved.
REM   =========================================================================
REM
DEFINE          v_fileName = 'HRMS120'
DEFINE        v_lastUpdate = '30-OCT-2015'
DEFINE          v_testDesc = 'Display HRMS R12 Details'
DEFINE    v_testNoteNumber = '453632.1'
DEFINE           v_product = 'Oracle HRMS'
DEFINE       v_legislation = 'All'
DEFINE          v_platform = 'Generic'
DEFINE v_validAppsVersions = '12.0'
DEFINE   v_inputParameters = 'None'
REM
REM   =========================================================================
REM   USAGE:   sqlplus apps/apps @HRMS120.sql
REM   =========================================================================
REM
REM   CHANGE HISTORY:
REM
REM    07-AUG-2007   jbressle  created
REM
REM    08-AUG-2007   jbressle  added the following:
REM                            HR R12 released HRMS family packs section
REM
REM    15-AUG-2007   jbressle  added the following:
REM                            hardcoded spooled output file name as HRMS12_output_file.txt 
REM                            to accommodate appending !frmbld to this file 
REM                            so as now to see the customer's FORMS VERSION in this output
REM
REM    10-OCT-2007   jbressle  added the following:
REM                            AME Approval Management Engine to OTHER current patching levels section
REM
REM    03-DEC-2007   jbressle  added the following:
REM                            fixed code for Date of last Succesfull Run of hrglobal.drv
REM
REM    18-JAN-2008   jbressle  added R12.HR_PF.A.delta.3 6196269 
REM                            to the R12 released HRMS family packs section
REM
REM    13-FEB-2008   jbressle  added product id 821 for iRec to Application Install Status section
REM                            added 6494646 R12.HR_PF.A.delta.4 to R12 HRMS family packs section
REM
REM    03-MAR-2008   jbressle  added 12.0.4 patching to scripts
REM
REM    07-MAR-2008   jbressle  added the following
REM                            added Language Details section showing Installed Languages
REM
REM    17-JUL-2008   jbressle  added the following:
REM                            R12.HR_PF.A.delta.5 patch 6610000
REM                            GEOCODE section for Address Validation
REM                            Instance Creation Date following Instance Name
REM                            changed output file naming convention to 
REM                                HRMS12_<SID>_<SYSDATE>.txt
REM
REM    22-JUL-2008   jbressle  added the following:
REM                            R12.IRC.A.delta.5 patch 6835790
REM                            R12.OTA.A.delta.5 patch 6835795
REM                            R12.ALR.A.delta.5 patch 6594741
REM                            R12.ALR.A.delta.6 patch 7237106
REM                            R12.XDO.A.delta.5 pacth 6594787
REM                            R12.XDO.A.delta.6 patch 7237308
REM                            R12.UMX.A.delta.5 patch 6594784
REM                            R12.UMX.A.delta.6 patch 7237243
REM                            R12.AK.A.delta.5  patch 6594738
REM                            R12.AK.A.delta.6  patch 7237094
REM                            R12.JTA.A.delta.5 pacth 6594777
REM                            R12.JTA.A.delta.6 patch 7237223
REM                            R12.EC.A.delta.5  patch 6594747
REM                            R12.EC.A.delta.6  patch 7237136
REM                            R12.FRM.A.delta.5 patch 6594779
REM                            R12.FRM.A.delta.6 patch 7237233
REM                            R12.AME.A.delta.5 patch 6835789
REM
REM    09-OCT-2008   jbressle  added ANNUAL GEOCODE/JIT UPDATE-2008 patch 7328291
REM
REM    19-NOV-2008   jbressle  added R12.HR_PF.A.delta.6 patch 7004477
REM                            added R12.OTA.A.delta.6   patch 7291412
REM                            added R12.IRC.A.delta.6   patch 7291408
REM                            added R12.PSP.A.delta.6   patch 7291411
REM
REM    23-FEB-2008   jbressle  added R12.AD.A.delta.5 patch 7305206
REM                            added R12.AD.A.delta.6 patch 7305220
REM
REM    20-APR-2009  jbressle  added R12.HR_PF.A.delta.7 7577660  planned release MAY 15, 2009
REM                           added OVN triggers to HRMS12 output
REM                           added WHO triggers to HRMS12 output
REM
REM    20-MAY-2009  jbressle  added Business Group Details section just before Language Details section
REM
REM    09-JUN-2009  jbressle  added 12.1+ patching levels for 
REM                           R12 HRMS family packs
REM                           R12 iRec patches
REM                           R12 Learning Management patches
REM                           R12 Labor Distribution psp patches
REM                           R12 ATG patching
REM                           R12 Techstack txk patches
REM                           R12 Alert alr patches
REM                           R12 XML Publisher xdo patches
REM                           R12 User Management umx patches
REM                           R12 Common Modules ak patches
REM                           R12 Common Application Calendar cac patching
REM                           R12 CRM applications Foundation jta
REM                           R12 E-Commerce Gateway ec patches
REM                           R12 Application Object Library fnd patches
REM                           R12 Applications DBA ad patches
REM                           R12 Report Manager frm patches
REM                           R12 Trading Community Architecture hz patches
REM                           R12 Financials fin_pf patches
REM                           R12 Web Applications Desktop Integrator bne patches
REM                           R12 Approval Management Engine ame patches
REM
REM    15-JUN-2009  jbressle  added Pay Action Parameter detail section
REM
REM    29-JUN-2009  jbressle  added Business Group and sub-Organization Classification Details
REM                           added v$parameter section at end of report
REM
REM    25-JUL-2009  jbressle  added Employee Numbering Details section covering the following:
REM                                 Global Numbering Profile details 
REM                                 Business Group Info. Org Developer DF details 
REM                                 NEXT_VALUE ordered by BUSINESS_GROUP_ID details 
REM                                 
REM    30-OCT-2009  jbressle  added 8977291:R12.PAY.A (12.0) ANNUAL GEOCODE UPDATE - 2009
REM                                 8977291:R12.PAY.B (12.1) ANNUAL GEOCODE UPDATE - 2009
REM
REM    26-JAN-2010  jbressle  added 8337373:R12.HR_PF.B.delta.2
REM
REM 
REM    09-FEB-2010  jbressle  added PROFILE settings section
REM                           added Legislation to Business Group Info. under Employee Numbering section
REM                           added Public Sector Budgeting to Application Install Status section
REM
REM    02-MAR-2010  jbressle  added Oracle General Ledger & Oracle Payroll to Application Install Status section
REM                           added Profile 'DateTrack:Enabled'
REM
REM    18-APR-2010  jbressle  added totals for Invalid Objects 
REM
REM    06-MAY-2010  jbressle  added Spatial Indexes and indexes related to Spatial Index issues section
REM                           added R12.HR_PF.A.DELTA.8 patch 9301208
REM
REM    17-JUN-2010  jbressle  added R12.HR_PF.B.delta.3 patch 9114911
REM
REM    08-JUL-2010  jbressle  removed DateTrack query for 804 SSP
REM
REM    28-AUG-2010  jbressle  added ANNUAL GEOCODE UPDATE - 2010  patches 
REM                           9879190:R12.PAY.A
REM                           9879190:R12.PAY.B
REM
REM    13-DEC-2010  jbressle  added the following patches
REM                           9349997  R12.IRC.A.delta.8 
REM                           9244274  R12.IRC.B.delta.3 
REM                           9350274  R12.OTA.A.delta.8 
REM                           9244281  R12.OTA.B.delta.3 
REM                           9350000  R12.PSP.A.delta.8 
REM                           9244279  R12.PSP.B.delta.3 
REM                           9386653  R12.TXK.A.delta.7 
REM                           8919489  R12.TXK.B.delta.3 
REM                           8919475  R12.ALR.B.delta.3 
REM                           8919488  R12.XDO.B.delta.3 
REM                           8919485  R12.UMX.B.delta.3 
REM                           8919474  R12.AK.B.delta.3 
REM                           9243944  R12.CAC.B.delta.3 
REM                           8919480  R12.JTA.B.delta.3 
REM                           8919479  R12.EC.B.delta.3 
REM                           8919473  R12.FND.B.delta.3 
REM                           8502056  R12.AD.B.delta.2 
REM                           9239089  R12.AD.B.delta.3 
REM                           8919484  R12.FRM.B.delta.3 
REM                           9249344  R12.HZ.B.delta.3 
REM                           9147733  R12.FIN_PF.B.delta.3 
REM                           8919478  R12.BNE.B.delta.3 
REM                           9349996  R12.AME.A.delta.8 
REM                           9244273  R12.AME.B.delta.3 
REM
REM    04-MAY-2011  jbressle  deleted section  R12 released HRMS family packs
REM                           added   section  R12.0+ released HRMS family packs -- 12.0 through 12.0.8
REM                           added   section  R12.1+ released HRMS family packs -- 12.1 through 12.1.3
REM
REM
REM
REM    08-MAY-2011  jbressle  split HRMS12.sql into HRMS120.sql (12.0+) and HRMS121.sql (12.1+)
REM
REM    25-JUL-2011  jbressle  added R12.HR_PF.A.DELTA.9 patch 10281209
REM
REM    16-AUG-2011  jbressle  added Geocode Upgrade Manager process section after GEOCODE patches section
REM                           added GEOCODE ANNUAL 2011 patch 12729901
REM
REM    14-FEB-2012  jbressle  added HR SECURITY PROFILE settings section 
REM                           HR: Security Profile
REM                           HR: Include Terminated People in Search
REM                           HR: Access Non-Current Employee Data
REM                           list defined HR Security profiles
REM
REM    14-FEB-2012  jbressle  hrglobal.drv details section changes
REM
REM    14-FEB-2012  jbressle  under Employee Numbering Details section added profiles 
REM                           HR:Use Global Applicant Numbering
REM                           HR:Use Global Contingent Worker Numbering
REM                           HR:Use Global Employee Numbering
REM
REM    09-APR-2012  jbressle  Business Group Details (HR_ALL_ORGANIZATION_UNITS) added Currency
REM
REM    03-AUG-2012  jbressle  added R12.HR_PF.A.delta.10 patch 13774477
REM                           added 12.0 Oracle Payroll Year End patching for 2012 section
REM
REM    12-AUG-2012  jbressle  added US HR 2012 Annual Geocode patch for Release 12.0.x - Patch 14281883 R12.PER.A
REM
REM    10-OCT-2012  jbressle  added US HR 2012 Annual Statutory Patch section
REM                           added Oracle HRMS Mandatory Patch List section
REM                           added LAD Add-on Localizations section
REM
REM    08-FEB-2013  jbressle  moved Language and Legislation sections to top at PAY team request
REM                           added PAYROLL 2012 year end phase 2 and phase 3 patches for US CA and MX
REM                           plus extra year end patch fixes 
REM
REM    05-JUL-2013  jbressle  added R12.HR_PF.A.delta.11 patch 16077077
REM                           added profile Enable Security Groups to the HR SECURITY PROFILE settings section
REM
REM    28-AUG-2013  jbressle  added R12.0.x - 17029535:R12.PAY.A  ANNUAL GEOCODE UPDATE - 2013
REM
REM    03-OCT-2013  jbressle  added Q3 2013: SQWL & JIT STATUTORY UPDATE FOR 120 patch 17365376
REM                           added US & CANADA END OF YEAR 2013 STATUTORY UPDATE I FOR R12.0 patch 17535555
REM                           added US HR 2013 Annual Statutory Patch Readme for Release 12.0.x patch 16713116
REM
REM    18-NOV-2013  jbressle  added UK Year End patching for 2013 section 
REM                           added YE13/14 REAL TIME INFORMATION CHANGES CONSOLIDATED FIXES - NOV - patch 17395845
REM
REM    24-DEC-2013  jbressle  added US & CANADA END OF YEAR 2013 STATUTORY UPDATE II  FOR R12.0 patch 17955555
REM
REM    28-JAN-2014  jbressle  added US & CANADA END OF YEAR 2013 STATUTORY UPDATE III FOR R12.0 patch 18075556
REM
REM    14-FEB-2014  jbressle  added YE13P1 120 MEXICO YEAREND - 2013 PHASE 1 patch 17941884
REM                           added iRec patches
REM                           added Labor Distribution patches
REM                           added Learning Management patches
REM
REM    01-JUL-2014  jbressle  added Q1 2014 SQWL and JIT STATUTORY UPDATE FOR 121 patch 18285981
REM                           added Q2 2014 SQWL and JIT STATUTORY UPDATE FOR 121 patch 19132199
REM                           added 12.0 Oracle Payroll US CA MX Year End patching for 2014 section
REM                           added profile 'External ADF Application URL' to PROFILE settings section
REM
REM    09-JAN-2015  jbressle  added Q3 2014 SQWL and JIT STATUTORY UPDATE FOR 121 patch 19507770
REM                           added US and CANADA END OF YEAR 2014 STATUTORY UPDATE I   FOR 121 patch 19701971
REM                           added US and CANADA END OF YEAR 2014 STATUTORY UPDATE II  FOR 121 patch 20212223
REM                           added US and Canadian Payroll Customers 2015 Year Begin FOR 120 patch 20212122
REM                           added Canadian HR Only Customers 2015 Year Begin FOR 120 patch 20212120
REM                           added 2014 Annual Geocode patch 19139617
REM
REM    27-JAN-2015  jbressle  added US and CANADA END OF YEAR 2014 STATUTORY UPDATE III FOR 120 patch 20365000
REM                           added profile 'HR:Defer Update After Approval' to PROFILE settings section 
REM                           removed 2012 Payroll Year End section 
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
REM    10-JUN-2015  jbressle  added Shared HR installed customers ONLY section
REM
REM    30-OCT-2015  jbressle  added International Payroll Details section
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
REM   R12.0+ HRMS family packs - 12.0 through 12.0.11
REM   =========================================================================





      COLUMN PFbugDate12011 NEW_VALUE v_PFbugDate12011 NOPRINT                    
      SELECT * FROM (
      SELECT 'Patch:' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '16077077', 'R12.HR_PF.A.delta.11')
          || ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate12011
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('16077077')
      ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1; 





      COLUMN PFbugDate12010 NEW_VALUE v_PFbugDate12010 NOPRINT                    
      SELECT * FROM (
      SELECT 'Patch:' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '13774477', 'R12.HR_PF.A.delta.10')
          || ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate12010
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('13774477')
      ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1; 





      COLUMN PFbugDate1209 NEW_VALUE v_PFbugDate1209 NOPRINT                    
      SELECT * FROM (
      SELECT 'Patch:' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '10281209', 'R12.HR_PF.A.delta.9')
          || ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate1209
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('10281209')
      ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1; 





      COLUMN PFbugDate1208 NEW_VALUE v_PFbugDate1208 NOPRINT                    
      SELECT * FROM (
      SELECT 'Patch:' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '9301208', 'R12.HR_PF.A.delta.8')
          || ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate1208
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('9301208')
      ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1; 





      COLUMN PFbugDate1207 NEW_VALUE v_PFbugDate1207 NOPRINT                    
      SELECT * FROM (
      SELECT 'Patch:' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '7577660', 'R12.HR_PF.A.delta.7')
          || ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate1207
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('7577660')
      ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1; 





      COLUMN PFbugDate1206 NEW_VALUE v_PFbugDate1206 NOPRINT                    
      SELECT * FROM (
      SELECT 'Patch:' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '7004477', 'R12.HR_PF.A.delta.6')
          || ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate1206
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('7004477')
      ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1; 





      COLUMN PFbugDate1205 NEW_VALUE v_PFbugDate1205 NOPRINT                    
      SELECT * FROM (
      SELECT 'Patch:' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '6610000', 'R12.HR_PF.A.delta.5')
          || ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate1205
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('6610000')
      ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1; 





      COLUMN PFbugDate1204 NEW_VALUE v_PFbugDate1204 NOPRINT                    
      SELECT * FROM (
      SELECT 'Patch:' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '6494646', 'R12.HR_PF.A.delta.4')
          || ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate1204
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('6494646')
      ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1; 





      COLUMN PFbugDate1203 NEW_VALUE v_PFbugDate1203 NOPRINT                    
      SELECT * FROM (
      SELECT 'Patch:' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '6196269', 'R12.HR_PF.A.delta.3')
          || ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate1203
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('6196269')
      ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1; 





      COLUMN PFbugDate1202 NEW_VALUE v_PFbugDate1202 NOPRINT                    
      SELECT * FROM (
      SELECT 'Patch:' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '5997278', 'R12.HR_PF.A.delta.2')
          || ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate1202
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('5997278')
      ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1; 





      COLUMN PFbugDate1201 NEW_VALUE v_PFbugDate1201 NOPRINT                    
      SELECT * FROM (
      SELECT 'Patch:' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '5881943', 'R12.HR_PF.A.delta.1')
          || ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate1201
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('5881943')
      ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1; 




      COLUMN PFbugDate120 NEW_VALUE v_PFbugDate120 NOPRINT                    
      SELECT * FROM (
      SELECT 'Patch:' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '4719824', 'R12.HR_PF.A')
          || ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate120
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('4719824')
      ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1; 








REM   =========================================================================
REM   12.0 Oracle Payroll Year End patching for 2012
REM   =========================================================================




REM   
REM   US and Canadian 2011 Year End Phase 3 patch 13599901
REM   

      COLUMN PFbugDate13599901 NEW_VALUE v_PFbugDate13599901 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate13599901
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('13599901')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 




REM   
REM   US and Canadian 2012 Q2 Statutory and JIT Update patch 14136272
REM   

      COLUMN PFbugDate14136272 NEW_VALUE v_PFbugDate14136272 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate14136272
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('14136272')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 




REM   
REM   US and Canadian CA Payroll RL2 FOOTNOTE Reporting changes patch 13614067
REM   

      COLUMN PFbugDate13614067 NEW_VALUE v_PFbugDate13614067 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate13614067
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('13614067')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 





REM   
REM   US and CANADA END OF YEAR 2012 STATUTORY UPDATE I FOR R12.0 patch 14740001
REM   

      COLUMN PFbugDate14740001 NEW_VALUE v_PFbugDate14740001 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate14740001
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('14740001')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 






REM   
REM   US and CANADA END OF YEAR 2012 STATUTORY UPDATE II FOR R12.0 patch 16000001
REM   

      COLUMN PFbugDate16000001 NEW_VALUE v_PFbugDate16000001 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate16000001
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('16000001')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 





REM   
REM   US and CANADA END OF YEAR 2012 STATUTORY UPDATE III FOR R12.0 patch 16000012
REM   

      COLUMN PFbugDate16000012 NEW_VALUE v_PFbugDate16000012 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate16000012
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('16000012')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 





REM   
REM   YE12 120 NOV 2012 MINIMUM WAGE UPDATES patch 15920839
REM   

      COLUMN PFbugDate15920839 NEW_VALUE v_PFbugDate15920839 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate15920839
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('15920839')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 






REM   
REM   120 GETTING WRONG VALUES WITH SS QUOTA PRORATED WHEN SENIORITY CHANGES patch 16039243
REM   

      COLUMN PFbugDate16039243 NEW_VALUE v_PFbugDate16039243 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate16039243
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('16039243')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 






REM   
REM   R120 GROSS WAGES 0.00 FOR STATE and LOCAL AFTER YEP1 2012 ON ENH WAGE ACCUM patch 14738406
REM   

      COLUMN PFbugDate14738406 NEW_VALUE v_PFbugDate14738406 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate14738406
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('14738406')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 






REM   
REM   Q3 2012 SQWL and JIT STATUTORY UPDATE FOR 120 patch 14571370
REM   

      COLUMN PFbugDate14571370 NEW_VALUE v_PFbugDate14571370 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate14571370
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('14571370')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 







REM   
REM   GROSS WAGES 0.00 FOR STATE and LOCAL AFTER YEP1 2012 ON ENH WAGE ACCUM patch 14738406
REM   

      COLUMN PFbugDate14738406 NEW_VALUE v_PFbugDate14738406 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate14738406
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('14738406')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 






REM   
REM   TAX WIHHELD IS NOT CORRECT IN PAYROLL RUN TYPE PERIODIC TAX ADJUSTMENT patch 13998818
REM   

      COLUMN PFbugDate13998818 NEW_VALUE v_PFbugDate13998818 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate13998818
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('13998818')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 




REM   
REM   Mexico 2011 Year End Phase 1 patch 13086596
REM   

      COLUMN PFbugDate13086596 NEW_VALUE v_PFbugDate13086596 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate13086596
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('13086596')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 




REM   
REM   Mexico 2012 Year Begin patch 13357651
REM   

      COLUMN PFbugDate13357651 NEW_VALUE v_PFbugDate13357651 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate13357651
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('13357651')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 




REM   
REM   Mexico COAHUILA STATE TAX UPDATES patch 13840088
REM   

      COLUMN PFbugDate13840088 NEW_VALUE v_PFbugDate13840088 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate13840088
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('13840088')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 




REM   
REM   Mexico MEX FORMAT 37 DISCREPANCY IN CONFIGURING SOME BOXES patch 13547295
REM   

      COLUMN PFbugDate13547295 NEW_VALUE v_PFbugDate13547295 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate13547295
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('13547295')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 





REM   
REM   YE12P1 120 MEXICO YEAR END - 2012 PHASE 1 patch 14776824
REM   

      COLUMN PFbugDate14776824 NEW_VALUE v_PFbugDate14776824 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate14776824
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('14776824')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 






REM   
REM   YE12P2 120 MEXICO YEAR END - 2012 PHASE 2 patch 16090553
REM   

      COLUMN PFbugDate16090553 NEW_VALUE v_PFbugDate16090553 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate16090553
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('16090553')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 





REM   
REM   120 MEXICO YEAR BEGIN - 2013 patch 16035660
REM   

      COLUMN PFbugDate16035660 NEW_VALUE v_PFbugDate16035660 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate16035660
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('16035660')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 








REM   =========================================================================
REM   12.0 Oracle Payroll Year End  US CA MX patching for 2013
REM   =========================================================================



REM   
REM   Q3 2013: SQWL & JIT STATUTORY UPDATE FOR 120 patch 17365376
REM   

      COLUMN PFbugDate17365376 NEW_VALUE v_PFbugDate17365376 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate17365376
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('17365376')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 





REM   
REM   US & CANADA END OF YEAR 2013 STATUTORY UPDATE I FOR R12.0 patch 17535555
REM   

      COLUMN PFbugDate17535555 NEW_VALUE v_PFbugDate17535555 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate17535555
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('17535555')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 






REM   
REM   US & CANADA END OF YEAR 2013 STATUTORY UPDATE II FOR R12.0 patch 17955555
REM   

      COLUMN PFbugDate17955555 NEW_VALUE v_PFbugDate17955555 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate17955555
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('17955555')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 





REM   
REM   US & CANADA END OF YEAR 2013 STATUTORY UPDATE III FOR R12.0 patch 18075556
REM   

      COLUMN PFbugDate18075556 NEW_VALUE v_PFbugDate18075556 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate18075556
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('18075556')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 





REM   
REM   YE13P1 120 MEXICO YEAREND - 2013 PHASE 1 patch 17941884
REM   

      COLUMN PFbugDate17941884 NEW_VALUE v_PFbugDate17941884 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate17941884
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('17941884')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 







REM   =========================================================================
REM   12.0 Oracle Payroll US CA MX Year End patching for 2014
REM   =========================================================================



REM   
REM   Q1 2014: SQWL & JIT STATUTORY UPDATE FOR 120 patch 18285981
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
REM   Q2 2014: SQWL & JIT STATUTORY UPDATE FOR 120 patch 19132199
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
REM   Q3 2014: SQWL & JIT STATUTORY UPDATE FOR 120 patch 19507770
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
REM   US & CANADA END OF YEAR 2014 STATUTORY UPDATE I FOR R120 patch 19701971
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
REM   US & CANADA END OF YEAR 2014 STATUTORY UPDATE II FOR R120 patch 20212223
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
REM   US & CANADA END OF YEAR 2014 STATUTORY UPDATE III FOR R120 patch 20365000
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
REM   MEXICO YEAR END 2014 PHASE I FOR R12.0 patch 20259629
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
REM   120 MEXICO YEAR BEGIN - 2015 patch 20280156
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
REM   12.0 Oracle Payroll UK Year End patching for 2013
REM   =========================================================================



REM   
REM   YE13/14 REAL TIME INFORMATION CHANGES CONSOLIDATED FIXES - NOV - patch 17395845
REM   

      COLUMN PFbugDate17395845 NEW_VALUE v_PFbugDate17395845 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate17395845
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('17395845')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 









REM   =========================================================================
REM   12.0 US HR 2012 Annual Statutory Patch 
REM   =========================================================================




REM   
REM   12.0 US HR 2012 Annual Statutory Patch
REM   

      COLUMN PFbugDate13929707 NEW_VALUE v_PFbugDate13929707 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate13929707
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('13929707')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 







REM   =========================================================================
REM   12.0 US HR 2013 Annual Statutory Patch 
REM   =========================================================================

REM   
REM   12.0 US HR 2013 Annual Statutory Patch
REM   

      COLUMN PFbugDate16713116 NEW_VALUE v_PFbugDate16713116 NOPRINT                    
      SELECT * FROM (
      SELECT ' applied ' || LAST_UPDATE_DATE || ' '   PFbugDate16713116
      FROM ad_bugs 
      WHERE BUG_NUMBER IN   
          ('16713116')
      ORDER BY BUG_NUMBER desc
      ) WHERE ROWNUM = 1; 






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


REM      COLUMN IRCbugDate NEW_VALUE v_IRCbugDate NOPRINT    
REM      SELECT * FROM (
REM             SELECT 'iRec patch: ' || '  ' || bug_number || ' - ' ||
REM             DECODE(BUG_NUMBER
REM             , '5348577', 'R12.IRC.A'
REM             , '5889675', 'R12.IRC.A.delta.1'
REM             , '5997243', 'R12.IRC.A.delta.2'
REM             , '6196261', 'R12.IRC.A.delta.3'
REM             , '6506488', 'R12.IRC.A.delta.4'
REM             , '6835790', 'R12.IRC.A.delta.5'
REM             , '7291412', 'R12.IRC.A.delta.6'
REM             , '7644755', 'R12.IRC.A.delta.7'
REM             , '9349997', 'R12.IRC.A.delta.8'
REM             , '12424333', 'R12.IRC.A.delta.9'
REM             , '13955168', 'R12.IRC.A.delta.10'
REM             , '16664306', 'R12.IRC.A.delta.11')
REM             || ' applied ' || LAST_UPDATE_DATE || ' ' IRCbugDate
REM         FROM ad_bugs 
REM         WHERE BUG_NUMBER IN 
REM             ('5348577','5889675','5997243','6196261','6506488','6835790','7291412','7644755','9349997','12424333','13955168','16664306')
REM         ORDER BY BUG_NUMBER desc ) 
REM      WHERE ROWNUM = 1;






      COLUMN IRCbugDate NEW_VALUE v_IRCbugDate NOPRINT    
      SELECT * FROM (
             SELECT 'iRec patch: ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '5348577', 'R12.IRC.A')
             || ' applied ' || LAST_UPDATE_DATE || ' ' IRCbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('5348577')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;



      COLUMN IRCbugDate1 NEW_VALUE v_IRCbugDate1 NOPRINT    
      SELECT * FROM (
             SELECT 'iRec patch: ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '5889675', 'R12.IRC.A.delta.1')
             || ' applied ' || LAST_UPDATE_DATE || ' ' IRCbugDate1
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('5889675')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;



      COLUMN IRCbugDate2 NEW_VALUE v_IRCbugDate2 NOPRINT    
      SELECT * FROM (
             SELECT 'iRec patch: ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '5997243', 'R12.IRC.A.delta.2')
             || ' applied ' || LAST_UPDATE_DATE || ' ' IRCbugDate2
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('5997243')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;



      COLUMN IRCbugDate3 NEW_VALUE v_IRCbugDate3 NOPRINT    
      SELECT * FROM (
             SELECT 'iRec patch: ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '6196261', 'R12.IRC.A.delta.3')
             || ' applied ' || LAST_UPDATE_DATE || ' ' IRCbugDate3
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('6196261')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;



      COLUMN IRCbugDate4 NEW_VALUE v_IRCbugDate4 NOPRINT    
      SELECT * FROM (
             SELECT 'iRec patch: ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '6506488', 'R12.IRC.A.delta.4')
             || ' applied ' || LAST_UPDATE_DATE || ' ' IRCbugDate4
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('6506488')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;



      COLUMN IRCbugDate5 NEW_VALUE v_IRCbugDate5 NOPRINT    
      SELECT * FROM (
             SELECT 'iRec patch: ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '6835790', 'R12.IRC.A.delta.5')
             || ' applied ' || LAST_UPDATE_DATE || ' ' IRCbugDate5
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('6835790')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;



      COLUMN IRCbugDate6 NEW_VALUE v_IRCbugDate6 NOPRINT    
      SELECT * FROM (
             SELECT 'iRec patch: ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '7291412', 'R12.IRC.A.delta.6')
             || ' applied ' || LAST_UPDATE_DATE || ' ' IRCbugDate6
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('7291412')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;



      COLUMN IRCbugDate7 NEW_VALUE v_IRCbugDate7 NOPRINT    
      SELECT * FROM (
             SELECT 'iRec patch: ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '7644755', 'R12.IRC.A.delta.7')
             || ' applied ' || LAST_UPDATE_DATE || ' ' IRCbugDate7
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('7644755')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;




      COLUMN IRCbugDate8 NEW_VALUE v_IRCbugDate8 NOPRINT    
      SELECT * FROM (
             SELECT 'iRec patch: ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '9349997', 'R12.IRC.A.delta.8')
             || ' applied ' || LAST_UPDATE_DATE || ' ' IRCbugDate8
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('9349997')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;



      COLUMN IRCbugDate9 NEW_VALUE v_IRCbugDate9 NOPRINT    
      SELECT * FROM (
             SELECT 'iRec patch: ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '12424333', 'R12.IRC.A.delta.9')
             || ' applied ' || LAST_UPDATE_DATE || ' ' IRCbugDate9
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('12424333')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;



      COLUMN IRCbugDate10 NEW_VALUE v_IRCbugDate10 NOPRINT    
      SELECT * FROM (
             SELECT 'iRec patch: ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '13955168', 'R12.IRC.A.delta.10')
             || ' applied ' || LAST_UPDATE_DATE || ' ' IRCbugDate10
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('13955168')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;



      COLUMN IRCbugDate11 NEW_VALUE v_IRCbugDate11 NOPRINT    
      SELECT * FROM (
             SELECT 'iRec patch: ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '16664306', 'R12.IRC.A.delta.11')
             || ' applied ' || LAST_UPDATE_DATE || ' ' IRCbugDate11
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('16664306')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;







REM   =========================================================================
REM   R12 Learning Management patches
REM   =========================================================================

REM      COLUMN OLMbugDate NEW_VALUE v_OLMbugDate NOPRINT    
REM      SELECT * FROM (
REM             SELECT 'Learning Management:' || '  ' || bug_number || ' - ' ||
REM             DECODE(BUG_NUMBER
REM             , '5348582', 'R12.OTA.A'
REM             , '5889686', 'R12.OTA.A.delta.1'
REM             , '5997248', 'R12.OTA.A.delta.2'
REM             , '6196267', 'R12.OTA.A.delta.3'
REM             , '6506492', 'R12.OTA.A.delta.4'
REM             , '6835795', 'R12.OTA.A.delta.5'
REM             , '7291412', 'R12.OTA.A.delta.6'
REM             , '7644783', 'R12.OTA.A.delta.7'
REM             , '9350274', 'R12.OTA.A.delta.8'
REM             , '12424345', 'R12.OTA.A.delta.9'
REM             , '13955174', 'R12.OTA.A.delta.10'
REM             , '16664311', 'R12.OTA.A.delta.11')
REM             || ' applied ' || LAST_UPDATE_DATE || ' ' OLMbugDate
REM         FROM ad_bugs 
REM         WHERE BUG_NUMBER IN 
REM             ('5348582','5889686','5997248','6196267','6506492','6835795','7291412','7644783','9350274','12424345','13955174','16664311')
REM         ORDER BY BUG_NUMBER desc ) 
REM      WHERE ROWNUM = 1;





COLUMN OLMbugDate NEW_VALUE v_OLMbugDate NOPRINT    
      SELECT * FROM (
             SELECT 'Learning Management:' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '5348582', 'R12.OTA.A')
             || ' applied ' || LAST_UPDATE_DATE || ' ' OLMbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('5348582')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;



COLUMN OLMbugDate1 NEW_VALUE v_OLMbugDate1 NOPRINT    
      SELECT * FROM (
             SELECT 'Learning Management:' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '5889686', 'R12.OTA.A.delta.1')
             || ' applied ' || LAST_UPDATE_DATE || ' ' OLMbugDate1
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('5889686')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;



COLUMN OLMbugDate2 NEW_VALUE v_OLMbugDate2 NOPRINT    
      SELECT * FROM (
             SELECT 'Learning Management:' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '5997248', 'R12.OTA.A.delta.2')
             || ' applied ' || LAST_UPDATE_DATE || ' ' OLMbugDate2
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('5997248')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;



COLUMN OLMbugDate3 NEW_VALUE v_OLMbugDate3 NOPRINT    
      SELECT * FROM (
             SELECT 'Learning Management:' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '6196267', 'R12.OTA.A.delta.3')
             || ' applied ' || LAST_UPDATE_DATE || ' ' OLMbugDate3
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('6196267')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;



COLUMN OLMbugDate4 NEW_VALUE v_OLMbugDate4 NOPRINT    
      SELECT * FROM (
             SELECT 'Learning Management:' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '6506492', 'R12.OTA.A.delta.4')
             || ' applied ' || LAST_UPDATE_DATE || ' ' OLMbugDate4
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('6506492')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;



COLUMN OLMbugDate5 NEW_VALUE v_OLMbugDate5 NOPRINT    
      SELECT * FROM (
             SELECT 'Learning Management:' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '6835795', 'R12.OTA.A.delta.5')
             || ' applied ' || LAST_UPDATE_DATE || ' ' OLMbugDate5
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('6835795')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;



COLUMN OLMbugDate6 NEW_VALUE v_OLMbugDate6 NOPRINT    
      SELECT * FROM (
             SELECT 'Learning Management:' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '7291412', 'R12.OTA.A.delta.6')
             || ' applied ' || LAST_UPDATE_DATE || ' ' OLMbugDate6
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('7291412')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;



COLUMN OLMbugDate7 NEW_VALUE v_OLMbugDate7 NOPRINT    
      SELECT * FROM (
             SELECT 'Learning Management:' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '7644783', 'R12.OTA.A.delta.7')
             || ' applied ' || LAST_UPDATE_DATE || ' ' OLMbugDate7
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('7644783')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;




COLUMN OLMbugDate8 NEW_VALUE v_OLMbugDate8 NOPRINT    
      SELECT * FROM (
             SELECT 'Learning Management:' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '9350274', 'R12.OTA.A.delta.8')
             || ' applied ' || LAST_UPDATE_DATE || ' ' OLMbugDate8
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('9350274')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;



COLUMN OLMbugDate9 NEW_VALUE v_OLMbugDate9 NOPRINT    
      SELECT * FROM (
             SELECT 'Learning Management:' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '12424345', 'R12.OTA.A.delta.9')
             || ' applied ' || LAST_UPDATE_DATE || ' ' OLMbugDate9
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('12424345')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;



COLUMN OLMbugDate10 NEW_VALUE v_OLMbugDate10 NOPRINT    
      SELECT * FROM (
             SELECT 'Learning Management:' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '13955174', 'R12.OTA.A.delta.10')
             || ' applied ' || LAST_UPDATE_DATE || ' ' OLMbugDate10
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('13955174')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;



COLUMN OLMbugDate11 NEW_VALUE v_OLMbugDate11 NOPRINT    
      SELECT * FROM (
             SELECT 'Learning Management:' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '16664311', 'R12.OTA.A.delta.11')
             || ' applied ' || LAST_UPDATE_DATE || ' ' OLMbugDate11
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('16664311')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;








REM   =========================================================================
REM   R12 Labor Distribution psp patches
REM   =========================================================================

REM      COLUMN LDbugDate NEW_VALUE v_LDbugDate NOPRINT    
REM      SELECT * FROM (
REM             SELECT 'Labor Distribution: ' || '  ' || bug_number || ' - ' ||
REM             DECODE(BUG_NUMBER
REM             , '5348607', 'R12.PSP.A'
REM             , '5889704', 'R12.PSP.A.delta.1'
REM             , '5997266', 'R12.PSP.A.delta.2'
REM             , '6196266', 'R12.PSP.A.delta.3'
REM             , '6506493', 'R12.PSP.A.delta.4'
REM             , '6835794', 'R12.PSP.A.delta.5'
REM             , '7291411', 'R12.PSP.A.delta.6'
REM             , '7644760', 'R12.PSP.A.delta.7'
REM             , '9350000', 'R12.PSP.A.delta.8'
REM             , '12424339', 'R12.PSP.A.delta.9'
REM             , '13955173', 'R12.PSP.A.delta.10'
REM             , '16664309', 'R12.PSP.A.delta.11')
REM             || ' applied ' || LAST_UPDATE_DATE || ' ' LDbugDate
REM         FROM ad_bugs 
REM         WHERE BUG_NUMBER IN 
REM             ('5348607','5889704','5997266','6196266','6506493','6835794','7291411','7644760','9350000','12424339','13955173','16664309')
REM         ORDER BY BUG_NUMBER desc ) 
REM      WHERE ROWNUM = 1;







      COLUMN LDbugDate NEW_VALUE v_LDbugDate NOPRINT    
      SELECT * FROM (
             SELECT 'Labor Distribution: ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '5348607', 'R12.PSP.A')
             || ' applied ' || LAST_UPDATE_DATE || ' ' LDbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('5348607')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;



      COLUMN LDbugDate1 NEW_VALUE v_LDbugDate1 NOPRINT    
      SELECT * FROM (
             SELECT 'Labor Distribution: ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '5889704', 'R12.PSP.A.delta.1')
             || ' applied ' || LAST_UPDATE_DATE || ' ' LDbugDate1
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('5889704')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;



      COLUMN LDbugDate2 NEW_VALUE v_LDbugDate2 NOPRINT    
      SELECT * FROM (
             SELECT 'Labor Distribution: ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '5997266', 'R12.PSP.A.delta.2')
             || ' applied ' || LAST_UPDATE_DATE || ' ' LDbugDate2
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('5997266')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;



      COLUMN LDbugDate3 NEW_VALUE v_LDbugDate3 NOPRINT    
      SELECT * FROM (
             SELECT 'Labor Distribution: ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '6196266', 'R12.PSP.A.delta.3')
             || ' applied ' || LAST_UPDATE_DATE || ' ' LDbugDate3
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('6196266')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;



      COLUMN LDbugDate4 NEW_VALUE v_LDbugDate4 NOPRINT    
      SELECT * FROM (
             SELECT 'Labor Distribution: ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '6506493', 'R12.PSP.A.delta.4')
             || ' applied ' || LAST_UPDATE_DATE || ' ' LDbugDate4
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('6506493')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;



      COLUMN LDbugDate5 NEW_VALUE v_LDbugDate5 NOPRINT    
      SELECT * FROM (
             SELECT 'Labor Distribution: ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '6835794', 'R12.PSP.A.delta.5')
             || ' applied ' || LAST_UPDATE_DATE || ' ' LDbugDate5
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('6835794')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;



      COLUMN LDbugDate6 NEW_VALUE v_LDbugDate6 NOPRINT    
      SELECT * FROM (
             SELECT 'Labor Distribution: ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '7291411', 'R12.PSP.A.delta.6')
             || ' applied ' || LAST_UPDATE_DATE || ' ' LDbugDate6
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('7291411')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;



      COLUMN LDbugDate7 NEW_VALUE v_LDbugDate7 NOPRINT    
      SELECT * FROM (
             SELECT 'Labor Distribution: ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '7644760', 'R12.PSP.A.delta.7')
             || ' applied ' || LAST_UPDATE_DATE || ' ' LDbugDate7
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('7644760')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;



      COLUMN LDbugDate8 NEW_VALUE v_LDbugDate8 NOPRINT    
      SELECT * FROM (
             SELECT 'Labor Distribution: ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '9350000', 'R12.PSP.A.delta.8')
             || ' applied ' || LAST_UPDATE_DATE || ' ' LDbugDate8
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('9350000')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;



      COLUMN LDbugDate9 NEW_VALUE v_LDbugDate9 NOPRINT    
      SELECT * FROM (
             SELECT 'Labor Distribution: ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '12424339', 'R12.PSP.A.delta.9')
             || ' applied ' || LAST_UPDATE_DATE || ' ' LDbugDate9
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('12424339')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;



      COLUMN LDbugDate10 NEW_VALUE v_LDbugDate10 NOPRINT    
      SELECT * FROM (
             SELECT 'Labor Distribution: ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '13955173', 'R12.PSP.A.delta.10')
             || ' applied ' || LAST_UPDATE_DATE || ' ' LDbugDate10
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('13955173')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;



      COLUMN LDbugDate11 NEW_VALUE v_LDbugDate11 NOPRINT    
      SELECT * FROM (
             SELECT 'Labor Distribution: ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '16664309', 'R12.PSP.A.delta.11')
             || ' applied ' || LAST_UPDATE_DATE || ' ' LDbugDate11
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('16664309')
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
             , '4461237', 'R12.ATG_PF.A'
             , '5907545', 'R12.ATG_PF.A.delta.1'
             , '5917344', 'R12.ATG_PF.A.delta.2'
             , '6077669', 'R12.ATG_PF.A.delta.3'
             , '6272680', 'R12.ATG_PF.A.delta.4'
             , '6594849', 'R12.ATG_PF.A.delta.5'
             , '7237006', 'R12.ATG_PF.A.delta.6')
             || ' applied ' || LAST_UPDATE_DATE || ' 'ATGbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
         ('4461237','5907545','5917344','6077669','6272680','6594849','7237006')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;





REM   =========================================================================
REM   R12 Techstack txk patches
REM   =========================================================================

      COLUMN TXKbugDate NEW_VALUE v_TXKbugDate NOPRINT                    
      SELECT * FROM (
             SELECT 'Techstack patch:                   ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '4494373', 'R12.TXK.A'
             , '5909746', 'R12.TXK.A.delta.1'
             , '5917601', 'R12.TXK.A.delta.2'
             , '6077487', 'R12.TXK.A.delta.3'
             , '6329757', 'R12.TXK.A.delta.4'
             , '6594792', 'R12.TXK.A.delta.5'
             , '7237313', 'R12.TXK.A.delta.6'
             , '9386653', 'R12.TXK.A.delta.7')
             || ' applied ' || LAST_UPDATE_DATE || ' ' TXKbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('4494373','5909746','5917601','6077487','6329757','6594792','7237313','9386653')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;





REM   =========================================================================
REM   R12 Alert alr patches
REM   =========================================================================

      COLUMN ALRbugDate NEW_VALUE v_ALRbugDate NOPRINT    
      SELECT * FROM (
             SELECT 'Alerts patch:                      ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '4496584', 'R12.ALR.A'
             , '5907552', 'R12.ALR.A.delta.1'
             , '5917314', 'R12.ALR.A.delta.2'
             , '6077418', 'R12.ALR.A.delta.3'
             , '6354126', 'R12.ALR.A.delta.4'
             , '6594741', 'R12.ALR.A.delta.5'
             , '7237106', 'R12.ALR.A.delta.6')
             || ' applied ' || LAST_UPDATE_DATE || ' ' ALRbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('4496584','5907552','5917314','6077418','6354126','6594741','7237106')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;






REM   =========================================================================
REM   R12 XML Publisher xdo patches
REM   =========================================================================

      COLUMN XDObugDate NEW_VALUE v_XDObugDate NOPRINT                    
      SELECT * FROM (
             SELECT 'XML Publisher patch:               ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '4495174', 'R12.XDO.A'
             , '5907579', 'R12.XDO.A.delta.1'
             , '5917336', 'R12.XDO.A.delta.2'
             , '6077632', 'R12.XDO.A.delta.3'
             , '6354146', 'R12.XDO.A.delta.4'
             , '6594787', 'R12.XDO.A.delta.5'
             , '7237308', 'R12.XDO.A.delta.6')
             || ' applied ' || LAST_UPDATE_DATE || ' ' XDObugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('4495174','5907579','5917336','6077632','6354146','6594787','7237308')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;






REM   =========================================================================
REM   R12 User Management umx patches
REM   =========================================================================

      COLUMN UMXbugDate NEW_VALUE v_UMXbugDate NOPRINT                    
      SELECT * FROM (
             SELECT 'User Management patch:             ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '4495281', 'R12.UMX.A'
             , '5907564', 'R12.UMX.A.delta.1'
             , '5917323', 'R12.UMX.A.delta.2'
             , '6077616', 'R12.UMX.A.delta.3'
             , '6354143', 'R12.UMX.A.delta.4'
             , '6594784', 'R12.UMX.A.delta.5'
             , '7237243', 'R12.UMX.A.delta.6')
             || ' applied ' || LAST_UPDATE_DATE || ' ' UMXbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('4495281','5907564','5917323','6077616','6354143','6594784','7237243')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;






REM   =========================================================================
REM   R12 Common Modules ak patches
REM   =========================================================================

      COLUMN AKbugDate NEW_VALUE v_AKbugDate NOPRINT    
      SELECT * FROM (
             SELECT 'AK Common Modules patch:           ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '4496642', 'R12.AK.A'
             , '5907546', 'R12.AK.A.delta.1'
             , '5917306', 'R12.AK.A.delta.2'
             , '6077390', 'R12.AK.A.delta.3'
             , '6354123', 'R12.AK.A.delta.4'
             , '6594738', 'R12.AK.A.delta.5'
             , '7237094', 'R12.AK.A.delta.6')
             || ' applied ' || LAST_UPDATE_DATE || ' ' AKbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('4496642','5907546','5917306','6077390','6354123''6594738','7237094')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;






REM   =========================================================================
REM   R12 Common Application Calendar cac patching
REM   =========================================================================

      COLUMN CACbugDate NEW_VALUE v_CACbugDate NOPRINT                    
      SELECT * FROM (
             SELECT 'Common Application Calendar patch: ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '4462883', 'R12.CAC.A'
             , '5884322', 'R12.CAC.A.delta.1'
             , '6000253', 'R12.CAC.A.delta.2'
             , '6262228', 'R12.CAC.A.delta.3'
             , '6496853', 'R12.CAC.A.delta.4'
             , '7300404', 'R12.CAC.A.delta.5'
             , '7303904', 'R12.CAC.A.delta.6')
             || ' applied ' || LAST_UPDATE_DATE || ' ' CACbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('4462883','5884322','6000253','6262228','6496853','7300404','7303904')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;






REM   =========================================================================
REM   R12 CRM applications Foundation jta
REM   =========================================================================

      COLUMN JTAbugDate NEW_VALUE v_JTAbugDate NOPRINT    
      SELECT * FROM (
             SELECT 'CRM Applications Foundation patch: ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '4497250', 'R12.JTA.A'
             , '5907573', 'R12.JTA.A.delta.1'
             , '5917330', 'R12.JTA.A.delta.2'
             , '6077589', 'R12.JTA.A.delta.3'
             , '6354137', 'R12.JTA.A.delta.4'
             , '6594777', 'R12.JTA.A.delta.5'
             , '7237223', 'R12.JTA.A.delta.6')
             || ' applied ' || LAST_UPDATE_DATE || ' ' JTAbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('4497250','5907573','5917330','6077589','6354137','6594777','7237223')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;





REM   =========================================================================
REM   R12 E-Commerce Gateway ec patches
REM   =========================================================================

      COLUMN ECbugDate NEW_VALUE v_ECbugDate NOPRINT    
      SELECT * FROM (
             SELECT 'E-Commerce Gateway patch:          ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '4496609', 'R12.EC.A'
             , '5907563', 'R12.EC.A.delta.1'
             , '5917321', 'R12.EC.A.delta.2'
             , '6077463', 'R12.EC.A.delta.3'
             , '6354135', 'R12.EC.A.delta.4'
             , '6594747', 'R12.EC.A.delta.5'
             , '7237136', 'R12.EC.A.delta.6')
             || ' applied ' || LAST_UPDATE_DATE || ' ' ECbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN  
             ('4496609','5907563','5917321','6077463','6354135','6594747','7237136')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;





REM   =========================================================================
REM   R12 Application Object Library fnd patches
REM   =========================================================================

      COLUMN FNDbugDate NEW_VALUE v_FNDbugDate NOPRINT    
      SELECT * FROM (
             SELECT 'Application Object Library patch:  ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '4494236', 'R12.FND.A'
             , '5907547', 'R12.FND.A.delta.1'
             , '5917310', 'R12.FND.A.delta.2'
             , '6077562', 'R12.FND.A.delta.3'
             , '6272353', 'R12.FND.A.delta.4'
             , '6594756', 'R12.FND.A.delta.5'
             , '7237143', 'R12.FND.A.delta.6')
             || ' applied ' || LAST_UPDATE_DATE || ' ' FNDbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('4494236','5907547','5917310','6077562','6272353','6594756','7237143')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;






REM   =========================================================================
REM   R12 Applications DBA ad patches
REM   =========================================================================

      COLUMN ADbugDate NEW_VALUE v_ADbugDate NOPRINT    
      SELECT * FROM (
             SELECT 'Applications DBA patch:            ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '4502962', 'R12.AD.A'
             , '5905728', 'R12.AD.A.delta.1'
             , '6014659', 'R12.AD.A.delta.2'
             , '6272715', 'R12.AD.A.delta.3'
             , '6510214', 'R12.AD.A.delta.4'
             , '7305206', 'R12.AD.A.delta.5'
             , '7305220', 'R12.AD.A.delta.6')
             || ' applied ' || LAST_UPDATE_DATE || ' ' ADbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('4502962','5905728','6014659','6272715','6510214','7305206','7305220')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;






REM   =========================================================================
REM   R12 Report Manager frm patches
REM   =========================================================================

      COLUMN FRMbugDate NEW_VALUE v_FRMbugDate NOPRINT    
      SELECT * FROM (
             SELECT 'Report Manager patch:              ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '4494603', 'R12.FRM.A'
             , '5907553', 'R12.FRM.A.delta.1'
             , '5917316', 'R12.FRM.A.delta.2'
             , '6077597', 'R12.FRM.A.delta.3'
             , '6354138', 'R12.FRM.A.delta.4'
             , '6594779', 'R12.FRM.A.delta.5'
             , '7237233', 'R12.FRM.A.delta.6')
             || ' applied ' || LAST_UPDATE_DATE || ' ' FRMbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('4494603','5907553','5917316','6077597','6354138','6594779','7237233')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;






REM   =========================================================================
REM   R12 Trading Community Architecture hz patches
REM   =========================================================================

      COLUMN HZbugDate NEW_VALUE v_HZbugDate NOPRINT    
      SELECT * FROM (
             SELECT 'Trading Community patch:           ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '4442901', 'R12.HZ.A'
             , '5884333', 'R12.HZ.A.delta.1'
             , '6000271', 'R12.HZ.A.delta.2'
             , '6262395', 'R12.HZ.A.delta.3'
             , '6496858', 'R12.HZ.A.delta.4'
             , '7299997', 'R12.HZ.A.delta.5'
             , '7300355', 'R12.HZ.A.delta.6')
             || ' applied ' || LAST_UPDATE_DATE || ' ' HZbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('4442901','5884333','6000271','6262395','6496858','7299997','7300355')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;





REM   =========================================================================
REM   R12 Financials fin_pf patches
REM   =========================================================================

      COLUMN FINbugDate NEW_VALUE v_FINbugDate NOPRINT    
      SELECT * FROM (
             SELECT 'Financials patch:                  ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '4175000', 'R12.FIN_PF.A'
             , '5884587', 'R12.FIN_PF.A.delta.1'
             , '6000030', 'R12.FIN_PF.A.delta.2'
             , '6251856', 'R12.FIN_PF.A.delta.3'
             , '6493602', 'R12.FIN_PF.A.delta.4'
             , '6836355', 'R12.FIN_PF.A.delta.5'
             , '7294050', 'R12.FIN_PF.A.delta.6')
             || ' applied ' || LAST_UPDATE_DATE || ' ' FINbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('4175000','5884587','6000030','6251856','6493602','6836355','7294050')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;







REM   =========================================================================
REM   R12 Web Applications Desktop Integrator bne patches
REM   =========================================================================

      COLUMN ADIbugDate NEW_VALUE v_ADIbugDate NOPRINT    
      SELECT * FROM (
             SELECT 'Web Application Desktop Integrator:' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '4494583', 'R12.BNE.A'
             , '5907557', 'R12.BNE.A.delta.1'
             , '5917318', 'R12.BNE.A.delta.2'
             , '6077453', 'R12.BNE.A.delta.3'
             , '6354131', 'R12.BNE.A.delta.4'
             , '6594745', 'R12.BNE.A.delta.5'
             , '7237127', 'R12.BNE.A.delta.6')
             || ' applied ' || LAST_UPDATE_DATE || ' ' ADIbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('4494583','5907557','5917318','6077453','6354131','6594745','7237127')
         ORDER BY BUG_NUMBER desc ) 
      WHERE ROWNUM = 1;





REM   =========================================================================
REM   R12 Approval Management Engine ame patches
REM   =========================================================================


      COLUMN AMEbugDate NEW_VALUE v_AMEbugDate NOPRINT    
      SELECT * FROM (
             SELECT 'Approval Management Engine:        ' || '  ' || bug_number || ' - ' ||
             DECODE(BUG_NUMBER
             , '5348050', 'R12.AME.A'
             , '5889626', 'R12.AME.A.delta.1'
             , '5997203', 'R12.AME.A.delta.2'
             , '6196260', 'R12.AME.A.delta.3'
             , '6506440', 'R12.AME.A.delta.4'
             , '6835789', 'R12.AME.A.delta.5'
             , '7291407', 'R12.AME.A.delta.6'
             , '7644754', 'R12.AME.A.delta.7'
             , '9349996', 'R12.AME.A.delta.8')
             || ' applied ' || LAST_UPDATE_DATE || ' ' AMEbugDate
         FROM ad_bugs 
         WHERE BUG_NUMBER IN 
             ('5348050','5889626','5997203','6196260','6506440','6835789','7291407','7644754','9349996')
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
      PROMPT &v_fileName..sql - 'Last HRMS120.sql Update Date ' &v_lastUpdate
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


REM   SPOOL HRMS120_output_file.txt


      SPOOL &v_spoolFile


      PROMPT SQL*Plus User/Version = &v_userName / &v_sqlplusVersion
      PROMPT NOTE: This Script must be run from SQL*Plus as user apps.  
      PROMPT
          

REM   =========================================================================
REM   Display Test Header Details
REM   =========================================================================



      PROMPT
      PROMPT
      PROMPT DATE HRMS120 was run: &v_ssdt
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
      PROMPT Most current downloadable version of file HRMS120.sql
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
      PROMPT


      PROMPT R12.0+ released HRMS family packs -- 12.0 through 12.0.11
      PROMPT =========================================================
      PROMPT  R12.HR_PF.A.delta.11 16077077 --  &v_PFbugDate12011
      PROMPT  R12.HR_PF.A.delta.10 13774477 --  &v_PFbugDate12010
      PROMPT  R12.HR_PF.A.delta.9  10281209 --  &v_PFbugDate1209
      PROMPT  R12.HR_PF.A.delta.8   9301208 --  &v_PFbugDate1208
      PROMPT  R12.HR_PF.A.delta.7   7577660 --  &v_PFbugDate1207
      PROMPT  R12.HR_PF.A.delta.6   7004477 --  &v_PFbugDate1206
      PROMPT  R12.HR_PF.A.delta.5   6610000 --  &v_PFbugDate1205
      PROMPT  R12.HR_PF.A.delta.4   6506482 --  &v_PFbugDate1204
      PROMPT  R12.HR_PF.A.delta.3   6196269 --  &v_PFbugDate1203
      PROMPT  R12.HR_PF.A.delta.2   5997278 --  &v_PFbugDate1202
      PROMPT  R12.HR_PF.A.delta.1   5881943 --  &v_PFbugDate1201
      PROMPT  R12.HR_PF.A           4719824 --  &v_PFbugDate120
      PROMPT
      PROMPT
      PROMPT  Oracle E-Business Suite HCM Information Center - Consolidated HRMS Mandatory Patch List (Doc ID 1160507.1)
      PROMPT




      PROMPT
      PROMPT
      PROMPT
      PROMPT
      PROMPT Oracle HRMS Mandatory Patch List
      PROMPT ===================================
      PROMPT Oracle E-Business Suite HCM Information Center - Consolidated HRMS Mandatory Patch List (Doc ID 1160507.1)
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
      PROMPT 12.0 Oracle Payroll US CA MX Year End patching for 2013  
      PROMPT ======================================================= 
      PROMPT
      PROMPT US and Canadian
      PROMPT ================
      PROMPT
      PROMPT Q3 2013 SQWL and JIT STATUTORY UPDATE FOR 120 patch 17365376 -- &v_PFbugDate17365376
      PROMPT US and CANADA END OF YEAR 2013 STATUTORY UPDATE I   FOR R12.0 patch 17535555 -- &v_PFbugDate17535555
      PROMPT US and CANADA END OF YEAR 2013 STATUTORY UPDATE II  FOR R12.0 patch 17955555 -- &v_PFbugDate17955555
      PROMPT US and CANADA END OF YEAR 2013 STATUTORY UPDATE III FOR R12.0 patch 18075556 -- &v_PFbugDate18075556


      PROMPT
      PROMPT
      PROMPT US HR 2013 Annual Statutory Patch Readme for Release 12.0.x - Patch 16713116 --  &v_PFbugDate16713116
      PROMPT US HR 2013 Annual Statutory Patch Readme for Release 12.0.x (Doc ID 1556339.1)


      PROMPT
      PROMPT
      PROMPT Mexico
      PROMPT =======
      PROMPT
      PROMPT YE13P1 120 MEXICO YEAREND - 2013 PHASE 1 patch 17941884 -- &v_PFbugDate17941884
      PROMPT
      PROMPT


      PROMPT
      PROMPT
      PROMPT
      PROMPT
      PROMPT 12.0 Oracle Payroll UK Year End patching for 2013 
      PROMPT ================================================= 
      PROMPT

      PROMPT YE13/14 REAL TIME INFORMATION CHANGES CONSOLIDATED FIXES - NOV - patch 17395845 -- &v_PFbugDate17395845




      PROMPT
      PROMPT
      PROMPT
      PROMPT
      PROMPT 12.0 Oracle Payroll US CA MX Year End patching for 2014 
      PROMPT =======================================================
      PROMPT
      PROMPT US and Canadian
      PROMPT ================
      PROMPT
      PROMPT Q1 2014 SQWL and JIT STATUTORY UPDATE FOR 120 patch 18285981 -- &v_PFbugDate18285981
      PROMPT Q2 2014 SQWL and JIT STATUTORY UPDATE FOR 120 patch 19132199 -- &v_PFbugDate19132199
      PROMPT Q3 2014 SQWL and JIT STATUTORY UPDATE FOR 120 patch 19507770 -- &v_PFbugDate19507770
      PROMPT

      PROMPT US and CANADA END OF YEAR 2014 STATUTORY UPDATE I   FOR 120 patch 19701971 -- &v_PFbugDate19701971
      PROMPT US and CANADA END OF YEAR 2014 STATUTORY UPDATE II  FOR 120 patch 20212223 -- &v_PFbugDate20212223
      PROMPT US and CANADA END OF YEAR 2014 STATUTORY UPDATE III FOR 120 patch 20365000 -- &v_PFbugDate20365000

      PROMPT
      PROMPT US and Canadian Payroll Customers 2015 Year Begin FOR 120 patch 20212122 -- &v_PFbugDate20212122

      PROMPT
      PROMPT Canadian HR Only Customers 2015 Year Begin FOR 120 patch 20212120 -- &v_PFbugDate20212120


      PROMPT
      PROMPT
      PROMPT
      PROMPT Mexico
      PROMPT ================

      PROMPT
      PROMPT MEXICO YEAR END 2014 PHASE I FOR R12.1 patch 20259629 -- &v_PFbugDate20259629

      PROMPT
      PROMPT MEXICO YEAR BEGIN 2015 FOR R12.1 patch 20280156 -- &v_PFbugDate20280156



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
      PROMPT  R12.OTA.A.delta.11  16664311 --  &v_OLMbugDate11
      PROMPT  R12.OTA.A.delta.10  13955174 --  &v_OLMbugDate10
      PROMPT  R12.OTA.A.delta.9   12424345 --  &v_OLMbugDate9
      PROMPT  R12.OTA.A.delta.8    9350274 --  &v_OLMbugDate8
      PROMPT  R12.OTA.A.delta.7    7644783 --  &v_OLMbugDate7
      PROMPT  R12.OTA.A.delta.6    7291412 --  &v_OLMbugDate6
      PROMPT  R12.OTA.A.delta.5    6835795 --  &v_OLMbugDate5
      PROMPT  R12.OTA.A.delta.4    6506492 --  &v_OLMbugDate4
      PROMPT  R12.OTA.A.delta.3    6196267 --  &v_OLMbugDate3
      PROMPT  R12.OTA.A.delta.2    5997248 --  &v_OLMbugDate2
      PROMPT  R12.OTA.A.delta.1    5889686 --  &v_OLMbugDate1
      PROMPT  R12.OTA.A            5348582 --  &v_OLMbugDate



      PROMPT
      PROMPT
      PROMPT iRecruitment details
      PROMPT ===========================
      PROMPT  R12.IRC.A.delta.11 16664306 --  &v_IRCbugDate11
      PROMPT  R12.IRC.A.delta.10 13955168 --  &v_IRCbugDate10
      PROMPT  R12.IRC.A.delta.9  12424333 --  &v_IRCbugDate9
      PROMPT  R12.IRC.A.delta.8   9349997 --  &v_IRCbugDate8
      PROMPT  R12.IRC.A.delta.7   7644755 --  &v_IRCbugDate7
      PROMPT  R12.IRC.A.delta.6   7291412 --  &v_IRCbugDate6
      PROMPT  R12.IRC.A.delta.5   6835790 --  &v_IRCbugDate5
      PROMPT  R12.IRC.A.delta.4   6506488 --  &v_IRCbugDate4
      PROMPT  R12.IRC.A.delta.3   6196261 --  &v_IRCbugDate3
      PROMPT  R12.IRC.A.delta.2   5997243 --  &v_IRCbugDate2
      PROMPT  R12.IRC.B.delta.1   5889675 --  &v_IRCbugDate1
      PROMPT  R12.IRC.A           5348577 --  &v_IRCbugDate
      PROMPT
      PROMPT



      PROMPT
      PROMPT
      PROMPT Labor Distribution details
      PROMPT ===========================
      PROMPT  R12.PSP.A.delta.11  16664309 --  &v_LDbugDate11
      PROMPT  R12.PSP.A.delta.10  13955173 --  &v_LDbugDate10
      PROMPT  R12.PSP.A.delta.9   12424339 --  &v_LDbugDate9
      PROMPT  R12.PSP.A.delta.8    9350000 --  &v_LDbugDate8
      PROMPT  R12.PSP.A.delta.7    7644760 --  &v_LDbugDate7
      PROMPT  R12.PSP.A.delta.6    7291411 --  &v_LDbugDate6
      PROMPT  R12.PSP.A.delta.5    6835794 --  &v_LDbugDate5
      PROMPT  R12.PSP.A.delta.4    6506493 --  &v_LDbugDate4
      PROMPT  R12.PSP.A.delta.3    6196266 --  &v_LDbugDate3
      PROMPT  R12.PSP.A.delta.2    5997266 --  &v_LDbugDate2
      PROMPT  R12.PSP.A.delta.1    5889704 --  &v_LDbugDate1
      PROMPT  R12.PSP.A            5348607 --  &v_LDbugDate




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
      PROMPT  XDO:  &v_XDObugDate
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






REM   =========================================================================
REM   Enable Security Groups
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
and   fpotl.PROFILE_OPTION_NAME = 'ENABLE_SECURITY_GROUPS' 
and   fpo.PROFILE_OPTION_ID = fpov.PROFILE_OPTION_ID
and   fpov.LEVEL_ID IN (10001,10002) 
and   fpotl.LANGUAGE = 'US' 
and   fpo.APPLICATION_ID = 0;







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
      PROMPT Business Group Details (HR_ALL_ORGANIZATION_UNITS )
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
REM   PROMPT Please review the output file: HRMS120_output_file.txt
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

      UNDEFINE         v_PFbugDate12011
      UNDEFINE         v_PFbugDate12010
      UNDEFINE         v_PFbugDate1209
      UNDEFINE         v_PFbugDate1208
      UNDEFINE         v_PFbugDate1207
      UNDEFINE         v_PFbugDate1206
      UNDEFINE         v_PFbugDate1205
      UNDEFINE         v_PFbugDate1204
      UNDEFINE         v_PFbugDate1203
      UNDEFINE         v_PFbugDate1202
      UNDEFINE         v_PFbugDate1201
      UNDEFINE         v_PFbugDate120

      UNDEFINE         v_PFbugDate13599900
      UNDEFINE         v_PFbugDate14136272
      UNDEFINE         v_PFbugDate13614067
      UNDEFINE         v_PFbugDate13086596
      UNDEFINE         v_PFbugDate13357651
      UNDEFINE         v_PFbugDate13840088
      UNDEFINE         v_PFbugDate13547295
      UNDEFINE         v_PFbugDate13998818

      UNDEFINE         v_PFbugDate13929707
      UNDEFINE         v_PFbugDate17365376
      UNDEFINE         v_PFbugDate17535555
      UNDEFINE         v_PFbugDate17955555
      UNDEFINE         v_PFbugDate18075556


      UNDEFINE         v_PFbugDate18285981
      UNDEFINE         v_PFbugDate19132199
      UNDEFINE         v_PFbugDate19507770



      UNDEFINE         v_PFbugDate19701971
      UNDEFINE         v_PFbugDate20212223
      UNDEFINE         v_PFbugDate20365000



      UNDEFINE         v_PFbugDate20212122
      UNDEFINE         v_PFbugDate20212120

      UNDEFINE         v_PFbugDate20259629
      UNDEFINE         v_PFbugDate20280156

      UNDEFINE         v_PFbugDate17941884

      UNDEFINE         v_PFbugDate16713116

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
      UNDEFINE        v_IRCbugDate1
      UNDEFINE        v_IRCbugDate2
      UNDEFINE        v_IRCbugDate3
      UNDEFINE        v_IRCbugDate4
      UNDEFINE        v_IRCbugDate5
      UNDEFINE        v_IRCbugDate6
      UNDEFINE        v_IRCbugDate7
      UNDEFINE        v_IRCbugDate8
      UNDEFINE        v_IRCbugDate9
      UNDEFINE        v_IRCbugDate10
      UNDEFINE        v_IRCbugDate11


      UNDEFINE        v_LDbugDate
      UNDEFINE        v_LDbugDate1
      UNDEFINE        v_LDbugDate2
      UNDEFINE        v_LDbugDate3
      UNDEFINE        v_LDbugDate4
      UNDEFINE        v_LDbugDate5
      UNDEFINE        v_LDbugDate6
      UNDEFINE        v_LDbugDate7
      UNDEFINE        v_LDbugDate8
      UNDEFINE        v_LDbugDate9
      UNDEFINE        v_LDbugDate10
      UNDEFINE        v_LDbugDate11


      UNDEFINE        v_OLMbugDate
      UNDEFINE        v_OLMbugDate1
      UNDEFINE        v_OLMbugDate2
      UNDEFINE        v_OLMbugDate3
      UNDEFINE        v_OLMbugDate4
      UNDEFINE        v_OLMbugDate5
      UNDEFINE        v_OLMbugDate6
      UNDEFINE        v_OLMbugDate7
      UNDEFINE        v_OLMbugDate8
      UNDEFINE        v_OLMbugDate9
      UNDEFINE        v_OLMbugDate10
      UNDEFINE        v_OLMbugDate11


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

      UNDEFINE   v_PFbugDate17395845




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