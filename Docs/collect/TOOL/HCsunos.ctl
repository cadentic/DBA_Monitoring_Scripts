# HCsunos.ctl: Solaris Specific Code
# $Id: HCsunos.ctl,v 1.4 2014/04/07 13:37:34 RDA Exp $
# ARCS: $Header: /home/cvs/cvs/RDA_8/src/scripting/lib/collect/TOOL/HCsunos.ctl,v 1.4 2014/04/07 13:37:34 RDA Exp $
#
# Change History
# 20140401  PRA  Improve operating system level detection for Solaris 10.

=head1 NAME

TOOL:HCsunos - Submodule Specific to the Solaris Operating System

=cut

# Make the module persistent
keep $KEEP_BLOCK,@SHARE_MACROS
var @SHARE_MACROS = ('get_df')

=head1 DESCRIPTION

This module determines the operating system version and its bit size.

The following macro is available:

=cut

import $OS_ARC,$OS_BIT,$OS_LVL,$OS_NAM,$OS_PLT,$OS_VER
var $OS_ARC = cond(grepCommand('/usr/sbin/psrinfo -v','i386','if'),'Intel',\
                                                                   'Sparc')
var $OS_BIT = 32
var $OS_NAM = uname('s')
var $OS_PLT = 'Sun'
var $OS_VER = replace(uname('r'),'^5','2')
var $osm = field('\.',1,$OS_VER)
if expr('>=',$osm,7)
{var ($str) = command('isainfo -v')
 if match($str,'^64-bit')
  var $OS_BIT = 64
 if expr('==',$osm,10)
  var ($OS_LVL) = grepFile('/etc/release','s10[sx]_u(\d+)','f1')
 elsif expr('>=',$osm,11)
  var ($OS_LVL) = grepCommand('/usr/bin/uname -v','^\d+\.(\d+)$','f1')
}

=head2 get_df($dir)

This macro returns the number of free KiB on the file system containing the
specified directory.

=cut

macro get_df
{var ($dir) = @arg
 var ($lin) = grepCommand(concat('df -k ',quote($dir)),'\s\d+\%')
 var (undef,undef,undef,$siz) = split('\s+',$lin,5)
 return $siz
}

=head1 COPYRIGHT NOTICE

Copyright (c) 2002, 2016, Oracle and/or its affiliates. All rights reserved.

=head1 TRADEMARK NOTICE

Oracle and Java are registered trademarks of Oracle and/or its
affiliates. Other names may be trademarks of their respective owners.

=cut
