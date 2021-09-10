#!/bin/sh


read -p  "Please input on or off :" evn


case "$evn" in
   "on")
     clear
     echo " maintannace mode on "
     sed -i 's/\$_CONFIG\["Maintenance"\] = 0/\$_CONFIG\["Maintenance"\] = 1/g' /opt/vhost/www.com/include/config.inc
        sed -i 's/\$_CONFIG\["Maintenance"\] = 0/\$_CONFIG\["Maintenance"\] = 1/g' /opt/vhost/affiliate.com/include/config.inc
    ;;
   "off")
     clear
     echo " maintannace mode off "
     sed -i 's/\$_CONFIG\["Maintenance"\] = 1/\$_CONFIG\["Maintenance"\] = 0/g' /opt/vhost/www.com/include/config.inc
        sed -i 's/\$_CONFIG\["Maintenance"\] = 1/\$_CONFIG\["Maintenance"\] = 0/g' /opt/vhost/affiliate.com/include/config.inc
    ;;
    *)
    echo "This is Wrong Character; running this's script again!!! "
    ;;
esac
