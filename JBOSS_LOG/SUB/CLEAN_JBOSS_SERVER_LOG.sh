#!/bin/bash
#####################################
#
#
#
#
#   2010/11/4  script by vincent yu   
#####################################
source /opt/script/PUBLIC_LIB/INI.inf
#####################################


F_CLEAN_JBOSS_SERVER_LOG(){
  DIR=$1
  cd $JBOSSHOME/$DIR/log/
  rm -rf server.log.????-??-??


}
