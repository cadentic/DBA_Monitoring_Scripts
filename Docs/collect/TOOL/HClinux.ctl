# HClinux.ctl: Linux Specific Code
# $Id: HClinux.ctl,v 1.5 2015/05/13 17:33:09 RDA Exp $
# ARCS: $Header: /home/cvs/cvs/RDA_8/src/scripting/lib/collect/TOOL/HClinux.ctl,v 1.5 2015/05/13 17:33:09 RDA Exp $
#
# Change History
# 20150513  KRA  Improve the documentation.

=head1 NAME

TOOL:HClinux - Submodule Specific to the Linux Operating System

=cut

# Make the module persistent
keep $KEEP_BLOCK,@SHARE_MACROS
var @SHARE_MACROS = ('chk_os_pkg','cmp_kernel','cmp_os_pkg',\
                     'cmp_os_pkg_range','fnd_os_pkg',\
                     'get_df','get_os_pkg','tst_os_pkg')

=head1 DESCRIPTION

This module determines the Linux flavor.

=cut

import $OS_NAM,$OS_TYP
keep $OS_NAM,$OS_TYP
var $OS_TYP = 'Unidentified'
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
 elsif match($fil,'Asianux',true)
  var ($OS_TYP,$OS_NAM) = ('Asianux',grepFile($fil,'Asianux','fi'))
 else
  next
 break
}

=pod

It determines the operating system version, architecture, and its bit size.

The following macros are available:

=cut

import $OS_ARC,$OS_BIT,$OS_LVL,$OS_PLT,$OS_VER
keep $OS_ARC,$OS_BIT,$OS_LVL,$OS_PLT,$OS_VER
var $OS_BIT = nvl(trim(command('getconf LONG_BIT')),32)
var $OS_PLT = 'Linux'
var ($OS_VER,$OS_LVL) = split('-',uname('r'),2)
if ?testFile('r','/proc/cpuinfo')
{#  - The 'model name' lines are found for x86 and AMD but not for ia64, ppc.
 #  - We don't need to identify other architecture than amd, ia64 and x86.
 #  - vendor_id: IBM/S390     for zLinux
 #  - platform : PowerMac
 #  - platform: pSeries
 #  - cpu: POWER...           for Linux on POWER
 var @lin = grepFile('/proc/cpuinfo',\
   '(Itanium|^(machine|model name|platform|vendor_id)\s*:\s)','i')
 if grep(@lin,'model name','if')
 {var $OS_ARC = field('\s+:\s+',1,last)
  if match($OS_ARC,'Intel',true)
   var $OS_ARC = 'Intel'
  elsif match ($OS_ARC,'AMD',true)
   var $OS_ARC = 'AMD'
 }
 elsif grep(@lin,'Itanium','if')
  var $OS_ARC = 'Itanium'
 elsif grep(@lin,'^vendor_id\s*:\sIBM\/S390','f')
  var $OS_ARC = 'zSeries'
 elsif grep(@lin,'(platform|vendor_id)\s*:\s','fi')
  var $OS_ARC = field('\s*:\s+',1,last)
 elsif grep(@lin,'^machine\s*:\sCHRP\sIBM','f')
  var $OS_ARC = 'pSeries'
}

=head2 cmp_kernel($name[,$ver[,$ref]])

This macro checks if the kernel release is valid. When no version or reference
is provided, it is rejected automatically as not certified.

=cut

macro cmp_kernel
{var ($nam,$ver,$ref) = @arg
 var $val = version(uname('r'))
 if !$ref
  var $ref = version($ver)
 if compare('VALID',$val,$ref)
  return 'Adequate'
 if $ver
  return concat('Need at least ',$ver,' for ',$nam)
 return concat($nam,' ',uname('r'),' is not certified')
}

=head2 get_df($dir)

This macro returns the number of free KiB on the file system containing the
specified directory.

=cut

