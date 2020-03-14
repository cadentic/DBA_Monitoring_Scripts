

found=`ps -aef | grep pmon | grep -v grep | wc -l`
lastline=`tail -1 updown.log`

if [ $found -lt 2 ]
then
    ## pmon process is not there
     if [ `echo $lastline | grep "no pmon process" | wc -l` -gt 0 ]
     then
          echo 'do nothing no pmon process'
     else
          echo "no pmon process `date`" >> updown.log
     fi
else
     ##pmnon process is there
      if [ `echo $lastline | grep "pmon process up" | wc -l` -gt 0 ]
     then
          echo 'do nothing pmon process up'
     else
          echo "pmon process up `date`" >> updown.log
     fi
fi

