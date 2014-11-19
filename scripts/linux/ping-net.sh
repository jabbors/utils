#!/bin/sh

#ip=$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{print $1}')
ip=$(/sbin/ifconfig wlan0 | grep 'inet addr:' | cut -d: -f2 | awk '{print $1}')
ip_first=$(echo $ip | cut -d '.' -f 1)
ip_seconds=$(echo $ip | cut -d '.' -f 2)
ip_third=$(echo $ip | cut -d '.' -f 3)
ip_fourth=$(echo $ip | cut -d '.' -f 4)

counter=1
while [ $counter -lt 100 ]
do
    if [ $counter = $ip_fourth ]
    then
        counter=$(($counter + 1))
        continue
    fi
    addr="$ip_first.$ip_seconds.$ip_third.$counter"
    ping -c 1 $addr -W 1 > /dev/null && echo "ping $addr [OK]"
    counter=$(($counter + 1))
done
