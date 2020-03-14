# HCVEman.ctl: Generates Diaglet Documentation
# $Id: HCVEman.ctl,v 1.8 2014/08/25 17:00:24 RDA Exp $
# ARCS: $Header: /home/cvs/cvs/RDA_8/src/scripting/lib/collect/TOOL/HCVEman.ctl,v 1.8 2014/08/25 17:00:24 RDA Exp $
#
# Change History
# 20140825  MSC  Improve variable and parameter formatting.

=head1 NAME

TOOL:HCVEman - Generates Diaglet Documentation

=head1 DESCRIPTION

Produces the documentation of the specified diaglet as a report.

=cut

use Hcve
use Message
use Report
use Xml

section Man

# Initialisation
var ($req,$xml,$abr) = @arg
var $typ = $xml->get_value('type','U')
var $set = $xml->get_value('set','no_name')
var $ttl = $xml->get_value('title',$set)

var $TOC = '%TOC%'
var $TOP = '[[#Top][Back to top]]'

var %tb_max = ('B', 'a result between ',\
               'O', 'a result not between ',\
               'VB','a version between ',\
               'VO','a version not between ')
var %tb_tst = ('==','',\
               '!=','a result different from ',\
               '<', 'a result less than ',\
               '<=','a result less than or equal to ',\
               '>', 'a result greater than ',\
               '>=','a result greater than or equal to ',\
               '=~','a result matching ',\
               '!~','a result not matching ',\
               'V=','a version equal to ',\
               'V!','a version different from ',\
               'V<','a version less than ',\
               'V-','a version less than or equal to ',\
               'V>','a version greater than ',\
               'V+','a version greater than or equal to ')
var %tb_typ = ('A','Pre-Installation','P','Post-Installation')

call setAbbr(nvl($abr,'RDA_HCVE_'))
call setPrefix(concat($typ,'_',$set))

# -----------------------------------------------------------------------------
# Macros for describing content blocks
# -----------------------------------------------------------------------------

