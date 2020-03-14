# HCVEexec.ctl: Executes HCVE Tests
# $Id: HCVEexec.ctl,v 1.14 2015/11/13 12:40:48 RDA Exp $
# ARCS: $Header: /home/cvs/cvs/RDA_8/src/scripting/lib/collect/TOOL/HCVEexec.ctl,v 1.14 2015/11/13 12:40:48 RDA Exp $
#
# Change History
# 20151113  MSC  Add rule link in the failure summary.

=head1 NAME

TOOL:HCVEexec - Executes Health Check/Validation Engine Rules.

=head1 DESCRIPTION

This test module applies HCVE rules to the current context. It removes all
previous reports for that rule set.

Produces the documentation of the specified rules set as a report.

=cut

use Buffer,Collect,Env,Hcve,Message,Report,Rda,Target,Xml

var $TOC = '%TOC%'
var $TOP = '[[#Top][Back to top]]'
keep $TOC,$TOP

# -----------------------------------------------------------------------------
# Initialize the rule set treatment
# -----------------------------------------------------------------------------

section begin

var $req = $arg[0]
global $[set] = $arg[1]
var ($ret,$ttl,%grp,%rpt) = (0,$[set]->{'ttl'})

echo tput('bold'),'Performing HCVE checks ...',tput('off')

# -----------------------------------------------------------------------------
# Rule related macros
# -----------------------------------------------------------------------------

# Evaluate a HCVE condition
macro eval_hcve_condition
{var ($rul,$rid) = @arg
 import %res
 keep %res

 # Detect circular references
 $val = $res{$rid,'res'}
 if compare('eq',$val,'LOOP')
  return (false,undef,\
    err => 'LOOP',\
    msg => concat('Rule: Circular dependencies found in ',$rid))

 # Check if a condition is specified
 if !?$rul->get_value('condition')
  return (true)

 # Evaluate the condition
 var $flg = false
 var $tbl{'tst'} = $tst = $rul->get_value('condition','')
 if compare('eq',$tst,'IS')
 {var $tbl{'min'} = $min = rpl_hcve_ref($rul->get_value('minimum'))
  var $flg = match($val,$min)
 }
 else
 {var $val = nvl($res{$rid,'val'},'')
  if compare('eq',$tst,'=~')
  {var $tbl{'min'} = $min = rpl_hcve_ref($rul->get_value('minimum'))
   var $flg = match($val,$min)
  }
  elsif compare('eq',$tst,'!~')
  {var $tbl{'min'} = $min = rpl_hcve_ref($rul->get_value('minimum'))
   var $flg = not(match($val,$min))
  }
  elsif match($tst,'^([=!]=|[<>]=?)$')
  {var $tbl{'min'} = $min = rpl_hcve_ref($rul->get_value('minimum'))
   var $flg = cond(and(isNumber($val),isNumber($min)),\
                   expr($tst,$val,$min),\
                   compare($tst,$val,$min))
  }
  elsif match($tst,'^B',true)
  {var $tbl{'min'} = $min = rpl_hcve_ref($rul->get_value('minimum'))
   var $tbl{'max'} = $max = rpl_hcve_ref($rul->get_value('maximum'))
   var $flg = cond(and(isNumber($val),isNumber($min),isNumber($max)),\
                   and(expr('>=',$val,$min),expr('<=',$val,$max)),\
                   and(compare('ge',$val,$min),compare('le',$val,$max)))
  }
  elsif match($tst,'^N',true)
   var $flg = isNumber($val)
  elsif match($tst,'^O',true)
  {var $tbl{'min'} = $min = rpl_hcve_ref($rul->get_value('minimum'))
   var $tbl{'max'} = $max = rpl_hcve_ref($rul->get_value('maximum'))
   var $flg = cond(and(isNumber($val),isNumber($min),isNumber($max)),\
                   or(expr('<',$val,$min),expr('>',$val,$max)),\
                   or(compare('lt',$val,$min),compare('gt',$val,$max)))
  }
  elsif match($tst,'^V[\-\+=!<>]$')
  {var $tbl{'min'} = $min = rpl_hcve_ref($rul->get_value('minimum'))
   var $flg = cond(compare($tst,$val,$min))
  }
  elsif match($tst,'^VB',true)
  {var $tbl{'min'} = $min = rpl_hcve_ref($rul->get_value('minimum'))
   var $tbl{'max'} = $max = rpl_hcve_ref($rul->get_value('maximum'))
   var $flg = and(compare('V+',$val,$min),compare('V-',$val,$max))
  }
  elsif match($tst,'^VO',true)
  {var $tbl{'min'} = $min = rpl_hcve_ref($rul->get_value('minimum'))
   var $tbl{'max'} = $max = rpl_hcve_ref($rul->get_value('maximum'))
   var $flg = or(compare('V<',$val,$min),compare('V>',$val,$max))
  }
 }
 return ($flg, $val, %tbl)
}

