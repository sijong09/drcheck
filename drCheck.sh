#!/bin/sh


while true;
do

targetserver=$(head ./targetserver.txt)
mainserver=$(head ./mainserver.txt)


# ping 마지막 결과 값 읽어오기 
laststatus=$(awk '/-/{print $1}' ./pingresult.txt)
#echo ${laststatus}
ping -c2  ${targetserver} > /dev/null
  if [ $? -eq 0 ]
  then 
	currentstatus="ok"
#	echo "OK! Good. Host found..." 
  if [ $laststatus == $currentstatus ]
	then
		#마지막 값이 fail 	
		sleep 1
		#echo "ok - $(date +%F_%H-%M-%S)" > ./pingresult.txt;
	else
	 	echo "ok - $(date +%F_%H-%M-%S)" > ./pingresult.txt;
                echo "sqlserver status changed to OK  - ${targetserver} - $(date +%F_%H-%M-%S)">> ./sqlstatus.log;
		sleep 1
	fi
	#echo "ok - $(date +%F_%H-%M-%S)" > ./pingresult.txt;
	#sleep 1 
  # exit 0
  else 
	currentstatus="fail"
#	echo "Host Not found..." 
#       echo $currentstatus , $laststatus	
        if [ $laststatus == $currentstatus ]
        then
		sleep 1
	else
                #마지막 값이 ok
                # sql read only 적용
                #sqlcmd  -U sa -P 'tdg@2018!1' -S 172.26.3.142 -Q "select @@servername;"
                echo "fail - $(date +%F_%H-%M-%S)"> ./pingresult.txt;
                sqlcmd  -U sa -P 'tdg@2018!1' -S $mainserver -Q "select @@servername;"
                #sed -i 's/$/sqlserver status change to OK - $(date +%F_%H-%M-%S)/g' ./sql.log
                echo "sqlserver status changed to Fail - ${targetserver} - $(date +%F_%H-%M-%S)">> ./sqlstatus.log;
        fi
	sleep 1 
  fi
done
