#!/bin/sh
#/opt/apache-tomcat-7.0.63/logs
find /mnt/tomcat-ins/appstore/logs/ -mtime +1 -name "*.*" -exec rm {} \;
find /mnt/tomcat-ins/appstore/logs/ -mtime -1 -name "*.out" -exec rm {} \;
find /mnt/apache-tomcat-7.0.63/logs/ -mtime +1 -name "*.*" -exec rm {} \;
find /mnt/apache-tomcat-7.0.63/logs/ -mtime +1 -name "*.out" -exec rm {} \;
find /mnt/log/nginx/bak -mtime +1 -name "*.*" -exec rm {} \;
find /mnt/log/nginx/access/bak -mtime +1 -name "*.*" -exec rm {} \;
find /mnt/log/appstore -mtime +1 -name "*.*" -exec rm {} \;
find /mnt/script/data/ -mtime +1 -name "*.*" -exec rm {} \;
find /mnt/script/log/ -mtime +1 -name "*.*" -exec rm {} \;
find /mnt/www/launcher.szprize.cn/Application/Runtime/Logs/ -mtime +1 -name "*.*" -exec rm {} \;
find /mnt/www/open.szprize.cn/Application/Runtime/Logs/ -mtime +1 -name "*.*" -exec rm {} \;
find /mnt/tomcat-ins/ics/logs/ -mtime -1 -name "*.out" -exec rm {} \;
find /mnt/tomcat-ins/ics/logs/ -mtime +1 -name "*.log" -exec rm {} \;
find /root/log/debug/ -mtime +3 -name "*.*" -exec rm {} \;
