#!/bin/bash
###########################################
#
#
#   Created date 20110222
#   script by Vincent.Yu
#
###########################################
CHCONFIG="FW"
DPATH="/opt/BK_CONFIG/$CHCONFIG"
LOGPATH="/tmp/CON"
###########################################
MAILTO="vincent.yu@travelzen.com ch.cheung@travelzen.com"
###########################################
TODAY=`date +"%Y%m%d"`
YESTERDAY=`date --date='1 day ago' +"%Y%m%d"`
###########################################
DIFFFILE(){
  FILEHE=$1
  SODATE=$2
  DEDATE=$3
  FILESO=$4
  FILEDE=$5
  SOFILENAME=$FILEHE.$CHCONFIG.$SODATE.$FILESO
  DEFILENAME=$FILEHE.$CHCONFIG.$DEDATE.$FILEDE
  diff -B -b -i  -C 1 $DPATH/$SODATE/$SOFILENAME $DPATH/$DEDATE/$DEFILENAME > $LOGPATH/$FILEHE
}
CFILE(){
 STATUS=$1
 HEADFILE=$2
 if [ $STATUS -eq 1 ];then
   SOURCE=`ls $DPATH/$TODAY |awk 'BEGIN {FS ="."} /'$HEADFILE'/ {print $4}'|sort`
   ARRAYINDEX=0
   for x in $SOURCE
   do
     ARRAYSOURCE[$ARRAYINDEX]=$x
     ARRAYINDEX=`expr $ARRAYINDEX + 1`
   done
   SOURCEFILE=${ARRAYSOURCE[1]}
   DESTFILE=${ARRAYSOURCE[0]}
   SODATE=$TODAY
   DEDATE=$TODAY
 elif [  $STATUS -eq 2 ];then
  SOURCE=`ls $DPATH/$TODAY |awk 'BEGIN {FS ="."} /'$HEADFILE'/ {print $4}'|sort`
  DEST=`ls $DPATH/$YESTERDAY |awk 'BEGIN {FS ="."} /'$HEADFILE'/ {print $4}'|sort`
   ARRAYINDEX=0
   for y in $SOURCE
   do
     ARRAYSOURCE[$ARRAYINDEX]=$y
     ARRAYINDEX=`expr $ARRAYINDEX + 1`
   done
   ARRAYINDEX=0
   for yy in $DEST
   do
     DARRAYSOURCE[$ARRAYINDEX]=$yy
     ARRAYINDEX=`expr $ARRAYINDEX + 1`
   done
   SOURCEFILE=${ARRAYSOURCE[0]}
   DESTFILE=${DARRAYSOURCE[1]}
   SODATE=$TODAY
   DEDATE=$YESTERDAY 
 fi
 DIFFFILE $HEADFILE $SODATE $DEDATE $SOURCEFILE $DESTFILE 
}


cd $DPATH/$TODAY
if [ ! -d $LOGPATH ];then
  mkdir -p $LOGPATH
fi
LIST=`ls *`
HEAD=`ls * |awk -F . '{print $1}' |uniq`

for i in $HEAD
do
  COUNT=`ls * |grep $i |wc -l`
  if [ $COUNT -eq 2 ];then
    CFILE 1 $i
  else
    CFILE  2 $i
  fi

done
cd  $LOGPATH
MAILFILE=`ls -la * |awk '$5 != 0 {print $9}'`
for cc in $MAILFILE
do
 /usr/bin/mutt -s "had changed config for '$cc'  !"  $MAILTO < $cc


done





