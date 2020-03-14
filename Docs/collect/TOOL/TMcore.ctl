# TMcore.ctl: Tests Stack Trace Extraction
# $Id: TMcore.ctl,v 1.6 2013/10/30 07:18:55 RDA Exp $
# ARCS: $Header: /home/cvs/cvs/RDA_8/src/scripting/lib/collect/TOOL/TMcore.ctl,v 1.6 2013/10/30 07:18:55 RDA Exp $
#
# Change History
# 20130610  MSC  Improve validation.

=head1 NAME

OS:TMcore - Tests Stack Trace Extraction

=head1 DESCRIPTION

This test module extracts the stack trace from a system core dump.

=cut

section tool
call unshift(@{CUR.W_NEXT},'test')

section test

# Initialization
var $TOC = '%TOC%'
var $TOP = '[[#Top][Back to top]]'

# Get the core file
if $arg[0]
 var $dmp = last
elsif getEnv('CORE')
 var $dmp = last
else
{call requestInput('TMcore')
 var $dmp = ${RUN.REQUEST.F_CORE}
}

if !?testFile('fr',$dmp)
 die 'Missing or invalid file'

# Try to extract the program name that produced the core
var $pgm = field(cond(match(getOsName(),'aix'),",\s*","'"),1,\
                 command(concat('file ',quote($dmp))))

# Find a debugger
var $flg = true
var $osn = getOsName()
var @dbg = ('gdb','mdb','adb','sdb')
var %opt = ('gdb',' -n -q')
if and(match($osn,'aix'),compare('valid',first(command('oslevel')),'4.3'))
 call unshift(@dbg,'dbx')
else
 call push(@dbg,'dbx')
if match($osn,'solaris|sunos')
 call unshift(@dbg,'pstack')
loop $typ (@dbg)
{if ?findCommand($typ,true)
 {var $dbg = last
  if ?testFile('x',$dbg)
  {var $flg = false
   break
  }
 }
}
if $flg
 die 'No debugger found'

# List the environment, what we know so far
call setAbbr('OS_CORE_')
report concat('c_',basename($dmp))
write '---+!! Stack Trace Extraction Utility'
write 'Version 1.0%BR%\
       Copyright (c) 2002, 2016, Oracle and/or its affiliates. \
       All rights reserved.%BR%'
write $TOC
write '%BR%'
write '|*Core file*|',$dmp,'|'
write '|*Program*|',$pgm,'|'
write '|*Debugger*|',$dbg,'|'
write $TOP

