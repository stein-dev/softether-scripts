#!/bin/bash

#vpncmd /client localhost /cmd accountlist >> awk -F "|" '/Status/ print{$
# choice=""
# read choice
# fchoice=$(cat logs/account.txt | awk NR==$choice)

echo $1
