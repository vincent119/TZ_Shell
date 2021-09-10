#!/bin/bash
############################################################
#
#
#         script by vincent.yu
#         created date 20120327
##
#
############################################################
. /opt/SYS_script/PUBLIC_LIB/Funtion.ini




SHOW_INFO(){
  STATUS=$1
  TAIP=`cat /etc/hosts  |sed '/^#/d' |grep travelagent.travelzen.com |awk '{print $1}'`
  TANAME=`cat /etc/hosts  |sed '/^#/d' |grep travelagent.travelzen.com |awk '{print $2}'`
  if [ $TAIP = "192.168.103.200" ];then
    TANAME=HK
  elif [ $TAIP = "192.168.103.220" ];then
    TANAME=CN
  fi
  if [ $STATUS = 1 ];then
    clear
    printf "%s\n" "|------------------------------------------------------------------------------------|"
    printf "%s\n" "|"
    printf "%s\n" "|"
    printf "%s\n" "|    IP using $TAIP  for travelagent.travelzen.com ........."
    printf "%s\n" "|"
    printf "%s\n" "|   using $TANAME TA now .........................."
    printf "%s\n" "|"
    printf "%s\n" "|------------------------------------------------------------------------------------|"
  elif [ $STATUS = 2 ];then
    clear
    printf "%s\n" "|------------------------------------------------------------------------------------|"
    printf "%s\n" "|"
    printf "%s\n" "|"
    printf "%s\n" "|   IP using $TAIP  for travelagent.travelzen.com........."
    printf "%s\n" "|"
    printf "%s\n" "|   using $TANAME TA now .........................."
    printf "%s\n" "|"
    printf "%s\n" "|************************************************************************************|"
    printf "%s\n" "|"
    printf "%s\n" "|******************    changed host table *******************************************|"
    printf "%s\n" "|*"
    printf "%s\n" "|*(1) Change to HK TA.................................."
    printf "%s\n" "|*(2) Change to CN TA.................................."
    printf "%s\n" "|*(3) Exit............................................."
    printf "%s\n" "|*"
    printf "%s\n" "|************************************************************************************|"
    printf "%s\n" "|------------------------------------------------------------------------------------|"
    read -p "Please type one number [1,2,3 or 4..........7 ] or Ctrl + C Skip it  !!! : " SERVICE
    CHANGE_HOST
 fi
}
CHANGE_HOST(){
 case "$SERVICE" in
  1)# changed to HK  
    sed -i '/travelagent.travelzen.com/d'  /etc/hosts
    echo "192.168.103.200 travelagent.travelzen.com" >> /etc/hosts
    SHOW_INFO 1
   ;;

  2)# changed to CN 
   sed -i '/travelagent.travelzen.com/d' /etc/hosts
   echo "192.168.103.220 travelagent.travelzen.com" >> /etc/hosts
   SHOW_INFO 1
   ;;
  3) exit 0;;
  *) SHOW_INFO 2 ;;
 esac




}
SHOW_MESS(){
  clear
  printf "%s\n" "|------------------------------------------------------------------------------------|"
  printf "%s\n" "|"
  printf "%s\n" "|"
  printf "%s\n" "|       can not running this is script ........."
  printf "%s\n" "|"
  printf "%s\n" "|------------------------------------------------------------------------------------|"
  exit 0;
}

INF_FILE=`find /opt/SYS_script/PUBLIC_LIB/CONFIG/ -name $HOSTNAME.inf`

if [ ! -s $INF_FILE ];then
  SHOW_MESS
fi

PHPUSE=`cat $INF_FILE |sed '/^#/d'|grep ^USE_PHP|awk -F\= '{print $2}'`
if [ $PHPUSE != "Y" ];then
 SHOW_MESS

fi





SHOW_INFO 2
