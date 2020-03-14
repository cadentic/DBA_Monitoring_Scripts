# TMvms.ctl: Verifies Current User Environment for VMS
# $Id: TMvms.ctl,v 1.5 2013/10/30 07:18:56 RDA Exp $
# ARCS: $Header: /home/cvs/cvs/RDA_8/src/scripting/lib/collect/TOOL/TMvms.ctl,v 1.5 2013/10/30 07:18:56 RDA Exp $
#
# Change History
# 20130617  MSC  Improve messages.

=head1 NAME

TOOL:TMvms - Verifies Current User Environment for VMS

=head1 DESCRIPTION

This test module determines if the current VMS account has the required
settings, and that the current logicals and symbols are a valid Oracle Server
environment. If not, you cannot run the RDA procedure.

=head1 ERROR SECTION

Any failure means that the RDA script cannot proceed.

=cut

section tool
call unshift(@{CUR.W_NEXT},'test')

section test

if !isVms()
 die 'Not for VMS. Tests aborted'

echo 'Verifying current user environment...'
echo

# Define common macros
macro f_getdvi
{var ($val) = command(concat('write sys$output f$getdvi("',$arg[0],'","',\
                             $arg[1],'")'))
 return $val
}
macro f_getjpi
{var ($val) = command(concat('write sys$output f$getjpi("","',$arg[0],'")'))
 return $val
}
macro f_getsyi
{var ($val) = command(concat('write sys$output f$getsyi("',$arg[0],'")'))
 return $val
}
macro f_privilege
{var ($val) = command(concat('write sys$output f$privilege("',$arg[0],'")'))
 return match($val,'TRUE',true)
}
macro f_search
{var ($val) = command(concat('write sys$output f$search("',$arg[0],'")'))
 return $val
}
macro f_trnlnm
 return getEnv($arg[0])

=pod

Checks VMS version.

=cut

if match(f_getsyi('VERSION'),'^V6')
 echo "ERROR: \001Remote Diagnostic Agent uses OpenVMS version 7.x features.\
              \012RDA cannot run for VMS version 6.x.\
              \012\040"

=pod

Checks if TCPIP Services for OpenVMS is installed and running.

=cut

var $flg = true
if or(f_search('SYS$SYSTEM:TCPIP$UCP.EXE'),f_search('SYS$SYSTEM:UCX$UCP.EXE'))
{if and(f_getdvi('_BG0','EXISTS'),f_getdvi('_BG0','MNT'))
  var $flg = false
}
if $flg
 echo "ERROR: \001TCPIP Services for OpenVMS not installed or not running.\
              \012Some network information will not be collected.\
              \012\040"

=pod

UIC check (Taken from F<ORACLEINS.COM>).

=cut

if expr('le',f_getjpi('GRP'),f_getsyi('MAXSYSGROUP'))
 echo "ERROR: \001You are attempting to use Oracle Server with an account \
                  that is a member of the system group. Oracle requires that \
                  all accounts which administer Oracle Server have UICs above \
                  the highest system UIC (see the SYSGEN parameter \
                  MAXSYSGROUP).\012\
              \012Accounts with UICs equal to or less than MAXSYSGROUP are \
                  not allowed to use ORACLE DBA commands or open Oracle \
                  datafiles.\
              \012\040"

=pod

Checks basic Oracle Server environment (Taken from F<PREFLIGHTVMS.COM>).

=cut

var $root_lnm =    f_trnlnm('ORA_ROOT')
var $sqlplus_lnm = f_trnlnm('ORA_SQLPLUS')
var $rdbms_lnm =   f_trnlnm('ORA_RDBMS')

if !and($root_lnm,$sqlplus_lnm,$rdbms_lnm)
 echo "ERROR: \001Basic Oracle logicals are not present.\
              \012If it is available, then execute ORAUSER.COM to establish \
                  the Oracle environment.\012\040"

=pod

Additional Oracle Server environment checks.

=cut

var $ora_rootdir_lnm = f_trnlnm('ORA_ROOTDIR')
var $oracle_home_lnm = f_trnlnm('ORACLE_HOME')	# New to Oracle8i
var $ora_sid_lnm =     f_trnlnm('ORA_SID')
var $oracle_sid_lnm =  f_trnlnm('ORACLE_SID')	# New to Oracle8i
var $ora_install_lnm = f_trnlnm('ORA_INSTALL')
var $ora_exe_lnm =     f_trnlnm('ORA_EXE')

if !and((or($ora_rootdir_lnm,$oracle_home_lnm)),$ora_install_lnm,$ora_exe_lnm)
 echo "ERROR: \001Oracle Server home, Install and/or SID logicals are not \
                  setup.\
              \012If it is available, then execute ORAUSER.COM to establish \
                  the Oracle environment.\
              \012\040"