macro get_df
{var ($dir) = @arg
 var ($lin) = grepCommand(concat('df -k ',quote($dir)),'\s\d+\%')
 var (undef,undef,undef,$siz) = split('\s+',$lin,5)
 return $siz
}

=head1 OPERATING SYSTEM PACKAGE MACROS

=head2 chk_os_pkg($name[,$architecture[,$options]])

This macro selects the operating system packages matching the name and
optionally the architecture. You can provide a regular expression for the
architecture. The architecture C<grep> options are specified as an extra
argument. It returns the number of packages found.

=cut

macro chk_os_pkg
{var ($nam,$arc,$opt) = @arg
 import $PKG,@PKG,%PKG
 keep $PKG,@PKG,%PKG

 # Load the package list on first call
 if $PKG
  call load_os_pkg()

 # Get the package list
 var @PKG = ()
 if exists($PKG{$nam})
 {var @PKG = split('\012',$PKG{$nam})
  if defined($arc)
   var @PKG = grep(@PKG,concat('\|',$arc,'$'),$opt)
 }
 return scalar(@PKG)
}

=head2 cmp_os_pkg(\@tbl,$name,$ref[,$architecture])

This macro lists the operating system packages matching the name and optionally
the architecture that are older than the specified reference.

=cut

macro cmp_os_pkg
{var (\@tbl,$nam,$ref,$arc,$pat,$rpl) = @arg

 if chk_os_pkg($nam,nvl($pat,$arc))
 {while get_os_pkg()
  {var ($ver,$rel) = (last)
   if ref($ref)
   {var $str = version($ver)
    var $min = version($ref->[0])
    next compare('newer',$str,$min)
    if or(compare('older',$str,$min),\
          compare('OLDER',version($ver,replace($rel,$rpl)),version(@{$ref})))
     call push(@tbl,concat('[',$nam,' ',\
                           replace($ver,'\.P:','_',true),'-',$rel,'] found'))
   }
   elsif compare('OLDER',version($ver,replace($rel,$rpl)),$ref)
    call push(@tbl,concat('[',$nam,' ',\
                          replace($ver,'\.P:','_',true),'-',$rel,'] found'))
  }
 }
 else
  call push(@tbl,concat('[',$nam,cond($arc,concat('(',$arc,')'),''),\
                          '] not installed'))
}

=head2 cmp_os_pkg_range(\@tbl,$name,$range[,$architecture[,$replace]])

This macro lists the operating system packages matching the name and optionally
the architecture that are not included in any specified version range.

The range argument is a reference to an array containing a sorted flat list of
minimum-maximum pairs. For an interval, the minimum is the first acceptable
version and the maximum is the first version that is no longer acceptable.

When present, the architecture argument provides a string indicating which
architecture must be tested or an array reference containing the preferred
architecture and a regular expression indicating all matching architecture.

When present, the replace argument is a reference to an array containing a list
of replace arguments to modify the release string before its normalization.

=cut

macro cmp_os_pkg_range
{var (\@tbl,$nam,$rng,$arc,$rpl) = @arg

 if ref($arc)
  var ($arc,$pat) = @{$arc}
 if chk_os_pkg($nam,nvl($pat,$arc))
 {while get_os_pkg()
  {var ($ver,$rel) = last
   if ?$rpl
   {var @rpl = @{$rpl}
    while @rpl
     var $rel = s($rel,splice(@rpl,0,2))
   }
   if chk_pkg_range($rng,$ver,$rel)
    call push(@tbl,concat('[',$nam,' ',\
                          replace($ver,'\.P:','_',true),'-',$rel,'] found'))
  }
 }
 else
  call push(@tbl,concat('[',$nam,cond($arc,concat('(',$arc,')'),''),\
                          '] not installed'))
}

macro chk_pkg_ge_lim
{var ($ref,$ver,$rel) = @arg

 if ref($ref)
 {var $str = version($ver)
  var $min = version($ref->[0])
  if compare('newer',$str,$min)
   return 1
  if compare('older',$str,$min)
   return 0
  var $ref = version(@{$ref})
 }
 return compare('VALID',version($ver,$rel),$ref)
}

