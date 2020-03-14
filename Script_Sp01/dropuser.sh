#!/bin/bash
. ~/.bash_profile

sqlplus -s "/ as sysdba"<<-EOF
drop user SEFPLLIVE cascade;
EOF
