#!/bin/sh
#################################################################################
#                                                                               #
#   script by vincent.yu                                                        #
#   date 20100706                                                               #
#   Version 1.0                                                                 #
#                                                                               #
#   1.copy script to /usr/local/bin/                                            #
#   2.change file access  to 777                                                #
#     chmod 777 /usr/local/bin/radius_monitor.sh                                #
#   3.use running this script in the background                                 #
#     radius_monitor.sh &                                                       #
#################################################################################
PTS="/dev/pts"
FPTS="/var/run/radiusclient/pts/"
TIMERUN=10

RUN_SCRIPT(){
 
  LIST=$1
  #echo $FPTS$LIST 
  chmod 777 $FPTS$LIST
  $FPTS$LIST
  rm -rf $FPTS$LIST
}
###########################################
while :
do
  PTSLIST=`ls -al $PTS | awk '{print $10}' `
  FPTSLIST=`ls $FPTS`
  for i in $FPTSLIST
  do 
    CHECK_POINT="A"
    for x in $PTSLIST
    do
      if [ $i -eq $x ];then
       CHECK_POINT="A"
       break
      else
       CHECK_POINT="B" 
      fi
    done
    if [ $CHECK_POINT = "B" ];then
       RUN_SCRIPT $i
    fi
  done
  sleep $TIMERUN
done
