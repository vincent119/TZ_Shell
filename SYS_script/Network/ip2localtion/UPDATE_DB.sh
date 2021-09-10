#!/bin/sh
####################################################
#
#
#    Script by vincent.yu
#    created Date 20110523
#    Changed Date 20120112
#
#####################################################
LOG="/tmp/ip2localtion.log"
MAILTO="instant.msg@travelzen.com"
DPATH2="/opt/SYS_script/Network/ip2localtion"
DPATH="/opt/app/IP2Location-DB"





echo "|------- `date +%Y%m%d-%H:%M:%S` strat dwonload --------|" > $LOG
if [ ! -d $DPATH ];then
 mkdir $DPATH
fi
/usr/bin/perl $DPATH2/download.pl -package DB3BIN -login techserv@travelzen.com -password YouYou2007! 

if [ -e IP-COUNTRY-REGION-CITY.BIN.ZIP ];then
  echo  >> $LOG
  echo "`date +%Y%m%d-%H:%M:%S` Download IP-COUNTRY-REGION-CITY.BIN.ZIP  complete!! " >> $LOG
  echo >> $LOG
  echo "|---- unzip .ZIP file -------- | " >>$LOG
  echo >> $LOG
  mv IP-COUNTRY-REGION-CITY.BIN.ZIP $DPATH/
  cd $DPATH
  if [ ! -d $DPATH/APACHE ];then
    mkdir -p  $DPATH/APACHE
  fi
  if [ -e $DPATH/APACHE/IP-COUNTRY-REGION-CITY.BIN ];then
     mkdir $DPATH/`date '+%Y%m%d'`
     mv $DPATH/APACHE/IP-COUNTRY-REGION-CITY.BIN $DPATH/`date '+%Y%m%d'`
  fi
  unzip IP-COUNTRY-REGION-CITY.BIN.ZIP >> $LOG
  rm -rf *.PDF *.TXT *.ZIP 
  if [ -s $DPATH/IP-COUNTRY-REGION-CITY.BIN ];then
    mv ./IP-COUNTRY-REGION-CITY.BIN $DPATH/APACHE/
    /opt/app/httpd/bin/apachectl stop  
    sleep 5
    echo >> $LOG
    /opt/app/httpd/bin/apachectl start 
    echo "|------`date +%Y%m%d-%H:%M:%S` IP2localtion IP-COUNTRY-REGION-CITY.BIN Update  complete!!" >> $LOG
    /usr/bin/mutt -s "IP2localtion Update  complete  - ( $HOSTNAME ) !"  $MAILTO < $LOG
  fi
else 
 echo >> $LOG
 echo "Download fail `date +%Y%m%d-%H:%M:%S` " >> $LOG
 echo   >> $LOG
 echo " this script run again at 2 hours later " >> $LOG
 echo >> $LOG 
 echo " at -f $DPATH2/UPDATE_DB.sh now + 2 hours "  >> $LOG
  /usr/bin/at -f $DPATH2/UPDATE_DB.sh now + 2 hours 
 /usr/bin/mutt -s "IP2localtion Update fail - ( $HOSTNAME ) !"  $MAILTO < $LOG
fi



