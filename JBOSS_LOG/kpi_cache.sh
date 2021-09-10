#!/bin/bash
###############################################
#      this is script only running on SHA web01
#
#
###############################################
source /opt/script/PUBLIC_LIB/INI.inf
##############################################
MIN4=`date +"%Y-%m-%d %H:%M" -d '4 min ago'`
MIN3=`date +"%Y-%m-%d %H:%M" -d '3 min ago'`
MIN2=`date +"%Y-%m-%d %H:%M" -d '2 min ago'`
MIN1=`date +"%Y-%m-%d %H:%M" -d '1 min ago'`
MIN0=`date +%d/%b/%Y:%H:%M`
##############################################

if [ -s $LOGPATH/hotelcrs-ws/search-lite-stat.log ];then
  LOG=$LOGPATH/hotelcrs-ws/search-lite-stat.log
  CNT4MIN=`grep "$MIN4" $LOG | grep 58.83. | wc -l`
  CNT3MIN=`grep "$MIN3" $LOG | grep 58.83. | wc -l`
  CNT2MIN=`grep "$MIN2" $LOG | grep 58.83. | wc -l`
  CNT1MIN=`grep "$MIN1" $LOG | grep 58.83. | wc -l`
  CNT0MIN=`grep "$MIN0" $LOG | grep 58.83. | wc -l`
  #CCHSEARCH=`expr $CNT4MIN + $CNT3MIN + $CNT2MIN + $CNT1MIN + $CNT0MIN`
  CCHSEARCHTMP=`expr $CNT4MIN + $CNT3MIN + $CNT2MIN + $CNT1MIN + $CNT0MIN`
  CCHSEARCH=`expr $CCHSEARCHTMP / 5`

  CCFSEARCH=0
  echo shCCFlightSearch:$CCFSEARCH shCCHotelSearch:$CCHSEARCH > /tmp/cache_search_qunar.sh.txt

  LOG=$LOGPATH/hotelcrs-ws/search-lite-stat.log
  CNT4MIN=`grep "$MIN4" $LOG | grep 202.157. | wc -l`
  CNT3MIN=`grep "$MIN3" $LOG | grep 202.157. | wc -l`
  CNT2MIN=`grep "$MIN2" $LOG | grep 202.157. | wc -l`
  CNT1MIN=`grep "$MIN1" $LOG | grep 202.157. | wc -l`
  CNT0MIN=`grep "$MIN0" $LOG | grep 202.157. | wc -l`
  CCHSEARCH=`expr $CNT4MIN + $CNT3MIN + $CNT2MIN + $CNT1MIN + $CNT0MIN`
  #CCHSEARCHTMP=`expr $CNT4MIN + $CNT3MIN + $CNT2MIN + $CNT1MIN + $CNT0MIN`
  #CCHSEARCH=`expr $CCHSEARCHTMP / 5`

  CCFSEARCH=0
  echo shCCFlightSearch:$CCFSEARCH shCCHotelSearch:$CCHSEARCH > /tmp/cache_search_wego.sh.txt

  LOG=$LOGPATH/hotelcrs-ws/search-lite-stat.log
  CNT4MIN=`grep "$MIN4" $LOG | grep 60.28.194.164 | wc -l`
  CNT3MIN=`grep "$MIN3" $LOG | grep 60.28.194.164 | wc -l`
  CNT2MIN=`grep "$MIN2" $LOG | grep 60.28.194.164 | wc -l`
  CNT1MIN=`grep "$MIN1" $LOG | grep 60.28.194.164 | wc -l`
  CNT0MIN=`grep "$MIN0" $LOG | grep 60.28.194.164 | wc -l`
  CCHSEARCH=`expr $CNT4MIN + $CNT3MIN + $CNT2MIN + $CNT1MIN + $CNT0MIN`
  #CCHSEARCHTMP=`expr $CNT4MIN + $CNT3MIN + $CNT2MIN + $CNT1MIN + $CNT0MIN`
  #CCHSEARCH=`expr $CCHSEARCHTMP / 5`

  CCFSEARCH=0
  echo shCCFlightSearch:$CCFSEARCH shCCHotelSearch:$CCHSEARCH > /tmp/cache_search_kuxun.sh.txt

  LOG=$LOGPATH/affiliate/user-search-stat-affiliate.log
  CNT4MIN=`grep "$MIN4" $LOG | grep QUNAR | wc -l`
  CNT3MIN=`grep "$MIN3" $LOG | grep QUNAR | wc -l`
  CNT2MIN=`grep "$MIN2" $LOG | grep QUNAR | wc -l`
  CNT1MIN=`grep "$MIN1" $LOG | grep QUNAR | wc -l`
  CNT0MIN=`grep "$MIN0" $LOG | grep QUNAR | wc -l`
  CCFSEARCHTMP=`expr $CNT4MIN + $CNT3MIN + $CNT2MIN + $CNT1MIN + $CNT0MIN`
  CCFSEARCH=`expr $CCFSEARCHTMP / 5`

  CCHSEARCH=0
  echo shCCFlightSearch:$CCFSEARCH shCCHotelSearch:$CCHSEARCH > /tmp/cache_fsearch_qunar.sh.txt

  cd /tmp
ftp -in 192.168.3.34 << end
user cactiupload travelzen
bin
mput cache_search_qunar.sh.txt
mput cache_search_wego.sh.txt
mput cache_search_kuxun.sh.txt
mput cache_fsearch_qunar.sh.txt
bye
fi
