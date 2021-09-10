#!/bin/bash
#################################################################
#
#
#
#            Script by Vincent.yu
#            Created date 2011/12/13
#            Changed date 20120228
#            change URL xxx.travelzen.com -> xxx.travelzen.com/flight/
#            change date 20120338
#            option 1 out txt file to /opt/vhost/NCIS/
#            changed date 20120619
#            added flight/hotel rewrite check
#################################################################
. /opt/SYS_script/PUBLIC_LIB/Funtion.ini
LOGDIR="/opt/logs"
TMPDIR="$LOGDIR/PHPCHECK"
ARCDIR="$LOGDIR/archives/PHPCHECK"
LOGFILE="$LOGDIR/PHPCHECK/Report`date +"%Y%m%d-%H%M%S"`.txt"
F_JSERVICE(){
   if [  JSERVICE = 1 ];then
     echo "aa"
   else
     SERVICE=$1
     clear
     if [ ${#SERVICE} -eq 0 ];then
      printf "%-80s\n" "******************************************************************************"
      printf "%-80s\n" "*********      Check  PHP service          ..............................!!!!*"
      printf "%-80s\n" "*(1).ALL site  .................... .........................................*"
      printf "%-80s\n" "*(2).HK site.................................................................*"
      printf "%-80s\n" "*(3).TW site.................................................................*"
      printf "%-80s\n" "*(4).CN site.................................................................*"
      printf "%-80s\n" "*(5).Exit   .................................................................*"
      printf "%-80s\n" "*                                                                            *"
      printf "%-80s\n" "******************************************************************************"
      printf "%-80s\n" "******************************************************************************"
      read -p "Please type one number [1,2,3 or 4..........7 ] or Ctrl + C Skip it  !!! : " SERVICE
     else
      SERVICE=$1
     fi
     F_CHECK_SERVICE
   fi
}
F_CHECK_SERVICE(){
   case "$SERVICE" in
    1) F_GET_CONF  ;;
    2) F_GET_CONF HK ;;
    3) F_GET_CONF TW ;;
    4) F_GET_CONF CN ;;
    5) exit 0 ;;
    *)
     JSERVICE=0
     F_JSERVICE ;;
   esac
}
F_TMPLOG(){
   if [ ! -d $TMPDIR ];then
     mkdir -p $TMPDIR
   fi
   cd $TMPDIR
   COU=`ls | wc -l`
   if [ ! -d $ARCDIR ];then
     mkdir -p $ARCDIR
   fi
   if [ $COU -gt 0 ];then
     tar zcf ./PHPCHECK-`date +"%Y%m%d-%H%M%S"`.tar ./*
     mv *.tar $ARCDIR/
     rm -rf $TMPDIR/*
   fi
}
F_GET_CONF(){
   clear
   LIDC=$1
   DPATH="/opt/SYS_script/PUBLIC_LIB/CONFIG/$LIDC"
   LIST=`find  $DPATH  -name *.inf`
   F_TMPLOG   
   STR="=========================================  Start CHECK PHP SERVICE ==================================================="
   printf "%-80s\n" "$STR"
   WLOG $LOGFILE  "$STR"
   for i in $LIST
   do
       F_GET_CHECK $i
       if [ $HOSTNAME = "monitor.travelzen.com" ];then 
         F_GETVERSION $i
       fi
   done
}
F_GET_CHECK(){
  CONF_PATH=$1
  IDC=`cat $CONF_PATH |awk -F= '/IDC/ {print $2}'| sed 's/^"*//;s/"*$//'`
  PHP_CHECK=`cat $CONF_PATH |grep PHP_CHECK|awk -F= '{print $2}'`
  EXT_IP=`cat $CONF_PATH |grep EXT_IP|awk -F= '{print $2}'`
  if [ ${#PHP_CHECK}  -gt 0 ];then  
    if [ $PHP_CHECK = "Y" ]  &&  [ ${#EXT_IP}  -gt 0 ];then
      URL=`cat $CONF_PATH |grep URL|awk -F= '{print $2}'|sed 's/^"*//;s/"*$//'`  
      SERVER=`cat $CONF_PATH |awk -F= '/^SERVER/ {print $2}'`      
      TODAY=`date +"%Y%m%d"`
      for XX in $URL
      do 
        if [ $XX = "asaholiday.travelzen.com" ];then
          EXT_IP=210.17.248.213
          echo $EXT_IP > $TMPDIR/$IDC.$SERVER.$XX.IP
         /usr/bin/curl -s -x $EXT_IP:80 -o $TMPDIR/$IDC.$SERVER.$XX.URL.flight -m 5  -w %{time_total} -A  hkmon01/$TODAY $XX/flight/ > $TMPDIR/$IDC.$SERVER.$XX.speed.flight
         /usr/bin/curl -s -x $EXT_IP:80 -o $TMPDIR/$IDC.$SERVER.$XX.URL.hotel -m 5  -w %{time_total} -A  hkmon01/$TODAY $XX/hotel/ > $TMPDIR/$IDC.$SERVER.$XX.speed.hotel
        else      
         echo $EXT_IP > $TMPDIR/$IDC.$SERVER.$XX.IP
         /usr/bin/curl -s -x $EXT_IP:80 -o $TMPDIR/$IDC.$SERVER.$XX.URL.flight -m 5  -w %{time_total} -A  hkmon01/$TODAY $XX/flight/ > $TMPDIR/$IDC.$SERVER.$XX.speed.flight
         /usr/bin/curl -s -x $EXT_IP:80 -o $TMPDIR/$IDC.$SERVER.$XX.URL.hotel -m 5  -w %{time_total} -A  hkmon01/$TODAY $XX/hotel/ > $TMPDIR/$IDC.$SERVER.$XX.speed.hotel
        fi 
        STR="=================================================================================================================="
        printf "%-90s\n" "$STR"
        WLOG $LOGFILE  "$STR"
        STR1=" Connect TO $XX"
        #printf "%-s" "$STR"
        if [ ! -f $TMPDIR/$IDC.$SERVER.$XX.URL.flight ] && [ ! -f $TMPDIR/$IDC.$SERVER.$XX.URL.hotel ] ;then
          STR=$STR1".....< $IDC IDC > $SERVER ( $EXT_IP ) Connected  is Timeout .....[Failed]"
          printf "%-s\n" "$STR"
          WLOG $LOGFILE  "$STR"
           ##########################################
            echo $EXT_IP > $TMPDIR/$IDC.$SERVER.$XX.EXT_IP
            echo "Failed1" > $TMPDIR/$IDC.$SERVER.$XX.STATUS.flight
            echo "Failed1" > $TMPDIR/$IDC.$SERVER.$XX.STATUS.hotel
        else
          FLIGHT_SERIP=`cat $TMPDIR/$IDC.$SERVER.$XX.URL.flight  |grep sitemap |awk -F\< ' {print $4}'|awk -F\> '{print $2}'`
          FLIGHT_MAPG=`cat $TMPDIR/$IDC.$SERVER.$XX.URL.flight  |awk -F\/ '/schedulemaintenance/ {print $4}' |wc -l`
          HOTEL_SERIP=`cat $TMPDIR/$IDC.$SERVER.$XX.URL.hotel  |grep sitemap |awk -F\< ' {print $4}'|awk -F\> '{print $2}'`
          HOTEL_MAPG=`cat $TMPDIR/$IDC.$SERVER.$XX.URL.hotel  |awk -F\/ '/schedulemaintenance/ {print $4}' |wc -l`
          echo $FLIGHT_SERIP > $TMPDIR/$IDC.$SERVER.$XX.INT_IP
          if [ ${#EXT_IP} -eq 0 ];then
            FLIGHT_SERIP=`cat $TMPDIR/$IDC.$SERVER.$XX.URL.flight |grep sitemap |awk -F\> '/[0-9]+\.[0-9]+/ {print $4}'| awk -F\< '{print $1}'`
            echo $FLIGHT_SERIP > $TMPDIR/$IDC.$SERVER.$XX.INT_IP.FLIGHT
            STR=$STR1"...< $IDC IDC > $SERVER ($EXT_IP ) Status is $FLIGHT_SERIP  .......[Failed]"
            printf "%-s\n" "$STR"
            WLOG $LOGFILE  "$STR"
            HOTEL_SERIP=`cat $TMPDIR/$IDC.$SERVER.$XX.URL.hotel |grep sitemap |awk -F\> '/[0-9]+\.[0-9]+/ {print $4}'| awk -F\< '{print $1}'`
            echo $HOTEL_SERIP > $TMPDIR/$IDC.$SERVER.$XX.INT_IP.HOTEL
            ##########################################
            echo $EXT_IP > $TMPDIR/$IDC.$SERVER.$XX.EXT_IP
            echo "Failed2" > $TMPDIR/$IDC.$SERVER.$XX.STATUS.flight
            echo "Failed2" > $TMPDIR/$IDC.$SERVER.$XX.STATUS.hotel
            #########################################
          elif [ $FLIGHT_MAPG -eq 1 ];then
            STR=$STR1"...< $IDC IDC > $SERVER ($EXT_IP ) Status is $SERIP  Maintenance mode ....."
            printf "%-s\n" "$STR"
            WLOG $LOGFILE  "$STR"
            ##########################################
            echo $EXT_IP > $TMPDIR/$IDC.$SERVER.$XX.EXT_IP
            echo "MA" > $TMPDIR/$IDC.$SERVER.$XX.STATUS
          elif [ ${#FLIGHT_SERIP} -eq 0 ] &&  [ ${#HOTEL_SERIP} -eq 0 ];then
            WEBSTATUS=`cat $IDC.$SERVER.$XX.URL.flight|grep title| sed -e :a -e 's/<[^>]*>//g;/</N;//ba'`
            STR=$STR1"/flight ...< $IDC IDC > $SERVER ($EXT_IP ) WEB Status  is $WEBSTATUS  .......[Failed]"
            echo "Failed3 $WEBSTATUS" > $TMPDIR/$IDC.$SERVER.$XX.STATUS.flight
            printf "%-s\n" "$STR"
            WLOG $LOGFILE  "$STR"
            WEBSTATUS=`cat $IDC.$SERVER.$XX.URL.hotel|grep title| sed -e :a -e 's/<[^>]*>//g;/</N;//ba'`
            STR=$STR1"/hotel...< $IDC IDC > $SERVER ($EXT_IP ) WEB Status is $WEBSTATUS  .......[Failed]"
            printf "%-s\n" "$STR"
            WLOG $LOGFILE  "$STR"
            echo "Failed3 $WEBSTATUS" > $TMPDIR/$IDC.$SERVER.$XX.STATUS.hotel
            echo $EXT_IP > $TMPDIR/$IDC.$SERVER.$XX.EXT_IP                           
          else
            FILGHT_SPEED=`cat $TMPDIR/$IDC.$SERVER.$XX.speed.flight`
            STR=$STR1"/flight ....< $IDC IDC > $SERVER ($EXT_IP) IP is $SERIP .......[OK]..."
            printf "%-s\n" "$STR"
            WLOG $LOGFILE  "$STR"
            printf "%-s\n" " "
            STR=$STR1"....Loading flight page speed is $FILGHT_SPEED Sec......."
            printf "%-s\n" "$STR"
            WLOG $LOGFILE  "$STR"
            printf "%-s\n" " "
            STR="*************************************************************************************************************"
            printf "%-90s\n" "$STR"
            WLOG $LOGFILE  "$STR"
            HOTEL_SPEED=`cat $TMPDIR/$IDC.$SERVER.$XX.speed.hotel`
            STR=$STR1"/hotel ....< $IDC IDC > $SERVER ($EXT_IP) IP is $SERIP  .......[OK]..."
            printf "%-s\n" "$STR"
            WLOG $LOGFILE  "$STR"
            printf "%-s\n" " "
            STR=$STR1"....Loading hotel page speed is $HOTEL_SPEED Sec......."
            printf "%-s\n" "$STR"
            WLOG $LOGFILE  "$STR"

            ##########################################
            echo $EXT_IP > $TMPDIR/$IDC.$SERVER.$XX.EXT_IP
            echo "ok" > $TMPDIR/$IDC.$SERVER.$XX.STATUS.flight
                        echo "ok" > $TMPDIR/$IDC.$SERVER.$XX.STATUS.hotel
          fi
        fi
      done
    fi
  fi

}
F_GETVERSION(){
  
  CONF_PATH=$1
  PHP_CHECK=`cat $CONF_PATH |grep PHP_CHECK|awk -F= '{print $2}'`
  EXT_IP=`cat $CONF_PATH |grep EXT_IP|awk -F= '{print $2}'`
  if [ ${#PHP_CHECK}  -gt 0 ];then
    if [ $PHP_CHECK = "Y" ];then
      IIP=`cat $CONF_PATH |awk -F= '/^IPADDR/ {print $2}'`
      VER=`/usr/bin/ssh $IIP  'cat /opt/vhost/www.com.version.txt |grep -E "^web\.version" |cut -d= -f2'`
        SERN=`cat $CONF_PATH |awk -F= '/^SERVER/ {print $2}'`
        printf "%-s\n" "   "
        STR=" $SERN "
        STR=$STR"...PHP version is $VER ....."
        printf "%-s\n" "$STR"
        WLOG $LOGFILE  "$STR"
        echo $VER > $TMPDIR/$IDC.$SERVER.VER
    fi
  fi
}
OUTPUT_REPORT(){
        cd $TMPDIR
        REPORTFILE=`date +"%s"`
        #IDCLIST=`ls *travelzen.com |awk -F\. '{print toupper($1)}'|sort|uniq -d`
        IDCLIST=`ls *travelzen.com* |awk -F\. '{print $1}'|sort|uniq -d`
        echo "<html><head><meta content=text/html; charset=UTF-8 http-equiv=content-type><title>PHP verion</title>" > $TMPDIR/REportPHP.html
        echo "</head><body><h3>Updated `date +"%Y%m%d-%H:%M:%S"`</h3>" >>$TMPDIR/REportPHP.html
        echo "<br><br><table style=text-align: left; width: 100%; border=1 cellpadding=2 cellspacing=2>" >>$TMPDIR/REportPHP.html
        echo "<tbody><tr><td style=vertical-align: top; width: 93px;>Location<br></td><td style=vertical-align: top; width: 95px;>Server<br>" >>$TMPDIR/REportPHP.html
        echo "</td><td style=vertical-align: top; width: 110px;>Public IP<br></td><td style=vertical-align: top;>Sitemap IP<br></td><td style=vertical-align: top; width: 208px;>URL</td>" >>$TMPDIR/REportPHP.html
        echo "<td style=vertical-align: top; width: 114px;>FLIGHT STATUS</td>" >> $TMPDIR/REportPHP.html
        echo "<td style=vertical-align: top;>FLIGHT page speed (Sec) </td>" >>$TMPDIR/REportPHP.html
        echo "<td style=vertical-align: top; width: 114px;>HOTEL STATUS</td>" >>$TMPDIR/REportPHP.html
        echo "<td style=vertical-align: top;>HOTEL page speed (Sec) </td>" >>$TMPDIR/REportPHP.html
        echo  "<td style=vertical-align: top; width: 111px;>PHP version<br></td></tr>" >> $TMPDIR/REportPHP.html
        NG=`cat HK-Tsuen-Wan.server03.VER`
        for IDCL in $IDCLIST
        do 
          SERVERLIST=`ls $IDCL.*.travelzen.com* | awk -F\. '{print $2 }'|sort|uniq -d`
          sleep 2
          for SERLIST in $SERVERLIST
          do

              URLLIST=`ls $IDCL.$SERLIST.*.travelzen.com*.URL.flight | cut -d '.' -f3-6 |sed 's/\.URL//g'`
              sleep 2
              for ULIST in $URLLIST
              do
                  EXTIP=`cat $IDCL.$SERLIST.$ULIST.EXT_IP`
                  INTIP=`cat $IDCL.$SERLIST.$ULIST.INT_IP`
                  FLIGHT_STATUS=`cat $IDCL.$SERLIST.$ULIST.STATUS.flight|awk '{print $1}'`
                  HOTEL_STATUS=`cat $IDCL.$SERLIST.$ULIST.STATUS.hotel|awk '{print $1}'`
                  if [ ${#FLIGHT_STATUS} -eq 0 ];then
                      FLIGHT_STATUS=Failed2
                  elif [ ${#HOTEL_STATUS} -eq 0 ];then
                      HOTEL_STATUS=Failed2
                  fi
                  PHPVER=`cat $IDCL.$SERLIST.VER`
                  FLIGHT_SPEED=`cat $IDCL.$SERLIST.$ULIST.speed.flight` 
                  HOTEL_SPEED=`cat $IDCL.$SERLIST.$ULIST.speed.hotel`
                  if [ ${#FLIGHT_SPEED} -eq 0 ];then
                    FLIGHT_SPEED="0"
                  elif  [ ${#HOTEL_SPEED} -eq 0 ];then
                    HOTEL_SPEED="0"
                  fi
                  echo "<tr><td style=vertical-align: top; width: 93px;> $IDCL <br></td>" >> $TMPDIR/REportPHP.html
                  echo "<td style=vertical-align: top; width: 95px;> $SERLIST <br></td>" >> $TMPDIR/REportPHP.html
                  echo "<td style=vertical-align: top; width: 110px;> $EXTIP <br></td>" >> $TMPDIR/REportPHP.html
                  echo "<td style=vertical-align: top;><br> $INTIP </td>"  >> $TMPDIR/REportPHP.html
                  echo "<td style=vertical-align: top; width: 114px;> $ULIST <br></td>"  >> $TMPDIR/REportPHP.html
                  if [ "$FLIGHT_STATUS" = "ok" ];then
                      echo "<td style=vertical-align: top; width: 208px;><font color=#0101DF> OK </font><br></td>"  >> $TMPDIR/REportPHP.html
                    elif [ "$FLIGHT_STATUS" = "MA" ];then
                      echo "<td style=vertical-align: top; width: 208px;><font color=#8000FF> Maintenance mode</font><br></td>"  >> $TMPDIR/REportPHP.html
                    elif [ "$FLIGHT_STATUS" = "Failed1" ];then
                      echo "<td style=vertical-align: top; width: 208px;><font color=#FF0000> connceted timeout  </font><br></td>"  >> $TMPDIR/REportPHP.html
                    elif [ "$FLIGHT_STATUS" = "Failed2" ];then
                      echo "<td style=vertical-align: top; width: 208px;><font color=#FF0000> Status Failed  </font><br></td>"  >> $TMPDIR/REportPHP.html
                    elif  [ "$FLIGHT_STATUS" = "Failed3" ];then
                    FLIGHT_STATUS=`cat $IDCL.$SERLIST.$ULIST.STATUS.flight|awk '{print $2}'`
                      echo "<td style=vertical-align: top; width: 208px;><font color=#FF0000> Status $FLIGHT_STATUS </font><br></td>"  >> $TMPDIR/REportPHP.html
                  fi 
                  if [ "$HOTEL_SPEED" = "0" ];then
                    echo "<td style=vertical-align: top;><font color=#FF0000> Time out <br></td>"  >> $TMPDIR/REportPHP.html
                  else
                    echo "<td style=vertical-align: top;> $FLIGHT_SPEED <br></td>"  >> $TMPDIR/REportPHP.html
                  fi
                  if [ "$HOTEL_STATUS" = "ok" ];then
                      echo "<td style=vertical-align: top; width: 208px;><font color=#0101DF> OK </font><br></td>"  >> $TMPDIR/REportPHP.html
                    elif [ "$HOTEL_STATUS" = "MA" ];then
                      echo "<td style=vertical-align: top; width: 208px;><font color=#8000FF> Maintenance mode</font><br></td>"  >> $TMPDIR/REportPHP.html
                    elif [ "$HOTEL_STATUS" = "Failed1" ];then
                      echo "<td style=vertical-align: top; width: 208px;><font color=#FF0000> connceted timeout  </font><br></td>"  >> $TMPDIR/REportPHP.html
                    elif [ "$HOTEL_STATUS" = "Failed2" ];then
                      echo "<td style=vertical-align: top; width: 208px;><font color=#FF0000> Status Failed  </font><br></td>"  >> $TMPDIR/REportPHP.html
                    elif  [ "$HOTEL_STATUS" = "Failed3" ];then
                    HOTEL_STATUS=`cat $IDCL.$SERLIST.$ULIST.STATUS.hotel|awk '{print $2}'`
                    echo "<td style=vertical-align: top; width: 208px;><font color=#FF0000> Status $HOTEL_STATUS </font><br></td>"  >> $TMPDIR/REportPHP.html
                  fi
                 
                  if [ $FLIGHT_SPEED = "0" ];then
                    echo "<td style=vertical-align: top;><font color=#FF0000> Time out <br></td>"  >> $TMPDIR/REportPHP.html
                  else
                    echo "<td style=vertical-align: top;> $HOTEL_SPEED <br></td>"  >> $TMPDIR/REportPHP.html
                  fi
                  if [ "$NG" -ne $PHPVER ];then
                     echo "<td style=vertical-align: top; width: 111px;><font color=#FF0000> * $PHPVER * </font><br></td>"  >> $TMPDIR/REportPHP.html
                  else
                     echo "<td style=vertical-align: top; width: 111px;> $PHPVER <br></td>"  >> $TMPDIR/REportPHP.html
                  fi
                done
          done
        done
        echo "</tbody></table><br><br></body></html>" >> $TMPDIR/REportPHP.html
        mv REportPHP.html $REPORTFILE.html
        mv $REPORTFILE.html /opt/vhost/NCIS/PHPVVERSION/
        cd /opt/vhost/NCIS/PHPVVERSION/
        COUNT=`ls *.html |awk -F\. '{print $1}'| wc -l`
        DLIST=`ls *.html |awk -F\. '{print $1}'| sort -n`
        if [ $COUNT -gt 20 ];then
           DCOUNT=$(($COUNT - 20))
           X=0
           for i in $DLIST
           do
                rm -rf  $i.html
                X=$(($X+1))
              if [ $X -eq $DCOUNT ];then
                 exit 0;
              fi
           done
        fi
}
F_JSERVICE $1
if [ $HOSTNAME =  "monitor.travelzen.com" ] && [ $SERVICE -eq 1 ];then 
  #mv $LOGFILE  /opt/vhost/NCIS/PHPREPORT.txt
  OUTPUT_REPORT
fi





