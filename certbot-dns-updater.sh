#!/bin/sh

#only thing you need to manually set
KEY=""

if [ $# -ne 1 -a -z $CERTBOT_DOMAIN ];
    then echo "cannot run with invalid params!"
fi

if [ -z $2 ]; then
	SERVER="127.0.0.1"
fi
if [ -z $CERTBOT_DOMAIN ]; then
	DOMAIN=$2
	FULL_DOMAIN=$(expr match "$DOMAIN" '.*\.\(.*\..*\)')
else
	FULL_DOMAIN=CERTBOT_DOMAIN
	DOMAIN=$(expr match "$CERTBOT_DOMAIN" '.*\.\(.*\..*\)')
fi
if [ -z $CERTBOT_VALIDATION ]; then
	TOKEN=$3
else
	TOKEN=$CERTBOT_VALIDATION
fi

do_add(){
echo "Setting $2 ($4) on $1 with a key of $3 "
nsupdate -k $4 <<dnsupdater
server $1
zone $2
update delete _acme-challenge.${3}
update add _acme-challenge.${3} 60 IN TXT "$5"
send
dnsupdater
}

do_remove(){
echo "Setting $2 ($4) on $1 with a key of $3"
nsupdate -k $4 <<dnsupdater
server ${1}
zone ${2}
update delete _acme-challenge.${3}
send
dnsupdater
}

if [[ "$1" == "update" ]]; then
	#add and stuff
	do_add $SERVER $DOMAIN $CERTBOT_DOMAIN $KEY $TOKEN
elif [[ "$1" == "clean" ]]; then
	#delete here
	do_remove $SERVER $DOMAIN $CERTBOT_DOMAIN $KEY
else
	echo "error: something has gone wrong. '$1' is an unknown option"
fi

# done?
