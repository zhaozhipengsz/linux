#!/bin/bash
#先压缩再ftp上传
logsname=$(date -d "1 day ago" +"%y_%m_%d")
cd /mnt/www/launcher.szprize.cn/Application/Runtime/Logs/Zyp
echo $logsname
ftpdir=hostname
m=$(tar zcvf ./$logsname.log.tar.gz *$logsname*)
ftp -n<<!
open 210.21.222.202
user serverlog Szprize@2017
binary
cd /
lcd /mnt/www/launcher.szprize.cn/Application/Runtime/Logs/Zyp
prompt
put ./$logsname.log.tar.gz ./$logsname.log.tar.gz
close
bye
!

