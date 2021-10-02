# #!/bin/bash

# #vpncmd /client localhost /cmd accountlist >> awk -F "|" '/Status/ print{$
# # choice=""
# # read choice
# # # fchoice=$(cat logs/account.txt | awk NR==$choice)

# # ./test2.sh "$fchoice"

# # dhclient vpn_ss -v | grep '10.20.*' &> /dev/null
# # if [ $? == 0 ]; then
# #    echo "matched"
# # fi

# # if dhclient vpn_ss -v | grep -q '10.20.30'; then
# #   echo "matched"
# # fi

# dhclient vpn_ss -v > logs/gateway.txt 2>&1

# # if [[ grep logs/gateway.txt -e '10.20.*' = true ]] 
# # then
# #     echo 'Found it'
# # fi

# # And here we have Bash Patterns:
# # if [[ "$VARIABLE" == ! ]]
# # then
# #     echo "matched"
# # else
# #     echo "nope"
# # fi

# chown jrm logs/gateway.txt
# if grep -q '192.168.*' logs/gateway.txt; then
#     echo found
#     echo "" > logs/gateway.txt
# else
#     echo not found
#     echo "" > logs/gateway.txt
# fi

server=$(awk -F '|' '/^Server Name/{print $2}' logs/status.txt | xargs)
echo $server
    route add -host $server gw 192.168.1.1
	# route del -host $server gw 192.168.1.1
    # ip route del $server via 192.168.1.1 dev wlp2s0 proto static