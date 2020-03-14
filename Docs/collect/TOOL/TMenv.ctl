# TMenv.ctl: Tests the Environment
# $Id: TMenv.ctl,v 1.2 2013/10/30 07:18:55 RDA Exp $
# ARCS: $Header: /home/cvs/cvs/RDA_8/src/scripting/lib/collect/TOOL/TMenv.ctl,v 1.2 2013/10/30 07:18:55 RDA Exp $
#
# Change History
# 20130310  MSC  Introduce the system view.

=head1 NAME

TMenv - Tests the Environment

=head1 DESCRIPTION

=cut

use Item,Target

options c:

section tool
call unshift(@{CUR.W_NEXT},'test')

section test

echo tput('bold'),'Processing environment test module ...',tput('off')
var $lin = ${RDA.T_LINE}

# Define the common macros
macro cmp_env
{var ($key) = @arg
 var @dsc = (' not used',' removed',' added',' modified',' unchanged')
 var $env = getEnv($key)
 var $rda = getLocalEnv($key)

 if compare('eq',$env,$rda)
 {var $sta = 4
  var $env
  var $rda
 }
 else
 {var $sta = 0
  if defined($env)
   incr $sta
  if defined($rda)
   incr $sta,2
 }

 echo "  ",$key,$dsc[$sta]
 if defined($env)
  dump "    ENV:'",$env,"'"
 if defined($rda)
  dump "    RDA:'",$rda,"'"
}


macro dsp_env
{var ($cnt,$env) = (0,@arg)

 dump 'Environment Alterations:'
 loop $key (keys($env))
 {if ?$env->{$key}
   dump "  ",$key,"='",last,"'"
  else
   dump "  ",$key," is deleted"
  incr $cnt
 }
 if !$cnt
  dump "  None"
 dump
}

macro find_item
{var ($oid) = @arg

 return cond($oid,$[COL]->find('TARGET')->search(concat('^\Q',$oid,'\E$')))
}

# Adjust the current target
if find_item($opt{'c'})
 call setCurrent(addTarget(last))

=pod

This test module lists all defined environment variables seen by RDA.

=cut

dump $lin
dump 'Environment variables'
dump $lin
loop $key (grepEnv('.'))
 dump "  ",$key,"='",getEnv($key),"'"
dump

=pod

Compares the environment with the RDA context.

=cut

dump $lin
dump 'RDA Context'
dump $lin
loop $key ('LANG',@{CUR.W_SHLIB},'NLS_LANG','ORACLE_HOME','ORACLE_SID','PATH',\
           'SQLPATH','TNS_ADMIN','TWO_TASK')
 call cmp_env($key)
dump

=pod

Reports current target details.

=cut

dump $lin
dump 'Current Target'
dump $lin
var $tgt = ${CUR.O_TARGET}
dump 'Target Identifier: ',$tgt->get_info('oid')
call dsp_env($tgt->get_env)

=pod

Reports details about the default SQL*Plus execution context.

=cut

dump $lin
dump 'Default SQL*Plus Execution Context'
dump $lin
var ($cmd,$env,$typ) = $[TGT]->get_sqlplus
dump 'Sql*Plus Command: ',$cmd
dump 'Execution context type: ',$typ
call dsp_env($env)

=pod

Reports details about the current SQL*Plus execution context.

=cut

dump $lin
dump 'Current SQL*Plus Execution Context'
dump $lin
var ($cmd,$env,$typ) = ${CUR.O_TARGET}->get_sqlplus
dump 'Sql*Plus Command: ',$cmd
dump 'Execution context type: ',$typ
call dsp_env($env)

=pod

Reports details about additional targets.

=cut

loop $itm (@arg)
{next !?find_item($itm)
 call $tgt = addTarget(last)
 dump $lin
 dump 'Target ',$itm
 dump $lin
 call dsp_env($tgt->get_env)

 dump $lin
 dump 'Sql*Plus Context for ',$itm
 dump $lin
 var ($cmd,$env,$typ) = $tgt->get_sqlplus
 dump 'Sql*Plus Command: ',$cmd
 dump 'Execution context type: ',$typ
 call dsp_env($env)
}

=head1 COPYRIGHT NOTICE

Copyright (c) 2002, 2016, Oracle and/or its affiliates. All rights reserved.

=head1 TRADEMARK NOTICE

Oracle and Java are registered trademarks of Oracle and/or its
affiliates. Other names may be trademarks of their respective owners.

=cut
