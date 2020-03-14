# TLroot.ctl: Performs Data Collection as root User
# $Id: TLroot.ctl,v 1.4 2013/11/26 10:00:46 RDA Exp $
# ARCS: $Header: /home/cvs/cvs/RDA_8/src/scripting/lib/collect/TOOL/TLroot.ctl,v 1.4 2013/11/26 10:00:46 RDA Exp $
#
# Change History
# 20131126  MSC  Improve the documentation.

=head1 NAME

TLroot - Performs Data Collection as C<root> User

=head1 DESCRIPTION

This tool performs data collection as C<root> user.

It changes the owner of the generated reports to the owner of report
directory. If you execute this tool before any RDA collection, the report
directory will belong to the C<root> user and you will have to modify that
ownership before using it for making RDA collections as another user.

=head1 USAGE

 <rda> -vT root

By default, it collects data from all applicable modules. It is possible to
limit the data collection to a subset of the configured modules. However, it
always collect the C<CFG> and C<END> modules. For example,

 <rda> -vT root OS NET

You can enable the trace selectively. For example,

 <rda> -vT root T:OS NET

It will enable code and variable tracing for the OS module only.

You can obtain the list of applicable modules with the following command:

 <rda> -L root

=cut

use Mrc

section tool

echo tput('bold'),'Processing TLroot tool ...',tput('off')

# Verify prerequisites
if !${DFT.B_FORCE_ROOT}
{if !isUnix()
  die S,'This tool can be run only on UNIX.'
 if !match(id(),'^uid=0\(')
  die S,'This tool can be run only as root user.'
}

# Initialisation
var $TOC = '%TOC%'
var $TOP = '[[#Top][Back to top]]'

# Purge all reports and create the report index
call setAbbr('TOOL_ROOT_')
call purge('C','.',0,0,true)
call enableIndex(true)

# Get applicable modules
var %col
loop $mod (getMrcModules(true))
 var $col{${<'STA',$mod,'M_NAM'>}} = $mod

# Determine the modules to treat
var $dft = setTrace()
var $min = 2
var %mod = ('RDA:DCend' => $dft)
var %trc = ('',$dft,'t:',1,'T:',2)
if @arg
{loop $mod (@arg)
 {var ($trc,$mod) = match($mod,'^([tT]:)?(.*)$')
  var $nam = nvl(getModule('DC',undef,$mod),$mod)
  if exists($col{$nam})
   var ($min,$mod{$nam}) = (1,$trc{nvl($trc,'')})
  else
   echo "\011No root collection applicable for ",$mod
 }
 var @mod = keys(%mod)
}
else
 var @mod = keys(%col)
if expr('<',scalar(@mod),$min)
 die S,"\012No collection required"

# Perform the collection
debug
loop $mod (@mod)
{debug 'Processing module ',$mod,' ...'
 var $trc = setTrace(nvl($mod{$mod},$trc{''}))
 if beginCollect($col{$mod})
   echo "\011Base collection missing for ",$mod
 else
 {loop $def (getMrcMembers($col{$mod},[@{T_MRC_GROUPS:'default'}],true))
  {if match($def,'\-')
    run &{$def}()
   else
    collect &{$def}()
  }
  call endCollect()
 }
 call setTrace($trc)
}

# Warn when the report directory belongs to root
if expr('==',${CUR.N_OWNER},'0')
 echo 'The owner of the report directory is root. Modify the owner of the \
       directory when you will use it for RDA collections with another user.'
else
{dump "\011Generating the index ..."
 call renderIndex()
}

# Force setup save
call $[COL]->save

=begin credits

=over 10

=item RDA 4.19: Jaime Alcoreza.

=back

=end credits

=head1 COPYRIGHT NOTICE

Copyright (c) 2002, 2016, Oracle and/or its affiliates. All rights reserved.

=head1 TRADEMARK NOTICE

Oracle and Java are registered trademarks of Oracle and/or its
affiliates. Other names may be trademarks of their respective owners.

=cut
