#!/bin/bash
sh all_svnup.sh

# 97 134 55 102
array=(10.51.58.70 10.174.10.50 10.45.151.40 10.25.113.171)
# echo ${#array[@]}
for i in ${array[@]}; do
	# ssh -l root 10.51.58.70 "/bin/bash /mnt/script/all_svnup.sh"
	ssh -l root $i "/bin/bash /mnt/script/all_svnup.sh"
done;
