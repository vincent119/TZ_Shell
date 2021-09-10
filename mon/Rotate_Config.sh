#!/bin/bash
########################################
#
#   script by vincent.yu
#   created date to 20101214
#
#
#
#########################################
MAILLIST="instant.msg@travelzen.com"
#########################################
TODATE=`date +'%Y%m%d'`
TODATE_S=`date +%s`
##########################################
EXPIRE_DAY="3"
##########################################
#### EXPIRE_TYPE = year,month,week,days ##
EXPIRE_TYPE="days"
##########################################
EXPIRE_DATE=`date -d "$TODATE $EXPIRE_DAY $EXPIRE_TYPE ago" +"%Y%m%d"`
EXPIRE_DATE_S=`date -d $EXPIRE_DATE +%s`
##########################################
BK_DIR="/opt/BK_CONFIG"
DIR_LIST=`ls $BK_DIR`
##########################################
LOG=/tmp/rotate_backup
##########################################
###   funtcion      ######################
F_DTAE_CHECK(){
  FFORSUBLIST=$1
  FSUBDATE=$2
  RESULTS=`echo "(( $FSUBDATE - $EXPIRE_DATE_S ) / (3060*24))" | bc`
  if [ $RESULTS -lt 0 ];then
    printf "%s\n" "remove $BK_DIR/$FFORSUBLIST"  >>$LOG
    rm -rf $BK_DIR/$FFORSUBLIST  >>$LOG

  fi
}
F_CREATE_DIR(){

  FDIR_LIST=$1
  if [ -d $BK_DIR/$FDIR_LIST/$TODATE ];then
    printf "%s\n" "$BK_DIR/$FDIR_LIST/$TODATE is exist!!"  >>$LOG
  else
    mkdir -p $BK_DIR/$FDIR_LIST/$TODATE
    printf "%s\n" "created directory on the"  >>$LOG
    printf "%s\n" "$BK_DIR/$FDIR_LIST/$TODATE"  >>$LOG
  fi
}
#####  Main Strat    ##############################
TIME=`date +"%Y-%m-%d %H:%M"`
printf "%s\n" "Strat $TIME Rotate Backup directory" > $LOG
printf "%-90s\n" "|-----------------------------------------------------------------------|" >>$LOG
printf "%-72s%s\n" "|           directory is keep $EXPIRE_DAY $EXPIRE_TYPE" "|" >>$LOG
printf "%-72s%s\n" "|                                                     " "|" >>$LOG     
printf "%-90s\n" "|-----------------------------------------------------------------------|" >>$LOG
for FORLIST in $DIR_LIST
do
  if [ -d $BK_DIR/$FORLIST ];then
     SUBLIST=`ls -d $FORLIST/*`
     if [ ${#SUBLIST} -eq 0 ];then 
       F_CREATE_DIR $FORLIST
     else
       for FORSUBLIST in $SUBLIST
       do  
         SUBDIR=`echo $FORSUBLIST |cut -d "/" -f 2`
         SUBDATE=`date -d $SUBDIR +%s`
         F_DTAE_CHECK $FORSUBLIST $SUBDATE 
       done
       F_CREATE_DIR $FORLIST
     fi
  else
     printf "%s\n"  "$FORLIST not is a directory"  >>$LOG

  fi
done
printf "%-90s\n" "|-----------------------------------------------------------------------|" >>$LOG
TIMEE=`date +"%Y-%m-%d %H:%M"`
printf "%s\n" "END $TIMEE Rotate Backup directory" >> $LOG

cat $LOG | mail -s "Rotate Backup config "  $MAILLIST
