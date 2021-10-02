#!/bin/bash

pause() {
    read -p "Press [enter] key to continue..." fackEnterKey
}
printf "\033c"
echo "$2 - $1"
echo "-------------------------"
echo "Connecting from mars..."
	vpncmd /client localhost /cmd accountconnect $1 | awk -F '|' '/^ /{print $2}'
    sleep 1
echo "Getting IP from moon..."
	dhclient vpn_mm -v > logs/gateway.txt 2>&1

if grep -q '192.168.*' logs/gateway.txt; then
    echo "Routing IP to sun..."
    sleep 1
    ip route add $2 via 192.168.1.1 dev wlp2s0 proto static
    sleep 1
    ip route del default
    sleep 1
    ip route add default via 192.168.30.1 dev vpn_mm
    echo "Done. You're connected to earth. The dumbest planet in milky way."
    echo "" > logs/gateway.txt  
    pause   
elif grep -q '10.20.*' logs/gateway.txt; then
    echo "Routing IP to sun..."
    sleep 1
    ip route add $2 via 192.168.1.1 dev wlp2s0 proto static
    sleep 1
    ip route del default
    sleep 1
    ip route add default via 10.20.30.1 dev vpn_mm
    echo "Done. You're connected to earth. The dumbest planet in milky way."
    echo "" > logs/gateway.txt 
    pause
else
    echo "Ooops. I feel lazy today. Try again!"
    pause
fi







