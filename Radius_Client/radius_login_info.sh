#!/bin/sh
export PATH=/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/root/bin
#################################################################################
#                                                                               #
#   script by vincent.yu                                                        #
#   date 20100706                                                               #
#   Version 1.0                                                                 #
#                                                                               #
#   1.copy script to /usr/local/bin/                                            #
#   2.change file access  to 777                                                #
#     chmod 777 /usr/local/bin/radius_login_info.sh                             #
#   3.add line to /etc/profile                                                  #
#      /usr/bin/radius_login_info.sh                                            #
#   4.Create folders and change file access to 777                              #
#     mkdir -p /var/run/radiusclient/pts                                        #
#     chmod -R 777 /var/run/radiusclient/pts                                    #
#                                                                               #
#################################################################################
RUN_PATH=/var/run/radiusclient/pts

RUSE=`export |grep USER |awk -F \" '{print $2}'` 
TTY=`export |grep SSH_TTY |awk -F \" '{print $2}'|cut -c 6-`
REMO_IP=`/usr/bin/w |grep $RUSE |grep $TTY| awk '{print $3}'`
SEC=`date +%S`
#SESSION=`echo $RUSE $REMO_IP $SEC | /usr/bin/openssl rand 15 -base64`
SESSION=`echo  $RUSE $REMO_IP $SEC | /usr/bin/openssl  des -a -pass pass:!qAZ`
PRINT_INFO() {

 printf "#############################################################################\n"
 printf "##|-----------------------------------------------------------------------|##\n" 
 printf "##| ----------------     Welcome    %s\t\t    --------------|##\n" $RUSE
 printf "##| --- your loging IP           :%s\t\t    --------------|##\n" $REMO_IP
 printf "##| --- your loging System TTY   :%s\t\t            --------------|##\n" $TTY  
 printf "##|-----------------------------------------------------------------------|##\n"
 printf "#############################################################################\n"
}
WRITE_RUN(){
  if [ -d $RUN_PATH ];then
    CONSLOE=`echo $TTY |cut -c 5-`
echo "cat <<EOF | /usr/local/sbin/radacct -f /usr/local/etc/radiusclient/radiusclient.conf
User-Name=$RUSE
Acct-Delay-Time=10
Acct-Status-Type=stop
Acct-Session-Id=$SESSION
Acct-Authentic=RADIUS
Service-Type=Login-User
Acct-Delay-Time=0
Acct-Terminate-Cause=Host-Request
Login-Service=SSH
Framed-IP-Address=$REMO_IP
Framed-Protocol=SSH
EOF" > $RUN_PATH/$CONSLOE 

cat <<EOF | /usr/local/sbin/radacct -f /usr/local/etc/radiusclient/radiusclient.conf
User-Name=$RUSE
Acct-Delay-Time=10
Acct-Status-Type=start
Acct-Session-Id=$SESSION
Acct-Authentic=RADIUS
Service-Type=Login-User
Acct-Delay-Time=0
Acct-Terminate-Cause=Host-Request
Login-Service=SSH
Framed-IP-Address=$REMO_IP
Framed-Protocol=SSH
EOF


  else
    mkdir -p $RUN_PATH 
    chmod -R 777 $RUN_PATH 
    WRITE_RUN
  fi


}



##### Start Main ##########

PRINT_INFO
WRITE_RUN