# Execute a rule
macro exec_hcve_rule
{var ($rid,@lid) = @arg
 import $tgt,@res,%err,%grp,%msg,%rul,%res,%stk
 keep $tgt,@res,%err,%grp,%msg,%rul,%res,%stk

 var $rul = $rul{$rid}
 var $uid = join('_',$rid,@lid)
 var $res{$uid} = {\
   dsc => $rul->find('sdp_description')->get_data,\
   lid => [@lid],\
   mod => $mod = uc($rul->get_value('mode','?')),\
   nam => $nam = $rul->get_value('name',$rid),\
   res => 'LOOP',\
   rid => $rid,\
   val => ''}

 # Check the dependencies
 loop $dep ($rul->find('sdp_dependencies/sdp_dependency'))
 {var $did = $dep->get_value('id','')

  # Resolve the dependency
  if ?find_did($did,@lid)
   var $did = last
  else
  {if missing($rul{$did})
   {debug sprintf('Executing Rule: [%-6s] %-20.20s - missing.',$did,'')
    var $err{$did} = 'Rule: Missing rule'
    var $res{$did} = {nam => '???',\
                      res => 'ERROR',\
                      val => 'NA'}
    call push(@res,$did)
   }
   elsif ?exec_hcve_rule($did,cond($dep->get_value('local'),@lid,list()))
    return last
  }

  # Check the condition
  var ($flg,$val,%tbl) = eval_hcve_condition($dep,$did)
  next $flg
  debug sprintf('Executing Rule: [%-6s] %-20.20s - dependency failure.',\
                $rid,$nam)
  var $res{$uid,'dep'} = $did
  if exists($tbl{'err'})
  {var $res{$uid,'res'} = $tbl{'err'}
   var $err{$uid} = $tbl{'msg'}
  }
  else
  {var $res{$uid,'prv'} = $val
   var $res{$uid,'res'} = $dep->get_value('result','FAILED')
   var $res{$uid,'syn'} = $dep->get_value('syntax','text')
   var $res{$uid,'val'} = $dep->get_value('value','NA')
   call get_text($res{$uid},$dep)
   loop $key (keys(%tbl))
    var $res{$uid,$key} = $tbl{$key}
   if $dep->get_value('error')
    var $err{$uid} = last
  }
  call push(@res,$uid)
  return undef
 }

 # Get the value
 call push(@res,$uid)
 call $[HCVE]->set_rule($rid)
 var ($msg,$val) = ()
 loop $itm ($rul->find('sdp_command'))
 {if $itm->get_value('exec')
   next skip_command(last)
  var $typ = uc($itm->get_value('type','?'))
  var $cmd = rpl_hcve_ref($itm->get_data)
  if !$cmd
   var $msg = 'Command: Missing command'
  elsif compare('eq',$typ,'ATTACH')
  {if ?testFile('rf',$cmd)
   {var $val = basename($cmd)
    var $rpt = $[OUT]->add_report('D',concat('fil_',$[set]->{'set'},'_',$val))
    if $rpt->write_data($cmd)
     var $val = join('|',$rpt->get_file,$cmd)
    else
     var $msg = join("\012",'Command:',\
                            '<verbatim>',\
                            $cmd,\
                            '</verbatim>',\
                            'Result: Copy failed')
    call $[OUT]->end_report($rpt)
   }
   else
    var $msg = join("\012",'Command:',\
                           '<verbatim>',\
                           $cmd,\
                           '</verbatim>',\
                           'Result: Cannot find or read the file')
   var $res{$uid,'mod'} = $mod = 'ATTACH'
  }
  elsif compare('eq',$typ,'GROUP')
  {if missing($grp{$cmd})
    var $msg = concat("Missing group ",$cmd)
   elsif exists($stk{$cmd})
    var $msg = concat("Recursive call to group ",$cmd)
   elsif !$grp{$cmd,'exe'}
   {var $stk{$cmd} = true
    loop $det (@{$grp{$cmd,'rul'}})
     break ?exec_hcve_rule($det,@lid)
    delete $stk{$cmd}
   }
  }
  elsif compare('eq',$typ,'LOOP')
  {if missing($grp{$cmd})
    var $msg = concat("Missing group ",$cmd)
   elsif exists($stk{$cmd})
    var $msg = concat("Recursive call to group ",$cmd)
   elsif !?$var = $itm->get_value('variable')
    var $msg = concat('Missing variable')
   elsif !?$inp = $itm->get_value('input')
    var $msg = concat('Missing value list')
   elsif !$grp{$cmd,'exe'}
   {var ($stk{$cmd},@val) = (true)
    loop $key (split(',',$inp))
    {var $key = check(uc($key),\
       '^HCVE/((\w+\.)+[A-Z]_[A-Z]\w*)$',concat('COL/TOOL.HCVE.',matches->[0]),\
       '^((COL|RUN)/(\w+\.)+[A-Z]_[A-Z]\w*)$',matches->[0],\
       '^((\w+\.)+[A-Z]_[A-Z]\w*)$',concat('SET.',matches->[0]))
     next ${<$key>/M}
     var @val = @{<$key>}
     break
    }
    var $cnt = @val
    var $fmt = cond(expr('>=',$cnt,100),'%03d',\
                    expr('>=',$cnt,10), '%02d',\
                                        '%d')
    var $cnt = 0
    loop $val (@val)
    {var $lid = sprintf($fmt,incr($cnt))
     call $[HCVE]->define_variable($var,$val)
     loop $det (@{$grp{$cmd,'rul'}})
      break ?exec_hcve_rule($det,@lid,$lid)
    }
    delete $stk{$cmd}
   }
  }
  elsif compare('eq',$typ,'PROMPT')
  {var ${RUN.REQUEST.W_HCVE_INFO} = 'prompt'
   var ${RUN.REQUEST.T_HCVE_PROMPT} = $cmd
   var $dft = undef
   if ?$itm->get_value('input')
   {loop $key (split(',',last))
     break ?$dft = check(uc($key),\
       '^HCVE/((\w+\.)+[A-Z]_[A-Z]\w*)$',${<'COL/TOOL.HCVE',matches->[0]>},\
       '^((COL|RUN)/(\w+\.)+[A-Z]_[A-Z]\w*)$',${<matches->[0]>},\
       '^((\w+\.)+[A-Z]_[A-Z]\w*)$',${<'SET',matches->[0]>})
   }
   var ${RUN.REQUEST.T_HCVE_DEFAULT} = nvl($dft,\
     determine(rpl_hcve_ref($itm->get_value('default'))))
   call $[COL]->request('TOOL:HCVEexec')
   var $val = $[ENV]->resolve(${RUN.REQUEST.T_HCVE_VALUE})
  }
  elsif compare('eq',$typ,'SQL')
  {var ($val,$msg,@err) = $[HCVE]->eval_command($typ, $cmd)
   if $msg
   {var $msg = join("\012",'Command:',\
                           '<verbatim>',\
                           $cmd,\
                           '</verbatim>',\
                           concat('Result: ',$msg),\
                           'Value:',\
                           '<verbatim>',\
                           $val,\
                           '</verbatim>')
    if @err
     var $msg = join("\012",$msg,\
                            'Return code: ',\
                            '<verbatim>',\
                            @err,\
                            '</verbatim>')
   }
  }
  else
  {var ($val,$msg,@err) = $[HCVE]->eval_command($typ, $cmd)
   if $msg
    var $msg = join("\012",'Command:',\
                           '<verbatim>',\
                           $cmd,\
                           '</verbatim>',\
                           join('%BR%',concat('Result: ',$msg),\
                                       concat('Value: ',nvl($val,'NA')),\
                                       @err))
  }

  # Treat the error
  if $msg
  {debug sprintf('Executing Rule: [%-6s] %-20.20s - error encountered.',\
                 $uid,$nam)
   var $res{$uid,'res'} = 'ERROR'
   var $res{$uid,'val'} = 'NA'
   var $err{$uid} = $msg

   return cond(compare('eq',$mod,'VERIFY_ABORT'),$rid,undef)
  }

  # Define parameter and variable
  var $key = $itm->get_value('parameter')
  if match($key,'^((\w+\.)+\w+)$')
   call $[HCVE]->set_parameter($key,$val)
  if match($itm->get_value('variable'),'^(\$\w+)$')
   call $[HCVE]->define_variable(last,$val)
 }

 # Perform the validation
 debug sprintf('Executing Rule: [%-6s] %-20.20s - completed.',$rid,$nam)
 var $res{$rid,'val'} = \
     $res{$uid,'val'} = $[HCVE]->set_result($val)
 if compare('eq',$mod,'ATTACH')
  var $res{$uid,'res'} = 'ATTACH'
 elsif compare('eq',$mod,'LOG')
  var $res{$uid,'res'} = 'LOGGED'
 elsif compare('eq',$mod,'RECORD')
  var $res{$uid,'res'} = 'RECORD'
 elsif compare('eq',$mod,'SECTION')
 {var $res{$uid,'act'} = $prv = []
  var $res{$uid,'res'} = 'PASSED'
  var $res{$uid,'txt'} = $nam

  # Identify the action
  loop $act ($rul->find('sdp_actions/sdp_action'))
  {# Check the action condition
   var ($flg,undef,%tbl) = eval_hcve_condition($act,$rid)

   # Apply the action
   if $flg
   {var $res{$uid,'res'} = $act->get_value('result','PASSED')
    var $res{$uid,'txt'} = get_title($act)
    loop $key (keys(%tbl))
     var $res{$uid,$key} = $tbl{$key}
    if $act->get_value('error')
     var $err{$uid} = last

    # Store the variable when requested
    if match($act->get_value('variable'),'^(\$\w+)$')
     call $[HCVE]->define_variable(last,$val)
    break
   }
   call push($prv,{%tbl})
  }
  if and(defined($mid = $rul->get_value('message')),exists($msg{$mid}))
   var $res{$uid,'nam'} = rpl_hcve_ref($msg{$mid})
 }
 elsif match($mod,'VERIFY(_ABORT)?')
 {var $res{$uid,'act'} = $prv = []
  var $res{$uid,'res'} = 'FAILED'

  # Identify the action
  loop $act ($rul->find('sdp_actions/sdp_action'))
  {# Check the action condition
   var ($flg,undef,%tbl) = eval_hcve_condition($act,$rid)

   # Apply the action
   if $flg
   {var $res{$uid,'res'} = $act->get_value('result','FAILED')
    var $res{$uid,'syn'} = $act->get_value('syntax','text')
    call get_text($res{$uid},$act)
    loop $key (keys(%tbl))
     var $res{$uid,$key} = $tbl{$key}
    if $act->get_value('error')
     var $err{$uid} = last

    # Store the variable when requested
    if match($act->get_value('variable'),'^(\$\w+)$')
     call $[HCVE]->define_variable(last,$val)

    # Check if the rule execution must be aborted
    if compare('eq',$mod,'VERIFY_ABORT')
    {if match($res,'(FAILED|ERROR)')
      return $rid
    }
    break
   }
   call push($prv,{%tbl})
  }
 }

 # Continue the rule evaluation
 return undef
}

