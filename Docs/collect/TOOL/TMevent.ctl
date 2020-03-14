# TMevent.ctl: Extracts Event Log Information
# $Id: TMevent.ctl,v 1.4 2014/05/13 19:52:07 RDA Exp $
# ARCS: $Header: /home/cvs/cvs/RDA_8/src/scripting/lib/collect/TOOL/TMevent.ctl,v 1.4 2014/05/13 19:52:07 RDA Exp $
#
# Change History
# 20140513  JJU  Extend the tool to archived files.

=head1 NAME

TMevent - Extracts Event Log Information

=head1 DESCRIPTION

This test module extracts event log information.

 <sdci> run event  or  <sdci> run event -L

Produces an overview of the data collection execution duration and report size
based on limit records (from RDA 4.18).

 <sdci> run event -C

Produces an overview of the data collection duration.

 <sdci> run event -S

Produces an overview of the data collection setup duration.

In some cases, data collection duration time can include the setup time.

 <sdci> -z <archive> run event

Treats the event log from the preferred result set inside the specified
archive.

 <sdci> -z <archive> run event -p <prefix>

Treats the event log from the specified result set inside the specified
archive.

=cut

options 'CLSp:z:'

section tool
call unshift(@{CUR.W_NEXT},'test')

section test

echo tput('bold'),'Processing the event log ...',tput('off')

# Initialisation
var (%fix,%mod,%tst,@log,%MSP,%RPT,%RUN,%TSP,%TST) = \
  ('RDA.BEGIN',1,\
   'RDA.CONFIG',1,\
   'RDA.END',1,\
   'RDA.LOAD',1,\
   'RDA.OCM',1,\
   'RDA.STATUS',1)

# Analyze the arguments
var $typ = cond(exists($opt{'C'}),'C',\
                exists($opt{'S'}),'S',\
                                  'L')

# When requested, set a virtual context
if @arg
{loop $arg (@arg)
 {if !isAbsolute($arg)
   var $arg = getGroupDir('D_CWD',$arg)
  call push(@log,grepDir($arg,'^RDA\.log$','ir'))
 }
}
else
{var @log = ('RDA.log')
 if isArchived($opt{'z'})
  call selectIndex(last,$opt{'p'})
}

# Define the parsing macros
code debug = 0
 debug last

code add_collect = -1
{var $run = field('\|',1,line)
 call push($RUN{$run,'evt'},line)
 var $RUN{$run,'flg'} = false
}

code add_fork = -1
{var (undef,$run,undef,$mod) = split('\|',line,5)
 var $RUN{$run,'frk',$mod} = 1
}

code add_limit = -1
{var (undef,$run,undef,$mod,$spc,$dur) = split('\|',line,7)
 if match($mod,'^(\w+):DC(.*)',true)
 {var $mod = uc(join('.',last))
  incr $mod{$mod}
  var $RUN{$run,'m_s',$mod} = $spc
  var $RUN{$run,'m_d',$mod} = $dur
 }
 elsif match($mod,'^(\w+):T[LM](.*)',true)
 {var $mod = join('.',last)
  incr $tst{$mod}
  var $RUN{$run,'t_s',$mod} = $spc
  var $RUN{$run,'t_d',$mod} = $dur
 }
}

code add_setup = -1
{var ($tim,$run) = split('\|',line,3)
 if $RUN{$run,'flg'}
  var $RUN{$run,'beg'} = $tim
}

code beg_session = -1
{var ($tim,$run) = split('\|',line,3)
 call eval(&end_session($run))
 var $RUN{$run} = {beg=>$tim,flg=>true,ref=>$tim}
}

