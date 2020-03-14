
===============================================================================
    Copyright (c) 2007 Oracle Corporation Redwood Shores, California, USA      
    Oracle Support Services.  All rights reserved.                              
===============================================================================
Product:        All Oracle HRMS Products
Legislations:   All
Metalink Note:  453632.1
Platform:       Generic
Spool Filename: 
HRMS120_<SID>_<SYSDATE>.txt (for 12.0+  customers)
HRMS121_<SID>_<SYSDATE>.txt (for 12.1+  customers)

Test Filename:  
HRMS120.sql (for 12.0+  customers)  OR  HRMS121.sql (for 12.1+  customers)

Valid Apps Versions: 12.0+ and 12.1+


===============================================================================
Purpose
===============================================================================
Script to display data specific to the HRMS suite of products for release R12.

===============================================================================
Instructions
===============================================================================


NOTE: This test 'must be ran from SQL*Plus' using the apps account.


The downloadable ZIP file contains:
     HRMS120.sql
     HRMS121.sql
     HRMS12_readme.txt
     sample_HRMS12_output_file.txt


The zipped file 'must be uploaded to your database'  
and then 
these files should be unzipped into a common directory 

and then ran from within UNIX as follows: 

sqlplus apps/apps @HRMS120.sql (for 12.0+  customers)

OR

sqlplus apps/apps @HRMS121.sql (for 12.1+  customers)



This script will produce 
output file HRMS120_<SID>_<SYSDATE>.txt  (for 12.0+  customers)
OR
output file HRMS121_<SID>_<SYSDATE>.txt  (for 12.1+  customers)




example:
HRMS120_VISHR04_17-Jan-2011.txt



===============================================================================
Disclaimer
===============================================================================
EXCEPT WHERE EXPRESSLY PROVIDED OTHERWISE, THE INFORMATION, SOFTWARE,
PROVIDED ON AN "AS IS" AND "AS AVAILABLE" BASIS. ORACLE EXPRESSLY DISCLAIMS
ALL WARRANTIES OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE AND NON-INFRINGEMENT. ORACLE MAKES NO WARRANTY THAT: (A) THE RESULTS
THAT MAY BE OBTAINED FROM THE USE OF THE SOFTWARE WILL BE ACCURATE OR
RELIABLE; OR (B) THE INFORMATION, OR OTHER MATERIAL OBTAINED WILL MEET YOUR
EXPECTATIONS. ANY CONTENT, MATERIALS, INFORMATION OR SOFTWARE DOWNLOADED OR
OTHERWISE OBTAINED IS DONE AT YOUR OWN DISCRETION AND RISK. ORACLE SHALL HAVE
NO RESPONSIBILITY FOR ANY DAMAGE TO YOUR COMPUTER SYSTEM OR LOSS OF DATA THAT
RESULTS FROM THE DOWNLOAD OF ANY CONTENT, MATERIALS, INFORMATION OR SOFTWARE.

ORACLE RESERVES THE RIGHT TO MAKE CHANGES OR UPDATES TO THE SOFTWARE AT ANY
TIME WITHOUT NOTICE.

===============================================================================
Limitation of Liability
===============================================================================
IN NO EVENT SHALL ORACLE BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL OR CONSEQUENTIAL DAMAGES, OR DAMAGES FOR LOSS OF PROFITS, REVENUE,
DATA OR USE, INCURRED BY YOU OR ANY THIRD PARTY, WHETHER IN AN ACTION IN
CONTRACT OR TORT, ARISING FROM YOUR ACCESS TO, OR USE OF, THE SOFTWARE.

SOME JURISDICTIONS DO NOT ALLOW THE LIMITATION OR EXCLUSION OF LIABILITY.
ACCORDINGLY, SOME OF THE ABOVE LIMITATIONS MAY NOT APPLY TO YOU.