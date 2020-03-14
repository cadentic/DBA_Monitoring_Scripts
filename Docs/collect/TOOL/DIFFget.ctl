# DIFFget.ctl: Gets Comparison Data
# $Id: DIFFget.ctl,v 1.11 2015/02/20 15:44:29 RDA Exp $
# ARCS: $Header: /home/cvs/cvs/RDA_8/src/scripting/lib/collect/TOOL/DIFFget.ctl,v 1.11 2015/02/20 15:44:29 RDA Exp $
#
# Change History
# 20150220  JJU  Add AIX support.

=head1 NAME

TOOL:DIFFget - Performs Data Collections for Comparing Systems

=head1 DESCRIPTION

This module performs the data collection and generates the intermediate file
for comparing systems. The following collection types can be combined:

=cut

# Initialization
var $CRS_HOME = ${SET.DB.CRS.D_CRS_HOME}
var $SYSDBA   = ${SET.DB.DB.B_SYSDBA/P}

var $RE = '(.*?)\b((ADDRESS|DESCRIPTION|SID)(_LIST)?|CONNECT_DATA|DEDICATED|\
                   GLOBAL_DBNAME|HOST|(INSTANCE|SERVICE|SID)_NAME|IPC?|KEY|\
                   LOAD_BALANCE|ORACLE_HOME|PORT|PRESENTATION|PROGRAM|\
                   PROTOCOL|SERVER|SID(_DESC)?|SHARED|TCP)\b(.*)'

# Load operating system-specific macros
if match(${RDA.T_OS},'aix')
 run TOOL:DFaix()
elsif match(${RDA.T_OS},'linux')
 run TOOL:DFlinux()
elsif or(isWindows(),isCygwin())
 run TOOL:DFwin32()

=head2 ASM - Automatic Storage Management Information

Collects the Automatic Storage Management parameters, hidden parameters,
product inventory, and file information on some executable files.

=cut

macro collect_asm
{var ($ind) = @arg
 import $ORACLE_HOME,$TOP

 # Initialization
 var $ASM_ORACLE_HOME = ${SET.DB.ASM.D_ORACLE_HOME:$ORACLE_HOME}

 write '---+ CHAPTER:410:Automatic Storage Management'

 # Switch to the ASM context
 call setSqlTarget(${SET.DB.ASM.I_DB})

 # Collect the ASM parameters
 if !testSql()
 {incr $ind
  debug " Inside DIFFget, collect the ASM parameters"
  prefix
  {write '---++ SECTION:100:ASM Parameters'
   write '|*Name*|*Value #*|'
  }
  set $sql
  {SELECT '|' ||
  "       SUBSTR(name, 0, 512) || '|' ||
  "       NVL(SUBSTR(value, 0, 512), '%NULL%') || '|'
  " FROM v$parameter;
  }
  call writeSql($sql)
  if hasOutput(true)
   write $TOP

  # Collect the hidden ASM parameters
  debug " Inside DIFFget, collect the hidden ASM parameters"
  prefix
  {write '---++ SECTION:110:Hidden ASM Parameters'
   write '|*Name*|*Compare*|*Default #*|*Value #*|'
  }
  set $sql
  {SELECT '|' ||
  "       SUBSTR(a.ksppinm,0,512) || '|' ||
  "       b.ksppstdf || ':' ||
  "         REPLACE(REPLACE(b.ksppstvl,'|','&#124;'),CHR(10),'%BR%') || '|' ||
  "       b.ksppstdf || '|' ||
  "       NVL(REPLACE(REPLACE(SUBSTR(b.ksppstvl,0,512),'|','&#124;'),
  "                   CHR(10),'%BR%'),'%NULL%') || '|'
  " FROM x$ksppi a,x$ksppsv b
  " WHERE a.indx = b.indx
  "   AND a.ksppinm LIKE '\_%' ESCAPE '\'
  " ORDER BY a.ksppinm;
  }
  call writeSql($sql)
  if hasOutput(true)
   write $TOP
 }

 # Collect the inventory and file information if different Oracle homes
 if ${SET.DB.ASM.B_DISTINCT_HOME:false}
 {# Collect the inventory information
  debug " Inside DIFFget, collect ASM inventory"
  call get_inventory(300,'ASM',$ASM_ORACLE_HOME)

  # Collect information on ASM executable files
  debug " Inside DIFFget, collect information on ASM executable files"
  call collect_file_info(900,'ASM Executables',\
                         catDir($ASM_ORACLE_HOME,'bin'),'(^\.+|O)$')
  debug " Inside DIFFget, collect information on ASM libraries"
  call collect_file_info(910,'ASM Libraries',\
                         catDir($ASM_ORACLE_HOME,'lib'),'^\.+$')
 }
}

