# TLdiff.ctl: Compares Two Systems
# $Id: TLdiff.ctl,v 1.12 2015/05/20 17:49:22 RDA Exp $
# ARCS: $Header: /home/cvs/cvs/RDA_8/src/scripting/lib/collect/TOOL/TLdiff.ctl,v 1.12 2015/05/20 17:49:22 RDA Exp $
#
# Change History
# 20150515  KRA  Improve the documentation.

=head1 NAME

TOOL:TLdiff - Compares Two Systems

=head1 DESCRIPTION

This tool compares two systems or two samples from the same system.

For remote collections:

=over 4

=item *

A remote collection setup must be performed before running this tool. Use a
command similar to the following:

 <rda> -vXRda start CLOUD /

=item *

Data is extracted remotely on all nodes and transferred back into the F<sample>
subdirectory. Collected samples are regrouped in a result set.

=back

You can compare samples from the same result set only. A list of all samples,
grouped by result sets, is available.

=head1 USAGE

This tool can be used in two ways:

=over 3

=item a)

Runs interactively. It requests the user to enter the required information.

 <rda> -vT diff

=item b)

Runs from the command line. The input can be given in the command line using
the following syntax:

 <rda> -vT diff:A:<set>,<sample>:<type>[,...][:<dir>|...]

Performs a data collection on all remote nodes. E<lt>setE<gt> is the result
name.

 <rda> -vT diff:B:<set>,<node>,<sample>:<type>[,...][:<dir>|...]

Performs a data collection on the local host. E<lt>setE<gt> is the result name.

 <rda> -vT diff:C:<set>:<node1>,<sample1>:<node2>,<sample2>

Compares two data collections.

 <rda> -vT diff:D

Lists all available samples, grouped by result set.

 <rda> -vT diff:E:<set>:<spec_name>:<type>[,...][:<dir>|...]

Prepares a specification file for comparing independent systems.

 <rda> -vT diff:F:<node>,<sample>:<spec_path>

Verifies the prerequisites and performs a data collection based in a
specification file.

=back

=cut

use Remote

section tool

# Initialization
var $DIFF_REPORT = '%s_%06d_%s'
var $DIFF_FILE   = 'TOOL_DIFF_%s_%06d_%s.txt'
var $EPM_HOME    = \
  ${SET.BI.EPM.D_HOME:${ENV.EPM_ORACLE_HOME:${ENV.HYPERION_HOME:''}}}
var $ORACLE_HOME = ${SET.RDA.BEGIN.D_ORACLE_HOME:${ENV.ORACLE_HOME:''}}
var $ORACLE_SID  = ${SET.DB.DB.T_ORACLE_SID/P:${ENV.ORACLE_SID:''}}

var $RE_SET = '^([A-Za-z]\w*)$'

var $TOP = '[[#Top][Back to top]]'
var $TOC = '%TOC%'

#------------------------------------------------------------------------------
# Define the remote operation macros
#------------------------------------------------------------------------------

# Check a remote installation
macro check_install
{var ($nod,$flg) = @arg

 # Check the remote RDA installation
 if rda($nod,'-XRda check -R',true)
 {if !$flg
   return 1

  # Check for file alterations
  if !getRemoteLines()
   return 1
  loop $lin (last)
  {if !match($lin,'^\s*(RDA-(00012|01603):|(\*\s+)?File .* altered$)')
    return 1
  }
 }

 # Indicate a successful RDA installation
 return 0
}

# Get a remote setting
macro get_node
 return ${<'COL/REMOTE',$arg[0],$arg[1]>:$arg[2]}

# Define the storage detection macro
macro get_storage
{var ($nod,$loc,$rem,$wrk) = @arg

 var $nam = getRemoteSetup($nod)

 # Detect a local node
 if !isRemote($nod)
 {if transfer($loc,$nam,$rem,$nam,true)
   return ('R','W_STORAGE=LOCAL')
  else
   return ('n')
 }

 # When needed, create the remote directory
 call rexec($nod,concat('mkdir -p ',quote($rem)))

 # Test the transfer of the setup file
 if put($nod,$loc,$nam,$rem,$nam)
  return ('n')

 # Detect if RDA software and data collection are separated
 if get_node($nod,'_SPLIT')
  return ('I','W_STORAGE=SPLIT')

 # Detect the current install is shared with the remote node
 if ?testFile('r',catFile($rem,$nam))
  return ('I','W_STORAGE=SHARED')

 # Otherwise assume a remote storage
 return ('I','W_STORAGE=REMOTE')
}

