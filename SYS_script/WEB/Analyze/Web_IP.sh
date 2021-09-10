#!/bin/bash
############################################
#
#
#    script by vincent.yu
#    created date 20120316
#    changed date 20120416
#
############################################




# Timing Variable
MIN5=`date +"%d/%b/%Y:%H:%M" -d '5 min ago'`
MIN4=`date +"%d/%b/%Y:%H:%M" -d '4 min ago'`
MIN3=`date +"%d/%b/%Y:%H:%M" -d '3 min ago'`
MIN2=`date +"%d/%b/%Y:%H:%M" -d '2 min ago'`
MIN1=`date +"%d/%b/%Y:%H:%M" -d '1 min ago'`
MIN0=`date +"%d/%b/%Y:%H:%M"`
MIN00=`date "+%Y%m%d%H%M"`
MIN55=`date +"%Y%m%d%H%M" -d '5 min ago'`


WLOG=/opt/logs/www.com/access_log
OFF_IP=/opt/SYS_script/PUBLIC_LIB/NET_config/office_ip.inf
IDC_IP=/opt/SYS_script/PUBLIC_LIB/NET_config/IDC_ip.inf
##########################################################
LASTCOUNT=10
SESSION_COUNT=25
LAST_LINE_LOG=5
MAILLIST="system.info@travelzen.com"
EXCLUDE_FILE=".png|.gif|.css|.js|.jpg"
HTML_FILE="index.php|search.php"

##############################
TLOGDIR=/tmp/NCIS
ALOG=$TLOGDIR/Alog.txt
NONELOG=$TLOGDIR/nonelog.txt
SORTIP=$TLOGDIR/SORT_IP.txt
REPORT=$TLOGDIR/AREPORT.txt
HISTORY_log=$TLOGDIR/HISTORY.txt


CHECK(){
    CONF=`find /opt/SYS_script/PUBLIC_LIB/CONFIG/  -name $HOSTNAME.inf`
    USEPHP=`cat $CONF |sed '/^#/d'|grep ^USE_PHP|awk -F= '{print $2}'`
    if [ $USEPHP != "Y" ];then
      clear
      printf "%s\n" "|----------------------------------------------------|"
      printf "%s\n" "|"
      printf "%s\n" "|  can not running this is script..........."
      printf "%s\n" "|"
      printf "%s\n" "|----------------------------------------------------|"
      exit 0;
    fi
    SETP1
}



