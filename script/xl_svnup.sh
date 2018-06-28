#!/bin/bash
svn up /mnt/www/sales $1 $2 # xl.szprize.cn
svn up /mnt/www/new_sales $1 $2

rm -f /mnt/www/sales/app/cache/*
rm -f /mnt/www/new_sales/app/cache/*
