#!/bin/bash

rm -f GeoIPCountryCSV.zip

[ ! -f "GeoIPCountryCSV.zip" ] && wget -T 5 -t 1 http://geolite.maxmind.com/download/geoip/database/GeoIPCountryCSV.zip
unzip GeoIPCountryCSV.zip || exit 1

(for c in $(awk -F \" '{print $10}' GeoIPCountryWhois.csv | sort -u)
do
  echo "acl \"$c\" {"
  awk -F \" -v c=$c 'function s(b,e,l,m,n) {l = log(e-b+1)/log(2); m = 2^32-2^int(l); n = and(m,e); if (n == and(m,b)) {printf "\t%u.%u.%u.%u/%u;\n",b/2^24%256,b/2^16%256,b/2^8%256,b%256,32-l} else {s(b,n-1); s(n,e)}} c == $10 {s($6,$8)}' GeoIPCountryWhois.csv
  echo -e "};\n"
done) | tee GeoIP.acl

rm -f GeoIPCountryWhois.csv

exit 0