# Extract information from the core file
if match($dbg,'pstack$')
{# If pstack is available, just call the code and be done with it.
 prefix
  write '---+ pstatck Output'
 call writeCommand(concat(quote($dbg),' ',quote($dmp)))
 if hasOutput(true)
  write $TOP

 # If we found pmap, run it
 if ?findCommand('pmap')
 {prefix
   write '---+ pmap Output'
  call writeCommand(concat(last,' ',quote($dmp)))
  if hasOutput(true)
   write $TOP
 }

 # If we found pflags, run it
 if ?findCommand('pflags')
 {prefix
   write '---+ pflags Output'
  call writeCommand(concat(last,' -r ',quote($dmp)))
  if hasOutput(true)
   write $TOP
 }

 # If we found pldd, run it
 if ?findCommand('pldd')
 {prefix
   write '---+ pldd Output'
  call writeCommand(concat(last,' ',quote($dmp)))
  if hasOutput(true)
   write $TOP
 }
}
else
{# Extract possible executables from the corefile
 var ($flg,%exe) = ()
 loop $fil ($pgm,\
            catFile(dirname($dmp),$pgm),\
            grepCommand(concat('strings ',quote($dmp)),\
            concat('^(.*\/)?',$pgm,'$')))
 {var $fil = replace($fil,'^\.\/')
  if ?testFile('x',$fil)
  {next ?testDir('d',$fil)
   var $exe{$fil} = 1
   var $flg = true
  }
 }

 # Try to extract the stack trace
 if $flg
 {# Initialize the debugger input file
  var $inp = createTemp('debug')
  if match($dbg,'gdb$')
  {call writeTemp('debug','echo \n</verbatim>\n---### Stack\n<verbatim>\n')
   call writeTemp('debug','thread apply all where')
   call writeTemp('debug','echo \n</verbatim>\n---### Registers\n<verbatim>\n')
   call writeTemp('debug','info all-registers')
   call writeTemp('debug','q')
  }
  elsif match($dbg,'mdb$')
  {call writeTemp('debug','!echo "</verbatim>"')
   call writeTemp('debug','!echo "---### Version and Status"')
   call writeTemp('debug','!echo "<verbatim>"')
   call writeTemp('debug','::version')
   call writeTemp('debug','::status')
   call writeTemp('debug','!echo "</verbatim>"')
   call writeTemp('debug','!echo "---### Stack"')
   call writeTemp('debug','!echo "<verbatim>"')
   call writeTemp('debug','::walk thread | ::findstack')
   call writeTemp('debug','!echo "</verbatim>"')
   call writeTemp('debug','!echo "---### Registers"')
   call writeTemp('debug','!echo "<verbatim>"')
   call writeTemp('debug','::regs')
  }
  elsif match($dbg,'adb$')
  {call writeTemp('debug','!echo "</verbatim>"')
   call writeTemp('debug','!echo "---### Stack"')
   call writeTemp('debug','!echo "<verbatim>"')
   call writeTemp('debug','$c')
   call writeTemp('debug','!echo "</verbatim>"')
   call writeTemp('debug','!echo "---### Registers"')
   call writeTemp('debug','!echo "<verbatim>"')
   call writeTemp('debug','$r')
   call writeTemp('debug','$f')
   call writeTemp('debug','!echo "</verbatim>"')
   call writeTemp('debug','!echo "---### Memory Map"')
   call writeTemp('debug','!echo "<verbatim>"')
   call writeTemp('debug','$m')
   call writeTemp('debug','!echo "</verbatim>"')
   call writeTemp('debug','!echo "---### Variables"')
   call writeTemp('debug','!echo "<verbatim>"')
   call writeTemp('debug','$v')
   call writeTemp('debug','$q')
  }
  elsif match($dbg,'sdb$')
  {call writeTemp('debug','t')
   call writeTemp('debug','quit')
  }
  elsif match($dbg,'dbx$')
  {call writeTemp('debug','print "</verbatim>"')
   call writeTemp('debug','print "---### Stack"')
   call writeTemp('debug','print "<verbatim>"')
   call writeTemp('debug','where')
   call writeTemp('debug','print "</verbatim>"')
   call writeTemp('debug','print "---### Registers"')
   call writeTemp('debug','print "<verbatim>"')
   call writeTemp('debug','registers')
   call writeTemp('debug','quit')
  }
  call closeTemp('debug')

  # Try them individually to extract a stack trace.
  loop $exe (keys(%exe))
  {prefix
    write '---+ Core Extraction Attempted with ',encode($exe)
   call writeCommand(concat(quote($dbg),$opt{$typ},' ',quote($exe),' ',\
                            quote($dmp),' <',$inp))
   if hasOutput(true)
    write $TOP
  }

  # Remove the temporary debug file
  call unlinkTemp('debug')
 }
 else
  echo 'Program not found'
}
echo "Stack trace extraction done."
if isCreated()
{call getGroupFile('D_CWD',renderFile())
 echo 'Result file: ',last
}

=begin credits

=over 10

=item RDA 4.4:  Roger Snowden.

=item RDA 4.12: Francois Lange.

=item RDA 4.21: Dave Henrique.

=back

=end credits

=head1 COPYRIGHT NOTICE

Copyright (c) 2002, 2016, Oracle and/or its affiliates. All rights reserved.

=head1 TRADEMARK NOTICE

Oracle and Java are registered trademarks of Oracle and/or its
affiliates. Other names may be trademarks of their respective owners.

=cut