# -----------------------------------------------------------------------------
# Internal routines
# -----------------------------------------------------------------------------

# Determine whether a dependency has been already resolved
macro find_did
{var ($did, @lid) = @arg
 import %res
 keep %res

 while
 {var $uid = join('_',$did,@lid)
  if exists($res{$uid,'res'})
   return $uid
  if !?pop(@lid)
   return undef
 }
}

# Get the associated text
macro get_text
{var ($rec,$obj) = @arg
 import %msg
 keep %msg

 # Get the text blocks
 var (@lin,@txt) = ()
 if ?$obj->get_value('message')
 {loop $mid (split(',',rpl_hcve_ref(last)))
  {if exists($msg{$mid})
    call push(@lin,split('\n',rpl_hcve_ref($msg{$mid})))
  }
 }
 else
  call push(@lin,split('\n',rpl_hcve_ref($obj->get_data)))

 # Format the text blocks
 if compare('eq',$rec->{'syn'},'wiki')
 {var ($val,%val) = ($rec->{'val'})
  if isNumber($val)
   var $val{$rec->{'nam'}} = 0
  loop $str (split('[\|\012]',$val))
   var $val{replace($str,'\[.*?\]','...',true)} = 1
  loop $lin (@lin)
  {if match($lin,'^\s*\|([^\|]+)\|([^\|]+\|)?(.*)\|\s*$')
   {var ($str,undef,$act) = (last)
    if exists($val{trim($str)})
     call push(@txt,$[HCVE]->get_values($act))
   }
   elsif !match($lin,'^\s*\|.*\|\s*$')
    call push(@txt,$[HCVE]->get_values($lin))
  }
 }
 else
 {loop $lin (@lin)
   call push(@txt,fmt_hcve_str($[HCVE]->get_values($lin)))
 }
 if @txt
  var $rec->{'txt'} = join('%BR%',@txt)
}

