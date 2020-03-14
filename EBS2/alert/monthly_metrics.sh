#!/bin/bash
. ~/.bash_profile

sqlplus -s "/ as sysdba"   @/home/oraep01/alert/monthly_metrics.sql

