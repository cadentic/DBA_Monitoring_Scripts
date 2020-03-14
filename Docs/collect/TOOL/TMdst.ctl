# TMdst.ctl: Daylight Saving Time Tool Box
# $Id: TMdst.ctl,v 1.11 2015/05/13 17:35:04 RDA Exp $
# ARCS: $Header: /home/cvs/cvs/RDA_8/src/scripting/lib/collect/TOOL/TMdst.ctl,v 1.11 2015/05/13 17:35:04 RDA Exp $
#
# Change History
# 20150513  KRA  Improve the documentation.

=head1 NAME

TOOL:TMdst - Daylight Saving Time Tool Box

=head1 DESCRIPTION

This test module regroups a number of tools for detecting issues relating to
Daylight Saving Time (DST) changes. See My Oracle Support document ID 412160.1
I<Updated DST Transitions and New Time Zones in Oracle RDBMS and OJVM Time
Zone File Patches> for a overview of all existing Oracle DST updates and the
related notes.

=head1 REQUIREMENTS

Must have a valid Oracle home and a valid connection to a running database.

=head1 USAGE

Use the following command to execute the tool kit:

 <rda> -T dst

 <sdci> -v run dst

Use the following command to ignore the current setup:

 <rda> -Tn dst

=cut

section tool
call unshift(@{CUR.W_NEXT},'test')

section test

echo tput('bold'),'DST Tool Box',tput('off'),"\012"

# Initialization
call setAbbr('TOOL_DST_')

=head1 AVAILABLE TOOLS

=head2 Client Time Zone Patch Test

Checks whether the time zone definition file on the client and the database
has updated to version 4 or later (C<Canada/Mountain>). When the version 4 or
later definition is not installed on either side, it then tests a version 3
change (C<US/Mountain>).

The test is based on My Oracle Support document ID 402742.1 I<USA 2007 DST
Changes: Frequently Asked Questions for Oracle Database Patches> (Q202 -
I<Is the time zone file patch applied correctly to the client?>).

=cut

macro test_client
{echo tput('bold'),'Client Time Zone Patch Test',tput('off'),"\012"

 set $sql
 {ALTER session SET nls_timestamp_tz_format = 'HH24';
 "col T format a2
 "SELECT to_timestamp_tz('20070311 06:00:00 CANADA/MOUNTAIN',
 "                       'YYYYMMDD HH24:MI:SS TZR') T
 " FROM dual;
 "SELECT to_timestamp_tz('20070311 06:00:00 CANADA/MOUNTAIN',
 "                       'YYYYMMDD HH24:MI:SS TZR') at time zone 'GMT' T
 " FROM dual;
 "SELECT to_timestamp_tz('20070311 06:00:00 US/MOUNTAIN',
 "                       'YYYYMMDD HH24:MI:SS TZR') T
 " FROM dual;
 "SELECT to_timestamp_tz('20070311 06:00:00 US/MOUNTAIN',
 "                       'YYYYMMDD HH24:MI:SS TZR') at time zone 'GMT' T
 " FROM dual;
 "SELECT 'version=' || version
 " FROM v$instance;
 }
 if loadSql($sql)
 {var ($loc4,$gmt4,$loc3,$gmt3) = getSqlLines()
  if and(match($gmt3,'^\d\d$'),match($gmt4,'^\d\d$'),\
         match($loc3,'^\d\d$'),match($loc4,'^\d\d$'))
  {debug "  Local hour (Canada/Mountain): \001",$loc4
   debug "  GMT hour (Canada/Mountain):   \001",$gmt4
   debug "  Local hour (US/Mountain):     \001",$loc3
   debug "  GMT hour (US/Mountain):       \001",$gmt3
   debug
   if and(expr('==',$loc4,6),expr('==',$gmt4,12))
    echo "The patch for version 4 or later is applied correctly on both the \
          client and the server."
   elsif and(expr('==',$loc4,5),expr('==',$gmt4,12))
   {echo "The patch for version 4 or later is applied on the server but not on \
          the client."
    if and(expr('==',$loc3,6),expr('==',$gmt3,12))
     echo "The patch for version 3 is applied on the client."
    echo "See My Oracle Support document ID 412160.1 for updating the client."
   }
   elsif and(expr('==',$loc4,7),expr('==',$gmt4,13))
   {echo "The patch for version 4 or later is applied on the client but not \
          on the server."
    if and(expr('==',$loc3,6),expr('==',$gmt3,12))
     echo "The patch for version 3 is applied on the server."
    echo "See My Oracle Support document ID 412160.1 for updating the server."
   }
   elsif and(expr('==',$loc3,6),expr('==',$gmt3,12))
    echo "The patch for version 3 is applied correctly on both the client and \
          the server."
   elsif and(expr('==',$loc3,5),expr('==',$gmt3,12))
    echo "The patch for version 3 is applied on the server but not on the \
          client. See My Oracle Support document ID 412160.1 for updating the \
          client."
   elsif and(expr('==',$loc3,7),expr('==',$gmt3,13))
    echo "The patch for version 3 is applied on the client but not on the \
          server. See My Oracle Support document ID 412160.1 for updating the \
          server."
   elsif and(expr('==',$loc3,6),expr('==',$gmt3,13))
    echo "Patch for version 3 or 4 is not applied on both the client and the \
          server. Consult My Oracle Support document ID 412160.1 for more \
          information."
   else
   {echo "Invalid time zone values. Contact Oracle Support."
    echo "  GMT hour (Canada/Mountain):   \001",$gmt4
    echo "  GMT hour (US/Mountain):       \001",$gmt3
    echo "  Local hour (Canada/Mountain): \001",$loc4
    echo "  Local hour (US/Mountain):     \001",$loc3
   }
  }
  else
  {var $ver = value(grepLastSql('^version='))
   if match($ver,'^version=(6|7|8)\.')
    echo "TIMEZONE data type was not supported before Release 9.\012\
          Database Version: ",$ver
   else
    echo "Error: Time zone does not seem to be supported by the client\012",\
         join("\012",getSqlLines())
  }
 }
 else
  echo "Error: ",getSqlMessage()
}

