#!/bin/bash
. ~/.bash_profile

sqlplus -S "sys/ebsmanager123 as sysdba" << EOS


alter system flush shared_pool;

exit
EOS
