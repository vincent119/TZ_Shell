#!/bin/sh
############################################
#
#
#    script by vincent.yu
#    created date 20120229
#
#
############################################
. /opt/SYS_script/PUBLIC_LIB/Funtion.ini
RSYNC=`which rsync`
DATE=`date +%Y%m%d-%H%M`
IMAGES_PATH=UI/Prod_images/
IMAGES_MOUNT=/tmp/bravo
FILESERVER=//192.168.9.11/Shares
LOGDIR=/tmp/rsync.$DATE.log



mount_disk(){
    
  #### Mount the share directory with the image files
  [ ! -d /tmp/bravo ] && mkdir -p /tmp/bravo
  # mount.cifs //192.168.9.11/Shares/UI/Prod_images /tmp/bravo -o username='imagesync'  ,password='Tz.Abc123!'
  mount.cifs $FILESERVER $IMAGES_MOUNT -o username='imagesync',password='Tz.Abc123!'

}
GET_PUBINF_IP(){
 DPATH="/opt/SYS_script/PUBLIC_LIB/CONFIG"
 
 SERNAME=`cat /opt/SYS_script/PUBLIC_LIB/Sync_config/WEBPHP.inf` 
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
  DEST=$1
  LOC=$2
  SENAME=$3     
  IDCN=$4
  STR="================================================================="
  printf "%s\n" "$STR"
  WLOG $LOGDIR/$SENAME.log  "$STR"
  STR="SYNC to $LOC $IDCN $SENAME IP is $DEST"
  printf "%s\n" "$STR"
  WLOG $LOGDIR/$SENAME.log  "$STR"
  STR="================================================================="
  printf "%s\n" "$STR"
  WLOG $LOGDIR/$SENAME.log  "$STR"
  $RSYNC -vrzta --progress --delete $IMAGES_MOUNT/$IMAGES_PATH -e ssh root@$DEST:/opt/vhost/images.com/  >>  $LOGDIR/$SENAME.log 2>&1
  if [ $CLEAN_CACHE -eq 1 ];then
    ssh root@$DEST "/etc/rc.d/init.d/memcached restart" 
  fi

}
PER=$1
if [ $HOSTNAME  = "pre-prod" ];then
   if [ ${#PER} -eq 0 ];then
      CLEAN_CACHE=0 
   else 
      CLEAN_CACHE=1
   fi 
   if [ ! -d $LOGDIR ];then
        mkdir -p $LOGDIR
    fi
   mount_disk
   GET_PUBINF_IP
   cd /
   umount $IMAGES_MOUNT 


else
    clear
    printf "%s\n" "#####################################################"
    printf "%s\n" "#"
    printf "%s\n" "    script only running  >> pre-prod <<"
    printf "%s\n" "#"
    printf "%s\n" "######################################################"

fi
