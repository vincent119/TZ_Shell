#!/bin/sh
############################################
#
#
#    script by vincent.yu
#    created date 20120102
#    changed to 20120223
#
############################################
. /opt/SYS_script/PUBLIC_LIB/Funtion.ini
VER_FILE="superagent.com.version.txt"
F_JSERVICE(){
   if [  JSERVICE = 1 ];then
     echo "aa"
   else
     clear
     printf "%-80s\n" "******************************************************************************"
     printf "%-80s\n" "*********       Deploy PHP or Rollback PHP ..............................!!!!*"
     printf "%-80s\n" "*(1).Deploy SUPERAGENT PHP.................... .........................................*"
     printf "%-80s\n" "*(2).Rollback SUPERAGENT PHP............................................................*"
     printf "%-80s\n" "*(3).Exit....................................................................*"
     printf "%-80s\n" "*                                                                            *"
     printf "%-80s\n" "******************************************************************************"
     printf "%-80s\n" "******************************************************************************"
     read -p "Please type one number [1,2,3 or 4..........7 ] or Ctrl + C Skip it  !!! : " SERVICE
     F_CHECK_SERVICE
   fi
}

F_CHECK_SERVICE(){
   LOGPATH="/opt/script/web"
   case "$SERVICE" in
   1) #Deploy PHP
     if [ ! -d $LOGPATH ];then
       mkdir -p $LOGPATH
     fi
     LOG="$LOGPATH/DEPLOY_SUPERAGENT.PHP.`date +"%Y%m%d-%H%M"`.log"
     echo "" > $LOG
     printf "%-80s\n" "******************************************************************************" >>$LOG
     printf "%-80s\n" "*                                                                            *" >>$LOG
     printf "%-80s\n" "Start Deployment SUPERAGENT  PHP on `date +"%Y%m%d-%H:%M:%S"`" >> $LOG
     printf "%-80s\n" "*                                                                            *" >>$LOG
     printf "%-80s\n" "******************************************************************************" >>$LOG
     USER=`who am i`
     echo $USER >>$LOG
     F_DEPLOY_PHP
     ;;
   2) #Rollback PHP
      if [ ! -d $LOGPATH ];then
        mkdir -p $LOGPATH
      fi
      LOG="$LOGPATH/ROLLBACK_SUPERAGENT.PHP.`date +"%Y%m%d-%H%M"`.log"
      echo "" > $LOG
      printf "%-80s\n" "******************************************************************************" >>$LOG
      printf "%-80s\n" "*                                                                            *" >>$LOG
      printf "%-80s\n" "Start Rollback SUPERAGENT PHP on `date +"%Y%m%d-%H:%M:%S"`" >> $LOG
      printf "%-80s\n" "*                                                                            *" >>$LOG
      printf "%-80s\n" "******************************************************************************" >>$LOG
      USER=`who am i`
      echo $USER >>$LOG
      F_SHOW_ROLLBACKLIST
     ;;
   3)
    exit 0 ;;
   *)
     JSERVICE=0
     F_JSERVICE;;
   esac
}
F_DATECHECK()
{
  date -d $1 &> /dev/null
  if [ $? -eq 0 ];then
   F_DATECHECK=1 
  else
   clear
   read -p "Please type in Date format YYYYMMDD or Ctrl + C Skip it!!! : " DATE
   F_DATECHECK $DATE
  fi
}
F_RESTART_MEMCACHE(){
  if [ $RESTARTMEM = "Y" ];then
        service memcached restart
  fi
}
F_DEPLOY_SPECIAL(){
  SDIR="/opt/vhost/superagent.com"
  cd $SDIR
  mkdir sessions
  chmod 777 sessions
  chmod 777 sessions_verify
  mkdir templates_c
  chmod 777 templates_c
  chmod 777 logs
  cp -pR /opt/vhost/www.com/cgi-bin .  
  sed -i 's/php-5.2.14/php-5.2.14-soap/' $SDIR/cgi-bin/php.fcgi
  sed -i  's/192.168.9.127/192.168.103.212/' $SDIR/classes/SingletonHttpClient.class.php 
  sed -i 's/192\.168\.9\.[0-9][0-9][0-9]/192\.168\.103\.212/' $SDIR/config.inc 
  if [ -f $PHP_FILE/$DATE/PHP/imagecapture-*-SNAPSHOT-*.zip ];then
    cp $PHP_FILE/$DATE/PHP/imagecapture-*-SNAPSHOT-*.zip .
    if [ ! -d /var/backup/superagent ];then
      mkdir -p /var/backup/superagent
    fi
    rm -rf /var/backup/superagent/imagecapture-*-SNAPSHOT-*.zip
    cp $PHP_FILE/$DATE/PHP/imagecapture-*-SNAPSHOT-*.zip /var/backup/superagent/
  else
    cp  /var/backup/superagent/imagecapture-*-SNAPSHOT-*.zip .
  fi
  if [ -f superagent-im-*-SNAPSHOT.zip ];then
    cp $PHP_FILE/$DATE/PHP/superagent-im-*-SNAPSHOT.zip .
    if [ ! -d /var/backup/superagent ];then
      mkdir -p /var/backup/superagent
    fi
    rm -rf /var/backup/superagent/superagent-im-*-SNAPSHOT.zip
    cp $PHP_FILE/$DATE/PHP/superagent-im-*-SNAPSHOT.zip  /var/backup/superagent/
  else
    cp /var/backup/superagent/superagent-im-*-SNAPSHOT.zip .
  fi
  unzip -q imagecapture-*-SNAPSHOT-*.zip 
  unzip -q superagent-im-*-SNAPSHOT.zip
  rm -rf templates_c/*
  
}
F_DEPLOY_PHP(){
  F_DATECHECK
  if [ -f $PHP_FILE/$DATE/PHP/superagentphp*.tar.gz ];then
    cp $PHP_FILE/$DATE/PHP/superagentphp*.tar.gz  $PHP_PATH
    printf "%-80s\n" "copy Superagent  PHP file to $PHP_PATH"
    cd $PHP_PATH
    F_DEL_ADD_LINK DEPLOY
    F_DEPLOY_SPECIAL
    
    #F_RESTART_MEMCACHE
    F_CLAEN_PHP_FILE
    SHOW_INFO DEPLOYMENT
  else
    clear
    printf "%-100s\n" "******************************************************************************"
    printf "%-100s\n" "********************           Error Message       ***************************"
    printf "%-100s\n" "*                                                                            *"
    printf "%-100s\n" "*  can not found out $PHP_FILE/$DATE/PHP/superagentphp$DATE.tar.gz !!!!!       *"
    printf "%-100s\n" "*  check Please file name !!                                                 *"
    printf "%-100s\n" "*                                                                            *"
    printf "%-100s\n" "******************************************************************************" 
    exit 0;
  fi
}
F_CLAEN_PHP_FILE(){
  cd /opt/vhost
  PLIST=`ls  |awk '/superagent\.com\.[0-9][0-9]$/ {print $1}'|awk -F\. '{print $3}' |sort -r`
  COUNT=1
  for q in $PLIST
  do
    if [ $COUNT -gt $PHP_KEEP ];then
      rm -rf superagent.com.$q 
    fi
  COUNT=`echo $COUNT +1|bc`
done


}
F_DEL_ADD_LINK(){ 
   STATUS=$1 
   ROLLBACK_VER=$2
   cd $PHP_PATH
   if [ $STATUS = "DEPLOY" ];then
     printf "%-80s\n" "unzip PHP File.........."
     OVERDATE=`cat $PHP_PATH/$VER_FILE |sed '/^#/d'|grep -n  "^web.build.date"|cut -d = -f 2`
     printf "%-80s\n" "|---------------------------------------------------------------------|" >>$LOG
     printf "%-80s\n" "|---------------- Last version date is $OVERDATE      ----------------|" >>$LOG
     printf "%-80s\n" "|---------------------------------------------------------------------|" >>$LOG
     VER=`cat $PHP_PATH/$VER_FILE |sed '/^#/d' |grep -n "^web.version"|cut -d = -f 2`
     printf "%-80s\n" "|---------------------------------------------------------------------|" >>$LOG
     printf "%-80s\n" "|---------------- Last version is $VER           ---------------------|" >>$LOG
     printf "%-80s\n" "|---------------------------------------------------------------------|" >>$LOG

     #tar zxf php*.tar.gz
     /opt/SYS_script/PUBLIC_LIB/bar  superagentphp*.tar.gz |tar zxf -
     LINKDATE=`ls -la |awk '/superagent\.com\.[0-9][0-9][0-9][0-9][0-9][0-9]+$/ {print $11}'|awk -F\. '{print $3}'`
     OVERDATE=`cat $PHP_PATH/$VER_FILE |sed '/^#/d' |grep -n "^web.build.date"|cut -d = -f 2`
     VER=`cat $PHP_PATH/$VER_FILE |sed '/^#/d' |grep -n "^web.version"|cut -d = -f 2`
     printf "%-80s\n" "|---------------------------------------------------------------------|" >>$LOG
     printf "%-80s\n" "|---------------- Current version date is $OVERDATE  ----------------|" >>$LOG
     printf "%-80s\n" "|---------------------------------------------------------------------|" >>$LOG
     printf "%-80s\n" "|---------------------------------------------------------------------|" >>$LOG
     printf "%-80s\n" "|---------------- Current version is $VER       ---------------------|" >>$LOG
     printf "%-80s\n" "|---------------------------------------------------------------------|" >>$LOG
     
   elif [ $STATUS = "ROLLBACK" ];then
     LINKDATE=`ls -la |awk '/superagent\.com\.[0-9][0-9][0-9][0-9][0-9][0-9]+$/ {print $11}'|awk -F\. '{print $3}'`
     OVERDATE=`cat $PHP_PATH/$VER_FILE |sed '/^#/d' |grep -n "^web.build.date"|cut -d = -f 2`
     VER=`cat $PHP_PATH/$VER_FILE |sed '/^#/d' |grep -n "^web.version"|cut -d = -f 2`
     printf "%-80s\n" "|---------------------------------------------------------------------|" >>$LOG
     printf "%-80s\n" "|---------------- Last version date is $OVERDATE      ----------------|" >>$LOG
     printf "%-80s\n" "|---------------------------------------------------------------------|" >>$LOG
     printf "%-80s\n" "|---------------------------------------------------------------------|" >>$LOG
     printf "%-80s\n" "|---------------- Last version is $VER           ---------------------|" >>$LOG
     printf "%-80s\n" "|---------------------------------------------------------------------|" >>$LOG
     LINKDATE=`ls -la |awk '/superagent\.com\.[0-9][0-9][0-9][0-9][0-9][0-9]+$/ {print $11}'|awk -F\. '{print $3}'`
     OVERDATE=`cat $PHP_PATH/superagent.com.$ROLLBACK_VER/$VER_FILE |sed '/^#/d'|grep -n "^web.build.date"|cut -d = -f 2`
     VER=`cat $PHP_PATH/superagent.com.$ROLLBACK_VER/$VER_FILE |sed '/^#/d'|grep -n "^web.version"|cut -d = -f 2`
     rm -rf $PHP_PATH/$VER_FILE
     cp $PHP_PATH/superagent.com.$ROLLBACK_VER/$VER_FILE $PHP_PATH
     OVERDATE=`cat $PHP_PATH/$VER_FILE |sed '/^#/d'|grep -n "^web.build.date"|cut -d = -f 2`
     VER=`cat $PHP_PATH/$VER_FILE |sed '/^#/d' |grep -n "^web.version"|cut -d = -f 2`
     printf "%-80s\n" "|---------------------------------------------------------------------|" >>$LOG
     printf "%-80s\n" "|---------------- Current version date is $OVERDATE  ----------------|" >>$LOG
     printf "%-80s\n" "|---------------------------------------------------------------------|" >>$LOG
     printf "%-80s\n" "|---------------------------------------------------------------------|" >>$LOG
     printf "%-80s\n" "|---------------- Current version is $VER       ---------------------|" >>$LOG
     printf "%-80s\n" "|---------------------------------------------------------------------|" >>$LOG   
   fi
    if [ ${#LINKDATE} -ne 0 ];then
    	rm -rf $PHP_PATH/superagent.com.$LINKDATE
    
    fi
    rm -rf $PHP_PATH/superagent.com
    printf "%-80s\n" "***********************************************************************"
    ln -s superagent.com.$VER superagent.com.$OVERDATE
    printf "%-80s\n" "Created symbolic links superagent.com.$VER superagent.com.$OVERDATE"
    printf "%-80s\n" "***********************************************************************"
    cd $PHP_PATH
      i="superagent.com"
      printf "%-80s\n" "***********************************************************************"
      rm -f $PHP_PATH/$i
      printf "%-80s\n" "Remove symbolic links $PHP_PATH/$i"
      printf "%-80s\n" "***********************************************************************"
      ln -s  superagent.com.$OVERDATE $i
      printf "%-80s\n" "Created symbolic links superagent.com.$OVERDATE $i"
      printf "%-80s\n" "***********************************************************************"
    rm -f $PHP_PATH/superagentphp$DATE.tar.gz
    printf "%-80s\n" "***********************************************************************"
}
F_SHOW_ROLLBACKLIST(){
   cd $PHP_PATH
   RLIST=`ls  |awk '/superagent\.com\.[0-9][0-9]$/ {print $1}'|awk -F\. '{print $3}'`
   VER=`cat $PHP_PATH/$VER_FILE |sed '/^#/d'|grep -n "^web.version"|cut -d = -f 2`
   clear
   printf "%-80s\n" "***********************************************************************"
   printf "%-80s\n" "******************        Rollback List                  **************"
   for z in $RLIST
   do
     if [ $z = $VER ];then
      printf "%-80s\t%s\n" "$z <- ( is active now on version number )"
     else
      printf "%-80s\n" "$z"
     fi
   done
   printf "%-80s\n" "***********************************************************************"
   read -p "Please type Rollback PHP version number  or Ctrl + C Skip it  !!! : " ROLLVERSION
   F_ROLLBACK_PHP
}
F_ROLLBACK_PHP(){
 if [ ! -f $PHP_PATH/superagent.com.$ROLLVERSION/$VER_FILE ];then
    clear
    printf "%-80s\n" "******************************************************************************"
    printf "%-80s\n" "********************           Error Message       ***************************"
    printf "%-80s\n" "*                                                                            *"
    printf "%-80s\n" "*     can not found out $PHP_PATH/superagent.com.$ROLLVERSION/$VER_FILE  **"
    printf "%-80s\n" "*   Check please!!!    ......................			           *"
    printf "%-80s\n" "*                                                                            *"
    printf "%-80s\n" "******************************************************************************"
    exit 0;	
 fi 
 F_DEL_ADD_LINK ROLLBACK $ROLLVERSION
 F_RESTART_MEMCACHE   
 SHOW_INFO ROLLBACK
}
SHOW_INFO(){
  INFOSTATUS=$1
  INFO=`ls -al $PHP_PATH |awk '$1 ~/^lrwxrwxrwx/ &&  $11 ~/^superagent\.com/ {print $9 "->" $11}'`
  printf "%-80s\n"  ""
  printf "%-80s\n"  ""
  printf "%-80s\n" "|-------------------------------------------------------------------------------|"
  printf "%-80s\n" "|                                                                               |"
  printf "%-80s\n" "|                                                                               |"
  if [ $INFOSTATUS = "DEPLOYMENT" ];then
    printf "%-80s\n" "|                    Deployed PHP is finish                                     |"
    printf "%-80s\n" "|                                                                               |"
    printf "%-80s\n" "|                    show  Depolyment information"
    printf "%-80s\n" "|                                                                               |"
  else 
    printf "%-80s\n" "|                    Rollback is finish                                         |"
    printf "%-80s\n" "|                                                                               |"
    printf "%-80s\n" "|                    show  Rollback information"
    printf "%-80s\n" "|                                                                               |"
  fi
  printf "%-80s\n" "|                                                                               |"
  for cc in $INFO
  do
    printf "%-80s\n" "| $cc "							
    printf "%-80s\n" "|                                                                               |"
  done
  printf "%-80s\n" "|                                                                               |"
  printf "%-80s\n" "|                                                                               |"
  printf "%-80s\n" "|-------------------------------------------------------------------------------|"
}
###### Mian  start ##############
GET_HOST_CONIF
if [ $USE_PHP = "N" ];then
   printf "%-80s\n" "******************************************************************************"
   printf "%-80s\n" "********************           Error Message       ***************************"
   printf "%-80s\n" "*                                                                            *"
   printf "%-80s\n" "*   USE_PHP setting to N !!!!!                                               *"
   printf "%-80s\n" "*   Check Config Please........                                              *"
   printf "%-80s\n" "*                                                                            *"
   printf "%-80s\n" "******************************************************************************" 
 exit 0;
fi

if [ -d $PHP_PATH ];then
  F_JSERVICE
else
    printf "%-80s\n" "******************************************************************************"
    printf "%-80s\n" "********************           Error Message       ***************************"
    printf "%-80s\n" "*                                                                            *"
    printf "%-80s\n" "*   can not found out $PHP_PATH/vhost                                        *"
    printf "%-80s\n" "*   Check please!!!    ......................                                *"
    printf "%-80s\n" "*                                                                            *"
    printf "%-80s\n" "******************************************************************************"
  exit 0;
fi
