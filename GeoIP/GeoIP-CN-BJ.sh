 #!/bin/sh

COUNTRYNAME="CN"
CITYNAME="Beijing"
#cd GeoLiteCity_20100401
DPATH=`pwd`
DATE=`date +%Y%m01`
[ -f GeoLiteCity_$DATE.zip ] || wget -T 5 -t 1 http://geolite.maxmind.com/download/geoip/database/GeoLiteCity_CSV/GeoLiteCity_$DATE.zip
unzip GeoLiteCity_$DATE.zip || exit 1

    
echo -ne "DONE\nGenerating BIND GeoIP.acl file..."
cat $DPATH/GeoLiteCity_*/GeoLiteCity-Location.csv | grep $COUNTRYNAME | grep $CITYNAME |awk -F \,  ' {printf "%s\n",$1 }' > $DPATH/CITYCODE.csv 
echo "" > $DPATH/GeoLiteCity.csv
for i in `cat $DPATH/CITYCODE.csv`
 do
   cat $DPATH/GeoLiteCity_*/GeoLiteCity-Blocks.csv | awk -F \"  '$6 == AA {print $2 "," $4 }' AA=$i  >> $DPATH/GeoLiteCity.csv
done
for x in $CITYNAME 
  do 
    echo "$COUNTRYNAME-$x {" 
    sed '/^$/d' $DPATH/GeoLiteCity.csv | awk -F , 'function s(b,e,l,m,n) {l = int(log(e-b+1)/log(2)); m = 2^32-2^l; n = and(m,e); if (n == and(m,b)) printf "\t%u.%u.%u.%u/%u;\n",b/2^24%256,b/2^16%256,b/2^8%256,b%256,32-l; else {s(b,n-1); s(n,e)}} s($1,$2)' 
    echo -e "};\n"
  done  > $DPATH/GeoIP.acl

rm -rf  GeoLiteCity_$DATE.zip 
rm -rf *.csv