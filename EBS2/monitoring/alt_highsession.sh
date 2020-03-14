$BODY=/home/oraep01/monitoring/alt_highsession_email.txt
sqlplus -s "  / as sysdba " > a.out << EOS
        select  count(sid) Total_session,
			count(case status when 'ACTIVE' THEN 1 ELSE NULL END) Active_session,
        		count(case status when 'INACTIVE' THEN 1 ELSE NULL END ) Inactive_Session,
 			username
	   from v\$session
        WHERE  USERNAME NOT IN ( 'SYS', 'SYSTEM')
        group by  username; 
EOS

llist=`cat a.out | awk '{print $2}'`
echo $llist
for i in $llist
do
     if [ $i != 'ACTIVE_SESSION' ]
     then
         if [ $i != '--------------' ]
         then
             if [ $i -ge 40 ]
             then
                  mutt -s "Oracle EBS DB: High Active Session Alert " 'ritayan.banerjee@xenolithtechnologies.com,vikash@srei.com,L1.OracleSupport@srei.com' < $BODY
             fi
         fi
      fi
 done

rm a.out
exit 0

