#!/bin/bash

##############################################   
# read apk info
# @author ELEI
# @time 26 Mar 2016 18:20:35  
##############################################
cd /home/android/autochecktest
OLDIFS=$IFS
IFS=$'\n'

type="66"
#host="http://pj.szprize.cn"
host="http://192.168.1.228:5010"

app_list_path="apk_list.txt" #记录appk列表信息
#new_url='http://192.168.1.78:6058/PJset.php'
new_url="$host/PJset.php"
php_url="http://192.168.1.228:5010/PJset.php"

path_info="type=66&op=putApkInfo"

if [ $# -gt 0 ]; then
	rarzip=$1
else
	rarzip=rarzip.txt
	IFS=$OLDIFS
	exit
fi

#t=$(date -d '-6 min' +%s)
t=$(date +%s)
key="project_auto_check20!*"
sign=$(echo -n "$t$key"|md5sum|cut -d ' ' -f1)
url="&t=$t&sign=$sign"

tpf=","
dPath="txt/"
tmp_apk="apk"
tmp_apk_dir="apk_dir"
tmp_mnt_dir="mnt_dir"
rarzipFail=rarzipFail.txt
apkInfo=apkInfo.txt
uselib=uselib.txt
packagelib=packagelib.txt
#path_ftp="../myshare/szprize/"
path_ftp="/home/android/myshare/temp1/"
#path_ftp="/home/android/myshare/szprize/"
#path="../myshare/temp/"
#path="/home/android/myshare/temp/"
path="/home/android/myshare/szprize/"
for row in `cat $rarzip`
do
	id=$(echo $row|cut -d "$tpf" -f1)
	kb=$(echo $row|cut -d "$tpf" -f2)
	purpose=$(echo $row|cut -d "$tpf" -f3)
	f=$(echo $row|cut -d "$tpf" -f4)
	pv=$(echo $row|cut -d "$tpf" -f5)
	cs=$(echo $row|cut -d "$tpf" -f6)
	#KB:dido_OS,dido_CMCC;KS:;
	utype=$(echo $row|cut -d "$tpf" -f7)

	if [ "$pv" = "" ]; then
		pv="PR"
	fi	
	if [ "$cs" = "" ]; then
		cs="15"
	fi

	f=${f//\\/\/}
	#f=${f//' '/\\" "}
	name=$(basename $f)
	name="${name%.*}"
	ext="${f##*.}"
	
	dir="${f%/*}"
	dir_ftp="$path_ftp$dir"
	projuselib="$name/projuselib.txt"

	f_ftp="$path_ftp$f"
	f="$path$f"
	check_pass="3"
	check_fail_str=""
	mp_ver=$(echo $purpose|grep "量产"|wc -l)
	if [ "$mp_ver" = "0" ]; then
		mp_ver=$(echo $purpose|grep "PVT"|wc -l)
	fi

	t=$(date +%s)
	sign=$(echo -n "$t$key"|md5sum|cut -d ' ' -f1)
	url="&t=$t&sign=$sign"

	#临时目录不存在 并且 正式目录不存在，则返回4:文件不存在
	#if [ ! -f "$f" ] && [ ! -f "$f_ftp" ]; then
	if [ -f "$f_ftp" ]; then
		m=$(curl -s "$host/PJset.php?type=$type&op=putCheckRep&id=$id&kb=$kb&status=3$url")
		echo "f_ftp file is OK"
		continue
	elif [ -f "$f" ]; then
		echo "file is OK"
	else
		echo $f>>$rarzipFail
		echo "file is error"
		#m=$(curl -s "$host/PJset.php?type=$type&op=putCheckRep&id=$id&kb=$kb&status=4$url")
		continue
	fi

	#检查360 OS版本，CPB扩展名
	os360="0"
	os360_flag="CPB"
	if echo "$name." | grep "\.$os360_flag\.">/dev/null; then
		if [ "$ext" = "rar" ]; then
			if unrar v "$f" | grep "system.img">/dev/null; then
				os360="2"
			elif unrar v "$f" | grep "\.$os360_flag">/dev/null; then
				os360="1"
			else
				os360="3"
			fi
		else
			if unzip -l "$f" | grep "system.img">/dev/null; then
				os360="4"
			elif unzip -l "$f" | grep "\.$os360_flag">/dev/null; then
				os360="1"
			else
				os360="5"
			fi
		fi
	else
		os360="0"
	fi
	t=$(date +%s)
	sign=$(echo -n "$t$key"|md5sum|cut -d ' ' -f1)
	url="&t=$t&sign=$sign"
	if [ $os360 = "1" ]; then
		if [ "$cs" = "1" ]; then
			echo "mv file"
			#m=$(mkdir "$dir_ftp" -p)
			#m=$(mv -f "$f" "$f_ftp")
			#m=$(cp -f "$f" "$f_ftp")
			#m=$(rm -fr "$f")
			m=$(curl -s "$host/PJset.php?type=$type&op=putCheckRep&id=$id&kb=$kb&status=3$url")
		else
			m=$(curl -s "$host/PJset.php?type=$type&op=putCheckRep&id=$id&kb=$kb&status=17$url")
		fi
		continue
	elif [ $os360 = "0" ]; then
		echo ""
	else
		m=$(curl -s "$host/PJset.php?type=$type&op=putCheckRep&id=$id&kb=$kb&status=5$url")
		continue
	fi

	if [ "$ext" = "rar" ]; then
		#result=$(unrar x "$f" "$name/system.img")
		result=$(unrar e "$f" "*/system.img" "$name/")
	else
		result=$(unzip "$f" "$name/system.img")
	fi
	if [ ! -f "$name/system.img" ]; then
		echo $f>>$rarzipFail
		m=$(curl -s "$host/PJset.php?type=$type&op=putCheckRep&id=$id&kb=$kb&status=5$url")
		continue
	fi
	filetype=$(file "$name/system.img"|grep ": data"|wc -l)
	if [ "$filetype" = "0" ]; then
		result=$(mv "$name/system.img" "$name/system.img.ext4")
	else
		result=$(simg2img "$name/system.img" "$name/system.img.ext4")
	fi
	if [ ! -f "$name/system.img.ext4" ]; then
		echo $f>>$rarzipFail
		m=$(curl -s "$host/PJset.php?type=$type&op=putCheckRep&id=$id&kb=$kb&status=6$url")
		continue
	fi
	result=$(rm -fr "$name/system.img")
	result=$(mkdir "$name/$tmp_apk")
	result=$(mkdir "$name/$tmp_apk_dir")
	result=$(mkdir "$name/$tmp_mnt_dir")
	result=$(mount -t ext4 -o loop "$name/system.img.ext4" "$name/$tmp_mnt_dir")
	result=$(cp `find "$name/$tmp_mnt_dir/" -name *.apk` "$name/$tmp_apk/")
	result=$(cp -r "$name/$tmp_mnt_dir/build.prop" "$name/")
	result=$(cp -r "$name/$tmp_mnt_dir/app/" "$name/$tmp_apk_dir/")
	result=$(cp -r "$name/$tmp_mnt_dir/priv-app/" "$name/$tmp_apk_dir/")
	result=$(cp -r "$name/$tmp_mnt_dir/vendor/" "$name/$tmp_apk_dir/")
	#result=$(cp -r "$name/$tmp_mnt_dir/framework/" "$name/$tmp_apk_dir/")
	result=$(umount "$name/$tmp_mnt_dir")
	result=$(rm -fr "$name/system.img.ext4")
	result=$(rm -fr "$name/$tmp_mnt_dir")
	result=$(echo '' > $projuselib)


	#读取项目名
	#project_name_tmp=$(cat $name/build.prop | grep "ro.build.display.id=")
	#project_name=${project_name_tmp##*=}
	project_name=$(cat "$name/build.prop" | grep "ro.build.display.id=" | awk -F'=' '{print $2}')
	customer_name=$(cat "$name/build.prop" | grep "ro.prize_customer=" | awk -F'=' '{print $2}')
	project_ver=$(cat "$name/build.prop" | grep "ro.prize.project.ver=" | awk -F'=' '{print $2}')
	project_name_len=$(echo "$project_name" | grep -o '.' | wc -l)
	project_name_dot=$(echo "$project_name" | grep -o '\.' | wc -l)
	project_name_1=$(echo "$project_name" | awk -F'.' '{print $1}')
	project_name_2=$(echo "$project_name" | awk -F'.' '{print $2}')
	project_name_3=$(echo "$project_name" | awk -F'.' '{print $3}')
	name_2=$(echo "$name" | awk -F'.' '{print $2}')
	prefix="PJ_"

	#版本名检查
	set_status="0"
	set_no_yz_pass="0"
	if [ "$kb" = "KB" ]; then
		prefix="koobee,$prefix"
		if [ "$utype" = "dido_OS" ]; then
			prefix="DIDO,$prefix"
		elif [ "$utype" = "dido_CMCC" ]; then
			prefix="CMCC,$prefix"
		fi
		if [ "$customer_name" = "koobee" ]; then
			echo $project_name_1
			project_name_1=$(echo $project_name_1 | tr '[a-z]' '[A-Z]' | awk -F'_' '{print $1}')
			echo $project_name_1
			match_uselib=",$prefix$project_name_1,"
			result=$(cat $uselib | grep "$match_uselib" | wc -l)
			if [ "$result" = "0" ]; then
				#set_no_yz_pass="1"
				#echo $match_uselib
				#read -p "Press any key to continue." var_pause
				m=$(cat $uselib | grep "$match_uselib" >> $projuselib)
			else
				m=$(cat $uselib | grep "$match_uselib" >> $projuselib)
				#m=$(cat $apkInfo | grep ",com.prize.appcenter,koobee," >> $projuselib)
			fi
		else
			set_status="7"
		fi
	elif [ "$kb" = "KS" ]; then
		prefix="coosea,$prefix"
		if [ "$customer_name" = "coosea" ]; then
			if [ "$project_name_2" = "$name_2" ]; then
				set_status="0"
				match_uselib=",$prefix$project_name_1,$project_name_2,$project_name_3,"
				result=$(cat $uselib | grep "$match_uselib" | wc -l)
				if [ "$result" = "0" ]; then
					match_uselib=",$prefix$pv,"
					result=$(cat $uselib | grep "$match_uselib" | wc -l)
					if [ "$result" = "0" ]; then
						set_no_yz_pass="1"
					else
						m=$(cat $uselib | grep "$match_uselib" >> $projuselib)
						m=$(cat $apkInfo | grep ",com.prize.appcenter,coosea," >> $projuselib)
					fi
				else
					m=$(cat $uselib | grep "$match_uselib" >> $projuselib)
					m=$(cat $apkInfo | grep ",com.prize.appcenter,coosea," >> $projuselib)
				fi
			else
				set_status="8"
			fi
		elif [ "$customer_name" = "odm" ]; then
			set_status="0"
			set_no_yz_pass="1"
		else
			set_status="7"
		fi
	elif [ "$kb" = "ODM" ]; then
		if [ "$customer_name" = "odm" ]; then
			set_status="0"
			set_no_yz_pass="1"
		else
			set_status="7"
		fi
	else
			set_status="7"
	fi
	t=$(date +%s)
	sign=$(echo -n "$t$key"|md5sum|cut -d ' ' -f1)
	url="&t=$t&sign=$sign"
	if [ ! "$set_status" = "0" ]; then
		result=$(rm -fr "$name")
		m=$(curl -s "$host/PJset.php?type=$type&op=putCheckRep&id=$id&kb=$kb&status=$set_status$url")
		continue
	else
		m=$(curl -s "$host/PJset.php?type=$type&op=comPutCheckRep&id=$id&kb=$kb&package_info=NULL$url")
	fi
     
	fPath=$name
	#"A761CPE.YGKJ.B3.HB.H.SVSUKM.0318.V3.07"
	#$(pwd|cut -d '/' -f4)
	title="md5MF"$tpf"md5SF"$tpf"package"$tpf"verCode"$tpf"verName"$tpf"filename"
	fPass=$dPath$fPath\_apkCheckPass.txt
	fFail=$dPath$fPath\_apkCheckFail.txt
	fNull=$dPath$fPath\_apkCheckNull.txt
	echo "$fPath / apkCheckPass.txt">$fPass
	echo $title>>$fPass
	echo "$fPath / apkCheckFail.txt">$fFail
	echo $title>>$fFail
	echo "$fPath / apkCheckNull.txt">$fNull
	echo $title>>$fNull
	result=$(mkdir $dPath$fPath)
	
	#移动文件到对应的项目里面
	reslut=$(mv $name/build.prop $dPath$fPath)

	#新建文件app_list.txt
	m=$(echo '' > $dPath$fPath/$app_list_path)

	#for file end of .apk
	for apk in $fPath/$tmp_apk/*.apk
	do
		filename=$(basename $apk)
		
		#输出到对应的压缩包名下的某个文件
		result=$(echo $filename >> $dPath$fPath/$app_list_path)
		
		apk_name=${filename%%.*}
		#根据apk包名创建对应的目录
		apk_dir_path=$dPath$fPath/$apk_name
		result=$(rm -fr $apk_dir_path)
		result=$(mkdir $apk_dir_path)

		ext="${apk##*.}"
		fname="${apk%.*}"
		dirname=$(basename $apk .apk)

		#echo package and versionName
		package=$(aapt dump xmltree $apk AndroidManifest.xml | sed -n "/package=/p" | awk -F'"' '{print $2}')
		vercode=$(aapt dump xmltree $apk AndroidManifest.xml | sed -n "/platformBuildVersionCode=/p" | awk -F'"' '{print $2}')
		vername=$(aapt dump xmltree $apk AndroidManifest.xml | sed -n "/platformBuildVersionName=/p" | awk -F'"' '{print $2}')
		
		result=$(aapt dump xmltree $apk AndroidManifest.xml > $apk_dir_path/AndroidManifest.xml)
		result=$(unzip $apk "META-INF/*.*" -d $apk_dir_path)
		result=$(aapt dump xmltree $apk AndroidManifest.xml | grep "android\.permission\." > $apk_dir_path/power.txt)
		#取权限
		power_tmp=""
		power_all=","
		for pf in `cat $apk_dir_path/power.txt`
		do
			power_tmp=$(echo ${pf##*permission.} | cut -d "\"" -f1)
			if echo $power_all | grep ",$power_tmp,">/dev/null; then
				result="1"
			else
				power_all="$power_all$power_tmp,"
			fi
		done

		result=$(rm $fname -fr)
		uf=$(unzip $apk "META-INF/*.*" -d $fname)
		mf=""
		sf=""
		match=""
		u_status=0
		#$(md5sum "${apk}")
		if [ -f $fname/META-INF/MANIFEST.MF ]; then
			mf=$(md5sum $fname/META-INF/MANIFEST.MF|cut -d ' ' -f1)
			match=$match$mf$tpf
		fi
		if [ -f $fname/META-INF/*.SF ]; then
			sf=$(md5sum $fname/META-INF/*.SF|cut -d ' ' -f1)
			match=$match$sf$tpf
		fi
		match=$match$package$tpf
		match_package=$tpf$package$tpf
		#echo "$mf|$sf|$match"
		result=$(rm $fname -fr)

		t=$(date +%s)
		sign=$(echo -n "$t$key"|md5sum|cut -d ' ' -f1)
		#post到服务器上
		curl_info="$path_info&t=$t&sign=$sign&project_name=$project_name&apk_name=$filename&package=$package&sf=$sf&mf=$mf&power=$power_all&status=$u_status"
		m=$(curl -s -d "$curl_info" $php_url)
		m=$(curl -s -d "$curl_info" $new_url)
        
		if cat $packagelib | grep ",$package,">/dev/null; then
			package_info=$(cat $packagelib | grep ",$package,")
			package_type=$(echo $package_info | awk -F',' '{print $1}')
		else
			check_pass="9"
			t=$(date +%s)
			sign=$(echo -n "$t$key"|md5sum|cut -d ' ' -f1)
			url="&t=$t&sign=$sign"

			m=$(curl -s "$host/PJset.php?type=$type&op=comPutCheckRep&id=$id&kb=$kb&package_info=5,0,$package,$url")
			continue
		fi
	
		packmatch="$package_type,$match"
		if [ "$package_type" = "3" ]; then
			error_status="2"
		elif [ "$package_type" = "1" -o "$package_type" = "6" ]; then
			continue
		elif [ "$package_type" = "2" ]; then
			if cat $projuselib | grep "$packmatch">/dev/null; then
				error_status="0"
			else
				error_status="3"
				package_info="$package_info,$mf"
			fi
		elif [ "$package_type" = "5" ]; then
			if cat $projuselib | grep "$packmatch">/dev/null; then
				error_status="0"
			else
				error_status="3"
				package_info="$package_info,$mf"
			fi
		else
		    error_status="1"
		fi
		m=$(sed -i '/,'"$package"',/d' $projuselib)
		
		if [ "$error_status" != "0" ]; then
			check_pass="9"
			t=$(date +%s)
			sign=$(echo -n "$t$key"|md5sum|cut -d ' ' -f1)
			url="&t=$t&sign=$sign"
			#echo "$host/PJset.php?type=$type&op=comPutCheckRep&id=$id&kb=$kb&package_info=$error_status,$package_info$url"
			m=$(curl -s "$host/PJset.php?type=$type&op=comPutCheckRep&id=$id&kb=$kb&package_info=$error_status,$package_info$url")
			#echo "$m"
		fi
	done

	for msg in `cat $projuselib`
	do
		pack_type=$(echo $msg|cut -d "$tpf" -f1)
		pack_mf=$(echo $msg|cut -d "$tpf" -f2)
		pack_sf=$(echo $msg|cut -d "$tpf" -f3)
		pack=$(echo $msg|cut -d "$tpf" -f4)
		app_name=$(echo $msg|cut -d "$tpf" -f11)
		pack_msg="$pack_type$tpf$pack_mf$tpf$pack_sf$tpf$pack$tpf"
		package_info="$pack_type$tpf$pack$tpf$app_name"
		check_pass="9"
		t=$(date +%s)
		sign=$(echo -n "$t$key"|md5sum|cut -d ' ' -f1)
		url="&t=$t&sign=$sign"
		if [ "$pack_type" = "5" ]; then	
			m=$(curl -s "$host/PJset.php?type=$type&op=comPutCheckRep&id=$id&kb=$kb&package_info=6,$package_info$url")
		else
			m=$(curl -s "$host/PJset.php?type=$type&op=comPutCheckRep&id=$id&kb=$kb&package_info=4,$package_info$url")
		fi
	done

	result=$(rm -fr "$name")

	#如果没有定义预装，或者不是量产软件，则通过版本
	if [ "$set_no_yz_pass" = "1" ]; then
		#check_pass="3"
		echo "mkdir mv"
	elif [ "$mp_ver" = "0" ]; then
		#check_pass="3"
		echo "mkdir mv"
	fi

	
	if [ "$cs" = "1" ]; then
		if [ $check_pass = "3" ]; then
			#m=$(mkdir "$dir_ftp" -p)
			#m=$(mv -f "$f" "$f_ftp")
			#m=$(cp -f "$f" "$f_ftp")
			#m=$(rm -fr "$f")
			echo "mkdir mv"
		fi
	else
		if [ $check_pass = "3" ]; then
			check_pass="17"
		fi
	fi
        t=$(date +%s)
        sign=$(echo -n "$t$key"|md5sum|cut -d ' ' -f1)
        url="&t=$t&sign=$sign"
        #m=$(curl -s "$host/PJset.php?type=$type&op=putCheckRep&id=$id&kb=$kb&status=3$url")
        m=$(curl -s "$host/PJset.php?type=$type&op=putCheckRep&id=$id&kb=$kb&status=$check_pass$url")
        #echo $m
done

IFS=$OLDIFS
echo "OK"
exit

FILE=`ls $dPath -F | grep '/$' | sed 's/.$//'`
for f in $FILE
do
        if [ ! "`ls -A $dPath$f`" = "" ]; then
                result=$(zip -r $dPath$f.zip $dPath$f/)
        fi
done
