# TMocm.ctl: Tests Configuration Management Discovery Information
# $Id: TMocm.ctl,v 1.4 2013/10/30 07:18:56 RDA Exp $
# ARCS: $Header: /home/cvs/cvs/RDA_8/src/scripting/lib/collect/TOOL/TMocm.ctl,v 1.4 2013/10/30 07:18:56 RDA Exp $
#
# Change History
# 20130610  MSC  Improve validation.

=head1 NAME

TOOL:TMocm - Tests Oracle Configuration Manager Discovery Information

=head1 DESCRIPTION

=cut

section tool
call unshift(@{CUR.W_NEXT},'test')

section test

echo tput('bold'),\
     'Processing Oracle Configuration Manager discovery test module ...',\
     tput('off')

=pod

This test module extracts the components from the Oracle Configuration Manager
discovery information. It lists the names, versions, and installation locations.

=cut

var $ORACLE_HOME = ${SET.RDA.BEGIN.D_ORACLE_HOME:${ENV.ORACLE_HOME}}
var $tst = cond(isCygwin(),'d','dr')

if ?$ORACLE_HOME
{loop $sub (catDir($ORACLE_HOME,'ccr'),\
            catDir($ORACLE_HOME,'livelink'),\
            catDir($ORACLE_HOME,upDir(),'oracle_common','ccr'),\
            catDir($ORACLE_HOME,upDir(),'utils','ccr'),\
            catDir($ORACLE_HOME,'oracle_common','ccr'),\
            catDir($ORACLE_HOME,'utils','ccr'))
 {next !?testDir($tst,$sub)

  # Find the CONFIG_HOME
  if ?testDir($tst,catDir($sub,'hosts'))
  {if getEnv('ORACLE_CONFIG_HOME')
    var $sub = catDir(getEnv('ORACLE_CONFIG_HOME'),'ccr')
   elsif ?testDir('d',catDir($sub,'hosts',${RDA.T_HOST}))
    var $sub = lastDir()
   else
    var $sub = catDir($sub,'hosts',${RDA.T_NODE})
  }

  # Check the presence of the Oracle home target
  next !?testDir($tst,catDir($sub,'state','review'))
  var ($fil) = grepDir(lastDir(),'-oracle_home_config\.xml$','ip')
  if ?testFile(cond(isCygwin(),'f','fr'),$fil)
  {var $inv = xmlLoadFile($fil)
   loop $xml (xmlFind($inv,'.../ROWSET TABLE="MGMT_LL_INV_COMPONENT"/ROW'))
   {var $nam = xmlData(xmlFind($xml,'NAME'))
    var $loc{$nam} = xmlData(xmlFind($xml,'INSTALLED_LOCATION'))
    var $ver{$nam} = xmlData(xmlFind($xml,'VERSION'))
   }
   echo "|*Name*|*Version*|*Location*|"
   loop $nam (keys(%loc))
    echo "|",$nam,"|",$ver{$nam},"|",$loc{$nam},"|"
   return
  }
 }
 echo "No Oracle Configuration Manager discovery information"
}
else
 echo "ORACLE_HOME is not defined"

=head1 COPYRIGHT NOTICE

Copyright (c) 2002, 2016, Oracle and/or its affiliates. All rights reserved.

=head1 TRADEMARK NOTICE

Oracle and Java are registered trademarks of Oracle and/or its
affiliates. Other names may be trademarks of their respective owners.

=cut
