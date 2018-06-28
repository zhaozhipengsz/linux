<?php
define('ROOT_PATH', str_replace('\\', '/', __DIR__));
require_once(ROOT_PATH ."/library/Curl.class.php");

$params_data = array(
            'devid'=>'862613123121490',
            'imei'=>'862613123121490',
            'imsi'=>'unknown',
            'network_type'=>'wifi',
            'forward'=>0,//$forward,//待传
            'chlid'=>'news_news_top',
            'lon'=>0,
            'lat'=>0,
            'page'=>1,
            'cnt'=>100,
            'refer'=>'openapi_for_rcmkubitianqi',
            'appkey'=>'ff5c34fa7fbe248971b0ed1abe4cfa2c',
        );
$url = 'http://openapi.inews.qq.com/getQQNewsUnreadList?devid='.$params_data['devid'].'&refer=openapi_for_rcmkubitianqi&appkey=ff5c34fa7fbe248971b0ed1abe4cfa2c&cnt='.$params_data['cnt'];
$curl = new Curl($url);

$res = $curl->getDataByCurl($url,true,$params_data);
$data = array();


if($res['ret'] == 0 && count($res['newslist']) == $params_data['cnt']){
	$redis = new Redis();
	$redis->connect('10.51.58.70', 6379);
	$redis->auth('fNENPzes6Ndk5nElWFpSMAF1zE0bMb');
	$key = "feedapi::NewList::TX";
	$result = $redis->set($key,json_encode($res['newslist']));
	if($result){
		echo "OK";
	}
}else{
	echo "NO";
}

