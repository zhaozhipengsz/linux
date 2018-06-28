#!/bin/bash

echo "Usage: ./get_appstore_log_info_ip.sh [all|ip:113.116.66.35|api:/appstore/push/list] [n:50|date:2016-04-17] [txt] "

#cat /mnt/log/nginx/access/bak/appstore.szprize.cn_2016-04-17.log|grep 113.116.66.35>IP113.116.66.35_nginx_20160417_.txt
#cat /mnt/apache-tomcat-7.0.63/logs/localhost_access_log.2016-04-17.txt|grep 113.116.66.35>IP113.116.66.35_tomcat_20160417_.txt

c=$#
filter=""
date=""
txt=""
if [ $c -ge 1 ]; then
	filter=$1
fi
if [ $c -ge 2 ]; then
	date=$2
fi
if [ $c -ge 3 ]; then
	txt=$3
fi
DATE=$(date +%Y-%m-%d)

if [ "$filter" = "all" ]; then
	ip=""
	file=""
elif [ ! "$date" = "" ]; then
	ip=$1
	file=$(basename $ip)
else
	ip=""
	file=""
fi

if [ "$date" = "$DATE" ]; then
	nginx_log="/mnt/log/nginx/access/appstore.szprize.cn.log"
	tomcat_log="/mnt/apache-tomcat-7.0.63/logs/localhost_access_log.$DATE.txt"
	file_nginx="$file_$DATE_nginx.txt"
	file_tomcat="$file_$DATE_tomcat.txt"
elif [ ! "$date" = "" ]; then
	nginx_log="/mnt/log/nginx/access/bak/appstore.szprize.cn_$date.log"
	tomcat_log="/mnt/apache-tomcat-7.0.63/logs/localhost_access_log.$date.txt"
else
	nginx_log="/mnt/log/nginx/access/appstore.szprize.cn.log"
	tomcat_log="/mnt/apache-tomcat-7.0.63/logs/localhost_access_log.$DATE.txt"
fi

if [ "$ip" = "" ]; then
	if [ ! "$date" = "" ]; then
		echo "nginx:"
		tail "$nginx_log" -n $date
		echo "tomcat:"
		tail "$tomcat_log" -n $date
	else
		echo "nginx:"
		tail "$nginx_log"
		echo "tomcat:"
		tail "$tomcat_log"
	fi
elif [ "$txt" = "" ]; then
	echo "nginx:"
	cat "$nginx_log"|grep "$ip"|wc -l
	cat "$nginx_log"|grep "$ip"
	echo "tomcat:"
	cat "$tomcat_log"|grep "$ip"|wc -l
	cat "$tomcat_log"|grep "$ip"
else
	cat "$nginx_log"|grep "$ip">$file_nginx
	cat "$tomcat_log"|grep "$ip">$file_tomcat
fi


