# TMdb.ctl: Tests Local Oracle Database Access
# $Id: TMdb.ctl,v 1.10 2015/04/24 11:26:40 RDA Exp $
# ARCS: $Header: /home/cvs/cvs/RDA_8/src/scripting/lib/collect/TOOL/TMdb.ctl,v 1.10 2015/04/24 11:26:40 RDA Exp $
#
# Change History
# 20150424  KRA  Improve the documentation.

=head1 NAME

TMdb - Tests Oracle Database Access

=head1 DESCRIPTION

=cut

use Item

options t:

section tool
call unshift(@{CUR.W_NEXT},'test')

section test

echo tput('bold'),'Processing local database test module ...',tput('off')

if findItem('SQ','.',$opt{'t'})
 call setCurrent($dft = addTarget(last))
elsif ${SET.DB.DB.I_DB}
 call setCurrent($dft = addTarget(last))
elsif ?testDir('d',${ENV.ORACLE_HOME})
 call setCurrent($dft = addTarget('SQ_TEST',\
   {B_LOCAL      =>true,\
    D_ORACLE_HOME=>last,\
    T_ORACLE_SID =>${ENV.ORACLE_SID}}))
else
 call setCurrent($dft = addTarget('SQ_TEST',\
   {T_ORACLE_SID =>${ENV.ORACLE_SID}}))
var $def = ${CUR.O_TARGET}->get_definition

=pod

It looks for F<sqlplus> in the command path and displays the corresponding path
when found.

=cut

echo 'Looking for sqlplus ...'
macro check_sqlplus
{var ($cmd,$env) = @arg
 if isVms()
  return replace(testCommand(concat($cmd,' -V')),' -V$')
 var $trc = ${COL.TRACE.N_TARGET}
 var $bkp = setContext($env,$trc)
 var $cmd = cond(isAbsolute($cmd),\
   replace(testCommand(concat(quote($cmd),' -V')),' -V$'),\
   findCommand($cmd))
 call restoreContext($bkp,$trc)
 return $cmd
}

if !check_sqlplus(${CUR.O_TARGET}->get_sqlplus)
{call displayText('TMdb:NoSqlplus',true)
 return
}
echo '  ',getNativePath(last)

=pod

It looks for F<oracle> in the command path and displays related information
(such as path, check sum, permissions, and size). Displayed information is
platform-specific.

=cut

echo 'Looking for oracle ...'
if ?findCommand('oracle',true)
{var $pgm = getNativePath(last)
 if ?findCommand('cksum')
  echo '  checksum: ',command(concat('cksum ',quote($pgm)))
 else
  echo '  ',$pgm
 if isUnix()
  echo '  ',command(concat('ls -l ',quote($pgm)))
}

=pod

It checks the C<D_ORACLE_HOME> and C<T_ORACLE_SID> settings for a database
connection target. A warning is issued when the C<TWO_TASK> environment
variable is found.

=cut

echo 'Checking settings ...'

if getEnv('TWO_TASK')
 echo '  TWO_TASK=',last,'   ',\
  tput('reverse'),'(but will be ignored)',tput('off')

if $dft
{if ?$ORACLE_HOME = $def->get_prime('D_ORACLE_HOME')
  echo '  D_ORACLE_HOME=',last

 if ?$ORACLE_SID = $def->get_prime('T_ORACLE_SID')
  echo '  T_ORACLE_SID=',last
 else
 {call displayText('TMdb:NoOracleSID',true)
  return
 }
}

=pod

It executes a simple query in the database with F<sqlplus>.

=cut

echo 'Testing sqlplus access to the database connection ...'

var @inf = getSqlInfo()
echo "  using '",cond(length($inf[2]),$inf[2],'/'),$inf[4],"'"

call ${CUR.O_TARGET}->set_trace(setTrace())
if testSql()
{echo getSqlMessage()
 call displayText('TMdb:ConnectionError',true,sid=>$ORACLE_SID)
 return
}
var @inf = getSqlInfo()

echo tput('reverse'),'Successful access to the database',tput('off')

=head1 COPYRIGHT NOTICE

Copyright (c) 2002, 2016, Oracle and/or its affiliates. All rights reserved.

=head1 TRADEMARK NOTICE

Oracle and Java are registered trademarks of Oracle and/or its
affiliates. Other names may be trademarks of their respective owners.

=cut
