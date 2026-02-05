#!/bin/bash

LOG="/var/log/auth.log"
THRESHOLD=3
TIME_WINDOW_MIN=2
ALERT_FILE="alerts_ssh_bruteforce.log"

echo "[SOC] Analisando tentativas de login SSH..."

grep "Failed password" $LOG | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | sort | uniq -c | while read count ip;
do
    if [ "$count" -ge "$THRESHOLD" ];
    then
        if [[ "$ip" =~ ^10\.|^192\.168\.|^172\.(1[6-9]|2[0-9]|3[0-1])\. ]];
        then
            CITY="INTERNAL"
            COUNTRY="INTERNAL"
            ORG="PRIVATE_NETWORK"
        else
            GEO=$(curl -s https://ipinfo.io/$ip/json)
            CITY=$(echo $GEO | jq -r '.city')
            COUNTRY=$(echo $GEO | jq -r '.country')
            ORG=$(echo $GEO | jq -r '.org')
        fi
        echo "[ALERTA] Possível bruteforce detectado"
        echo "IP: $ip"
        echo "Tentativas: $count"
        echo "Localização: $CITY - $COUNTRY"
        echo "Organização: $ORG"
        echo "MITRE: T1110 - BruteForce"
        echo "$(date)"
        echo "$(date) | IP=$ip | TENTATIVAS=$count | LOC=$CITY-$COUNTRY | ORG=$ORG | MITRE=T1110" >> $ALERT_FILE
    fi
done