elsif !or($ora_sid_lnm,$oracle_sid_lnm)
{echo "WARNING: \001Oracle SID logicals are not present.\
                \012No database information will be collected.\
                \012\040"
 var $oracle_sid_lnm = 'NONE'
}

# Set Oracle SID symbol using SID logicals from above; 1 must be nonblank.
if $ora_sid_lnm
 var $sid = $ora_sid_lnm
else
 var $sid = $oracle_sid_lnm

=pod

Checks rights/identifiers.

=cut

var $cur = f_getjpi('RIGHTSLIST')
if !match($cur,concat('ORA_(',$sid,'_)?DBA'))
 echo "WARNING: \001This account does not have the ORA_DBA or ORA_<sid>_DBA' \
                    identifier. Make sure you have the password to the \
                    Oracle Server SYSTEM account, otherwise, the RDA script \
                    will not be able to gather internal database information.\
                \012\040"

=head1 WARNINGS SECTION

RDA can proceed but with limited functionality.

Checks if C<DECC$FILE_SHARING> value is set to C<ENABLE>.

=cut

if !match(getEnv('DECC$FILE_SHARING'),'^ENABLE$',true)
 echo "WARNING: \001RDA will not able to perform some collections unless the \
                    logical DECC$FILE_SHARING is not set to ENABLE.\
                \012\040"

=pod

Checks privileges for an Oracle Admin account.

=cut

if !and(f_privilege('CMKRNL'),f_privilege('GROUP'),f_privilege('GRPNAM'),\
        f_privilege('IMPERSONATE'),f_privilege('LOG_IO'),\
        f_privilege('NETMBX'),f_privilege('OPER'),f_privilege('PFNMAP'),\
        f_privilege('PRMGBL'),f_privilege('PRMMBX'),f_privilege('SHARE'),\
        f_privilege('SYSGBL'),f_privilege('SYSLCK'),f_privilege('SYSNAM'),\
        f_privilege('SYSPRV'),f_privilege('TMPMBX'),f_privilege('WORLD'))
 echo "WARNING: \001To administer ORACLE, you need following privileges: \
                    CMKRNL GROUP GRPNAM IMPERSONATE LOG_IO NETMBX OPER PFNMAP \
                    PRMGBL PRMMBX SHARE SYSGBL SYSLCK SYSNAM SYSPRV TMPMBX \
                    WORLD\
                \012\040"

=pod

Checks if the database instance is running (that is, C<ORA_E<lt>sidE<gt>_PMON>
process exists).

=cut

if $sid
{if !grepCommand('show system',concat('ORA_',$sid,'_PMON'))
  echo "WARNING: \001The database instance does not appear to active. The RDA \
                     will be unable to gather database information for Oracle \
                     instance ",$sid,\
                "\012\040"
}

=pod

Checks for C<OPER>, as it is required to run F<SYSMAN>.

=cut

if !f_privilege('OPER')
 echo "WARNING: \001This account does not have the OPER privilege, unable to \
                    run SYSMAN and obtain system parameters.\
                \012\040"

=pod

Checks for C<SYSLCK>, as it is required to run F<PRODUCT> command.

=cut

if !f_privilege('SYSLCK')
 echo "WARNING: \001This account does not have the SYSLCK privilege, cannot \
                    run the PRODUCT command to obtain the list of VMS patches.\
                \012\040"

=pod

Checks for C<WORLD>, as it is required to run F<SHOW> command.

=cut

if !f_privilege('WORLD')
 echo "WARNING: \001This account does not have the WORLD privilege, cannot \
                    run the SHOW PROCESS command to get information on other \
                    processes.\
                \012\040"

=pod

Checks for read access to UAF file.

=cut

var $fil = 'SYS$SYSTEM:SYSUAF.DAT'
if !f_search($fil)
 var $fil = f_trnlnm('SYSUAF')
if !?testFile('r',$fil)
 echo "WARNING: \001This account does not have access to the User \
                    Authorization File, unable to run AUTHORIZE and to obtain \
                    user and identifier information.\
                \012\040"

=pod

Checks for availability of the VMS ZIP program.

=cut

var $ZIP_available = true
if !testCommand('zip -h')
 echo "WARNING: \001Unable to detect a ZIP symbol to package collected data.\
                \012\040"

echo 'Verification completed.'
echo

=begin credits

=over 10

=item RDA 4.8:  Grant Hayden.

=back

=end credits

=head1 COPYRIGHT NOTICE

Copyright (c) 2002, 2016, Oracle and/or its affiliates. All rights reserved.

=head1 TRADEMARK NOTICE

Oracle and Java are registered trademarks of Oracle and/or its
affiliates. Other names may be trademarks of their respective owners.

=cut
