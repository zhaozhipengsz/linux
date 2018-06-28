<?php
define('ROOT_PATH', str_replace('\\', '/', __DIR__));
require_once(ROOT_PATH ."/library/Curl.class.php");

$token_url = 'http://launcher.szprize.cn/zyp/card/getBaiduToken';
$curl = new Curl($token_url);
$token = $curl->exec();
$token = trim($token,'\"');

$url = 'http://cpu-openapi.baidu.com/api/v2/data/list';

$timestamp = time();
$request_params = array(
    'appsid' => 'd00232ff',
    'timestamp' => $timestamp,
    'data' => array(
        'contentParams' => array(
            'pageSize' => 15,
            'pageIndex' => 1,
            'adCount' => 0,
            'catIds' => array(1001,1011,1012,1016,1019,1020,1021,1031),
        ),
        'device' => array(
            'deviceType' => '1',
            'osType' => '1',
            'osVersion' => '6.0',
            'vendor' => 'koobee',
            'model' => 'bc0968200887824ae56048f7100c7508',
            'udid' => array(
                'imei' => '862613123121532',
                'imeiMd5' => '364ca309fcfbd30d68b8b04791019026',
            ),
        ),
        'network' => array(
            'ipv4' => '127.0.0.1',
            'connectionType' => 3,
            'operatorType' => 0,
        )
    ),
    'token' => $token
);
$string = json_encode($request_params['data']);
$signature = md5($timestamp.$token.$string);
$request_params['signature'] = $signature;
$params_string = json_encode($request_params);
$newsArr = $curl->getDataByCurl($url,true,$params_string);

if($newsArr['baseResponse']['code'] == 200){
    $resDatas = $newsArr['items'];
    if(is_array($resDatas)){
        foreach($resDatas as $k=>$v){
            $row = json_decode($v['data'],true);
            if($row) {
                $data[$k]['id'] = substr($row['id'],0,8);
                $data[$k]['imageUrl'] = $row['images'][0];
                $data[$k]['title'] = $row['title'];
                $data[$k]['src'] = $row['source'];
                $data[$k]['surl'] = $row['detailUrl'];
                $data[$k]['time'] = $row['updateTime'];
                $data[$k]['timeFormat']=null;
            }
        }
    }
	$redis = new Redis();
	//$redis->connect('192.168.1.158', 6379);
	//$redis->connect('101.200.187.142', 6379);
	$redis->connect('10.51.58.70', 6379);
	$redis->auth('fNENPzes6Ndk5nElWFpSMAF1zE0bMb');
	$key = "fypadmin.szprize.cn#_NewList";
	$result = $redis->set($key,json_encode($data));
	if($result){
		echo "OK";
	}
}else{
	echo "NO";
}
