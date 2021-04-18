#!/bin/bash
#echo "Enter the path to the Nmap file:"

#read NMAP

NMAP=NMAP_all_hosts.txt

#Grab all the IP Addresses
#IP=$(grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' $NMAP)
#awk '/Nmap scan/{print $5}' $NMAP 


#Grab The service names, sort, grab uniqes and count, then sort high to low
grep -E 'open\s\s[A-Za-z]+' $NMAP | awk '{print $3}' | sort | uniq -c | sort -k 1 -nr
echo
echo '============================================================================================'
echo

#Grab all the Ips and associated ports
#awk '/Nmap scan/{print $5} ; /PORT/,/MAC/{if (!/PORT/&&!/MAC/)print $3} ' NMAP_all_hosts.txt



SERV=$(grep -E 'open\s\s[A-Za-z]+' $NMAP | awk '{print $3}' | sort | uniq -c | sort -k 1 -nr | awk '{print $2}')

#Make directory in /tmp to store files
DIR='/tmp/ip/'
if [[ ! -d $DIR ]]
then
    mkdir $DIR
fi



while read line 
do

    if [[ "$line" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
    then 
        var=$line
	#echo "This line is IP $var"
	echo $var > /tmp/ip/$var.txt 
    else
        #echo "line is service $line"
	echo $line >> /tmp/ip/$var.txt  
    fi
    
done < <(awk '/Nmap scan/{print $5} ; /PORT/,/MAC/{if (!/PORT/&&!/MAC/)print $3} ' NMAP_all_hosts.txt)      

FILES=$(ls /tmp/ip/)

for x in $SERV
do
    echo "======================================="
    echo "$x"
    echo "======================================="
    echo
    
    for f in $FILES 
    do
        if grep -Fxq "$x" "/tmp/ip/$f"
	then
            echo "$f" | awk -F'.' '{print $1"."$2"."$3"."$4}' 
            echo
    fi
    done
done

