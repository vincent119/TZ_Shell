#!/bin/bash
###########################################
#
#
#
#
#  changed date 20101126
#
###########################################
source /opt/script/PUBLIC_LIB/INI.inf
############################################
MIN4=`date +"%Y-%m-%d %H:%M" -d '4 min ago'`
MIN3=`date +"%Y-%m-%d %H:%M" -d '3 min ago'`
MIN2=`date +"%Y-%m-%d %H:%M" -d '2 min ago'`
MIN1=`date +"%Y-%m-%d %H:%M" -d '1 min ago'`
#MIN0=`date +%d/%b/%Y:%H:%M`
MIN0=`date +"%Y-%m-%d %H:%M"`
############################################

COMPANY="greentree tianker"
EXCLUDECOM="greentree|tianker"

for COM in $COMPANY
do
echo $COM

        LOG=$LOGPATH/affiliate/user-search-stat-affiliate.log
        CNT4MIN=`grep "$MIN4" $LOG | grep $COM | wc -l`
        CNT3MIN=`grep "$MIN3" $LOG | grep $COM | wc -l`
        CNT2MIN=`grep "$MIN2" $LOG | grep $COM | wc -l`
        CNT1MIN=`grep "$MIN1" $LOG | grep $COM | wc -l`
        CNT0MIN=`grep "$MIN0" $LOG | grep $COM | wc -l`
        AFFFSEARCH=`expr $CNT4MIN + $CNT3MIN + $CNT2MIN + $CNT1MIN + $CNT0MIN`

        CNT4MIN=`grep "$MIN4" $LOG | grep $COM >> /tmp/affliate_"$COM"_search.$SITE.yip`
        CNT3MIN=`grep "$MIN3" $LOG | grep $COM >> /tmp/affliate_"$COM"_search.$SITE.yip`
        CNT2MIN=`grep "$MIN2" $LOG | grep $COM >> /tmp/affliate_"$COM"_search.$SITE.yip`
        CNT1MIN=`grep "$MIN1" $LOG | grep $COM >> /tmp/affliate_"$COM"_search.$SITE.yip`
        CNT0MIN=`grep "$MIN0" $LOG | grep $COM >> /tmp/affliate_"$COM"_search.$SITE.yip`

        LOG=$LOGPATH/affiliate/hotel-search-stat-affiliate.log
        CNT4MIN=`grep "$MIN4" $LOG | grep $COM | wc -l`
        CNT3MIN=`grep "$MIN3" $LOG | grep $COM | wc -l`
        CNT2MIN=`grep "$MIN2" $LOG | grep $COM | wc -l`
        CNT1MIN=`grep "$MIN1" $LOG | grep $COM | wc -l`
        CNT0MIN=`grep "$MIN0" $LOG | grep $COM | wc -l`
        AFFHSEARCH=`expr $CNT4MIN + $CNT3MIN + $CNT2MIN + $CNT1MIN + $CNT0MIN`

        echo AFFFlightSearch:$AFFFSEARCH AFFHotelSearch:$AFFHSEARCH > /tmp/affliate_"$COM"_search.$SITE.txt
sleep 10
done


LOG=$LOGPATH/affiliate/user-search-stat-affiliate.log
CNT4MIN=`grep "$MIN4" $LOG | egrep -v "$EXCLUDECOM" | wc -l`
CNT3MIN=`grep "$MIN3" $LOG | egrep -v "$EXCLUDECOM" | wc -l`
CNT2MIN=`grep "$MIN2" $LOG | egrep -v "$EXCLUDECOM" | wc -l`
CNT1MIN=`grep "$MIN1" $LOG | egrep -v "$EXCLUDECOM" | wc -l`
CNT0MIN=`grep "$MIN0" $LOG | egrep -v "$EXCLUDECOM" | wc -l`
AFFFSEARCH=`expr $CNT4MIN + $CNT3MIN + $CNT2MIN + $CNT1MIN + $CNT0MIN`

LOG=$LOGPATH/affiliate/hotel-search-stat-affiliate.log
CNT4MIN=`grep "$MIN4" $LOG | egrep -v "$EXCLUDECOM" | wc -l`
CNT3MIN=`grep "$MIN3" $LOG | egrep -v "$EXCLUDECOM" | wc -l`
CNT2MIN=`grep "$MIN2" $LOG | egrep -v "$EXCLUDECOM" | wc -l`
CNT1MIN=`grep "$MIN1" $LOG | egrep -v "$EXCLUDECOM" | wc -l`
CNT0MIN=`grep "$MIN0" $LOG | egrep -v "$EXCLUDECOM" | wc -l`
AFFHSEARCH=`expr $CNT4MIN + $CNT3MIN + $CNT2MIN + $CNT1MIN + $CNT0MIN`

echo AFFFlightSearch:$AFFFSEARCH AFFHotelSearch:$AFFHSEARCH > /tmp/affliate_others_search.$SITE.txt


cd /tmp
ftp -in $MONITOR << end
user cactiupload travelzen
bin
mput affliate_*_search.$SITE.txt
bye