# Get the associated title
macro get_title
{var ($obj) = @arg
 import %msg
 keep %msg

 # Get the text blocks
 var @lin = ()
 if ?$obj->get_value('message')
 {loop $mid (split(',',rpl_hcve_ref(last)))
  {if exists($msg{$mid})
    call push(@lin,split('\n',rpl_hcve_ref($msg{$mid})))
  }
 }
 else
  call push(@lin,split('\n',rpl_hcve_ref($obj->get_data)))
 return join('',@lin)
}

# Define a macro to remove references
macro rpl_hcve_ref
{var ($str) = @arg
 import %res
 keep %res

 # Reject missing or empty string
 if !$str
  return $str

 # Replace the references
 var $chr = "\224"
 while match($str,'(%+(.*?)%+)')
 {var ($ref,$rid) = (last)
  var $val = cond(match($rid,'\.'),$[HCVE]->get_fact($rid),$res{$rid,'val'})
  if match($val,'^NA')
   return 'NA:'
  if ?$val
   var $str = replace($str,concat('%+',$rid,'%+'),$val,true)
  else
  {# Escape when not a reference
   var $ref = replace($ref,'%\!','%')
   var $ref = replace($ref,'\!%','%')
   var $ref = replace($ref,'%',$chr,true)
   var $str = replace($str,concat('%+',$rid,'%+'),$ref,true)
  }
 }

 return replace($str,$chr,'%',true)
}

