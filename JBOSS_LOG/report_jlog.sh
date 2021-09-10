#!/bin/bash
########################################
source /opt/script/JBOSS_LOG/INI.inf
source /opt/script/JBOSS_LOG/SUB/FTP.sh
##############################################
#
#   user-search-stat-1 session-service-action-1 hotel-search-stat-1 file in ota-web
#
##############################################  
if [ -s $ARCPATH/$OTAWEBPATH/user-search-stat-1.`date +%Y-%m-%d -d yesterday`.log.gz ];then
  cd $ARCPATH/$OTAWEBPATH
  gunzip user-search-stat-1.`date +%Y-%m-%d -d yesterday`.log.gz
  cat user-search-stat-1.`date +%Y-%m-%d -d yesterday`.log | cut -c20-23 --complement | sed 's/\.000//g' > user-search-stat-1.log.shta1.import
  gzip user-search-stat-1.`date +%Y-%m-%d -d yesterday`.log
  sed -i 's/,/|/g' user-search-stat-1.log.shta1.import 
elif [ -s  $ARCPATH/$OTAWEBPATH/hotel-search-stat-1.`date +%Y-%m-%d -d yesterday`.log.gz ];then
  cd $ARCPATH/$OTAWEBPATH
  gunzip hotel-search-stat-1.`date +%Y-%m-%d -d yesterday`.log.gz
  cat hotel-search-stat-1.`date +%Y-%m-%d -d yesterday`.log | cut -c20-23 --complement | sed 's/\.000//g' > hotel-search-stat-1.log.shta1.import
  gzip hotel-search-stat-1.`date +%Y-%m-%d -d yesterday`.log
  sed -i 's/,/|/g' hotel-search-stat-1.log.shta1.import 
elif [ -s  $ARCPATH/$OTAWEBPATH/session-service-action-1.`date +%Y-%m-%d -d yesterday`.log.gz ];then
  cd $ARCPATH/$OTAWEBPATH
  gunzip session-service-action-1.`date +%Y-%m-%d -d yesterday`.log.gz
  #cat session-service-action-1.`date +%Y-%m-%d -d yesterday`.log | cut -c20-23 --complement | sed 's/\.000//g' | grep -v ',,,,' > session-service-action-1.log.shta1.import
  cat session-service-action-1.`date +%Y-%m-%d -d yesterday`.log | cut -c20-23 --complement | sed 's/\.000//g'  > session-service-action-1.log.shta1.import
  gzip session-service-action-1.`date +%Y-%m-%d -d yesterday`.log
  sed -i 's/,/|/g' session-service-action-1.log.shta1.import
  F_FTP
  rm -f *.import
if
#################################
#
#
#  user-search-stat-affiliate hotel-search-stat-affiliate  in web01 affiliate
#################################
if [ -s $ARCPATH/affiliate/user-search-stat-affiliate.date +%Y-%m-%d -d yesterday`.log.gz ];then
  cd $ARCPATH/affiliate
  gunzip user-search-stat-affiliate.`date +%Y-%m-%d -d yesterday`.log.gz
  cat user-search-stat-affiliate.`date +%Y-%m-%d -d yesterday`.log | cut -c20-23 --complement | sed 's/\.000//g' > user-search-stat-affiliate.log.shta1.import 
  gzip user-search-stat-affiliate.`date +%Y-%m-%d -d yesterday`.log
  sed -i 's/,/|/g' user-search-stat-affiliate.log.shta1.import 
  F_FTP
  rm -f *.import
elif [ -s $ARCPATH/affiliate/hotel-search-stat-affiliate.`date +%Y-%m-%d -d yesterday`.log.gz ];then
  cd $ARCPATH/affiliate
  gunzip hotel-search-stat-affiliate.`date +%Y-%m-%d -d yesterday`.log.gz
  cat hotel-search-stat-affiliate.`date +%Y-%m-%d -d yesterday`.log | cut -c20-23 --complement | sed 's/\.000//g' > hotel-search-stat-affiliate.log.shta1.import 
  gzip hotel-search-stat-affiliate.`date +%Y-%m-%d -d yesterday`.log
  sed -i 's/,/|/g' hotel-search-stat-affiliate.log.shta1.import 
  F_FTP
  rm -f *.import
fi
###########################################################
# Section 2
#
#
#
##########################################################
if [ -s $ARCPATH/hotelcrs-web-revamp/hotel-price-audit.`date +%Y-%m-%d -d yesterday`.log.gz ];then
  cd $ARCPATH/hotelcrs-web-revamp 
  gunzip hotel-price-audit.`date +%Y-%m-%d -d yesterday`.log.gz
  cat hotel-price-audit.`date +%Y-%m-%d -d yesterday`.log | cut -c20-23 --complement > hotel-price-audit.log.sh.import
  gzip hotel-price-audit.`date +%Y-%m-%d -d yesterday`.log
  sed -i 's/^\([^,]*\),\([^,]*\),\([^,]*\),\([^,]*\),\([^,]*\),\([^,]*\),\([^,]*\),\([^,]*\),/\1|\2|\3|\4|\5|\6|\7|\8|/' hotel-price-audit.log.sh.import
  F_FTP
  rm -f *.import 
fi
