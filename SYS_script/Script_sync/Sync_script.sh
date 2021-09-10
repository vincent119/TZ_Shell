#!/bin/bash
################################################
#
#
#
#       script by vincent.yu
#       Created date 20111006
#
#
########################################
SRCPATH="/opt/SYS_script/"
DESTPATH="/opt/SYS_script/"
SYNCLOG="/tmp/SYNC_script`date +%Y%m%d-%H%M`.log"
SDATE=`date +"%Y-%m-%d %H:%M:%S"`
########################################
GET_PUBINF_IP(){
DPATH="/opt/SYS_script/PUBLIC_LIB/CONFIG"
cd $DPATH
LIST=`ls $DPATH/`
for i in $LIST
do
  cd $DPATH/$i
  LIST2=`ls $DPATH/$i/`
  for x in $LIST2
    do

     IP=`cat $x |grep IPADDR |awk -F= '{print $2}'`
     SYNC_SCRIPT $IP
    done

done
}

SYNC_SCRIPT(){
  DESTSVR=$1
  DATE=`date +"%Y-%m-%d %H:%M:%S"`
  EXLIST="/opt/SYS_script/Script_sync/exclude.list"
  INCLUDE="/opt/SYS_script/Script_sync/include.list"
  echo >>$SYNCLOG 2>&1
  printf "%s\n"   "|###############################################################|" >>$SYNCLOG 2>&1
  printf "%s\n"   "|#" >>$SYNCLOG 2>&1
  printf "%s\n"   "|# $DATE" >>$SYNCLOG 2>&1
  printf "%s\n"   "|# Sync script to $DESTSVR" >>$SYNCLOG 2>&1
  printf "%s\n"   "|#" >>$SYNCLOG 2>&1
  printf "%s\n"   "|#" >>$SYNCLOG 2>&1 
  printf "%s\n"   "|###############################################################|" >>$SYNCLOG 2>&1
  printf "%s\n"   "|###############################################################|"
  printf "%s\n"   "|#"
  printf "%s\n"   "|# $DATE"
  printf "%s\n"   "|# Sync script to $DESTSVR"
  printf "%s\n"   "|#"
  printf "%s\n"   "|#"
  printf "%s\n"   "|###############################################################|"
  echo >>$SYNCLOG 2>&1
  #rsync -vrzta --progress --include-from=$INCLUDE --exclude "*.svn*" -exclude-from=$EXLIST --delete-excluded --delete $SRCPATH -e ssh root@$DESTSVR:$DESTPATH >>$SYNCLOG 2>&1
  rsync -pvrzta --timeout 30 --progress --exclude "*.svn*" \
                         --exclude-from=$EXLIST --delete-excluded --delete $SRCPATH -e ssh root@$DESTSVR:$DESTPATH >>$SYNCLOG 2>&1
                          #--exclude "Script_sync" --delete-excluded --delete $SRCPATH -e ssh root@$DESTSVR:$DESTPATH >>$SYNCLOG 2>&1
}

echo "" > $SYNCLOG
if [ $HOSTNAME != "monitor.travelzen.com" ];then 
 exit 0 ;
fi
cd $SRCPATH
SVNSTATUS=`svn status |wc -l`
DATE=`date +"%Y-%m-%d %H:%M:%S"`
printf "%s\n"   "|###############################################################|" >>$SYNCLOG 2>&1
printf "%s\n"   "|# sync script start Time : $DATE" >>$SYNCLOG 2>&1
printf "%s\n"   "|###############################################################|" >>$SYNCLOG 2>&1
printf "%s\n"   "|###############################################################|" 
printf "%s\n"   "|# sync script start Time : $DATE"
printf "%s\n"   "|###############################################################|"
echo >> $SYNCLOG

if [ $SVNSTATUS -ne 0 ];then
  printf "%s\n" "$SDATE SVN update start .............." >>$SYNCLOG 2>&1
  echo >> $SYNCLOG
  printf "%s\n" "svn status not equal "0"" >>$SYNCLOG 2>&1 
  svn update >> $SYNCLOG 2>&1 
  echo >> $SYNCLOG
  find . -name "*.sh" -type f -exec dos2unix {} \; >> $SYNCLOG 2>&1
  find . -name "*.sh" -exec chmod 750 {} \; >> $SYNCLOG 2>&1
fi

GET_PUBINF_IP

EDATE=`date +"%Y-%m-%d %H:%M:%S"`
echo >>$SYNCLOG 2>&1
printf "%s\n"   "|###############################################################|" >>$SYNCLOG 2>&1
printf "%s\n"   "|# sync script end Time : $EDATE" >>$SYNCLOG 2>&1
printf "%s\n"   "|###############################################################|" >>$SYNCLOG 2>&1
printf "%s\n"   "|###############################################################|"
printf "%s\n"   "|# sync script end Time : $EDATE" 
printf "%s\n"   "|###############################################################|"
