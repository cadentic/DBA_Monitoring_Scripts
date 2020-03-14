# HCCEinit.ctl: Initializes Health Check/Compliance Engine Evaluation Context
# $Id: HCCEinit.ctl,v 1.1 2014/08/19 12:14:27 RDA Exp $
# ARCS: $Header: /home/cvs/cvs/RDA_8/src/scripting/lib/collect/TOOL/HCCEinit.ctl,v 1.1 2014/08/19 12:14:27 RDA Exp $
#
# Change History
# 20120818  MSC  Initial version.

=head1 NAME

TOOL:HCCEinit - Initializes Health Check/Compliance Engine Evaluation Context

=head1 DESCRIPTION

This persistent submodule contains the initialization of the evaluation
context for all actions written in the data collection specification language.

=cut

# Define the global variables
var ($OS_ARC,$OS_BIT,$OS_LVL,$OS_NAM,$OS_PLT,$OS_TYP,$OS_VER) = ()
var ($PKG,@PKG,%PKG) = (true)
keep $OS_ARC,$OS_BIT,$OS_LVL,$OS_NAM,$OS_PLT,$OS_TYP,$OS_VER,$PKG,@PKG,%PKG

# Call the operating specific libraries
run &{check(getOsName(),'aix',             'TOOL:HCaix',\
                        'darwin',          'TOOL:HCdarwin',\
                        'dec_osf',         'TOOL:HCosf',\
                        'dynixptx',        'TOOL:HCptx',\
                        'hpux',            'TOOL:HChpux',\
                        'linux',           'TOOL:HClinux',\
                        'solaris',         'TOOL:HCsunos',\
                         cond(isCygwin(),  'TOOL:HCwin32',\
                              isUnix(),    'TOOL:HCunix',\
                              isVms(),     'TOOL:HCvms',\
                              isWindows(), 'TOOL:HCwin32'))}()

=head1 SEE ALSO

L<TOOL:HCaix|collect::TOOL:HCaix>,
L<TOOL:HCdarwin|collect::TOOL:HCdarwin>,
L<TOOL:HChpux|collect::TOOL:HChpux>,
L<TOOL:HClinux|collect::TOOL:HClinux>,
L<TOOL:HCosf|collect::TOOL:HCosf>,
L<TOOL:HCptx|collect::TOOL:HCptx>,
L<TOOL:HCsunos|collect::TOOL:HCsunos>,
L<TOOL:HCunix|collect::TOOL:HCunix>,
L<TOOL:HCvms|collect::TOOL:HCvms>,
L<TOOL:HCwin32|collect::TOOL:HCwin32>

=head1 COPYRIGHT NOTICE

Copyright (c) 2002, 2016, Oracle and/or its affiliates. All rights reserved.

=head1 TRADEMARK NOTICE

Oracle and Java are registered trademarks of Oracle and/or its
affiliates. Other names may be trademarks of their respective owners.

=cut
