#!/bin/bash

se_ip
dhcp_ip


ip route add $se_ip via 192.168.1.1 dev wlp2s0 proto static
ip route del default
ip route add default via $dhcp_ip dev vpn_se1

