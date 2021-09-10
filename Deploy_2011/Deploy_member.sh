#!/bin/bash
################################################
#
#
#   careted date 20110303 
#   script by  Vincent Yu
#   Changed 20110316 by vincent.yu
#
################################################
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
################################################
BIN_FILE="member-web-*-binary.zip"

if [ $SER_TYPE = "prod" ];then
  DPATH="/opt/deploy/$DDDATE"
  if [ $SITE = "hk" ];then
    CON_FILE="member-web-*-hkprod-config.zip"
  elif [ $SITE = "sh" ];then
    CON_FILE="member-web-*-shprod-config.zip"
  fi
########## defind variables for beta ###########
elif [ $SER_TYPE = "beta" ];then
  DPATH="/opt/Deploy_Beta/Deploy_Beta/$DDDATE"
  CON_FILE="member-web-*-beta-config.zip"

######## defind variables for alpha ############
elif [ $SER_TYPE = "alpha" ];then
  DPATH="/opt/deploy/$DDDATE"
  CON_FILE="member-web-*-alpha-config.zip"
fi
#########################################
SERVICE_N="member"
ENV_NAME="JBOSS-MEMBER"
################################################
#    enable or disable check 
#    enable = 1   ;   disable = 0 
################################################
CHECK_ENABLE="0"
################################################
##  CHECK_SUM format  (1:enable  0:disable)
##    1        1       1
##  alpha    beta    prod
################################################
CHECK_SUM=110
#########################################
DATE=`date +"%Y%m%d"`
TIME=`date +"%H%M"`
################################################
########## main start ##########################
if [ ! -d $JBOSSHOME/$SERVICE_N ];then
  clear
  echo "|#######################################################|"
  echo "|     Not found out on the $JBOSSHOME/$SERVICE_N      "
  echo "|     Check Please!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  echo "|#######################################################|"
fi

read -p  "Deployment date :" DDDATE
echo "Deployment on $DDDATE start...."

if  [ ! -s $DPATH/$DDDATE/$ENV_NAME/$BIN_FILE ];then
  clear
  printf "%s\n" "************************************************************************"
  echo "or not found out $DPATH/$DDDATE/$ENV_NAME/$BIN_FILE"
  printf "%s\n" "*************************************************************************"
  exit 0;
else
  clear
  printf "%s\n" "Today server      information .........................................."
  printf "%s\n" "************************************************************************"
  printf "%s\n" "* Localtion     : $LOCATION "
  printf "%s\n" "* SITE          : $SITE "
  printf "%s\n" "* Deploy Server : $SERVER "
  printf "%s\n" "* Deploy Type   : $SER_TYPE "
  printf "%s\n" "************************************************************************"
  printf "%s\n" "* Deploy file information .............................................."
  ls -la $DPATH/$DDDATE/$ENV_NAME/$BIN_FILE
  printf "%s\n" "*************************************************************************"
  read -p  "Press a key to start backup the old $SERVICE_N and copy new file .... " YNANS1
  ###########
  clear
  printf "%s\n" "********    JBOSS stop ................................................."
  printf "%s\n" "************************************************************************"
  F_STOP_JBOSS $SERVICE_N 
  ###########
  printf "%s\n" "********    JBOSS Backup        ........................................"
  printf "%s\n" "************************************************************************"
  BACKUP_SERVICE $SERVICE_N
  CLEAN_FILE $SERVICE_N
  sleep 5
  ##### remove old version file  & copy new version to Jboss service ######
  if [ -s $DPATH/$DDDATE/$ENV_NAME/$BIN_FILE ];then
     rm -rf $JBOSSHOME/$SERVICE_N/$BIN_FILE
     cp $DPATH/$DDDATE/$ENV_NAME/$BIN_FILE $JBOSSHOME/$SERVICE_N/
  fi
  if [ -s $DPATH/$DDDATE/$ENV_NAME/$CON_FILE ];then
     rm -rf $JBOSSHOME/$SERVICE_N/$CON_FILE
     cp $DPATH/$DDDATE/$ENV_NAME/$CON_FILE $JBOSSHOME/$SERVICE_N/
  fi
  ######## clear old file & unzip new version file ############
  ########   F_DEPOLY format
  ########   SITE = HK SH TW BJ
  ########   SERVICE_N = exp event-inventory ,creme-admin
  ########   SER_TYPE = prod,beta,alpha

  F_DEPOLY $SITE $SERVICE_N $SER_TYPE 
  ###### start jboss service
  read -p  "Press a key to start jboss and check stdout .... " YNANS2    
  clear
  F_START_JBOSS $SERVICE_N
  sleep 5
fi


