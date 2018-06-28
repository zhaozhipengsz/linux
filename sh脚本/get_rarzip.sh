#!/bin/bash

##############################################   
# read apk info
# @author ELEI
# @time 26 Mar 2016 18:20:35  
##############################################
cd /home/android/autochecktest
type="66"
#host="http://192.168.1.78:6058"
#host="http://pj.szprize.cn"
host="http://192.168.1.228:5010"
#host="http://192.168.1.85:8084"

fgf=","
DATE=$(date +%Y%m%d%H%M%S)
#t=$(date -d '-6 min' +%s)
t=$(date +%s)
key="project_auto_check20!*"
sign=$(echo -n "$t$key"|md5sum|cut -d ' ' -f1)
url="&t=$t&sign=$sign"

status="$host/PJset.php?type=$type&op=getCheckStatus$url"
result=$(curl -s $status)
if [ "$result" = "请求非法，请检查后再次请求" ]; then
	echo 1
	exit
fi

r3=$(echo $result|cut -d "$fgf" -f3)
uselib="uselib.txt"
if [ ! "$r3" = "0" ]; then
	liburl="$host/PJset.php?type=$type&op=getUsedLibInfo$url"
	m=$(wget $liburl -O "$uselib.tmp")
	m=$(mv -f "$uselib.tmp" $uselib)
fi

r4=$(echo $result|cut -d "$fgf" -f4)
packagelib="packagelib.txt"
if [ ! "$r4" = "0" ]; then
	packageurl="$host/PJset.php?type=$type&op=getPackageLibInfo$url"
	m=$(wget $packageurl -O "$packagelib.tmp")
	m=$(mv -f "$packagelib.tmp" $packagelib)
fi

r2=$(echo $result|cut -d "$fgf" -f2)
apkInfo="apkInfo.txt"
if [ ! "$r2" = "0" ] || [ ! -f $apkInfo ]; then
	apkurl="$host/PJset.php?type=$type&op=getAPKLibInfo$url"
	m=$(wget $apkurl -O "$apkInfo.tmp")
	m=$(mv -f "$apkInfo.tmp" $apkInfo)
fi

r1=$(echo $result|cut -d "$fgf" -f1)
if [ ! "$r1" = "0" ]; then
	rarzip="rarzip/rarzip$DATE.txt"
	rarurl="$host/PJset.php?type=$type&op=getCheckInfo$url"
	m=$(wget $rarurl -O $rarzip)
	if [ ! `cat $rarzip|wc -l` = "0" ]; then
		m=$(./startCheck.sh $rarzip)
	fi
fi

r5=$(echo $result|cut -d "$fgf" -f5)
if [ ! "$r5" = "0" ]; then
	rarzip="rarzip/rarzipOTA$DATE.txt"
	rarurl="$host/PJset.php?type=63&op=apiPullOta$url"
	m=$(wget $rarurl -O $rarzip)
	if [ ! `cat $rarzip|wc -l` = "0" ]; then
		m=$(./startCheckOTA.sh $rarzip)
	fi
fi

#echo "OK"

