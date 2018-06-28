#!/bin/bash
svn up /mnt/www/launcher.szprize.cn $1 $2
rm -f /mnt/www/launcher.szprize.cn/Application/Runtime/*.php
