#!/bin/sh
/opt/apache-tomcat-7.0.63/bin/shutdown.sh
#kill -9 `ps -ef | grep tomcat  |awk '{print $2}'`

#ps -ef | grep "apache-tomcat-7.0.63/"
ps -ef | grep "apache-tomcat-7.0.63/" | awk '{print $2,$8}'| while read action
        do
                if [[ $action == *grep* ]];then
                        #echo $action
                        r=1
                else
			            #echo $action
                        echo $action | awk '{print $1}' | while read pid
                        do
                                kill -9 $pid
				echo $pid
                        done
                    fi
        done
/mnt/apache-tomcat-7.0.63/bin/startup.sh
