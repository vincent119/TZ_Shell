#!/bin/sh
# check_SSL_expire.sh by vincent
#

SSL_URL="www.travelzen.com.cn www.travelzen.com"
LIMIT_DAY=60
MAILLIST="instant.msg@travelzen.com"
#############################
TODATE=`date +'%Y%m%d'`
TODATE_S=`date -d $TODATE +%s`

for i in $SSL_URL
do
  /usr/bin/openssl s_client -connect $i:443 < /dev/null  > $i.pem
  ENDDAY=`openssl x509 -noout -in $i.pem  -enddate | cut -c 10- | awk '{print $2}'`
  ENDYEAR=`openssl x509 -noout -in $i.pem  -enddate | cut -c 10- | awk '{print $4}'`
  ENDMON=`openssl x509 -noout -in $i.pem  -enddate | cut -c 10- | awk '{print $1 $2}'`
  ENDMON=`date "+%G%m" -d $ENDMON | cut -c 5-`
  if [ ${#ENDDAY} == "1" ]; then
    ENDDAY="0"$ENDDAY
  fi

  EXPIRE_DATE=$ENDYEAR$ENDMON$ENDDAY
  EXPIRE_DATE_S=`date -d $EXPIRE_DATE +%s`
  RESULTS=`echo "(( $EXPIRE_DATE_S - $TODATE_S ) / (3060*24)) -1" | bc`
  if [  $RESULTS -le $LIMIT_DAY ];then
     touch Alter.$i.pem
     echo "SSL certificate for $i expires in $RESULTS days" >> Alter.$i.pem
     echo  "" >> Alter.$i.pem
     echo "Server certificate: " >> Alter.$i.pem
    /usr/bin/openssl x509 -noout -in $i.pem -subject >> Alter.$i.pem
     echo "" >> Alter.$i.pem
    STARTDATE=`openssl x509 -noout -in $i.pem  -startdate |cut -c 11-`
    echo "start date: $STARTDATE" >> Alter.$i.pem
    ENDDAY2=`openssl x509 -noout -in $i.pem  -enddate  |cut -c 10-`
    echo "expire date: $ENDDAY2" >> Alter.$i.pem

    cat Alter.$i.pem | mail -s "Alter for SSL certificate "  $MAILLIST

  fi

done

rm -rf *.pem


