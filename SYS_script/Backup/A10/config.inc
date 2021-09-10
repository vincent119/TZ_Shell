<?php
#################################################
#
#
#    carated date 20120904
#    script by vincent yu
#    for A10 backup script
#################################################
date_default_timezone_set("Asia/Hong_Kong");
$MYUSER="BackupA10UAER";
$MYPASSWD="1qazZXCV";
//$MYUSER="php";
//$MYPASSWD="php";
$REMOTE_SERVER="192.168.103.134";
//$REMOTE_SERVER="210.242.212.126";
$REUSER="BackupA10UAER";
$REPASSWD="1qazZXCV";
$REMOTE_DIR="/home/BackupA10UAER";
// upload service 0=ftp ; 1=tftp
$UPLOAD_SERVICE="0";
$ary[0]['ip'] = "192.168.103.250";
$ary[0]['name'] = "HKa10-1";
$ary[1]['ip'] = "192.168.103.251";
$ary[1]['name'] = "HKa10-2";
$ary[2]['ip'] = "192.168.70.253";
$ary[2]['name'] = "BJa10";
$ary[3]['ip'] = "192.168.30.250";
$ary[3]['name'] = "SHa10";
//$ary[0]['ip'] = "118.142.44.172";
//$ary[0]['name'] = "HKatest";
?>
