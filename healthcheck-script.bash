#!/bin/bash
RESPONSE_STATUS_URL='200'
TELEGRAM_TOKEN='[TOKEN]'
TELEGRAM_CHAT_ID='[CHAT ID]'


getServiceHealthCheck() {
	for ListService in $(cat service-list);
	do
		RESPONSE_HEALTHCHECK=`curl -s -I -X GET $ListService | grep HTTP | awk '{ print $2 }'`
	
		if [[ "$RESPONSE_HEALTHCHECK" != "$RESPONSE_STATUS_URL" ]]
		then
			curl -s -X POST https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage -d chat_id=$TELEGRAM_CHAT_ID -d text="Health Check Service ALERT : $ListService - Response : $RESPONSE_HEALTHCHECK"
		fi

	done
}



while [ 1 ]
do
	getServiceHealthCheck
	sleep 30s
done

