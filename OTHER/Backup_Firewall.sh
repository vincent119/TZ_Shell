#!/bin/bash
################################
#
#
#     script by vincent.yu
#     created date 20101223
#
#
#   
################################
TODATE=`date +"%Y%m%d"`
TIME=`date +"%H%m"`
########################################
MAILLIST="vincent.yu@travelzen.com ch.cheung@travelzen.com"
LOG=/tmp/log.log
########################################
BPATH=/opt/BK_CONFIG/FW/$TODATE
SSHUSER="CCKBackuP"
#########################################
SHFWIP="211.152.60.3"
HKFWIP="192.168.3.1"
BJFWIP="114.255.243.194"
TWFWIP="203.192.172.226"
#########################################
FWIPLIST="$SHFWIP $HKFWIP $BJFWIP $TWFWIP"
FWNAMELI=(SHAIDC.FW HKIDC.FW BJIDC.FW TWIDC.FW)
#########################################
echo "|-------------------------------------------------------------|" >$LOG
echo " Start `date +"%Y%m%d-%H%M%S"` backup Firewall config" >> $LOG
echo "|-------------------------------------------------------------|" >>$LOG

cd $BPATH

COUNT=0
for i in $FWIPLIST
do
    
  scp $SSHUSER@$i:ns_sys_config ${FWNAMELI[$COUNT]}.$TODATE.$TIME | >> $LOG

  COUNT=`expr $COUNT + 1`
done

ls -alh $BPATH/*.FW* | awk '{print $5,$6,$7,$8,$9}' >>$LOG




echo "|-------------------------------------------------------------|" >>$LOG
echo " END `date +"%Y%m%d-%H%M%S"` backup Firewall config" >> $LOG
echo "|-------------------------------------------------------------|" >>$LOG


cat $LOG | mail -s "Backup firewall config status"  $MAILLIST
