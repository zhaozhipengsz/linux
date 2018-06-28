<?php
//定时去调usp_update_channel这个存储过程

define('ROOT_PATH',str_replace('\\','/',__DIR__));

require_once(ROOT_PATH."/library/MysqliDb.php");


$channel = (int)@$argv[1];
if(empty($channel)){
	echo "请输入百度渠道号!";exit;
}

$is_local = 0;

if($is_local){
    define("DB_IP", "192.168.1.34");
    define("DB_UR", "root");
    define("DB_PW", "root");
    define("DB_DN", "zyp");
}else{
	define("DB_IP", "rm-2zey38yp493b4mc08.mysql.rds.aliyuncs.com");
    define("DB_UR", "prize");
    define("DB_PW", "qazwsxedcA741852963");
    define("DB_DN", "zyp");
}

$db = MysqliDb::getInstance();
if(!$db) {
    $db = new MysqliDb (Array (
        'host' => DB_IP,
        'username' => DB_UR,
        'password' => DB_PW,
        'db'=> DB_DN,
        'port' => 3306,
        'prefix' => 'zyp_',
        'charset' => 'utf8'
    ));

}
$GLOBALS['db'] = $db;

$row = $GLOBALS['db']->query('CALL usp_update_channel('.$channel.')');