=head2 DB - Oracle Database Information

Collects the Oracle database parameters and hidden parameters.

=cut

macro collect_db
{import $SYSDBA,$TOP

 write '---+ CHAPTER:210:Database'

 # Switch to the DB context
 call setSqlTarget(${SET.DB.DB.I_DB})

 # Collect the database parameters
 debug " Inside DIFFget, collect the database parameters"
 prefix
 {write '---++ SECTION:100:Database Parameters'
  write '|*Name*|*Value #*|'
 }
 set $sql
 {SELECT '|' ||
 "       SUBSTR(name, 0, 512) || '|' ||
 "       NVL(SUBSTR(value, 0, 512), '%NULL%') || '|'
 " FROM v$parameter
 " ORDER BY name;
 }
 call writeSql($sql)
 if hasOutput(true)
  write $TOP

 # Collect the hidden database parameters
 if $SYSDBA
 {debug " Inside DIFFget, collect the hidden database parameters"
  prefix
  {write '---++ SECTION:110:Hidden Database Parameters'
   write '|*Name*|*Compare*|*Default #*|*Value #*|'
  }
  set $sql
  {SELECT '|' ||
  "       SUBSTR(a.ksppinm,0,512) || '|' ||
  "       b.ksppstdf || ':' ||
  "         REPLACE(REPLACE(b.ksppstvl,'|','&#124;'),CHR(10),'%BR%') || '|' ||
  "       b.ksppstdf || '|' ||
  "       NVL(REPLACE(REPLACE(SUBSTR(b.ksppstvl,0,512),'|','&#124;'),
                      CHR(10),'%BR%'),'%NULL%') || '|'
  " FROM x$ksppi a,x$ksppsv b
  " WHERE a.indx = b.indx
  "   AND a.ksppinm LIKE '\_%' ESCAPE '\'
  " ORDER BY a.ksppinm;
  }
  call writeSql($sql)
  if hasOutput(true)
   write $TOP
 }
}

=head2 EPM - Enterprise Performance Management System Information

Collects the Enterprise Performance Management product inventory, and common
file information.

=cut

macro collect_epm
{import $EPM_HOME,$TOP

 write '---+ CHAPTER:545:Enterprise Performance Management System'

 # Collect the inventory and file information
 debug " Inside DIFFget, collect EPM inventory"
 call get_inventory(300,'EPM',$EPM_HOME)

 # Collect the registry information
 debug " Inside DIFFget, collect EPM Windows registry"
 call collect_registry(700,'EPM Windows Registry',\
                       'HKLM\SOFTWARE\Hyperion Solutions','\S+')
 call collect_registry(701,'.Net Windows Registry',\
                       'HKLM\Microsoft\NET Framework Setup\NDP','\S+')

 # Collect information on EPM Files
 debug " Inside DIFFget, collect information on common EPM Files"
 call collect_file_info(900,'EPM Files',\
                        $EPM_HOME,\
                        '\.(dll|exe|jar|asp|ass|css|cs|js|xml|xslt)$','dir',\
                        $EPM_HOME,'$EPM_HOME')
}

=head2 EPMA - Enterprise Performance Management Architect Information

Collects the Enterprise Performance Management Architect file information.

=cut