# Format a result value
macro fmt_hcve_res
 return concat('``',replace(encode($arg[0]),"\012",'%BR%',true),'``')

# Format a string
macro fmt_hcve_str
{var ($str,$flg) = @arg
 var $str = encode($str,$flg)
 var $str = replace($str,'\|','&#x7C;',true)
 var $str = replace($str,'\*','&#x2A;',true)
 var $str = replace($str,"\012",'%BR%',true)
 return $str
}

# Check if a command must be skipped
macro skip_command
{loop $nam (split('\|',@arg))
 {if $[HCVE]->get_fact($nam)
   return false
 }
 return true
}

# -----------------------------------------------------------------------------
# Load the rule set
# -----------------------------------------------------------------------------

section Load

var ($rid,$tgt,@grp,%err,%grp,%msg,%res,%rul,%stk) = ()
keep $rid,$tgt,@grp,%err,%grp,%msg,%res,%rul,%stk

# Load the fact collectors
var $prv = undef
loop $fct ($[set]->{'xml'}->find('sdp_facts/sdp_fact'))
{var $uid = $fct->get_value('id','')
 if !match($uid,'^\w+$')
  die 'Missing or invalid fact identifier ',\
      cond($prv,concat('after fact ',$prv),'at first row')
 call $[HCVE]->set_fact($uid,$fct)
}

