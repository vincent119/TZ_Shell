#!/bin/sh
#
#
#
#     changed Date by 20120112
################################################

LOG="/tmp/for_dns_ip2localtion.log"
MAILTO="instant.msg@travelzen.com"
DPATH2="/opt/SYS_script/Network/ip2localtion"
DPATH="/opt/app/IP2Location-DB"


echo "|------- `date +%Y%m%d-%H:%M:%s` strat dwonload --------|" > $LOG
/usr/bin/perl ./download.pl -package DB3 -login techserv@travelzen.com -password YouYou2007!
/usr/bin/perl ./download.pl -package DB1 -login techserv@travelzen.com -password YouYou2007!

if [ -e IP-COUNTRY-FULL.ZIP ] && [ -e IP-COUNTRY-REGION-CITY-FULL.ZIP ];then
  echo  >> $LOG
  echo "`date +%Y%m%d-%H:%M:%s` Download IP-COUNTRY-REGION-CITY.BIN.ZIP  complete!! " >> $LOG
  echo >> $LOG
  echo "|---- unzip .ZIP file -------- | " >>$LOG
  echo >> $LOG
  mv IP-COUNTRY-FULL.ZIP $DPATH/
  mv IP-COUNTRY-REGION-CITY-FULL.ZIP $DPATH/
  cd $DPATH/ 
  unzip  IP-COUNTRY-FULL.ZIP >> $LOG
  rm -rf *.PDF *.TXT *.pdf *.HTM AOL.csv *.dump  Satellite.csv *.MDB
  unzip  IP-COUNTRY-REGION-CITY-FULL.ZIP >> $LOG
  rm -rf *.PDF *.TXT *.pdf *.HTM AOL.csv *.dump  Satellite.csv *.MDB

  echo >> $LOG
  echo "|------`date +%Y%m%d-%H:%M:%s` IP2localtion IP-COUNTRY-REGION-CITY.BIN Update  complete!!" >> $LOG
   /usr/bin/mutt -s "IP2localtion Update  complete  - ( $HOSTNAME ) !"  $MAILTO < $LOG
else
 echo >> $LOG
 echo "Download fail `date +%Y%m%d-%H:%M:%s` " >> $LOG
fi

