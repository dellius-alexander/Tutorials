#!/usr/bin/env bash
##########################################################################
RED='\033[0;31m' # Red
NC='\033[0m' # No Color CAP
##########################################################################
# REGEX patters
# ip_address="(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)"
# _url_pattern="[((^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$)?|^[http|https|//|\w]{1}([\.][\w])*$]"
# _doman_pattern="[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)"
_ipv4_pattern="(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)"
_doman_pattern="[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)"
_url_pattern="($_ipv4_pattern|$_doman_pattern)"
_file_pattern="([\/\sa-zA-Z0-9_\.\-\(\):]*){2}"
msgg="<Ip address> <remote source directory> <host destination directory>"
##########################################################################
#
if [[ $UID != 0 ]]; then
    printf "\nPlease run this script with sudo: \n";
    printf "\nUsage: ${RED}sudo ${0} ${msgg} ${NC}\n"
    printf "\nExample: ${RED}sudo ${0} 10.0.0.10 /nfsfileshare /mnt/nfsfileshare${NC}\n"
    exit 1
fi
#
##########################################################################
##########################################################################
# mounts the nfs share
__nfs__() {
    # get user input
    _input=($(echo ${@}))
    declare -p _input &>/dev/null   # set variable
    # validating the input values and positional parameters
    if [[ $UID == 0 ]] &&  [[ ${#_input[@]} == 3 ]] && [[ ${_input[0]} =~ $_url_pattern ]] && [[ ${_input[1]} =~ $_file_pattern ]] && [[ ${_input[2]} =~ $_file_pattern ]]; then
        # install packages for managing nfs 
        yum install -y nfs-utils firewalld
        wait $!
        printf "\n\n"
        # create the nfs directory if not exist
        [ ! -d "/mnt/nfs" ] && mkdir -p ${_input[2]}   # /mnt/local/nfs
        # deep check for the nfs matching input parameters
        if [[ $(mount | grep -i 'nfs' | grep -i ${_input[0]} | grep -i ${_input[1]} | grep -ic ${_input[2]}) == 0 ]]; then
            # mount nfs if no match is found
            mount -t nfs -o nfsvers=4  ${_input[0]}:${_input[1]} ${_input[2]}
            wait $!
        fi
        printf "\n\n"
        # print mounted nfs info
        mount | grep nfs
        sleep 2
        wait $!
        printf "\n\n"
        # check and update /etc/fstab to persit reboots, if necessary
        if [[ $(cat /etc/fstab | grep -i ${_input[0]} | grep -i ${_input[1]} | grep -c ${_input[2]}) -eq 0 ]]; then
        cat >>/etc/fstab<<EOF 
        # Mount point for NFS Share
        ${_input[0]}:${_input[1]} ${_input[2]}  nfs4     _netdev,auto,nosuid,rw,sync,hard,intr    0   0
EOF
        printf "\n$(cat /etc/fstab | grep -i 'nfs')\n\n"
        printf "\nMounted ${_input[1]} successfully to ${_input[3]} from host ${_input[0]}...\n\n\n"
        ls -lia ${_input[2]}
        printf "\n\n"
        fi
    
    else
    # Print error message on check failure
        printf "\nUsage: ${RED}sudo ${0} ${msgg} ${NC}\n"
        printf "\nExample: ${RED}sudo ${0} 10.0.0.10 /nfsfileshare /mnt/nfsfileshare${NC}\n"
    fi
    exit 0
}
__nfs__ $1 $2 $3