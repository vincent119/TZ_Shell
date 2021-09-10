#!/bin/bash




DATETIME=$1
SRCPATH="/opt/build/uat/$DATETIME"
DESTPATH="/opt/Deploy_Beta/$DATETIME/PHP"
PPATCHDIR="/opt/Deploy_Beta/$DATETIME/PHP_patch" 
IP="210.17.248.146"

ssh -t $IP "mkdir -p $DESTPATH ;mkdir -p $PPATCHDIR"
rsync -vrztaP --progress --delete  $SRCPATH/PHP/ -e ssh root@$IP:$DESTPATH/  
rsync -vrztaP --progress --delete  $SRCPATH/PHP_patch/ -e ssh root@$IP:$PPATCHDIR/
ssh -t $IP "/opt/SYS_script/WEB/Sync/PHP_SYNC/uat/sync_2.sh $DATETIME"
#scp * 210.17.248.146:/opt/Deploy_Beta/$DATETIME/PHP