=head2 Oracle Java Virtual Machine Test

Checks if the February 2007 Time Zone Update or later is applied for Oracle
JVM. If not, it checks if the March 2006 Time Zone Update has been applied.

The test is based on My Oracle Support document ID 414309.1 (Q6 - I<How can I
test if the OJVM patch has been applied correctly?>) and requires the privilege
to create objects in the database.

=cut

macro test_jvm
{echo tput('bold'),'Oracle Java Virtual Machine Test',tput('off'),"\012"

 set $sql
 {CREATE OR REPLACE JAVA SOURCE NAMED "RdaOffsetFromStandard" AS
 "import java.util.Calendar;
 "import java.util.GregorianCalendar;
 "import java.util.TimeZone;
 "public class RdaOffsetFromStandard
 "{public static int getDSTOffset(
 "   String timezone,
 "   int    year,
 "   int    month,
 "   int    mday,
 "   int    hour,
 "   int    min,
 "   int    sec)
 " {TimeZone tz = TimeZone.getTimeZone(timezone);
 "  GregorianCalendar c = new GregorianCalendar(tz);
 "  c.set(year,month-1,mday,hour,min,sec);
 "  return c.get(Calendar.DST_OFFSET);
 " }
 "}
 "/
 "ALTER JAVA CLASS "RdaOffsetFromStandard" RESOLVE;
 "CREATE OR REPLACE FUNCTION rda_dst_offset(
 "  timezone VARCHAR2,
 "  year     NUMBER,
 "  month    NUMBER,
 "  mday     NUMBER,
 "  hour     NUMBER,
 "  min      NUMBER,
 "  sec      NUMBER) RETURN NUMBER AS
 "LANGUAGE JAVA NAME 'RdaOffsetFromStandard.getDSTOffset(
 "  java.lang.String,int,int,int,int,int,int) return int';
 "/
 "SELECT 'ca=' || rda_dst_offset('America/Edmonton',2007,3,11,10,0,0)/3600000
 " FROM dual;
 "SELECT 'us=' || rda_dst_offset('America/Los_Angeles',2007,3,11,10,0,0)/3600000
 " FROM dual;
 }
 if loadSql($sql)
 {var $ca = value(grepLastSql('^ca=','f'))
  var $us = value(grepLastSql('^us=','f'))
  debug 'America/Edmonton:    ',$ca
  debug 'America/Los_Angeles: ',$us
  if expr('==',$ca,1)
   echo "February 2007 Oracle JVM Time Zone Update or later has been applied \
         correctly."
  elsif expr('==',$us,1)
   echo "March 2006 Oracle JVM Time Zone Update has been applied correctly."
  elsif and(defined($ca),defined($us))
   echo "March 2006 Oracle JVM Time Zone Update has not been applied. For \
         information about the patches which must be applied, see the \
         Oracle JVM section and Table 3 in My Oracle Support document ID \
         359145.1"
  else
   echo "Error encountered during the test:\012",join("\012",getSqlLines()),\
        "\012My Oracle Support document ID 397770.1 provides more information \
        for checking if the JVM is installed."
 }
 else
  echo "Error accessing the JVM: ",getSqlMessage(),"\012My Oracle Support \
        document ID 397770.1 provides more information for checking if the \
        JVM is installed."
}

=for stopwords utltzuv utltzuv2

=head2 utltzuv2 test

Any existing C<TIMESTAMP WITH TIME ZONE> data that uses time zones that are
updated in the new time zone files, will be affected by the installation of
these new time zone files. Oracle provides the F<utltzuv2.sql> script to scan
your current data to see if any of this TSTZ data exists. Using the results of
this script, you can save the affected TSTZ data before the new time zone files
are installed in a C<VARCHAR2> column. After the time zone files are installed,
the C<TIMESTAMP> values can then be restored to their intended value.

This test covers data that will be affected by version 3 and version 4
update of the time zone definition files only.

If you have an existing F<utltzuv2.sql> script, this is not sufficient for
scanning the updates in version 3 of the time zone files (which include
the changes for the USA from 2007), or for version 4 changes.

Standalone implementation of the F<utltzuv2.sql> script does not require
installing files in the Oracle Home or installing a Java Virtual Machine. It
can be executed on remote databases.

It is based on My Oracle Support document ID 359145.1 - I<Impact of 2007 USA
daylight saving changes on the Oracle database>.

=cut

