#!/bin/sh
#自动检测应用中心的状态，如果不建康就自动重启
appstore_exec="/mnt/script/appstore_restart.sh" #//重启appstore的脚本
music_exec="/mnt/script/music_restart.sh" #//重启music脚本
check_exec="/mnt/script/check_appstore.php"

run_logs="/mnt/script/data/run_logs.log"
#检查自己是已经启动
count=`ps -ef | grep check_appstore.php | grep -v "grep" | wc -l`

if [ $count -eq 0 ]; then
	status=$(/alidata/server/php/bin/php /mnt/script/check_appstore.php | tr '\n' ' ')  #`php $check_exec`
	#echo $status
	if [ $status -eq 1 ]; then
	    #echo $appstore_exec
                date >> ${run_logs}
		${appstore_exec} >> ${run_logs}
	elif [ $status -eq 2 ]; then
	    #echo $music_exec
                date >> ${run_logs}
		${music_exec} >> ${run_logs}
	else
		#echo $status
            r=1
	fi
else 
	#echo "alerdy running ....."
	exit 1 
fi  
