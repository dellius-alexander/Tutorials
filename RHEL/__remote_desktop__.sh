#!/usr/bin/env bash
#####################################################################
    # Require sudo to run script
if [[ $UID != 0 ]]; then
    printf "\nPlease run this script with sudo: \n";
    printf "\n${RED} sudo $0 $* ${NC}\n\n";
    exit 1
fi
#####################################################################
#####################################################################
# Install & Setup Remote Desktop Connection
#####################################################################
# Remote Desktop Centos
yum install -y epel-release && \
yum install -y xrdp && \
systemctl enable xrdp && \
systemctl start xrdp && \
firewall-cmd --add-port=3389/tcp --permanent && \
firewall-cmd --reload
#
if [ $? == 0 ]; then 
    printf "\nSomething went wrong installing Remote Desktop...\n"
fi