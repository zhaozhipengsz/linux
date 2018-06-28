<?php
//定时去调用usp_imei_stat这个存储过程销量表

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
$row = $GLOBALS['db']->query('CALL usp_update_noise_word_searchbox');
if($row){
	$redis = new Redis();
	//$redis->connect('192.168.1.158', 6379);
	$redis->connect('101.200.187.142', 6379);
	//$redis->connect('10.51.58.70', 6379);
	$redis->auth('fNENPzes6Ndk5nElWFpSMAF1zE0bMb');
	$key = "fypadmin.szprize.cn#_Word_";
	foreach($row as $v){
		$data = $v['word'];
		$val = json_encode($data);
		$time = (int)(strtotime($v['end_time']) - time());
		if($time>0){
			$redis->setex($key.$v['id'],$time,$val);
		}
	}
}else{
	echo 'no data!';
}