# HCVEinit.ctl: Initializes Health Check/Validation Engine Evaluation Context
# $Id: HCVEinit.ctl,v 1.2 2013/10/30 07:18:55 RDA Exp $
# ARCS: $Header: /home/cvs/cvs/RDA_8/src/scripting/lib/collect/TOOL/HCVEinit.ctl,v 1.2 2013/10/30 07:18:55 RDA Exp $
#
# Change History
# 20120805  MSC  Improve the documentation.

=head1 NAME

TOOL:HCVEinit - Initializes Health Check/Validation Engine Evaluation Context

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