code end_session = -1
{var ($run) = last
 if $RUN{$run,'beg'}
 {var $beg = last
  var $key = join('|',$nam,nvl($RUN{$run,'ref'},$beg),$run)
  if exists($RUN{$run,'m_d'})
  {var $RPT{$key} = $RUN{$run,'m_d'}
   var $RPT{$key,'-'} = 0
   loop $mod (keys($RUN{$run,'frk'}))
    decr $RPT{$key,'-'},$RUN{$run,'m_d',$mod}
   var $MSP{$key} = $RUN{$run,'m_s'}
  }
  elsif exists($RUN{$run,'t_d'})
  {var $TST{$key} = $RUN{$run,'t_d'}
   var $TSP{$key} = $RUN{$run,'t_s'}
  }
  else
  {var ($dur,$prv,$off) = parse_time($beg,0,0)
   loop $evt (@{$RUN{$run,'evt'}})
   {var ($tim,undef,$typ,$mod) = split('\|',$evt,5)
    var ($dur,$prv,$off) = parse_time($tim,$prv,$off)
    var $RPT{$key,'-'} = 0
    if match($typ,'[CS]')
    {incr $mod{$mod}
     var $RPT{$key,$mod} = $dur
    }
    if match($typ,'T')
    {incr $tst{$mod}
     var $TST{$key,$mod} = $dur
    }
   }
  }
 }
 call delete($RUN{$run})
}

macro parse_time
{var ($tim,$prv,$off) = @arg
 var $nxt = $off
 incr $nxt,expr('*',substr($tim,9,2),3600)
 incr $nxt,expr('*',substr($tim,11,2),60)
 incr $nxt,substr($tim,13,2)
 var $dur = $nxt
 decr $dur,$prv
 if expr('<',$dur,0)
 {var $dlt = cond(expr('>',$dur,-3600),$dur,-86400)
  decr $dur,$dlt
  decr $nxt,$dlt
  decr $off,$dlt
 }
 return ($dur,$nxt,$off)
}

# Define the parsing directives
call parseReset()
call parsePattern('TOP',\
  '^\d{8}_\d{6}\|',\
    cond(compare('ne',$cur,substr(line,0,8)),\
         &debug($cur = substr(line,0,8)),\
         0),\
  '.?',-1)
if compare('eq',$typ,'L')
 call parsePattern('TOP',\
  '^(.*?\|){2}c\|',\
    &add_fork,\
  '^(.*?\|){2}l\|',\
    &add_limit,\
  '^(.*?\|){2}b\|',\
    &beg_session,\
  '^(.*?\|){2}e\|',\
    &end_session(field('\|',1,line)))
elsif compare('eq',$typ,'C')
 call parsePattern('TOP',\
  '^(.*?\|){2}C\|',\
    &add_collect,\
  '^(.*?\|){2}S\|',\
    &add_setup,\
  '^(.*?\|){2}b\|',\
    &beg_session,\
  '^(.*?\|){2}e\|',\
    &end_session(field('\|',1,line)))
else
 call parsePattern('TOP',\
  '^\d{8}_\d{6}\|[^\|]*\|S\|',\
    code(push($RUN{field('\|',1,line),'evt'},line),\
         0),\
  '^\d{8}_\d{6}\|[^\|]*\|b\|',\
    &beg_session,\
  '^\d{8}_\d{6}\|[^\|]*\|e\|',\
    &end_session(field('\|',1,line)))

# Parse the event logs
loop $log (@log)
{next !createBuffer('LOG','A',$log)
 debug ' Inside TMevent, parsing ',$log,' ...'
 var ($cur,$nam) = ('00000000',dirname($log))
 call parse('LOG')
 loop $run (keys(%RUN))
  call eval(&end_session($run))
 call deleteBuffer('LOG')
}

