#!/usr/bin/env bash
##########################################################################
# Command to assign port:
# semanage port -a -t ssh_port_t -p tcp < #PORTNUMBER >
# Command to verify post assignment:
# ss -tlnp | grep -i < #PORTNUMBER >
##########################################################################
#                       Environment Variables
##########################################################################
RED='\033[0;31m'        # Red
NC='\033[0m'            # No Color  CAP
##########################################################################
function assign_port()
{
#   check if input is empty
if [ ${#} -ne 1 ]; then
        echo "You must provide a parameter. Please try again..."
        printf "\nUsage:${RED} $0 <port number>${NC}\n"
        exit 1
#   check if port already exists
elif [ $(echo $(ss -tlnp | grep -c ${1})) -gt 0 ]; then
        printf "\n${RED}WARNING${NC}: Port number ${RED}${1}${NC} already assigned...\n"
        exit 1
else
#   assign port to sshd_config file to persist restarts
    if [[ $(cat /etc/ssh/sshd_config | grep -v "#" | gawk '/P/' | grep -c ${1}) -gt 0 ]]; then
        printf "\n${RED}WARNING${NC}: Port number ${RED}${1}${NC} already assigned...\n"
        exit 1
    else
        /usr/bin/sed -i "s/Port 22/&\nPort ${1}/" /etc/ssh/sshd_config
        sleep 1
    fi
        
fi
wait $!
printf "\nPort number ${RED}${1}${NC} assigned...\n" &&
sleep 1
#   add policy mapping for new port assignment as tcp
semanage port -a -t ssh_port_t -p tcp "${1}" &&
sleep 1
#   restart sshd for new policy changes to take affect
systemctl restart sshd
sleep 1
#   verify port assignment...
echo "Verifying port assignment: " &&
sleep 1
/usr/sbin/ss -tlnp | grep "${1}"
exit 0
}
##########################################################################
assign_port ${1}
##########################################################################