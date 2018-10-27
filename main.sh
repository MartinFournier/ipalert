#!/bin/sh

getEmailTemplate() {
  sed \
    -e "s/\#host/$host/" \
    -e "s/\#currentAddress/$currentAddress/" \
    -e "s/\#previousAddress/$previousAddress/" \
    -e "s/\#currentDate/$currentDate/" \
    -e "s/\#currentTime/$currentTime/" \
    /app/email.template
}

getAddress() {
  wget -q -O - https://ipinfo.io/ip
}

lastAddressFile="/app/data/ip"
logFile="/app/data/ip.log"
currentTime=$(date +%T)
currentDate=$(date +"%y-%m-%d")

currentAddress=$(getAddress)
if [ -f $lastAddressFile ]; then
  echo Found previous address file
  previousAddress=$(cat $lastAddressFile)
fi
if [ "$currentAddress" == "$previousAddress" ]; then
  echo IP address did not change
  echo $currentDate $currentTime " | " $currentAddress >> $logFile
else
  echo $currentAddress > $lastAddressFile
  echo -e "$(getEmailTemplate)"
  echo -e "$(getEmailTemplate)" | sendmail "$recipient"
fi
