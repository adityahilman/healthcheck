#!/bin/bash
BASE_URL='YOUR_APP_URL'
RESPONSE_STATUS_URL='200'

TELEGRAM_TOKEN='YOUR_TELEGRAM_TOKEN'
TELEGRAM_CHAT_ID='YOUR_TELEGRAM_CHAT_ID'


getMicroserviceHealthCheck() {
	for ListService in $(cat microservice-list);
	do
		RESPONSE_HEALTHCHECK=`curl -s -I -X GET $BASE_URL/$ListService | grep HTTP | awk '{ print $2 }'`
	
		if [[ "$RESPONSE_HEALTHCHECK" != "$RESPONSE_STATUS_URL" ]]
		then
			curl -s -X POST https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage -d chat_id=$TELEGRAM_CHAT_ID -d text="Health Check Service ALERT : $ListService - Response : $RESPONSE_HEALTHCHECK"
		fi

	done
}



while [ 1 ]
do
	getMicroserviceHealthCheck
	sleep 30s
done

