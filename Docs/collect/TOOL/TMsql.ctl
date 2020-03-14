# TMsql.ctl: Tests SQL Settings
# $Id: TMsql.ctl,v 1.4 2013/10/30 07:18:56 RDA Exp $
# ARCS: $Header: /home/cvs/cvs/RDA_8/src/scripting/lib/collect/TOOL/TMsql.ctl,v 1.4 2013/10/30 07:18:56 RDA Exp $
#
# Change History
# 20130422  MSC  Improve the validation.

=head1 NAME

TMsql - Tests SQL*Plus Settings and Gets some Database Configuration
Information

=head1 DESCRIPTION

=cut

options t:

section tool
call unshift(@{CUR.W_NEXT},'test')

section test

echo tput('bold'),'Processing SQL test module ...',tput('off')

if findItem('SQ','.',$opt{'t'})
 call setCurrent($dft = addTarget(last))
elsif ${SET.DB.DB.I_DB}
 call setCurrent($dft = addTarget(last))
elsif ?testDir('d',${ENV.ORACLE_HOME})
 call setCurrent($dft = addTarget('SQ_TEST',\
   {B_LOCAL      =>true,\
    D_ORACLE_HOME=>last,\
    T_ORACLE_SID =>${ENV.ORACLE_SID}}))
else
 call setCurrent($dft = addTarget('SQ_TEST',{T_ORACLE_SID=>${ENV.ORACLE_SID}}))
call ${CUR.O_TARGET}->set_trace(setTrace())

=pod

This tool loads the passwords that are encoded in the setup file and collects
the following information:

=over 4

=item o Current user

=item o Current SQL*Plus settings

=item o Content of the C<v$version> table

=item o Content of the C<v$database> table

=item o Content of the C<v$pwfile_users> table

=item o Value of the C<remote_login_passwordfile> parameter

=item o Records of the C<dba_triggers> table with a null C<table_name>

=back

=cut

set $sql
{PROMPT Current User:
"PROMPT =============
"SELECT USER
" FROM dual;
"
"PROMPT
"PROMPT Current SQL*Plus Settings:
"PROMPT ==========================
"SHOW all
"
"COLUMN value FORMAT a20
"COLUMN owner FORMAT a10
"COLUMN trigger_name FORMAT a20
"COLUMN status FORMAT a10
"COLUMN triggering_event FORMAT a16
"COLUMN trigger_type FORMAT a16
"SET wrap on
"SET heading on
"SET linesize 80
"
"PROMPT
"PROMPT v$version
"PROMPT =========
"SELECT *
" FROM v$version;
"
"PROMPT
"PROMPT v$database
"PROMPT ==========
"SELECT *
" FROM v$database;
"
"PROMPT
"PROMPT v$pwfile_users
"PROMPT ==============
"SELECT *
" FROM v$pwfile_users;
"
"PROMPT
"PROMPT remote_login_passwordfile Parameter
"PROMPT ===================================
"SELECT value
" FROM v$parameter
" WHERE name = 'remote_login_passwordfile';
"
"PROMPT
"PROMPT dba_triggers (null table_name)
"PROMPT ==============================
"SELECT owner,trigger_name,triggering_event,trigger_type,status
" FROM dba_triggers
" WHERE table_name IS NULL
" ORDER BY 1,2;
}
if loadSql($sql)
{loop $lin(grepLastSql('.*'))
  dump $lin
}
if getSqlMessage()
 echo last

=head1 COPYRIGHT NOTICE

Copyright (c) 2002, 2016, Oracle and/or its affiliates. All rights reserved.

=head1 TRADEMARK NOTICE

Oracle and Java are registered trademarks of Oracle and/or its
affiliates. Other names may be trademarks of their respective owners.

=cut
