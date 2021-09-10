#!/bin/bash
################################################
#
#
#   careted date 20110303 
#   script by  Vincent Yu
#   Changed 20110316 by vincent.yu
#   Changed 20110415 by Vincent.yu
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
if [ $SER_TYPE = "prod" ];then
  if [ $SITE = "hk" ];then
    DPATH="/opt/deploy/$DDDATE/JBOSS-PG/hkprod"
    BIN_FILE="payment-web-*-SNAPSHOT-hkprod.zip"
    ENV_FILE="payment-web-*-SNAPSHOT-hkprod-env.zip"
  elif [ $SITE = "sh" ];then
    DPATH="/opt/deploy/$DDDATE/JBOSS-PG/shprod"
    BIN_FILE="payment-web-*-SNAPSHOT-shprod.zip"
    ENV_FILE="payment-web-*-SNAPSHOT-shprod-env.zip"
  fi
########## defind variables for beta ###########
elif [ $SER_TYPE = "beta" ];then
  DPATH="/opt/Deploy_Beta/Deploy_Beta/$DDDATE"
  BIN_FILE="payment-web-*-beta.zip"

######## defind variables for alpha ############
elif [ $SER_TYPE = "alpha" ];then
  DPATH="/opt/deploy/$DDDATE"
  BIN_FILE="payment-web-*-alpha.zip"
fi
#########################################
SERVICE_N="payment"
ENV_NAME="JBOSS-PG"
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

if  [ ! -s $DPATH/$BIN_FILE ];then
  clear
  printf "%s\n" "************************************************************************"
  echo "or not found out $DPATH/$BIN_FILE"
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
  ls -la $DPATH/$BIN_FILE
  ls -la $DPATH/$ENV_FILE
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
  DEP_FLAG=0
  if [ -s $DPATH/$ENV_FILE ];then
     DEP_FLAG=`$DEP_FLAG + 1 |bc`
     rm -rf $JBOSSHOME/$SERVICE_N/$ENV_FILE
     cp $DPATH/$ENV_FILE $JBOSSHOME/$SERVICE_N/
  fi
  if [ -s $DPATH/$BIN_FILE ];then
     DEP_FLAG=`$DEP_FLAG + 3 |bc`
     rm -rf $JBOSSHOME/$SERVICE_N/$BIN_FILE
     cp $DPATH/$BIN_FILE $JBOSSHOME/$SERVICE_N/
  fi
  if [ -s $DPATH/deploy-payment.sh ];then
     rm -rf  $JBOSSHOME/$SERVICE_N/deploy-payment.sh
     cp $DPATH/deploy-payment.sh $JBOSSHOME/$SERVICE_N/
  fi 
  if [ -s $DPATH/deploy-payment.sh ];then
     rm -rf  $JBOSSHOME/$SERVICE_N/env_setup.sh 
     cp $DPATH/env_setup.sh $JBOSSHOME/$SERVICE_N/
  fi

  if [ -s $DPATH/assembly-env.xml ];then
     rm -rf  $JBOSSHOME/$SERVICE_N/assembly-env.xml
     cp $DPATH/assembly-env.xml $JBOSSHOME/$SERVICE_N/
  fi
  ######## clear old file & unzip new version file ############
  ########   F_DEPOLY format
  ########   SITE = HK SH TW BJ
  ########   SERVICE_N = exp event-inventory ,creme-admin
  ########   SER_TYPE = prod,beta,alpha
  ##
  ##F_DEPOLY $SITE $SERVICE_N $SER_TYPE 
  if [ $DEP_FLAG = "1" ];tehn
     $JBOSSHOME/$SERVICE_N/env_setup.sh
  elif [ $DEP_FLAG = "3" ];tehn
     $JBOSSHOME/$SERVICE_N/deploy-payment.sh
  elif [ $DEP_FLAG = "4" ];tehn
     $JBOSSHOME/$SERVICE_N/env_setup.sh
     $JBOSSHOME/$SERVICE_N/deploy-payment.sh
  fi
  ###### start jboss service
  read -p  "Press a key to start jboss and check stdout .... " YNANS2    
  clear
  F_START_JBOSS $SERVICE_N
  sleep 5
fi


You have new mail in /var/spool/mail/root