# Load the messages
var $prv = undef
loop $msg ($[set]->{'xml'}->find('sdp_messages/sdp_message'))
{var $uid = $msg->get_value('id','')
 if !match($uid,'^\w+$')
  die 'Missing or invalid message identifier ',\
      cond($prv,concat('after message ',$prv),'at first row')
 var $msg{$prv = $uid} = $msg->get_data
 if $msg->get_value('prefix')
  call $[HCVE]->set_parameter(concat(last,'.',$uid),$msg{$uid})
}

# Get the list of opted-out rules
var ($uid,%out) = ($[set]->{'xml'}->get_value('id'))
if ?$uid
{loop $rul (@{COL.TOOL.HCVE.SKIP.W_${VAR.uid}:@{ENV.${VAR.uid}/C}})
 {if match($rul,'^\w+$')
   $out{$rul} = 1
 }
}

# Load the rules
loop $grp ($[set]->{'xml'}->find('sdp_group'))
{# Define the group record
 var $rec = {\
   exe => $grp->get_value('exec',1),\
   gid => $grp->get_value('id'),\
   rul => $det = [],\
   ttl => $grp->get_value('title')}
 var $out = $grp->get_value('opt_out')

 # Load the rules
 var $prv = undef
 loop $rul ($grp->find('sdp_rule'))
 {# Validate the rule identifier
  var $uid = $rul->get_value('id','')
  if !match($uid,'^\w+$')
   die 'Missing or invalid rule identifier ',\
       cond($prv,concat('after rule ',$prv),'at first row')
  var $rul{$prv = $uid} = $rul

  # Validate the dependency identifiers
  loop $dep ($rul->find('sdp_dependencies/sdp_dependency'))
  {if !match($dep->get_value('id',''),'^\w+$')
    die 'Missing or invalid dependency identifier in rule ',$uid
  }

  # Add the rule to the group
  if !and($rul->get_value('opt_out',$out),exists($out{$uid}))
   call push($det,$uid)
 }
 call push(@grp,$rec)
 if $rec->{'gid'}
   var $grp{last} = $rec
}

# -----------------------------------------------------------------------------
# Perform the HCVE tests
# -----------------------------------------------------------------------------

section Execute
var ($hlt,@res) = (0)
keep $hlt,@res

debug 'Executing the ',$ttl,' validation rules'
if $[HCVE]->set_context(nvl($[set]->{'ini'},'TOOL:HCVEinit'))
 die [$[HCVE]->purge_errors]
loop $grp (@grp)
{next !$grp->{'exe'}
 loop $rid (@{$grp->{'rul'}})
  break ?$hlt = exec_hcve_rule($rid)
}

# -----------------------------------------------------------------------------
# Display a result summary
# -----------------------------------------------------------------------------

section Summary

# Display the page header
if $dsp = ${SET.TOOL.HCVE.B_SUMMARY:true}
{var $fmt = "%-6s %-20.20s %-7.7s %s"
 var $sct = "%-6s -- %.64s --"
 dump "\012Test \042",$ttl,"\042 executed at ",${RDA.T_LOCALTIME}
 dump "\012Test Results\012~~~~~~~~~~~~\012"
 dump sprintf($fmt,"ID","NAME","RESULT","VALUE")
 dump "====== ==================== ======= ====================================\
       ======"
}

