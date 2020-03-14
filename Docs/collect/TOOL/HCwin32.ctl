# HCwin32.ctl: Windows Specific Code
# $Id: HCwin32.ctl,v 1.4 2013/10/30 07:18:55 RDA Exp $
# ARCS: $Header: /home/cvs/cvs/RDA_8/src/scripting/lib/collect/TOOL/HCwin32.ctl,v 1.4 2013/10/30 07:18:55 RDA Exp $
#
# Change History
# 20130613  MSC  Fix quoting.

=head1 NAME

TOOL:HCwin32 - Submodule Specific to the Windows Operating System

=cut

# Make the module persistent
keep $KEEP_BLOCK,@SHARE_MACROS
var @SHARE_MACROS = ('get_df')

=head1 DESCRIPTION

This module determines the operating system version and its bit size.

The following macro is available:

=cut

import $OS_BIT,$OS_LVL,$OS_NAM,$OS_PLT,$OS_VER
var $reg = 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
var $OS_NAM = getRegValue($reg,'ProductName')
var $OS_VER = getRegValue($reg,'CurrentVersion')
var $OS_LVL = getReg64Value($reg,'CSDVersion','No Service Packs installed')
var $OS_PLT = 'Windows'
if getEnv('SYSTEMROOT')
 var $sys = last
else
 var ($sys) = command('echo %SystemRoot%')
if ?testDir('d',catDir($sys,'SysWOW64'))
 var $OS_BIT = 64
else
 var $OS_BIT = 32

=head2 get_df($dir)

This macro returns the number of free KiB on the file system containing the
specified directory.

=cut

if isCygwin()
{macro get_df
 {var ($dir) = @arg
  var ($lin) = grepCommand(concat('df -k ',quote($dir)),'\s\d+\%')
  if match($lin,'\s(\d+)\s+\d+\%\s')
   var ($siz) = last
  return $siz
 }
}
else
{macro get_df
 {var ($fil) = @arg
  loop $lin (reverse(grepCommand(concat('cmd /C dir /-C ',quote($fil)),\
                                 '^\s+\d+\s')))
  {if match($lin,'^\s+\d+\s.*\s(\d+)\s[^\d]+$')
   {var ($siz) = last
    var $siz = int(expr('/',$siz,1024))
    return $siz
   }
  }
  return undef
 }
}

=head1 COPYRIGHT NOTICE

Copyright (c) 2002, 2016, Oracle and/or its affiliates. All rights reserved.

=head1 TRADEMARK NOTICE

Oracle and Java are registered trademarks of Oracle and/or its
affiliates. Other names may be trademarks of their respective owners.

=cut
