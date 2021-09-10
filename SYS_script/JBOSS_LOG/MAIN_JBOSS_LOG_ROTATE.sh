#!/bin/sh
##############################
#
#
#2010/11/4  script by vincent yu
#
#
##############################




#####
DATE=`date +%Y%m%d%H%M`
WEEK=`date +%a`


##### include define setting & function  ###################
source /opt/script/PUBLIC_LIB/INI.inf
source /opt/script/JBOSS_LOG/SUB/ROTATE_LOG.sh
source /opt/script/JBOSS_LOG/SUB/CLEAN_JBOSS_SERVER_LOG.sh



##### main start ################

  for LIST  in $SERVERLIST
  do
    if [ -d $JBOSSHOME/$LIST ];then
      F_ROTATE_LOG $LIST
      echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      echo $LIST
      F_CLEAN_JBOSS_SERVER_LOG $LIST
    fi
  done
