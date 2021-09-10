#/bin/sh
#########################################
#
#
#
#   script by vincent.yu
#   craeted date by 20101027 version 1.0
#   changed date by 20101216 version 2.0
#   changed by Alex Ch on 20110218
#   changed by Vincent Yu on 20110222
#   changed by Vincent yu on 20110307
#########################################
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
#########################################
#DATE=`date +"%Y%m%d"`
#TIME=`date +"%H%M"`
#########################################
##SERVICE_N="hotelcrs-ws-project"
ENV_NAME="JBOSS-TZ"
########### defind variables for prod ##########
if [ $SER_TYPE = "prod" ];then
  DPATH="/opt/deploy"
  BIZ_BIN_FILE="ota-web-service.war"
  WEB_BIN_FILE="Travelagent_*_PROD.ear"
  MEM_BIN_FILE="ota-member-webservice-*-binary.zip"
  if [ $SITE = "hk" ];then
     BIZ_CON_FILE="tz-jboss-env-*-hkprod-biz-config.zip"
     WEB_CON_FILE="tz-jboss-env-*-hkprod-web-config.zip"
     MEM_CON_FILE="ota-member-webservice-*-hkprod1-config.zip"
  elif [ $SITE = "sh" ];then
     BIZ_CON_FILE="tz-jboss-env-*-shprod-biz-config.zip"
     WEB_CON_FILE="tz-jboss-env-*-shprod-web-config.zip"
     MEM_CON_FILE="ota-member-webservice-*-shprod1-config.zip" 
  fi
########## defind variables for beta ###########
elif [ $SER_TYPE = "beta" ];then 
  DPATH="/opt/Deploy_Beta/Deploy_Beta"
  BIZ_BIN_FILE="ota-web-service.war"
  WEB_BIN_FILE="Travelagent_*_PROD.ear"
  BIZ_CON_FILE="tz-jboss-env-*-hkbeta-biz-config.zip"
  WEB_CON_FILE="tz-jboss-env-*-hkbeta-web-config.zip" 
  #WEB_CON_FILE="tz-jboss-env-*-SNAPSHOT-hkbeta-web-config.zip"
  MEM_BIN_FILE="ota-member-webservice-*-binary.zip"
  MEM_CON_FILE="ota-member-webservice-*-hkprod1-config.zip"
######## defind variables for alpha ############
elif [ $SER_TYPE = "alpha" ];then
  DPATH="/opt/deploy"
  BIZ_BIN_FILE="ota-web-service.war"
  WEB_BIN_FILE="Travelagent_*_DEV.ear"
  BIZ_CON_FILE="tz-jboss-env-*-alpha-biz-config.zip"
  WEB_CON_FILE="tz-jboss-env-*-alpha-web-config.zip" 
  MEM_BIN_FILE="ota-member-webservice-*-binary.zip"
  MEM_CON_FILE="ota-member-webservice-*-dev-config.zip"
