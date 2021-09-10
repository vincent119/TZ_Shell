#!/bin/bash
#############################################
#
#
#     created date 20120904
#     script by vincent yu
#
#
##############################################

LOG=/tmp/backupa10.txt


TODATE=`date +"%Y%m%d"
`
printf "%s\n" "|----- `date +"%Y%m%d-%H:%M:%S"` start backup A10  -------------------------|" > $LOG
printf "%s\n" "" >>$LOG
/opt/app/php-5.3.3/bin/php /opt/SYS_script/Backup/A10/A10Backup_20121002.php
cd /home/BackupA10UAER/
mv ./*.bk /opt/BK_CONFIG/A10/$TODATE
cd /opt/BK_CONFIG/A10/$TODATE
ls -al  *.bk |awk '{print "Size: "$5,"DateTime: "$6"-"$7,$8,"FileName: "$9}' >>$LOG

printf "%s\n" "" >>$LOG

printf "%s\n" "|----- `date +"%Y%m%d-%H:%M:%S"` finshed backup A10  -------------------------|" >> $LOG

