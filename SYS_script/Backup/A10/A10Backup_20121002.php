<?php
#################################################
#
#
#    carated date 20121002
#    script by vincent yu
#    for A10 backup script
#    verson 3.0
#################################################
include("config.inc");

function getStatusNew($XMLResult) {
   preg_match('/<response status="(.+)"[\s]?[\/]?>/', $XMLResult, $matches);
   return isset($matches) ? $matches[1] : '';
}
function getStatusSESSION($XMLResult) {
   $data = simplexml_load_string($XMLResult);
   $ssid = (string)$data->session_id;
   return $ssid;
}
function Exec_CURL($url){
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, $url);
  curl_setopt ($ch, CURLOPT_HEADER, 0);
  curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 1);
  curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
  $response = curl_exec($ch);
  curl_close($ch);
  return $response;

}
function get_session($ip,$MYUSER,$MYPASSWD){
  $url = 'https://'.$ip.'/services/rest/V1/?method=authenticate&username='.$MYUSER.'&password='.$MYPASSWD.'';
  $Newresponse = Exec_CURL($url);
  $status = getStatusNew($Newresponse);
  if ( $status == "ok" ){
   $session_id=getStatusSESSION($Newresponse);
   echo "SESSION ID : $session_id";
   echo "\n";
   }else{
     $session_id="0";
  }
  return $session_id;
}
function Close_Session($ip,$session_id){
  $url='https://'.$ip.'/services/rest/V1/?session_id='.$session_id.'&method=session.close';
  $Newresponse = Exec_CURL($url);
  $status = getStatusNew($Newresponse);
  echo  "closeed session status : $status";
  echo "\n";
}
function Backup($type,$session_id,$ip,$protocol,$port,$REMOTE_SERVER,$REUSER,$REPASSWD,$name,$date1){
   if ( $type != "7" ){
    // running-config
   $url = 'https://'.$ip.'/services/rest/V1/?session_id='.$session_id.'&method=system.config-file.upload&file-type=running-config&protocol='.$protocol.'&port='.$port.'&host='.$REMOTE_SERVER.'&save-filename='.$name.'_runing-config_'.$date1.'.bk&file-format=text&username='.$REUSER.'&password='.$REPASSWD.'';
   echo "running config: $url";
   echo "\n";
   $Newresponse = Exec_CURL($url);
   $status = getStatusNew($Newresponse);
   echo  "Running config status : $status";
   echo "\n";
   //system config
   echo $url = 'https://'.$ip.'/services/rest/V1/?session_id='.$session_id.'&method=system.config-file.upload&file-type=system&protocol='.$protocol.'&port='.$port.'&host='.$REMOTE_SERVER.'&save-filename='.$name.'_system-config_'.$date1.'.bk&file-format=text&username='.$REUSER.'&password='.$REPASSWD.'';
   $Newresponse = Exec_CURL($url);
   $status = getStatusNew($Newresponse);
   echo  "system config status : $status";
   echo "\n"; 
   }else {
   // running-config
   echo $url = 'https://'.$ip.'/services/rest/V1/?session_id='.$session_id.'&method=system.config-file.upload&file-type=running-config&protocol='.$protocol.'&port='.$port.'&host='.$REMOTE_SERVER.'&save-filename='.$name.'_runing-config_'.$date1.'.bk&file-format=text&username='.$REUSER.'&password='.$REPASSWD.'';
   $Newresponse = Exec_CURL($url);
   $status = getStatusNew($Newresponse);
   echo  "Running config status : $status";
   echo "\n";
   // startup-config backup
   echo $url2 = 'https://'.$ip.'/services/rest/V1/?session_id='.$session_id.'&method=system.config-file.upload&file-type=startup-config&protocol='.$protocol.'&port='.$port.'&host='.$REMOTE_SERVER.'&save-filename='.$name.'_startup-config_'.$date1.'.bk&file-format=text&username='.$REUSER.'&password='.$REPASSWD.'';
   $Newresponse = Exec_CURL($url);
   $status = getStatusNew($Newresponse);
   echo  "startup config status : $status";
   echo "\n";
   //system config
   echo $url3 = 'https://'.$ip.'/services/rest/V1/?session_id='.$session_id.'&method=system.config-file.upload&file-type=system&protocol='.$protocol.'&port='.$port.'&host='.$REMOTE_SERVER.'&save-filename='.$name.'_system-config_'.$date1.'.bk&file-format=text&username='.$REUSER.'&password='.$REPASSWD.'';
   $Newresponse = Exec_CURL($url);
   $status = getStatusNew($Newresponse);
   echo  "system config status : $status";
   echo "\n";  
  }
}
$date1 = date("Ymd");
$type= date("N");
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
    $session_id = get_session($ip,$MYUSER,$MYPASSWD);
	
   if ( $session_id == "0" ){
     break;
   }else{
     Backup($type,$session_id,$ip,$protocol,$port,$REMOTE_SERVER,$REUSER,$REPASSWD,$name,$date1);
     Close_Session($ip,$session_id);
   }
}

?>

