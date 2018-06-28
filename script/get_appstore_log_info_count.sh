#!/bin/bash

DATE=$(date +%Y-%m-%d)
nginx_log="/mnt/log/nginx/access/appstore.szprize.cn.log"
tomcat_log="/mnt/apache-tomcat-7.0.63/logs/localhost_access_log.$DATE.txt"
api="/appstore/push/list"

#17/Apr/2016:08:43:17
DATE=$(date -d '-1 min' +%d/%b/%Y:%H:%M)
echo "nginx-1:"
cat "$nginx_log"|grep "$DATE"|wc -l
echo "tomcat-1:"
cat "$tomcat_log"|grep "$DATE"|wc -l
echo "nginx-1-api:"
cat "$nginx_log"|grep "$DATE"|grep "$api"|wc -l
echo "tomcat-1-api:"
cat "$tomcat_log"|grep "$DATE"|grep "$api"|wc -l

#17/Apr/2016:08:43:1
DATE=$(date -d '-10 min' +%d/%b/%Y:%H:%M)
DATE=${DATE%?}
echo "nginx-10:"
cat "$nginx_log"|grep "$DATE"|wc -l
echo "tomcat-10:"
cat "$tomcat_log"|grep "$DATE"|wc -l
echo "nginx-10-api:"
cat "$nginx_log"|grep "$DATE"|grep "$api"|wc -l
echo "tomcat-10-api:"
cat "$tomcat_log"|grep "$DATE"|grep "$api"|wc -l

#api
echo "nginx-api:"
cat "$nginx_log"|grep "$api"|wc -l
echo "tomcat-api:"
cat "$tomcat_log"|grep "$api"|wc -l

