#!/bin/bash
svn up /mnt/www/overwork $1 $2
rm -f /mnt/www/overwork/app/cache/*

echo 97
ssh -l root 10.51.58.70 "/bin/bash /mnt/script/oa_svnup.sh $1 $2" # 97
echo 55
ssh -l root 10.45.151.40 "/bin/bash /mnt/script/oa_svnup.sh $1 $2" # 55
echo 102
ssh -l root 10.25.113.171 "/bin/bash /mnt/script/oa_svnup.sh $1 $2" # 102