# Define the software installation macro
macro do_install
{var ($nod,$top) = @arg

 # Determine if software alterations are allowed
 var $flg = or(${COL.REMOTE.B_ALTER_ALLOWED},get_node($nod,'B_SPLIT'))

 # When not yet done, install the software
 var $pth = quote($top)
 if check_install($nod,$flg)
 {# When needed, create or modify the remote directory
  if expr('>',last,0)
   call rexec($nod,concat('mkdir -p ',$pth))
  else
   call rexec($nod,concat("chmod -R u+w ",$pth))

  # Transfer RDA software
  if mput($nod,true,\
    ${CFG.D_RDA},'(^rda[\.\_]|sdci[\.\_]|\.txt$|^Convert$|^I?RDA$|\
                   ^admin$|^collect$|^da$|^dfw|^engine$|^hcve$|^mesg$)',\
    $top)
   return 'i'
  if match(getRemoteSession($nod)->get_type,'^(da|jsch)$')
   call rexec($nod,join($pth,'chmod a+x ',\
     '/*.cmd ','/*.com ','/*.exe ','/*.pl ','/*.sh ','/engine/rda_*'))

  # Check the remote software allowing only altered modules
  if check_install($nod,$flg)
   return 'c'
 }

 # Indicate a successful completion
 return 'R'
}

macro do_run
{var ($nod,$wrk,$set,$num,$typ,$dir) = @arg

 if rda($nod,concat(' -s ',catFile($wrk,getRemoteSetup($nod)),\
        " -vT 'diff:L:",$set,',',$nod,',',$num,':',$typ,':',$dir,"'"))
  return 'r'

 # Indicate a successful completion
 return 'T'
}

# Define the package transfer macro
macro do_transfer
{var ($nod,$rem,$set,$num) = @arg
 import $DIFF_FILE
 if match(get_node($nod,'W_STORAGE'),'^(LOCAL|SHARED)$')
 {if !transfer(catDir($rem,concat(lc($nod),'_',${CUR.W_COLLECTOR}),'sample'),\
               sprintf($DIFF_FILE,$nod,$num,$set),\
                ${OUT.S})
    return 't'
 }
 elsif get($nod,catDir($rem, concat(lc($nod),'_',${CUR.W_COLLECTOR}),'sample'),\
           sprintf($DIFF_FILE,$nod,$num,$set),\
            ${OUT.S})
  return 't'

 # Indicate a successful completion
 return '-'
}

#------------------------------------------------------------------------------
# Define the actions
#------------------------------------------------------------------------------

# Collect the data based of a specification file
macro do_check
{var ($pth,$nod,$num) = @arg
 import $DIFF_REPORT

 # Parse the specification file
 var %tbl = ('grp','RDA')
 loop $lin (grepFile($pth,'^\w+='))
  var $tbl{key($lin)} = value($lin)
 if missing($tbl{'set'})
 {echo 'Invalid specification file'
  return
 }

 # Check if some setup is required
 var %req = (ASM  => 'DB:DCasm',\
             CRS  => 'DB:DCcrs',\
             DB   => 'DB:DCdba',\
             EPM  => 'BI:DCepm', \
             EPMA => 'BI:DCepma',\
             HFM  => 'BI:DChfm',\
             OH   => 'RDA:DCbegin')
 var %chk = (ASM  => 'DB.ASM.B_IN_USE',\
             CRS  => 'DB.CRS.B_IN_USE',\
             DB   => 'DB.DBA.B_IN_USE',\
             EPM  => 'BI.EPM.B_IN_USE',\
             EPMA => 'BI.EPMA.B_IN_USE',\
             HFM  => 'BI.HFM.B_IN_USE',\
             OH   => 'RDA.BEGIN.D_ORACLE_HOME')
 if !$tbl{'typ'}
  var $tbl{'typ'} = 'ASM,CRS,DB,EPM,EPMA,HFM,OH,OS'
 loop $mod (split(',',$tbl{'typ'}))
 {if !or(missing($chk{$mod}),${<'COL/SET',$chk{$mod}>/E})
   var $mod{$req{$mod}} = true
 }
 if keys(%mod)
 {var @mod = last
  echo 'The collection requires to setup the ',join(', ',@mod),' module(s)'
  echo '<rda> -S ',join(' ',@mod)
  return
 }

 # Execute the request
 var $rpt = sprintf($DIFF_REPORT,nvl($nod,'NOD001'),nvl($num,0),$tbl{'set'})
 run TOOL:DIFFget($rpt,$tbl{'set'},$tbl{'typ'},$tbl{'dir'})
 echo 'Transfer the ',last,' file'
 if $tbl{'tgt'}
  echo 'in the ',$tbl{'tgt'},' directory on ',nvl($tbl{'hst'},'localhost')
}

