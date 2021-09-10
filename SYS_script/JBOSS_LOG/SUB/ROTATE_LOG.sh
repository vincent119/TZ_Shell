#!/bin/sh
#################################
#
#
#
#
# 2010/11/2  script by vincent yu
##################################

source /opt/script/JBOSS_LOG/INI.inf

F_ROTATE_LOG(){

  DATE=`date +%Y-%m-%d`
  LOGDIR=$1

  CRONLOG="/tmp/ROTATE_$LOGDIR"
  echo > $CRONLOG
  cd $LOGPATH/$LOGDIR
  JBOSSNOHUP=`ls -la *.log |awk '$5 != 0 {print $9}'`
  if [ ! -e $ARCPATH/$LOGDIR ];then
    mkdir $ARCPATH/$LOGDIR 
  fi
  for i in $JBOSSNOHUP
  do            
    echo "=====================================" >> $CRONLOG
    echo "$i Started at `date +"%y-%m-%d %H:%M:%S"`" >> $CRONLOG
    cat $i >> $i.$DATE
    cat /dev/null > $i
    gzip $i.$DATE >> $CRONLOG 2>&1
    mv  $i.$DATE.gz $ARCPATH/$LOGDIR >> $CRONLOG 2>&1
    echo "$i completed at `date +"%H:%M:%S"` $i.$DATE.gz" >> $CRONLOG
    COUNT=`ls -al $i*.tmp |wc -l`
    if [ $COUNT -gt 0 ];then
      F_ROTATE_LOG_TMP $LOGDIR $i
    fi
  done

}
F_ROTATE_LOG_TMP(){
  LOGDIR=$1
  TMPLOG=$2
  cd $LOGPATH/$LOGDIR
  TMPLIST=`ls -al $TMPLOG*.tmp |awk '{print $9}'`
  for i in $TMPLIST
  do
    DATE=`ls -latc --time-style="+%Y%m%d" $i |awk '{print $6}'`
    mv $i $TMPLOG.$DATE
    gzip $TMPLOG.$DATE
    mv $TMPLOG.$DATE.gz $ARCPATH/$LOGDIR/ 
  done

}
