#!/bin/bash
. ~/.bash_profile

sqlplus -s "/ as sysdba"   @/home/orasp01/alert/monthly_metrics.sql

