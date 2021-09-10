#/bin/sh
###############################################
#
#
#
#    Created date 20110407
#    script by vincent.yu
#
#
##############################################
if [ ! -f  /opt/script/PUBLIC_LIB/INI.inf ] || [ ! -f /opt/script/PUBLIC_LIB/Funtion.ini ] || [ ! -f /opt/script/PUBLIC_LIB/Depoly_fun.inf ];then
  clear
  echo "<*************************************>"
  echo "< Please Check, Public variables!!!!!!!!>"
  echo "<                                       >"
  echo "< /opt/script/PUBLIC_LIB/INI.inf        >"
  echo "< /opt/script/PUBLIC_LIB/Funtion.ini    >"
  echo "< /opt/script/PUBLIC_LIB/Depoly_fun.inf >"
  echo "<***************************************>"
  exit 0;
else
  source /opt/script/PUBLIC_LIB/INI.inf
  source /opt/script/PUBLIC_LIB/Funtion.ini
  source /opt/script/PUBLIC_LIB/Depoly_fun.inf
fi
##############################################
PATH="/opt/Deploy_Beta/Deploy_Beta/"
##############################################
TODAY=`/bin/date +"%Y%m%d"`
##############################################
LOG="/tmp/CITYPAIR.log"
##############################################
TOMAIL="instant.msg@travelzen.com fergus.tang@travelzen.com"
##############################################
CHECK_FILE(){
 TYPE=$1
 if [ $TYPE = "beta" ];then
   PATH="/opt/Deploy_Beta/Deploy_Beta"
 else
   PATH="/opt/deploy" 
 fi
 if [ -s $PATH/$TODAY/CITYPAIR/www.com.hotelcity.$TODAY.tar.gz ];then
     /bin/cp $PATH/$TODAY/CITYPAIR/www.com.hotelcity.$TODAY.tar.gz /opt/vhost/
     /bin/echo "###### start  update hotel city ########################################" >> $LOG
     /bin/echo "cp $PATH/$TODAY/CITYPAIR/www.com.hotelcity.$TODAY.tar.gz /opt/vhost/" >>$LOG
     cd /opt/vhost/
     /bin/gzip -d www.com.hotelcity.$TODAY.tar.gz
     /bin/tar xf www.com.hotelcity.$TODAY.tar
     /bin/rm -rf www.com.hotelcity.$TODAY.tar
     /bin/echo "######### END update hotel city ########################################">> $LOG
 fi
 if [ -s $PATH/$TODAY/CITYPAIR/www.com.citypair.$TODAY.tar.gz ];then
      /bin/cp $PATH/$TODAY/CITYPAIR/www.com.citypair.$TODAY.tar.gz /opt/vhost/
      /bin/echo "######## start update city pair ####################################" >> $LOG
      cd /opt/vhost/
      /bin/gzip -d www.com.citypair.$TODAY.tar.gz
      /bin/tar xf www.com.citypair.$TODAY.tar
      /bin/rm -rf www.com.citypair.$TODAY.tar
      /bin/echo "######## END update city pair   ###################################" >> $LOG
 fi

}
DATE=`/bin/date +"%Y%m%d-%H%M"`
/bin/echo "" > $LOG
/bin/echo "|--------------   strat $DATE Citypair update -------------------------|" >> $LOG
if [ $SER_TYPE = "beta" ];then
  CHECK_FILE beta
elif [ $SER_TYPE = "prod" ];then  
  CHECK_FILE prod
fi
DATE=`/bin/date +"%Y%m%d-%H%M"`
/bin/echo "|-------------   END  $DATE  Citypair update -------------------------|" >> $LOG
/bin/mail -s "$LOCATION - $SITE -$SERVER running Citypair update" $TOMAIL < $LOG