macro collect_epma
{import $EPM_HOME,$TOP

 write '---+ CHAPTER:572:Enterprise Performance Management Architect'

 # Collect the dme.properties file
 debug " Inside DIFFget, collect dme.properties"
 call collect_properties(800,\
   catDir($EPM_HOME,'products','Foundation','BPMA','config','DataSync'),\
   'dme.properties')

 # Collect the AwbConfig.properties file
 debug " Inside DIFFget, collect AwbConfig.properties"
 call collect_properties(801,\
   catDir($EPM_HOME,'products','Foundation','BPMA','config','WebTier'),\
   'AwbConfig.properties')

 # Collect the BPMAPlus.properties file
 debug " Inside DIFFget, collect BPMAPlus.properties"
 call collect_properties(802,\
   catDir($EPM_HOME,'products','Foundation','BPMA','EPMABatchClient','conf'),\
   'BPMAPlus.properties')

 # Collect information on EPMA Files
 debug " Inside DIFFget, collect information on EPMA Files"
 call collect_file_info(900,'EPMA Files',\
                        catDir($EPM_HOME,'products','Foundation','BPMA'),\
                        '\.(dll|exe|jar|asp|ass|css|cs|js|xml|xslt)$','dir',\
                        $EPM_HOME,'$EPM_HOME')
}

=head2 HFM - Hyperion Financial Management Information

Collects the HFM file information.

=cut

macro collect_hfm
{import $EPM_HOME,$TOP

 write '---+ CHAPTER:564:Hyperion Financial Management'

 # Collect information on HFM Files
 debug " Inside DIFFget, collect information on HFM Files"
 call collect_file_info(900,'HFM Files',\
                        catDir($EPM_HOME,'products','FinancialManagement'),\
                        '\.(dll|exe|jar|asp|ass|css|cs|js|xml|xslt)$','dir',\
                        $EPM_HOME,'$EPM_HOME')
}

=head2 Extra - Extra Information

Collects file information for the extra directories.

=cut

macro collect_extra
{import $TOP

 write '---+ CHAPTER:900:Extra Information'

 var $cnt = 100
 loop $dir (@arg)
 {if  testDir('dr',$dir)
  {debug " Inside DIFFget, collect file information from ",$dir
   call collect_file_info($cnt,concat('Files from ',$dir),$dir,'^\.+$')
  }
  incr $cnt
 }
}

=head2 OH - Oracle Home Information

Analyzes Oracle home files: F<sqlnet.ora>, F<listener.ora>, and
F<tnsnames.ora>. It performs a basic parsing of those files and applies a few
normalization rules on the values. The final report contains the original files.

It collects the product inventory and file information on some executable files
also.

=cut

macro collect_oh
{import $ORACLE_HOME,$ORACLE_SID,$TOP

 write '---+ CHAPTER:200:Oracle Home'

 # Determine the TNS_ADMIN directory
 if getEnv('TNS_ADMIN')
  var $TNS_ADMIN = last
 else
 {var $TNS_ADMIN = catDir($ORACLE_HOME,'network','admin',\
                          concat($ORACLE_SID,'_',${RDA.T_NODE}))
  if !?testDir('d',$TNS_ADMIN)
   var $TNS_ADMIN = catDir($ORACLE_HOME,'network','admin')
 }

 # Collect the sqlnet.ora file
 debug " Inside DIFFget, collect sqlnet.ora"
 call collect_net(200,$TNS_ADMIN,'sqlnet.ora')

 # Collect the listener.ora file
 debug " Inside DIFFget, collect listener.ora"
 call collect_net(210,$TNS_ADMIN,'listener.ora')

 # Collect the tnsnames.ora file
 debug " Inside DIFFget, collect tnsnames.ora"
 call collect_net(220,$TNS_ADMIN,'tnsnames.ora')

 # Collect Oracle Home Inventory information
 debug " Inside DIFFget, collect Oracle home inventory"
 call get_inventory(300,'database',$ORACLE_HOME)

 # Collect information on Oracle home executable files
 debug " Inside DIFFget, collect information on Oracle home executable files"
 call collect_file_info(900,'Oracle Home Executables',\
                        catDir($ORACLE_HOME,'bin'),'(^\.+|O)$')
 debug " Inside DIFFget, collect information on Oracle home libraries"
 call collect_file_info(910,'Oracle Home Libraries',\
                        catDir($ORACLE_HOME,'lib'),'^\.+$')
}

=head2 RAC - Real Application Cluster Information

Checks if RAC is linked in the Oracle executable and collects CSS Daemon status,
F<crs_stat> details, and product inventory.

=cut