# Display a rule overview
loop $uid (@res)
{var $mod = $res{$uid,'mod'}
 var $nam = $res{$uid,'nam'}
 var $res = $res{$uid,'res'}
 var $rid = $res{$uid,'rid'}

 # Determine the value contribution and display the rule result
 if $dsp
 {if and(compare('eq',$mod,'LOG'),\
         compare('ne',$res,'ERROR'),\
         compare('ne',$res,'LOOP'))
   dump sprintf($fmt,$rid,$nam,$res,'See Log')
  elsif compare('eq',$mod,'SECTION')
  {if compare('ne',$res,'SKIPPED')
    dump sprintf($sct,$rid,$res{$uid,'txt'})
  }
  elsif ?$res{$uid,'val'}
  {var $val = replace(last,"\012",' ',true)
   if expr('>',length($val),40)
    var $val = concat(substr($val,0,37),'...')
   dump sprintf($fmt,$rid,$nam,$res,nvl($val,''))
  }
  else
   dump sprintf($fmt,$rid,$nam,$res,'')
 }

 # Check when if abort occurred
 if compare('eq',$rid,$hlt)
 {echo ${RDA.T_LINE}
  if compare('eq',$res,'ERROR')
   echo "(ABORT) Execution of rule \042",$nam,"\042 completed with errors."
  else
   echo "(ABORT) Execution of rule \042",$nam,"\042 was FAILED."
  echo 'To be able to continue with remaing tests, this test has to be PASSED.'
  echo ${RDA.T_LINE}
  break
 }
}

# Report execution errors
if scalar(keys(%err))
 echo "\012Execution of ",last," rule(s) completed with errors."

# -----------------------------------------------------------------------------
# Produce a complete report
# -----------------------------------------------------------------------------

section Report

# Purge old reports
call setAbbr(nvl($[set]->{'abr'},'RDA_HCVE_'))
call setPrefix(concat($[set]->{'cls'},'_',$[set]->{'set'}))
call purge('C','(res|err)',0)

# Produce the result report
report res
write '---+!! Health Check/Validation for "',$ttl,'"'
write 'Tests "',$ttl,'" executed at ',${RDA.T_GMTIME},' UTC'
write
write $TOC

# Report the test results
write '---+ Test Results'
write '|*Rule*|*Name*|*Result*|*Value*|'
var $det = $arg[2]
loop $rid (@res)
{# Determine the value contribution
 var $rec = $res{$rid}
 var $mod = $rec->{'mod'}
 var $nam = $rec->{'nam'}
 var $res = $rec->{'res'}
 if and(compare('eq',$mod,'ATTACH'),\
        compare('ne',$res,'ERROR'),\
        compare('ne',$res,'LOOP'))
 {var @tbl = ()
  loop $itm (split("\012",$rec->{'val'}))
  {var ($lnk,$rpt) = split("\|",$itm,2)
   if length($lnk)
    call push(@tbl,concat('[[',$lnk,'][_blank][',nvl($rpt,$lnk),']]'))
  }
  var $val = join("\012",@tbl)
 }
 elsif and(compare('eq',$mod,'LOG'),\
           compare('ne',$res,'ERROR'),\
           compare('ne',$res,'LOOP'))
  var $val = 'See Log'
 else
  var $val = $rec->{'val'}

 # Display the rule result
 if compare('ne',$mod,'SECTION')
 {if and($det,match($res,'(FAILED|LOGGED|PASSED|SKIPPED|WARNING)'))
   var $res = concat('[[#Rule',$rid,'][',$res,']]')
  write '|',$rid,' |',fmt_hcve_str($nam),' |',$res,' |',fmt_hcve_res($val),' |'
 }
 elsif compare('ne',$res,'SKIPPED')
  write '|',$rid,' | &nbsp;**',fmt_hcve_str($rec->{'txt'}),'**&nbsp; |||'

 # Check when if abort occurred
 if compare('eq',$rid,$hlt)
 {write '---'
  if compare('eq',$res,'ERROR')
   write '(ABORT) Execution of rule "',$nam,'" completed with errors.'
  else
   write '(ABORT) Execution of rule "',$nam,'" was FAILED.'
  write 'To be able to continue with remaing tests, this test has to be \
         PASSED.'
  write '---'
  break
 }
}
if scalar(keys(%err))
 write 'Execution of ',last,' rule(s) completed with errors.%BR%'
