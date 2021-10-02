#!/bin/bash

regex='^[0-9]+$'

loading() {
    printf "\033c"
    echo "Loading brain cells..."
    vpnclient start | awk -F '|' '/^ /{print $2}'
    sleep 1
}

showvpncmd() {
    printf "\033c"
    vpncmd /client localhost | awk -F '|' '/^ /{print $2}'
    pause
}

pause() {
  read -p "Press [enter] key to continue..." fackEnterKey
}

accountconnect() {
    facc=$(cat logs/account.txt | awk NR==$choice2)
    fip=$(cat logs/ip.txt | awk NR==$choice2)
    ./conn.sh $facc $fip
}

deleteaccount() {
    loading
    printf "\033c"
    vpncmd /client localhost /out:logs/log.txt /cmd accountlist | awk -F '|' '/^ /{print $2}'
    echo "--------------------------------------------"
    echo "|               DELETE ACCOUNT             |"
    echo "--------------------------------------------"
    getserver
    echo "--------------------------------------------"
	read -p "Enter choice: " delchoice
    delacc=$(cat logs/account.txt | awk NR==$delchoice)
    if [[ $delchoice =~ $regex ]]
    then
        printf "\033c"
        echo "Deleting account: " $delacc     
        vpncmd /client localhost /cmd accountdelete $delacc | awk -F "/" '/^ /{print $2}'
        sleep 1
        echo "Done. Dandandan."
        pause
    elif [[ -z $delchoice ]]
    then
        semenu
    else
        echo "Wrong input dude." && sleep 1
    fi



}

createaccount() {
    printf "\033c"
    echo "-------------------------------------"
    echo "|          CREATE ACCOUNT           |"
    echo "-------------------------------------"
    read -p "VPN Name: " vname
    read -p "VPN Server Hostname/IP: " vip
    read -p "VPN Server Port: " vport
    read -p "VPN Hub Name: " vhub
    read -p "VPN Username: " vusername
    read -p "VPN Adapter Name: " vnic
    read -p "[1]Anonymous [2]Standard : " vauth
    if [ $vauth = 1 ]
    then
        echo "Creating bank account(I wish)..."
        vpncmd /client localhost /cmd accountcreate $vname /server:$vip:$vport /hub:$vhub /username:$vusername /nicname:$vnic | awk -F '|' '/^ /{print $2}'
        sleep 1
        vpncmd /client localhost /cmd accountanonymousset $vname | awk -F '|' '/^ /{print $2}'
        sleep 1
        echo "Done. Like how your gf was done with you."
        pause
    elif [ $vauth = 2 ]
    then
        read -p "VPN Password: " vpassword
        echo "Creating bank account(I wish)..."
        vpncmd /client localhost /cmd accountcreate $vname /server:$vip:$vport /hub:$vhub /username:$vusername /nicname:$vnic | awk -F '|' '/^ /{print $2}'
        sleep 1
        vpncmd /client localhost /cmd accountpasswordset $vname /password:$vpassword /type:standard | awk -F '|' '/^ /{print $2}'
        sleep 1
        echo "Done. Like how your gf was done with you."
        pause
    else
        echo "Something's wrong. Oh well, it's my code."
        pause
    fi
    
}

getserver() {
    awk -F '|' '/^VPN Connection Setting Name/{print $2}' logs/log.txt  > logs/account.txt
    awk -F '[|:]' '/^VPN Server Hostname/{print $2}' logs/log.txt  > logs/ip.txt
    awk -F '[|:]' '/^Status/{print $2}' logs/log.txt  > logs/status.txt
    linecount=$(wc -l logs/account.txt | awk '{print $1}')
   
    for ((i=1;i<=$linecount;i++)); 
    do 
        echo $i 
    done > logs/count.txt   
   
    { echo -e "<html>\n<table border=1 cellpadding=0 cellspacing=0>"
    paste logs/count.txt logs/account.txt logs/ip.txt logs/status.txt   "$@" |sed -re 's#(.*)#\x09\1\x09#' -e 's#\x09# </pre></td>\n<td><pre> #g' -e 's#^ </pre></td>#<tr>#' -e 's#\n<td><pre> $#\n</tr>#'
    echo -e "</table>\n</html>"
    } |w3m -dump -T 'text/html'
    
}

serverlist() {
    loading
    printf "\033c"
    vpncmd /client localhost /out:logs/log.txt /cmd accountlist | awk -F '|' '/^ /{print $2}'
    echo "---------------------------------------------"
    echo "|                SERVER LIST                |"
    echo "---------------------------------------------"
    getserver
    echo "---------------------------------------------"
	read -p "Enter choice: " choice2
    if [[ $choice2 =~ $regex ]]
    then
        accountconnect
    elif [[ -z $choice2 ]]
    then
        semenu
    else
        echo "Wrong input dude." && sleep 1
    fi
}


option() {
    local choice
	read -p "Enter choice: " choice
	case $choice in
		1) serverlist;;
		2) ./dc.sh;;	
        3) createaccount;;
        4) deleteaccount;;
		*) echo "Wooops! In earth, we called this error." && sleep 1
	esac
}

semenu() {
    printf "\033c"
    echo "-------------------------------"
    echo "| SOFTETHER AUTO @ pigscanfly |"
    echo "-------------------------------"
    echo "1. View Server List"
    echo "2. Disconnect"
    echo "3. Create Account"
    echo "4. Delete Account"
    echo "5. vpncmd"
    echo "-------------------------------"
    option
}

while true
do
    semenu
done


