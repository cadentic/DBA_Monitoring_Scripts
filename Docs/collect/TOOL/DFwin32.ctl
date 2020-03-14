# DFwin32.ctl: Collects Windows-specific Comparison Information
# $Id: DFwin32.ctl,v 1.2 2013/10/30 07:18:55 RDA Exp $
# ARCS: $Header: /home/cvs/cvs/RDA_8/src/scripting/lib/collect/TOOL/DFwin32.ctl,v 1.2 2013/10/30 07:18:55 RDA Exp $
#
# Change History
# 20130212  KRA  Initial RDA 8 version.

=head1 NAME

TOOL:DFwin32 - Collects Windows-specific Comparison Information

=head1 DESCRIPTION

This module collects Windows-specific information for comparing systems.

=cut

# Make the module persistent and share macros
keep $KEEP_BLOCK,@SHARE_MACROS
var @SHARE_MACROS = ('collect_os')

# Collect the operating system information
macro collect_os
{var ($ind) = @arg
 import $TOP

 write '---+ CHAPTER:100:Operating System'

 # Collect the Windows release information
 var $reg = 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
 write '---++ SECTION:010:System Information'
 write '|*Name*|*Value #*|'
 write '|Name|',getRegValue($reg,'ProductName'),' |'
 write '|Version|',getRegValue($reg,'CurrentVersion'),' |'
 write '|Service Pack|',getRegValue($reg,'CSDVersion',\
                                    'No Service Packs installed'),' |'
 write $TOP
}

=head1 SEE ALSO

L<TOOL:DIFFcmp|collect::TOOL:DIFFcmp>,
L<TOOL:DIFFget|collect::TOOL:DIFFget>,
L<TOOL:TLdiff|collect::TOOL:TLdiff>

=begin credits

=over 10

=item RDA 4.10:  Michel Villette.

=back

=head1 COPYRIGHT NOTICE

Copyright (c) 2002, 2016, Oracle and/or its affiliates. All rights reserved.

=head1 TRADEMARK NOTICE

Oracle and Java are registered trademarks of Oracle and/or its
affiliates. Other names may be trademarks of their respective owners.

=cut