macro test_utltzuv2
{echo tput('bold'),'Utltzuv2 Test',tput('off'),"\012"

 # Check the database version
 set $sql
 {SELECT 'version=' || version
  FROM v$instance;
 "SELECT owner || '.' || table_name
 " FROM all_tables
 " WHERE owner = 'SYS'
 "   AND table_name IN ('SYS_TZUV2_AFFECTED_REGIONS','SYS_TZUV2_TEMPTAB');
 }
 call loadSql($sql)
 var $ver = value(grepLastSql('^version=','f'))
 if !defined($ver)
 {echo 'Unable to determine the database version.'
  return
 }
 if match($ver,'^(6|7|8)\.')
 {echo 'TIMEZONE data type was not supported before Release 9.'
  echo 'No need to validate TIMEZONE data.'
  return
 }

 # Ask confirmation before dropping existing work tables
 if grepLastSql('^SYS.')
 {echo 'Tables to drop: ',join(', ',last)
  var ${RUN.REQUEST.T_SETUP} = 'utltzuv2'
  call requestInput('TMdst')
  if !${RUN.REQUEST.B_UTLTZUV2}
   return
 }

 # Define the changes in the different versions
 var $dst = createData(\
  '2', list('AMERICA/ARAGUAINA',\
            'AMERICA/BOA_VISTA',\
            'AMERICA/BUENOS_AIRES',\
            'AMERICA/CAMBRIDGE_BAY',\
            'AMERICA/CANCUN',\
            'AMERICA/CHIHUAHUA',\
            'AMERICA/CUIABA',\
            'AMERICA/ENSENADA',\
            'AMERICA/FORTALEZA',\
            'AMERICA/GOOSE_BAY',\
            'AMERICA/HAVANA',\
            'AMERICA/IQALUIT',\
            'AMERICA/MACEIO',\
            'AMERICA/MAZATLAN',\
            'AMERICA/MEXICO_CITY',\
            'AMERICA/RANKIN_INLET',\
            'AMERICA/SANTIAGO',\
            'AMERICA/SAO_PAULO',\
            'AMERICA/ST_JOHNS',\
            'AMERICA/TIJUANA',\
            'AMERICA/WINNIPEG',\
            'ASIA/ALMATY',\
            'ASIA/AMMAN',\
            'ASIA/ANADYR',\
            'ASIA/AQTAU',\
            'ASIA/AQTOBE',\
            'ASIA/BAGHDAD',\
            'ASIA/JERUSALEM',\
            'ASIA/KARACHI',\
            'ASIA/TEHRAN',\
            'ASIA/TEL_AVIV',\
            'ATLANTIC/STANLEY',\
            'AUSTRALIA/LHI',\
            'AUSTRALIA/LORD_HOWE',\
            'BRAZIL/EAST',\
            'CANADA/CENTRAL',\
            'CANADA/NEWFOUNDLAND',\
            'CHILE/CONTINENTAL',\
            'CHILE/EASTERISLAND',\
            'CUBA',\
            'EUROPE/RIGA',\
            'EUROPE/TALLINN',\
            'EUROPE/VILNIUS',\
            'IRAN',\
            'ISRAEL',\
            'MEXICO/BAJASUR',\
            'MEXICO/GENERAL',\
            'PACIFIC/EASTER',\
            'PACIFIC/FIJI',\
            'PACIFIC/GUAM',\
            'PACIFIC/SAIPAN',\
            'PACIFIC/TONGATAPU'),\
  '3', list('AFRICA/KHARTOUM',\
            'AFRICA/TUNIS',\
            'AMERICA/ADAK',\
            'AMERICA/ANCHORAGE',\
            'AMERICA/ARAGUAINA',\
            'AMERICA/ASUNCION',\
            'AMERICA/ATKA',\
            'AMERICA/BOISE',\
            'AMERICA/CAMBRIDGE_BAY',\
            'AMERICA/CHICAGO',\
            'AMERICA/CUIABA',\
            'AMERICA/DENVER',\
            'AMERICA/DETROIT',\
            'AMERICA/FORT_WAYNE',\
            'AMERICA/HALIFAX',\
            'AMERICA/HAVANA',\
            'AMERICA/INDIANA/INDIANAPOLIS',\
            'AMERICA/INDIANA/KNOX',\
            'AMERICA/INDIANA/MARENGO',\
            'AMERICA/INDIANA/VEVAY',\
            'AMERICA/INDIANAPOLIS',\
            'AMERICA/IQALUIT',\
            'AMERICA/JAMAICA',\
            'AMERICA/JUNEAU',\
            'AMERICA/KENTUCKY/LOUISVILLE',\
            'AMERICA/KNOX_IN',\
            'AMERICA/LOS_ANGELES',\
            'AMERICA/LOUISVILLE',\
            'AMERICA/MANAGUA',\
            'AMERICA/MIQUELON',\
            'AMERICA/MONTEVIDEO',\
            'AMERICA/MONTREAL',\
            'AMERICA/NEW_YORK',\
            'AMERICA/NOME',\
            'AMERICA/NORONHA',\
            'AMERICA/RANKIN_INLET',\
            'AMERICA/SAO_PAULO',\
            'AMERICA/SHIPROCK',\
            'AMERICA/THUNDER_BAY',\
            'AMERICA/WINNIPEG',\
            'ASIA/ALMATY',\
            'ASIA/AMMAN',\
            'ASIA/AQTAU',\
            'ASIA/AQTOBE',\
            'ASIA/BAKU',\
            'ASIA/BISHKEK',\
            'ASIA/CHAGOS',\
            'ASIA/HONG_KONG',\
            'ASIA/JAKARTA',\
            'ASIA/JAYAPURA',\
            'ASIA/JERUSALEM',\
            'ASIA/TBILISI',\
            'ASIA/TEHRAN',\
            'ASIA/TEL_AVIV',\
            'ASIA/TOKYO',\
            'AUSTRALIA/ACT',\
            'AUSTRALIA/ADELAIDE',\
            'AUSTRALIA/BROKEN_HILL',\
            'AUSTRALIA/CANBERRA',\
            'AUSTRALIA/HOBART',\
            'AUSTRALIA/LHI',\
            'AUSTRALIA/LORD_HOWE',\
            'AUSTRALIA/MELBOURNE',\
            'AUSTRALIA/NSW',\
            'AUSTRALIA/PITCAIRN',\
            'AUSTRALIA/SOUTH',\
            'AUSTRALIA/SYDNEY',\
            'AUSTRALIA/TASMANIA',\
            'AUSTRALIA/VICTORIA',\
            'AUSTRALIA/YANCOWINNA',\
            'BRAZIL/DENORONHA',\
            'BRAZIL/EAST',\
            'CANADA/ATLANTIC',\
            'CANADA/CENTRAL',\
            'CANADA/EASTERN',\
            'CST',\
            'CST6CDT',\
            'CUBA',\
            'EST',\
            'EST5EDT',\
            'HONGKONG',\
            'HST',\
            'IRAN',\
            'ISRAEL',\
            'JAMAICA',\
            'JAPAN',\
            'MST',\
            'MST7MDT',\
            'PST',\
            'PST8PDT',\
            'US/ALASKA',\
            'US/ALEUTIAN',\
            'US/CENTRAL',\
            'US/EASTERN',\
            'US/EAST-INDIANA',\
            'US/MICHIGAN',\
            'US/MOUNTAIN',\
            'US/PACIFIC',\
            'US/PACIFIC-NEW'),\
  '4', list('AFRICA/CAIRO',\
            'AFRICA/TUNIS',\
            'AMERICA/CUIABA',\
            'AMERICA/DAWSON',\
            'AMERICA/EDMONTON',\
            'AMERICA/GOOSE_BAY',\
            'AMERICA/GUATEMALA',\
            'AMERICA/INUVIK',\
            'AMERICA/MANAGUA',\
            'AMERICA/MONTEVIDEO',\
            'AMERICA/SAO_PAULO',\
            'AMERICA/ST_JOHNS',\
            'AMERICA/TEGUCIGALPA',\
            'AMERICA/THULE',\
            'AMERICA/VANCOUVER',\
            'AMERICA/WHITEHORSE',\
            'AMERICA/YELLOWKNIFE',\
            'ASIA/AMMAN',\
            'ASIA/DAMASCUS',\
            'ASIA/GAZA',\
            'ASIA/TEHRAN',\
            'ATLANTIC/BERMUDA',\
            'AUSTRALIA/PERTH',\
            'AUSTRALIA/WEST',\
            'BRAZIL/EAST',\
            'CANADA/MOUNTAIN',\
            'CANADA/NEWFOUNDLAND',\
            'CANADA/PACIFIC',\
            'CANADA/YUKON',\
            'EGYPT',\
            'IRAN'))

 # Determine the current version
 if match($ver,'^9\.')
 {set $sql
  {SELECT 'dis=' || COUNT(DISTINCT(tzname)) || CHR(10) ||
  "       'tot=' || COUNT(tzname)
  " FROM v$timezone_names;
  }
  call loadSql($sql)
  var $dis = value(grepLastSql('^dis=','f'))
  var $tot = value(grepLastSql('^tot=','f'))
  debug 'Number of distinct time zone names: ',$dis
  debug 'Number of time zone name records:   ',$tot
  var $cur = cond(\
    or(expr('==',$dis,183),expr('==',$dis,355),expr('==',$dis,347)), 1,\
    expr('==',$dis,377),                                             2,\
    and(expr('==',$dis,186),expr('==',$tot,636)),                    2,\
    and(expr('==',$dis,186),expr('==',$tot,626)),                    3,\
    or(expr('==',$dis,185),expr('==',$dis,386)),                     3,\
    and(expr('==',$dis,387),expr('==',$tot,1438)),                   3,\
    and(expr('==',$dis,391),expr('==',$tot,1457)),                   4,\
    and(expr('==',$dis,392),expr('==',$tot,1458)),                   4,\
    and(expr('==',$dis,188),expr('==',$tot,637)),                    4,\
    and(expr('==',$dis,189),expr('==',$tot,638)),                    4)
  if !defined($cur)
  {echo "Your time zone upgrade needs a different script.\012\
         Contact Oracle support!"
   echo "- Number of distinct time zone names: \001",$dis
   echo "- Number of time zone name records:   \001",$tot
   return
  }
 }
 else
 {set $sql
  {SELECT 'cur=' || version
  " FROM v$timezone_file;
  }
  var $cur = value(grepSql($sql,'^cur=','f'))
 }
 echo "Time zone data version: ",$cur

 # Check if the TIMEZONE data is consistent with the target version
 var ${RUN.REQUEST.N_VERSION} = max($cur,3)
 var ${RUN.REQUEST.T_SETUP} = 'version'
 call requestInput('TMdst')
 var $max = ${RUN.REQUEST.N_VERSION}
 if expr('>=',$cur,$max)
 {echo "No need to validate time zone data."
  return
 }

 # Determine the relevant changes
 var %chg = ()
 incr $cur
 for $ver ($cur,$max)
 {loop $nam (getDataValue($dst,$ver))
   var $chg{$nam} = 1
 }
 var $chg = join("' FROM DUAL UNION ALL\012 SELECT '",keys(%chg))
 debug "Change count: ",scalar(keys(%chg))

 # Perform the checks
 set $sql
 {SET serveroutput on
 "DROP TABLE sys.sys_tzuv2_temptab;
 "CREATE TABLE sys.sys_tzuv2_temptab
 " (table_owner  VARCHAR2(128),
 "  table_name   VARCHAR2(128),
 "  column_name  VARCHAR2(128),
 "  rowcount     NUMBER,
 "  nested_tab   VARCHAR2(3)
 " );
 "
 "DROP TABLE sys.sys_tzuv2_affected_regions;
 "CREATE TABLE sys.sys_tzuv2_affected_regions
 " (time_zone_name VARCHAR2(60)
 " );
 "
 "INSERT INTO sys.sys_tzuv2_affected_regions
 " SELECT ':1' FROM DUAL;
 "
 "ANALYZE TABLE sys.sys_tzuv2_affected_regions COMPUTE STATISTICS;
 "
 "SELECT 'chg=' || COUNT(1)
 " FROM sys.sys_tzuv2_affected_regions;
 "
 "DECLARE
 " TYPE cursor_t IS REF CURSOR;
 " cursor_tstz cursor_t;
 " numrows     NUMBER;
 " tstz_owner  all_tab_cols.owner%TYPE;
 " tstz_tname  all_tab_cols.table_name%TYPE;
 " tstz_qcname all_tab_cols.qualified_col_name%TYPE;
 "BEGIN
 " --======================================================================
 " -- Get tables with columns defined as type TIMESTAMP WITH TIME ZONE
 " --======================================================================
 " OPEN cursor_tstz FOR
 "  'SELECT atc.owner, atc.table_name, atc.qualified_col_name ' ||
 "  'FROM "ALL_TAB_COLS" atc,"ALL_TABLES" at ' ||
 "  'WHERE data_type LIKE ''TIMESTAMP%WITH TIME ZONE''' ||
 "  ' AND atc.owner = at.owner AND atc.table_name = at.table_name ' ||
 "  'ORDER BY atc.owner, atc.table_name, atc.column_name';
 "
 " --======================================================================
 " -- Check regular table columns
 " --======================================================================
 " LOOP
 "  BEGIN
 "   FETCH cursor_tstz INTO tstz_owner, tstz_tname, tstz_qcname;
 "   EXIT WHEN cursor_tstz%NOTFOUND;
 "
 "   EXECUTE IMMEDIATE
 "    'SELECT COUNT(1) FROM ' ||
 "      tstz_owner || '."' || tstz_tname || '" t_alias, ' ||
 "      ' sys.sys_tzuv2_affected_regions r ' ||
 "    'WHERE UPPER(r.time_zone_name) = ' ||
 "    ' UPPER(TO_CHAR(t_alias.' || tstz_qcname || ', ''TZR''))' INTO numrows;
 "
 "   IF numrows > 0 THEN
 "    EXECUTE IMMEDIATE
 "     'INSERT INTO sys.sys_tzuv2_temptab VALUES (''' ||
 "        tstz_owner || ''',''' || tstz_tname || ''',''' ||
 "        tstz_qcname || ''',' || numrows || ', ''NO'')';
 "   END IF;
 "  EXCEPTION
 "   WHEN OTHERS THEN
 "    DBMS_OUTPUT.PUT_LINE('OWNER: ' || tstz_owner);
 "    DBMS_OUTPUT.PUT_LINE('TABLE: ' || tstz_tname);
 "    DBMS_OUTPUT.PUT_LINE('COLUMN: ' || tstz_qcname);
 "    DBMS_OUTPUT.PUT_LINE(SQLERRM);
 "  END;
 " END LOOP;
 }
 if match($ver,'^1[01]\.')
 {append $sql
  { --======================================================================
  " -- Check nested table columns
  " --======================================================================
  " EXECUTE IMMEDIATE
  "  'INSERT INTO sys.sys_tzuv2_temptab
  "    SELECT owner, table_name, qualified_col_name, NULL, ''YES''
  "     FROM ALL_NESTED_TABLE_COLS
  "     WHERE data_type like ''TIMESTAMP%WITH TIME ZONE''';
  }
 }
 append $sql
 {EXCEPTION
 " WHEN OTHERS THEN
 "  DBMS_OUTPUT.PUT_LINE(SQLERRM);
 "END;
 "/
 "
 "SELECT 'cnt=' || COUNT(1)
 " FROM sys.sys_tzuv2_temptab;
 "COMMIT;
 }

 # Get the result without interrupting the script execution
 var $cnt = value(grepSql(bindSql($sql,$chg),'^cnt='))
 echo 'SYS.SYS_TZUV2_TEMPTAB row count: ',$cnt
 echo "Query SYS.SYS_TZUV2_TEMPTAB table to see if any time zone data is \
       affected by version ",$max," transition rules."
 if match($ver,'^9\.')
  echo "For more details, look at My Oracle Support document ID 396670.1 \
        'Usage of utltzuv2.sql before updating time zone files in Oracle 9'."
 else
  echo "For more details, look at My Oracle Support document ID 396671.1 \
        'Usage of utltzuv2.sql before updating time zone files in Oracle 10'."
}

