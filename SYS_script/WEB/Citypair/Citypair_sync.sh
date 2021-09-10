#!/bin/bash
##########################################
#
#
#    Created Date: 20120607
#    script by Vincent.yu
#
##########################################
. /opt/SYS_script/PUBLIC_LIB/Funtion.ini
TODAY=`/bin/date +"%Y%m%d"`
FPATH="/opt/build"
SYS_CONF="/opt/SYS_script/PUBLIC_LIB/Sync_config"
TYPE="beta prod"
SYNC_LOG_PATH="/tmp/CITYPAIR_SYNC"
###################################################
COUNT(){
   S_TYPE=$1
   if [ $S_TYPE = "beta" ];then
     BETA_COUNT=`echo $BETA_COUNT +1 |/usr/bin/bc`
   elif [ $S_TYPE = "uat" ];then
     BETA_COUNT=`echo $UAT_COUNT +1 |/usr/bin/bc`
   elif  [ $S_TYPE = "prod" ];then
     PROD_COUNT=`echo $PROD_COUNT +1 |/usr/bin/bc`
   fi

}
SYNC(){
  IP=$1
  TYPE=$2
  TO_DATE=$3
  SER_NAME=$4
  TYPE=`echo $TYPE| awk '{print  tolower($1)}'`
  DESPATHW="/opt/deploy/$TO_DATE/CITYPAIR"
  SRCTPATHW="$FPATH/$TYPE/$TO_DATE/CITYPAIR"
  FILE1=`find /opt/build/$TYPE/$TO_DATE/CITYPAIR/ -name *citypair* |awk -F\/ '{ print $7}'`
  FILE2=`find /opt/build/$TYPE/$TO_DATE/CITYPAIR/ -name *hotelcity* |awk -F\/ '{ print $7}'`
  
  /usr/bin/ssh root@$IP "mkdir -p $DESPATHW"
  WLOG $SYNC_LOG "Created Folder:[ $DESPATHW ] on $SER_NAME."
  WLOG $SYNC_LOG "|************************************************************************************************|"
  WLOG $SYNC_LOG "Sync file to IP:$IP SERVER name:$SER_NAME [ $DESPATHW/ ]"
  /usr/bin/rsync -vrzta   --delete $SRCTPATHW/ -e /usr/bin/ssh root@$IP:$DESPATHW/
  if [ ${#FILE1} -gt 0 ];then
     WLOG $SYNC_LOG "sync FILE:[ $FILE1 ]"
  fi
  if [ ${#FILE2} -gt 0 ];then
     WLOG $SYNC_LOG "sync FILE:[ $FILE2 ]"
  fi 
  WLOG $SYNC_LOG "file is Synced........"
  ssh -t $IP "/opt/SYS_script/WEB/Citypair/Update/Citypair_update.sh  $TO_DATE" 
  WLOG $SYNC_LOG  "Running remote script [ $IP /opt/SYS_script/WEB/Citypair/Update/Citypair_update.sh  $TO_DATE  ]"
}
GET_IP(){
     SERVERTYPE=$1
     DDATE=$2
     DPATH="/opt/SYS_script/PUBLIC_LIB/CONFIG"
     
     if [ ! -f "$SYS_CONF/CITYPAIR.$SERVERTYPE.inf" ];then
        exit
     fi
     CONIF=$SYS_CONF/CITYPAIR.$SERVERTYPE.inf
     SERNAME=`/bin/cat $CONIF`
     for i in $SERNAME
       do 
        INFPATH=`find $DPATH -name $i.inf`
      	PUBLICIP=`cat $INFPATH | sed '/^#/g' |grep EXT_IP |awk -F= '{print $2}'`
        LOCATION=`cat $INFPATH | sed '/^#/d'|grep ^SITE |tr -d \"  |awk -F= '{print $2}'`
        SERVERNAME=`cat $INFPATH |  sed '/^#/g' |grep ^SERVER |awk -F= '{print $2}'`
        IDCNAME=`cat $INFPATH | sed '/^#/d' |grep ^IDC|tr -d \"  |awk -F= '{print $2}'`
        SERVERCLASS=`cat $INFPATH |sed '/^#/d'|grep ^CLASS|awk -F\= '{print  toupper($2)}'`
        #if [ $SERVERCLASS = "PROD" ];then
          WLOG $SYNC_LOG  "Sync $SERVERTYPE DATE:$DDATE"
          WLOG $SYNC_LOG  "Sync file to $PUBLICIP $LOCATION $SERVERNAME"
          SYNC $PUBLICIP $SERVERTYPE $DDATE $SERVERNAME
        #fi 
       done   
}
########### main ################################
BETA_COUNT=0
PROD_COUNT=0
UAT_COUNT=0
FLAG=0
SYDATE=$1
S_TTYPE=$2
if [ $HOSTNAME = "pre-prod" ];then
  if [ ! -d $SYNC_LOG_PATH ];then
    mkdir -p $SYNC_LOG_PATH
  fi
  SYNC_LOG=$SYNC_LOG_PATH/$TODAY.log
  FCHECK=`echo $SYDATE |awk '{ if ($1 ~/[0-9]+/) print 0 ; else print 1 }'`
  if [ $FCHECK -eq 1 ];then
     TMP=$SYDATE
     S_TTYPE=$TMP
     SYDATE=$TODAY
  fi   
  if [ ${#SYSDATE} -eq 0 ];then
    SYDATE=$TODAY
  fi
  if [ ${#S_TTYPE} -eq 0 ];then
    for i in $TYPE
    do
      if [ -s $FPATH/$i/$SYDATE/CITYPAIR/www.com.hotelcity.*.tar.gz ];then
        COUNT $i
      fi
      if [ -s $FPATH/$i/$SYDATE/CITYPAIR/www.com.citypair.*.tar.gz ];then
        COUNT $i
      fi
    done
  else 
    S_TTYPE=`echo $S_TTYPE|awk '{print  toupper($1)}'`  
    FLAG=1
  fi

  if [ $BETA_COUNT -gt 0 ] && [ $FLAG -eq 0 ];then
    GET_IP BETA $SYDATE
  fi
  if [ $PROD_COUNT -gt 0 ] && [ $FLAG -eq 0 ];then
    GET_IP PROD $SYDATE
  fi
  if [ $UAT_COUNT -gt 0 ] && [ $FLAG -eq 0 ];then
    GET_IP UAT $SYDATE
  fi
  if [ $FLAG -gt 0 ];then
    GET_IP $S_TTYPE
  fi

fi