fi
##########################################################################
F_DEPLOY_BIZ(){
  ######## copy new deploy file to jboss ##########
  if [ -s $DPATH/$DDDATE/$ENV_NAME/$BIZ_BIN_FILE ];then
    rm -rf  $JBOSSHOME/ota-biz/deploy/$BIZ_BIN_FILE
    cp -r $DPATH/$DDDATE/$ENV_NAME/$BIZ_BIN_FILE  $JBOSSHOME/ota-biz/deploy/
    ls -al $JBOSSHOME/ota-biz/deploy/$BIZ_BIN_FILE
  fi
  if [ -s $DPATH/$DDDATE/$ENV_NAME/$BIZ_CON_FILE ];then
    rm -rf $JBOSSHOME/ota-biz/$BIZ_CON_FILE
    cp -r $DPATH/$DDDATE/$ENV_NAME/$BIZ_CON_FILE $JBOSSHOME/ota-biz/
    ls -la $JBOSSHOME/ota-biz/$BIZ_CON_FILE
  fi
}
F_DEPLOY_WEB(){
  ######## copy new deploy file to jboss(ota-member-webservice) ##########
  if [ -s $DPATH/$DDDATE/$ENV_NAME/$WEB_BIN_FILE ];then
    rm -rf  $JBOSSHOME/ota-web/deploy/$WEB_BIN_FILE
    cp  $DPATH/$DDDATE/$ENV_NAME/$WEB_BIN_FILE $JBOSSHOME/ota-web/deploy/
    ls -al $JBOSSHOME/ota-web/deploy/$WEB_BIN_FILE
  fi
  if [ -s $DPATH/$DDDATE/$ENV_NAME/$WEB_CON_FILE ];then
    rm -rf $JBOSSHOME/ota-web/$WEB_CON_FILE
    cd $JBOSSHOME/ota-web/
    cp -r $DPATH/$DDDATE/$ENV_NAME/$WEB_CON_FILE .
    ls -la $JBOSSHOME/ota-web/$WEB_CON_FILE
  fi
  if [ -s $DPATH/$DDDATE/$ENV_NAME/$MEM_BIN_FILE ];then
    rm -rf $JBOSSHOME/ota-web/$MEM_BIN_FILE
    cp -r $DPATH/$DDDATE/$ENV_NAME/$MEM_BIN_FILE $JBOSSHOME/ota-web/
    ls -la $JBOSSHOME/ota-web/$MEM_BIN_FILE
  fi
  if [ -s $DPATH/$DDDATE/$ENV_NAME/$MEM_CON_FILE ];then
    rm -rf $JBOSSHOME/ota-web/$WEB_CON_FILE
    cp -r $DPATH/$DDDATE/$ENV_NAME/$MEM_CON_FILE $JBOSSHOME/ota-web/
    ls -la $JBOSSHOME/ota-web/$MEM_CON_FILE
  fi
}
F_DATECHECK()
{
  date -d $1 &> /dev/null
  if [ $? -eq 0 ];then
   F_DATECHECK=1 
  else
   read -p "Please type in Date format YYYYMMDD or Ctrl + C Skip it!!! : " DDDATE
   F_DATECHECK $DDDATE
  fi
}
F_JSERVICE(){
   
   if [  $JSERVICE -ne 1 ];then
     printf "%80s\n" "***************************************************************************"
     printf "%80s\n" "***************************************************************************"
     printf "%s\n" "Please type in Deploy service name or stop and start service............!!!!!"
     printf "%s\n" "(1).stop 3T service and deploy ALL .........................................."
     printf "%s\n" "(2).stop 3T service and deploy ota-biz......................................."
     printf "%s\n" "(3).stop 3T service and deploy ota-web......................................."
     printf "%s\n" "(4).strat 3T ................................................................"
     printf "%s\n" "(5).strat ora-biz ..........................................................."
     printf "%s\n" "(6).strat ota-web ..........................................................."
     printf "%80s\n" "***************************************************************************"
     printf "%80s\n" "***************************************************************************"
     read -p "Please type one number [1,2,3 or 4..........7 ] or Ctrl + C Skip it  !!! : " SERVICE
     F_CHECK_SERVICE
   fi

}
F_CHECK_SERVICE(){
   case "$SERVICE" in
   1)
     ## stop 3T & deploy ALL   ####### 
     JSERVICE=1
     F_DATECHECK
     F_MAIN
     #F_STOP_JBOSS $JBOSS
     F_STOP_JBOSS "ota-biz"
     F_STOP_JBOSS "ota-web"
     BACKUP_SERVICE ota-biz
     BACKUP_SERVICE ota-web
     CLEAN_FILE
     #######################
     F_DEPLOY_BIZ
     F_DEPLOY_WEB
     F_DEPOLY $LOCATION ota-biz  $SER_TYPE
     F_DEPOLY $LOCATION ota-web  $SER_TYPE
        ;;
   2)
     ##stop 3T service and deploy ota-biz#####
     JSERVICE=1
     F_DATECHECK
     F_MAIN
     F_STOP_JBOSS "ota-biz"
     BACKUP_SERVICE ota-biz
     CLEAN_FILE
     ##################
     F_DEPLOY_BIZ
     F_DEPOLY $LOCATION ota-biz  $SER_TYPE
        ;;
   3)
     ## stop 3T service and deploy ota-web################
     JSERVICE=1
     F_DATECHECK
     F_MAIN
     F_STOP_JBOSS "ota-web"
     BACKUP_SERVICE ota-web
     CLEAN_FILE
     ##########################     
     F_DEPLOY_WEB
     F_DEPOLY $LOCATION ota-web  $SER_TYPE
        ;;
   4)
    ### strat 3T  #####################
     JSERVICE=1
     F_START_JBOSS ota-biz 
     F_START_JBOSS ota-web
        ;;
   5)
    ## stop 3T service and deploy ota-biz
     JSERVICE=1
     F_START_JBOSS "ota-biz"
        ;;
   6)
     ## stop 3T service and deploy ota-web
     JSERVICE=1
     F_START_JBOSS "ota-web"
        ;;
   *)
     JSERVICE=0
     F_JSERVICE
        ;;
   esac
}
F_MAIN(){
     clear
     printf "%s\n" "Today Deploy file list ................................................."
     printf "%s\n" "************************************************************************"
     if [ -s $DPATH/$DDDATE/$ENV_NAME/$BIZ_BIN_FILE ];then
       ls -la $DPATH/$DDDATE/$ENV_NAME/$BIZ_BIN_FILE
     fi
     if [ -s $DPATH/$DDDATE/$ENV_NAME/$WEB_BIN_FILE ];then
       ls -la $DPATH/$DDDATE/$ENV_NAME/$WEB_BIN_FILE
     fi
     if [ -s $DPATH/$DDDATE/$ENV_NAME/$BIZ_CON_FILE ];then
       ls -la $DPATH/$DDDATE/$ENV_NAME/$BIZ_CON_FILE
     fi
     if [ -s $DPATH/$DDDATE/$ENV_NAME/$WEB_CON_FILE ];then
       ls -la $DPATH/$DDDATE/$ENV_NAME/$WEB_CON_FILE
     fi
     if [ -s $DPATH/$DDDATE/$ENV_NAME/$MEM_BIN_FILE ];then
       ls -la $DPATH/$DDDATE/$ENV_NAME/$MEM_BIN_FILE
     fi
     if [ -s $DPATH/$DDDATE/$ENV_NAME/$MEM_CON_FILE ];then
       ls -al $DPATH/$DDDATE/$ENV_NAME/$MEM_CON_FILE
     fi
     printf "%s\n" "*************************************************************************"
     read -p  "Press a key to start backup the TA and copy new file .... " YNANS1
}
#### main start
DATE=$1
SERVICE=$2
JSERVICE=0
F_JSERVICE $SERVICE