=head2 Time Zone Usage Views

Drops and recreates the following objects in the C<SYS> schema, and ensures
that you do not use these for your own purpose:

=over 2

=item * View C<TZ$TSLTZ_TAB_COLS>

Shows columns of tables using the C<TIMESTAMP WITH LOCAL TIME ZONE>
type. If all session time zones and the database time zone are not affected by
the time zone changes, then these types are not affected.

=item * View C<TZ$TSLTZ_VW_COLS>

Shows columns of views using C<TIMESTAMP WITH LOCAL TIME ZONE>
type. These views are based on tables with TSLTZ types. Therefore these views
themselves do not introduce any new time zone use. They would not be affected
by any time zone changes. The underlying table data may be affected, but the
views will only reflect the data stored in the tables.

=item * View C<TZ$NAMED_TSTZ_TAB_COLS>

Shows columns of tables using C<TIMESTAMP WITH TIME ZONE> type where
C<named time zones> are used. When TSTZ data uses offsets (C<-05:00>,
C<+10:00>, etc.) or static time zones (GMT, UTC), it is not affected by any
changes to time zone rules because offsets are always the same. Therefore you
are only interested in TSTZ data using named time zones (C<US/EASTERN>,
C<Europe/Berlin>, etc.). This view shows TSTZ data only with named time
zones. It lists the column details and the number of rows in each column using
a named time zone.

