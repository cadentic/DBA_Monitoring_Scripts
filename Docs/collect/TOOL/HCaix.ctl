# HCaix.ctl: AIX Specific Code
# $Id: HCaix.ctl,v 1.2 2013/10/30 07:18:55 RDA Exp $
# ARCS: $Header: /home/cvs/cvs/RDA_8/src/scripting/lib/collect/TOOL/HCaix.ctl,v 1.2 2013/10/30 07:18:55 RDA Exp $
#
# Change History
# 20121011  MSC  Modify quoting.

=head1 NAME

TOOL:HCaix - Submodule Specific to the AIX Operating System

=cut

# Make the module persistent
keep $KEEP_BLOCK,@SHARE_MACROS
var @SHARE_MACROS = ('get_df')

=head1 DESCRIPTION

This module determines the operating system version and its bit size.

The following macro is available:

=cut

debug ' Inside END module, determining operating system characteristics'
import $OS_BIT,$OS_LVL,$OS_NAM,$OS_PLT,$OS_VER
var $OS_BIT = 32
var ($OS_LVL) = command('oslevel -r')
var $OS_NAM = getOsName()
var $OS_PLT = 'AIX'
var ($OS_VER) = command('oslevel')
if expr('>',\
        concat(substr($OS_VER,0,1),substr($OS_VER,2,1),substr($OS_VER,4,1)),\
        430)
{var ($str) = command('lslpp -l bos.64bit 2>&1')
 if !match($str,'not installed')
  var $OS_BIT = 64
}

=head2 get_df($dir)

This macro returns the number of free KiB on the file system containing the
specified directory.

=cut

macro get_df
{var ($dir) = @arg
 var ($lin) = grepCommand(concat('df -k ',quote($dir)),'\s\d+\%')
 var (undef,undef,$siz) = split('\s+',$lin,4)
 return $siz
}

=head1 COPYRIGHT NOTICE

Copyright (c) 2002, 2016, Oracle and/or its affiliates. All rights reserved.

=head1 TRADEMARK NOTICE

Oracle and Java are registered trademarks of Oracle and/or its
affiliates. Other names may be trademarks of their respective owners.

=cut
