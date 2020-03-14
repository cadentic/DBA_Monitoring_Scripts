#! /bin/sh

cd /rac1/oracle_base/admin/EP01/adump
find . -name '*.aud' -mtime +3 -exec rm {} \;
cd /rac1/oracle_base/diag/rdbms/ep01/EP012/trace
find . -name '*.tr*' -mtime +3 -exec rm {} \;


