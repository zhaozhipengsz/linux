<?php

define('ROOT_PATH', str_replace('\\', '/', __DIR__));

require_once(ROOT_PATH ."/library/MysqliDb.php");

$db = MysqliDb::getInstance();
if(!$db) {
    /*$db = new MysqliDb (Array (
        'host' => '192.168.1.34',
        'username' => 'root',
        'password' => 'root',
        'db'=> 'zyp',
        'port' => 3306,
        'prefix' => '',
        'charset' => 'utf8'
    ));*/
	$db = new MysqliDb (Array (
        'host' => 'rm-2zey38yp493b4mc08.mysql.rds.aliyuncs.com',
        'username' => 'prize',
        'password' => 'qazwsxedcA741852963',
        'db'=> 'zyp_test',
        'port' => 3306,
        'prefix' => '',
        'charset' => 'utf8'
    ));
}
$GLOBALS['db'] = $db;
$row = $GLOBALS['db']->query('CALL usp_update_noise_word_allsearch');
if($row){
	$redis = new Redis();
	//$redis->connect('192.168.1.158', 6379);
	$redis->connect('101.200.187.142', 6379);
	//$redis->connect('10.51.58.70', 6379);
	$redis->auth('fNENPzes6Ndk5nElWFpSMAF1zE0bMb');
	$key = "fypadmin.szprize.cn#_AllWord_";
	foreach($row as $k=>$v){
		$data[$k]['id'] = $v['id'];
        $data[$k]['word'] = $v['word'];
        $data[$k]['url'] = 'http://m.so.com/s?src=home&srcg=cs_boruizhiheng_3&q='.urlencode($v['word']);
        $data[$k]['sort'] = (int)$k;
        $data[$k]['type'] = $v['show_type'];
        $data[$k]['tag'] = $v['tag'];
        $data[$k]['color'] = ($v['show_type'] == 0)?$v['show_color']:'#FF0000';
		$data[$k]['source'] = 1;
		$val = json_encode($data);
		$time = (int)(strtotime($v['end_time']) - time());
		if($time>0){
			$redis->setex($key.$v['id'],$time,$val);
		}
	}
}else{
	echo 'no data!';
}