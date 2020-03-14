# TMinv.ctl: Tests Oracle Home Inventory Content
# $Id: TMinv.ctl,v 1.4 2014/04/15 05:56:55 RDA Exp $
# ARCS: $Header: /home/cvs/cvs/RDA_8/src/scripting/lib/collect/TOOL/TMinv.ctl,v 1.4 2014/04/15 05:56:55 RDA Exp $
#
# Change History
# 20140415  MSC  Extract top products.

=head1 NAME

TOOL:TMinv - Tests Oracle Home Inventory Content

=head1 DESCRIPTION

=cut

section tool
call unshift(@{CUR.W_NEXT},'test')

section test

echo tput('bold'),'Processing inventory test module ...',tput('off')

=pod

This test module extracts the top products and the components from the Oracle
home inventory. For the the top products, it lists the names, versions, and
patch set versions. For the components, it lists the names, versions, and
installation locations.

=cut

macro get_inventory
{var ($fil) = @arg
 if ?testFile('fr',$fil)
 {var $inv = xmlLoadFile($fil)

  # Get top products
  loop $xml (xmlFind($inv,'PRD_LIST/TL_LIST/COMP'))
  {var $nam = xmlValue($xml,'NAME')
   var $top{$nam} = xmlValue($xml,'VER')
  }
  loop $xml (xmlFind($inv,'PRD_LIST/TL_LIST/PATCHSET'))
  {var $nam = xmlValue($xml,'NAME')
   if missing($top{$nam})
    var $top{$nam} = ' '
   var $set{$nam} = join(',',$set{$nam},xmlValue($xml,'VER'))
  }
  if @key = keys(%top)
  {echo "|*Top Product*|*Version*|*Patch Set(s)|"
   loop $nam (@key)
    echo "|",$nam,"|",$top{$nam},"|",nvl($set{$nam},' '),"|"
   echo
  }

  # Get components
  loop $xml (xmlFind($inv,'PRD_LIST/COMP_LIST/COMP'))
  {var $nam = xmlValue($xml,'NAME')
   var $loc{$nam} = xmlValue($xml,'INST_LOC')
   var $ver{$nam} = xmlValue($xml,'VER')
  }
  loop $xml (xmlFind($inv,'PRD_LIST/COMP_LIST/PATCH'))
  {var $nam = xmlValue($xml,'NAME')
   var $loc{$nam} = xmlValue($xml,'INST_LOC')
   var $ver{$nam} = xmlValue($xml,'VER')
  }
  if @key = keys(%loc)
  {echo "|*Component*|*Version*|*Location*|"
   loop $nam (@key)
    echo "|",$nam,"|",$ver{$nam},"|",$loc{$nam},"|"
   echo
  }
 }
 else
  echo "The inventory file is not available"
}

if $arg[0]
 call get_inventory(last)
elsif ${SET.RDA.BEGIN.D_ORACLE_HOME}
 call get_inventory(catFile(last,'inventory','ContentsXML','comps.xml'))
elsif getEnv('ORACLE_HOME')
 call get_inventory(catFile(last,'inventory','ContentsXML','comps.xml'))
else
 echo "ORACLE_HOME is not defined"

=head1 COPYRIGHT NOTICE

Copyright (c) 2002, 2016, Oracle and/or its affiliates. All rights reserved.

=head1 TRADEMARK NOTICE

Oracle and Java are registered trademarks of Oracle and/or its
affiliates. Other names may be trademarks of their respective owners.

=cut
