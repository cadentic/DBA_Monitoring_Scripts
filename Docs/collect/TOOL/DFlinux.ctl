# DFlinux.ctl: Collects Linux-specific Comparison Information
# $Id: DFlinux.ctl,v 1.4 2015/02/20 15:44:40 RDA Exp $
# ARCS: $Header: /home/cvs/cvs/RDA_8/src/scripting/lib/collect/TOOL/DFlinux.ctl,v 1.4 2015/02/20 15:44:40 RDA Exp $
#
# Change History
# 20150220  KRA  Improve list management.

=head1 NAME

TOOL:DFlinux - Collects Linux-specific Comparison Information

=head1 DESCRIPTION

This module collects Linux-specific information for comparing systems.

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
 debug " Inside DFlinux, determine the operating system type"
 loop $fil (grepDir('/etc','^oracle-release$','ip'),\
            grepDir('/etc','release$','p'),\
            grepDir('/etc','conectiva$','p'),\
            grepDir('/etc','^debian','p'))
 {if match($fil,'(enterprise|oracle)',true)
   var ($OS_TYP,$OS_NAM) = ('Oracle',\
                            grepFile($fil,'(Enterprise|Oracle) Linux','fi'))
  elsif match($fil,'Redhat',true)
  {if grepFile($fil,'^(Enterprise|Oracle) Linux','fi')
    var ($OS_TYP,$OS_NAM) = ('Oracle',last)
   elsif grepFile($fil,'CentOS','fi')
    var ($OS_TYP,$OS_NAM) = ('CentOS',last)
   else
    var ($OS_TYP,$OS_NAM) = ('Red Hat',grepFile($fil,'Red Hat','fi'))
  }
  elsif match($fil,'SuSE',true)
  {var $OS_TYP = 'SuSE'
   if grepFile($fil,'SLES','i')
   {loop $lin (last)
    {next match($lin,'VER')
     var $OS_NAM = uc(field('\s',1,$lin))
     break
    }
   }
   elsif grepFile($fil,'Enterprise','i')
   {loop $lin (grepFile($fil,'VER','i'))
    {next match($lin,'Enterprise',true)
     var $OS_NAM = concat('SLES-',field('\s',2,$lin))
     break
    }
   }
  }
  elsif match($fil,'UnitedLinux',true)
   var ($OS_TYP,$OS_NAM) = ('UnitedLinux',\
     field('\s',2,grepFile($fil,'VER','fi')))
  elsif match($fil,'Conectiva',true)
   var $OS_TYP = 'Conectiva'
  elsif match($fil,'TurboLinux',true)
   var $OS_TYP = 'TurboLinux'
  elsif match($fil,'SCO',true)
   var $OS_TYP = 'SCO'
  elsif match($fil,'Debian',true)
   var $OS_TYP = 'Debian'
  else
   next
  break
 }

 # Collect the Linux release information
 write '---++ SECTION:010:System Information'
 write '|*Name*|*Value #*|'
 write '|Type|',$OS_TYP,' |'
 write '|Name|',$OS_NAM,' |'
 write $TOP

 # Collect the uname information
 write '---++ SECTION:020:Release and Hardware Information'
 write '|*Name*|*Value #*|'
 write '|Release|',uname('r'),' |'
 write '|Version|',uname('v'),' |'
 write '|Hardware Name|',uname('m'),' |'
 write $TOP

 # Get the CPU information
 debug " Inside DFlinux, collect the CPU information"
 if loadFile('/proc/cpuinfo')
 {var ($cnt,$ven) = (0,'?')
  loop $lin (getLines())
  {if match($lin,'^processor\s*\d*\:\s*(.*)')
   {var ($str) = (last)
    incr $cnt
    var $mhz[$cnt] = 0
    var $mod[$cnt] = ''
    var $typ[$cnt] = nvl($str,'')
    var $ven[$cnt] = $ven
   }
   elsif match($lin,'^cpu MHz\s*\:\s*(.*)$')
    var ($mhz[$cnt]) = (last)
   elsif match($lin,'^clock\s*\:\s*(.*)Mhz$')
    var ($mhz[$cnt]) = (last)
   elsif match($lin,'^model name\s*\:\s*(.*)$')
    var ($mod[$cnt]) = (last)
   elsif match($lin,'^cpu\s*\:\s*(.*)$')
    var ($mod[$cnt]) = (last)
   elsif match($lin,'^vendor?\s*\:\s*(.*)$')
    var ($ven[$cnt]) = (last)
   elsif match($lin,'^vendor_id\s*\:\s*(.*)$')
   {var ($str) = (last)
    if $cnt
     var $ven[$cnt] = $str
    else
     var $ven = $str
   }
   elsif match($lin,'^arch\s*\:\s*(.*)$')
    var $typ[$cnt] = join(' ',$typ[$cnt],last)
   elsif match($lin,'^cpu family\s*\:\s*(.*)$')
    var $typ[$cnt] = join(' ',$typ[$cnt],'Family',last)
   elsif match($lin,'^family\s*\:\s*(.*)$')
    var $typ[$cnt] = join(' ',$typ[$cnt],'Family',last)
   elsif match($lin,'^model\s*\:\s*(.*)$')
    var $typ[$cnt] = join(' ',$typ[$cnt],'Model',last)
   elsif match($lin,'^stepping\s*\:\s*(.*)$')
    var $typ[$cnt] = join(' ',$typ[$cnt],'Stepping',last)
  }
  if $cnt
  {var ($off,$str) = (0,'')
   while expr('<',$off,$cnt)
   {incr $off
    if $mod[$off]
     var $str = sprintf('%s%%BR%%[%02d]: %s',$str,$off,$mod[$off])
    else
     var $str = sprintf('%s%%BR%%[%02d]:%s %s %d MHz',$str,$off,\
                       $typ[$off],$ven[$off],$mhz[$off])
   }
   write '---++ SECTION:100:CPU Information'
   write '|*Name*|*Value #*|'
   write '|Number of Processors|',$cnt,'|'
   write '|Processor Details|',substr($str,4),'|'
   write $TOP
  }
 }

 # Collect the memory information
 debug " Inside DFlinux, collect the memory information"
 if createBuffer('OS','R','/proc/meminfo')
 {prefix
  {write '---++ SECTION:110:Memory Information'
   write '|*Name*|*Value #*|'
  }
  while getLine('OS')
  {var $lin = chomp(last)
   if match($lin,'MemTotal')
    write '|Mem Total|',field(':\s*',1,$lin),' |'
   elsif match($lin,'(Big|Huge)Pages_Total')
    write '|Huge/Big Pages Total|',field(':\s*',1,$lin),' |'
   elsif match($lin,'(Big|Huge)Pages_Free')
    write '|Huge/Big Pages Free|',field(':\s*',1,$lin),' |'
   elsif match($lin,'(Big|Huge)pagesize')
    write '|Huge/Big Page Size|',field(':\s*',1,$lin),' |'
   elsif match($lin,'SwapTotal')
    write '|Swap Total|',field(':\s*',1,$lin),' |'
  }
  if hasOutput(true)
   write $TOP
  call deleteBuffer('OS')
 }

 # Collect the mount points
 debug " Inside DFlinux, collect the mount points"
 prefix
 {write '---++ SECTION:120:Mount Points'
  write '|*Directory*|*Device #*%BR%*Type #*%BR%*Options #*|'
 }
 var %tbl = ()
 loop $lin (command('mount'))
 {var ($dev,$dir,$typ,$opt) = match($lin,'^(.*) on (.*) type (.*) \((.*)\)')
  next compare('eq',$dev,'none')
  next match($dir,'^/(proc|home)\b')
  var $tbl{$dir} = join('%BR%',$dev,$typ,$opt)
 }
 loop $dir (keys(%tbl))
  write '|',encode($dir),'|',$tbl{$dir},'|'
 if hasOutput(true)
  write $TOP

 # Collect package versions and releases
 debug " Inside DFlinux, collect the package versions and releases"
 if loadCommand('rpm -qa --queryformat "|%{NAME}|%{VERSION} %{RELEASE}|\n"')
 {var %tbl = ()
  loop $key ('binutils','compat-db','compat-gcc','compat-gcc-c++',\
             'compat-libstdc++','compat-libstdc++','compat-libstdc++-296',\
             'compat-libstdc++-33','compat-libstdc++-devel','control-center',\
             'db1','gcc','gcc-c++','glibc','glibc-common','glibc-devel',\
             'gnome-libs','gnuplot','libaio','libaio-devel','libstdc++',\
             'libstdc++-devel','make','openmotif','openmotif-libs','orbit',\
             'pdksh','plotutils','setarch','sysstat','xscreensaver')
  {loop $lin (grepLastFile(concat('\|',verbatim($key),'\|')))
   {var (undef,$key,$val) = split('\|',$lin)
    if isFiltered()
     var $val = replace($val,'\.','&#46;',true)
    var $tbl{$key} = join('%BR%',$tbl{$key},$val)
   }
  }
  prefix
  {write '---++ SECTION:200:Package Versions and Releases'
   write '|*Name*|*Compare*|*Version #*|*Release #*|'
  }
  loop $key (keys(%tbl))
  {if match($tbl{$key},'%BR%')
   {var (@cmp,@rel,@ver,%cmp) = ()
    loop $cmp (split('%BR%',$tbl{$key}))
     var $cmp{$cmp} = 1
    loop $cmp (keys(%cmp))
    {var ($ver,$rel) = split(' ',$cmp)
     call push(@cmp,$cmp)
     call push(@rel,$rel)
     call push(@ver,$ver)
    }
    write '|',$key,'|',join('%BR%',@cmp),'|',\
                       join('%BR%',@ver),'|',\
                       join('%BR%',@rel),'|'
   }
   else
    write '|',$key,'|',$tbl{$key},'|',replace($tbl{$key},' ','|'),'|'
  }
  if hasOutput(true)
   write $TOP
 }

 # Collect kernel parameters
 debug " Inside DFlinux, collect the system/kernel parameters"
 prefix
 {write '---++ SECTION:300:System/Kernel Parameters'
  write '|*Name*|*Value #*|'
 }
 var %tbl = ()
 loop $key ('file-max','ip_local_port_range','rmem_default','rmem_max',\
            'semmns','semmsl','semmin','semmni','semvmx','shmmax','shmall',\
            'shmmin','shmmni','shmseg','wmem_default','wmem_max')
  var $tbl{$key} = '%R:Missing%'
 loop $lin (command('/sbin/sysctl -a'))
 {var $key = key($lin)
  if compare('eq',$key,'kernel.sem')
   var (undef,undef,\
        $tbl{'semmsl'},$tbl{'semmns'},$tbl{'semopm'},$tbl{'semmni'}) = \
     split('\s+',$lin)
  elsif match($key,'file-max|ip_local_port_range|rmem_default|rmem_max|semmns|\
                    semmsl|semmin|semmni|semvmx|shmmax|shmall|shmmin|shmmni|\
                    shmseg|wmem_default|wmem_max')
   var $tbl{field('\.',-1,$key)} = replace(value($lin),'\s+',' ',true)
 }
 loop $key (keys(%tbl))
  write '|',$key,'| ',$tbl{$key},'|'
 if hasOutput(true)
  write $TOP

 # Collect the java version
 debug " Inside DFlinux, collect the Java versions"
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
