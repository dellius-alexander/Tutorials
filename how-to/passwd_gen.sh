#!/usr/bin/env bash
###########################################################
# Generate a mixed case password using this script
###########################################################

if [ ${#@} -ne 1 ]; then
    printf "Only one parameter required...\n./${0} <password>"
    exit 1
fi

uppers="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
lowers="abcdefghijklmnopqrstuvwxyz"
echo $1
#exit 0
word=${1}
length=${#1}
password=""
re='^[0-9]+$'
letter=""

for ((i=0; i<$length; i++))
do
## printf "${word:i:1}\n"
    if [[ ${word:i:1} =~ ${re} ]]; then
#	echo "Found number ${word:i:1}"
        password="${password}${word:i:1}"
    else
        case $(( $RANDOM % 2 )) in
           0 ) letter=$(echo ${word:i:1} | tr [a-z] [A-Z]) ;;  # uppercase the character
           1 ) letter=$(echo ${word:i:1} | tr [A-Z] [a-z]) ;;  # lowercase the character
        esac
        password="${password}$letter"
    fi
done
echo  ${password}
exit 0
