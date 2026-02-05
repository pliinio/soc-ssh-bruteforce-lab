#!/bin/bash

ALERT_FILE="alerts_ssh_bruteforce.log"

echo "SOC DASHBOARD - SSH"
echo

echo "Total de alertas:"
wc -l < $ALERT_FILE
echo

echo "[+] IPs mais frequentes:"
grep "IP=" $ALERT_FILE | cut -d'|' -f2 | cut -d'=' -f2 | sort | uniq -c | sort -nr
echo

echo "[+] Técnicas MITRE detectadas:"
grep "MITRE=" $ALERT_FILE | cut -d'=' -f6 | sort | uniq -c
echo

echo "[+] Últimos 5 alertas:"
tail -n 5 $ALERT_FILE
echo