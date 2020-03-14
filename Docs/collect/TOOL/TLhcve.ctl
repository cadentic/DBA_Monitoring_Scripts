# TLhcve.ctl: Executes HCVE Tests
# $Id: TLhcve.ctl,v 1.9 2015/04/29 14:12:58 RDA Exp $
# ARCS: $Header: /home/cvs/cvs/RDA_8/src/scripting/lib/collect/TOOL/TLhcve.ctl,v 1.9 2015/04/29 14:12:58 RDA Exp $
#
# Change History
# 20150424  MSC  Introduce the control agent concept.

=head1 NAME

TOOL:TLhcve - Executes Health Check/Validation Engine Tests

=head1 DESCRIPTION

 <rda> -T hcve

 <sdci> run hcve

This test module presents all possible rule sets for the current platform and
executes the selected one. It removes all previous reports for that rule
set. If the I<-d> option is specified, it displays step execution progress. The
exit code is O when tests are successful, 1 in case of failures, or 2 when
it detects execution errors.

 <rda> -T hcve:<name>

 <sdci> run hcve <name>

Executes the specified rule set.

 <rda> -T M:hcve:<name>

 <sdci> run hcve -M <name>

Produces the documentation of the specified rules set as a report.

=cut

use Collect
use Message

options afg*M

section tool

echo tput('bold'),'Processing HCVE tests ...',tput('off')

# Initialisation
var $TOC = '%TOC%'
var $TOP = '[[#Top][Back to top]]'

var @set = ()

# Select the rule set
if @arg
{var $set = getSet($opt{'g'},replace($arg[0],'\.xml$','',true))
 if submitCommand('.','DIAGLET.INFO',diaglet=>$set)->is_error
  die 'Rule set ',$set,' not found'
}
else
{# List available rule sets
 var ($cnt,%ttl,@txt) = (0,'A','Available Pre-Installation Rule Sets:',\
                           'P','Available Post-Installation Rule Sets:')
 loop $typ ('A','P')
 {# Get the rule sets
  var $hsh = getSets($typ,$opt{'g'},$opt{'a'},'seq','uid','dsc','old')

  # Eliminate old rule sets
  loop $key (keys($hsh))
  {if $hsh->{$key}->[3]
    call delete($hsh->{$key})
  }

  # Add remaining rule sets to the list
  if keys($hsh)
  {call push(@txt,concat(".M2 '",$ttl{$typ},"'"))
   loop $rec (sort($hsh,'1NA,2'))
   {var (undef,$uid,$dsc) = @{$rec}
    var $set[incr($cnt)] = $uid
    call push(@txt,sprintf('%2d.|%s',$cnt,$dsc))
   }
   call push(@txt,'','.N1')
  }
 }
 if !$cnt
  die 'No rule set found for this platform'

 # Get the HCVE rule set offset
 var ${RUN.REQUEST.N_RULE_SETS} = $cnt
 var ${RUN.REQUEST.T_RULE_SETS} = join("\012",@txt)
 call requestInput('TLhcve')
 var $set = $set[${RUN.REQUEST.N_RULE_SET}]
}

# Treat the HCVE rule set
if $set
{if $opt{'M'}
 {var $rsp = submitCommand('.','DIAGLET.MAN',diaglet=>$set)
  if $rsp->get_first('man')
   dump 'Rule set description file: ',last
 }
 else
 {var $rsp = submitCommand('.','DIAGLET.RUN',diaglet=>$set,force=>$opt{'f'})
  if $rsp->get_first('results')
   dump 'Result file: ',last
  if $rsp->get_first('errors')
   dump 'Error file: ',last
 }
 if $rsp->has_errors
 {dump join("\012",$rsp->format_errors(-1))
  return ${CUR.O_REQUEST}->error('Comply',{exit_only=>2})
 }
 if $rsp->get_first('exit')
  return ${CUR.O_REQUEST}->error('Comply',{exit_only=>last})
}

=head1 SEE ALSO

L<TOOL:HCVEexec|collect::TOOL:HCVEexec>,
L<TOOL:HCVEinit|collect::TOOL:HCVEinit>,
L<TOOL:HCVEman|collect::TOOL:HCVEman>

=begin credits

=over 10

=item RDA 4.3:  Joerg Doerris, Bill Loi, John Peeken, Wes Root.

=back

=end credits

=head1 COPYRIGHT NOTICE

Copyright (c) 2002, 2016, Oracle and/or its affiliates. All rights reserved.

=head1 TRADEMARK NOTICE

Oracle and Java are registered trademarks of Oracle and/or its
affiliates. Other names may be trademarks of their respective owners.

=cut
