# RUNroot.ctl : Post treatment for running TLroot
# $Id: RUNroot.ctl,v 1.6 2015/04/21 11:49:57 RDA Exp $
# ARCS: $Header: /home/cvs/cvs/RDA_8/src/scripting/lib/collect/TOOL/RUNroot.ctl,v 1.6 2015/04/21 11:49:57 RDA Exp $
#
# Change history
# 20150421  MSC  Add a credential transfer mechanism.

=head1 NAME

RUNroot - Post treatment for running TLroot

=cut

=head1 REMOTE SECTION

Executes C<TLroot> through a remote session.

=cut

use Remote

section remote

if ?isHost(${SET.RDA.END.ROOT.T_HOST},true)
 var $hst = last
else
 var $hst = 'localhost'
if ?isUser(${SET.RDA.END.ROOT.T_USER},true)
 var $usr = last
else
 var $usr = 'root'

var $ses = addRemoteSession('ROOT',$hst,$usr)
if !$ses->need_password
{debug 'Run TLroot'

 # Generate the remote command
 var @arg = (@{SET.RDA.END.ROOT.T_PREFIX}, ${RDA.T_LOCAL})
 if @{SET.RDA.END.ROOT.T_EDIT}
  call push(@arg,quote(concat('-e',join(',',last))))
 call push(@arg,quote(concat('-s',getGroupFile('D_CWD',${CUR.W_COLLECTOR}))))
 if ${SET.RDA.END.ROOT.T_TRANSFER/E}
 {call push(@arg,'-viXRda','run','root')
  var $req = {cmd=>[@arg],pwi=>[@{SET.RDA.END.ROOT.T_TRANSFER}]}
 }
 else
 {call push(@arg,'-vyXRda','run','root')
  var $req = [@arg]
 }
 dump join(' ',' Using:',@arg)

 # Execute the command
 call $ses->command($req,true,${SET.RDA.END.ROOT.R_FACTOR})
 dump join("\012",$ses->get_lines())
}
call endRemoteSession('ROOT')

