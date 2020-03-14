
$ORACLE_HOME/bin/rman nocatalog <<EOF | tee  /dump/rmanbackup/blog_03-Jul-14.log
connect target /
run {
   allocate channel t1 type disk connect 'sys/keltu6400@ep011';
   allocate channel t2 type disk connect 'sys/keltu6400@ep012';
   sql 'alter system archive log current';
   backup format '/dump/rmanbackup/ArchBackup_6269-1_03-Jul-14__%s_%p_%u' archivelog sequence 6269 thread 1;
   backup format '/dump/rmanbackup/ArchBackup_4553-2_03-Jul-14__%s_%p_%u' archivelog sequence 4553 thread 2;
   backup format '/dump/rmanbackup/ArchBackup_4554-2_03-Jul-14__%s_%p_%u' archivelog sequence 4554 thread 2;
   backup current controlfile format '/dump/rmanbackup/ctrl-03-Jul-14__%s_%p_%u';
   release channel t1;
   release channel t2;
}
EOF

exit 0

