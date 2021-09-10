#!/bin/bash
####################################
#
#
#       script by vincent.yu
#       created date 20120319
#
#
####################################





PPATCH="/var/named/chroot/var/named"
VIEWZONE="INT_HK INT_CN"
DOMAIN="travelzen.com travelzen.com.cn"
FILE=/opt/vhost/NCIS


TIME=`date "+%Y-%m-%d %H:%M"`


for ZONE in $VIEWZONE
do
  for DOM in $DOMAIN
  do  
    FILENAME=$FILE/$ZONE-$DOM.html
    echo "<!doctype html>" >$FILENAME
    echo "<html> <head> <meta charset="UTF-8"> <title>Top Page</title> </head> <html> <table border=1 width=40% height=120 >" >> $FILENAME
    echo "<tr><td colspan=3> $TIME Updated by $DOM</td></tr>" >> $FILENAME
    cat $PPATCH/$ZONE/$DOM | sed '1,7d;/^;/d;/^$/d;/IN NS*/d;/IN MX*/d'|awk '{printf ("%s%-15s%-50s\n", "<tr><td>" NR "</td><td>", $1,"</td><td>"  $4 "</p></td></tr>")}'  >> $FILENAME

    echo "</table></html>" >> $FILENAME
  done
done
