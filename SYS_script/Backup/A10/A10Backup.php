<?php
#################################################
#
#
#    carated date 20120904
#    script by vincent yu
#    for A10 backup script
#    verson 2.0
#################################################
include("config.inc");

function getStatusNew($XMLResult) {
     preg_match('/<response status="(.+)"[\s]?[\/]?>/', $XMLResult, $matches);
     return isset($matches) ? $matches[1] : '';
}

$date1 = date("Ymd");  
$type= date("N");
echo "type:".$type;

if ( $UPLOAD_SERVICE = "0" ){
   $protocol="tftp";
   $port="69";
   }
 elseif ( $UPLOAD_SERVICE = "1" ) {
    $protocol="ftp";
    $port="21";    
}
for($i=0; $i<count($ary); $i++) {
    $ip=$ary[$i]['ip'];
    $name=$ary[$i]['name'];
    $responseXML = file_get_contents('https://'.$ip.'/services/rest/V1/?method=authenticate&username='.$MYUSER.'&password='.$MYPASSWD);
    $status = getStatusNew($responseXML);
   
    //TA response success
    if (strcmp($status, "ok") == 0) {
    $thirdPartyData = simplexml_load_string($responseXML);
    $session_id = (string)$thirdPartyData->session_id;
    }
    
  if ( $type != "7" ){
    // running-config
   $url = 'https://'.$ip.'/services/rest/V1/?session_id='.$session_id.'&method=system.config-file.upload&file-type=running-config&protocol='.$protocol.'&port='.$port.'&host='.$REMOTE_SERVER.'&save-filename='.$name.'_runing-config_'.$date1.'.bk&file-format=text&username='.$MYUSER.'&password='.$MYPASSWD.'';
   $responseXML = file_get_contents($url);
    //system config
   echo $url3 = 'https://'.$ip.'/services/rest/V1/?session_id='.$session_id.'&method=system.config-file.upload&file-type=system&protocol='.$protocol.'&port='.$port.'&host='.$REMOTE_SERVER.'&save-filename='.$name.'_system-config_'.$date1.'.bk&file-format=text&username='.$MYUSER.'&password='.$MYPASSWD.'';
   $responseXML = file_get_contents($url3);
   }
   else {
   // running-config
   echo $url = 'https://'.$ip.'/services/rest/V1/?session_id='.$session_id.'&method=system.config-file.upload&file-type=running-config&protocol='.$protocol.'&port='.$port.'&host='.$REMOTE_SERVER.'&save-filename='.$name.'_runing-config_'.$date1.'.bk&file-format=text&username='.$MYUSER.'&password='.$MYPASSWD.'';
   $responseXML = file_get_contents($url);
   // startup-config backup
   echo $url2 = 'https://'.$ip.'/services/rest/V1/?session_id='.$session_id.'&method=system.config-file.upload&file-type=startup-config&protocol='.$protocol.'&port='.$port.'&host='.$REMOTE_SERVER.'&save-filename='.$name.'_startup-config_'.$date1.'.bk&file-format=text&username='.$MYUSER.'&password='.$MYPASSWD.'';
   $responseXML = file_get_contents($url2);
   //system config
   echo $url3 = 'https://'.$ip.'/services/rest/V1/?session_id='.$session_id.'&method=system.config-file.upload&file-type=system&protocol='.$protocol.'&port='.$port.'&host='.$REMOTE_SERVER.'&save-filename='.$name.'_system-config_'.$date1.'.bk&file-format=text&username='.$MYUSER.'&password='.$MYPASSWD.'';
   $responseXML = file_get_contents($url3);
   
   
   
  }
  // close session
  $responseXML = file_get_contents('https://'.$ip.'/services/rest/V1/?session_id='.$session_id.'&method=session.close');
  }
?>





