#!/bin/bash
##############################################
#############################################
source /opt/script/PUBLIC_LIB/INI.inf
##############################################
#
##############################################
MIN4=`date +"%Y-%m-%d %H:%M" -d '4 min ago'`
MIN3=`date +"%Y-%m-%d %H:%M" -d '3 min ago'`
MIN2=`date +"%Y-%m-%d %H:%M" -d '2 min ago'`
MIN1=`date +"%Y-%m-%d %H:%M" -d '1 min ago'`
MIN0=`date +%d/%b/%Y:%H:%M`
########################################
LOG=$LOGPATH/$OTAWEBPATH/user-search-stat-1.log 
CNTMIN=`grep -E "$MIN4|$MIN3|$MIN2|$MIN1|$MIN0" $LOG | grep hk.travelzen.com | wc -l`
FSEARCH=`expr $CNTMIN`
###############################################
LOG=$LOGPATH/$OTAWEBPATH/hotel-search-stat-1.log 
CNTMIN=`grep -E "$MIN4|$MIN3|$MIN2|$MIN1|$MIN0" $LOG | grep hk.travelzen.com | wc -l`
HSEARCH=`expr $CNTMIN`
DISPLAY="hkFlightSearch1:$FSEARCH hkHotelSearch1:$HSEARCH"
printf "%s\t%s" $DISPLAY > /tmp/flight_search1.$SITE.$SERVER.txt
########################################
LOG=$LOGPATH/$OTAWEBPATH/user-search-stat-1.log 
CNTMIN=`grep -E "$MIN4|$MIN3|$MIN2|$MIN1|$MIN0" $LOG | grep tw.travelzen.com | wc -l`
FSEARCH=`expr $CNTMIN`
###############################################
LOG=$LOGPATH/$OTAWEBPATH/hotel-search-stat-1.log 
CNTMIN=`grep -E "$MIN4|$MIN3|$MIN2|$MIN1|$MIN0" $LOG | grep tw.travelzen.com | wc -l`
HSEARCH=`expr $CNTMIN`
DISPLAY="twFlightSearch1:$FSEARCH twHotelSearch1:$HSEARCH"
printf "%s\t%s" $DISPLAY > /tmp/flight_search1.tw.$SERVER.txt
#################################################
# Refer KPI
LOG=$LOGPATH/$OTAWEBPATH/user-search-stat-1.log
if [ -d $LOGPATH/$OTAWEBPATH/KPI  ];then
   echo 0
else
   mkdir -p $LOGPATH/$OTAWEBPATH/KPI
fi
CNT4MIN=`grep "$MIN4" $LOG >  $LOGPATH/$OTAWEBPATH/KPI/chk_flightref.txt`
CNT3MIN=`grep "$MIN3" $LOG >> $LOGPATH/$OTAWEBPATH/KPI/chk_flightref.txt`
CNT2MIN=`grep "$MIN2" $LOG >> $LOGPATH/$OTAWEBPATH/KPI/chk_flightref.txt`
CNT1MIN=`grep "$MIN1" $LOG >> $LOGPATH/$OTAWEBPATH/KPI/chk_flightref.txt`
CNT0MIN=`grep "$MIN0" $LOG >> $LOGPATH/$OTAWEBPATH/KPI/chk_flightref.txt`
###############################
LOG=$LOGPATH/$OTAWEBPATH/hotel-search-stat-1.log
CNT4MIN=`grep "$MIN4" $LOG > $LOGPATH/$OTAWEBPATH/KPI/chk_hotelref.txt`
CNT3MIN=`grep "$MIN3" $LOG >> $LOGPATH/$OTAWEBPATH/KPI/chk_hotelref.txt`
CNT2MIN=`grep "$MIN2" $LOG >> $LOGPATH/$OTAWEBPATH/KPI/chk_hotelref.txt`
CNT1MIN=`grep "$MIN1" $LOG >> $LOGPATH/$OTAWEBPATH/KPI/chk_hotelref.txt`
CNT0MIN=`grep "$MIN0" $LOG >> $LOGPATH/$OTAWEBPATH/KPI/chk_hotelref.txt`

REFERRER="google yahoo baidu facebook qunar"
for REFER in $REFERRER
do
        FSEARCH=`cat $LOGPATH/$OTAWEBPATH/KPI/chk_flightref.txt | cut -d ',' -f 5 | cut -d '/' -f 3 | grep $REFER | wc -l`
        HSEARCH=`cat $LOGPATH/$OTAWEBPATH/KPI/chk_hotelref.txt | grep search | cut -d ',' -f 5 | cut -d '/' -f 3 | grep $REFER | wc -l`
        DISPLAY1="hkFlightSearch:$FSEARCH hkHotelSearch:$HSEARCH"
        printf "%s\t%s" $DISPLAY1 /tmp/referrer_"$REFER"_search.$SITE.$SERVER.txt
done

FSEARCH=`cat $LOGPATH/$OTAWEBPATH/KPI/chk_flightref.txt | cut -d ',' -f 5 | cut -d '/' -f 3 | egrep 'travelzen|^$' | wc -l`
HSEARCH=`cat $LOGPATH/$OTAWEBPATH/KPI/chk_hotelref.txt | grep search | cut -d ',' -f 5 | cut -d '/' -f 3 | egrep 'travelzen|^$' | wc -l`
DISPLAY2="hkFlightSearch:$FSEARCH hkHotelSearch:$HSEARCH"
printf "%s\t%s" $DISPLAY2  > /tmp/referrer_travelzen_search.$SITE.$SERVER.txt

FSEARCH=`cat $LOGPATH/$OTAWEBPATH/KPI/chk_flightref.txt | cut -d ',' -f 5 | cut -d '/' -f 3 | egrep -v 'travelzen|^$|google|yahoo|baidu|facebook|qunar"' | wc -l`
HSEARCH=`cat $LOGPATH/$OTAWEBPATH/KPI/chk_hotelref.txt | grep search | cut -d ',' -f 5 | cut -d '/' -f 3 | egrep -v 'travelzen|^$|google|yahoo|baidu|facebook|qunar' | wc -l`
DISPLAY3="hkFlightSearch:$FSEARCH hkHotelSearch:$HSEARCH"
printf "%s\t%s" $DISPLAY3 > /tmp/referrer_others_search.$SITE.$SERVER.txt

cd /tmp
ftp -in $MONITOR << end
user cactiupload travelzen
bin
cd TMP
mput flight_search1.*.*.txt
mput referrer_*_search.*.*.txt
bye

