#!/usr/bin/env bash
################################################################
URL_REGEX='@^(https?|ftp)://[^\s/$.?#].[^\s]*$@iS'

if [[ ${1} ~= ${URL_REGEX} ]]; then
    wget \
        --recursive \
        --no-clobber \
        --page-requisites \
        --html-extension \
        --convert-links \
        --restrict-file-names=windows \
        --domains website.org \
        --no-parent \
        ${1}
else
    printf "Invalid URL: ${1}"
fi