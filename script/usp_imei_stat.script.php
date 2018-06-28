<?php
//定时去调用usp_imei_stat这个存储过程销量表

define('ROOT_PATH', str_replace('\\', '/', __DIR__));

require_once(ROOT_PATH ."/library/MysqliDb.php");


if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
    define("TOKEN", "XiaJiaer");
    define("DB_IP", "192.168.1.34");
    define("DB_UR", "root");
    define("DB_PW", "root");
    define("DB_DN", "koobee");

} else {
    define("TOKEN", "XiaJiaer");
    define("DB_IP", "szprizecn.mysql.rds.aliyuncs.com");
    define("DB_UR", "prize");
    define("DB_PW", "szprize2015");
    define("DB_DN", "prize");
}


$db = MysqliDb::getInstance();
if(!$db) {
    $db = new MysqliDb (Array (
        'host' => DB_IP,
        'username' => DB_UR,
        'password' => DB_PW,
        'db'=> DB_DN,
        'port' => 3306,
        'prefix' => '',
        'charset' => 'utf8'
    ));

}
$GLOBALS['db'] = $db;

$row = $GLOBALS['db']->query('CALL usp_imei_stat');

?>