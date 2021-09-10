#!/bin/bash
####################################################
#
#
#              script by vincent.yu
#
#              created date 20120307
#
#
#
#
####################################################
. /opt/SYS_script/PUBLIC_LIB/Funtion.ini




GET_IP(){
     DPATH="/opt/SYS_script/PUBLIC_LIB/CONFIG"
     if [ ! -f "/opt/SYS_script/PUBLIC_LIB/Sync_config/$HOSTNAME.inf" ];then
        exit
     fi
     CONIF=/opt/SYS_script/PUBLIC_LIB/Sync_config/$HOSTNAME.inf
     SERNAME=`cat $CONIF`
     for i in $SERNAME
       do 
        INFPATH=`find $DPATH -name $i.inf`
      	PUBLICIP=`cat $INFPATH | sed '/^#/g' |grep EXT_IP |awk -F= '{print $2}'`
        LOCATION=`cat $INFPATH |grep ^SITE | sed '/^#/d' |tr -d \"  |awk -F= '{print $2}'`
        SERVERNAME=`cat $INFPATH |  sed '/^#/g' |grep ^SERVER |awk -F= '{print $2}'`
        IDCNAME=`cat $INFPATH |grep ^IDC | sed '/^#/d' |tr -d \"  |awk -F= '{print $2}'`
        SERVERCLASS=`cat $INFPATH |sed '/^#/d'|grep ^CLASS|awk -F\= '{print  toupper($2)}'`
        if [ $SERVERCLASS = "PROD" ];then
      	  SYNC $PUBLICIP $LOCATION $SERVERNAME $IDCNAME
        fi 
       done   
}
SYNC(){
    IP=$1
    SITE=$2
    SERNAME=$3
    IDC=$4
    DESTPATH="/opt/deploy/$DATETIME/PHP"
    SRCPATH="/opt/build/prod/$DATETIME"
    PPATCHDIR="/opt/deploy/$DATETIME/PHP_patch" 
    STR="############################################################"
    printf "%s\n" "$STR"  
    STR="#"
    printf "%s\n" "$STR"
    STR="#  careted folder on $IP"
    printf "%s\n" "$STR"
    WLOG $LOG_FILE "$STR"
    ssh -t $IP "mkdir -p $DESTPATH ;mkdir -p $PPATCHDIR"
    STR="#"
    printf "%s\n" "$STR"
    STR="# SYNC to $SITE $IDC IP is -$IP- SERVER name: $SERNAME"
    printf "%s\n" "$STR"
    WLOG $LOG_FILE "$STR"
    STR="#"
    printf "%s\n" "$STR"
    STR="############################################################"
    printf "%s\n" "$STR" 
    rsync -vrztaP --progress --delete  $SRCPATH/PHP/ -e ssh root@$IP:$DESTPATH/  > $LOG_PATH/$SERNAME
    rsync -vrztaP --progress --delete $SRCPATH/PHP_patch/ -e ssh root@$IP:$PPATCHDIR/
    STR="#"
    printf "%s\n" "$STR"
    STR="# remote running sync script......."
    WLOG $LOG_FILE "$STR"
    printf "%s\n" "$STR"
    ssh -t $IP "/opt/SYS_script/WEB/Sync/PHP_SYNC/prod/SYNC_prod.sh $DATETIME" 
    STR="############################################################"
    printf "%s\n" "$STR"
}



## main 


DATETIME=$1
LOG_PATH=/tmp/PHP_upload_`date "+%Y%m%d-%H%M"`
LOG_FILE=/tmp/PHP_upload_`date "+%Y%m%d-%H%M"`/system.txt
if [ ! -d $LOG_PATH ];then
  mkdir -p $LOG_PATH
fi

if [ ${#DATETIME} -eq 0 ];then
   printf "%s\n"  "|-----------------------------------------------------------------|"
   printf "%s\n"  "|"
   printf "%s\n"  "|   need key in  date "
   printf "%s\n"  "|"
   printf "%s\n"  "|-----------------------------------------------------------------|"
   exit;
   
fi

GET_IP
