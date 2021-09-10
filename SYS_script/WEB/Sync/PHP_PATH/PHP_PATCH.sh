#!/bin/sh
#########################################
#
#
#
#   script by vincent.yu
#   date by 20100722
#
#########################################
DPATH="/opt/deploy"
WEBPATH="/opt/vhost"
LISTPATH="$DPATH/"
BACKUPDIR="/tmp/PHP_PATCH/`date +%Y%m%d-%H%M`"
TOMAIL="system.info@travelzen.com music.yin@travelzen.com ken.tam@travelzen.com"

READFILE()
{
 CPATH="/opt/SYS_script/PUBLIC_LIB/CONFIG"
 HOSTCONFIG=`find $CPATH -name $HOSTNAME.inf`
 LOCATION=`cat $HOSTCONFIG |sed '/^#/d'|grep LOCATION |awk -F= '{print $2}'`
 if [ -s $DPATH/$NUM_DATE/PHP_patch/*.lst ];then
	if [ $LOCATION = "cn" ];then
	LIST=`ls $DPATH/$NUM_DATE/PHP_patch/*.lst`
	cp $DPATH/$NUM_DATE/PHP_patch/* $BACKUPDIR/SOURCE/
	cd $BACKUPDIR/SOURCE/
	#cp patch*.bz2     ./www.com/
	#cd $BACKUPDIR/SOURCE/www.com
	tar -jxvf patch*.tar.bz2 -C www.com
	#tar zxvf patch$NUM_DATEef.tar.gz
	else
	LIST=`ls $DPATH/$NUM_DATE/PHP_patch/*.lst`
	cp $DPATH/$NUM_DATE/PHP_patch/* $BACKUPDIR/SOURCE/ 
	cd $BACKUPDIR/SOURCE
	#cp php*.bz2     ./www.com/
	#cd $BACKUPDIR/SOURCE/www.com
	tar -jxvf patch*.tar.bz2 -C www.com
	fi

	for i in $LIST
	do  
	while read -r LINE;
	  do
		FILENAME=`basename www.com/$LINE`
		PATHNAME=`dirname  www.com/$LINE`
		mkdir -p $BACKUPDIR/BACKUP/$PATHNAME
		printf "%s %s %s\n" mkdir -p $BACKUPDIR/BACKUP/$PATHNAME >> $MKLOG
		BACKUPFILE $PATHNAME $FILENAME
		F_REPLACE_FILE $PATHNAME $FILENAME
	  done < $i 
	done
 else
    echo "can't found list file on $HOSTNAME " > $BACKUPDIR/ERROR.log 
	mail -s "$LOCATION - $HOSTNAME running PHP patch ERROR." $TOMAIL < $BACKUPDIR/ERROR.log 
 fi 
}

DATECHECK()
{
  date -d $1 &> /dev/null
  if [ $? -eq 0 ];then
   DATECHECK=1 
  else
   read -p "Please type in Date format YYYYMMDD or Ctrl + C Skip it!!! : " NUM_DATE
   DATECHECK $NUM_DATE
  fi
}
CHECK_FILE()
{
  if [ -e $DPATH/$NUM_DATE ];then
     CHECK_FILE=1 
  else
    echo "Can't find $DPATH/$NUM_DATE!!!"
    read -p "Please type in Date format YYYYMMDD or Ctrl + C Skip it!!!: " NUM_DATE
    DATECHECK $NUM_DATE
    if [ $DATECHECK = 1 ];then
      CHECK_FILE
    fi
  fi

}
F_REPLACE_FILE(){
 cp $BACKUPDIR/SOURCE/$1/$2 $WEBPATH/$1/$2
 printf "%s %s %s\n " cp $BACKUPDIR/SOURCE/$1/$2 $WEBPATH/$1/$2 >> $RPLOG
}
BACKUPFILE()
{ 
  cp $WEBPATH/$1/$2 $BACKUPDIR/BACKUP/$1/$2
  printf "%s %s %s\n" cp $WEBPATH/$1/$2 $BACKUPDIR/BACKUP/$1/$2 >> $CPLOG
  printf  "%s %s %s\n" cp  $BACKUPDIR/BACKUP/$1/$2 $WEBPATH/$1/$2 >> $RTLOG
}
F_MAIL(){
  TIME=`date +%Y%m%d-%H%M`
  printf "%s %s %s %s %s\n" PHP patch running $TIME .............. > $MAIL
  printf "%s\n" >> $MAIL
  printf "%s %s %s %s \n" 1. Created Backup floder >> $MAIL
  printf "%s\n" >> $MAIL
  awk '{print $0}' $MKLOG >> $MAIL
  printf "%s\n" >> $MAIL
  printf "%s %s %s %s %s %s\n" 2. Created Backup file to $BACKUPDIR/BACKUP >> $MAIL
  printf "%s\n" >> $MAIL
  awk '{print $0}' $CPLOG >> $MAIL
  printf "%s\n" >> $MAIL
  printf "%s %s %s %s %s %s\n" 3. Replaced the file  >> $MAIL
  printf "%s\n" >> $MAIL
  awk '{print $0}' $RPLOG >> $MAIL
  printf "%s\n" >> $MAIL
  printf "%-s\n" "#############################################################################" >>$MAIL
  printf "\t\t\t%s %s\n" "Please note!!!" >> $MAIL
  printf "%s\n" >> $MAIL
  printf "%s %s %s %s %s %s %s %s %s %s %s\n"  To restore, run the following command >>$MAIL
  printf "%s\n" >> $MAIL
  awk '{print $0}' $RTLOG >> $MAIL
  printf "%-s\n" "#############################################################################" >>$MAIL
  mail -s "$LOCATION - $HOSTNAME running PHP patch." $TOMAIL < $MAIL
}
## MAIN Start

NUM_DATE=$1

DATECHECK $NUM_DATE
if [ $DATECHECK = 1 ];then
  CHECK_FILE
  if [ $CHECK_FILE = 1 ];then
    mkdir -p $BACKUPDIR/SOURCE/www.com
    echo "" > $BACKUPDIR/MK_PHP_PATCH.log
    echo "" > $BACKUPDIR/CP_PHP_PATCH.log
    echo "" > $BACKUPDIR/RT_PHP_PATCH.log
    echo "" > $BACKUPDIR/RP_PHP_PATCH.log
    CPLOG=$BACKUPDIR/CP_PHP_PATCH.log
    MKLOG=$BACKUPDIR/MK_PHP_PATCH.log
    RTLOG=$BACKUPDIR/RT_PHP_PATCH.log
    RPLOG=$BACKUPDIR/RP_PHP_PATCH.log
    READFILE
    F_MAIL
  fi
fi 
DATE=`date +%Y%m%d-%H%M`
DTIME=`date +"%H%M"`
cd $DPATH/$NUM_DATE/PHP_patch/
mv patch-*.lst patch$DATETIME-$DTIME.lst.bk 
mv patch-*.tar.bz2 patch$DATETIME-$DTIME.tar.bz2.bk

#rm -rf /tmp/templates_c/*
TMPLIST=`ls -d /tmp/templates*`
for tmpList in $TMPLIST
do
    rm -rf  $tmpList/*
done

