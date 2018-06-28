#!/bin/sh
host="http://pj.szprize.cn"

t=$(date +%s)
key="project_auto_check20!*"
sign=$(echo -n "$t$key"|md5sum|cut -d ' ' -f1)
url="&t=$t&sign=$sign"

m=$(curl -s "$host/PJset.php?type=141&weather_type=1$url")
echo $m
if [ $m == "1" ]
then
    ./slb_weather_svnup.sh -r 152
    php /mnt/www/weather.szprize.cn/clearRedis.script.php  All  d
else
   ./slb_weather_svnup.sh
fi
m=$(curl -s "$host/PJset.php?type=141&weather_type=0$url")

