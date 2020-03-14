# HCCEmeta.ctl: Generates Diaglet Compliance Metadata
# $Id: HCCEmeta.ctl,v 1.5 2014/08/25 12:33:54 RDA Exp $
# ARCS: $Header: /home/cvs/cvs/RDA_8/src/scripting/lib/collect/TOOL/HCCEmeta.ctl,v 1.5 2014/08/25 12:33:54 RDA Exp $
#
# Change History
# 20140825  MSC  Add passed and failed messages.

=head1 NAME

TOOL:HCCEmeta - Generates Diaglet Compliance Metadata

=head1 DESCRIPTION

Produces the compliance metadata of the specified diaglet as a report.

=cut

use Hcve
use Message
use Report
use Xml

section Meta

# Initialisation
var ($req,$xml,$abr) = @arg
var $typ = $xml->get_value('type','U')
var $set = nvl($xml->get_value('oem'),\
               $xml->get_value('set'),\
               'no_name')
var $ttl = $xml->get_value('title',$set)

var $TOC = '%TOC%'
var $TOP = '[[#Top][Back to top]]'

call setAbbr(nvl($abr,'RDA_HCCE_'))
call setPrefix(concat($typ,'_',$set))

# -----------------------------------------------------------------------------
# Macros for describing content blocks
# -----------------------------------------------------------------------------

# Produce a rule set description
macro dsp_check
{var ($xml,$abr,$ver,$set,$ttl) = @arg
 import $TOP
 keep $TOP

 write '---+ ',$set,': ',$ttl

 # Treat the global obsolete compliance rules
 var ($pre,%tbl) = (concat($abr,$set,'_'))
 loop $itm ($xml->find('sdp_oem type="^obsolete$"'))
  var $tbl{$itm->get_value('target'),$itm->get_value('id')} = {\
    obs=>true,\
    ver=>$itm->get_value('version',$ver)}

 # Regroup the rules per target
 loop $grp ($xml->find('sdp_group'))
 {# Treat the group obsolete compliance rules
  loop $itm ($grp->find('sdp_oem type="^obsolete$"'))
   var $tbl{$itm->get_value('target'),$itm->get_value('id')} = {\
     obs=>true,\
     ver=>$itm->get_value('version',$ver)}

  # Treat the rules
  loop $rul ($grp->find('sdp_rule mode="VERIFY(_ABORT)?" target="\w"'))
  {var $tgt = $rul->get_value('target')
   var $rev = $rul->get_value('version',$ver)
   var $rid = nvl($rul->get_value('oem'),\
                  $rul->get_value('id'))

   # Treat the obsolete entries
   loop $itm ($rul->find('sdp_oem type="^obsolete$"'))
    var $tbl{$tgt,join('_',$rid,$itm->get_value('id'))} = {\
      obs=>true,\
      ver=>$itm->get_value('version',$ver)}

   # Treat the dependencies
   loop $dep ($rul->find('sdp_dependencies/sdp_dependency result="FAILED$"'))
   {var $uid = join('_',$rid,$dep->get_value('oem'))
    var $tbl{$tgt,concat($pre,$uid)} = {\
      act=>fmt_hcve_str(getHcveValues($dep->get_data)),\
      obs=>false,\
      rul=>$rul,\
      sev=>$dep->get_value('severity','CRITICAL'),\
      uid=>$uid,\
      ver=>$rev}
   }

   # Treat the actions
   loop $act ($rul->find('sdp_actions/sdp_action result="^FAILED$"'))
   {var $uid = join('_',$rid,$act->get_value('oem'))
    var $sev = $act->get_value('severity','CRITICAL')
    if ?$act->get_value('message')
     var $str = $xml->find(\
      concat('sdp_messages/sdp_message id="',last,'"'))->get_data
    else
     var $str = $act->get_data
    if compare('eq',$act->get_value('syntax'),'wiki')
    {var @lin = split("\012",$str)
     if match($str,'^\s*\|\*Return Value\*\|(\*OEM\*\|)?\*Action\*\|\s*$#m')
     {var %act = ()
      loop $lin (@lin)
      {if match($lin,'^\s*\|([^\|]+)\|(([^\|]+)\|)?(.*)\|\s*$')
        var $act{first} = cond(second,third,first)
      }
      delete($act{'*Return Value*'})
      loop $key (keys(%act))
      {var ($tid,@txt) = (join('_',$rid,$act{$key}))
       loop $lin (@lin)
       {if match($lin,'^\s*\|([^\|]+)\|([^\|]+\|)?(.*)\|\s*$')
        {if compare('eq',$key,matches->[0])
          call push(@txt,matches->[2])
        }
        else
         call push(@txt,$lin)
       }
       var $tbl{$tgt,concat($pre,$tid)} = {\
         act=>getHcveValues(join('%BR%',@txt)),\
         obs=>false,\
         rul=>$rul,\
         sev=>$sev,\
         uid=>$tid,\
         ver=>$rev}
      }
     }
     else
      var $tbl{$tgt,concat($pre,$uid)} = {\
        act=>getHcveValues(join('%BR%',@lin)),\
        obs=>false,\
        rul=>$rul,\
        sev=>$sev,\
        uid=>$uid,\
        ver=>$rev}
    }
    else
     var $tbl{$tgt,concat($pre,$uid)} = {\
       act=>fmt_hcve_str(getHcveValues($str)),\
       obs=>false,\
       rul=>$rul,\
       sev=>$sev,\
       uid=>$uid,\
       ver=>$rev}
   }
  }
 }

 # Treat all target types
 loop $tgt (keys(%tbl))
 {write '---++ ',$tgt,' Target Type'
  loop $uid (keys($tbl{$tgt}))
  {var $rec = $tbl{$tgt,$uid}
   var $qry = concat('sdp_oem id="^',$rec->{'uid'},'$" type="^%s$"')
   write '|<Rule ',$uid,'>|'
   write '|*Version*|',$rec->{'ver'},' |'
   write '|*Identifier*|',$uid,' |'
   if $rec->{'obs'}
    write '|*Status*|Obsolete|'
   else
   {write '|*Status*|Active|'
    var $nam = \
      nvl($rec->{'rul'}->find(sprintf($qry,'name'))->get_value('name'),\
          $rec->{'rul'}->get_value('name'))
    write '|*Name*|',$nam,' |'
    if $rec->{'rul'}->find(sprintf($qry,'description'))->get_data
     write '|*Description*|',fmt_hcve_str(last,true),' |'
    elsif $rec->{'rul'}->find('sdp_description')->get_data
     write '|*Description* |',fmt_hcve_str(last,true),' |'
    write '|*Severity*|',$rec->{'sev'},' |'
    if $rec->{'rul'}->find(sprintf($qry,'failed'))->get_data
     write '|*Failed*|',fmt_hcve_str(last,true),' |'
    else
     write '|*Failed* |',concat($nam,' Failed'),' |'
    if $rec->{'rul'}->find(sprintf($qry,'passed'))->get_data
     write '|*Passed*|',fmt_hcve_str(last,true),' |'
    else
     write '|*Passed* |',concat($nam,' Passed'),' |'
    if exists($rec->{'act'})
     write '|*Recommendation*|',$rec->{'act'},' |'
    loop $itm ($rec->{'rul'}->find(sprintf($qry,'context')))
     write '|*',join(' ','Context',$itm->get_value('context')),'*|',\
       encode($itm->get_value('title')),' |'
   }
   write $TOP
  }
 }
}

