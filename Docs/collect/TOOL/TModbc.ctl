# TModbc.ctl: Tests Oracle Database Access Using ODBC
# $Id: TModbc.ctl,v 1.5 2015/05/20 17:51:05 RDA Exp $
# ARCS: $Header: /home/cvs/cvs/RDA_8/src/scripting/lib/collect/TOOL/TModbc.ctl,v 1.5 2015/05/20 17:51:05 RDA Exp $
#
# Change History
# 20150515  KRA  Improve the documentation.

=head1 NAME

TOOL:TModbc - Tests Oracle Database Access Using ODBC

=head1 DESCRIPTION

This tools requires an ODBC Data Source Name as argument.

 <rda> -vT odbc:<DSN>

 <sdci> -v run odbc [<DSN>|-t<target>]

=cut

options t:

section tool
call unshift(@{CUR.W_NEXT},'test')

section test

echo tput('bold'),'Processing ODBC test module ...',tput('off')

echo 'Setting logins ...'

if findItem('DQ','.',$opt{'t'})
 call setCurrent(addTarget(last))
else
 call setCurrent(addTarget('DQ_TEST',\
   {T_TYPE=>'Odbc',\
    T_SOURCE=>$arg[0],\
    T_USER=>nvl(${SET.DB.DB.I_DB}->get_first('T_USER'),'SYSTEM')}))
call ${CUR.O_TARGET}->set_trace(setTrace())

=pod

It loads the passwords that are encoded in the setup file and collects the
following information:

=over 4

=item o Current user

=item o Content of the C<v$version> table

=item o Content of the C<v$database> table

=item o Content of the C<v$pwfile_users> table

=item o Value of the C<remote_login_passwordfile> parameter

=item o Records of the C<dba_triggers> table with a null C<table_name>

=item o Macro library information

=item o List of available data source names

=back

=cut

set $job
{# ECHO Current User:
"# ECHO =============
"# SQL
"SELECT USER
" FROM dual
"/
"# ECHO
"# ECHO v$version
"# ECHO =========
"# SQL
"SELECT *
" FROM v$version
"/
"# ECHO
"# ECHO v$database
"# ECHO ==========
"# SQL
"SELECT *
" FROM v$database
"/
"# ECHO
"# ECHO v$pwfile_users
"# ECHO ==============
"# SQL
"SELECT *
" FROM v$pwfile_users
"/
"# ECHO
"# ECHO remote_login_passwordfile Parameter
"# ECHO ===================================
"# SQL
"SELECT value
" FROM v$parameter
" WHERE name = 'remote_login_passwordfile'
"/
"# ECHO
"# ECHO dba_triggers (null table_name)
"# ECHO ==============================
"# SQL
"SELECT owner,trigger_name,triggering_event,trigger_type,status
" FROM dba_triggers
" WHERE table_name IS NULL
" ORDER BY 1,2
"/
}
if loadDb($job)
{loop $lin(grepLastDb('.*'))
  dump $lin
}
if getDbMessage()
 echo last

dump
dump 'DBI Information'
dump '==============='
dump 'DB Provider: ',getDbProvider()
dump 'DB Version:  ',getDbVersion()

dump
dump join("\012  ",'Available drivers:',getDrivers())

dump
dump 'DBM Driver:    ',nvl(isDriverAvailable('DBM'),'(Not available)')
dump 'ODBC Driver:   ',nvl(isDriverAvailable('ODBC'),'(Not available)')
dump 'Oracle Driver: ',nvl(isDriverAvailable('Oracle'),'(Not available)')

dump
dump 'ODBC Data Sources'
dump '================='
loop $dsn (getDataSources())
 dump $dsn

=head1 COPYRIGHT NOTICE

Copyright (c) 2002, 2016, Oracle and/or its affiliates. All rights reserved.

=head1 TRADEMARK NOTICE

Oracle and Java are registered trademarks of Oracle and/or its
affiliates. Other names may be trademarks of their respective owners.

=cut
