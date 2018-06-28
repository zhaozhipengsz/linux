#!/bin/bash
# svn up /mnt/www/launcher.szprize.cn $1 $2
echo 101.201.102.15
ssh -l root 10.174.13.48 "/bin/bash /mnt/script/launcher_svnup.sh $1 $2"
echo 101.201.197.239
ssh -l root 10.174.12.73 "/bin/bash /mnt/script/launcher_svnup.sh $1 $2"
echo 101.201.100.44
ssh -l root 10.174.9.178 "/bin/bash /mnt/script/launcher_svnup.sh $1 $2"
echo 101.201.100.252
ssh -l root 10.25.113.26 "/bin/bash /mnt/script/launcher_svnup.sh $1 $2"
