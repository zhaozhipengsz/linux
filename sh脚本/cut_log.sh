#!/bin/bash
## 零点执行该脚本

## Nginx日志文件所在的目录
LOGE_PATH=/mnt/log/nginx
LOGA_PATH=/mnt/log/nginx/access

## 首次运行创建Nginx日志备份目录
LOGE_BAK=/mnt/log/nginx/bak
LOGA_BAK=/mnt/log/nginx/access/bak
if [ ! -d "$LOGE_BAK" ]; then
        m=$(mkdir "$LOGE_BAK")
fi
if [ ! -d "$LOGA_BAK" ]; then
        m=$(mkdir "$LOGA_BAK")
fi

## 设置pid文件
PID_PATH=/alidata/server/nginx/logs/nginx.pid

## 获取昨天的 yyyy-MM-dd
YESTERDAY=$(date -d "yesterday" +%Y-%m-%d)

## 移动error日志
for file_e  in ${LOGE_PATH}/*.log
do
        mv ${LOGE_PATH}/${file_e##*/}  ${LOGE_BAK}/$(basename $file_e .log)_${YESTERDAY}.log
done

## 移动access日志
for file_a in ${LOGA_PATH}/*.log
do
        mv ${LOGA_PATH}/${file_a##*/} ${LOGA_BAK}/$(basename $file_a .log)_${YESTERDAY}.log
done

## 向nginx主进程发信号重新打开日志
kill -USR1 `cat ${PID_PATH}`
