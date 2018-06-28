#!/bin/bash
svn up /mnt/www/weather.szprize.cn $1 $2
echo 115
ssh -l root 10.26.242.193 "/bin/bash /mnt/script/weather_svnup.sh $1 $2" # 115
echo 100
ssh -l root 10.26.242.166 "/bin/bash /mnt/script/weather_svnup.sh $1 $2" # 100
echo 151
ssh -l root 10.26.242.174 "/bin/bash /mnt/script/weather_svnup.sh $1 $2" # 151
echo 226
ssh -l root 10.25.133.237 "/bin/bash /mnt/script/weather_svnup.sh $1 $2" # 226
echo 208
ssh -l root 10.25.133.215 "/bin/bash /mnt/script/weather_svnup.sh $1 $2" # 208
echo 35
ssh -l root 10.174.12.115 "/bin/bash /mnt/script/weather_svnup.sh $1 $2" # 35
echo 239
ssh -l root 10.174.12.73 "/bin/bash /mnt/script/weather_svnup.sh $1 $2" #239
