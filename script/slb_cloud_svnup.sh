#!/bin/bash
svn up /mnt/www/cloud_release $1 $2 # cloud.szprize.cn
echo 134
ssh -l root 10.174.10.50 "/bin/bash /mnt/script/cloud_svnup.sh $1 $2" # 134
echo 97
ssh -l root 10.51.58.70 "/bin/bash /mnt/script/cloud_svnup.sh $1 $2" # 97
echo 55
ssh -l root 10.45.151.40 "/bin/bash /mnt/script/cloud_svnup.sh $1 $2" # 55
echo 102
ssh -l root 10.25.113.171 "/bin/bash /mnt/script/cloud_svnup.sh $1 $2" # 102
