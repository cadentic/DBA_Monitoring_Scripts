# HChpux.ctl: HPUX Specific Code
# $Id: HChpux.ctl,v 1.2 2013/10/30 07:18:55 RDA Exp $
# ARCS: $Header: /home/cvs/cvs/RDA_8/src/scripting/lib/collect/TOOL/HChpux.ctl,v 1.2 2013/10/30 07:18:55 RDA Exp $
#
# Change History
# 20121011  MSC  Modify quoting.

=head1 NAME

TOOL:HChpux - Submodule Specific to the HP-UX Operating System

=cut

# Make the module persistent
keep $KEEP_BLOCK,@SHARE_MACROS
var @SHARE_MACROS = ('get_df')

=head1 DESCRIPTION

This module determines the operating system version and its bit size.

The following macro is available:

=cut

import $OS_ARC,$OS_BIT,$OS_NAM,$OS_PLT,$OS_VER
var $OS_NAM = uname('s')
var $OS_PLT = 'HP-UX'
var $OS_VER = substr(uname('r'),2,5)
debug ' Inside END module, determining OS characteristics'
var $OS_BIT = 32
if match($OS_VER,'^11')
{var ($str) = command('getconf KERNEL_BITS')
 if match($str,'^64')
  var $OS_BIT = 64
}
var $OS_ARC = check(uname('m'),'^ia64','Itanium','PA-RISC')

=head2 get_df($dir)

This macro returns the number of free KiB on the file system containing the
specified directory.

=cut

macro get_df
{var ($dir) = @arg
 return field('\s+',0,grepCommand(concat('df -k ',quote($dir)),\
                                  'free allocated','fi'))
}

=head1 COPYRIGHT NOTICE

Copyright (c) 2002, 2016, Oracle and/or its affiliates. All rights reserved.

=head1 TRADEMARK NOTICE

Oracle and Java are registered trademarks of Oracle and/or its
affiliates. Other names may be trademarks of their respective owners.

=cut
