#!/usr/bin/env bash
set -e
#################################################
# PARAMETER:    1=>[OPTIONS], 
#               2=>[source filename],
#               3=>[destination folder PATH]
OPTIONS=${1:-""}
SOURCE_REGEX=${2:-""}
DEST_REGEX=${3:-""}
# DEST_REGEX=${3:-"$(echo ${3} | tr -d '\.' | cut -d '/' -f-))"}
#################################################
HELP="""
Usage: ${0} [OPTIONS]... [FILE REGEX]... [DEST PATH] \n
Moves all FILE(s) that matches the source file name \n
    regex and moves them to the destionation folder \n
    or PATH. \n

With no OPTIONS, or REGEX prints help message. \n

    -R, --recursive,        check for files recursively \n
    -h, --help              prints help message \n
"""
#################################################
test_regex(){
    for INPUT in ${@}; 
    do
        case "${INPUT}" in 
            "-R")
                OPTIONS="true"
                ;;
            "--help")
                printf "${HELP}"
                ;;
            *)
                ;;
        esac
    done;
}
#################################################
mvfs_folder(){
if [ ${#} -le 0 ]; then
    printf "${HELP}"
    exit 1
elif [ ${#} -lt 4 ]; then
        test_regex  "${@}"
        # echo "${OPTIONS}"
        if [ -f "${SOURCE_REGEX}" ]; then
            ls "${SOURCE_REGEX}" | while read file
            do
                FILE_LIST=$(ls "${file}" | grep -Ei "(${SOURCE_REGEX})");
                for _f in ${FILE_LIST};
                do 
                    mv  ${_f} ${DEST_REGEX}
                done
            done
            exit 0
            
        fi
fi
}
#################################################
# run function  move file to folder
mvfs_folder ${@}