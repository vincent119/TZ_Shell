#!/bin/sh
####################################################
#
#
#    Script by vincent.yu
#    created Date 20110523
#    Changed Date 20120112
#
#####################################################
MAILTO="instant.msg@travelzen.com"
DPATH2="/opt/SYS_script/Network/ip2localtion"
DPATH="/opt/app/IP2Location-DB"

$DPATH2/getfile.sh


BJ(){
 cd $DPATH
 if [ -s  IP-COUNTRY-REGION-CITY.CSV ];then
  mv ip2localtion_Country.acl $DPATH/`date '+%Y%m%d'`/BJ.ip2localtion_Country.acl.`date +"%Y%m%d"`
    
  #unzip -o IP-COUNTRY-REGION-CITY-FULL.ZIP
  #rm -rf *.PDF *.TXT *.pdf *.HTM AOL.csv PCountry.mysql.dump  Satellite.csv

  cat IP-COUNTRY-REGION-CITY.CSV | awk -F \" '/\"CN\"\,\"CHINA\"\,\"BEIJING\"/ {print $0}' > BJ.list
  (for c in $(awk -F \" '{print $6}' BJ.list | sort -u| sed '/-/d')
  do
    echo "acl \"$c\" {"
    awk -F \" -v c=$c 'function s(b,e,l,m,n) {l = log(e-b+1)/log(2); m = 2^32-2^int(l); n = and(m,e); if (n == and(m,b)) {printf "\t%u.%u.%u.%u/%u;\n",b/2^24%256,b/2^16%256,b/2^8%256,b%256,32-l} else {s(b,n-1); s(n,e)}} c == $6 {s($2,$4)}' BJ.list
    echo -e "};\n"
  done) | tee BJ.acl
   sed -i 's/"CN"/"1BJ"/g' BJ.acl
  fi
}

####################################
OTHER(){
  cd $DPATH
  mv ip2localtion22.acl $DPATH/`date '+%Y%m%d'`/OTHER.ip2localtion_Country.acl.`date +"%Y%m%d"`
  #unzip -o IP-COUNTRY-FULL.ZIP
  #rm -rf *.PDF *.TXT *.pdf *.HTM AOL.csv 
  #rm -rf IPCountry.mysql.dump  Satellite.csv IPCountry.MDB
 if [ -s IPCountry.csv ];then
    (for c in $(awk -F \" '{print $6}' IPCountry.csv | sort -u| sed '/-/d')
    do
      echo "acl \"$c\" {"
      awk -F \" -v c=$c 'function s(b,e,l,m,n) {l = log(e-b+1)/log(2); m = 2^32-2^int(l); n = and(m,e); if (n == and(m,b)) {printf "\t%u.%u.%u.%u/%u;\n",b/2^24%256,b/2^16%256,b/2^8%256,b%256,32-l} else {s(b,n-1); s(n,e)}} c == $6 {s($2,$4)}' IPCountry.csv
      echo -e "};\n"
    done) | tee ip2localtion22.acl
  fi
#  mv BJ.acl ip2localtion.acl
#  sed -i 's/"CN"/"1BJ"/g' ip2localtion.acl
#  cat ip2localtion22.acl  >> ip2localtion.acl
#  rm -rf  BJ.list ip2localtion22.acl
#fi

}


BJ
OTHER
cd $DPATH
mv BJ.acl ip2localtion_Country.acl
cat ip2localtion22.acl  >> ip2localtion_Country.acl
mv ip2localtion22.acl $DPATH/`date '+%Y%m%d'`/OTHER.ip2localtion_Country.acl.`date +"%Y%m%d"`
rm -rf *.csv *.CSV *.zip *.ZIP
rm -rf  BJ.list
