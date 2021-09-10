#!/bin/sh
########################################
#
#
#         script by vincent.yu
#         changed date 20120302
#
#
#######################################


read -p  "Please input on or off :" evn


case "$evn" in
   "on")
     clear
     echo " maintannace mode on "
     if [ -d /opt/vhost/www.com ];then
       sed -i 's/\$_CONFIG\["Maintenance"\] = 0/\$_CONFIG\["Maintenance"\] = 1/g' /opt/vhost/www.com/include/config.inc
       sed -i 's/\$_CONFIG\["Maintenance"\] = 0/\$_CONFIG\["Maintenance"\] = 1/g' /opt/vhost/affiliate.com/include/config.inc
       sed -i 's/\$\_CONFIG\[\"Maintenance\"\] \= 0\;/\$\_CONFIG\[\"Maintenance\"\] \= 1\;/'      /opt/vhost/www.com/php/includes/config.inc
       #cd /opt/vhost/www.com
       #mv index.php index.php.bk
       #ln -s aboutus.php index.php
     else
       printf "%s\n" "-------------------------------------------------------------------"
       printf "%s\n" "-"
       printf "%s\n" "-     not found www.com  , can not running this script"
       printf "%s\n" "-"
       printf "%s\n" "-------------------------------------------------------------------"
     fi
    ;;
   "off")
     clear
     echo " maintannace mode off "
     if [ -d /opt/vhost/www.com ];then
       sed -i 's/\$_CONFIG\["Maintenance"\] = 1/\$_CONFIG\["Maintenance"\] = 0/g' /opt/vhost/www.com/include/config.inc
       sed -i 's/\$_CONFIG\["Maintenance"\] = 1/\$_CONFIG\["Maintenance"\] = 0/g' /opt/vhost/affiliate.com/include/config.inc
        sed -i 's/\$\_CONFIG\[\"Maintenance\"\] \= 1\;/\$\_CONFIG\[\"Maintenance\"\] \= 0\;/'      /opt/vhost/www.com/php/includes/config.inc
       #cd /opt/vhost/www.com
       #rm -rf index.php
       #mv index.php.bk index.php
    else
       printf "%s\n" "-------------------------------------------------------------------"
       printf "%s\n" "-"
       printf "%s\n" "-     not found www.com  , can not running this script"
       printf "%s\n" "-"
       printf "%s\n" "-------------------------------------------------------------------"
    fi
    ;;
    *)
    echo "This is Wrong Character; running this's script again!!! "
    ;;
esac