macro collect_rac
{var ($ind) = @arg
 import $CRS_HOME,$ORACLE_HOME,$ORACLE_SID,$OSN,$TOP

 write '---+ CHAPTER:400:Real Application Cluster'

 # Check if RAC is linked in the Oracle executable
 if match($OSN,'aix|dec_osf|hpux|linux|solaris')
 {debug " Inside DIFFget, check if RAC is linked in the Oracle executable"
  write '---++ SECTION:100:Real Application Cluster Option Verification'
  write '|*Name*|*Value #*|'
  var $cmd = concat('nm -r ',cond(match($OSN,'aix'),'-X 64 ',''),\
                    catCommand($ORACLE_HOME,'rdbms','lib','libknlopt.a'))
  if grepCommand(concat($cmd,' 2>/dev/null'),'kcsm\.o','f')
   write '|RAC Linked|Yes|'
  else
   write '|RAC Linked|No|'
  write $TOP
 }

 # Collect CRS home details
 if get_crs_home()
 {var $crs = last

  # Collect the CSS Daemon status
  if ?testFile('r',catFile($crs,'bin','olsnodes'))
  {debug " Inside DIFFget, collect CSS daemon status"
   write '---++ SECTION:200:CSS Daemon Status'
   write '|*Name*|*Value #*|'
   var $cmd = concat(catCommand($crs,'bin','crsctl'),' check css')
   var ($str) = command($cmd)
   write '|CSS Daemon Status|',$str,'|'
   write $TOP
  }

  # Collect the CRS Stat Details
  debug " Inside DIFFget, collect crs_stat details"
  prefix
  {write '---++ SECTION:210:crs_stat Details'
   write '|*Name*|*Value #*|'
  }
  var $cmd = concat(catCommand($crs,'bin','crs_stat'),' -t')
  var @itm = ('asm','db','gsd','inst','lsnr','ons','vip')
  var $pat = concat('(',join('|',@itm),')')
  var %tbl = ()
  loop $lin (grepCommand($cmd,${RDA.T_NODE}))
  {var $nam = field('\s+',0,$lin)
   var $val = field('\s+',3,$lin)
   if match($nam,$pat)
   {var ($itm) = last
    var $tbl{$itm} = join('%BR%',$tbl{$itm},$val)
   }
  }
  loop $itm (@itm)
   write '|',$itm,'|',nvl($tbl{$itm},'%R:Missing%'),'|'
  if hasOutput(true)
   write $TOP

  # Collect the cluster inventory
  debug " Inside DIFFget, collect CRS inventory"
  call get_inventory(300,'cluster',$crs)

  # Collect information on CRS executable files
  debug " Inside DIFFget, collect information on CRS executable files"
  call collect_file_info(900,'CRS Executables',\
                         catDir($crs,'bin'),'(^\.+|O)$')
  debug " Inside DIFFget, collect information on CRS libraries"
  call collect_file_info(910,'CRS Libraries',\
                         catDir($crs,'lib'),'^\.+$')
 }
}

# -----------------------------------------------------------------------------
# Define auxiliary macros
# -----------------------------------------------------------------------------

# Collect file information
macro collect_file_info
{var ($ind,$ttl,$dir,$pat,$opt,$bas,$abr) = @arg
 import $TOP

 prefix
 {write '---++ SECTION:',$ind,':',$ttl
  write '|*File*|*Mode #*%BR%*UID #*%BR%*GID #*%BR%*Size #*%BR%*Checksum #*|'
 }
 if $abr
  var $bas = concat('^',verbatim($bas),'\b')
 loop $fil (grepDir($dir,$pat,nvl($opt,'npv')))
 {next !?testFile('f',$fil)
  if getStat($fil)
  {var @sta = last
   write '|',encode(cond($abr,replace($fil,$bas,$abr),basename($fil))),'|',\
     join('%BR%',fmt_mode($sta[2]),$sta[4],$sta[5],$sta[7],checksum($fil)),'|'
  }
 }
 if hasOutput(true)
  write $TOP
 return
}

