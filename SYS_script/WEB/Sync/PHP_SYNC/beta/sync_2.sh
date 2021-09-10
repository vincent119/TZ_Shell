#!/bin/bash




DATETIME=$1
SRCPATH="/opt/Deploy_Beta/uat/$DATETIME"
DESTPATH="/opt/Deploy_Beta/$DATETIME/PHP"
PPATCHDIR="/opt/Deploy_Beta/$DATETIME/PHP_patch"
IP="192.168.101.239"

ssh -t $IP "mkdir -p $DESTPATH ;mkdir -p $PPATCHDIR"
rsync -vrztaP --progress --delete  $SRCPATH/PHP/ -e ssh root@$IP:$DESTPATH/
rsync -vrztaP --progress --delete  $SRCPATH/PHP_patch/ -e ssh root@$IP:$PPATCHDIR/
#scp * 210.17.248.146:/opt/Deploy_Beta/$DATETIME/PHP
