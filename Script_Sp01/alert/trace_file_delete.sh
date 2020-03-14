#! /bin/sh

export DT=`date +%d%m%y_%H%M%S`

cd /rac/app/oracle/diag/rdbms/sp01/SP011/trace

find . -name '*' -mtime +2 -exec rm {} \;

