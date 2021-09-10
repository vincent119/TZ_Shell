#!/bin/sh
##############################################################
#
#    Script by vincent.yu
#    Created Date 20110930
#
#
###########################################################
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/opt/app/memcached-1.4.5/bin/memcached
DAEMONBOOTSTRAP=/opt/app/memcached-1.4.5/bin/start-memcached
DAEMONCONF=/opt/app/memcached-1.4.5/conf/memcached.conf
NAME=memcached
DESC=memcached
PORT=11211
USER=daemon
PIDFILE=/var/run/$NAME.pid
prog=memcached
LOG="/tmp/RESTARTMEMCACHE.log"
URL="http://www.travelzen.com"
OUTPAGE="/tmp/page.html"
OUTSTAT="/tmp/outcurl.log"
OUTSTAT2="/tmp/outcurl2.log"
MAILLIST="vincent.yu@travelzen.com"



STRTIME=`date +"%Y%m%d-%H:%M:%S"`
printf "%s\n" "|~~~~~~~~~~~~~  START $STRTIME    ~~~~~~~~~~~~~|" > $LOG
echo >> $LOG
[ -x $DAEMON ] || exit 0
[ -x $DAEMONBOOTSTRAP ] || exit 0
start() {
 $DAEMONBOOTSTRAP $DAEMONCONF
 STATUS=`ps aux |grep $NAME |grep $PORT |awk '{print $2}'`
 if [ ${#STATUS} -gt 0 ];then
   printf "%s\n" "Service Started $DESC [`date +"%Y-%m-%d %H:%M"`]: [OK]"  >>$LOG
   echo >> $LOG
   printf "%s\n" "$NAME PID is $STATUS" >> $LOG
   echo >> $LOG
 else
   printf "%s\n" "Service Started $DESC [`date +"%Y-%m-%d %H:%M"`]: [FAILED]"  >>$LOG
   echo >> $LOG
 fi
}
stop() {
 PID=`ps aux |grep $NAME |grep $PORT |awk '{print $2}'`
 if [ ${#PID} -gt 0 ];then
   kill -9 $PID
 fi
 STATUS=`ps aux |grep $NAME |grep $PORT |awk '{print $2}' |wc -l`
 if [ $STATUS -eq 0 ];then 
   printf "%s\n" "Shutting down $DESC [`date +"%Y-%m-%d %H:%M"`]: [OK]"  >>$LOG
   echo >> $LOG
 else 
   printf "%s\n" "Shutting down $DESC [`date +"%Y-%m-%d %H:%M"`]: [FAILED]"  >>$LOG
   echo >> $LOG
 fi
}

 ### Main 
  stop
  start
  curl -# -o $OUTPAGE $URL > $OUTSTAT 2>&1
  printf "%s\n" "|~~~~~~ get $NAME    Cache ~~~~~~~~~~~~~~~~~|" >>$LOG
  tr -s "[\r]" "[\n]" <  $OUTSTAT >  $OUTSTAT2
  head -2 $OUTSTAT2 >>$LOG
  echo >> $LOG
ENDTIME=`date +"%Y%m%d-%H:%M:%S"`
printf "%s\n" "|~~~~~~~~~~~~~  END $ENDTIME    ~~~~~~~~~~~~~|" >> $LOG

mail -s "$HOSTNAME Restart $NAME STATUS" $MAILLIST <$LOG
