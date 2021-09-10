#!/bin/sh
############################################
#
#
#    script by vincent.yu
#    created date 20111024
#    changed date 20120309
#    fix Repeat PHP file on /opt/vhost
#
############################################
. /opt/SYS_script/PUBLIC_LIB/Funtion.ini
F_JSERVICE(){
   if [  JSERVICE = 1 ];then
     echo "aa"
   else
     clear
     printf "%-80s\n" "******************************************************************************"
     printf "%-80s\n" "*********       Deploy PHP or Rollback PHP ..............................!!!!*"
     printf "%-80s\n" "*(1).Deploy PHP.................... .........................................*"
     printf "%-80s\n" "*(2).Rollback PHP............................................................*"
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
     LOG="$LOGPATH/DEPLOY_PHP.`date +"%Y%m%d-%H%M"`.log"
     echo "" > $LOG
     printf "%-80s\n" "******************************************************************************" >>$LOG
     printf "%-80s\n" "*                                                                            *" >>$LOG
     printf "%-80s\n" "Start Deployment PHP on `date +"%Y%m%d-%H:%M:%S"`" >> $LOG
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
      LOG="$LOGPATH/ROLLBACK_PHP.`date +"%Y%m%d-%H%M"`.log"
      echo "" > $LOG
      printf "%-80s\n" "******************************************************************************" >>$LOG
      printf "%-80s\n" "*                                                                            *" >>$LOG
      printf "%-80s\n" "Start Rollback PHP on `date +"%Y%m%d-%H:%M:%S"`" >> $LOG
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
F_DEPLOY_WEB01_PHP(){
   cp $PHP_FILE/$DATE/PHP/efphp*.tar.gz  /opt/vhost/
   cd /opt/vhost/
   #tar zxvf efphp*.tar.gz
   /opt/SYS_script/PUBLIC_LIB/bar  efphp*.tar.gz| tar zxf -
   rm -f /opt/vhost/ef.travelzen.com.cn
   ln -s  ef.com.$DATE ef.travelzen.com.cn
   rm -f  /opt/vhost/ef.travelzen.com.cn/templates/en/header.html
   rm -f  /opt/vhost/ef.travelzen.com.cn/templates/sc/header.html
   rm -f  /opt/vhost/ef.travelzen.com.cn/templates/tc/header.html
   cp -p /opt/vhost/ef.travelzen.com.cn/include/preferences/ef.travelzen.com.cn/en/expoefheader.html /opt/vhost/ef.travelzen.com.cn/templates/en/header.html
   cp -p /opt/vhost/ef.travelzen.com.cn/include/preferences/ef.travelzen.com.cn/sc/expoefheader.html /opt/vhost/ef.travelzen.com.cn/templates/sc/header.html
   cp -p /opt/vhost/ef.travelzen.com.cn/include/preferences/ef.travelzen.com.cn/tc/expoefheader.html /opt/vhost/ef.travelzen.com.cn/templates/tc/header.html
   rm -rf /tmp/templates_c_ef/*

   rm -rf efphp*.tar.gz


}
F_DEPLOY_PHP(){
  F_DATECHECK
  if [ -f $PHP_FILE/$DATE/PHP/php*.tar.gz ];then
    if [ -f $PHP_FILE/$DATE/PHP/efphp*.tar.gz ] && [ $HOSTNAME = "web01" ];then
        F_DEPLOY_WEB01_PHP
    fi
    if [ -f $PHP_PATH/php*.tar.gz ];then
      rm -rf $PHP_PATH/php*.tar.gz
    fi
	cd $PHP_PATH
	rm -rf *.gz
    cp $PHP_FILE/$DATE/PHP/php*.tar.gz  $PHP_PATH
    printf "%-80s\n" "copy PHP file to $PHP_PATH"
    cd $PHP_PATH
    F_DEL_ADD_LINK DEPLOY
    cp -p $PHP_PATH/www.com/specialdeals_hp_main.php $PHP_PATH/www.com/specialdeals_hp.php
    cp -p $PHP_PATH/www.com/concertindex_main.php    $PHP_PATH/www.com/concertindex.php
    cp -p $PHP_PATH/www.com/eventindex_main.php      $PHP_PATH/www.com/eventindex.php
    if [ $STANDALONE = "Y" ];then
     sed -i 's/<SessionManager>DB<\/SessionManager>/<!-- <SessionManager>DB<\/SessionManager> -->/g' $PHP_PATH/www.com/include/config/$XML_FILE
    fi
    mv $PHP_PATH/www.com/include/config/$XML_FILE $PHP_PATH/www.com/include/config/www.travelzen.com.xml
    cp $PHP_PATH/www.com/include/config/www.travelzen.com.xml     $PHP_PATH/www.com/php/xml-configs/ 
    
    F_RESTART_MEMCACHE
    F_CLAEN_PHP_FILE
    SHOW_INFO DEPLOYMENT
  else
    clear
    printf "%-100s\n" "******************************************************************************"
    printf "%-100s\n" "********************           Error Message       ***************************"
    printf "%-100s\n" "*                                                                            *"
    printf "%-100s\n" "*  can not found out $PHP_FILE/$DATE/PHP/php$DATE.tar.gz !!!!!       *"
    printf "%-100s\n" "*  check Please file name !!                                                 *"
    printf "%-100s\n" "*                                                                            *"
    printf "%-100s\n" "******************************************************************************" 
    exit 0;
  fi
}
F_CLAEN_PHP_FILE(){
  cd /opt/vhost
  PLIST=`ls  |awk '/www\.com\.[0-9][0-9][0-9][0-9][0-9]$/ {print $1}'|awk -F\. '{print $3}' |sort -r`
  COUNT=1
  for q in $PLIST
  do
    if [ $COUNT -gt $PHP_KEEP ];then
      rm -rf www.com.$q 
      echo www.com.$q
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
     OVERDATE=`cat $PHP_PATH/www.com.version.txt |grep -n  "^web.build.date"|cut -d = -f 2`
     printf "%-80s\n" "|---------------------------------------------------------------------|" >>$LOG
     printf "%-80s\n" "|---------------- Last version date is $OVERDATE      ----------------|" >>$LOG
     printf "%-80s\n" "|---------------------------------------------------------------------|" >>$LOG
     VER=`cat $PHP_PATH/www.com.version.txt |grep -n "^web.version"|cut -d = -f 2`
     printf "%-80s\n" "|---------------------------------------------------------------------|" >>$LOG
     printf "%-80s\n" "|---------------- Last version is $VER           ---------------------|" >>$LOG
     printf "%-80s\n" "|---------------------------------------------------------------------|" >>$LOG

     #tar zxf php*.tar.gz
     /opt/SYS_script/PUBLIC_LIB/bar  php*.tar.gz |tar zxf -
     LINKDATE=`ls -la |awk '/www\.com\.[0-9][0-9][0-9][0-9][0-9][0-9]+$/ {print $11}'|awk -F\. '{print $3}'`
     OVERDATE=`cat $PHP_PATH/www.com.version.txt |grep -n "^web.build.date"|cut -d = -f 2`
     VER=`cat $PHP_PATH/www.com.version.txt |grep -n "^web.version"|cut -d = -f 2`
     printf "%-80s\n" "|---------------------------------------------------------------------|" >>$LOG
     printf "%-80s\n" "|---------------- Current version date is $OVERDATE  ----------------|" >>$LOG
     printf "%-80s\n" "|---------------------------------------------------------------------|" >>$LOG
     printf "%-80s\n" "|---------------------------------------------------------------------|" >>$LOG
     printf "%-80s\n" "|---------------- Current version is $VER       ---------------------|" >>$LOG
     printf "%-80s\n" "|---------------------------------------------------------------------|" >>$LOG
     
   elif [ $STATUS = "ROLLBACK" ];then
     LINKDATE=`ls -la |awk '/www\.com\.[0-9][0-9][0-9][0-9][0-9][0-9]+$/ {print $11}'|awk -F\. '{print $3}'`
     OVERDATE=`cat $PHP_PATH/www.com.version.txt |grep -n "^web.build.date"|cut -d = -f 2`
     VER=`cat $PHP_PATH/www.com.version.txt |grep -n "^web.version"|cut -d = -f 2`
     printf "%-80s\n" "|---------------------------------------------------------------------|" >>$LOG
     printf "%-80s\n" "|---------------- Last version date is $OVERDATE      ----------------|" >>$LOG
     printf "%-80s\n" "|---------------------------------------------------------------------|" >>$LOG
     printf "%-80s\n" "|---------------------------------------------------------------------|" >>$LOG
     printf "%-80s\n" "|---------------- Last version is $VER           ---------------------|" >>$LOG
     printf "%-80s\n" "|---------------------------------------------------------------------|" >>$LOG
     LINKDATE=`ls -la |awk '/www\.com\.[0-9][0-9][0-9][0-9][0-9][0-9]+$/ {print $11}'|awk -F\. '{print $3}'`
     OVERDATE=`cat $PHP_PATH/www.com.$ROLLBACK_VER/www.com.version.txt |grep -n "^web.build.date"|cut -d = -f 2`
     VER=`cat $PHP_PATH/www.com.$ROLLBACK_VER/www.com.version.txt |grep -n "^web.version"|cut -d = -f 2`
     rm -rf $PHP_PATH/www.com.version.txt
     cp $PHP_PATH/www.com.$ROLLBACK_VER/www.com.version.txt $PHP_PATH
     OVERDATE=`cat $PHP_PATH/www.com.version.txt |grep -n "^web.build.date"|cut -d = -f 2`
     VER=`cat $PHP_PATH/www.com.version.txt |grep -n "^web.version"|cut -d = -f 2`
     printf "%-80s\n" "|---------------------------------------------------------------------|" >>$LOG
     printf "%-80s\n" "|---------------- Current version date is $OVERDATE  ----------------|" >>$LOG
     printf "%-80s\n" "|---------------------------------------------------------------------|" >>$LOG
     printf "%-80s\n" "|---------------------------------------------------------------------|" >>$LOG
     printf "%-80s\n" "|---------------- Current version is $VER       ---------------------|" >>$LOG
     printf "%-80s\n" "|---------------------------------------------------------------------|" >>$LOG   
   fi
    if [ ${#LINKDATE} -ne 0 ];then
    	rm -rf $PHP_PATH/www.com.$LINKDATE
    
    fi
    rm -rf $PHP_PATH/www.com
    printf "%-80s\n" "***********************************************************************"
    ln -s www.com.$VER www.com.$OVERDATE
    printf "%-80s\n" "Created symbolic links www.com.$VER www.com.$OVERDATE"
    printf "%-80s\n" "***********************************************************************"
    rm -rf edm
    printf "%-80s\n" "***********************************************************************"
    ln -s $PHP_PATH/$IMG_PATH/edm edm
    printf "%-80s\n" "Created symbolic links $PHP_PATH/$IMG_PATH/edm edm"
    printf "%-80s\n" "***********************************************************************"
    cd $PHP_PATH
    for i in $PHP_LIST
    do
      printf "%-80s\n" "***********************************************************************"
      rm -f $PHP_PATH/$i
      printf "%-80s\n" "Remove symbolic links $PHP_PATH/$i"
      printf "%-80s\n" "***********************************************************************"
      ln -s  www.com.$OVERDATE $i
      printf "%-80s\n" "Created symbolic links www.com.$OVERDATE $i"
      printf "%-80s\n" "***********************************************************************"
    done
    rm -f $PHP_PATH/php$DATE.tar.gz
    printf "%-80s\n" "***********************************************************************"
    printf "%-80s\n" "Remove PHP Cache......................................................."
    TMPFILE=`ls -d /tmp/templates*`
    for x in $TMPFILE
    do
      rm -rf $x/*
      printf "%-80s\n" "Remove PHP Cache $x now ............................................."
    done
    printf "%-80s\n" "Remove PHP Cache completed..............................................."
    printf "%-80s\n" "***********************************************************************"
    chown -R daemon:daemon /opt/vhost/www.com/cache
    cd  /opt/vhost/www.com/imageserver
    ln -s  /opt/vhost/images.com/images images
}
F_SHOW_ROLLBACKLIST(){
   cd $PHP_PATH
   RLIST=`ls  |awk '/www\.com\.[0-9][0-9][0-9][0-9][0-9]$/ {print $1}'|awk -F\. '{print $3}'`
   VER=`cat $PHP_PATH/www.com.version.txt |grep -n "^web.version"|cut -d = -f 2`
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
 if [ ! -f $PHP_PATH/www.com.$ROLLVERSION/www.com.version.txt ];then
    clear
    printf "%-80s\n" "******************************************************************************"
    printf "%-80s\n" "********************           Error Message       ***************************"
    printf "%-80s\n" "*                                                                            *"
    printf "%-80s\n" "*     can not found out $PHP_PATH/www.com.$ROLLVERSION/www.com.version.txt  **"
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
  INFO=`ls -al $PHP_PATH |awk '$1 ~/^lrwxrwxrwx/ {print $9 "->" $11}'`
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
