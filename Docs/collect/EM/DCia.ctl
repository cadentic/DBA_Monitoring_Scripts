# DCia.ctl:220:Collects Intelligent Agent Information
# $Id: DCia.ctl,v 1.5 2013/12/18 13:20:35 RDA Exp $
# ARCS: $Header: /home/cvs/cvs/RDA_8/src/scripting/lib/collect/EM/DCia.ctl,v 1.5 2013/12/18 13:20:35 RDA Exp $
#
# Change History
# 20131217  KRA  Fix spell.

=head1 NAME

EM:DCia - Collects Intelligent Agent Information

=head1 DESCRIPTION

This module collects the Intelligent Agent information. This module applies
to versions earlier than Oracle Database 10g only.

The following reports can be generated and are regrouped under C<Intelligent
Agent>:

=cut

echo tput('bold'),'Processing EM.IA module ...',tput('off')

# Initialization
var $ORACLE_HOME = ${SET.RDA.BEGIN.D_ORACLE_HOME:''}
var $TAIL        = ${DFT.N_TAIL:1000}

var $TOC = '%TOC%'
var $TOP = '[[#Top][Back to top]]'
pretoc '1:Intelligent Agent'

# Load the common macros
run RDA:library()

=head2 Configuration Files

Collects all files related to Intelligent Agent.

=cut

debug ' Inside IA module, about to gather IA files'
pretoc '2:Configuration Files'
var $dir = getEnv('TNS_ADMIN',catDir($ORACLE_HOME,'network','admin'))
loop $fil (grepDir($dir,'^snmp.*\.ora$','in'))
 call cat_report($dir,$fil)
if isVms()
 call cat_report($dir,'oratab.ora')
call cat_report(catDir($ORACLE_HOME,'network','agent'),'services.ora')
call cat_report(catDir($ORACLE_HOME,'network','agent'),'dbsnmp.ver')
call cat_report(catDir($ORACLE_HOME,'network','agent','config'),'nmxw.ora')
call cat_report(catDir($ORACLE_HOME,'network','agent','config'),'oapps.ora')
call cat_report(catDir($ORACLE_HOME,'network','trace'),'dbsnmp.nohup')

var $ref = catFile($ORACLE_HOME,'network','admin','snmp_rw.ora')
if ?testFile('r',$ref)
{var $dir = catDir($ORACLE_HOME,'network','log')
 if value(grepFile($ref,'^dbsnmp\.trace_directory','fi'))
  var $dir = last
 loop $fil (grepDir($dir,'.','t'))
 {next match($fil,'^\.{1,2}$')
  break
 }
 loop $str (grepFile($ref,'^dbsnmp\.trace_file','i'))
 {next match($str,'dbsnmp\.trace_filecnt',true)
  break
 }
 if value($str)
  var $fil = last
 call cat_report($dir,$fil)
}
unpretoc

if !isTocCreated()
 echo 'No Oracle Intelligent Agent found in use on this Oracle Home'

=head2 Log files

Collects last lines of log files.

=cut

debug ' Inside IA module, about to gather log files'
pretoc '2:Log Files'
var $dir = catDir($ORACLE_HOME,'network','log')
loop $nam (grepDir($dir,'^(agent|dbsnmp|nmi)','in'))
 call tail_report($dir,$nam,$TAIL)
unpretoc

=head2 status - Intelligent Agent Status

Gets the Intelligent Agent (IA) status.

From Oracle 9i on, F<lsnrctl> is no longer the interface to IA and is replaced
by F<agentctl>. There may not be a database available on this system, so Oracle
cannot guarantee the version information from the database. Therefore, RDA
checks to see if F<agentctl> exists; if it exists, then it is used. Otherwise,
RDA uses F<lsnrctl>.

C<lsnrctl status> can hang, thus causing the script to hang. To prevent this,
the command execution is limited to 30 seconds when C<alarm> is supported in
the Perl version.

=cut

