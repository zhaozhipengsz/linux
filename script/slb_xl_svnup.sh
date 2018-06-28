#!/bin/bash
svn up /mnt/www/sales $1 $2 # xl.szprize.cn
svn up /mnt/www/new_sales $1 $2

rm -f /mnt/www/sales/app/cache/*
rm -f /mnt/www/new_sales/app/cache/*

echo 97
ssh -l root 10.51.58.70 "/bin/bash /mnt/script/xl_svnup.sh $1 $2" # 97
echo 55
ssh -l root 10.45.151.40 "/bin/bash /mnt/script/xl_svnup.sh $1 $2" # 55
echo 102
ssh -l root 10.25.113.171 "/bin/bash /mnt/script/xl_svnup.sh $1 $2" # 102
