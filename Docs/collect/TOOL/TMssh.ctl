# TMssh.ctl: Tests Remote Connectivity and Operations
# $Id: TMssh.ctl,v 1.7 2015/05/13 17:29:55 RDA Exp $
# ARCS: $Header: /home/cvs/cvs/RDA_8/src/scripting/lib/collect/TOOL/TMssh.ctl,v 1.7 2015/05/13 17:29:55 RDA Exp $
#
# Change History
# 20150513  KRA  Improve the documentation.

=head1 NAME

TOOL:TMssh - Tests Remote Connectivity and Associated Operations

=head1 DESCRIPTION

This test module executes several tests to check remote connectivity and
operations:

=over 2

=cut

use Item,Remote

section tool
call unshift(@{CUR.W_NEXT},'test')

section test

echo tput('bold'),'Processing remote operation test module ...',tput('off')

call setRemoteTrace(setDebug())

# Define macros
macro chk_env
{var ($key,$flg) = @arg

 if getEnv($key,$flg)
 {var $val = last
  import $TTL
  if $TTL
  {echo $TTL
   var $TTL = undef
  }
  echo '  ',$key,'=',$val
 }
}

macro chk_ident
{echo "\012Agent identities:"
 loop $lin (command('ssh-add -l'))
  echo '  ',$lin
}

=item o

Tests which commands are available from the C<PATH> environment variable.

=cut

echo "\012Command Availability:"
loop $cmd ('rcp','remsh','rsh','scp','ssh','ssh-add','ssh-agent')
 echo sprintf("  %-12s \001%s",$cmd,nvl(findCommand($cmd),'(Not found)'))

=item o

Lists related files.

=cut

var $TTL = "\012Related files:"
var $hom = getEnv('HOME')
loop $fil ('/etc/hosts.equiv',\
           grepDir('/etc/ssh','.','npr'),\
           grepDir($hom,'^\.[rs]hosts$','inp'),\
           grepDir(catDir($hom,'.ssh'),'.','npr'))
{next !?testFile('f',$fil)
 if $TTL
  echo delete($TTL)
 echo '  ',$fil
}

=item o

Tests if an authentication agent is configured. When possible, it checks if
identities have been added.

=cut

var $TTL = "\012Check if an authentication agent is running"
call chk_env('SSH_AGENT_PID')
call chk_env('SSH_AUTH_SOCK')
if !?$agt = $TTL
 call chk_ident()

=item o

Lists default remote operation settings defined.

=cut

var ($rem,%set) = (${COL.REMOTE/i})
var $TTL = "\012Predefined remote operation settings:"
loop $req ($rem,$rem->get_childs)
{loop $key ($req->grep('(SSH|SCP)'))
 {var $nam = join('.',$req->get_path,$key)
  var $set{$nam} = $req->get_first($key)
  if $TTL
   echo delete($TTL)
  echo '  ',$nam,'=',$set{$key}
 }
}

=item o

Checks if an authentication agent has been started. When possible, it lists
agent identities.

=cut

if expr('>',initRemote(),0)
{var $TTL = "\012Check if an authentication agent has been started"
 call chk_env('SSH_AGENT_PID',true)
 call chk_env('SSH_AUTH_SOCK',true)
 if !?$TTL
  call chk_ident()
}

=item o

Tests which drivers are available for the remote connection.

=cut

echo "\012Driver Availability:"
loop $typ ('da','jsch','ssh','rsh')
 echo sprintf('  %4s %s',$typ,cond($[REM]->can_use($typ),'Available','-'))

=item o

Lists common settings modified by the remote operation initialization.

=cut

var $TTL = "\012Settings modified by the remote operation initialization:"
loop $req ($rem,$rem->get_childs)
{loop $key ($req->grep('(SSH|SCP)'))
 {var $nam = join('.',$req->get_path,$key)
  var $val = $req->get_first($key)
  next compare('eq',$val,$set{$nam})
  if $TTL
   echo delete($TTL)
  echo '  ',$nam,'=',$val
 }
}

=item o

Tests a remote command execution with different settings.

=cut

var $sep = ${RDA.T_LINE}
echo
echo $sep
echo 'Test a remote command'
echo $sep

var ($hst,$usr) = ()
if @arg
{var $hst = isHost(shift(@arg),true)
 var $usr = isUser(shift(@arg),true)
 var $rem = 'env'
}
if ?$hst
 var $usr = nvl($usr,isUser(${COL/REMOTE.T_USER},true),${RDA.T_LOGIN})
else
{call requestInput('TMssh')
 var $hst = ${RUN.REQUEST.T_HOSTNAME}
 var $rem = ${RUN.REQUEST.T_COMMAND:'env'}
 var $usr = ${RUN.REQUEST.T_USER:${COL.REMOTE.T_USER}}
}

# Initialize the remote session
var $ses = addRemoteSession('TST',$hst,$usr)
if needPassword('TST')
{call setPassword('host',$hst,$usr,askPassword(\
   concat('Enter ',$usr,'@',$hst,' password:')))
 if needPassword('TST')
 {echo 'Connection error connecting to ',$hst
  call endRemoteSession('TST')
  return
 }
}

echo "\012Check remote command execution with best driver"
echo 'Exit code: ',rexec('TST',$rem)

var %tbl = (\
  DA    => {typ => 'da'},\
  JSCH  => {typ => 'jsch'},\
  REMSH => {cmd => 'remsh',\
            typ => 'rsh'},\
  RSH   => {cmd => 'rsh',\
            typ => 'rsh'},\
  SSH   => {cmd => 'ssh',\
            opt => '-Cnq -o ConnectTimeout=30',\
            typ => 'ssh'},\
  SSH0  => {cmd => 'ssh',\
            dsc => 'SSH (no timeout)',\
            opt => '-Cnq',\
            typ => 'ssh'})
loop $typ ('DA','JSCH','SSH','SSH0','RSH','REMSH')
{if exists($tbl{$typ,'cmd'})
 {var $pre = uc($tbl{$typ,'typ'})
  next !?findCommand($tbl{$typ,'cmd'})
  var ${COL.REMOTE.F_${VAR.pre}_COMMAND/T} = last
  var ${COL.REMOTE.T_${VAR.pre}_OPTIONS/T} = $tbl{$typ,'opt'}
 }
 var ${COL.REMOTE.W_PREFIX/T} = $typ
 next $ses->set_type($tbl{$typ,'typ'})
 echo "\012Check remote command execution using ",nvl($tbl{$typ,'dsc'},$typ)
 echo 'Exit code: ',rexec('TST',$rem)
}
call endRemoteSession('TST')

=back

=head1 COPYRIGHT NOTICE

Copyright (c) 2002, 2016, Oracle and/or its affiliates. All rights reserved.

=head1 TRADEMARK NOTICE

Oracle and Java are registered trademarks of Oracle and/or its
affiliates. Other names may be trademarks of their respective owners.

=cut
