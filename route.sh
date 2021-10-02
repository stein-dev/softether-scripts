#!/bin/bash

pause() {
    read -p "Press [Enter] key to continue..." fackEnterKey
}

accountstatus() {
    vpncmd /client localhost /out:logs/status.txt /cmd accountstatusget $1 | awk -F '|' '/^ /{print $2}'
    chown jrm logs/status.txt
    echo "" > logs/gateway.txt
}

route1() {
    echo "Routing IP..."
    sleep 1
    ip route add $2 via 192.168.1.1 dev wlp2s0 proto static
    ip route del default
    ip route add default via 192.168.30.1 dev vpn_mm
    echo "Done."
}

route2() {
    echo "Routing IP..."
    sleep 1
	ip route add $2 via 192.168.1.1 dev wlp2s0 proto static
    ip route del default
    ip route add default via 10.30.20.1 dev vpn_mm
    echo "Done."
}


if grep -q '192.168.*' logs/gateway.txt; then
    route1
    accountstatus
    pause    
else
    route2
    accountstatus
    pause
fi