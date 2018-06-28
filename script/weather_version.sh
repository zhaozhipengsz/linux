#!/bin/sh
host="http://pj.szprize.cn"

t=$(date +%s)
key="project_auto_check20!*"
sign=$(echo -n "$t$key"|md5sum|cut -d ' ' -f1)
url="&t=$t&sign=$sign"

m=$(curl -s "$host/PJset.php?type=141&weather_type=1$url")
if [ "$m" == "1" ]
then
    cd /mnt/script
    ./slb_weather_svnup.sh -r 152
    php /mnt/www/weather.szprize.cn/clearRedis.script.php  All  d
elif [ "$m" == "2" ]
then
    cd /mnt/script
   ./slb_weather_svnup.sh
   php /mnt/www/weather.szprize.cn/clearRedis.script.php  All  d
fi