# Produce a rule set description
macro dsp_check
{var ($xml,$ttl) = @arg
 import %tb_max,%tb_tst,$TOP
 keep %tb_max,%tb_tst,$TOP

 write '---+ ',$ttl
 if ?$xml->get_value('id')
  write '|*Identifier*|',last,' |'

 # Treat the messages
 loop $itm ($xml->find('sdp_messages/sdp_message'))
 {if ?$itm->get_value('id')
   var $tbl{last} = [$itm->get_value('prefix',''), $itm->get_data]
 }
 prefix
 {write '---++ Messages'
  write '|*Identifier*|*Prefix*|*Text*|'
 }
 loop $key (keys(%tbl))
  write '|',$key,' |',$tbl{$key}->[0],' |',$tbl{$key}->[1],' |'
 if hasOutput(true)
 {write $TOP
  write '---'
 }

 # Treat the fact collectors
 if $xml->find('sdp_facts/sdp_fact')
 {var @tbl = last
  write '---++ Facts'
  loop $itm (@tbl)
  {var $uid = $itm->get_value('id')
   write '---+++ Fact ',nvl($uid,'?')
   if $itm->find('sdp_description')->get_data
    write fmt_hcve_str(last,true),'%BR%%BR%'

   if $itm->find('sdp_parameters/sdp_parameter')
   {var @trg = last
    write "''For parameters:''"
    loop $trg (@trg)
    {if ?$trg->get_value('name')
      write '   * ',uc(last)
    }
    write '%BR%'
   }

   var $sep = ''
   loop $cmd ($itm->find('sdp_command'))
   {var $typ = uc($cmd->get_value('type',''))
    if compare('eq',$typ,'OS')
     write $sep,"''Run the following command from the operating system \
           command line:''"
    elsif compare('eq',$typ,'PERL')
     write $sep,"''Run the following Perl code:''"
    elsif compare('eq',$typ,'RDA')
     write $sep,"''Run the following RDA code:''"
    elsif compare('eq',$typ,'SDCL')
     write $sep,"''Run the following SDCL code:''"
    elsif compare('eq',$typ,'SDSL')
     write $sep,"''Run the following SDSL code:''"
    elsif compare('eq',$typ,'SQL')
     write $sep,"''Run the following command from a SQL command prompt:''"
    else
     write $sep,"''``",$typ,"``''"
    write '<verbatim>'
    write $cmd->get_data
    write '</verbatim>'
    if $cmd->get_value('parameter')
     write "''It stores the rule value in the ``",uc(last),\
           "`` parameter.''%BR%"
    if $cmd->get_value('variable')
     write "''It stores the rule value in the ``",last,\
           "`` variable in the evaluation context.''%BR%"
    var $sep = "%BR%"
   }
   write $TOP
   write '---'
  }
 }

 # Treat the rule groups
 loop $grp ($xml->find('sdp_group'))
 {# Display the group title
  var $str = cond($grp->get_value('exec',1),'Rule Group','Optional Rule Group')
  if $grp->get_value('id')
   var $str = concat($str,': ',last)
  if $grp->get_value('title')
   var $str = concat($str,' - ',fmt_hcve_str(last))
  var $out = $grp->get_value('opt_out')
  write '---++ ',$str

  # Display the rules
  loop $rul ($grp->find('sdp_rule'))
  {var $uid = $rul->get_value('id')
   write '#Rule',$uid
   write '---+++ Rule ',$uid,': ',fmt_hcve_str($rul->get_value('name'))
   if $rul->find('sdp_description')->get_data
    write fmt_hcve_str(last,true),'%BR%%BR%'

   # Display possible dependencies
   loop $dep ($rul->find('sdp_dependencies/sdp_dependency id="\w+"'))
   {var $did = $dep->get_value('id')
    var $lnk = concat('[[#Rule',$did,'][rule ',$did,']]')
    var $tst = uc($dep->get_value('condition'))
    if ?$tst
    {write "''HCVE treats this test as ",\
            fmt_hcve_val($dep->get_value('result','FAILED')),\
            " unless the ",$lnk," \134"
     if match($tst,'^(V?[BO])')
     {var ($val) = last
      write "has ",$tb_max{$val},\
            fmt_hcve_val($dep->get_value('minimum'))," and ",\
            fmt_hcve_val($dep->get_value('maximum')),"\134"
     }
     elsif compare('eq',$tst,'IS')
      write "has a ",fmt_hcve_val($dep->get_value('minimum'))," status\134"
     elsif match($tst,'^N')
      write "has a numeric result\134"
     else
      write "has ",nvl($tb_tst{$tst},$tst),\
            fmt_hcve_val($dep->get_value('minimum')),"\134"
     write ".''%BR%"
    }
    else
     write "''This rule requires the execution of ",$lnk,".''%BR%"
    if ?$dep->get_value('message')
    {write "''The text is composed of the following messages:'' ``",\
           replace(last,',','``, ``',true),"``"
     write
    }
    elsif $dep->get_data
    {var $str = last
     if compare('eq',$dep->get_value('syntax'),'wiki')
      call wrt_hcve_man_txt($str)
     else
      write fmt_hcve_str($str)
     write
    }
    write "%BR%"
   }

   # Display the rule content
   var $sep = ''
   loop $cmd ($rul->find('sdp_command'))
   {var $typ = uc($cmd->get_value('type',''))
    if compare('eq',$typ,'PROMPT')
    {write '|*Prompt*|',fmt_hcve_str($cmd->get_data),' |'
     if ?$cmd->get_value('input')
      write '|*Input List*|',fmt_hcve_str(last),' |'
     if ?$cmd->get_value('default')
      write '|*Default Value*|',fmt_hcve_str(last),' |'
    }
    else
    {if $cmd->get_value('exec')
      var $cnd = concat(' when the HCVE fact ``',\
        join('`` or ``',split('\|',last)),'`` is true')
     else
      var $cnd = ''
     if compare('eq',$typ,'GROUP')
      write $sep,"''Execute the rules from the following group",$cnd,":''"
     elsif compare('eq',$typ,'LOOP')
      write $sep,"''For each value of ``",\
            join('`` or ``',split(',',$cmd->get_value('input'))),\
            "``, execute the rules from the following group",$cnd,":''"
     elsif compare('eq',$typ,'OS')
      write $sep,"''Run the following command from the operating system \
            command line and record the result",$cnd,":''"
     elsif compare('eq',$typ,'PERL')
      write $sep,"''Run the following Perl code and record the result",$cnd,\
            ":''"
     elsif compare('eq',$typ,'RDA')
      write $sep,"''Run the following RDA code and record the result",$cnd,\
            ":''"
     elsif compare('eq',$typ,'SDCL')
      write $sep,"''Run the following SDCL code and record the result",$cnd,\
            ":''"
     elsif compare('eq',$typ,'SDSL')
      write $sep,"''Run the following SDSL code and record the result",$cnd,\
            ":''"
     elsif compare('eq',$typ,'SQL')
      write $sep,"''Run the following command from a SQL command prompt \
            and record the result",$cnd,":''"
     else
      write "''``",$typ,"``",$cnd,"''"
     write '<verbatim>'
     write $cmd->get_data
     write '</verbatim>'
    }
    if $cmd->get_value('parameter')
     write "''It stores the rule value in the ``",uc(last),\
           "`` parameter.''%BR%"
    if $cmd->get_value('variable')
     write "''It stores the rule value in the ``",last,\
           "`` variable in the evaluation context.''%BR%"
    var $sep = "%BR%"
   }

   var $mod = $rul->get_value('mode')
   if match($mod,'VERIFY(_ABORT)?|SECTION',true)
   {loop $act ($rul->find('sdp_actions/sdp_action'))
    {var $tst = uc($act->get_value('condition'))
     if ?$tst
     {write "%BR%''If the rule code \134"
      if match($tst,'^(V?[BO])')
      {var ($val) = last
       write "returns ",$tb_max{$val},\
             fmt_hcve_val($dep->get_value('minimum'))," and ",\
             fmt_hcve_val($dep->get_value('maximum')),"\134"
      }
      elsif compare('eq',$tst,'IS')
       write "has a ",fmt_hcve_val($act->get_value('minimum'))," status\134"
      elsif match($tst,'^N')
       write "returns a numeric result\134"
      elsif match($tst,'^O')
       write "returns a result not between ",\
             fmt_hcve_val($act->get_value('minimum'))," and ",\
             fmt_hcve_val($act->get_value('maximum')),"\134"
      else
       write "returns ",nvl($tb_tst{$tst},$tst),\
             fmt_hcve_val($act->get_value('minimum')),"\134"
      write ", then\134"
     }
     else
      write "%BR%''Otherwise,\134"
     write " HCVE treats this test as ",\
             fmt_hcve_val($act->get_value('result','FAILED')),".\134"
     if $act->get_value('variable')
      write " It stores the rule value in the ``",last,\
            "`` variable in the evaluation context.\134"
     write "''%BR%"
     if ?$act->get_value('message')
     {write "''The text is composed of the following messages:'' ``",\
            replace(last,',','``, ``',true),"``"
      write
     }
     elsif $act->get_data
     {var $str = last
      if compare('eq',$act->get_value('syntax'),'wiki')
       call wrt_hcve_man_txt($str)
      else
       write fmt_hcve_act($str)
      write
     }
    }
   }
   if $rul->get_value('opt_out',$out)
    write "%BR%''Users can opt out this rule.''%BR%"
   write $TOP
   write '---'
  }
 }
}