# Produce the report
call setAbbr('TOOL_EVENT_')
call purge('C','log',0)
var @mod = keys(%mod)
if compare('eq',$typ,'L')
{debug ' Inside TMevent, producing the data collection duration overview ...'
 report log
 prefix
 {write '---+ Data Collection Duration'
  write '|*Directory*|*Start*|*Run*| *',join('*| *',@mod),\
        '*| *Fixed*| *Total*|'
 }
 loop $run (keys(%RPT))
 {var ($fix,$tot,@rpt) = (0,$RPT{$run,'-'})
  loop $mod (@mod)
  {var $val = $RPT{$run,$mod}
   if ?$val
   {if $fix{$mod}
     incr $fix,$val
    incr $tot,$val
    call push(@rpt,$val)
   }
   else
    call push(@rpt,'')
  }
  write '|',$run,'| ',join('| ',@rpt),'| ',$fix,'| ',$tot,'|'
 }

 debug ' Inside TMevent, producing the data collection space overview ...'
 prefix
 {write '---+ Data Collection Report Text Space'
  write '|*Directory*|*Start*|*Run*| *',join('*| *',@mod),'*| *Total*|'
 }
 loop $run (keys(%MSP))
 {var ($tot,@rpt) = (0)
  loop $mod (@mod)
  {var $val = $MSP{$run,$mod}
   if ?$val
   {incr $tot,$val
    call push(@rpt,$val)
   }
   else
    call push(@rpt,'')
  }
  write '|',$run,'| ',join('| ',@rpt),'| ',$tot,'|'
 }

 if isCreated(true)
 {call renderFile()
  echo last
 }

 debug ' Inside TMevent, producing the tool/test duration module overview ...'
 report test
 prefix
 {write '---+ Tool/Test Module Duration'
  write '|*Directory*|*Start*|*Run*| *',join('*| *',keys(%tst)),'*|'
 }
 loop $run (keys(%TST))
 {var @rpt = ()
  loop $mod (keys(%tst))
   call push(@rpt,nvl($TST{$run,$mod},''))
  write '|',$run,'| ',join('| ',@rpt),'|'
 }

 debug ' Inside TMevent, producing the tool/test module space overview ...'
 prefix
 {write '---+ Tool/Test Module Report Text Space'
  write '|*Directory*|*Start*|*Run*| *',join('*| *',keys(%tst)),'*|'
 }
 loop $run (keys(%TSP))
 {var @rpt = ()
  loop $mod (keys(%tst))
   call push(@rpt,nvl($TSP{$run,$mod},''))
  write '|',$run,'| ',join('| ',@rpt),'|'
 }
}
elsif compare('eq',$typ,'C')
{debug ' Inside TMevent, producing the data collection overview ...'
 report log
 prefix
 {write '---+ Data Collection Duration'
  write '|*Directory*|*Start*|*Run*| *',join('*| *',@mod),\
        '*| *Fixed*| *Total*|'
 }
 loop $run (keys(%RPT))
 {var ($fix,$tot,@rpt) = (0,$RPT{$run,'-'})
  loop $mod (@mod)
  {var $val = $RPT{$run,$mod}
   if ?$val
   {if $fix{$mod}
     incr $fix,$val
    incr $tot,$val
    call push(@rpt,$val)
   }
   else
    call push(@rpt,'')
  }
  write '|',$run,'| ',join('| ',@rpt),'| ',$fix,'| ',$tot,'|'
 }

 debug ' Inside TMevent, producing the tool/test module overview ...'
 prefix
 {write '---+ Tool/Test Module Duration'
  write '|*Directory*|*Start*|*Run*| *',join('*| *',keys(%tst)),'*|'
 }
 loop $run (keys(%TST))
 {var @rpt = ()
  loop $mod (keys(%tst))
   call push(@rpt,nvl($TST{$run,$mod},''))
  write '|',$run,'| ',join('| ',@rpt),'|'
 }
}
else
{debug ' Inside TMevent, producing the module setup overview ...'
 report log
 prefix
 {write '---+ Module Setup Duration'
  write '|*Directory*|*Start*|*Run*| *',join('*| *',@mod),'*| *Total*|'
 }
 loop $run (keys(%RPT))
 {var ($tot,@rpt) = ()
  loop $mod (@mod)
  {var $val = $RPT{$run,$mod}
   if ?$val
   {incr $tot,$val
    call push(@rpt,$val)
   }
   else
    call push(@rpt,'')
  }
  write '|',$run,'| ',join('| ',@rpt),'| ',$tot,'|'
 }
}

if isCreated(true)
{call renderFile()
 echo last
}

=head1 COPYRIGHT NOTICE

Copyright (c) 2002, 2016, Oracle and/or its affiliates. All rights reserved.

=head1 TRADEMARK NOTICE

Oracle and Java are registered trademarks of Oracle and/or its
affiliates. Other names may be trademarks of their respective owners.

=cut
