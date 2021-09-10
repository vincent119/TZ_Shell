#!/bin/sh

#DATE=`date +%Y%m%d`
#DATE="20100624"

read -p  "Deployment date :" DATE

echo "Deployment on $DATE start...."

DPATH="/opt/deploy/$DATE"
DIR="www.com affiliate.com"
IMGPATH="/opt/vhost/images.com/images"

f_DEPLOY_WEB01()
{

 if [ -d $DPATH ];then

  if [ -e $DPATH/PHP/efphp$DATE.tar.gz ];then

   cp $DPATH/PHP/efphp$DATE.tar.gz  /opt/vhost/
   cd /opt/vhost/
   tar zxvf efphp$DATE.tar.gz
   rm -f /opt/vhost/ef.travelzen.com.cn
   ln -s  ef.com.$DATE ef.travelzen.com.cn
   rm -f  /opt/vhost/ef.travelzen.com.cn/templates/en/header.html
   rm -f  /opt/vhost/ef.travelzen.com.cn/templates/sc/header.html
   rm -f  /opt/vhost/ef.travelzen.com.cn/templates/tc/header.html
   cp -p /opt/vhost/ef.travelzen.com.cn/include/preferences/ef.travelzen.com.cn/en/expoefheader.html /opt/vhost/ef.travelzen.com.cn/templates/en/header.html
   cp -p /opt/vhost/ef.travelzen.com.cn/include/preferences/ef.travelzen.com.cn/sc/expoefheader.html /opt/vhost/ef.travelzen.com.cn/templates/sc/header.html
   cp -p /opt/vhost/ef.travelzen.com.cn/include/preferences/ef.travelzen.com.cn/tc/expoefheader.html /opt/vhost/ef.travelzen.com.cn/templates/tc/header.html
   rm -rf /tmp/templates_c_ef/*
  fi 
  cp $DPATH/PHP/php$DATE.tar.gz  /opt/vhost/
  cd /opt/vhost/
  tar zxvf php$DATE.tar.gz
  ln -s $IMGPATH www.com.$DATE/imageserver/images
  for i in $DIR
  do
    rm -f /opt/vhost/$i
    ln -s  www.com.$DATE $i
  done
  rm -rf /opt/vhost/php$DATE.tar.gz
  rm -rf /opt/vhost/efphp$DATE.tar.gz
  rm -rf /tmp/templates_c/*
  rm -rf /tmp/templates_c1/*
  rm -rf /tmp/templates_c_ebt/*
  rm -rf /tmp/templates_c_ef/*
  service memcached restart
 else
  echo "not find out $DPATH"
 fi
}

f_DEPLOY_MAIN()
{
 echo "|-----   Depoly server101 PHP --------|"
 ssh root@server101 "/opt/script/NEW_deploy/SHA_Deploy_PHP.sh" 

 echo "|-----   Depoly server102 PHP --------|"
 ssh root@server102 "/opt/script/NEW_deploy/SHA_Deploy_PHP.sh"
}

f_DEPLOY_WEB01
#f_DEPLOY_MAIN



