#!/bin/bash
####################################################################################
#
#
#      Script by Vincent yu
#      Created Date 20120503
#
#
####################################################################################
# Backup variables
BAKDIR=/opt/mnt_backup
BAK_ETC=/etc
BAK_HOME=/home
BAK_OPT=/opt/app
BAK_APP="jboss-4.2.3.GA openfire httpd-2.2.15-fastcgi httpd-2.2.15"
BAK_OPTLOG=/opt/logs/archives
# Global variables/
DATE=`date +%Y%m%d`
# Backup
## for sunday
BACKUP1(){
        cd $BAK_ETC
        tar zcf etc.$DATE.tar . --exclude "*.tar" 
        mv etc.$DATE.tar $BAKDIR/$HOSTNAME/SYSTEM_Backup/$DATE/

        cd $BAK_HOME
        tar zcf home.$DATE.tar .  --exclude "*.tar" 
        mv  home.$DATE.tar $BAKDIR/$HOSTNAME/SYSTEM_Backup/$DATE/

        cd $BAK_OPT
        for X in $BAK_APP
        do
          if [ -d $BAK_OPT/$X ];then
                  tar zcf $X.$DATE.tar ./$X  --exclude "*.tar" 
                  mv $X.$DATE.tar  $BAKDIR/$HOSTNAME/SYSTEM_Backup/$DATE/
          fi          
        done
}
## for 1-6
BACKUP2(){
		INF_CONFIG=`find /opt/SYS_script/PUBLIC_LIB/CONFIG/ -name $HOSTNAME.inf`
		if [ ${#INF_CONFIG}  -ne 0 ];then
			ARC_BACKUP=`cat  $INF_CONFIG |sed '/^#/d'|grep ^BACKUP_ARCHIVE_LOG|awk -F\= '{print toupper($2)}'`
			if [ $ARC_BACKUP = "Y" ] && [ ${#ARC_BACKUP} -gt 0 ];then
				ARC_LIST=`cat $INF_CONFIG |sed '/^#/d'|grep ^JSERVICE|awk -F\= '{print $2}'`
				unalias  cp
				for ZZ in $ARC_LIST
				do
				  cd $BAK_OPTLOG/$ZZ
				  if [ ! -d $BAKDIR/$HOSTNAME/archives/$ZZ/ ];then
				     mkdir -p $BAKDIR/$HOSTNAME/archives/$ZZ
				  fi
				  for (( JJ=1;JJ <=6;JJ++ ));
					do
					 DATE2=`date  +"%Y-%m-%d" -d  "$JJ day ago"`
					 cp *$DATE2* $BAKDIR/$HOSTNAME/archives/$ZZ/
					done
				done
				
			fi
		fi
}
if [ ! -d $BAKDIR ];then
 mkdir -p $BAKDIR 
fi

COUNT=`df -k |grep mnt_backup |wc -l`
if [ $COUNT -eq 0 ];then
   mount -t nfs 192.168.103.239:/volume1/linux_backup /opt/mnt_backup
fi

COUNT=`df -k | grep mnt_ |awk '{print $1}'`
if [  $COUNT -ge 3836426752  ];then
  if [ ! -d $BAKDIR/$HOSTNAME/SYSTEM_Backup/$DATE ];then
     mkdir -p $BAKDIR/$HOSTNAME/SYSTEM_Backup/$DATE
  fi
  DAY=`date +"%u"`
  if [ $DAY = "7" ];then
    BACKUP1
    BACKUP2
  else
    BACKUP2
  fi 
fi
COUNT=`df -k |grep mnt_backup |wc -l`
if [ $COUNT -eq 1 ];then
   umount /opt/mnt_backup
fi
