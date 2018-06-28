#!/bin/bash

# scp /alidata/server/nginx/conf/vhosts/$1 root@123.57.235.97:/alidata/server/nginx/conf/vhosts/$1

for arg in "$@"
do
	scp /alidata/server/nginx/conf/vhosts/$arg root@10.51.58.70:/alidata/server/nginx/conf/vhosts/$arg
done
