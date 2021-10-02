#!/bin/bash

exip=" "
dhip=" "
accname=" "
fname=" "
sep="_"
loc="/se"
RED='\033[0;41;30m'
STD='\033[0;0;39m'

pause() {
  read -p "Press [Enter] key to continue..." fackEnterKey
}

findscript() {
	if [ -z "$choice" ]; then
		main_menu
		sleep 1
	else
		find ./scripts -name "$choice*" -type f -exec bash {} \;
	fi	
}

scriptname() {
	count=$(ls -1 $loc | wc -l)
	ncount=$((count + 1))
	echo "$loc$ncount$sep$fname"
}

changeperm() {
	count=$(ls -1 $loc | wc -l)
	cfname=$(echo "$loc$count$sep$fname")
	chmod 755 "$cfname"
	chown jerome "$cfname"
}

createscript() {
	echo '#!/bin/sh

	echo "Starting VPNClient"
		vpnclient start
	echo "Connecting to Server..."
		sleep 2
		vpncmd /client localhost /cmd accountconnect '$accname'
	echo "Getting IP..."
		dhclient vpn_se1
	echo "Routing IP..."
		ip route add '$exip' via 192.168.1.1 dev wlp2s0 proto static
		ip route del default
		ip route add default via '$dhip' dev vpn_se1
	echo "Generating Log..."
	vpncmd /client localhost /out:log.txt /cmd accountget '$accname'
	echo "Connected."
	read -p "Press [Enter] key to continue..." fackEnterKey' > $(scriptname)
		
		changeperm
		echo "Success."
		pause
}

servers() {
	for file in scripts/*; do
    	echo  "\t⬥\t\t$(basename "$file")\t\t\t⬥"
	done
}

accountlist() {
	sleep 2
	vpncmd /client localhost /out:logs/log2.txt /cmd accountlist
	pause
}

accountcreate() {
	sleep 2
	vpncmd /client localhost /cmd accountcreate
	pause
}

accountimport() {
	sleep 2
	vpncmd /client localhost /cmd accountimport
	pause
}

vpncmdstart() {
	sleep 2
	vpncmd /client localhost
	pause
}

choice_server() {
	local choice
	echo "\n"
	read -p "Enter choice: " choice
	findscript
}

choice_menu() {
	local choice
	echo "\n"
	read -p "Enter choice: " choice
	case $choice in
		0) main_menu;;
		1) serverlist_menu;;
		2) accountlist;;
		3) accountcreate;;
		4) accountimport;;
		5) scriptcreator_menu;;	
 		6) vpncmdstart;;	
		*) echo "${RED}Error...${STD}" && sleep 2
	esac
}

createaccount_menu() {
	clear
	echo "
	⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥
	⬥⬥⬥⬥⬥        GENERATE ROUTE SCRIPT        ⬥⬥⬥⬥⬥
	⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥\n" 
	read -p "Enter External IP: " exip
	read -p "Enter DHCP IP: " dhip
	read -p "Enter Account Name: " accname
	read -p "Enter Filename(sample.sh): " fname
	echo "Generating route script..."

}

scriptcreator_menu() {
	clear
	echo "
⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥
⬥⬥⬥⬥⬥        GENERATE ROUTE SCRIPT        ⬥⬥⬥⬥⬥
⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥\n" 
read -p "Enter External IP: " exip
read -p "Enter DHCP IP: " dhip
read -p "Enter Account Name: " accname
read -p "Enter Filename(sample.sh): " fname
echo "Generating route script..."
createscript
}

serverlist_menu() {
clear
echo "
⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥
⬥⬥⬥⬥⬥           VIEW SERVERS              ⬥⬥⬥⬥⬥⬥⬥
⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥
                                               ⬥"
servers
echo "\t⬥                                               ⬥
⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥
⬥⬥⬥⬥⬥          (c) pigscanfly             ⬥⬥⬥⬥⬥⬥⬥
⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥"
	choice_server
}

main_menu() {
clear
echo "
⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥
⬥⬥⬥⬥⬥           SOFTETHER MENU            ⬥⬥⬥⬥⬥
⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥
⬥                                             ⬥
⬥            1. VIEW SERVERS                  ⬥ 
⬥            2. ACCOUNT LIST                  ⬥ 
⬥            3. CREATE ACCOUNT                ⬥
⬥            4. IMPORT CONFIG                 ⬥
⬥            5. GENERATE ROUTE SCRIPT         ⬥                         
⬥            6. VPNCMD                        ⬥
⬥                                             ⬥
⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥
⬥⬥⬥⬥⬥          (c) pigscanfly             ⬥⬥⬥⬥⬥
⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥⬥"
choice_menu
}

while true
do	
	main_menu	
done