# Produce an eval block description
macro dsp_eval
{var ($xml,$ttl) = @arg
 import $TOP
 keep $TOP

 write '---+ ',$ttl
 var $cnt = 0
 loop $itm ($xml->get_content)
 {incr $cnt
  var ($tag,%tbl) = ($itm->get_name(''))
  loop $key ($itm->get_attr)
   var $tbl{$key} = $itm->get_value($key)

  # Identify the request
  if compare('eq',$tag,'sdp_ask')
  {if delete($tbl{'name'})
    write '---++ Prompt for ',last
   else
   {write '---++ Prompt ',$cnt
    write '**Missing property name**'
    next
   }
  }
  elsif compare('eq',$tag,'sdp_exec')
  {if delete($tbl{'command'})
   {# Identify the command
    var $ttl = concat('---++ Execute ',last,' Command')
    if delete($tbl{'on'})
     var $ttl = concat($ttl,' on ',last)
    write $ttl
   }
   else
   {write '---++ Command ',$cnt
    write '**Missing command**'
    next
   }
  }
  else
   next

  # Display the attribute
  prefix
   write '|*Attribute*|*Value*|'
  loop $key (keys(%tbl))
   write '|',$key,'|',$tbl{$key},'|'
  unprefix

  # Display the associated data
  if $itm->get_data
  {var $str = last
   write '---### Associated Data:'
   write '<verbatim>'
   write $str
   write '</verbatim>'
  }
  write $TOP
  write '---'
 }
}

