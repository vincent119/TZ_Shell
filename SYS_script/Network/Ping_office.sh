#!/bin/bash
######################################################
#    
#          Script by Vincent.yu
#          Created date 20111013
#
######################################################
#116.66.38.129 116.66.38.129-SH
#180.168.172.62 180.168.172.62-SH
#210.242.233.194 210.242.233.194-TW
#119.6.17.202 119.6.17.202-Chengdu
#123.246.59.222 123.246.59.222-Dalian
#222.128.36.220 222.128.36.220-BJ
#125.89.67.10 125.89.67.10-Zhuhai
#118.142.18.41 118.142.18.41-hk1
#210.3.237.177 210.3.237.177-hk2

PCOUNT=5
TIMEOUT=5
TMPLOG=/tmp/PING.txt
RESULT=/tmp/B28ping.txt
IPLIST="116.66.38.129 180.168.172.62 210.242.233.194 119.6.17.202 123.246.59.222 222.128.36.220 125.89.67.10 118.142.18.41 210.3.237.177"
ARRAYL=(SH1 SH2 TW CHENGDU DALIAN BEK ZHUHAI HK1 HK2)
echo "" > $RESULT
COUNT=0
for I in $IPLIST
do
  ping -q -c $PCOUNT -W $TIMEOUT  $I  >$TMPLOG
  LOSS=`cat $TMPLOG  |grep packet |awk -F\, '{print $3}'|awk -F\% '{print $1}'|sed 's/^[ \t]*//'`
  PMIN=`cat $TMPLOG |grep min |awk -F= '{print $2}'| awk -F\/ '{print $1}'|sed 's/^[ \t]*//' `
  PAVG=`cat $TMPLOG |grep min |awk -F= '{print $2}'| awk -F\/ '{print $2}'|sed 's/^[ \t]*//' `
  PMAX=`cat $TMPLOG |grep min |awk -F= '{print $2}'| awk -F\/ '{print $3}'|sed 's/^[ \t]*//' `
  printf "%s\t%s\t%s\t%s\t%s\n" ${ARRAYL[$COUNT]} LOSS:$LOSS PMIN:$PMIN PAVG:$PAVG PMAX:$PMAX >>$RESULT
  COUNT=`echo "( $COUNT + 1)"|bc`
done



cd /tmp
ftp -in 192.168.3.34 << end
user cactiupload travelzen
bin
mput B28ping.txt
bye