Because this view has to work out exactly how many affected rows there are in
each column it could take some time to complete. If you know you have a lot of
this type of data, then it is a good idea to create a table based on the view
results to query it again without the same amount of work.

=item * View C<TZ$NAMED_TSTZ_VW_COLS>

Similar to C<TZ$NAMED_TSTZ_TAB_COLS>, but for views. Usually views that are
marked as using these types are based on tables using the same types, and
therefore these views are not important when assessing time zone use. For these
views, it is the underlying table data that requires investigation.

However, it is possible to create a view also where a C<TO_TIMESTAMP_TZ>
function is used to "build" a time stamp: for example, a C<DATE> in a underlying
table. When it is performed, you must check the view definition for
the usage of named time zones. When these are used, then the view is affected
by time zone changes even if the underlying data is not.

=item * View C<TZ$ARGUMENTS>

Shows arguments of PL/SQL procedures and functions that use time zone
types. This does not mean that these objects are affected by time zone changes.
This is the case only if they are called with arguments that use updated time
zone information.

For this reason, the standard Oracle schemas (like C<SYS> etc.) are filtered
out of the results of this view as well. Many of the standard functions are
capable of dealing with time zones, but these are only affected when affected
data is used. Therefore these functions are not flagged since they do not
'introduce' any time zone use.

