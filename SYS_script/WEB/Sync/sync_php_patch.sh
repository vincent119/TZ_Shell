#!/bin/bash
####################################################
#
#
#          Script by vincent.yu
#          Created date 20120308
#
#
####################################################
. /opt/SYS_script/PUBLIC_LIB/Funtion.ini
DATE=`date +%Y%m%d-%H%M`
LOGDIR=/tmp/php_patch.$DATE.log
PATCH="/opt/build/prod"


GET_PUBINF_IP(){
 SER_TYPE=$1
 DPATH="/opt/SYS_script/PUBLIC_LIB/CONFIG"
 if [ $SER_TYPE !=  1 ];then
   SERNAME=`cat /opt/SYS_script/PUBLIC_LIB/Sync_config/WEBPHP.inf` 
 else
   SERNAME="server03"
 fi
 for i in $SERNAME
 do
    
    INFPATH=`find $DPATH -name $i.inf`
    if [ ${#INFPATH} -eq 0 ];then
      STR="############################################################"
      WLOG $LOGDIR/system.log  "$STR"
      printf "%s\n" "$STR"
      STR="# can not found out $i"
      WLOG $LOGDIR/system.log  "$STR"
      printf "%s\n" "$STR"
      STR="############################################################"
      WLOG $LOGDIR/system.log  "$STR"
      printf "%s\n" "$STR"
    else
      PUBLICIP=`cat $INFPATH | sed '/^#/g' |grep EXT_IP |awk -F= '{print $2}'`
      LOCATION=`cat $INFPATH |grep ^SITE | sed '/^#/d' |tr -d \"  |awk -F= '{print $2}'`
      SERVERNAME=`cat $INFPATH |  sed '/^#/g' |grep ^SERVER |awk -F= '{print $2}'`
      IDCNAME=`cat $INFPATH |grep ^IDC | sed '/^#/d' |tr -d \"  |awk -F= '{print $2}'`
      SYNC $PUBLICIP $LOCATION $SERVERNAME $IDCNAME
    fi

 done
}

SYNC(){
   IP=$1
   SITE=$2
   SERNAME=$3
   IDC=$4
   DEPLOYPATH="/opt/deploy/$ADATETIME"
   STR="############################################################"
   WLOG $LOGDIR/system.log  "$STR"
   printf "%s\n" "$STR"
   STR="Created floder on $SERNAME $DEPLOYPATH"
   printf "%s\n" "$STR"
   WLOG $LOGDIR/$SERNAME.log  "$STR"
   ssh root@$IP "mkdir -p $DEPLOYPATH/PHP_patch"
   echo "|------------------------------------------------------------|"
   STR="SCP file to $SERNAME $DEPLOYPATH....."
   printf "%s\n" "$STR"
   echo "|------------------------------------------------------------|"
   WLOG $LOGDIR/$SERNAME.log  "$STR"
   #scp -p -r $PHPPATH root@$IP:$DEPLOYPATH/PHP_patch/   
   rsync -vrzta --progress   --delete $PHPPATH/ -e ssh root@$IP:$DEPLOYPATH/PHP_patch/
   STR=" $SITE $SERNAME remote running script /opt/SYS_script/WEB/Sync/PHP_PATH/PHP_PATCH.sh  $ADATETIME...."
   printf "%s\n" "$STR"
   WLOG $LOGDIR/$SERNAME.log  "$STR" 
   ssh root@$IP "/opt/SYS_script/WEB/Sync/PHP_PATH/PHP_PATCH.sh  $ADATETIME"&
   STR="############################################################"
   WLOG $LOGDIR/system.log  "$STR"
   printf "%s\n" "$STR"
   DTIME=`date +"%H%M"`
   
   #ssh root@$IP "cd $DEPLOYPATH/PHP_patch/ ;mv patch-*.lst patch$DATETIME-$DTIME.lst.bk ;mv patch-*.tar.bz2 patch$DATETIME-$DTIME.tar.bz2.bk"



}



read -p  "Deployment date :" ADATETIME
clear
echo "|----------------------------------------------------------------|"
echo "|                                                          "
echo "|   "
echo "|   deploye date on $ADATETIME				"
echo "|				"
echo "|-    please type a  value ( 1 or 2 )                      "
echo "|-  1. patch to hk22                                       "
echo "|-  2. patch to Prod server								 "
echo "|-                                                         "
echo "|----------------------------------------------------------------|"
read -p  "value :" SERVERTYPE
clear

echo "PHP Patch Deployment on $ADATETIME start...."




PHPPATCH="$PATCH/$ADATETIME/PHP_patch/patch*.tar.bz2"
PHPPATH="$PATCH/$ADATETIME/PHP_patch"
if [ ! -d $LOGDIR ];then

  mkdir -p $LOGDIR
fi

#if [ -f $PHPPATCH ];then
#   if [ `ls -l $PHPPATCH | awk '{print $5}'` -lt 5000000 ]; then
     
	 GET_PUBINF_IP $SERVERTYPE
	 cd $PHPPATH
	 DTIME=`date +"%H%M"`
	 STR="############################################################"
	 WLOG $LOGDIR/system.log  "$STR"
	 printf "%s\n" "$STR"
	 if [ $SERVERTYPE != 1 ];then
		 STR="MOVE patch*.tar.bz2 To patch*.tar.bz2 ......"
		 printf "%s\n" $STR
		 WLOG $LOGDIR/system.log  "$STR"
		 mv patch-*.tar.bz2 patch$DATE.tar.bz2.bk
		 STR="Move patch-*.lst To  patch$DATE.lst.bk"
		 printf "%s\n" $STR
		 WLOG $LOGDIR/system.log  "$STR"
		 mv patch-*.lst patch$DATE.lst.bk
		 STR="############################################################"
		 WLOG $LOGDIR/system.log  "$STR"
		 printf "%s\n" "$STR"
    fi 
		 #echo "value is wrong  .............."
		 #exit 0;
 #  else
 #     STR="############################################################"
 #     WLOG $LOGDIR/system.log  "$STR"
 #     printf "%s\n" "$STR"
 #     STR="Abort : $PHPPATCH is larger than 5MB"
 #     printf "%s\n" $STR
 #     WLOG $LOGDIR/system.log  "$STR"
 #     STR="############################################################"
 #     WLOG $LOGDIR/system.log  "$STR"
 #     printf "%s\n" "$STR"
 #  fi
#else
#   STR="############################################################"
#   WLOG $LOGDIR/system.log  "$STR"
#   printf "%s\n" "$STR"
#   STR="Error : $PHPPATCH not found"   
#   printf "%s\n" $STR
#   WLOG $LOGDIR/system.log  "$STR"
#   STR="############################################################"
#   WLOG $LOGDIR/system.log  "$STR"
#   printf "%s\n" "$STR"
#fi
