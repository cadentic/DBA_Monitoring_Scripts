# TMcred.ctl: Manages Credentials
# $Id: TMcred.ctl,v 1.13 2015/05/20 17:50:08 RDA Exp $
# ARCS: $Header: /home/cvs/cvs/RDA_8/src/scripting/lib/collect/TOOL/TMcred.ctl,v 1.13 2015/05/20 17:50:08 RDA Exp $
#
# Change History
# 20150515  KRA  Improve the documentation.

=head1 NAME

TMcred - Manages Credentials

=head1 DESCRIPTION

This module manages credentials stored in a wallet.

=cut

use Access

options d:

section tool
call unshift(@{CUR.W_NEXT},'test')

section test

# Validate the prerequisite
if missing($opt{'d'})
 return
if !?$dir = testDir('d',catDir($opt{'d'}))
 return
if !?$sub = testDir('d',catDir($dir,'da'))
 return
if ?testFile('l',$sub)
 return
var @sta = getStat($sub)
if expr('&',$sta[2],0o7077)
 return
loop $pth (catFile($sub,'ewallet.p12'),catFile($sub,'ks.properties'))
{if !?testFile('f',$pth)
  return
 if ?testFile('l',$pth)
  return
 var @sta = getStat($pth)
 if expr('&',$sta[2],0o7077)
  return
}
if !?nvl(testFile('f',catFile(${ENV.JAVA_HOME},'bin','java')),\
         testFile('f','/usr/bin/java'))
 return
var ($cmd,@jar) = (lastTestCommand())
loop $jar ('da/lib/dacore.jar','da/lib/oraclepki.jar')
{if !?testFile('f',getGroupFile('D_RDA',$jar))
  return
 call push(@jar,getNativePath(last))
}
var $cmd = join(' ',$cmd,'-cp',quote(join(cond(isUnix(),':',';'),@jar)),\
                    'oracle/sysman/da/rda/Rda2Cred','-M')

# Define the request macro
macro do_request
{var ($cmd,$act,$hsh) = @arg

 output | $cmd
 if ${COL.TRACE.N_CRED}
  write $key,"lvl='",last,"'"
 loop $key (keys($hsh))
 {if ?$hsh->{$key}
   write $key,"='",\
     join('',map(unpack('c*',last),code(sprintf('%04o',last)))),"'"
 }
 write $act
 close
}

# Execute the request
eval
{var $act = shift(@arg)
 if compare('eq',$act,'add')
 {loop $uid (@arg)
   call do_request($cmd,'/ADD',\
     {crd=>${AS.STRING:chomp(pack('u',\
                             askPassword("Enter password for ${VAR.uid}:")))},\
      dir=>getNativePath($dir),\
      uid=>$uid})
 }
 elsif compare('eq',$act,'delete')
 {loop $uid (@arg)
   call do_request($cmd,'/DELETE',\
     {dir=>getNativePath($dir),\
      uid=>$uid})
 }
 elsif compare('eq',$act,'init')
  call do_request($cmd,'/INIT',\
    {dir=>getNativePath($dir)})
 elsif compare('eq',$act,'upgrade')
  call do_request($cmd,'/UPGRADE',\
    {dir=>getNativePath($dir)})
 elsif compare('eq',$act,'version')
  echo command(replace($cmd,'-M$','-V'))
}

=head1 COPYRIGHT NOTICE

Copyright (c) 2002, 2016, Oracle and/or its affiliates. All rights reserved.

=head1 TRADEMARK NOTICE

Oracle and Java are registered trademarks of Oracle and/or its
affiliates. Other names may be trademarks of their respective owners.

=cut
