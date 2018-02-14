#!/bin/sh

#only thing you need to manually set
KEY=""

if [ $# -ne 1 -a -z $CERTBOT_DOMAIN ];
    then echo "cannot run with invalid params!"
fi

if [ -z $SERVER ]; then
	SERVER="127.0.0.1"
fi
if [ -z $CERTBOT_DOMAIN ]; then
	DOMAIN=$2
else
	DOMAIN=$(expr match "$CERTBOT_DOMAIN" '.*\.\(.*\..*\)')
fi
if [ -z $CERTBOT_TOKEN ]; then
	TOKEN=$3
else
	TOKEN=$CERTBOT_TOKEN
fi

do_add(){
echo "Setting $2 ($4) on $1 with a key of $3 "
nsupdate -k $3 <<dnsupdater
server $1
zone $2
update delete _acme-challenge.${2}
update add _acme-challenge.${2} 60 IN TXT "$4"
send
dnsupdater
}

do_remove(){
echo "Setting $2 ($4) on $1 with a key of $3"
nsupdate -k $3 <<dnsupdater
server ${1}
zone ${2}
update delete _acme-challenge.${2}
send
dnsupdater
}

if [[ "$1" == "pre" ]]; then
	#add and stuff
	do_add $SERVER $DOMAIN $KEY $TOKEN
elif [[ "$1" == "post" ]]; then
	#delete here
	do_remove $SERVER $DOMAIN $KEY
else
	echo "error: something has gone wrong. '$1' is an unknown option"
fi

# done?
