#!/bin/bash
svn up /mnt/www/overwork $1 $2

rm -f /mnt/www/overwork/app/cache/*
