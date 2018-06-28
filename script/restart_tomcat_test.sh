#!/bin/sh
/opt/apache-tomcat-7.0.63-test/bin/shutdown.sh
#kill -9 `ps -ef | grep tomcat  |awk '{print $2}'`

#ps -ef | grep "apache-tomcat-7.0.63-test/"
ps -ef | grep "apache-tomcat-7.0.63-test/" | awk '{print $2,$8}'| while read action
        do
                if [[ $action == *grep* ]];then
                        echo $action
                else
			echo $action
                        echo $action | awk '{print $1}' | while read pid
                        do
                                kill -9 $pid
				echo $pid
                        done
                fi
        done
/mnt/apache-tomcat-7.0.63-test/bin/startup.sh
