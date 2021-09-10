#/bin/bash
###############################################
#
#
#      Created date:20120608
#      script by vincent yu
#
#
#   20120824 updated copy 2 .inc file
#  www.com/include/ReleaseVersion.inc
#  www.com/php/ReleaseVersion.inc
##############################################
. /opt/SYS_script/PUBLIC_LIB/Funtion.ini
TODAY=`/bin/date +"%Y%m%d"`
FPATH="/opt/deploy"
SYS_CONF="/opt/SYS_script/PUBLIC_LIB/Sync_config"
TYPE="beta prod"
TMP_PATH="/tmp/CITYPAIR_UPADTE"
##############################################
TOMAIL="instant.msg@travelzen.com lucien.chan@travelzen.com"
##############################################
CHECK_FILE(){
 cd $NPATH
 unalias cp
 if [ -s $FPATH/$TODAY/CITYPAIR/www.com.hotelcity.*.tar.gz ];then
     WLOG $LOG "|------------------------------------------------------------------------------------------------|"
     cp $FPATH/$TODAY/CITYPAIR/www.com.hotelcity.*.tar.gz $NPATH/
     WLOG $LOG "copy $FPATH/$TODAY/CITYPAIR/www.com.hotelcity.*.tar.gz to  $NPATH"
     WLOG $LOG "unzip $FPATH/$TODAY/CITYPAIR/www.com.hotelcity.*.tar.gz"
     tar zxvf www.com.hotelcity.*.tar.gz
     WLOG $LOG "unzip hotel date done ........."
     cd $NPATH/www.com/js/hotel/
     LIST=`ls *.js`
     for i in $LIST
     do
       cp $NPATH/www.com/js/hotel/$i /opt/vhost/www.com/js/hotel/
       WLOG $LOG "copyed $i file to /opt/vhost/www.com/js/hotel/ [ OK ] ........."
     done
	 cp $NPATH/www.com/include/ReleaseVersion.inc  /opt/vhost/www.com/include/
	 WLOG $LOG "copyed ReleaseVersion.inc  file to /opt/vhost/www.com/include/ [ OK ] ........."
	 cp $NPATH/www.com/php/ReleaseVersion.inc  /opt/vhost/www.com/php/
	 WLOG $LOG "copyed ReleaseVersion.inc  file to /opt/vhost/www.com/php/ [ OK ] ........."
 fi
 if [ -s $FPATH/$TODAY/CITYPAIR/www.com.citypair.*.tar.gz ];then
      cd $NPATH
      WLOG $LOG "|------------------------------------------------------------------------------------------------|"
      cp $FPATH/$TODAY/CITYPAIR/www.com.citypair.*.tar.gz $NPATH/
      WLOG $LOG "copy $FPATH/$TODAY/CITYPAIR/www.com.citypair.*.tar.gz to  $NPATH"
      WLOG $LOG "unzip $FPATH/$TODAY/CITYPAIR/www.com.citypair.*.tar.gz"
      tar zxvf www.com.citypair.*.tar.gz
      WLOG $LOG "unzip  city pair done ........."
      cd $NPATH/www.com/js/
      LIST=`ls *.js`
      for i in $LIST
      do
        cp $NPATH/www.com/js/$i /opt/vhost/www.com/js/
        WLOG $LOG "copyed $i file to /opt/vhost/www.com/js/ [ OK ] ........."
      done
	  cp $NPATH/www.com/include/ReleaseVersion.inc  /opt/vhost/www.com/include/
	  WLOG $LOG "copyed ReleaseVersion.inc  file to /opt/vhost/www.com/include/ [ OK ] ........."
	  cp $NPATH/www.com/php/ReleaseVersion.inc  /opt/vhost//www.com/php/
	  WLOG $LOG "copyed ReleaseVersion.inc  file to /opt/vhost/www.com/php/ [ OK ] ........."
 fi
 WLOG $LOG "|-----------------------------------------------------------------------------------------------------|"
}
DATE=`/bin/date +"%Y%m%d"`

UDATE=$1


if [ ! -d $TMP_PATH/$UDATE ];then
 mkdir -p $TMP_PATH/$UDATE
fi
NPATH=$TMP_PATH/$UDATE
LOG=$TMP_PATH/$UDATE/$DATE.log
CHECK_FILE







#echo "|-------------   END  $DATE  Citypair update -------------------------|" >> $LOG
mail -s "$HOSTNAME running Citypair update" $TOMAIL < $LOG