# Collect the Oracle network files
macro collect_net
{var ($ind,$dir,$nam) = @arg
 import $RE,$TOP

 if createBuffer('BUF','R',catFile($dir,$nam))
 {# Define the line assembly macro
  macro rec_sqlnet
  {var ($key,\@lin,\%cmp,\%val) = @arg
   import $RE

   var $str = ''
   var $suf = replace(join(' ',@lin),'\s+','',true)
   while match($suf,$RE,true)
   {var ($pre,$itm,@tbl) = last
    var $str = concat($str,$pre,lc($itm))
    var $suf = $tbl[-1]
   }
   var $cmp{$key} = concat($str,$suf)
   var $val{$key} = replace(join('%BR%',@lin),'\s','&nbsp;',true)
  }

  # Parse the file
  var ($key,@lin,%cmp,%val) = ('')
  while getLine('BUF')
  {var $lin = chomp(last)
   if match($lin,'^(\s*#|\s*$)')
   {if $key
     call rec_sqlnet($key,\@lin,\%cmp,\%val)
    var ($key,@lin) = ('')
    next
   }
   if match($lin,'^\s*([\.\w]+)\s*=\s*(.*)')
   {var ($nxt,$lin) = last
    if $key
     call rec_sqlnet($key,\@lin,\%cmp,\%val)
    var ($key,@lin) = (uc($nxt))
   }
   if $lin
    call push(@lin,$lin)
  }
  if $key
   call rec_sqlnet($key,\@lin,\%cmp,\%val)

  # Display the parsing results
  prefix
  {write '---++ SECTION:',$ind,':',$nam
   write '|*Name*|*Compare*|*Value #*|'
  }
  loop $key (keys(%cmp))
   write '|',$key,'|',$cmp{$key},'|``',$val{$key},'``|'
  if hasOutput(true)
   write $TOP
  call deleteBuffer('BUF')
 }
}

# Collect the properties files
macro collect_properties
{var ($ind,$dir,$nam) = @arg
 import $TOP

 if ?testFile(cond(isWindows(),'f',\
                   isCygwin(), 'f',\
                               'fr'),\
             catFile($dir,$nam))
 {var %tbl = ()
  loop $lin (grepFile(lastFile(),'^[^#]'))
   var $tbl{key($lin)} = value($lin)

  # Display the parsing results
  prefix
  {write '---++ SECTION:',$ind,':',$nam
   write '|*Name*|*Value*|'
  }
  loop $key (keys(%tbl))
   write '|',$key,'|',$tbl{$key},'|'
  if hasOutput(true)
   write $TOP
 }
}

# Collect windows registry information
macro collect_registry
{var ($ind,$ttl,$bas,$pat) = @arg
 import $TOP

 prefix
 {write '---++ SECTION:',$ind,':',$ttl
  write '|*Key-Name*|*Value*|'
 }
 var %reg = ()
 loop $itm (grepRegValue($bas,$pat,true))
 {var ($key,$nam) = split('\|',$itm,2)
  var $reg{$key,$nam} = getRegValue($key,$nam)
 }
 loop $key (keys(%reg))
 {loop $nam (keys($reg{$key}))
  {write '|',$key,'-',$nam,'|',$reg{$key,$nam},'|'
  }
 }
 if hasOutput(true)
  write $TOP
 return
}

# Convert the mode in its symbolic format
macro fmt_bit
{var ($val,$flg) = @arg

 var @bit = ('---','--x','-w-','-wx','r--','r-x','rw-','rwx',\
             '--S','--s','-wS','-ws','r-S','r-s','rwS','rws')
 if $flg
  incr $val,8
 return $bit[$val]
}

# Format the file mode
macro fmt_mode
{var ($mod) = @arg

 return concat(substr("?pc?d?b?-?l?s???",expr('&',expr('>>',$mod,12),15), 1),\
   fmt_bit(expr('&',expr('>>',$mod,6),7),expr('&',$mod,2048)),\
   fmt_bit(expr('&',expr('>>',$mod,3),7),expr('&',$mod,1024)),\
   fmt_bit(expr('&',$mod,7),             expr('&',$mod,512)))
}

# Protect version numbers
macro fmt_version
 return replace($arg[0],'\.','&#46;',true)

# Determine the CRS home
macro get_crs_home
{import $CRS_HOME
 keep $CRS_HOME

 if !?$CRS_HOME
  run DB:CRSinit(\$CRS_HOME)
 return $CRS_HOME
}