# List available result sets
macro do_list
{echo "\012Available Result Sets:"
 var $cnt = 0
 var $pat = concat('^',${CUR.W_PREFIX},'[A-Z0-9]+_\d+_(\w*)\.txt$')
 loop $fil (grepDir(${OUT.S},concat('^',${CUR.W_PREFIX}),'in'))
 {if match($fil,$pat,true)
   call push($tbl{last},$fil)
  incr $cnt
 }
 if $cnt
 {loop $set (keys(%tbl))
   dump "- Set '",$set,"':\012    ",join("\012    ",@{$tbl{$set}})
 }
 else
  echo '  No sets found'
}

# Perform a remote collection
macro do_request
{var ($set,$num,$typ,$dir) = @arg

 # Initialization
 if !@{COL.REMOTE.W_NODES}
 {echo 'No remote collection defined'
  return
 }
 var @nod = last

 # Recover step information for aborted sessions
 if initSteps(true)
  call endSteps()

 # Check if there are pending remote requests
 loop $nod (@nod)
 {if isRemote($nod)
  {call initRemote()
   break
  }
 }

 # Perform the data collection in separate threads
 loop $nod (@nod)
 {var ${COL.REMOTE.${VAR.nod}.T_STEP/T} = 'N'
  thread
  {import $nod,$set,$num,$typ,$dir
   if match(getStep($nod,'N'),'-')
    var $stp = 'N'
   else
    var $stp = getStep($nod,'N')
   var $top = get_node($nod,'T_HOME','.')
   var $wrk = get_node($nod,'T_WORK',${CFG.D_CWD})

   # Detect the storage type of the remote node
   if compare('eq',$stp,'N')
   {debug $nod,': Detecting storage type'
    var $stp = setStep($nod,get_storage($nod,${OUT.P},$wrk))
   }

   # Install the software on the remote node
   if compare('eq',$stp,'I')
   {debug $nod,': Installing RDA software'
    var $stp = setStep($nod,do_install($nod,$top))
   }

   # Execute remotely RDA command
   if compare('eq',$stp,'R')
   {debug $nod,': Running RDA command'
    var $stp = setStep($nod,do_run($nod,$wrk,$set,$num,$typ,$dir))
   }

   # Transfer the report package
   if compare('eq',$stp,'T')
   {debug $nod,': Transfering report package'
    var $stp = setStep($nod,do_transfer($nod,$wrk,$set,$num))
   }
  }
 }
 wait
 call endSteps()
}

# Produce a specification file
macro do_spec
{var ($set,$nam,$typ,$dir) = @arg

 # Validate the arguments
 if !length($nam)
  var $nam = 'spec'

 # Produce the specification file
 output S,$nam
 write 'dir=',encode($dir)
 write 'hst=',${RDA.T_NODE}
 write 'set=',$set
 write 'tgt=',encode(${OUT.S})
 write 'typ=',$typ
 var $rpt = getFile('/')
 close

 # Display the instructions
 echo '1. \001Copy the specification file ',$rpt,' on the systems where the \
              collection must be done.'
 echo '2. \001Execute the following command:\
          \012<rda> -vT diff:F:<spec file path>'
 echo '3. \001Transfer the result files in the ',dirname($rpt),' directory.'
 echo '4. \001Perform the comparaisons you want'
}

#------------------------------------------------------------------------------
# Main program
#------------------------------------------------------------------------------