Note: If your application stores PL/SQL objects in the C<SYS> schema (or other
standard schemas), you should adjust the view so that they can be checked, but
discard Oracle-standard objects.

=item * View C<TZ$DBTIMEZONE>

Shows the database time zone. The database time zone should be an
offset rather than a named time zone. See My Oracle Support document ID
359119.1 I<Using named time zones vs offsets in database E<amp> session
time zone>.

=item * View C<TZ$OVERVIEW>

Contains an overview of the results of all the above queries. For
x_TAB_COLS and x_VW_COLS, it makes a split between SYS usage and non-SYS
usage. For an overview of time zone data in the data dictionary see
My Oracle Support document ID 402614.1 I<Time Zone Data in the Data Dictionary
(SYS) and the Effects of a Time Zone File Update>. This view does not contain
results of the C<TZ$SOURCE> view because they must be interpreted manually
before they can be judged.

=item * View C<TZ$SOURCE>

Shows all lines of PL/SQL stored in the database that use time zone
C<keywords>. This view filters some of the standard Oracle schemas like
SYS because these schemas contain source code, which use time zones. However,
it does not mean that the database uses time zone functionality. When these
functions are used, other time zone functionality must be used in the database,
and that is found either through this view or other views.

Similar to C<TZ$ARGUMENTS>, if your application stores PL/SQL objects in the
C<SYS> schema (or other standard schemas), adjust the view so that these can be
checked, but discard Oracle-standard objects.

This view should be handled with care. Firstly it is a simple "like" query
based on the C<DBA_SOURCE> view, which can be large, so this view can be
slow. Also, because these keywords can be used in other settings, the
output from this view should be handled with care since it might contain some
"false-positives".

An example of such a false positive is the keyword C<TIMESTAMP>. This can be
used to indicate a time stamp only without a time zone, which is not affected by
time zone changes. However, it can be used in a "time zone aware" context also.
Therefore, as stated, you must check the output from this view manually before
conclusions can be drawn. C<TZ$SOURCE> contains a C<TEXT> column, which
contains the line of source text in a PL/SQL block that contains one of the TZ
keywords. Based on this complete line, you can judge whether this is using time
zone aware data, or whether this is a false positive.

=item * Function C<TZ$NAMED_TSTZ_TAB_COLS_FN>

=item * Function C<TZ$NAMED_TSTZ_VW_COLS_FN>

=item * Type C<TSTZ_NAMED_TABLE>

=item * Type C<TSTZ_NAMED_TYPE>

=back

It is based on My Oracle Support document ID 412971.1 I<Assess Time Zone usage
in a Database>.

=cut

