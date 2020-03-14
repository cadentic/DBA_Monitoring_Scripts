#! /bin/bash

. $HOME/.bash_profile

export DT=`date +%d%m%y_%H%M%S`


sqlplus -s " / as sysdba"  << EOS

   exec SEFPLLIVE.SP_SREI_NG_EXECUTION_SEQ;

EOS

exit 0


