<?php
$root_path = str_replace('\\', '/', __DIR__);
//$appstore_url = 'http://appstore.szprize.cn/appstore/api/test';
//$music_url = 'http://music.szprize.cn/music/api/test';
$appstore_url = 'http://127.0.0.1:8080/appstore/api/test';
$music_url = 'http://127.0.0.1:8081/music/api/test';

$pid = $root_path . '/data/check_appstore.pid';//进程唯一标识
$records_path = $root_path . '/data/error_records.txt';//记录运行的一些状态信息
$log_path = $root_path . '/data/restart_tomcat.log';//日志文件

$debugg_logs = $root_path . '/data/debug.log';//日志文件

$sh_appsotre = "/mnt/script/appstore_restart.sh";//重启appstore的脚本
$sh_music = "/mnt/script/music_restart.sh";//重启music脚本


$error_count = 3;
//检测程序是否已经在运行
/*if (file_exists($pid)) {
    echo "this script is already runing.....";
    exit;
} else {
    $fp = fopen($pid, "w");
    fclose($fp);
    }*/

$status = 0;//0-不执行命令 1-更新appstore 2-更新music
//初始化反加非200的记录
$records = array();
if (file_exists($records_path)) {
    $json_str = file_get_contents($records_path);
    if ($json_str) {
        $records = json_decode($json_str, true);
    } else {
        $records['appstore'] = 0;
        $records['muscis'] = 0;
    }
} else {
    $records['appstore'] = 0;
    $records['muscis'] = 0;
}


//file_put_contents($debugg_logs, "getHttpCode 1begin " . date('Y-m-d H:i:s'). "\n", FILE_APPEND);
$ret = getHttpCode($appstore_url);
//file_put_contents($debugg_logs, "getHttpCode 1end " . date('Y-m-d H:i:s'). "\n", FILE_APPEND);
//var_dump($ret);
//var_dump($ret !== 200);
//die();
if ($ret !== 200) {
    $records['appstore']++;
    if ($records['appstore'] >= $error_count) {
        //重启
        //$status = null;
        //system("/bin/bash $sh_appsotre",$status);
        //$status = exec('/bin/bash $sh_appsotre');
        $records['appstore'] = -10;
        $str_msg = date('Y-m-d H:i:s') . "\t" . '重启appstore' . "\t $status \n";
        //file_put_contents($log_path, $str_msg, FILE_APPEND);
        $status = 1;

        //记录状态
        $json_str = json_encode($records);
        //file_put_contents($records_path, $json_str);

        //删除进程文件
        //unlink($pid);
        echo $status;
        exit;

    }
    //重启
} else {
    $records['appstore'] = 0;
}

//file_put_contents($debugg_logs, "getHttpCode 2begin " . date('Y-m-d H:i:s'). "\n", FILE_APPEND);
$ret = getHttpCode($music_url);
//file_put_contents($debugg_logs, "getHttpCode 2end " . date('Y-m-d H:i:s'). "\n", FILE_APPEND);

if ($ret !== 200) {
    $records['muscis']++;
    if ($records['muscis'] >= $error_count) {
        //重启
        //$status = null;
        //system("/bin/bash $sh_music",$status);
        //$status = exec('/bin/bash $sh_appsotre');
        $records['muscis'] = -10;
        $str_msg = date('Y-m-d H:i:s') . "\t" . '重启music' . "\t$status\n";
        //file_put_contents($log_path, $str_msg, FILE_APPEND);
        $status = 2;

        //记录状态
        $json_str = json_encode($records);
        //file_put_contents($records_path, $json_str);

        //删除进程文件
        //unlink($pid);
        echo $status;
        exit;

    }
    //重启
} else {
    $records['muscis'] = 0;
}


//记录状态
$json_str = json_encode($records);
//file_put_contents($records_path, $json_str);

//删除进程文件
//unlink($pid);
echo $status;
exit;

//检测连接返回码
//@Param $url string 要检测的地址
//@return int http 状态码
function getHttpCode($url)
{

    $ch = curl_init ();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_TIMEOUT, 200);
    curl_setopt($ch, CURLOPT_HEADER, FALSE);
    curl_setopt($ch, CURLOPT_NOBODY, FALSE);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, FALSE);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'GET');

    curl_exec($ch);
    $httpCode = curl_getinfo($ch,CURLINFO_HTTP_CODE);
    curl_close($ch);
    return $httpCode;
}

?>