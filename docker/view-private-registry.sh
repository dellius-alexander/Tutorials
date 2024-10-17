#!/usr/bin/env bash
##########################################################################
#
# Registry Password
if [ ${#REGISTRY_PASS} -gt 0 ]; then
REGISTRY_PASS=$(echo -n ${REGISTRY_PASS} | base64 -d)  # Variable must be a base64 --encoded {hash}
        printf "\n\nRegistry pass set...\n"
else
        printf "\n\nRegisry pass not set...\n"
        printf "\nRun export REGISTRY_PASS=<a base64 encrypted password>\n"
fi
# Enter remote registtry v2 server IP address or FQDN
# Setup environmental variables for each of these values:
#
REMOTE_REGISTRY_HOST="${REMOTE_PRIVATE_REGISTRY}"
#       Enter remote registry v2 ssh admin account for the above host
REMOTE_ADMIN_ACCOUNT="${REMOTE_ADMIN_ACCOUNT}"
##########################################################################
_list(){
        RESULTS="${1}"
        cnt=0
        #RESULTS=${RESULTS[@]}  # Checking formatted values
        IFS=',' read -ra splitIFS<<<${RESULTS[@]}
        #echo ${#splitIFS[@]}   # Checking array count
        for c in ${splitIFS[@]};
        do
                if [[ $c =~ 'repositories' ]]; then
                        #c=($(echo $c))
                        printf "\n${c:0:12}:\n"
                        echo "-------------"
                        echo  -n ${c:13}
                        continue
                fi
                if [[ $cnt -lt $((${#splitIFS[@]}))  ]]; then
                        printf "\n$c "
                fi
                cnt=$((cnt+1))
        done
        echo ""
        IFS=''
        exit 0
}
##########################################################################
_list_repo(){
        cnt=0
        IFS=',' read -ra splitIFS<<<${RESULTS[@]}
        #echo ${#splitIFS[@]}   # Checking array count
        for c in ${splitIFS[@]};
        do
                if [[ $cnt -lt 1 ]]; then
                        printf "\n${c:0:5}${c:5}\n"
                fi
                if [ $cnt -gt 0 ] && [ $cnt -lt $((${#splitIFS[@]} - 1)) ]; then
                        echo -n "$c, "
                elif [ $cnt -eq $((${#splitIFS[@]} -1)) ]; then
                        printf "$c \n" | tr -d ','
                fi
                cnt=$((cnt+1))
        done
        echo ""
        IFS=''
        exit 0

}
##########################################################################
if [[ "$1" =~ ^(--help)$ ]]; then
        printf "\nUsage:  ${0} [REMOTE_REGISTRY_HOST] [REMOTE_ADMIN_ACCOUNT]\n"
        printf "\nDisplay remote private registry. \nCreate an environmental variable for each to bypass setting it manually.\n"
	      printf "\nDefault:\n\tREMOTE_REGISTRY_HOST=$REMOTE_REGISTRY_HOST\n"
	      printf "\n\tREMOTE_ADMIN_ACCOUNT=$REMOTE_ADMIN_ACCOUNT\n"
        printf "\nUsage: ${0} REMOTE_ADMIN_ACCOUNT REMOTE_REGISTRY_HOST [Options]\n"
        printf "\nOptions:\n\t--help	This menu\n"
        printf "\n\t--list - lists contents of your registry\n"
        printf "\n\t--list <some repo name in your registry>\n\n"
	exit 0
fi
if [[ "$2" =~ ^(http://|https://)[a-zA-Z0-9_./]+(.com|.net|.org|.io)?[a-zA-Z0-9_.]$ ]]; then
#       Set remote registtry v2 server IP address or FQDN
	REMOTE_REGISTRY_HOST="$2"
        printf "\n\nREMOTE_REGISTRY_HOST: ${REMOTE_REGISTRY_HOST}\n"
fi
if  [[ "$1" =~ [a-zA-Z0-9]* ]] && [[ ! "$1" =~ ^(--list)$ ]]; then
#       Set remote registry v2 ssh admin account for the above host
	REMOTE_ADMIN_ACCOUNT="$1"
        printf "\\nREMOTE_ADMIN_ACCOUNT: ${REMOTE_ADMIN_ACCOUNT}\n"
fi
##
if [[ "$1" =~ ^(--list)$ ]] || [[ "$3" =~ ^(--list)$ ]] ; then
        if [[ "$1" =~ ^(--list)$ ]] && [ -z $2 ]; then
        RESULTS=($(curl -X GET --user ${REMOTE_ADMIN_ACCOUNT}:${REGISTRY_PASS} ${REMOTE_REGISTRY_HOST}/v2/_catalog 2>/dev/null))
        RESULTS=($(echo ${RESULTS} | tr -d '{' | tr -d '}' | tr -d '[' | tr -d ']' | tr -d '\"'))
        _list ${RESULTS[@]}
        elif [[ "$1" =~ ^(--list)$ ]] && [ ! -z $2 ]; then
        RESULTS=($(curl -X GET --user ${REMOTE_ADMIN_ACCOUNT}:${REGISTRY_PASS} ${REMOTE_REGISTRY_HOST}/v2/${2}/tags/list 2>/dev/null))
        RESULTS=($(echo ${RESULTS} | tr -d '{' | tr -d '}' | tr -d '[' | tr -d ']' | tr -d '\"'))
        _list_repo ${RESULTS[@]}
        elif [[ "$3" =~ ^(--list)$ ]] && [ ! -z $4 ]; then
        RESULTS=($(curl -X GET --user ${REMOTE_ADMIN_ACCOUNT}:${REGISTRY_PASS} ${REMOTE_REGISTRY_HOST}/v2/${4}/tags/list 2>/dev/null))
        RESULTS=($(echo ${RESULTS} | tr -d '{' | tr -d '}' | tr -d '[' | tr -d ']' | tr -d '\"'))
        _list_repo ${RESULTS[@]}
        elif [[ "$3" =~ ^(--list)$ ]] && [ -z $4 ]; then
        RESULTS=($(curl -X GET --user ${REMOTE_ADMIN_ACCOUNT}:${REGISTRY_PASS} ${REMOTE_REGISTRY_HOST}/v2/_catalog 2>/dev/null))
        RESULTS=($(echo ${RESULTS} | tr -d '{' | tr -d '}' | tr -d '[' | tr -d ']' | tr -d '\"'))
        _list ${RESULTS[@]}
        fi
fi
printf "\nUsage: ${0} --help\n"