write $TOP

# List Failures
prefix
{write '---+ Failure Summary'
 write '|*Rule*|*Description*|*Result*|*Action*|'
}
loop $rid (keys(%res))
{var $rec = $res{$rid}
 if compare('eq',$rec->{'res'},'FAILED')
  write '|[[#Rule',$rid,'][',$rid,']]|',\
        fmt_hcve_str($rec->{'dsc'},true),' |',\
        fmt_hcve_res(replace($rec->{'val'},'[\[\]]','',true)),' |',\
        $rec->{'txt'},' |'
}
if hasOutput(true)
{write $TOP
 incr $ret,1
}

# Report detailed results
if $det
{var $TTL = '---+ Detailed Results'
 loop $rid (keys(%res))
 {var $rec = $res{$rid}
  var $rul = $rul{$rid}

  # Print the actions
  prefix
  {write $TTL
   var $TTL = '---'
   write '#Rule',$rid,' ---## Rule ',$rid,': ',fmt_hcve_str($res{$rid,'nam'})
   write '---### Description'
   write fmt_hcve_str($rec->{'dsc'},true)
  }

  if exists($rec->{'dep'})
  {var $did = $rec->{'dep'}
   write '---### Dependency Failures'
   write '   * Dependency: ',$did,' - ',$res{$did,'nam'}
   write '   * Result: **',$rec->{'res'},'**'
   write '   * Condition: ``',\
         fmt_hcve_str(join(' ',$rec->{'prv'},\
                               $rec->{'tst'},\
                               $rec->{'min'},\
                               $rec->{'max'})),'``'
   if ?$rec->{'txt'}
    write last
   write
  }
  elsif exists($rec->{'act'})
  {if @{$rec->{'act'}}
   {write '---### Unmatched Actions'
    loop $act (@{$rec->{'act'}})
     write '   * ',\
           fmt_hcve_res($rec->{'val'}),'`` ',\
           fmt_hcve_str(join(' ',$act->{'tst'},\
                                 $act->{'min'},\
                                 $act->{'max'})),'``'
   }
   if ?$rec->{'tst'}
   {write '---### Action'
    write '   * Result: **',$rec->{'res'},'**'
    write '   * Condition: ',\
          fmt_hcve_res($rec->{'val'}),'`` ',\
          fmt_hcve_str(join(' ',$rec->{'tst'},\
                                $rec->{'min'},\
                                $rec->{'max'})),'``'
   }
   else
   {write '---### Default Action'
    write '   * Result: **',$rec->{'res'},'**'
    write '   * Value: ',fmt_hcve_res($rec->{'val'})
   }
   if ?$rec->{'txt'}
    write last
   write
  }
  if hasOutput(true)
   write $TOP
 }

 # Report logged results
 prefix
  write '---+ Logged Results'
 loop $rid (keys(%res))
 {var $rec = $res{$rid}
  next !compare('eq',$rec->{'res'},'LOGGED')
  write '#Rule',$rid,' ---## Rule ',$rid,': ',fmt_hcve_str($rec->{'nam'})
  write '<verbatim>'
  write $rec->{'val'}
  write '</verbatim>'
 }
 if hasOutput(true)
  write $TOP
}
if isCreated(true)
 var $rpt{'results'} = renderFile()

# Produce the error report
report err
prefix
{write '---+!! Health Check/Validation Errors for "',$ttl,'"'
 write 'Tests "',$ttl,'" executed at ',${RDA.T_GMTIME},' UTC'
}
loop $rid (keys(%err))
{write '---'
 write '(Error) Execution of rule ',$rid,' failed.'
 write '---'
 write $err{$rid}
}
if isCreated(true)
{var $rpt{'errors'} = renderReport()
 incr $ret,2
}

# Indicate the results
return new($req,'OK.Exec',exit=>$ret,title=>$ttl,%rpt)

=head1 SEE ALSO

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
