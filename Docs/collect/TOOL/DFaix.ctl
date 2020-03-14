# DFaix.ctl: Collects AIX-specific Comparison Information
# $Id: DFaix.ctl,v 1.3 2015/09/25 00:16:32 RDA Exp $
#
# Change History
# 20150924  MSC  Eliminate trailing spaces.

=head1 NAME

TOOL:DFaix - Collects AIX-specific Comparison Information

=head1 DESCRIPTION

This module collects AIX-specific information for comparing systems.
For some collections it requires super user privileges.

=cut

# Make the module persistent and share macros
keep $KEEP_BLOCK,@SHARE_MACROS
var @SHARE_MACROS = ('collect_os')

# Collect the operating system information
macro collect_os
{var ($ind) = @arg
 import $TOP

 write '---+ CHAPTER:100:Operating System'

 # Determine the operating system type and name
 debug " Inside DFaix, determine the operating system type"
 var $bit = 32
 var $plt = 'AIX'
 var ($osv) = command('oslevel')
 if expr('>',concat(substr($osv,0,1),substr($osv,2,1),substr($osv,4,1)),430)
 {var ($str) = command('lslpp -l bos.64bit 2>&1')
  if !match($str,'not installed')
   var $bit = 64
 }
 var ($oml) = command('oslevel -r')
 var ($spl) = command('oslevel -s')

 # Collect the AIX release information
 write '---++ SECTION:010:System Information'
 write '|*Name*|*Value #*|'
 write '|Platform|',$bit,'-bit ',$plt,'|'
 write '|O/S Version|',$osv,'|'
 write '|O/S Maintenance Level|',$oml,'|'
 write '|O/S Service Pack Level|',$spl,'|'
 write $TOP

 # Collect the uname information
 write '---++ SECTION:020:Release and Hardware Information'
 write '|*Name*|*Value #*|'
 write '|Release|',uname('r'),' |'
 write '|Version|',uname('v'),' |'
 write '|Hardware Name|',uname('m'),' |'
 write $TOP

 # Collect the CPU information
 debug " Inside DFaix, collect the CPU information"
 # Collect the memory information
 debug " Inside DFaix, collect the memory information"
 if loadCommand('/usr/sbin/prtconf')
 {var ($cnt,$mhz,$nxt,$mem,$pct,$typ,$swp) = (0,'?',false)
  loop $lin (getLines())
  {if match($lin,'^Processor Type:\s+(.*)$')
    var ($typ) = (last)
   elsif match($lin,'^Number Of Processors:\s+(\d+)$')
    var ($cnt) = (last)
   elsif match($lin,'^Processor Clock Speed:\s+(.*)$')
    var ($mhz) = (last)
   elsif match($lin,'^Memory Size:\s+(.*)$')
    var ($mem) = (last)
   elsif match($lin,'^\s+Total Paging Space:\s+(.*)$')
   {var ($nxt,$swp) = (true,last)
    next
   }
   elsif $nxt
   {if match($lin,'^\s+Percent Used:\s+(.*)$')
     var ($pct) = (last)
   }
   var $nxt = false
  }
  if $cnt
  {var ($off,$str) = (0,'')
   while expr('<',$off,$cnt)
   {incr $off
    var $str = sprintf('%s%%BR%%[%02d]: %s %s',$str,$off,$typ,$mhz)
   }
   write '---++ SECTION:100:CPU Information'
   write '|*Name*|*Value #*|'
   write '|Number of Processors|',$cnt,'|'
   write '|Processor Details|',substr($str,4),'|'
   write $TOP
  }

  write '---++ SECTION:110:Memory Information'
  write '|*Name*|*Value #*|'
  if $mem
   write '|Mem Total|',replace($mem,'\s*MB\s*',' MiB'),'|'
  if $swp
   write '|Swap Total|',replace($swp,'\s*MB\s*',' MiB'),'|'
  if $pct
   write '|Swap Percent Used|',$pct,'|'
  write $TOP
 }

 # Collect the mount points
 debug " Inside DFaix, collect the mount points"
 prefix
 {write '---++ SECTION:120:Mount Points'
  write '|*Directory*|*Node #*%BR%*Device #*%BR%*Type #*%BR%*Options #*|'
 }
 var %tbl = ()
 loop $lin (command('mount'))
 {next match($lin,'^\s+node\s+mounted')
  next match($lin,'^-+\s+-+')
  var $opt = field('\s+',-1,$lin)
  var $typ = field('\s+',-5,$lin)
  var $dir = field('\s+',-6,$lin)
  var $dev = field('\s+',-7,$lin)
  var $nod = nvl(field('\s+',-8,$lin),'(None)')
  var $tbl{$dir} = join('%BR%',$nod,$dev,$typ,$opt)
 }
 loop $dir (keys(%tbl))
  write '|',encode($dir),'|',$tbl{$dir},'|'
 if hasOutput(true)
  write $TOP

 # Collect package versions and releases
 debug " Inside DFaix, collect the filesets"
 if loadCommand('/usr/bin/lslpp -c -l')
 {prefix
  {write '---++ SECTION:200:Package Versions and Releases'
   write '|*Path:Name*|*Level #*%BR%*State #*%BR%*PTF ID #*%BR%*Typ #*|'
  }
  loop $lin (getLines())
  {var ($pth,$nam,$lvl,$ptf,$sta,$typ) = split(':',$lin)
   write '|',$pth,':',$nam,'|',join('%BR%',$lvl,$sta,$ptf,$typ),'|'
  }
  if hasOutput(true)
   write $TOP
 }

 # Collect Operating System Patches
 debug ' Inside DFaix, collect Operating System Patches'
 if loadCommand('/usr/sbin/instfix -ic')
 {prefix
  {write '---++ SECTION:210:Operating System Patches'
   write '|*Name:Fileset*|*Required #*%BR%*Installed #*%BR%*Status #*|'
  }
  loop $lin (getLines())
  { # name, fileset name, required level, installed level, status, abstract
    var ($nam,$set,$req,$ins,$sta) = split(':',$lin)
    $sta =  check($sta,'<','down level','=|\+','correct/superseded',\
                       '!','not installed')
    write '|',$nam,':',$set,'|',join('%BR%',$req,$ins,$sta),'|'
  }
  if hasOutput(true)
   write $TOP
 }

 # Collect kernel parameters
 debug " Inside DFaix, collect the  Virtual Memory Manager tunable parameters"
 if loadCommand('/usr/sbin/vmo -x')
 {prefix
  {write '---++ SECTION:300:System/Kernel Parameters'
   write '|*Name*|*Value #*|'
  }
  loop $lin (getLines())
  {# tunable,current,default,reboot,min,max,unit,type,{dtunable }
   var ($nam,$cur) = split(',',$lin,3)
   write '|',$nam,'|',$cur,'|'
  }
  if hasOutput(true)
   write $TOP
 }

 # Collect the java version
 debug " Inside DFaix, collect the Java versions"
 var ($lin) = command('java -version 2>&1')
 if match($lin,'.*version\s*(.*)\s*$')
 {var $ver = trim(last,'"')
  write '---++ SECTION:400:Java Version'
  write '|*Name*|*Value #*|'
  write '|','Java Version','|',$ver,'|'
  write $TOP
 }
}

=head1 SEE ALSO

L<TOOL:DIFFcmp|collect::TOOL:DIFFcmp>,
L<TOOL:DIFFget|collect::TOOL:DIFFget>,
L<TOOL:TLdiff|collect::TOOL:TLdiff>

=head1 COPYRIGHT NOTICE

Copyright (c) 2002, 2016, Oracle and/or its affiliates. All rights reserved.

=head1 TRADEMARK NOTICE

Oracle and Java are registered trademarks of Oracle and/or its
affiliates. Other names may be trademarks of their respective owners.

=cut