# -----------------------------------------------------------------------------
# Formatting macros
# -----------------------------------------------------------------------------

# Format an action
macro fmt_hcve_act
{var $str = $arg[0]
 var $str = replace($str,'<[Pp][Rr][Ee]>','%PRE%',true)
 var $str = replace($str,'</[Pp][Rr][Ee]>','%/PRE%',true)
 var $str = fmt_hcve_str($str)
 var $str = replace($str,'%PRE%','<PRE>',true)
 var $str = replace($str,'%/PRE%','</PRE>',true)
 return $str
}

# Format a man string
macro fmt_hcve_man
{var $str = $arg[0]
 var $str = s($str,"\$\{=(\w+(\.\w+)*)\}",'\${$1}',true)
 var $str = s($str,"\$\{([\'\`\*])(\w+(\.\w+)*)\}",'$1$1\${$2}$1$1',true)
 var $str = s($str,"\$\{([\'\`\*])(\w+(\.\w+)*):([^\{\}]*)\}",\
                   '$1$1\${$2:$1$1$4$1$1}$1$1',true)
 return $str
}

# Format a string
macro fmt_hcve_str
{var ($str,$flg) = @arg
 var $str = encode($str,$flg)
 var $str = replace($str,'\|','&#x7C;',true)
 var $str = replace($str,'\*','&#x2A;',true)
 var $str = replace($str,"\012",'%BR%',true)
 return $str
}

# Format a value
macro fmt_hcve_val
{var $val = $arg[0]
 if isNumber($val)
  return $val
 return concat('``',$val,'``')
}

# Write a Wiki documentation text
macro wrt_hcve_man_txt
{var $str = $arg[0]
 loop $lin (split("\012",$str))
 {if match($lin,'^\s*\|\s*\*')
   write $lin
  elsif match($lin,'^\s*\|([^\|]+)\|(.*)\|\s*$')
  {var ($val,$txt) = last
   write '|',fmt_hcve_val($val,true),'|',fmt_hcve_man($txt),'|'
  }
  else
   write fmt_hcve_man($lin)
 }
}

# -----------------------------------------------------------------------------
# Produce the documentation report
# -----------------------------------------------------------------------------

report man

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
loop $sub ($xml->find('sdp_content'))
{incr $cnt
 var $hdr = $sub->get_value('title')
 var $typ = $sub->get_value('type')
 if compare('eq',$typ,'check')
  call dsp_check($sub,nvl($hdr,concat('Rule Set ',$cnt)))
 elsif compare('eq',$typ,'eval')
  call dsp_eval($sub,nvl($hdr,concat('Command Set ',$cnt)))
}
if isCreated(true)
{write 'Generated on ',${RDA.T_LOCALTIME}
 return new($req,'OK.Man',man=>renderReport($ttl),title=>$ttl)
}
return undef

=head1 SEE ALSO

L<TOOL:HCVEexec|collect::TOOL:HCVEexec>

=head1 COPYRIGHT NOTICE

Copyright (c) 2002, 2016, Oracle and/or its affiliates. All rights reserved.

=head1 TRADEMARK NOTICE

Oracle and Java are registered trademarks of Oracle and/or its
affiliates. Other names may be trademarks of their respective owners.

=cut
