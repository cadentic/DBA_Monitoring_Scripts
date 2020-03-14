# HCunix.ctl: UNIX Specific Code
# $Id: HCunix.ctl,v 1.2 2013/10/30 07:18:55 RDA Exp $
# ARCS: $Header: /home/cvs/cvs/RDA_8/src/scripting/lib/collect/TOOL/HCunix.ctl,v 1.2 2013/10/30 07:18:55 RDA Exp $
#
# Change History
# 20120609  MSC  Initial RDA 5 version.

=head1 NAME

TOOL:HCunix - Submodule Specific to other UNIX Operating Systems

=cut

# Make the module persistent
keep $KEEP_BLOCK

=head1 DESCRIPTION

This module determines the operating system version.

=cut

import $OS_NAM,$OS_PLT,$OS_VER
var $OS_NAM = getOsName()
var $OS_PLT = 'UNIX'
var $OS_VER = uname('r')

=head1 COPYRIGHT NOTICE

Copyright (c) 2002, 2016, Oracle and/or its affiliates. All rights reserved.

=head1 TRADEMARK NOTICE

Oracle and Java are registered trademarks of Oracle and/or its
affiliates. Other names may be trademarks of their respective owners.

=cut
