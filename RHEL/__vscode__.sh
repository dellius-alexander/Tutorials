#!/usr/bin/env bash
#####################################################################
RED='\033[0;31m' # Red
NC='\033[0m' # No Color CAP
#####################################################################
    # Require sudo to run script
if [[ $UID != 0 ]]; then
    printf "\nPlease run this script with sudo: \n";
    printf "\n${RED} sudo $0 $* ${NC}\n\n";
    exit 1
fi
#####################################################################
#####################################################################
rpm --import https://packages.microsoft.com/keys/microsoft.asc
wait $!
cat <<EOF | tee /etc/yum.repos.d/vscode.repo 
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
wait $!
yum install -y code