debug ' Inside IA module, do status of Intelligent Agent'
echo 'Processing Intelligent Agent status'
report status
if isVms()
{write '---+!! Intelligent Agent Status Information'
 write $TOC

 # Check the account can do a show process
 var ($prv) = command(concat('write sys$output f$privilege("WORLD")'))
 var $prv = match($prv,'TRUE',true)

 # Get AGENTWORK process information
 write '---+ AGENTWORK Process'
 prefix
  write '<verbatim>'
 loop $lin (grepCommand('show system','ORA_AGENTWORK','i'))
 {var $pid = field('\s+',0,$lin)
  write $lin
 }
 if hasOutput(true)
 {write '</verbatim>'
  if $prv
   call writeCommand(concat('show process/identification=',$pid))
  else
   write 'IA WORK process found, but could not issue the SHOW PROCESS command \
          due to lack of privileges.%BR%'
 }
 else
  write 'IA WORK process not found.%BR%'
 write $TOP

 # Get ORACOMM process information
 write '---+ COMM Process'
 prefix
  write '<verbatim>'
 loop $lin (grepCommand('show system','ORACOMM','i'))
 {var $pid = field('\s+',0,$lin)
  write $lin
 }
 if hasOutput(true)
 {write '</verbatim>'
  if $prv
   call writeCommand(concat('show process/identification=',$pid))
  else
   write 'IA COMM process found, but could not issue the SHOW PROCESS command \
          due to lack of privileges.%BR%'
 }
 else
  write 'IA COMM process not found.%BR%'
 write $TOP

 # Get IA Status
 if loadCommand('agentctl status')
 {write '---+ AGENTCTL STATUS'
  call writeLastFile()
  write $TOP
 }
 elsif loadCommand('lsnrctl dbsnmp_status')  # 8.1
 {write '---+ LSNRCTL DBSNMP_STATUS'
  call writeLastFile()
  write $TOP
 }
}
else
{prefix
  write '---+!! Status of the Intelligent Agent'
 var $err = 0
 if grepDir(catDir($ORACLE_HOME,'bin'),'^agentctl(\.exe)?$','i')
 {var $agt = 1
  var $ret = loadCommand('agentctl status',true)
 }
 else
 {var $agt = 0
  var $ret = loadCommand('lsnrctl dbsnmp_status',true)
  var $err = grepLastFile('undefined command "dbsnmp_status"')
 }
 if $err
  unprefix
 elsif $ret
  call writeLastFile()
 elsif status()
 {echo '  Status Check for Intelligent Agent timed out'
  write 'Could not get Intelligent Agent status, command did not complete.%BR%\
         Status Check for Intelligent Agent cancelled.'
 }
}
if isCreated(true)
 toc '2:[[',getFile(),'][rda_report][Intelligent Agent Status]]'

=for stopwords dbsnmp

=head2 processes - dbsnmp Process Status

Checks for the existence of the C<dbsnmp> process.

=cut

if grepLastFile(cond($agt,'^Agent is running',\
                          'subagent is already running'))
{debug ' Inside IA module, get dbsnmp process'
 report processes
 var $TTL = '---+ Associated Intelligent Agent Process Data'

 # Get the ps command format
 var $PS_EF
 run &{check(getOsName(),'aix',        'OS:OSaix',\
                         'darwin',     'OS:OSdarwin',\
                         'dec_osf',    'OS:OSosf',\
                         'dynixptx',   'OS:OSptx',\
                         'hpux',       'OS:OShpux',\
                         'linux',      'OS:OSlinux',\
                         'solaris',    'OS:OSsunos',\
                         cond(isUnix(),'OS:OSunix'))}('PS')

 # Grep the processes
 prefix
 {write $TTL
  write '<verbatim>'
 }
 if loadCommand($PS_EF)
 {loop $lin (getLines(0,0),grepLastFile('dbsnmp','i'))
   write $lin
 }
 if hasOutput(true)
  write '</verbatim>'
 else
 {write $TTL
  write 'dbsnmp process not found.'
 }
 toc '2:[[',getFile(),'][rda_report][dbsnmp Process Status]]'
}

=head1 SEE ALSO

L<OS:OSaix|collect::OS:OSaix>,
L<OS:OSdarwin|collect::OS:OSdarwin>,
L<OS:OShpux|collect::OS:OShpux>,
L<OS:OSlinux|collect::OS:OSlinux>,
L<OS:OSosf|collect::OS:OSosf>,
L<OS:OSptx|collect::OS:OSptx>,
L<OS:OSsunos|collect::OS:OSsunos>,
L<OS:OSunix|collect::OS:OSunix>,
L<OS:OSvms|collect::OS:OSvms>,
L<OS:OSwin32|collect::OS:OSwin32>,
L<RDA:library|collect::RDA:library>

=head1 COPYRIGHT NOTICE

Copyright (c) 2002, 2016, Oracle and/or its affiliates. All rights reserved.

=head1 TRADEMARK NOTICE

Oracle and Java are registered trademarks of Oracle and/or its
affiliates. Other names may be trademarks of their respective owners.

=cut
