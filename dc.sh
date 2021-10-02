#!/bin/bash

printf "\033c"
echo "Disconnecting to the world..."
	service network-manager restart 
	vpnclient stop | awk -F '|' '/^ /{print $2}'
echo "Done. Your back to reality!"
read -p "Press [enter] key to continue..." fackEnterKey