# Get the versions and patchsets from the inventory
macro get_inventory
{var ($ind,$typ,$dir) = @arg
 import $TOP

 if ?testFile('fr',catFile($dir,'inventory','ContentsXML','comps.xml'))
  call get_inventory_details($ind,$typ,lastFile())
 elsif loadFile(catFile($dir,'orainst',cond(isWindows(),'nt.rgs',\
                                            isCygwin(), 'nt.rgs',\
                                                        'unix.rgs')))
 {incr $ind,10
  prefix
  {write '---++ SECTION:',$ind,':',ucfirst($typ),' Installed Products'
   write '|*Name*|*Version #*|'
  }
  var $flt = isFiltered()
  loop $lin (getLines())
  {next !match($lin,'Product files loaded')
   var @tbl = split('"',$lin)
   write '|',$tbl[5],' |',cond($flt,fmt_version($tbl[3]),$tbl[3]),' |'
  }
  if hasOutput(true)
   write $TOP
 }
}

macro get_inventory_details
{var ($ind,$typ,$fil) = @arg
 import $TOP

 var $flt = isFiltered()
 var $inv = xmlLoadFile($fil)

 # Explore the top level products
 var ($cnt,%all,%top_dsc,%top_set,%top_ver) = (0)
 loop $xml (xmlFind($inv,'PRD_LIST/TL_LIST/COMP'))
 {var $nam = xmlValue($xml,'NAME')
  var $ver = xmlValue($xml,'VER')
  var $dsc = xmlData(xmlFind($xml,'EXT_NAME'))

  var $key = uc($dsc)
  var $all{$key} = join('"',$all{$key},$nam)

  var $top_dsc{$nam} = $dsc
  var $top_ver{$nam} = cond($flt,fmt_version($ver),$ver)
 }

 # Explore the patchsets
 loop $xml (xmlFind($inv,'PRD_LIST/TL_LIST/PATCHSET'))
 {var $nam = xmlValue($xml,'NAME')
  var $ver = xmlValue($xml,'VER')
  var $dsc = xmlData(xmlFind($xml,'EXT_NAME'))

  if $flt
   var $ver = fmt_version($ver)

  if missing($top_dsc{$nam})
  {var $key = uc($dsc)
   var $all{$key} = join('"',$all{$key},$nam)
   var $top_dsc{$nam} = $dsc
  }
  var $top_set{$nam} = join(', ',$top_set{$nam},$ver)

  incr $cnt
  var $dsc[$cnt] = $dsc
  var $ver[$cnt] = $ver
 }

 # Report top level products
 prefix
 {write '---++ SECTION:',$ind,':',ucfirst($typ),' Top Level Products'
  write '|*Name*|*Version #*%BR%*PatchSet(s) #*|'
 }
 loop $key (keys(%all))
 {loop $nam (split('"',$all{$key}))
   write '|',encode($top_dsc{$nam}),'|',\
         $top_ver{$nam},'%BR%',nvl($top_set{$nam},"''&lt;none&gt;''"),' |'
 }
 if hasOutput(true)
  write $TOP

 # Explore the installed products and the patches
 var (%all,%prd_dsc,%prd_set,%prd_ver) = ()
 loop $xml (xmlFind($inv,'PRD_LIST/COMP_LIST/COMP'))
 {var $nam = xmlValue($xml,'NAME')
  var $ver = xmlValue($xml,'VER')
  var $dsc = xmlData(xmlFind($xml,'EXT_NAME'))

  if $flt
   var $ver = fmt_version($ver)

  var $key = uc($dsc)
  var $all{$key} = join('"',$all{$key},$nam)
  var $prd_dsc{$nam} = $dsc
  var $prd_ver{$nam} = $ver
 }

 # Explore the patches
 loop $xml (xmlFind($inv,'PRD_LIST/COMP_LIST/PATCH'))
 {var $nam = xmlValue($xml,'NAME')
  var $ver = xmlValue($xml,'VER')
  var $dsc = xmlData(xmlFind($xml,'EXT_NAME'))

  if $flt
   var $ver = fmt_version($ver)

  if missing($prd_dsc{$nam})
  {if exists($top_dsc{$nam})
    var ($dsc,$prd_ver{$nam}) = ($top_dsc{$nam},$top_ver{$nam})
   var $key = uc($dsc)
   var $all{$key} = join('"',$all{$key},$nam)
   var $prd_dsc{$nam} = $dsc
  }
  var $prd_set{$nam} = join(', ',$prd_set{$nam},$ver)
 }

 # Report the installed products
 incr $ind,10
 prefix
 {write '---++ SECTION:',$ind,':','',ucfirst($typ),' Installed Products'
  write '|*Name*|*Version #*%BR%*Patch(es) #*|'
 }
 loop $key (keys(%all))
 {loop $nam (split('"',$all{$key}))
   write '|',encode($prd_dsc{$nam}),'|',\
         $prd_ver{$nam},'%BR%',$prd_set{$nam},'|'
 }
 if hasOutput(true)
  write $TOP

 # Report the patchsets
 if xmlFind($inv,'PRD_LIST/ONEOFF_LIST/ONEOFF')
 {incr $ind,10
  prefix
  {write '---++ SECTION:',$ind,':',ucfirst($typ),' Interim Patches'
   write '|*Patch*|*Base Bug(s) #*|'
  }
  loop $xml (xmlFind($inv,'PRD_LIST/ONEOFF_LIST/ONEOFF'))
  {var (@bug,%fil) = ()
   loop $det (xmlFind($xml,'BUG_LIST/BUG'))
    call push(@bug,xmlData($det))
   write '|',xmlValue($xml,'REF_ID'),'|',join(', ',@bug),' |'
  }
  if hasOutput(true)
   write $TOP
 }
}

