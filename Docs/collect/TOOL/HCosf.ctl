# HCosf.ctl: OSF Specific Code
# $Id: HCosf.ctl,v 1.2 2013/10/30 07:18:55 RDA Exp $
# ARCS: $Header: /home/cvs/cvs/RDA_8/src/scripting/lib/collect/TOOL/HCosf.ctl,v 1.2 2013/10/30 07:18:55 RDA Exp $
#
# Change History
# 20121011  MSC  Modify quoting.

=head1 NAME

TOOL:HCosf - Submodule Specific to OSF Operating System

=cut

# Make the module persistent
keep $KEEP_BLOCK,@SHARE_MACROS
var @SHARE_MACROS = ('get_df')

=head1 DESCRIPTION

This module determines the operating system version and its bit size.

The following macro is available:

=cut

import $OS_BIT,$OS_NAM,$OS_PLT,$OS_VER
var $OS_BIT = 64
var $OS_PLT = 'HP Tru64'
var $OS_VER = nvl(field('V(\d[\.\w]*)',1,command('/usr/sbin/sizer -v')),\
                  field('V',1,uname('r')))

var $OS_NAM = getOsName()

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
