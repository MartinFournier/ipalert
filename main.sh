#!/bin/sh

getEmailTemplate() {
    envsubst < /app/email.template
}

getAddress() {
    wget -q -O - https://ipinfo.io/ip || echo $previousAddress
}

# Load environment variables
set -o allexport
. /app/.env
set +o allexport

# Generate msmtp config
envsubst < /app/msmtprc.template > /etc/msmtprc
chmod 600 /etc/msmtprc

lastAddressFile="/app/data/ip"
logFile="/app/data/ip.log"

export IPALERT_CURRENT_TIME=$(date +%T)
export IPALERT_CURRENT_DATE=$(date +"%y-%m-%d")

if [ -f $lastAddressFile ]; then
    export IPALERT_PREVIOUS_ADDRESS=$(cat $lastAddressFile)
    echo Previous address: $IPALERT_PREVIOUS_ADDRESS
fi

export IPALERT_CURRENT_ADDRESS=$(getAddress)

echo -e "$(getEmailTemplate)"

if [ "$IPALERT_CURRENT_ADDRESS" = "$IPALERT_PREVIOUS_ADDRESS" ]; then
    echo IP address did not change
    echo $IPALERT_CURRENT_DATE $IPALERT_CURRENT_TIME " | " $IPALERT_CURRENT_ADDRESS >> $logFile
else
    echo $IPALERT_CURRENT_ADDRESS > $lastAddressFile
    echo -e "$(getEmailTemplate)" | msmtp -a default $GMAIL_FROM
fi