echo tput('bold'),'Comparing systems ...',tput('off')

# Force the creation of the local sample directory
call setAbbr('TOOL_DIFF_')
call purge('S','DIFF\.tmp',0,0,true)

# Execute the request
if $arg[0]
{var ($opt,$set,@arg) = split(':',last)
 if compare('eq',$opt,'A')
 {var ($set,$num) = split(',',$set)
  if !match($set,$RE_SET)
   die 'Missing set'
  call do_request($set,$num,@arg)
 }
 elsif compare('eq',$opt,'C')
 {if !match($set,$RE_SET)
   die 'Missing set'
  var ($nod,$num) = split(',',$arg[0])
  var $fil1 = sprintf($DIFF_FILE,nvl($nod,'NOD001'),nvl($num,0),$set)
  var ($nod,$num) = split(',',$arg[1])
  var $fil2 = sprintf($DIFF_FILE,nvl($nod,'NOD001'),nvl($num,0),$set)
  run TOOL:DIFFcmp($fil1,$fil2)
 }
 elsif compare('eq',$opt,'D')
  call do_list()
 elsif or(compare('eq',$opt,'B'),compare('eq',$opt,'L'))
 {var ($set,$nod,$num) = split(',',$set)
  if !match($set,$RE_SET)
   die 'Missing set'
  run TOOL:DIFFget(\
    sprintf($DIFF_REPORT,nvl($nod,'NOD001'),nvl($num,0),$set),$set,@arg)
 }
 elsif compare('eq',$opt,'E')
 {if !match($set,$RE_SET)
   die 'Missing set'
  call do_spec($set,@arg)
 }
 elsif compare('eq',$opt,'F')
 {var ($nod,$num) = split(',',$set)
  call do_check(join(':',@arg),nvl($nod,'NOD999'),nvl($num,0))
 }
}
else
{call requestInput('TLdiff')
 var $opt = ${RUN.REQUEST.W_MENU}
 var $set = ${RUN.REQUEST.W_SET}
 if compare('eq',$opt,'A')
  call do_request($set,${RUN.REQUEST.N_SAMPLE},\
    join(',',@{RUN.REQUEST.W_TYPE}),join("|",@{RUN.REQUEST.D_ADD}))
 elsif compare('eq',$opt,'C')
 {if match($set,$RE_SET)
   run TOOL:DIFFcmp(\
     sprintf($DIFF_FILE,${RUN.REQUEST.W_NOD1},${RUN.REQUEST.N_SAMPLE1},$set),\
     sprintf($DIFF_FILE,${RUN.REQUEST.W_NOD2},${RUN.REQUEST.N_SAMPLE2},$set))
  else
   echo 'No set'
 }
 elsif compare('eq',$opt,'D')
  call do_list()
 elsif compare('eq',$opt,'E')
 {if match($set,$RE_SET)
   call do_spec($set,${RUN.REQUEST.F_SPEC},join(',',@{RUN.REQUEST.W_TYPE}),\
     join("|",@{RUN.REQUEST.D_ADD}))
  else
   echo 'No set'
 }
 elsif compare('eq',$opt,'F')
  call do_check(${RUN.REQUEST.F_SPEC},${RUN.REQUEST.W_NOD},\
                ${RUN.REQUEST.N_SAMPLE})
 elsif compare('eq',$opt,'L')
  run TOOL:DIFFget(sprintf($DIFF_REPORT,'NOD000',${RUN.REQUEST.N_SAMPLE},$set),\
    $set,join(',',@{RUN.REQUEST.W_TYPE}),join("|",@{RUN.REQUEST.D_ADD}))
}

=head1 SEE ALSO

L<TOOL:DIFFcmp|collect::TOOL:DIFFcmp>,
L<TOOL:DIFFget|collect::TOOL:DIFFget>

=begin credits

=over 10

=item RDA 4.10:  Michel Villette.

=back

=end credits

=head1 COPYRIGHT NOTICE

Copyright (c) 2002, 2016, Oracle and/or its affiliates. All rights reserved.

=head1 TRADEMARK NOTICE

Oracle and Java are registered trademarks of Oracle and/or its
affiliates. Other names may be trademarks of their respective owners.

=cut
