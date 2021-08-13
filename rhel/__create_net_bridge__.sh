#!/usr/bin/env bash
###########################################################
# Create network bridge adapter:
nmcli connection \
ad con-name br2 \
ifname br2 \
type bridge \
ip4 10.0.4.1/24 && \

# Assign interface to the bridge
nmcli connection \
ad con-name bridge-slave \
ifname em3 \
type bridge-slave \
master br2 && \

[[ $? != 0 ]] && echo $? || exit "Something went wrong... \nExit Code:\n$?";