SETP1(){

  OFF_IP_LIST=`cat $OFF_IP |awk '{print $2}'|awk 'BEGIN {print $2}{ FS = "\n" }{printf "%s", $1"|" }END { print substr($0,1,length($0)-1)}'`
  IDC_IP_LIST=`cat $IDC_IP |awk '{print $2}'|awk 'BEGIN {print $2}{ FS = "\n" }{printf "%s", $1"|" }END { print substr($0,1,length($0)-1)}'`
 

  cat $WLOG |grep  "$MIN0" > $ALOG.txt
  cat $WLOG |grep  "$MIN1" >> $ALOG.txt
  cat $WLOG |grep  "$MIN2" >> $ALOG.txt
  cat $WLOG |grep  "$MIN3" >> $ALOG.txt
  cat $WLOG |grep  "$MIN4" >> $ALOG.txt
  cat $WLOG |grep  "$MIN5" >> $ALOG.txt

  cat  $ALOG.txt |egrep -v $OFF_IP_LIST |egrep -v $IDC_IP_LIST |egrep -v $EXCLUDE_FILE |egrep $HTML_FILE> $NONELOG
  IPCOUNT=`cat $NONELOG |wc -l`
  if [ $IPCOUNT -gt 0 ];then
    mv $SORTIP /tmp/NCIS/LSAT_SORT_IP.txt
    cat $NONELOG |awk '{print $1}'|sort |uniq -c |sort -nr |awk '$1 > COUNT { print $0 }' COUNT=$SESSION_COUNT |sort -nr > $SORTIP
    IPSUB=`cat $SORTIP |awk '$1 > COUNT {print $1}'  COUNT=$SESSION_COUNT |wc -l`
    if [ $IPSUB -gt 0 ];then
      printf  "%-90s\n" "|-------------------- The digit is bigger than $SESSION_COUNT for log count ----------------|"> $REPORT          
      printf "%s\n" "" >>$REPORT
      printf "%s90\n"    "|----    exclude file $EXCLUDE_FILE               -----|"
      printf "%s\n" "" >>$REPORT
      printf "%-90s\n" "|-- count from $MIN5 to  $MIN0  --------------------|" >>$REPORT
      printf "%s\n" "" >>$REPORT 
      printf "%-10s%-18s\n" "|---count--|""----IP----------|" >>$REPORT 
      cat $SORTIP | awk '{printf "|%-10s|%-16s|\n", $1, $2 }'>> $REPORT
      CLEAR_TIME=`echo $MIN00 | awk '{print substr($0,9,12)}'`
      if  [ $CLEAR_TIME = "0000" ];then
         echo "" >   $HISTORY_log
      fi 
      cat  $SORTIP | awk '{print $1,$2,MIN555,"-",MIN000 }' MIN555=$MIN5 MIN000=$MIN0 >> $HISTORY_log
      printf "%s\n" "" >>$REPORT
      printf "%-60s\n" "|-------------------------------------------------------------------------------------|" >>$REPORT
    SETP2
    fi
  fi
 
}
SETP2(){
  LIST=`cat $SORTIP|awk '{print $2}'`
  LDAY=`date +"%d/%b/%Y"`
  printf "%s\n" "" >>$REPORT
  printf "%-90s\n" "|-------------- count from $LDAY:00:00 to  $MIN0  ------------------------------------|" >>$REPORT
  printf "%s\n" "" >>$REPORT
  printf "%-15s%-18s\n" "|---count----|""----IP----------|" >>$REPORT
  for x in $LIST
  do
    SUBCOUNT=`cat $WLOG |grep $x |egrep -v $EXCLUDE_FILE |wc -l`
    printf "|%-10s|%-16s|\n"  "$SUBCOUNT" $x >>$REPORT
  done
  printf "%s\n" "" >>$REPORT
  printf "%-90s\n" "|-------------------------------------------------------------------------------------|" >>$REPORT
  SETP3
}
SETP3(){

  printf "%s\n" "" >>$REPORT
  LIST=`cat $SORTIP|awk '{print $2}'`
  printf "%-90s\n" "|---------------    last log from web log --------------------------------------------|" >>$REPORT
  printf "%s\n" "" >>$REPORT
  for x in $LIST
  do
    printf "%-90s" "|***************** log detail for   $x   ***************************************|" >>$REPORT
    printf "%s\n" "" >>$REPORT
    cat $NONELOG |grep $x |tail -$LAST_LINE_LOG >> $REPORT
    printf "%s\n" "" >>$REPORT
    printf "%-90s\n" "|***********************************************************************************|" >>$REPORT
    printf "%s\n" "" >>$REPORT
  done
  printf "%s\n" "" >>$REPORT
  printf "%-90s\n" "|------------------------------------------------------------------------------------------------------|" >>$REPORT
  printf "%s\n" "" >>$REPORT
  printf "%s\n" "" >>$REPORT
  printf "%s\n" "" >>$REPORT
  SETP4
}
SETP4(){
   HILIST=`cat $SORTIP |awk '{print $2}'`
   if [ ${#HILIST} -ne 0 ];then
   #  for HI_LIST in $HILIST
   #  do
   #    printf "%-90s" "|***************** history log detail for  $HI_LIST   ************************************|" >>$REPORT
   #    printf "%s\n" "" >>$REPORT
       printf "%-90s\n" "|***************** history log detail for last $LASTCOUNT    ********************************************|" >>$REPORT
       printf "%-15s%-18s-%24s\n" "|---count----|""--------IP----------|""-------------- TIME ------------------|" >>$REPORT
       printf "%s\n" "" >>$REPORT
       tail -n   $LASTCOUNT    $HISTORY_log | awk '{printf("%-5s%s%-s%s%s%s%2s\t%s%s\n"," | ", $1," | ",$2," | ",$3,$4,$5," |")}'     >>$REPORT
       #cat $HISTORY_log |grep $HI_LIST |awk '{printf("%-5s%s%-s%s%s%s%2s\t%s%s\n"," | ", $1," | ",$2," | ",$3,$4,$5," |")}' >>$REPORT
       printf "%s\n" "" >>$REPORT 
       printf "%-90s\n" "|***************************************************************************************|" >>$REPORT
     #done
     SENDMAIL
   fi
}
SENDMAIL(){
   mail -s "web log Analyze for $HOSTNAME" $MAILLIST < $REPORT
}
if [ ! -d /tmp/NCIS ];then
  mkdir /tmp/NCIS
fi
CHECK

