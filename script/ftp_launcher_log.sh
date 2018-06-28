#!/bin/bash
#先压缩再ftp上传
logsname=$(date -d "1 day ago" +"%y_%m_%d")
cd /mnt/www/launcher.szprize.cn/Application/Runtime/Logs/Zyp
ftpdir=$(hostname)
m=$(tar zcvf ./$logsname.log.tar.gz *$logsname*)
ftp -n<<!
open 210.21.222.202
user serverlog Szprize@2017
binary
cd /launcher
lcd /mnt/www/launcher.szprize.cn/Application/Runtime/Logs/Zyp
mkdir $ftpdir
prompt
put ./$logsname.log.tar.gz ./${ftpdir}/$logsname.log.tar.gz
close
bye
!
mv_tar=$(rm -rf ./$logsname.log.tar.gz)
mv_log=$(rm -rf *$logsname*)
