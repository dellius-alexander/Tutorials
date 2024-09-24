#!/usr/bin/env bash
#####################################################################
#####################################################################
    # Require sudo to run script
if [[ $UID != 0 ]]; then
    printf "\nPlease run this script with sudo: \n";
    printf "\n${RED} sudo $0 $* ${NC}\n\n";
    exit 1
fi
#####################################################################
RED='\033[0;31m' # Red
NC='\033[0m' # No Color CAP
#####################################################################
#
if [[ ! -z ${1} ]]; then
yum install -y yum-utils && \
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo &&
yum install -y containerd.io \
docker-ce docker-ce-cli && \
systemctl enable --now docker && \
systemctl start docker && \
wait $! && \
usermod -aG docker $(id -u) && \
newgrp docker && \
docker run hello-world && \
wait $!
else
#
printf "\nUsage: ${RED}${0} <USERNAME> ${NC}\n"
printf "\nExample: ${RED}${0} dellius ${NC}\n"
exit 1
#
fi