
#!/bin/bash
export DT=`date +%d%m%y_%H%M%S`
clusterflie=$HOME/alert/logs/cluster_alert$DT
 cd /u01/app/bin/
chk=`./crsctl check crs | grep -i "online" | wc -l`

if [ $chk -ne 4 ] 
then
     echo "Date        : "`date '+%m/%d/%y %X %A '` >> $clusterfile
     echo "Hostname    : "`hostname` >> $clusterfile
     echo "Oracle Cluster is down on $hostname please check " >>  $clusterfile
   ##mutt -s "Warning Cluster Down $HOSTNAME" db.support@srei.com 
/bin/mailx -s "Oracle Cluster might be down  on $hostname please check " l1.dbsupport@srei.com,l1.infrasupport@srei.com,ritayan.banerjee@srei.com,caesar.dutta@in.pwc.com,yogeshk@srei.com,abhijit.chakraborty@in.pwc.com < $clusterfile
cd $HOME/alert/logs/
for ((i=0;i<1;i++))
  do
( echo open 192.168.22.110 25
sleep 8
echo helo sreikolvpwspic.srei.com
echo mail from: $HOSTNAME
sleep 2
echo rcpt to: l1.dbsupport@srei.com
sleep 2
echo rcpt to: l1.infrasupport@srei.com
sleep 2
echo data
sleep 2
echo subject: CLUSTER USAGE ALERT FOR $ORACLE_SID
echo
echo
echo
echo CLUSTER MAY BE DOWN 
echo $clusterfile
echo
sleep 5
echo .
sleep 5
echo quit )| telnet

done



fi
exit


