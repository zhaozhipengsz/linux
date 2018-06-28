<?php 
error_reporting(0);

ini_set('default_socket_timeout', 1);
$redis = new \Redis();
$redis->connect('192.168.1.158', 6379);
$redis->auth('fNENPzes6Ndk5nElWFpSMAF1zE0bMb');

$redis->subscribe(array('redisChat'),'subscribe');

function subscribe($redis, $chan, $msg){
   echo $msg;
}



//echo $result;
?>