# -----------------------------------------------------------------------------
# Formatting macros
# -----------------------------------------------------------------------------

# Format a man string
macro fmt_hcve_man
 return s(\
   s($arg[0],"\$\{=(\w+(\.\w+)*)\}",'\${$1}',true),\
   "\$\{([\'\`\*])(\w+(\.\w+)*)\}",'$1$1\${$2}$1$1',true)

# Format a string
macro fmt_hcve_str
{var ($str,$flg) = @arg
 var $str = encode($str,$flg)
 var $str = replace($str,'\|','&#x7C;',true)
 var $str = replace($str,'\*','&#x2A;',true)
 var $str = replace($str,"\012",'%BR%',true)
 return $str
}

# -----------------------------------------------------------------------------
# Produce the documentation report
# -----------------------------------------------------------------------------

report meta

# Produce a diaglet description
write '---+!! ',$ttl
write $TOC
write '---+ Generalities'
write '|*Name*|``',$set,'`` |'
write '|*Title*|``',$ttl,'`` |'
if $xml->find('sdp_description')->get_data
 write '|*Description*|',last,' |'
if ?$xml->get_value('type')
 write '|*Type*|',nvl($tb_typ{last},concat('``',last,'``')),' |'
if ?$xml->get_value('family')
 write '|*Family*|``',last,'`` |'
if ?$xml->get_value('platform')
 write '|*Platform*|``',last,'`` |'
if ?$xml->get_value('product')
 write '|*Product*|``',last,'`` |'
if match($xml->find('sdp_meta type="^version$"')->get_value('id'),\
         '^\$Id:\s\S+\s(\d+\.\d+)\s')
 write '|*Version*|``',$ver = first,'`` |'
if $xml->find('sdp_meta type="^copyright$"')
 write '|*Copyright*|',trim(replace(last->get_data,'\s',' ',true)),' |'
if $xml->find('sdp_meta type="^trademark$"')
 write '|*Trademark*|',trim(replace(last->get_data,'\s',' ',true)),' |'
write $TOP

# Display the target information
if $xml->find('sdp_meta type="target"')
{var ($tgt) = last
 prefix
  write '---+ Target Information'
 loop $key ($tgt->get_attr)
 {next compare('eq',$key,'type')
  write '|*',ucfirst($key),'*|',$tgt->get_value($key),' |'
 }
 if hasOutput(true)
  write $TOP
}
write '---'

# Analyze the diaglet content
var $cnt = 0
call setHcveContext('TOOL:HCCEinit')
loop $sub ($xml->find('sdp_content'))
{incr $cnt
 var $typ = $sub->get_value('type')
 if or(compare('eq',$typ,'check'),\
       compare('eq',$typ,'comply'))
  call dsp_check($sub,$abr,$ver,\
    nvl($sub->get_value('oem'),$sub->get_value('set'),$set),\
    nvl($sub->get_value('title'),concat('Rule Set ',$cnt)))
}
if isCreated(true)
{write 'Generated on ',${RDA.T_LOCALTIME}
 return new($req,'OK.Meta',meta=>convertReport($ttl),title=>$ttl)
}
return undef

=head1 SEE ALSO

L<TOOL:HCCEexec|collect::TOOL:HCCEexec>

=head1 COPYRIGHT NOTICE

Copyright (c) 2002, 2016, Oracle and/or its affiliates. All rights reserved.

=head1 TRADEMARK NOTICE

Oracle and Java are registered trademarks of Oracle and/or its
affiliates. Other names may be trademarks of their respective owners.

=cut