macro test_views
{echo tput('bold'),'Time Zone Usage Views',tput('off'),"\012"

 # Ask confirmation for object replacement
 set $sql
 {SELECT owner || '.' || object_name
 " FROM dba_objects
 " WHERE  object_name IN (
 "          'TZ$TSLTZ_TAB_COLS',
 "          'TZ$TSLTZ_VW_COLS',
 "          'TZ$ARGUMENTS',
 "          'TZ$SOURCE',
 "          'TZ$DBTIMEZONE',
 "          'TZ$NAMED_TSTZ_TAB_COLS',
 "          'TZ$NAMED_TSTZ_VW_COLS',
 "          'TZ$OVERVIEW',
 "          'TZ$NAMED_TSTZ_TAB_COLS_FN',
 "          'TZ$NAMED_TSTZ_VW_COLS_FN',
 "          'TSTZ_NAMED_TABLE',
 "          'TSTZ_NAMED_TYPE');
 }
 if grepSql($sql,'^SYS.')
 {echo "Objects to replace:\012  ",join("\012  ",last)
  var ${RUN.REQUEST.T_SETUP} = 'views'
  call requestInput('TMdst')
  if !${RUN.REQUEST.B_VIEWS}
   return
 }

 # Create the views
 set $sql
 {CREATE OR REPLACE VIEW tz$tsltz_tab_cols AS
 " SELECT c.owner,c.table_name,c.column_name
 "  FROM dba_tab_cols c,
 "       dba_objects o
 "  WHERE c.data_type LIKE '%WITH LOCAL TIME ZONE'
 "    AND c.owner = o.owner
 "    AND c.table_name = o.object_name
 "    AND o.object_type = 'TABLE'
 "/
 "CREATE OR REPLACE VIEW tz$tsltz_vw_cols AS
 " SELECT c.owner,c.table_name,c.column_name
 "  FROM dba_tab_cols c,
 "       dba_objects o
 "  WHERE c.data_type LIKE '%WITH LOCAL TIME ZONE'
 "    AND c.owner = o.owner
 "    AND c.table_name = o.object_name
 "    AND o.object_type = 'VIEW'
 "/
 "CREATE OR REPLACE VIEW tz$arguments AS
 " SELECT u.name owner,
 "        NVL2(a.procedure$,o.name,NULL) package_name,
 "        NVL(a.procedure$,o.name) object_name,
 "        a.argument argument_name,
 "        a.pls_type
 "  FROM sys.argument$ a,
 "       sys.obj$ o,
 "       sys.user$ u
 "  WHERE o.obj# = a.obj#
 "    AND u.user#=o.owner#
 "    AND u.name NOT IN ('SYS','SYSMAN','XDB','MDSYS','OLAPSYS','ODM','DBSNMP',
 "                       'DMSYS','CTXSYS','WMSYS','RMAN','WKSYS','SDPRO',
 "                       'ORDSYS','EXFSYS','PERFSTAT')
 "    AND UPPER(pls_type) LIKE '%TIME ZONE'
 "/
 "CREATE OR REPLACE VIEW tz$source AS
 " SELECT owner, name, type, line, text
 "  FROM dba_source
 "  WHERE owner NOT IN ('SYS','SYSMAN','XDB','MDSYS','OLAPSYS','ODM','DBSNMP',
 "                      'DMSYS','CTXSYS','WMSYS','RMAN','WKSYS','SDPRO',
 "                      'ORDSYS','EXFSYS','PERFSTAT')
 "    AND TRIM(REPLACE(text,CHR(9),'')) NOT LIKE '--%'
 "    AND (UPPER(text) LIKE '%TIMESTAMP%'
 "      OR UPPER(text) LIKE '%FROM_TZ%'
 "      OR UPPER(text) LIKE '%AT TIME ZONE%'
 "      OR UPPER(text) LIKe '%EXTRACT%'
 "      OR UPPER(text) LIKE '%CURRENT_DATE%'
 "      OR UPPER(text) LIKE '%TZ_OFFSET%')
 "/
 "CREATE OR REPLACE VIEW tz$dbtimezone AS
 " SELECT dbtimezone database_tz
 "  FROM dual
 "/
 "DROP FUNCTION tz$named_tstz_tab_cols_fn
 "/
 "DROP FUNCTION tz$named_tstz_vw_cols_fn
 "/
 "DROP TYPE tstz_named_table
 "/
 "CREATE OR REPLACE TYPE tstz_named_type AS OBJECT (
 " owner VARCHAR2(128),
 " table_name VARCHAR2(128),
 " column_name VARCHAR2(128),
 " tstz_named_count NUMBER(10));
 "/
 "CREATE OR REPLACE TYPE tstz_named_table AS TABLE OF tstz_named_type;
 "/
 "CREATE OR REPLACE FUNCTION tz$named_tstz_tab_cols_fn
 " RETURN tstz_named_table PIPELINED
 "AS
 " newrec tstz_named_type;
 " CURSOR c1 IS
 "  SELECT c.owner,
 "         c.table_name,
 "         c.column_name
 "   FROM dba_tab_cols c,
 "        dba_objects o
 "   WHERE c.data_type LIKE '%WITH TIME ZONE'
 "     AND c.owner = o.owner
 "     AND c.table_name = o.object_name
 "     AND o.object_type = 'TABLE'
 "   ORDER BY owner, table_name;
 " stmt VARCHAR2(2000);
 " nr NUMBER(10);
 "BEGIN
 " FOR r1 IN c1 LOOP
 "  stmt := 'SELECT COUNT(*) FROM "' || r1.owner || '"."' || r1.table_name;
 "  stmt := stmt || '" WHERE TO_CHAR("' || r1.column_name || '", ''TZR'')';
 "  stmt := stmt || ' not like ''%:%''';
 "  stmt := stmt || \
            ' AND TO_CHAR("' || r1.column_name || '", ''TZR'') <> ''GMT''';
 "  stmt := stmt || \
            ' AND TO_CHAR("' || r1.column_name || '", ''TZR'') <> ''UTC''';
 "  EXECUTE IMMEDIATE stmt INTO nr;
 "  IF nr > 0 THEN
 "   newrec := tstz_named_type(r1.owner,r1.table_name,r1.column_name,nr);
 "   PIPE ROW ( newrec );
 "  END IF;
 " END LOOP;
 " RETURN;
 "END;
 "/
 "CREATE OR REPLACE VIEW tz$named_tstz_tab_cols AS
 " SELECT *
 "  FROM TABLE(TZ$NAMED_TSTZ_TAB_COLS_FN)
 "/
 "CREATE OR REPLACE FUNCTION tz$named_tstz_vw_cols_fn
 " RETURN tstz_named_table PIPELINED
 "AS
 " newrec tstz_named_type;
 " CURSOR c1 is SELECT c.owner, c.table_name, c.column_name
 "               FROM dba_tab_cols c, dba_objects o
 "               WHERE c.data_type like '%WITH TIME ZONE'
 "                 AND c.owner=o.owner
 "                 AND c.table_name = o.object_name
 "                 AND o.object_type = 'VIEW'
 "               ORDER BY owner, table_name;
 " stmt VARCHAR2(2000);
 " nr NUMBER(10);
 "BEGIN
 " FOR r1 IN c1 LOOP
 "  stmt := 'SELECT COUNT(*) FROM "' || r1.owner || '"."' || r1.table_name;
 "  stmt := stmt || '" WHERE TO_CHAR("' || r1.column_name || '", ''TZR'')';
 "  stmt := stmt || ' not like ''%:%''';
 "  stmt := stmt || \
            ' AND TO_CHAR("' || r1.column_name || '", ''TZR'') <> ''GMT''';
 "  stmt := stmt || \
            ' AND TO_CHAR("' || r1.column_name || '", ''TZR'') <> ''UTC''';
 "  EXECUTE IMMEDIATE stmt INTO nr;
 "  IF nr > 0 THEN
 "   newrec := tstz_named_type(r1.owner,r1.table_name,r1.column_name,nr);
 "   PIPE ROW ( newrec );
 "  END IF;
 " END LOOP;
 " RETURN;
 "END;
 "/
 "CREATE OR REPLACE VIEW tz$named_tstz_vw_cols AS
 "  SELECT * FROM TABLE(TZ$NAMED_TSTZ_VW_COLS_FN)
 "/
 "CREATE OR REPLACE VIEW tz$overview (usage_type,value,description) AS
 " SELECT 'DBTIMEZONE',
 "        database_tz,
 "        'Database Time Zone, if this is an ''offset'' not affected by DST'
 "  FROM tz$dbtimezone
 " UNION
 " SELECT 'NAMED_TSTZ_TABLE_USE_NONSYS',
 "         TO_CHAR(COUNT(*)),
 "         'Number of TSTZ columns using named time zones in tables \
            not owned by SYS'
 "  FROM tz$named_tstz_tab_cols
 "  WHERE owner <> 'SYS'
 " UNION
 " SELECT 'NAMED_TSTZ_TABLE_USE_SYS',
 "         TO_CHAR(COUNT(*)),
 "         'Number of TSTZ columns using named time zones in tables \
            owned by SYS'
 "  FROM tz$named_tstz_tab_cols
 "  WHERE owner = 'SYS'
 " UNION
 " SELECT 'TSLTZ_TABLE_USE',
 "        TO_CHAR(COUNT(*)),
 "        'Number of TSLTZ columns used in tables'
 "  FROM tz$tsltz_tab_cols
 " UNION
 " SELECT 'NAMED_TSTZ_VIEW_USE_NONSYS',
 "        TO_CHAR(COUNT(*)),
 "        'Number of TSTZ columns using named time zones in views \
           not owned by SYS'
 "  FROM tz$named_tstz_vw_cols
 "  WHERE owner <> 'SYS'
 " UNION
 " SELECT 'NAMED_TSTZ_VIEW_USE_SYS',
 "        TO_CHAR(COUNT(*)),
 "        'Number of TSTZ columns using named time zones in views \
           owned by SYS'
 "  FROM tz$named_tstz_vw_cols
 "  WHERE owner = 'SYS'
 " UNION
 " SELECT 'TSLTZ_VIEW_USE',
 "        TO_CHAR(COUNT(*)),
 "        'Number of TSLTZ columns used in views'
 "  FROM tz$tsltz_vw_cols
 " UNION
 " SELECT 'TZ_ARGUMENTS',
 "        TO_CHAR(COUNT(*)),
 "        'Number of PL/SQL objects with time zone arguments'
 "  FROM tz$arguments
 "/
 "SELECT usage_type || '|' || value || '|' || description
 " FROM tz$overview
 "/
 }
 var $fmt = '%-27s %6s %s'
 debug "Creating the views and getting an usage overview ... (can take time)"
 dump sprintf($fmt,'Type','Value','Description')
 loop $lin (grepSql($sql,'\|'))
 {var ($typ,$val,$dsc) = split('\|',$lin)
  var $off = rindex($dsc,' ',44)
  dump sprintf($fmt,$typ,$val,substr($dsc,0,$off))
  incr $off
  if substr($dsc,$off)
   dump sprintf($fmt,'','',last)
 }
 echo "\012\
       Use My Oracle Support document ID 412971.1 to analyze the contents of \
       these views and determine if you must apply a patch for the DST \
       functionality. Also refer to My Oracle Support document ID 359145.1 'Do \
       I need a patch?' for clarifications."
}

