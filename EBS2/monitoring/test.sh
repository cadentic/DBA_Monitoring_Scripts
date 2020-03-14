sqlplus " / as sysdba" << EOS
select  count(sid) Total_session,
			count(case status when 'ACTIVE' THEN 1 ELSE NULL END) Active_session,
        		count(case status when 'INACTIVE' THEN 1 ELSE NULL END ) Inactive_Session,
 			username
	   from v\$session
        WHERE  USERNAME NOT IN ( 'SYS', 'SYSTEM')
        group by  username;
EOS

exit 0