macro chk_pkg_range
{var ($rng,$ver,$rel) = @arg

 var @rng = @{$rng}
 while @rng
 {var ($min,$max) = splice(@rng,0,2)
  if ?$max
   next chk_pkg_ge_lim($max,$ver,$rel)
  if ?$min
   break !chk_pkg_ge_lim($min,$ver,$rel)
  return 0
 }
 return 1
}

=head2 fnd_os_pkg($name,$ver,$ref[,$architecture])

This macro looks for a specified version of operating system packages matching
the name and optionally the architecture. It checks if the release is older
than the specified reference, and returns the corresponding message. It returns
an undefined value if the package is not found.

=cut

macro fnd_os_pkg
{var ($nam,$str,$ref,$arc,$pat) = @arg
 if chk_os_pkg($nam,nvl($pat,$arc))
 {while get_os_pkg()
  {var ($ver,$rel) = (last)
   next compare('ne',$ver,$str)
   if compare('OLDER',version($rel),version($ref))
    return concat('Need at least ',$nam,cond($arc,concat('(',$arc,')'),''),\
                  '-',$str,'-',$ref)
   return 'Adequate'
  }
 }
 return undef
}

=head2 get_os_pkg([...])

This macro gets the first hit from the list and returns the package information
as a list, containing the version, release, and architecture. It returns an
empty list when no -more- values are found.

When you specify arguments, it first performs a C<chk_os_pkg>.

=cut

macro get_os_pkg
{var ($nam) = @arg
 import @PKG
 keep @PKG

 # Select the operating system packages if a name is provided
 if defined($nam)
  call chk_os_pkg(@arg)

 # Get the information of the first package in the list
 var ($det,@PKG) = @PKG
 if $det
  return split('\|',$det)
 return ()
}

=head2 tst_os_pkg($name,$ref[,$architecture])

This macro tests if operating system packages matching the name and optionally
the architecture are older than the specified reference.

=cut

macro tst_os_pkg
{var ($nam,$str,$arc,$pat) = @arg
 if !chk_os_pkg($nam,nvl($pat,$arc))
  return concat('[',$nam,'] not installed')
 var $ref = version($str)
 while get_os_pkg()
 {var ($ver,$rel) = (last)
  if compare('OLDER',version($ver,$rel),$ref)
   return concat('Need at least ',$nam,cond($arc,concat('(',$arc,')'),''),\
                  '-',$str)
 }
 return 'Adequate'
}

# --- Internal operating system package macros --------------------------------

# Load all operating system macros
macro load_os_pkg
{import $PKG,$OS_TYP,%PKG

 var $PKG = false
 var $flg = match($OS_TYP,'SuSE')
 if loadCommand(\
   'rpm -qa --queryformat "%{NAME}|%{VERSION}|%{RELEASE}|%{ARCH}\n"')
 {loop $lin (getLines())
  {if $flg
   {var ($key,$ver,$det,$alt) = split('\|',chomp($lin),3)
    if match($ver,'\d_')
    {loop $str (split('\.',$ver))
     {if match($str,'^\d+_')
       var $str = replace($str,'_','.P:')
      var $alt = join('.',$alt,$str)
     }
     var $PKG{$key} = join("\012",$PKG{$key},join('|',$alt,$det))
    }
    else
     var $PKG{$key} = join("\012",$PKG{$key},join('|',$ver,$det))
   }
   else
   {var ($key,$det) = split('\|',chomp($lin),2)
    var $PKG{$key} = join("\012",$PKG{$key},$det)
   }
  }
 }
}

=head1 COPYRIGHT NOTICE

Copyright (c) 2002, 2016, Oracle and/or its affiliates. All rights reserved.

=head1 TRADEMARK NOTICE

Oracle and Java are registered trademarks of Oracle and/or its
affiliates. Other names may be trademarks of their respective owners.

=cut