# -----------------------------------------------------------------------------
# Extract the data for comparing systems
# -----------------------------------------------------------------------------

var ($fil,$set,$typ,$dir) = @arg
import $ORACLE_SID,$TOC,$TOP

# Initialize the collection
if !$typ
 var $typ = 'ASM,DB,EPM,EPMA,HFM,OH,OS,RAC'

# Create the collection report
call $[OUT]->add_report('S',$fil,0)
write '---+!! CHAPTER:000:Comparison Data'
write $TOC
write '---+ INTRO:000:Collection Information'
write '|*Parameter*|*Value #*|'
write '|Host Name|',${RDA.T_NODE},'|'
write '|Operating System|',${RDA.T_OS},'|'
write '|Collect Type|',$typ,'|'
write '|Collect Time (UTC)|',${RDA.T_GMTIME},'|'
write $TOP

# Extract data
loop $itm (split(',',$typ))
 var $typ{uc($itm)} = 1
if $typ{'OS'}
{if isImplemented('collect_os')
  call collect_os()
}
if $typ{'OH'}
 call collect_oh()
if and($typ{'DB'},$ORACLE_SID)
 call collect_db()
if $typ{'RAC'}
 call collect_rac()
if and($typ{'ASM'},${SET.DB.ASM.B_IN_USE:true})
 call collect_asm()
if $typ{'EPM'}
 call collect_epm()
if $typ{'HFM'}
 call collect_hfm()
if $typ{'EPMA'}
 call collect_epma()
if $dir
 call collect_extra(split('\|',$dir))
close
return getFile('.')

=head1 SEE ALSO

L<DB:CRSinit|collect::DB:CRSinit>,
L<TOOL:DFlinux|collect::TOOL:DFlinux>,
L<TOOL:DIFFcmp|collect::TOOL:DIFFcmp>,
L<TOOL:DFwin32|collect::TOOL:DFwin32>,
L<TOOL:TLdiff|collect::TOOL:TLdiff>

=begin credits

=over 10

=item RDA 4.10: Michel Villette.

=item RDA 4.11: Nizamuddin Khan, Michel Villette.

=item RDA 4.24: Jaime Alcoreza.

=back

=head1 COPYRIGHT NOTICE

Copyright (c) 2002, 2016, Oracle and/or its affiliates. All rights reserved.

=head1 TRADEMARK NOTICE

Oracle and Java are registered trademarks of Oracle and/or its
affiliates. Other names may be trademarks of their respective owners.

=cut
