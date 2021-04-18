#!/bin/bash

# Function to see if the script should continue
function ask(){
  echo -n "Should we continue? (Y/N): "
  read response 

  if [ $response == "Y" ]; then
    return 0 
  elif [ $response == "N" ]; then 
    return 1 
  else 
    ask
  fi
} 

function sa_checks(){
  # Enter situational awareness commands here
  
  echo "=========Beginning SA checks =========="
  
  echo "====ID===="
  id

  echo "====logged in users===="
  w
  
  echo "====date===="
  date; date -u

  echo "====Current PID===="
  ps | grep $$

  echo "====Path===="
  echo $PATH
  
  echo "====hostname===="
  hostname

  echo "====SELINUX===="
  getenforce

  echo "====Remote Logging==="
  ps -ef | grep -i audit[d]

  echo "====Logs===="
  auditctl -l

  ls -al /var/log/account

  echo "====IP===="
  ip addr

  echo "=========SA Checks completed =========="
}

function security_checks() {
  # Enter security checks here

  echo "=========Beginning Security Checks========="
  
  ps -ef 

  ls -altr /var/log

  find / -mmin -60 -type f 2> /dev/null | grep -v "/proc\|/sys"

  ls -l /etc/*syslog*.conf

  grep '@' /etc/*sysl*.conf


  echo "=========Security Checks completed========="

}

function system_info() {
  # Enter system information gathering commands here

  echo "==========Beginning System Info gathering=========="

  uname -a
 
  cat /etc/*release*

  mount

  lsusb

  route -n

  ip -r

  echo "==========System Info gathering completed ========="
  
}

# Main portion
sa_checks
if ask; then
  security_checks
  if ask; then 
    system_info
  fi
fi