# Select the database
if ${SET.DB.DB.I_DB}
{# Extract the connection information
 var $db = last
 var $sid = $db->get_first('T_ORACLE_SID')
 var $usr = $db->get_first('T_USER')
 var $dba = $db->get_first('B_SYSDBA')
 if !and($sid,$usr)
 {echo "Error: \001The current setup does not contain information to connect \
                   to a database."
  return
 }
 if !$dba
 {echo "Error: \001AS SYSDBA is required to run most scripts."
  return
 }
 call setSqlTarget($db)
}
else
{var ${RUN.REQUEST.T_SETUP} = 'db'
 call requestInput('TMdst')
 if ${RUN.REQUEST.I_DB}
  call setSqlTarget(last)
 else
 {echo "Error: \001Those tools require a database connection. Configure the \
                   environment accordingly."
  return
 }
}

# Test the database connectivity
var (undef,$sid,$usr) = getSqlInfo()
echo 'Database: ',$sid
echo 'User:     ',$usr,' AS SYSDBA'
if testSql()
{echo "Error: \001The database to be analyzed does not appear to be \
                  accessible:\012",getSqlMessage()
 return
}

# Select the tools
var ${RUN.REQUEST.T_SETUP} = 'select'
call requestInput('TMdst')
var $sel = ${RUN.REQUEST.W_TOOL}
if compare('eq',$sel,'Client')
 call test_client()
elsif compare('eq',$sel,'JVM')
 call test_jvm()
elsif compare('eq',$sel,'utltzuv2')
 call test_utltzuv2()
elsif compare('eq',$sel,'Views')
 call test_views()

echo "\012For more information on Daylight Saving Time aspects, consult:\012\
      - My Oracle Support document ID 412160.1"

=head1 NOTES

=over 2

=item *

All the tests require RDA to connect as a SYSDBA user to the database.

=back

=begin credits

=over 10

=item RDA 4.7:  Emiel Ramakers.

=back

=end credits

=head1 COPYRIGHT NOTICE

Copyright (c) 2002, 2016, Oracle and/or its affiliates. All rights reserved.

=head1 TRADEMARK NOTICE

Oracle and Java are registered trademarks of Oracle and/or its
affiliates. Other names may be trademarks of their respective owners.

=cut
